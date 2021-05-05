
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 80 10 00       	mov    $0x108000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 20 c6 10 80       	mov    $0x8010c620,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 97 2a 10 80       	mov    $0x80102a97,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 20 c6 10 80       	push   $0x8010c620
80100046:	e8 9d 3b 00 00       	call   80103be8 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 70 0d 11 80    	mov    0x80110d70,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
8010005f:	74 30                	je     80100091 <bget+0x5d>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	83 c0 01             	add    $0x1,%eax
80100071:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100074:	83 ec 0c             	sub    $0xc,%esp
80100077:	68 20 c6 10 80       	push   $0x8010c620
8010007c:	e8 cc 3b 00 00       	call   80103c4d <release>
      acquiresleep(&b->lock);
80100081:	8d 43 0c             	lea    0xc(%ebx),%eax
80100084:	89 04 24             	mov    %eax,(%esp)
80100087:	e8 6f 39 00 00       	call   801039fb <acquiresleep>
      return b;
8010008c:	83 c4 10             	add    $0x10,%esp
8010008f:	eb 4c                	jmp    801000dd <bget+0xa9>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100091:	8b 1d 6c 0d 11 80    	mov    0x80110d6c,%ebx
80100097:	eb 03                	jmp    8010009c <bget+0x68>
80100099:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009c:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
801000a2:	74 43                	je     801000e7 <bget+0xb3>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a4:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a8:	75 ef                	jne    80100099 <bget+0x65>
801000aa:	f6 03 04             	testb  $0x4,(%ebx)
801000ad:	75 ea                	jne    80100099 <bget+0x65>
      b->dev = dev;
801000af:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b2:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000bb:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c2:	83 ec 0c             	sub    $0xc,%esp
801000c5:	68 20 c6 10 80       	push   $0x8010c620
801000ca:	e8 7e 3b 00 00       	call   80103c4d <release>
      acquiresleep(&b->lock);
801000cf:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d2:	89 04 24             	mov    %eax,(%esp)
801000d5:	e8 21 39 00 00       	call   801039fb <acquiresleep>
      return b;
801000da:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000dd:	89 d8                	mov    %ebx,%eax
801000df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e2:	5b                   	pop    %ebx
801000e3:	5e                   	pop    %esi
801000e4:	5f                   	pop    %edi
801000e5:	5d                   	pop    %ebp
801000e6:	c3                   	ret    
  panic("bget: no buffers");
801000e7:	83 ec 0c             	sub    $0xc,%esp
801000ea:	68 60 64 10 80       	push   $0x80106460
801000ef:	e8 54 02 00 00       	call   80100348 <panic>

801000f4 <binit>:
{
801000f4:	55                   	push   %ebp
801000f5:	89 e5                	mov    %esp,%ebp
801000f7:	53                   	push   %ebx
801000f8:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000fb:	68 71 64 10 80       	push   $0x80106471
80100100:	68 20 c6 10 80       	push   $0x8010c620
80100105:	e8 a2 39 00 00       	call   80103aac <initlock>
  bcache.head.prev = &bcache.head;
8010010a:	c7 05 6c 0d 11 80 1c 	movl   $0x80110d1c,0x80110d6c
80100111:	0d 11 80 
  bcache.head.next = &bcache.head;
80100114:	c7 05 70 0d 11 80 1c 	movl   $0x80110d1c,0x80110d70
8010011b:	0d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010011e:	83 c4 10             	add    $0x10,%esp
80100121:	bb 54 c6 10 80       	mov    $0x8010c654,%ebx
80100126:	eb 37                	jmp    8010015f <binit+0x6b>
    b->next = bcache.head.next;
80100128:	a1 70 0d 11 80       	mov    0x80110d70,%eax
8010012d:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100130:	c7 43 50 1c 0d 11 80 	movl   $0x80110d1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100137:	83 ec 08             	sub    $0x8,%esp
8010013a:	68 78 64 10 80       	push   $0x80106478
8010013f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100142:	50                   	push   %eax
80100143:	e8 80 38 00 00       	call   801039c8 <initsleeplock>
    bcache.head.next->prev = b;
80100148:	a1 70 0d 11 80       	mov    0x80110d70,%eax
8010014d:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100150:	89 1d 70 0d 11 80    	mov    %ebx,0x80110d70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100156:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010015c:	83 c4 10             	add    $0x10,%esp
8010015f:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
80100165:	72 c1                	jb     80100128 <binit+0x34>
}
80100167:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010016a:	c9                   	leave  
8010016b:	c3                   	ret    

8010016c <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
8010016c:	55                   	push   %ebp
8010016d:	89 e5                	mov    %esp,%ebp
8010016f:	53                   	push   %ebx
80100170:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100173:	8b 55 0c             	mov    0xc(%ebp),%edx
80100176:	8b 45 08             	mov    0x8(%ebp),%eax
80100179:	e8 b6 fe ff ff       	call   80100034 <bget>
8010017e:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
80100180:	f6 00 02             	testb  $0x2,(%eax)
80100183:	74 07                	je     8010018c <bread+0x20>
    iderw(b);
  }
  return b;
}
80100185:	89 d8                	mov    %ebx,%eax
80100187:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010018a:	c9                   	leave  
8010018b:	c3                   	ret    
    iderw(b);
8010018c:	83 ec 0c             	sub    $0xc,%esp
8010018f:	50                   	push   %eax
80100190:	e8 aa 1c 00 00       	call   80101e3f <iderw>
80100195:	83 c4 10             	add    $0x10,%esp
  return b;
80100198:	eb eb                	jmp    80100185 <bread+0x19>

8010019a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
8010019a:	55                   	push   %ebp
8010019b:	89 e5                	mov    %esp,%ebp
8010019d:	53                   	push   %ebx
8010019e:	83 ec 10             	sub    $0x10,%esp
801001a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001a4:	8d 43 0c             	lea    0xc(%ebx),%eax
801001a7:	50                   	push   %eax
801001a8:	e8 d8 38 00 00       	call   80103a85 <holdingsleep>
801001ad:	83 c4 10             	add    $0x10,%esp
801001b0:	85 c0                	test   %eax,%eax
801001b2:	74 14                	je     801001c8 <bwrite+0x2e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b4:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001b7:	83 ec 0c             	sub    $0xc,%esp
801001ba:	53                   	push   %ebx
801001bb:	e8 7f 1c 00 00       	call   80101e3f <iderw>
}
801001c0:	83 c4 10             	add    $0x10,%esp
801001c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c6:	c9                   	leave  
801001c7:	c3                   	ret    
    panic("bwrite");
801001c8:	83 ec 0c             	sub    $0xc,%esp
801001cb:	68 7f 64 10 80       	push   $0x8010647f
801001d0:	e8 73 01 00 00       	call   80100348 <panic>

801001d5 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001d5:	55                   	push   %ebp
801001d6:	89 e5                	mov    %esp,%ebp
801001d8:	56                   	push   %esi
801001d9:	53                   	push   %ebx
801001da:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001dd:	8d 73 0c             	lea    0xc(%ebx),%esi
801001e0:	83 ec 0c             	sub    $0xc,%esp
801001e3:	56                   	push   %esi
801001e4:	e8 9c 38 00 00       	call   80103a85 <holdingsleep>
801001e9:	83 c4 10             	add    $0x10,%esp
801001ec:	85 c0                	test   %eax,%eax
801001ee:	74 6b                	je     8010025b <brelse+0x86>
    panic("brelse");

  releasesleep(&b->lock);
801001f0:	83 ec 0c             	sub    $0xc,%esp
801001f3:	56                   	push   %esi
801001f4:	e8 51 38 00 00       	call   80103a4a <releasesleep>

  acquire(&bcache.lock);
801001f9:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80100200:	e8 e3 39 00 00       	call   80103be8 <acquire>
  b->refcnt--;
80100205:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100208:	83 e8 01             	sub    $0x1,%eax
8010020b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010020e:	83 c4 10             	add    $0x10,%esp
80100211:	85 c0                	test   %eax,%eax
80100213:	75 2f                	jne    80100244 <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100215:	8b 43 54             	mov    0x54(%ebx),%eax
80100218:	8b 53 50             	mov    0x50(%ebx),%edx
8010021b:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021e:	8b 43 50             	mov    0x50(%ebx),%eax
80100221:	8b 53 54             	mov    0x54(%ebx),%edx
80100224:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100227:	a1 70 0d 11 80       	mov    0x80110d70,%eax
8010022c:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010022f:	c7 43 50 1c 0d 11 80 	movl   $0x80110d1c,0x50(%ebx)
    bcache.head.next->prev = b;
80100236:	a1 70 0d 11 80       	mov    0x80110d70,%eax
8010023b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023e:	89 1d 70 0d 11 80    	mov    %ebx,0x80110d70
  }
  
  release(&bcache.lock);
80100244:	83 ec 0c             	sub    $0xc,%esp
80100247:	68 20 c6 10 80       	push   $0x8010c620
8010024c:	e8 fc 39 00 00       	call   80103c4d <release>
}
80100251:	83 c4 10             	add    $0x10,%esp
80100254:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100257:	5b                   	pop    %ebx
80100258:	5e                   	pop    %esi
80100259:	5d                   	pop    %ebp
8010025a:	c3                   	ret    
    panic("brelse");
8010025b:	83 ec 0c             	sub    $0xc,%esp
8010025e:	68 86 64 10 80       	push   $0x80106486
80100263:	e8 e0 00 00 00       	call   80100348 <panic>

80100268 <consoleread>:
#endif
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100268:	55                   	push   %ebp
80100269:	89 e5                	mov    %esp,%ebp
8010026b:	57                   	push   %edi
8010026c:	56                   	push   %esi
8010026d:	53                   	push   %ebx
8010026e:	83 ec 28             	sub    $0x28,%esp
80100271:	8b 7d 08             	mov    0x8(%ebp),%edi
80100274:	8b 75 0c             	mov    0xc(%ebp),%esi
80100277:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010027a:	57                   	push   %edi
8010027b:	e8 f6 13 00 00       	call   80101676 <iunlock>
  target = n;
80100280:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100283:	c7 04 24 20 95 10 80 	movl   $0x80109520,(%esp)
8010028a:	e8 59 39 00 00       	call   80103be8 <acquire>
  while(n > 0){
8010028f:	83 c4 10             	add    $0x10,%esp
80100292:	85 db                	test   %ebx,%ebx
80100294:	0f 8e 8f 00 00 00    	jle    80100329 <consoleread+0xc1>
    while(input.r == input.w){
8010029a:	a1 00 10 11 80       	mov    0x80111000,%eax
8010029f:	3b 05 04 10 11 80    	cmp    0x80111004,%eax
801002a5:	75 47                	jne    801002ee <consoleread+0x86>
      if(myproc()->killed){
801002a7:	e8 95 2f 00 00       	call   80103241 <myproc>
801002ac:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002b0:	75 17                	jne    801002c9 <consoleread+0x61>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b2:	83 ec 08             	sub    $0x8,%esp
801002b5:	68 20 95 10 80       	push   $0x80109520
801002ba:	68 00 10 11 80       	push   $0x80111000
801002bf:	e8 44 34 00 00       	call   80103708 <sleep>
801002c4:	83 c4 10             	add    $0x10,%esp
801002c7:	eb d1                	jmp    8010029a <consoleread+0x32>
        release(&cons.lock);
801002c9:	83 ec 0c             	sub    $0xc,%esp
801002cc:	68 20 95 10 80       	push   $0x80109520
801002d1:	e8 77 39 00 00       	call   80103c4d <release>
        ilock(ip);
801002d6:	89 3c 24             	mov    %edi,(%esp)
801002d9:	e8 d6 12 00 00       	call   801015b4 <ilock>
        return -1;
801002de:	83 c4 10             	add    $0x10,%esp
801002e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002e9:	5b                   	pop    %ebx
801002ea:	5e                   	pop    %esi
801002eb:	5f                   	pop    %edi
801002ec:	5d                   	pop    %ebp
801002ed:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
801002ee:	8d 50 01             	lea    0x1(%eax),%edx
801002f1:	89 15 00 10 11 80    	mov    %edx,0x80111000
801002f7:	89 c2                	mov    %eax,%edx
801002f9:	83 e2 7f             	and    $0x7f,%edx
801002fc:	0f b6 8a 80 0f 11 80 	movzbl -0x7feef080(%edx),%ecx
80100303:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
80100306:	83 fa 04             	cmp    $0x4,%edx
80100309:	74 14                	je     8010031f <consoleread+0xb7>
    *dst++ = c;
8010030b:	8d 46 01             	lea    0x1(%esi),%eax
8010030e:	88 0e                	mov    %cl,(%esi)
    --n;
80100310:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100313:	83 fa 0a             	cmp    $0xa,%edx
80100316:	74 11                	je     80100329 <consoleread+0xc1>
    *dst++ = c;
80100318:	89 c6                	mov    %eax,%esi
8010031a:	e9 73 ff ff ff       	jmp    80100292 <consoleread+0x2a>
      if(n < target){
8010031f:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100322:	73 05                	jae    80100329 <consoleread+0xc1>
        input.r--;
80100324:	a3 00 10 11 80       	mov    %eax,0x80111000
  release(&cons.lock);
80100329:	83 ec 0c             	sub    $0xc,%esp
8010032c:	68 20 95 10 80       	push   $0x80109520
80100331:	e8 17 39 00 00       	call   80103c4d <release>
  ilock(ip);
80100336:	89 3c 24             	mov    %edi,(%esp)
80100339:	e8 76 12 00 00       	call   801015b4 <ilock>
  return target - n;
8010033e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100341:	29 d8                	sub    %ebx,%eax
80100343:	83 c4 10             	add    $0x10,%esp
80100346:	eb 9e                	jmp    801002e6 <consoleread+0x7e>

80100348 <panic>:
{
80100348:	55                   	push   %ebp
80100349:	89 e5                	mov    %esp,%ebp
8010034b:	53                   	push   %ebx
8010034c:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010034f:	fa                   	cli    
  cons.locking = 0;
80100350:	c7 05 54 95 10 80 00 	movl   $0x0,0x80109554
80100357:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
8010035a:	e8 52 20 00 00       	call   801023b1 <lapicid>
8010035f:	83 ec 08             	sub    $0x8,%esp
80100362:	50                   	push   %eax
80100363:	68 8d 64 10 80       	push   $0x8010648d
80100368:	e8 9e 02 00 00       	call   8010060b <cprintf>
  cprintf(s);
8010036d:	83 c4 04             	add    $0x4,%esp
80100370:	ff 75 08             	pushl  0x8(%ebp)
80100373:	e8 93 02 00 00       	call   8010060b <cprintf>
  cprintf("\n");
80100378:	c7 04 24 b7 6d 10 80 	movl   $0x80106db7,(%esp)
8010037f:	e8 87 02 00 00       	call   8010060b <cprintf>
  getcallerpcs(&s, pcs);
80100384:	83 c4 08             	add    $0x8,%esp
80100387:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010038a:	50                   	push   %eax
8010038b:	8d 45 08             	lea    0x8(%ebp),%eax
8010038e:	50                   	push   %eax
8010038f:	e8 33 37 00 00       	call   80103ac7 <getcallerpcs>
  for(i=0; i<10; i++)
80100394:	83 c4 10             	add    $0x10,%esp
80100397:	bb 00 00 00 00       	mov    $0x0,%ebx
8010039c:	eb 17                	jmp    801003b5 <panic+0x6d>
    cprintf(" %p", pcs[i]);
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	ff 74 9d d0          	pushl  -0x30(%ebp,%ebx,4)
801003a5:	68 a1 64 10 80       	push   $0x801064a1
801003aa:	e8 5c 02 00 00       	call   8010060b <cprintf>
  for(i=0; i<10; i++)
801003af:	83 c3 01             	add    $0x1,%ebx
801003b2:	83 c4 10             	add    $0x10,%esp
801003b5:	83 fb 09             	cmp    $0x9,%ebx
801003b8:	7e e4                	jle    8010039e <panic+0x56>
  panicked = 1; // freeze other CPU
801003ba:	c7 05 58 95 10 80 01 	movl   $0x1,0x80109558
801003c1:	00 00 00 
801003c4:	eb fe                	jmp    801003c4 <panic+0x7c>

801003c6 <cgaputc>:
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	57                   	push   %edi
801003ca:	56                   	push   %esi
801003cb:	53                   	push   %ebx
801003cc:	83 ec 0c             	sub    $0xc,%esp
801003cf:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003d1:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
801003d6:	b8 0e 00 00 00       	mov    $0xe,%eax
801003db:	89 ca                	mov    %ecx,%edx
801003dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003de:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003e3:	89 da                	mov    %ebx,%edx
801003e5:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003e6:	0f b6 f8             	movzbl %al,%edi
801003e9:	c1 e7 08             	shl    $0x8,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003ec:	b8 0f 00 00 00       	mov    $0xf,%eax
801003f1:	89 ca                	mov    %ecx,%edx
801003f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f4:	89 da                	mov    %ebx,%edx
801003f6:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801003f7:	0f b6 c8             	movzbl %al,%ecx
801003fa:	09 f9                	or     %edi,%ecx
  if(c == '\n')
801003fc:	83 fe 0a             	cmp    $0xa,%esi
801003ff:	74 6a                	je     8010046b <cgaputc+0xa5>
  else if(c == BACKSPACE){
80100401:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100407:	0f 84 81 00 00 00    	je     8010048e <cgaputc+0xc8>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010040d:	89 f0                	mov    %esi,%eax
8010040f:	0f b6 f0             	movzbl %al,%esi
80100412:	8d 59 01             	lea    0x1(%ecx),%ebx
80100415:	66 81 ce 00 07       	or     $0x700,%si
8010041a:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
80100421:	80 
  if(pos < 0 || pos > 25*80)
80100422:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100428:	77 71                	ja     8010049b <cgaputc+0xd5>
  if((pos/80) >= 24){  // Scroll up.
8010042a:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100430:	7f 76                	jg     801004a8 <cgaputc+0xe2>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	be d4 03 00 00       	mov    $0x3d4,%esi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 f2                	mov    %esi,%edx
8010043e:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
8010043f:	89 d8                	mov    %ebx,%eax
80100441:	c1 f8 08             	sar    $0x8,%eax
80100444:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100449:	89 ca                	mov    %ecx,%edx
8010044b:	ee                   	out    %al,(%dx)
8010044c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100451:	89 f2                	mov    %esi,%edx
80100453:	ee                   	out    %al,(%dx)
80100454:	89 d8                	mov    %ebx,%eax
80100456:	89 ca                	mov    %ecx,%edx
80100458:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100459:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100460:	80 20 07 
}
80100463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100466:	5b                   	pop    %ebx
80100467:	5e                   	pop    %esi
80100468:	5f                   	pop    %edi
80100469:	5d                   	pop    %ebp
8010046a:	c3                   	ret    
    pos += 80 - pos%80;
8010046b:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100470:	89 c8                	mov    %ecx,%eax
80100472:	f7 ea                	imul   %edx
80100474:	c1 fa 05             	sar    $0x5,%edx
80100477:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010047a:	89 d0                	mov    %edx,%eax
8010047c:	c1 e0 04             	shl    $0x4,%eax
8010047f:	89 ca                	mov    %ecx,%edx
80100481:	29 c2                	sub    %eax,%edx
80100483:	bb 50 00 00 00       	mov    $0x50,%ebx
80100488:	29 d3                	sub    %edx,%ebx
8010048a:	01 cb                	add    %ecx,%ebx
8010048c:	eb 94                	jmp    80100422 <cgaputc+0x5c>
    if(pos > 0) --pos;
8010048e:	85 c9                	test   %ecx,%ecx
80100490:	7e 05                	jle    80100497 <cgaputc+0xd1>
80100492:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100495:	eb 8b                	jmp    80100422 <cgaputc+0x5c>
  pos |= inb(CRTPORT+1);
80100497:	89 cb                	mov    %ecx,%ebx
80100499:	eb 87                	jmp    80100422 <cgaputc+0x5c>
    panic("pos under/overflow");
8010049b:	83 ec 0c             	sub    $0xc,%esp
8010049e:	68 a5 64 10 80       	push   $0x801064a5
801004a3:	e8 a0 fe ff ff       	call   80100348 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004a8:	83 ec 04             	sub    $0x4,%esp
801004ab:	68 60 0e 00 00       	push   $0xe60
801004b0:	68 a0 80 0b 80       	push   $0x800b80a0
801004b5:	68 00 80 0b 80       	push   $0x800b8000
801004ba:	e8 50 38 00 00       	call   80103d0f <memmove>
    pos -= 80;
801004bf:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004c2:	b8 80 07 00 00       	mov    $0x780,%eax
801004c7:	29 d8                	sub    %ebx,%eax
801004c9:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004d0:	83 c4 0c             	add    $0xc,%esp
801004d3:	01 c0                	add    %eax,%eax
801004d5:	50                   	push   %eax
801004d6:	6a 00                	push   $0x0
801004d8:	52                   	push   %edx
801004d9:	e8 b6 37 00 00       	call   80103c94 <memset>
801004de:	83 c4 10             	add    $0x10,%esp
801004e1:	e9 4c ff ff ff       	jmp    80100432 <cgaputc+0x6c>

801004e6 <consputc>:
  if(panicked){
801004e6:	83 3d 58 95 10 80 00 	cmpl   $0x0,0x80109558
801004ed:	74 03                	je     801004f2 <consputc+0xc>
  asm volatile("cli");
801004ef:	fa                   	cli    
801004f0:	eb fe                	jmp    801004f0 <consputc+0xa>
{
801004f2:	55                   	push   %ebp
801004f3:	89 e5                	mov    %esp,%ebp
801004f5:	53                   	push   %ebx
801004f6:	83 ec 04             	sub    $0x4,%esp
801004f9:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
801004fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100500:	74 18                	je     8010051a <consputc+0x34>
    uartputc(c);
80100502:	83 ec 0c             	sub    $0xc,%esp
80100505:	50                   	push   %eax
80100506:	e8 37 4b 00 00       	call   80105042 <uartputc>
8010050b:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
8010050e:	89 d8                	mov    %ebx,%eax
80100510:	e8 b1 fe ff ff       	call   801003c6 <cgaputc>
}
80100515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100518:	c9                   	leave  
80100519:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010051a:	83 ec 0c             	sub    $0xc,%esp
8010051d:	6a 08                	push   $0x8
8010051f:	e8 1e 4b 00 00       	call   80105042 <uartputc>
80100524:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010052b:	e8 12 4b 00 00       	call   80105042 <uartputc>
80100530:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100537:	e8 06 4b 00 00       	call   80105042 <uartputc>
8010053c:	83 c4 10             	add    $0x10,%esp
8010053f:	eb cd                	jmp    8010050e <consputc+0x28>

80100541 <printint>:
{
80100541:	55                   	push   %ebp
80100542:	89 e5                	mov    %esp,%ebp
80100544:	57                   	push   %edi
80100545:	56                   	push   %esi
80100546:	53                   	push   %ebx
80100547:	83 ec 1c             	sub    $0x1c,%esp
8010054a:	89 d7                	mov    %edx,%edi
  if(sign && (sign = xx < 0))
8010054c:	85 c9                	test   %ecx,%ecx
8010054e:	74 09                	je     80100559 <printint+0x18>
80100550:	89 c1                	mov    %eax,%ecx
80100552:	c1 e9 1f             	shr    $0x1f,%ecx
80100555:	85 c0                	test   %eax,%eax
80100557:	78 09                	js     80100562 <printint+0x21>
    x = xx;
80100559:	89 c2                	mov    %eax,%edx
  i = 0;
8010055b:	be 00 00 00 00       	mov    $0x0,%esi
80100560:	eb 08                	jmp    8010056a <printint+0x29>
    x = -xx;
80100562:	f7 d8                	neg    %eax
80100564:	89 c2                	mov    %eax,%edx
80100566:	eb f3                	jmp    8010055b <printint+0x1a>
    buf[i++] = digits[x % base];
80100568:	89 de                	mov    %ebx,%esi
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	ba 00 00 00 00       	mov    $0x0,%edx
80100571:	f7 f7                	div    %edi
80100573:	8d 5e 01             	lea    0x1(%esi),%ebx
80100576:	0f b6 92 e4 64 10 80 	movzbl -0x7fef9b1c(%edx),%edx
8010057d:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
80100581:	89 c2                	mov    %eax,%edx
80100583:	85 c0                	test   %eax,%eax
80100585:	75 e1                	jne    80100568 <printint+0x27>
  if(sign)
80100587:	85 c9                	test   %ecx,%ecx
80100589:	74 14                	je     8010059f <printint+0x5e>
    buf[i++] = '-';
8010058b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100590:	8d 5e 02             	lea    0x2(%esi),%ebx
80100593:	eb 0a                	jmp    8010059f <printint+0x5e>
    consputc(buf[i]);
80100595:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
8010059a:	e8 47 ff ff ff       	call   801004e6 <consputc>
  while(--i >= 0)
8010059f:	83 eb 01             	sub    $0x1,%ebx
801005a2:	79 f1                	jns    80100595 <printint+0x54>
}
801005a4:	83 c4 1c             	add    $0x1c,%esp
801005a7:	5b                   	pop    %ebx
801005a8:	5e                   	pop    %esi
801005a9:	5f                   	pop    %edi
801005aa:	5d                   	pop    %ebp
801005ab:	c3                   	ret    

801005ac <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005ac:	55                   	push   %ebp
801005ad:	89 e5                	mov    %esp,%ebp
801005af:	57                   	push   %edi
801005b0:	56                   	push   %esi
801005b1:	53                   	push   %ebx
801005b2:	83 ec 18             	sub    $0x18,%esp
801005b5:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005b8:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bb:	ff 75 08             	pushl  0x8(%ebp)
801005be:	e8 b3 10 00 00       	call   80101676 <iunlock>
  acquire(&cons.lock);
801005c3:	c7 04 24 20 95 10 80 	movl   $0x80109520,(%esp)
801005ca:	e8 19 36 00 00       	call   80103be8 <acquire>
  for(i = 0; i < n; i++)
801005cf:	83 c4 10             	add    $0x10,%esp
801005d2:	bb 00 00 00 00       	mov    $0x0,%ebx
801005d7:	eb 0c                	jmp    801005e5 <consolewrite+0x39>
    consputc(buf[i] & 0xff);
801005d9:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005dd:	e8 04 ff ff ff       	call   801004e6 <consputc>
  for(i = 0; i < n; i++)
801005e2:	83 c3 01             	add    $0x1,%ebx
801005e5:	39 f3                	cmp    %esi,%ebx
801005e7:	7c f0                	jl     801005d9 <consolewrite+0x2d>
  release(&cons.lock);
801005e9:	83 ec 0c             	sub    $0xc,%esp
801005ec:	68 20 95 10 80       	push   $0x80109520
801005f1:	e8 57 36 00 00       	call   80103c4d <release>
  ilock(ip);
801005f6:	83 c4 04             	add    $0x4,%esp
801005f9:	ff 75 08             	pushl  0x8(%ebp)
801005fc:	e8 b3 0f 00 00       	call   801015b4 <ilock>

  return n;
}
80100601:	89 f0                	mov    %esi,%eax
80100603:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100606:	5b                   	pop    %ebx
80100607:	5e                   	pop    %esi
80100608:	5f                   	pop    %edi
80100609:	5d                   	pop    %ebp
8010060a:	c3                   	ret    

8010060b <cprintf>:
{
8010060b:	55                   	push   %ebp
8010060c:	89 e5                	mov    %esp,%ebp
8010060e:	57                   	push   %edi
8010060f:	56                   	push   %esi
80100610:	53                   	push   %ebx
80100611:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100614:	a1 54 95 10 80       	mov    0x80109554,%eax
80100619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
8010061c:	85 c0                	test   %eax,%eax
8010061e:	75 10                	jne    80100630 <cprintf+0x25>
  if (fmt == 0)
80100620:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80100624:	74 1c                	je     80100642 <cprintf+0x37>
  argp = (uint*)(void*)(&fmt + 1);
80100626:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100629:	bb 00 00 00 00       	mov    $0x0,%ebx
8010062e:	eb 27                	jmp    80100657 <cprintf+0x4c>
    acquire(&cons.lock);
80100630:	83 ec 0c             	sub    $0xc,%esp
80100633:	68 20 95 10 80       	push   $0x80109520
80100638:	e8 ab 35 00 00       	call   80103be8 <acquire>
8010063d:	83 c4 10             	add    $0x10,%esp
80100640:	eb de                	jmp    80100620 <cprintf+0x15>
    panic("null fmt");
80100642:	83 ec 0c             	sub    $0xc,%esp
80100645:	68 bf 64 10 80       	push   $0x801064bf
8010064a:	e8 f9 fc ff ff       	call   80100348 <panic>
      consputc(c);
8010064f:	e8 92 fe ff ff       	call   801004e6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100654:	83 c3 01             	add    $0x1,%ebx
80100657:	8b 55 08             	mov    0x8(%ebp),%edx
8010065a:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
8010065e:	85 c0                	test   %eax,%eax
80100660:	0f 84 b8 00 00 00    	je     8010071e <cprintf+0x113>
    if(c != '%'){
80100666:	83 f8 25             	cmp    $0x25,%eax
80100669:	75 e4                	jne    8010064f <cprintf+0x44>
    c = fmt[++i] & 0xff;
8010066b:	83 c3 01             	add    $0x1,%ebx
8010066e:	0f b6 34 1a          	movzbl (%edx,%ebx,1),%esi
    if(c == 0)
80100672:	85 f6                	test   %esi,%esi
80100674:	0f 84 a4 00 00 00    	je     8010071e <cprintf+0x113>
    switch(c){
8010067a:	83 fe 70             	cmp    $0x70,%esi
8010067d:	74 48                	je     801006c7 <cprintf+0xbc>
8010067f:	83 fe 70             	cmp    $0x70,%esi
80100682:	7f 26                	jg     801006aa <cprintf+0x9f>
80100684:	83 fe 25             	cmp    $0x25,%esi
80100687:	0f 84 82 00 00 00    	je     8010070f <cprintf+0x104>
8010068d:	83 fe 64             	cmp    $0x64,%esi
80100690:	75 22                	jne    801006b4 <cprintf+0xa9>
      printint(*argp++, 10, 1);
80100692:	8d 77 04             	lea    0x4(%edi),%esi
80100695:	8b 07                	mov    (%edi),%eax
80100697:	b9 01 00 00 00       	mov    $0x1,%ecx
8010069c:	ba 0a 00 00 00       	mov    $0xa,%edx
801006a1:	e8 9b fe ff ff       	call   80100541 <printint>
801006a6:	89 f7                	mov    %esi,%edi
      break;
801006a8:	eb aa                	jmp    80100654 <cprintf+0x49>
    switch(c){
801006aa:	83 fe 73             	cmp    $0x73,%esi
801006ad:	74 33                	je     801006e2 <cprintf+0xd7>
801006af:	83 fe 78             	cmp    $0x78,%esi
801006b2:	74 13                	je     801006c7 <cprintf+0xbc>
      consputc('%');
801006b4:	b8 25 00 00 00       	mov    $0x25,%eax
801006b9:	e8 28 fe ff ff       	call   801004e6 <consputc>
      consputc(c);
801006be:	89 f0                	mov    %esi,%eax
801006c0:	e8 21 fe ff ff       	call   801004e6 <consputc>
      break;
801006c5:	eb 8d                	jmp    80100654 <cprintf+0x49>
      printint(*argp++, 16, 0);
801006c7:	8d 77 04             	lea    0x4(%edi),%esi
801006ca:	8b 07                	mov    (%edi),%eax
801006cc:	b9 00 00 00 00       	mov    $0x0,%ecx
801006d1:	ba 10 00 00 00       	mov    $0x10,%edx
801006d6:	e8 66 fe ff ff       	call   80100541 <printint>
801006db:	89 f7                	mov    %esi,%edi
      break;
801006dd:	e9 72 ff ff ff       	jmp    80100654 <cprintf+0x49>
      if((s = (char*)*argp++) == 0)
801006e2:	8d 47 04             	lea    0x4(%edi),%eax
801006e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801006e8:	8b 37                	mov    (%edi),%esi
801006ea:	85 f6                	test   %esi,%esi
801006ec:	75 12                	jne    80100700 <cprintf+0xf5>
        s = "(null)";
801006ee:	be b8 64 10 80       	mov    $0x801064b8,%esi
801006f3:	eb 0b                	jmp    80100700 <cprintf+0xf5>
        consputc(*s);
801006f5:	0f be c0             	movsbl %al,%eax
801006f8:	e8 e9 fd ff ff       	call   801004e6 <consputc>
      for(; *s; s++)
801006fd:	83 c6 01             	add    $0x1,%esi
80100700:	0f b6 06             	movzbl (%esi),%eax
80100703:	84 c0                	test   %al,%al
80100705:	75 ee                	jne    801006f5 <cprintf+0xea>
      if((s = (char*)*argp++) == 0)
80100707:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010070a:	e9 45 ff ff ff       	jmp    80100654 <cprintf+0x49>
      consputc('%');
8010070f:	b8 25 00 00 00       	mov    $0x25,%eax
80100714:	e8 cd fd ff ff       	call   801004e6 <consputc>
      break;
80100719:	e9 36 ff ff ff       	jmp    80100654 <cprintf+0x49>
  if(locking)
8010071e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100722:	75 08                	jne    8010072c <cprintf+0x121>
}
80100724:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100727:	5b                   	pop    %ebx
80100728:	5e                   	pop    %esi
80100729:	5f                   	pop    %edi
8010072a:	5d                   	pop    %ebp
8010072b:	c3                   	ret    
    release(&cons.lock);
8010072c:	83 ec 0c             	sub    $0xc,%esp
8010072f:	68 20 95 10 80       	push   $0x80109520
80100734:	e8 14 35 00 00       	call   80103c4d <release>
80100739:	83 c4 10             	add    $0x10,%esp
}
8010073c:	eb e6                	jmp    80100724 <cprintf+0x119>

8010073e <do_shutdown>:
{
8010073e:	55                   	push   %ebp
8010073f:	89 e5                	mov    %esp,%ebp
80100741:	83 ec 14             	sub    $0x14,%esp
  cprintf("\nShutting down ...\n");
80100744:	68 c8 64 10 80       	push   $0x801064c8
80100749:	e8 bd fe ff ff       	call   8010060b <cprintf>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010074e:	b8 00 20 00 00       	mov    $0x2000,%eax
80100753:	ba 04 06 00 00       	mov    $0x604,%edx
80100758:	66 ef                	out    %ax,(%dx)
  return;  // not reached
8010075a:	83 c4 10             	add    $0x10,%esp
}
8010075d:	c9                   	leave  
8010075e:	c3                   	ret    

8010075f <consoleintr>:
{
8010075f:	55                   	push   %ebp
80100760:	89 e5                	mov    %esp,%ebp
80100762:	57                   	push   %edi
80100763:	56                   	push   %esi
80100764:	53                   	push   %ebx
80100765:	83 ec 28             	sub    $0x28,%esp
80100768:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
8010076b:	68 20 95 10 80       	push   $0x80109520
80100770:	e8 73 34 00 00       	call   80103be8 <acquire>
  while((c = getc()) >= 0){
80100775:	83 c4 10             	add    $0x10,%esp
  int shutdown = FALSE;
80100778:	bf 00 00 00 00       	mov    $0x0,%edi
  int c, doprocdump = 0;
8010077d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((c = getc()) >= 0){
80100784:	eb 36                	jmp    801007bc <consoleintr+0x5d>
    switch(c){
80100786:	83 fb 15             	cmp    $0x15,%ebx
80100789:	0f 84 d7 00 00 00    	je     80100866 <consoleintr+0x107>
8010078f:	83 fb 7f             	cmp    $0x7f,%ebx
80100792:	75 4c                	jne    801007e0 <consoleintr+0x81>
      if(input.e != input.w){
80100794:	a1 08 10 11 80       	mov    0x80111008,%eax
80100799:	3b 05 04 10 11 80    	cmp    0x80111004,%eax
8010079f:	74 1b                	je     801007bc <consoleintr+0x5d>
        input.e--;
801007a1:	83 e8 01             	sub    $0x1,%eax
801007a4:	a3 08 10 11 80       	mov    %eax,0x80111008
        consputc(BACKSPACE);
801007a9:	b8 00 01 00 00       	mov    $0x100,%eax
801007ae:	e8 33 fd ff ff       	call   801004e6 <consputc>
801007b3:	eb 07                	jmp    801007bc <consoleintr+0x5d>
      doprocdump = 1;
801007b5:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  while((c = getc()) >= 0){
801007bc:	ff d6                	call   *%esi
801007be:	89 c3                	mov    %eax,%ebx
801007c0:	85 c0                	test   %eax,%eax
801007c2:	0f 88 d9 00 00 00    	js     801008a1 <consoleintr+0x142>
    switch(c){
801007c8:	83 fb 10             	cmp    $0x10,%ebx
801007cb:	74 e8                	je     801007b5 <consoleintr+0x56>
801007cd:	83 fb 10             	cmp    $0x10,%ebx
801007d0:	7f b4                	jg     80100786 <consoleintr+0x27>
801007d2:	83 fb 04             	cmp    $0x4,%ebx
801007d5:	0f 84 bc 00 00 00    	je     80100897 <consoleintr+0x138>
801007db:	83 fb 08             	cmp    $0x8,%ebx
801007de:	74 b4                	je     80100794 <consoleintr+0x35>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801007e0:	85 db                	test   %ebx,%ebx
801007e2:	74 d8                	je     801007bc <consoleintr+0x5d>
801007e4:	a1 08 10 11 80       	mov    0x80111008,%eax
801007e9:	89 c2                	mov    %eax,%edx
801007eb:	2b 15 00 10 11 80    	sub    0x80111000,%edx
801007f1:	83 fa 7f             	cmp    $0x7f,%edx
801007f4:	77 c6                	ja     801007bc <consoleintr+0x5d>
        c = (c == '\r') ? '\n' : c;
801007f6:	83 fb 0d             	cmp    $0xd,%ebx
801007f9:	0f 84 8e 00 00 00    	je     8010088d <consoleintr+0x12e>
        input.buf[input.e++ % INPUT_BUF] = c;
801007ff:	8d 50 01             	lea    0x1(%eax),%edx
80100802:	89 15 08 10 11 80    	mov    %edx,0x80111008
80100808:	83 e0 7f             	and    $0x7f,%eax
8010080b:	88 98 80 0f 11 80    	mov    %bl,-0x7feef080(%eax)
        consputc(c);
80100811:	89 d8                	mov    %ebx,%eax
80100813:	e8 ce fc ff ff       	call   801004e6 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100818:	83 fb 0a             	cmp    $0xa,%ebx
8010081b:	0f 94 c2             	sete   %dl
8010081e:	83 fb 04             	cmp    $0x4,%ebx
80100821:	0f 94 c0             	sete   %al
80100824:	08 c2                	or     %al,%dl
80100826:	75 10                	jne    80100838 <consoleintr+0xd9>
80100828:	a1 00 10 11 80       	mov    0x80111000,%eax
8010082d:	83 e8 80             	sub    $0xffffff80,%eax
80100830:	39 05 08 10 11 80    	cmp    %eax,0x80111008
80100836:	75 84                	jne    801007bc <consoleintr+0x5d>
          input.w = input.e;
80100838:	a1 08 10 11 80       	mov    0x80111008,%eax
8010083d:	a3 04 10 11 80       	mov    %eax,0x80111004
          wakeup(&input.r);
80100842:	83 ec 0c             	sub    $0xc,%esp
80100845:	68 00 10 11 80       	push   $0x80111000
8010084a:	e8 1d 30 00 00       	call   8010386c <wakeup>
8010084f:	83 c4 10             	add    $0x10,%esp
80100852:	e9 65 ff ff ff       	jmp    801007bc <consoleintr+0x5d>
        input.e--;
80100857:	a3 08 10 11 80       	mov    %eax,0x80111008
        consputc(BACKSPACE);
8010085c:	b8 00 01 00 00       	mov    $0x100,%eax
80100861:	e8 80 fc ff ff       	call   801004e6 <consputc>
      while(input.e != input.w &&
80100866:	a1 08 10 11 80       	mov    0x80111008,%eax
8010086b:	3b 05 04 10 11 80    	cmp    0x80111004,%eax
80100871:	0f 84 45 ff ff ff    	je     801007bc <consoleintr+0x5d>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100877:	83 e8 01             	sub    $0x1,%eax
8010087a:	89 c2                	mov    %eax,%edx
8010087c:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010087f:	80 ba 80 0f 11 80 0a 	cmpb   $0xa,-0x7feef080(%edx)
80100886:	75 cf                	jne    80100857 <consoleintr+0xf8>
80100888:	e9 2f ff ff ff       	jmp    801007bc <consoleintr+0x5d>
        c = (c == '\r') ? '\n' : c;
8010088d:	bb 0a 00 00 00       	mov    $0xa,%ebx
80100892:	e9 68 ff ff ff       	jmp    801007ff <consoleintr+0xa0>
      shutdown = TRUE;
80100897:	bf 01 00 00 00       	mov    $0x1,%edi
8010089c:	e9 1b ff ff ff       	jmp    801007bc <consoleintr+0x5d>
  release(&cons.lock);
801008a1:	83 ec 0c             	sub    $0xc,%esp
801008a4:	68 20 95 10 80       	push   $0x80109520
801008a9:	e8 9f 33 00 00       	call   80103c4d <release>
  if (shutdown)
801008ae:	83 c4 10             	add    $0x10,%esp
801008b1:	85 ff                	test   %edi,%edi
801008b3:	75 0e                	jne    801008c3 <consoleintr+0x164>
  if(doprocdump) {
801008b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801008b9:	75 0f                	jne    801008ca <consoleintr+0x16b>
}
801008bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008be:	5b                   	pop    %ebx
801008bf:	5e                   	pop    %esi
801008c0:	5f                   	pop    %edi
801008c1:	5d                   	pop    %ebp
801008c2:	c3                   	ret    
    do_shutdown();
801008c3:	e8 76 fe ff ff       	call   8010073e <do_shutdown>
801008c8:	eb eb                	jmp    801008b5 <consoleintr+0x156>
    procdump();  // now call procdump() wo. cons.lock held
801008ca:	e8 3a 30 00 00       	call   80103909 <procdump>
}
801008cf:	eb ea                	jmp    801008bb <consoleintr+0x15c>

801008d1 <consoleinit>:

void
consoleinit(void)
{
801008d1:	55                   	push   %ebp
801008d2:	89 e5                	mov    %esp,%ebp
801008d4:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801008d7:	68 dc 64 10 80       	push   $0x801064dc
801008dc:	68 20 95 10 80       	push   $0x80109520
801008e1:	e8 c6 31 00 00       	call   80103aac <initlock>

  devsw[CONSOLE].write = consolewrite;
801008e6:	c7 05 cc 19 11 80 ac 	movl   $0x801005ac,0x801119cc
801008ed:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801008f0:	c7 05 c8 19 11 80 68 	movl   $0x80100268,0x801119c8
801008f7:	02 10 80 
  cons.locking = 1;
801008fa:	c7 05 54 95 10 80 01 	movl   $0x1,0x80109554
80100901:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100904:	83 c4 08             	add    $0x8,%esp
80100907:	6a 00                	push   $0x0
80100909:	6a 01                	push   $0x1
8010090b:	e8 a1 16 00 00       	call   80101fb1 <ioapicenable>
}
80100910:	83 c4 10             	add    $0x10,%esp
80100913:	c9                   	leave  
80100914:	c3                   	ret    

80100915 <exec>:
#include "elf.h"


int
exec(char *path, char **argv)
{
80100915:	55                   	push   %ebp
80100916:	89 e5                	mov    %esp,%ebp
80100918:	57                   	push   %edi
80100919:	56                   	push   %esi
8010091a:	53                   	push   %ebx
8010091b:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100921:	e8 1b 29 00 00       	call   80103241 <myproc>
80100926:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
8010092c:	e8 b0 1e 00 00       	call   801027e1 <begin_op>

  if((ip = namei(path)) == 0){
80100931:	83 ec 0c             	sub    $0xc,%esp
80100934:	ff 75 08             	pushl  0x8(%ebp)
80100937:	e8 d8 12 00 00       	call   80101c14 <namei>
8010093c:	83 c4 10             	add    $0x10,%esp
8010093f:	85 c0                	test   %eax,%eax
80100941:	74 4a                	je     8010098d <exec+0x78>
80100943:	89 c3                	mov    %eax,%ebx
#ifndef PDX_XV6
    cprintf("exec: fail\n");
#endif
    return -1;
  }
  ilock(ip);
80100945:	83 ec 0c             	sub    $0xc,%esp
80100948:	50                   	push   %eax
80100949:	e8 66 0c 00 00       	call   801015b4 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010094e:	6a 34                	push   $0x34
80100950:	6a 00                	push   $0x0
80100952:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100958:	50                   	push   %eax
80100959:	53                   	push   %ebx
8010095a:	e8 47 0e 00 00       	call   801017a6 <readi>
8010095f:	83 c4 20             	add    $0x20,%esp
80100962:	83 f8 34             	cmp    $0x34,%eax
80100965:	74 32                	je     80100999 <exec+0x84>
  return 0;

bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
80100967:	85 db                	test   %ebx,%ebx
80100969:	0f 84 cd 02 00 00    	je     80100c3c <exec+0x327>
    iunlockput(ip);
8010096f:	83 ec 0c             	sub    $0xc,%esp
80100972:	53                   	push   %ebx
80100973:	e8 e3 0d 00 00       	call   8010175b <iunlockput>
    end_op();
80100978:	e8 de 1e 00 00       	call   8010285b <end_op>
8010097d:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100985:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100988:	5b                   	pop    %ebx
80100989:	5e                   	pop    %esi
8010098a:	5f                   	pop    %edi
8010098b:	5d                   	pop    %ebp
8010098c:	c3                   	ret    
    end_op();
8010098d:	e8 c9 1e 00 00       	call   8010285b <end_op>
    return -1;
80100992:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100997:	eb ec                	jmp    80100985 <exec+0x70>
  if(elf.magic != ELF_MAGIC)
80100999:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801009a0:	45 4c 46 
801009a3:	75 c2                	jne    80100967 <exec+0x52>
  if((pgdir = setupkvm()) == 0)
801009a5:	e8 58 58 00 00       	call   80106202 <setupkvm>
801009aa:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
801009b0:	85 c0                	test   %eax,%eax
801009b2:	0f 84 06 01 00 00    	je     80100abe <exec+0x1a9>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009b8:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
801009be:	bf 00 00 00 00       	mov    $0x0,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009c3:	be 00 00 00 00       	mov    $0x0,%esi
801009c8:	eb 0c                	jmp    801009d6 <exec+0xc1>
801009ca:	83 c6 01             	add    $0x1,%esi
801009cd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
801009d3:	83 c0 20             	add    $0x20,%eax
801009d6:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
801009dd:	39 f2                	cmp    %esi,%edx
801009df:	0f 8e 98 00 00 00    	jle    80100a7d <exec+0x168>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009e5:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009eb:	6a 20                	push   $0x20
801009ed:	50                   	push   %eax
801009ee:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009f4:	50                   	push   %eax
801009f5:	53                   	push   %ebx
801009f6:	e8 ab 0d 00 00       	call   801017a6 <readi>
801009fb:	83 c4 10             	add    $0x10,%esp
801009fe:	83 f8 20             	cmp    $0x20,%eax
80100a01:	0f 85 b7 00 00 00    	jne    80100abe <exec+0x1a9>
    if(ph.type != ELF_PROG_LOAD)
80100a07:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a0e:	75 ba                	jne    801009ca <exec+0xb5>
    if(ph.memsz < ph.filesz)
80100a10:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a16:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a1c:	0f 82 9c 00 00 00    	jb     80100abe <exec+0x1a9>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a22:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a28:	0f 82 90 00 00 00    	jb     80100abe <exec+0x1a9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a2e:	83 ec 04             	sub    $0x4,%esp
80100a31:	50                   	push   %eax
80100a32:	57                   	push   %edi
80100a33:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100a39:	e8 6a 56 00 00       	call   801060a8 <allocuvm>
80100a3e:	89 c7                	mov    %eax,%edi
80100a40:	83 c4 10             	add    $0x10,%esp
80100a43:	85 c0                	test   %eax,%eax
80100a45:	74 77                	je     80100abe <exec+0x1a9>
    if(ph.vaddr % PGSIZE != 0)
80100a47:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a4d:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a52:	75 6a                	jne    80100abe <exec+0x1a9>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a54:	83 ec 0c             	sub    $0xc,%esp
80100a57:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a5d:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a63:	53                   	push   %ebx
80100a64:	50                   	push   %eax
80100a65:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100a6b:	e8 06 55 00 00       	call   80105f76 <loaduvm>
80100a70:	83 c4 20             	add    $0x20,%esp
80100a73:	85 c0                	test   %eax,%eax
80100a75:	0f 89 4f ff ff ff    	jns    801009ca <exec+0xb5>
bad:
80100a7b:	eb 41                	jmp    80100abe <exec+0x1a9>
  iunlockput(ip);
80100a7d:	83 ec 0c             	sub    $0xc,%esp
80100a80:	53                   	push   %ebx
80100a81:	e8 d5 0c 00 00       	call   8010175b <iunlockput>
  end_op();
80100a86:	e8 d0 1d 00 00       	call   8010285b <end_op>
  sz = PGROUNDUP(sz);
80100a8b:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80100a91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a96:	83 c4 0c             	add    $0xc,%esp
80100a99:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a9f:	52                   	push   %edx
80100aa0:	50                   	push   %eax
80100aa1:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100aa7:	e8 fc 55 00 00       	call   801060a8 <allocuvm>
80100aac:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ab2:	83 c4 10             	add    $0x10,%esp
80100ab5:	85 c0                	test   %eax,%eax
80100ab7:	75 24                	jne    80100add <exec+0x1c8>
  ip = 0;
80100ab9:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100abe:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac4:	85 c0                	test   %eax,%eax
80100ac6:	0f 84 9b fe ff ff    	je     80100967 <exec+0x52>
    freevm(pgdir);
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	50                   	push   %eax
80100ad0:	e8 bd 56 00 00       	call   80106192 <freevm>
80100ad5:	83 c4 10             	add    $0x10,%esp
80100ad8:	e9 8a fe ff ff       	jmp    80100967 <exec+0x52>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100add:	89 c7                	mov    %eax,%edi
80100adf:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100ae5:	83 ec 08             	sub    $0x8,%esp
80100ae8:	50                   	push   %eax
80100ae9:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100aef:	e8 93 57 00 00       	call   80106287 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100af4:	83 c4 10             	add    $0x10,%esp
80100af7:	bb 00 00 00 00       	mov    $0x0,%ebx
80100afc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100aff:	8d 34 98             	lea    (%eax,%ebx,4),%esi
80100b02:	8b 06                	mov    (%esi),%eax
80100b04:	85 c0                	test   %eax,%eax
80100b06:	74 4d                	je     80100b55 <exec+0x240>
    if(argc >= MAXARG)
80100b08:	83 fb 1f             	cmp    $0x1f,%ebx
80100b0b:	0f 87 0d 01 00 00    	ja     80100c1e <exec+0x309>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	50                   	push   %eax
80100b15:	e8 1c 33 00 00       	call   80103e36 <strlen>
80100b1a:	29 c7                	sub    %eax,%edi
80100b1c:	83 ef 01             	sub    $0x1,%edi
80100b1f:	83 e7 fc             	and    $0xfffffffc,%edi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b22:	83 c4 04             	add    $0x4,%esp
80100b25:	ff 36                	pushl  (%esi)
80100b27:	e8 0a 33 00 00       	call   80103e36 <strlen>
80100b2c:	83 c0 01             	add    $0x1,%eax
80100b2f:	50                   	push   %eax
80100b30:	ff 36                	pushl  (%esi)
80100b32:	57                   	push   %edi
80100b33:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b39:	e8 8b 58 00 00       	call   801063c9 <copyout>
80100b3e:	83 c4 20             	add    $0x20,%esp
80100b41:	85 c0                	test   %eax,%eax
80100b43:	0f 88 df 00 00 00    	js     80100c28 <exec+0x313>
    ustack[3+argc] = sp;
80100b49:	89 bc 9d 64 ff ff ff 	mov    %edi,-0x9c(%ebp,%ebx,4)
  for(argc = 0; argv[argc]; argc++) {
80100b50:	83 c3 01             	add    $0x1,%ebx
80100b53:	eb a7                	jmp    80100afc <exec+0x1e7>
  ustack[3+argc] = 0;
80100b55:	c7 84 9d 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%ebx,4)
80100b5c:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b60:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b67:	ff ff ff 
  ustack[1] = argc;
80100b6a:	89 9d 5c ff ff ff    	mov    %ebx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b70:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
80100b77:	89 f9                	mov    %edi,%ecx
80100b79:	29 c1                	sub    %eax,%ecx
80100b7b:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b81:	8d 04 9d 10 00 00 00 	lea    0x10(,%ebx,4),%eax
80100b88:	29 c7                	sub    %eax,%edi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b8a:	50                   	push   %eax
80100b8b:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b91:	50                   	push   %eax
80100b92:	57                   	push   %edi
80100b93:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b99:	e8 2b 58 00 00       	call   801063c9 <copyout>
80100b9e:	83 c4 10             	add    $0x10,%esp
80100ba1:	85 c0                	test   %eax,%eax
80100ba3:	0f 88 89 00 00 00    	js     80100c32 <exec+0x31d>
  for(last=s=path; *s; s++)
80100ba9:	8b 55 08             	mov    0x8(%ebp),%edx
80100bac:	89 d0                	mov    %edx,%eax
80100bae:	eb 03                	jmp    80100bb3 <exec+0x29e>
80100bb0:	83 c0 01             	add    $0x1,%eax
80100bb3:	0f b6 08             	movzbl (%eax),%ecx
80100bb6:	84 c9                	test   %cl,%cl
80100bb8:	74 0a                	je     80100bc4 <exec+0x2af>
    if(*s == '/')
80100bba:	80 f9 2f             	cmp    $0x2f,%cl
80100bbd:	75 f1                	jne    80100bb0 <exec+0x29b>
      last = s+1;
80100bbf:	8d 50 01             	lea    0x1(%eax),%edx
80100bc2:	eb ec                	jmp    80100bb0 <exec+0x29b>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100bc4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100bca:	89 f0                	mov    %esi,%eax
80100bcc:	83 c0 6c             	add    $0x6c,%eax
80100bcf:	83 ec 04             	sub    $0x4,%esp
80100bd2:	6a 10                	push   $0x10
80100bd4:	52                   	push   %edx
80100bd5:	50                   	push   %eax
80100bd6:	e8 20 32 00 00       	call   80103dfb <safestrcpy>
  oldpgdir = curproc->pgdir;
80100bdb:	8b 5e 04             	mov    0x4(%esi),%ebx
  curproc->pgdir = pgdir;
80100bde:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100be4:	89 4e 04             	mov    %ecx,0x4(%esi)
  curproc->sz = sz;
80100be7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100bed:	89 0e                	mov    %ecx,(%esi)
  curproc->tf->eip = elf.entry;  // main
80100bef:	8b 46 18             	mov    0x18(%esi),%eax
80100bf2:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100bf8:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100bfb:	8b 46 18             	mov    0x18(%esi),%eax
80100bfe:	89 78 44             	mov    %edi,0x44(%eax)
  switchuvm(curproc);
80100c01:	89 34 24             	mov    %esi,(%esp)
80100c04:	e8 ec 51 00 00       	call   80105df5 <switchuvm>
  freevm(oldpgdir);
80100c09:	89 1c 24             	mov    %ebx,(%esp)
80100c0c:	e8 81 55 00 00       	call   80106192 <freevm>
  return 0;
80100c11:	83 c4 10             	add    $0x10,%esp
80100c14:	b8 00 00 00 00       	mov    $0x0,%eax
80100c19:	e9 67 fd ff ff       	jmp    80100985 <exec+0x70>
  ip = 0;
80100c1e:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c23:	e9 96 fe ff ff       	jmp    80100abe <exec+0x1a9>
80100c28:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c2d:	e9 8c fe ff ff       	jmp    80100abe <exec+0x1a9>
80100c32:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c37:	e9 82 fe ff ff       	jmp    80100abe <exec+0x1a9>
  return -1;
80100c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c41:	e9 3f fd ff ff       	jmp    80100985 <exec+0x70>

80100c46 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c46:	55                   	push   %ebp
80100c47:	89 e5                	mov    %esp,%ebp
80100c49:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c4c:	68 f5 64 10 80       	push   $0x801064f5
80100c51:	68 20 10 11 80       	push   $0x80111020
80100c56:	e8 51 2e 00 00       	call   80103aac <initlock>
}
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	c9                   	leave  
80100c5f:	c3                   	ret    

80100c60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c60:	55                   	push   %ebp
80100c61:	89 e5                	mov    %esp,%ebp
80100c63:	53                   	push   %ebx
80100c64:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c67:	68 20 10 11 80       	push   $0x80111020
80100c6c:	e8 77 2f 00 00       	call   80103be8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c71:	83 c4 10             	add    $0x10,%esp
80100c74:	bb 54 10 11 80       	mov    $0x80111054,%ebx
80100c79:	81 fb b4 19 11 80    	cmp    $0x801119b4,%ebx
80100c7f:	73 29                	jae    80100caa <filealloc+0x4a>
    if(f->ref == 0){
80100c81:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c85:	74 05                	je     80100c8c <filealloc+0x2c>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c87:	83 c3 18             	add    $0x18,%ebx
80100c8a:	eb ed                	jmp    80100c79 <filealloc+0x19>
      f->ref = 1;
80100c8c:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c93:	83 ec 0c             	sub    $0xc,%esp
80100c96:	68 20 10 11 80       	push   $0x80111020
80100c9b:	e8 ad 2f 00 00       	call   80103c4d <release>
      return f;
80100ca0:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ca3:	89 d8                	mov    %ebx,%eax
80100ca5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ca8:	c9                   	leave  
80100ca9:	c3                   	ret    
  release(&ftable.lock);
80100caa:	83 ec 0c             	sub    $0xc,%esp
80100cad:	68 20 10 11 80       	push   $0x80111020
80100cb2:	e8 96 2f 00 00       	call   80103c4d <release>
  return 0;
80100cb7:	83 c4 10             	add    $0x10,%esp
80100cba:	bb 00 00 00 00       	mov    $0x0,%ebx
80100cbf:	eb e2                	jmp    80100ca3 <filealloc+0x43>

80100cc1 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100cc1:	55                   	push   %ebp
80100cc2:	89 e5                	mov    %esp,%ebp
80100cc4:	53                   	push   %ebx
80100cc5:	83 ec 10             	sub    $0x10,%esp
80100cc8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100ccb:	68 20 10 11 80       	push   $0x80111020
80100cd0:	e8 13 2f 00 00       	call   80103be8 <acquire>
  if(f->ref < 1)
80100cd5:	8b 43 04             	mov    0x4(%ebx),%eax
80100cd8:	83 c4 10             	add    $0x10,%esp
80100cdb:	85 c0                	test   %eax,%eax
80100cdd:	7e 1a                	jle    80100cf9 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100cdf:	83 c0 01             	add    $0x1,%eax
80100ce2:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ce5:	83 ec 0c             	sub    $0xc,%esp
80100ce8:	68 20 10 11 80       	push   $0x80111020
80100ced:	e8 5b 2f 00 00       	call   80103c4d <release>
  return f;
}
80100cf2:	89 d8                	mov    %ebx,%eax
80100cf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cf7:	c9                   	leave  
80100cf8:	c3                   	ret    
    panic("filedup");
80100cf9:	83 ec 0c             	sub    $0xc,%esp
80100cfc:	68 fc 64 10 80       	push   $0x801064fc
80100d01:	e8 42 f6 ff ff       	call   80100348 <panic>

80100d06 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d06:	55                   	push   %ebp
80100d07:	89 e5                	mov    %esp,%ebp
80100d09:	53                   	push   %ebx
80100d0a:	83 ec 30             	sub    $0x30,%esp
80100d0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100d10:	68 20 10 11 80       	push   $0x80111020
80100d15:	e8 ce 2e 00 00       	call   80103be8 <acquire>
  if(f->ref < 1)
80100d1a:	8b 43 04             	mov    0x4(%ebx),%eax
80100d1d:	83 c4 10             	add    $0x10,%esp
80100d20:	85 c0                	test   %eax,%eax
80100d22:	7e 1f                	jle    80100d43 <fileclose+0x3d>
    panic("fileclose");
  if(--f->ref > 0){
80100d24:	83 e8 01             	sub    $0x1,%eax
80100d27:	89 43 04             	mov    %eax,0x4(%ebx)
80100d2a:	85 c0                	test   %eax,%eax
80100d2c:	7e 22                	jle    80100d50 <fileclose+0x4a>
    release(&ftable.lock);
80100d2e:	83 ec 0c             	sub    $0xc,%esp
80100d31:	68 20 10 11 80       	push   $0x80111020
80100d36:	e8 12 2f 00 00       	call   80103c4d <release>
    return;
80100d3b:	83 c4 10             	add    $0x10,%esp
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100d3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d41:	c9                   	leave  
80100d42:	c3                   	ret    
    panic("fileclose");
80100d43:	83 ec 0c             	sub    $0xc,%esp
80100d46:	68 04 65 10 80       	push   $0x80106504
80100d4b:	e8 f8 f5 ff ff       	call   80100348 <panic>
  ff = *f;
80100d50:	8b 03                	mov    (%ebx),%eax
80100d52:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d55:	8b 43 08             	mov    0x8(%ebx),%eax
80100d58:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d5b:	8b 43 0c             	mov    0xc(%ebx),%eax
80100d5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100d61:	8b 43 10             	mov    0x10(%ebx),%eax
80100d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  f->ref = 0;
80100d67:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d6e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d74:	83 ec 0c             	sub    $0xc,%esp
80100d77:	68 20 10 11 80       	push   $0x80111020
80100d7c:	e8 cc 2e 00 00       	call   80103c4d <release>
  if(ff.type == FD_PIPE)
80100d81:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d84:	83 c4 10             	add    $0x10,%esp
80100d87:	83 f8 01             	cmp    $0x1,%eax
80100d8a:	74 1f                	je     80100dab <fileclose+0xa5>
  else if(ff.type == FD_INODE){
80100d8c:	83 f8 02             	cmp    $0x2,%eax
80100d8f:	75 ad                	jne    80100d3e <fileclose+0x38>
    begin_op();
80100d91:	e8 4b 1a 00 00       	call   801027e1 <begin_op>
    iput(ff.ip);
80100d96:	83 ec 0c             	sub    $0xc,%esp
80100d99:	ff 75 f0             	pushl  -0x10(%ebp)
80100d9c:	e8 1a 09 00 00       	call   801016bb <iput>
    end_op();
80100da1:	e8 b5 1a 00 00       	call   8010285b <end_op>
80100da6:	83 c4 10             	add    $0x10,%esp
80100da9:	eb 93                	jmp    80100d3e <fileclose+0x38>
    pipeclose(ff.pipe, ff.writable);
80100dab:	83 ec 08             	sub    $0x8,%esp
80100dae:	0f be 45 e9          	movsbl -0x17(%ebp),%eax
80100db2:	50                   	push   %eax
80100db3:	ff 75 ec             	pushl  -0x14(%ebp)
80100db6:	e8 9a 20 00 00       	call   80102e55 <pipeclose>
80100dbb:	83 c4 10             	add    $0x10,%esp
80100dbe:	e9 7b ff ff ff       	jmp    80100d3e <fileclose+0x38>

80100dc3 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100dc3:	55                   	push   %ebp
80100dc4:	89 e5                	mov    %esp,%ebp
80100dc6:	53                   	push   %ebx
80100dc7:	83 ec 04             	sub    $0x4,%esp
80100dca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100dcd:	83 3b 02             	cmpl   $0x2,(%ebx)
80100dd0:	75 31                	jne    80100e03 <filestat+0x40>
    ilock(f->ip);
80100dd2:	83 ec 0c             	sub    $0xc,%esp
80100dd5:	ff 73 10             	pushl  0x10(%ebx)
80100dd8:	e8 d7 07 00 00       	call   801015b4 <ilock>
    stati(f->ip, st);
80100ddd:	83 c4 08             	add    $0x8,%esp
80100de0:	ff 75 0c             	pushl  0xc(%ebp)
80100de3:	ff 73 10             	pushl  0x10(%ebx)
80100de6:	e8 90 09 00 00       	call   8010177b <stati>
    iunlock(f->ip);
80100deb:	83 c4 04             	add    $0x4,%esp
80100dee:	ff 73 10             	pushl  0x10(%ebx)
80100df1:	e8 80 08 00 00       	call   80101676 <iunlock>
    return 0;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100dfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e01:	c9                   	leave  
80100e02:	c3                   	ret    
  return -1;
80100e03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e08:	eb f4                	jmp    80100dfe <filestat+0x3b>

80100e0a <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e0a:	55                   	push   %ebp
80100e0b:	89 e5                	mov    %esp,%ebp
80100e0d:	56                   	push   %esi
80100e0e:	53                   	push   %ebx
80100e0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100e12:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e16:	74 70                	je     80100e88 <fileread+0x7e>
    return -1;
  if(f->type == FD_PIPE)
80100e18:	8b 03                	mov    (%ebx),%eax
80100e1a:	83 f8 01             	cmp    $0x1,%eax
80100e1d:	74 44                	je     80100e63 <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e1f:	83 f8 02             	cmp    $0x2,%eax
80100e22:	75 57                	jne    80100e7b <fileread+0x71>
    ilock(f->ip);
80100e24:	83 ec 0c             	sub    $0xc,%esp
80100e27:	ff 73 10             	pushl  0x10(%ebx)
80100e2a:	e8 85 07 00 00       	call   801015b4 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e2f:	ff 75 10             	pushl  0x10(%ebp)
80100e32:	ff 73 14             	pushl  0x14(%ebx)
80100e35:	ff 75 0c             	pushl  0xc(%ebp)
80100e38:	ff 73 10             	pushl  0x10(%ebx)
80100e3b:	e8 66 09 00 00       	call   801017a6 <readi>
80100e40:	89 c6                	mov    %eax,%esi
80100e42:	83 c4 20             	add    $0x20,%esp
80100e45:	85 c0                	test   %eax,%eax
80100e47:	7e 03                	jle    80100e4c <fileread+0x42>
      f->off += r;
80100e49:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e4c:	83 ec 0c             	sub    $0xc,%esp
80100e4f:	ff 73 10             	pushl  0x10(%ebx)
80100e52:	e8 1f 08 00 00       	call   80101676 <iunlock>
    return r;
80100e57:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e5a:	89 f0                	mov    %esi,%eax
80100e5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e5f:	5b                   	pop    %ebx
80100e60:	5e                   	pop    %esi
80100e61:	5d                   	pop    %ebp
80100e62:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e63:	83 ec 04             	sub    $0x4,%esp
80100e66:	ff 75 10             	pushl  0x10(%ebp)
80100e69:	ff 75 0c             	pushl  0xc(%ebp)
80100e6c:	ff 73 0c             	pushl  0xc(%ebx)
80100e6f:	e8 39 21 00 00       	call   80102fad <piperead>
80100e74:	89 c6                	mov    %eax,%esi
80100e76:	83 c4 10             	add    $0x10,%esp
80100e79:	eb df                	jmp    80100e5a <fileread+0x50>
  panic("fileread");
80100e7b:	83 ec 0c             	sub    $0xc,%esp
80100e7e:	68 0e 65 10 80       	push   $0x8010650e
80100e83:	e8 c0 f4 ff ff       	call   80100348 <panic>
    return -1;
80100e88:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e8d:	eb cb                	jmp    80100e5a <fileread+0x50>

80100e8f <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e8f:	55                   	push   %ebp
80100e90:	89 e5                	mov    %esp,%ebp
80100e92:	57                   	push   %edi
80100e93:	56                   	push   %esi
80100e94:	53                   	push   %ebx
80100e95:	83 ec 1c             	sub    $0x1c,%esp
80100e98:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->writable == 0)
80100e9b:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
80100e9f:	0f 84 c5 00 00 00    	je     80100f6a <filewrite+0xdb>
    return -1;
  if(f->type == FD_PIPE)
80100ea5:	8b 03                	mov    (%ebx),%eax
80100ea7:	83 f8 01             	cmp    $0x1,%eax
80100eaa:	74 10                	je     80100ebc <filewrite+0x2d>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100eac:	83 f8 02             	cmp    $0x2,%eax
80100eaf:	0f 85 a8 00 00 00    	jne    80100f5d <filewrite+0xce>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100eb5:	bf 00 00 00 00       	mov    $0x0,%edi
80100eba:	eb 67                	jmp    80100f23 <filewrite+0x94>
    return pipewrite(f->pipe, addr, n);
80100ebc:	83 ec 04             	sub    $0x4,%esp
80100ebf:	ff 75 10             	pushl  0x10(%ebp)
80100ec2:	ff 75 0c             	pushl  0xc(%ebp)
80100ec5:	ff 73 0c             	pushl  0xc(%ebx)
80100ec8:	e8 14 20 00 00       	call   80102ee1 <pipewrite>
80100ecd:	83 c4 10             	add    $0x10,%esp
80100ed0:	e9 80 00 00 00       	jmp    80100f55 <filewrite+0xc6>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100ed5:	e8 07 19 00 00       	call   801027e1 <begin_op>
      ilock(f->ip);
80100eda:	83 ec 0c             	sub    $0xc,%esp
80100edd:	ff 73 10             	pushl  0x10(%ebx)
80100ee0:	e8 cf 06 00 00       	call   801015b4 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100ee5:	89 f8                	mov    %edi,%eax
80100ee7:	03 45 0c             	add    0xc(%ebp),%eax
80100eea:	ff 75 e4             	pushl  -0x1c(%ebp)
80100eed:	ff 73 14             	pushl  0x14(%ebx)
80100ef0:	50                   	push   %eax
80100ef1:	ff 73 10             	pushl  0x10(%ebx)
80100ef4:	e8 aa 09 00 00       	call   801018a3 <writei>
80100ef9:	89 c6                	mov    %eax,%esi
80100efb:	83 c4 20             	add    $0x20,%esp
80100efe:	85 c0                	test   %eax,%eax
80100f00:	7e 03                	jle    80100f05 <filewrite+0x76>
        f->off += r;
80100f02:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
80100f05:	83 ec 0c             	sub    $0xc,%esp
80100f08:	ff 73 10             	pushl  0x10(%ebx)
80100f0b:	e8 66 07 00 00       	call   80101676 <iunlock>
      end_op();
80100f10:	e8 46 19 00 00       	call   8010285b <end_op>

      if(r < 0)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	85 f6                	test   %esi,%esi
80100f1a:	78 31                	js     80100f4d <filewrite+0xbe>
        break;
      if(r != n1)
80100f1c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80100f1f:	75 1f                	jne    80100f40 <filewrite+0xb1>
        panic("short filewrite");
      i += r;
80100f21:	01 f7                	add    %esi,%edi
    while(i < n){
80100f23:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f26:	7d 25                	jge    80100f4d <filewrite+0xbe>
      int n1 = n - i;
80100f28:	8b 45 10             	mov    0x10(%ebp),%eax
80100f2b:	29 f8                	sub    %edi,%eax
80100f2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100f30:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f35:	7e 9e                	jle    80100ed5 <filewrite+0x46>
        n1 = max;
80100f37:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100f3e:	eb 95                	jmp    80100ed5 <filewrite+0x46>
        panic("short filewrite");
80100f40:	83 ec 0c             	sub    $0xc,%esp
80100f43:	68 17 65 10 80       	push   $0x80106517
80100f48:	e8 fb f3 ff ff       	call   80100348 <panic>
    }
    return i == n ? n : -1;
80100f4d:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f50:	75 1f                	jne    80100f71 <filewrite+0xe2>
80100f52:	8b 45 10             	mov    0x10(%ebp),%eax
  }
  panic("filewrite");
}
80100f55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f58:	5b                   	pop    %ebx
80100f59:	5e                   	pop    %esi
80100f5a:	5f                   	pop    %edi
80100f5b:	5d                   	pop    %ebp
80100f5c:	c3                   	ret    
  panic("filewrite");
80100f5d:	83 ec 0c             	sub    $0xc,%esp
80100f60:	68 1d 65 10 80       	push   $0x8010651d
80100f65:	e8 de f3 ff ff       	call   80100348 <panic>
    return -1;
80100f6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f6f:	eb e4                	jmp    80100f55 <filewrite+0xc6>
    return i == n ? n : -1;
80100f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f76:	eb dd                	jmp    80100f55 <filewrite+0xc6>

80100f78 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f78:	55                   	push   %ebp
80100f79:	89 e5                	mov    %esp,%ebp
80100f7b:	57                   	push   %edi
80100f7c:	56                   	push   %esi
80100f7d:	53                   	push   %ebx
80100f7e:	83 ec 0c             	sub    $0xc,%esp
80100f81:	89 d7                	mov    %edx,%edi
  char *s;
  int len;

  while(*path == '/')
80100f83:	eb 03                	jmp    80100f88 <skipelem+0x10>
    path++;
80100f85:	83 c0 01             	add    $0x1,%eax
  while(*path == '/')
80100f88:	0f b6 10             	movzbl (%eax),%edx
80100f8b:	80 fa 2f             	cmp    $0x2f,%dl
80100f8e:	74 f5                	je     80100f85 <skipelem+0xd>
  if(*path == 0)
80100f90:	84 d2                	test   %dl,%dl
80100f92:	74 59                	je     80100fed <skipelem+0x75>
80100f94:	89 c3                	mov    %eax,%ebx
80100f96:	eb 03                	jmp    80100f9b <skipelem+0x23>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80100f98:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80100f9b:	0f b6 13             	movzbl (%ebx),%edx
80100f9e:	80 fa 2f             	cmp    $0x2f,%dl
80100fa1:	0f 95 c1             	setne  %cl
80100fa4:	84 d2                	test   %dl,%dl
80100fa6:	0f 95 c2             	setne  %dl
80100fa9:	84 d1                	test   %dl,%cl
80100fab:	75 eb                	jne    80100f98 <skipelem+0x20>
  len = path - s;
80100fad:	89 de                	mov    %ebx,%esi
80100faf:	29 c6                	sub    %eax,%esi
  if(len >= DIRSIZ)
80100fb1:	83 fe 0d             	cmp    $0xd,%esi
80100fb4:	7e 11                	jle    80100fc7 <skipelem+0x4f>
    memmove(name, s, DIRSIZ);
80100fb6:	83 ec 04             	sub    $0x4,%esp
80100fb9:	6a 0e                	push   $0xe
80100fbb:	50                   	push   %eax
80100fbc:	57                   	push   %edi
80100fbd:	e8 4d 2d 00 00       	call   80103d0f <memmove>
80100fc2:	83 c4 10             	add    $0x10,%esp
80100fc5:	eb 17                	jmp    80100fde <skipelem+0x66>
  else {
    memmove(name, s, len);
80100fc7:	83 ec 04             	sub    $0x4,%esp
80100fca:	56                   	push   %esi
80100fcb:	50                   	push   %eax
80100fcc:	57                   	push   %edi
80100fcd:	e8 3d 2d 00 00       	call   80103d0f <memmove>
    name[len] = 0;
80100fd2:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
80100fd6:	83 c4 10             	add    $0x10,%esp
80100fd9:	eb 03                	jmp    80100fde <skipelem+0x66>
  }
  while(*path == '/')
    path++;
80100fdb:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80100fde:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100fe1:	74 f8                	je     80100fdb <skipelem+0x63>
  return path;
}
80100fe3:	89 d8                	mov    %ebx,%eax
80100fe5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe8:	5b                   	pop    %ebx
80100fe9:	5e                   	pop    %esi
80100fea:	5f                   	pop    %edi
80100feb:	5d                   	pop    %ebp
80100fec:	c3                   	ret    
    return 0;
80100fed:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ff2:	eb ef                	jmp    80100fe3 <skipelem+0x6b>

80100ff4 <bzero>:
{
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	53                   	push   %ebx
80100ff8:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80100ffb:	52                   	push   %edx
80100ffc:	50                   	push   %eax
80100ffd:	e8 6a f1 ff ff       	call   8010016c <bread>
80101002:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101004:	8d 40 5c             	lea    0x5c(%eax),%eax
80101007:	83 c4 0c             	add    $0xc,%esp
8010100a:	68 00 02 00 00       	push   $0x200
8010100f:	6a 00                	push   $0x0
80101011:	50                   	push   %eax
80101012:	e8 7d 2c 00 00       	call   80103c94 <memset>
  log_write(bp);
80101017:	89 1c 24             	mov    %ebx,(%esp)
8010101a:	e8 eb 18 00 00       	call   8010290a <log_write>
  brelse(bp);
8010101f:	89 1c 24             	mov    %ebx,(%esp)
80101022:	e8 ae f1 ff ff       	call   801001d5 <brelse>
}
80101027:	83 c4 10             	add    $0x10,%esp
8010102a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010102d:	c9                   	leave  
8010102e:	c3                   	ret    

8010102f <balloc>:
{
8010102f:	55                   	push   %ebp
80101030:	89 e5                	mov    %esp,%ebp
80101032:	57                   	push   %edi
80101033:	56                   	push   %esi
80101034:	53                   	push   %ebx
80101035:	83 ec 1c             	sub    $0x1c,%esp
80101038:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010103b:	be 00 00 00 00       	mov    $0x0,%esi
80101040:	eb 14                	jmp    80101056 <balloc+0x27>
    brelse(bp);
80101042:	83 ec 0c             	sub    $0xc,%esp
80101045:	ff 75 e4             	pushl  -0x1c(%ebp)
80101048:	e8 88 f1 ff ff       	call   801001d5 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010104d:	81 c6 00 10 00 00    	add    $0x1000,%esi
80101053:	83 c4 10             	add    $0x10,%esp
80101056:	39 35 20 1a 11 80    	cmp    %esi,0x80111a20
8010105c:	76 75                	jbe    801010d3 <balloc+0xa4>
    bp = bread(dev, BBLOCK(b, sb));
8010105e:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
80101064:	85 f6                	test   %esi,%esi
80101066:	0f 49 c6             	cmovns %esi,%eax
80101069:	c1 f8 0c             	sar    $0xc,%eax
8010106c:	03 05 38 1a 11 80    	add    0x80111a38,%eax
80101072:	83 ec 08             	sub    $0x8,%esp
80101075:	50                   	push   %eax
80101076:	ff 75 d8             	pushl  -0x28(%ebp)
80101079:	e8 ee f0 ff ff       	call   8010016c <bread>
8010107e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101081:	83 c4 10             	add    $0x10,%esp
80101084:	b8 00 00 00 00       	mov    $0x0,%eax
80101089:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010108e:	7f b2                	jg     80101042 <balloc+0x13>
80101090:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80101093:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80101096:	3b 1d 20 1a 11 80    	cmp    0x80111a20,%ebx
8010109c:	73 a4                	jae    80101042 <balloc+0x13>
      m = 1 << (bi % 8);
8010109e:	99                   	cltd   
8010109f:	c1 ea 1d             	shr    $0x1d,%edx
801010a2:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
801010a5:	83 e1 07             	and    $0x7,%ecx
801010a8:	29 d1                	sub    %edx,%ecx
801010aa:	ba 01 00 00 00       	mov    $0x1,%edx
801010af:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801010b1:	8d 48 07             	lea    0x7(%eax),%ecx
801010b4:	85 c0                	test   %eax,%eax
801010b6:	0f 49 c8             	cmovns %eax,%ecx
801010b9:	c1 f9 03             	sar    $0x3,%ecx
801010bc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801010bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801010c2:	0f b6 4c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%ecx
801010c7:	0f b6 f9             	movzbl %cl,%edi
801010ca:	85 d7                	test   %edx,%edi
801010cc:	74 12                	je     801010e0 <balloc+0xb1>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010ce:	83 c0 01             	add    $0x1,%eax
801010d1:	eb b6                	jmp    80101089 <balloc+0x5a>
  panic("balloc: out of blocks");
801010d3:	83 ec 0c             	sub    $0xc,%esp
801010d6:	68 27 65 10 80       	push   $0x80106527
801010db:	e8 68 f2 ff ff       	call   80100348 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
801010e0:	09 ca                	or     %ecx,%edx
801010e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010e5:	8b 75 dc             	mov    -0x24(%ebp),%esi
801010e8:	88 54 30 5c          	mov    %dl,0x5c(%eax,%esi,1)
        log_write(bp);
801010ec:	83 ec 0c             	sub    $0xc,%esp
801010ef:	89 c6                	mov    %eax,%esi
801010f1:	50                   	push   %eax
801010f2:	e8 13 18 00 00       	call   8010290a <log_write>
        brelse(bp);
801010f7:	89 34 24             	mov    %esi,(%esp)
801010fa:	e8 d6 f0 ff ff       	call   801001d5 <brelse>
        bzero(dev, b + bi);
801010ff:	89 da                	mov    %ebx,%edx
80101101:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101104:	e8 eb fe ff ff       	call   80100ff4 <bzero>
}
80101109:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010110c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010110f:	5b                   	pop    %ebx
80101110:	5e                   	pop    %esi
80101111:	5f                   	pop    %edi
80101112:	5d                   	pop    %ebp
80101113:	c3                   	ret    

80101114 <bmap>:
{
80101114:	55                   	push   %ebp
80101115:	89 e5                	mov    %esp,%ebp
80101117:	57                   	push   %edi
80101118:	56                   	push   %esi
80101119:	53                   	push   %ebx
8010111a:	83 ec 1c             	sub    $0x1c,%esp
8010111d:	89 c6                	mov    %eax,%esi
8010111f:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
80101121:	83 fa 0b             	cmp    $0xb,%edx
80101124:	77 17                	ja     8010113d <bmap+0x29>
    if((addr = ip->addrs[bn]) == 0)
80101126:	8b 5c 90 5c          	mov    0x5c(%eax,%edx,4),%ebx
8010112a:	85 db                	test   %ebx,%ebx
8010112c:	75 4a                	jne    80101178 <bmap+0x64>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010112e:	8b 00                	mov    (%eax),%eax
80101130:	e8 fa fe ff ff       	call   8010102f <balloc>
80101135:	89 c3                	mov    %eax,%ebx
80101137:	89 44 be 5c          	mov    %eax,0x5c(%esi,%edi,4)
8010113b:	eb 3b                	jmp    80101178 <bmap+0x64>
  bn -= NDIRECT;
8010113d:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
80101140:	83 fb 7f             	cmp    $0x7f,%ebx
80101143:	77 68                	ja     801011ad <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101145:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010114b:	85 c0                	test   %eax,%eax
8010114d:	74 33                	je     80101182 <bmap+0x6e>
    bp = bread(ip->dev, addr);
8010114f:	83 ec 08             	sub    $0x8,%esp
80101152:	50                   	push   %eax
80101153:	ff 36                	pushl  (%esi)
80101155:	e8 12 f0 ff ff       	call   8010016c <bread>
8010115a:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010115c:	8d 44 98 5c          	lea    0x5c(%eax,%ebx,4),%eax
80101160:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101163:	8b 18                	mov    (%eax),%ebx
80101165:	83 c4 10             	add    $0x10,%esp
80101168:	85 db                	test   %ebx,%ebx
8010116a:	74 25                	je     80101191 <bmap+0x7d>
    brelse(bp);
8010116c:	83 ec 0c             	sub    $0xc,%esp
8010116f:	57                   	push   %edi
80101170:	e8 60 f0 ff ff       	call   801001d5 <brelse>
    return addr;
80101175:	83 c4 10             	add    $0x10,%esp
}
80101178:	89 d8                	mov    %ebx,%eax
8010117a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117d:	5b                   	pop    %ebx
8010117e:	5e                   	pop    %esi
8010117f:	5f                   	pop    %edi
80101180:	5d                   	pop    %ebp
80101181:	c3                   	ret    
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101182:	8b 06                	mov    (%esi),%eax
80101184:	e8 a6 fe ff ff       	call   8010102f <balloc>
80101189:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010118f:	eb be                	jmp    8010114f <bmap+0x3b>
      a[bn] = addr = balloc(ip->dev);
80101191:	8b 06                	mov    (%esi),%eax
80101193:	e8 97 fe ff ff       	call   8010102f <balloc>
80101198:	89 c3                	mov    %eax,%ebx
8010119a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010119d:	89 18                	mov    %ebx,(%eax)
      log_write(bp);
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	57                   	push   %edi
801011a3:	e8 62 17 00 00       	call   8010290a <log_write>
801011a8:	83 c4 10             	add    $0x10,%esp
801011ab:	eb bf                	jmp    8010116c <bmap+0x58>
  panic("bmap: out of range");
801011ad:	83 ec 0c             	sub    $0xc,%esp
801011b0:	68 3d 65 10 80       	push   $0x8010653d
801011b5:	e8 8e f1 ff ff       	call   80100348 <panic>

801011ba <iget>:
{
801011ba:	55                   	push   %ebp
801011bb:	89 e5                	mov    %esp,%ebp
801011bd:	57                   	push   %edi
801011be:	56                   	push   %esi
801011bf:	53                   	push   %ebx
801011c0:	83 ec 28             	sub    $0x28,%esp
801011c3:	89 c7                	mov    %eax,%edi
801011c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801011c8:	68 40 1a 11 80       	push   $0x80111a40
801011cd:	e8 16 2a 00 00       	call   80103be8 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011d2:	83 c4 10             	add    $0x10,%esp
  empty = 0;
801011d5:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011da:	bb 74 1a 11 80       	mov    $0x80111a74,%ebx
801011df:	eb 0a                	jmp    801011eb <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011e1:	85 f6                	test   %esi,%esi
801011e3:	74 3b                	je     80101220 <iget+0x66>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011e5:	81 c3 90 00 00 00    	add    $0x90,%ebx
801011eb:	81 fb 94 36 11 80    	cmp    $0x80113694,%ebx
801011f1:	73 35                	jae    80101228 <iget+0x6e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011f3:	8b 43 08             	mov    0x8(%ebx),%eax
801011f6:	85 c0                	test   %eax,%eax
801011f8:	7e e7                	jle    801011e1 <iget+0x27>
801011fa:	39 3b                	cmp    %edi,(%ebx)
801011fc:	75 e3                	jne    801011e1 <iget+0x27>
801011fe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101201:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101204:	75 db                	jne    801011e1 <iget+0x27>
      ip->ref++;
80101206:	83 c0 01             	add    $0x1,%eax
80101209:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
8010120c:	83 ec 0c             	sub    $0xc,%esp
8010120f:	68 40 1a 11 80       	push   $0x80111a40
80101214:	e8 34 2a 00 00       	call   80103c4d <release>
      return ip;
80101219:	83 c4 10             	add    $0x10,%esp
8010121c:	89 de                	mov    %ebx,%esi
8010121e:	eb 32                	jmp    80101252 <iget+0x98>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101220:	85 c0                	test   %eax,%eax
80101222:	75 c1                	jne    801011e5 <iget+0x2b>
      empty = ip;
80101224:	89 de                	mov    %ebx,%esi
80101226:	eb bd                	jmp    801011e5 <iget+0x2b>
  if(empty == 0)
80101228:	85 f6                	test   %esi,%esi
8010122a:	74 30                	je     8010125c <iget+0xa2>
  ip->dev = dev;
8010122c:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
8010122e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101231:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
80101234:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010123b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101242:	83 ec 0c             	sub    $0xc,%esp
80101245:	68 40 1a 11 80       	push   $0x80111a40
8010124a:	e8 fe 29 00 00       	call   80103c4d <release>
  return ip;
8010124f:	83 c4 10             	add    $0x10,%esp
}
80101252:	89 f0                	mov    %esi,%eax
80101254:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101257:	5b                   	pop    %ebx
80101258:	5e                   	pop    %esi
80101259:	5f                   	pop    %edi
8010125a:	5d                   	pop    %ebp
8010125b:	c3                   	ret    
    panic("iget: no inodes");
8010125c:	83 ec 0c             	sub    $0xc,%esp
8010125f:	68 50 65 10 80       	push   $0x80106550
80101264:	e8 df f0 ff ff       	call   80100348 <panic>

80101269 <readsb>:
{
80101269:	55                   	push   %ebp
8010126a:	89 e5                	mov    %esp,%ebp
8010126c:	53                   	push   %ebx
8010126d:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
80101270:	6a 01                	push   $0x1
80101272:	ff 75 08             	pushl  0x8(%ebp)
80101275:	e8 f2 ee ff ff       	call   8010016c <bread>
8010127a:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010127c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010127f:	83 c4 0c             	add    $0xc,%esp
80101282:	6a 1c                	push   $0x1c
80101284:	50                   	push   %eax
80101285:	ff 75 0c             	pushl  0xc(%ebp)
80101288:	e8 82 2a 00 00       	call   80103d0f <memmove>
  brelse(bp);
8010128d:	89 1c 24             	mov    %ebx,(%esp)
80101290:	e8 40 ef ff ff       	call   801001d5 <brelse>
}
80101295:	83 c4 10             	add    $0x10,%esp
80101298:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010129b:	c9                   	leave  
8010129c:	c3                   	ret    

8010129d <bfree>:
{
8010129d:	55                   	push   %ebp
8010129e:	89 e5                	mov    %esp,%ebp
801012a0:	56                   	push   %esi
801012a1:	53                   	push   %ebx
801012a2:	89 c6                	mov    %eax,%esi
801012a4:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801012a6:	83 ec 08             	sub    $0x8,%esp
801012a9:	68 20 1a 11 80       	push   $0x80111a20
801012ae:	50                   	push   %eax
801012af:	e8 b5 ff ff ff       	call   80101269 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801012b4:	89 d8                	mov    %ebx,%eax
801012b6:	c1 e8 0c             	shr    $0xc,%eax
801012b9:	03 05 38 1a 11 80    	add    0x80111a38,%eax
801012bf:	83 c4 08             	add    $0x8,%esp
801012c2:	50                   	push   %eax
801012c3:	56                   	push   %esi
801012c4:	e8 a3 ee ff ff       	call   8010016c <bread>
801012c9:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801012cb:	89 d9                	mov    %ebx,%ecx
801012cd:	83 e1 07             	and    $0x7,%ecx
801012d0:	b8 01 00 00 00       	mov    $0x1,%eax
801012d5:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801012d7:	83 c4 10             	add    $0x10,%esp
801012da:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801012e0:	c1 fb 03             	sar    $0x3,%ebx
801012e3:	0f b6 54 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%edx
801012e8:	0f b6 ca             	movzbl %dl,%ecx
801012eb:	85 c1                	test   %eax,%ecx
801012ed:	74 23                	je     80101312 <bfree+0x75>
  bp->data[bi/8] &= ~m;
801012ef:	f7 d0                	not    %eax
801012f1:	21 d0                	and    %edx,%eax
801012f3:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801012f7:	83 ec 0c             	sub    $0xc,%esp
801012fa:	56                   	push   %esi
801012fb:	e8 0a 16 00 00       	call   8010290a <log_write>
  brelse(bp);
80101300:	89 34 24             	mov    %esi,(%esp)
80101303:	e8 cd ee ff ff       	call   801001d5 <brelse>
}
80101308:	83 c4 10             	add    $0x10,%esp
8010130b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010130e:	5b                   	pop    %ebx
8010130f:	5e                   	pop    %esi
80101310:	5d                   	pop    %ebp
80101311:	c3                   	ret    
    panic("freeing free block");
80101312:	83 ec 0c             	sub    $0xc,%esp
80101315:	68 60 65 10 80       	push   $0x80106560
8010131a:	e8 29 f0 ff ff       	call   80100348 <panic>

8010131f <iinit>:
{
8010131f:	55                   	push   %ebp
80101320:	89 e5                	mov    %esp,%ebp
80101322:	53                   	push   %ebx
80101323:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101326:	68 73 65 10 80       	push   $0x80106573
8010132b:	68 40 1a 11 80       	push   $0x80111a40
80101330:	e8 77 27 00 00       	call   80103aac <initlock>
  for(i = 0; i < NINODE; i++) {
80101335:	83 c4 10             	add    $0x10,%esp
80101338:	bb 00 00 00 00       	mov    $0x0,%ebx
8010133d:	eb 21                	jmp    80101360 <iinit+0x41>
    initsleeplock(&icache.inode[i].lock, "inode");
8010133f:	83 ec 08             	sub    $0x8,%esp
80101342:	68 7a 65 10 80       	push   $0x8010657a
80101347:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
8010134a:	89 d0                	mov    %edx,%eax
8010134c:	c1 e0 04             	shl    $0x4,%eax
8010134f:	05 80 1a 11 80       	add    $0x80111a80,%eax
80101354:	50                   	push   %eax
80101355:	e8 6e 26 00 00       	call   801039c8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010135a:	83 c3 01             	add    $0x1,%ebx
8010135d:	83 c4 10             	add    $0x10,%esp
80101360:	83 fb 31             	cmp    $0x31,%ebx
80101363:	7e da                	jle    8010133f <iinit+0x20>
  readsb(dev, &sb);
80101365:	83 ec 08             	sub    $0x8,%esp
80101368:	68 20 1a 11 80       	push   $0x80111a20
8010136d:	ff 75 08             	pushl  0x8(%ebp)
80101370:	e8 f4 fe ff ff       	call   80101269 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101375:	ff 35 38 1a 11 80    	pushl  0x80111a38
8010137b:	ff 35 34 1a 11 80    	pushl  0x80111a34
80101381:	ff 35 30 1a 11 80    	pushl  0x80111a30
80101387:	ff 35 2c 1a 11 80    	pushl  0x80111a2c
8010138d:	ff 35 28 1a 11 80    	pushl  0x80111a28
80101393:	ff 35 24 1a 11 80    	pushl  0x80111a24
80101399:	ff 35 20 1a 11 80    	pushl  0x80111a20
8010139f:	68 e0 65 10 80       	push   $0x801065e0
801013a4:	e8 62 f2 ff ff       	call   8010060b <cprintf>
}
801013a9:	83 c4 30             	add    $0x30,%esp
801013ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013af:	c9                   	leave  
801013b0:	c3                   	ret    

801013b1 <ialloc>:
{
801013b1:	55                   	push   %ebp
801013b2:	89 e5                	mov    %esp,%ebp
801013b4:	57                   	push   %edi
801013b5:	56                   	push   %esi
801013b6:	53                   	push   %ebx
801013b7:	83 ec 1c             	sub    $0x1c,%esp
801013ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801013bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801013c0:	bb 01 00 00 00       	mov    $0x1,%ebx
801013c5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801013c8:	39 1d 28 1a 11 80    	cmp    %ebx,0x80111a28
801013ce:	76 3f                	jbe    8010140f <ialloc+0x5e>
    bp = bread(dev, IBLOCK(inum, sb));
801013d0:	89 d8                	mov    %ebx,%eax
801013d2:	c1 e8 03             	shr    $0x3,%eax
801013d5:	03 05 34 1a 11 80    	add    0x80111a34,%eax
801013db:	83 ec 08             	sub    $0x8,%esp
801013de:	50                   	push   %eax
801013df:	ff 75 08             	pushl  0x8(%ebp)
801013e2:	e8 85 ed ff ff       	call   8010016c <bread>
801013e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013e9:	89 d8                	mov    %ebx,%eax
801013eb:	83 e0 07             	and    $0x7,%eax
801013ee:	c1 e0 06             	shl    $0x6,%eax
801013f1:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801013f5:	83 c4 10             	add    $0x10,%esp
801013f8:	66 83 3f 00          	cmpw   $0x0,(%edi)
801013fc:	74 1e                	je     8010141c <ialloc+0x6b>
    brelse(bp);
801013fe:	83 ec 0c             	sub    $0xc,%esp
80101401:	56                   	push   %esi
80101402:	e8 ce ed ff ff       	call   801001d5 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101407:	83 c3 01             	add    $0x1,%ebx
8010140a:	83 c4 10             	add    $0x10,%esp
8010140d:	eb b6                	jmp    801013c5 <ialloc+0x14>
  panic("ialloc: no inodes");
8010140f:	83 ec 0c             	sub    $0xc,%esp
80101412:	68 80 65 10 80       	push   $0x80106580
80101417:	e8 2c ef ff ff       	call   80100348 <panic>
      memset(dip, 0, sizeof(*dip));
8010141c:	83 ec 04             	sub    $0x4,%esp
8010141f:	6a 40                	push   $0x40
80101421:	6a 00                	push   $0x0
80101423:	57                   	push   %edi
80101424:	e8 6b 28 00 00       	call   80103c94 <memset>
      dip->type = type;
80101429:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010142d:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
80101430:	89 34 24             	mov    %esi,(%esp)
80101433:	e8 d2 14 00 00       	call   8010290a <log_write>
      brelse(bp);
80101438:	89 34 24             	mov    %esi,(%esp)
8010143b:	e8 95 ed ff ff       	call   801001d5 <brelse>
      return iget(dev, inum);
80101440:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101443:	8b 45 08             	mov    0x8(%ebp),%eax
80101446:	e8 6f fd ff ff       	call   801011ba <iget>
}
8010144b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144e:	5b                   	pop    %ebx
8010144f:	5e                   	pop    %esi
80101450:	5f                   	pop    %edi
80101451:	5d                   	pop    %ebp
80101452:	c3                   	ret    

80101453 <iupdate>:
{
80101453:	55                   	push   %ebp
80101454:	89 e5                	mov    %esp,%ebp
80101456:	56                   	push   %esi
80101457:	53                   	push   %ebx
80101458:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010145b:	8b 43 04             	mov    0x4(%ebx),%eax
8010145e:	c1 e8 03             	shr    $0x3,%eax
80101461:	03 05 34 1a 11 80    	add    0x80111a34,%eax
80101467:	83 ec 08             	sub    $0x8,%esp
8010146a:	50                   	push   %eax
8010146b:	ff 33                	pushl  (%ebx)
8010146d:	e8 fa ec ff ff       	call   8010016c <bread>
80101472:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101474:	8b 43 04             	mov    0x4(%ebx),%eax
80101477:	83 e0 07             	and    $0x7,%eax
8010147a:	c1 e0 06             	shl    $0x6,%eax
8010147d:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101481:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
80101485:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101488:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
8010148c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101490:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
80101494:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101498:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
8010149c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801014a0:	8b 53 58             	mov    0x58(%ebx),%edx
801014a3:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801014a6:	83 c3 5c             	add    $0x5c,%ebx
801014a9:	83 c0 0c             	add    $0xc,%eax
801014ac:	83 c4 0c             	add    $0xc,%esp
801014af:	6a 34                	push   $0x34
801014b1:	53                   	push   %ebx
801014b2:	50                   	push   %eax
801014b3:	e8 57 28 00 00       	call   80103d0f <memmove>
  log_write(bp);
801014b8:	89 34 24             	mov    %esi,(%esp)
801014bb:	e8 4a 14 00 00       	call   8010290a <log_write>
  brelse(bp);
801014c0:	89 34 24             	mov    %esi,(%esp)
801014c3:	e8 0d ed ff ff       	call   801001d5 <brelse>
}
801014c8:	83 c4 10             	add    $0x10,%esp
801014cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014ce:	5b                   	pop    %ebx
801014cf:	5e                   	pop    %esi
801014d0:	5d                   	pop    %ebp
801014d1:	c3                   	ret    

801014d2 <itrunc>:
{
801014d2:	55                   	push   %ebp
801014d3:	89 e5                	mov    %esp,%ebp
801014d5:	57                   	push   %edi
801014d6:	56                   	push   %esi
801014d7:	53                   	push   %ebx
801014d8:	83 ec 1c             	sub    $0x1c,%esp
801014db:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
801014dd:	bb 00 00 00 00       	mov    $0x0,%ebx
801014e2:	eb 03                	jmp    801014e7 <itrunc+0x15>
801014e4:	83 c3 01             	add    $0x1,%ebx
801014e7:	83 fb 0b             	cmp    $0xb,%ebx
801014ea:	7f 19                	jg     80101505 <itrunc+0x33>
    if(ip->addrs[i]){
801014ec:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
801014f0:	85 d2                	test   %edx,%edx
801014f2:	74 f0                	je     801014e4 <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
801014f4:	8b 06                	mov    (%esi),%eax
801014f6:	e8 a2 fd ff ff       	call   8010129d <bfree>
      ip->addrs[i] = 0;
801014fb:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
80101502:	00 
80101503:	eb df                	jmp    801014e4 <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
80101505:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
8010150b:	85 c0                	test   %eax,%eax
8010150d:	75 1b                	jne    8010152a <itrunc+0x58>
  ip->size = 0;
8010150f:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101516:	83 ec 0c             	sub    $0xc,%esp
80101519:	56                   	push   %esi
8010151a:	e8 34 ff ff ff       	call   80101453 <iupdate>
}
8010151f:	83 c4 10             	add    $0x10,%esp
80101522:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101525:	5b                   	pop    %ebx
80101526:	5e                   	pop    %esi
80101527:	5f                   	pop    %edi
80101528:	5d                   	pop    %ebp
80101529:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010152a:	83 ec 08             	sub    $0x8,%esp
8010152d:	50                   	push   %eax
8010152e:	ff 36                	pushl  (%esi)
80101530:	e8 37 ec ff ff       	call   8010016c <bread>
80101535:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101538:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010153b:	83 c4 10             	add    $0x10,%esp
8010153e:	bb 00 00 00 00       	mov    $0x0,%ebx
80101543:	eb 03                	jmp    80101548 <itrunc+0x76>
80101545:	83 c3 01             	add    $0x1,%ebx
80101548:	83 fb 7f             	cmp    $0x7f,%ebx
8010154b:	77 10                	ja     8010155d <itrunc+0x8b>
      if(a[j])
8010154d:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
80101550:	85 d2                	test   %edx,%edx
80101552:	74 f1                	je     80101545 <itrunc+0x73>
        bfree(ip->dev, a[j]);
80101554:	8b 06                	mov    (%esi),%eax
80101556:	e8 42 fd ff ff       	call   8010129d <bfree>
8010155b:	eb e8                	jmp    80101545 <itrunc+0x73>
    brelse(bp);
8010155d:	83 ec 0c             	sub    $0xc,%esp
80101560:	ff 75 e4             	pushl  -0x1c(%ebp)
80101563:	e8 6d ec ff ff       	call   801001d5 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101568:	8b 06                	mov    (%esi),%eax
8010156a:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101570:	e8 28 fd ff ff       	call   8010129d <bfree>
    ip->addrs[NDIRECT] = 0;
80101575:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
8010157c:	00 00 00 
8010157f:	83 c4 10             	add    $0x10,%esp
80101582:	eb 8b                	jmp    8010150f <itrunc+0x3d>

80101584 <idup>:
{
80101584:	55                   	push   %ebp
80101585:	89 e5                	mov    %esp,%ebp
80101587:	53                   	push   %ebx
80101588:	83 ec 10             	sub    $0x10,%esp
8010158b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010158e:	68 40 1a 11 80       	push   $0x80111a40
80101593:	e8 50 26 00 00       	call   80103be8 <acquire>
  ip->ref++;
80101598:	8b 43 08             	mov    0x8(%ebx),%eax
8010159b:	83 c0 01             	add    $0x1,%eax
8010159e:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801015a1:	c7 04 24 40 1a 11 80 	movl   $0x80111a40,(%esp)
801015a8:	e8 a0 26 00 00       	call   80103c4d <release>
}
801015ad:	89 d8                	mov    %ebx,%eax
801015af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015b2:	c9                   	leave  
801015b3:	c3                   	ret    

801015b4 <ilock>:
{
801015b4:	55                   	push   %ebp
801015b5:	89 e5                	mov    %esp,%ebp
801015b7:	56                   	push   %esi
801015b8:	53                   	push   %ebx
801015b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801015bc:	85 db                	test   %ebx,%ebx
801015be:	74 22                	je     801015e2 <ilock+0x2e>
801015c0:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015c4:	7e 1c                	jle    801015e2 <ilock+0x2e>
  acquiresleep(&ip->lock);
801015c6:	83 ec 0c             	sub    $0xc,%esp
801015c9:	8d 43 0c             	lea    0xc(%ebx),%eax
801015cc:	50                   	push   %eax
801015cd:	e8 29 24 00 00       	call   801039fb <acquiresleep>
  if(ip->valid == 0){
801015d2:	83 c4 10             	add    $0x10,%esp
801015d5:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801015d9:	74 14                	je     801015ef <ilock+0x3b>
}
801015db:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015de:	5b                   	pop    %ebx
801015df:	5e                   	pop    %esi
801015e0:	5d                   	pop    %ebp
801015e1:	c3                   	ret    
    panic("ilock");
801015e2:	83 ec 0c             	sub    $0xc,%esp
801015e5:	68 92 65 10 80       	push   $0x80106592
801015ea:	e8 59 ed ff ff       	call   80100348 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015ef:	8b 43 04             	mov    0x4(%ebx),%eax
801015f2:	c1 e8 03             	shr    $0x3,%eax
801015f5:	03 05 34 1a 11 80    	add    0x80111a34,%eax
801015fb:	83 ec 08             	sub    $0x8,%esp
801015fe:	50                   	push   %eax
801015ff:	ff 33                	pushl  (%ebx)
80101601:	e8 66 eb ff ff       	call   8010016c <bread>
80101606:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101608:	8b 43 04             	mov    0x4(%ebx),%eax
8010160b:	83 e0 07             	and    $0x7,%eax
8010160e:	c1 e0 06             	shl    $0x6,%eax
80101611:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101615:	0f b7 10             	movzwl (%eax),%edx
80101618:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
8010161c:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101620:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101624:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101628:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
8010162c:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101630:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101634:	8b 50 08             	mov    0x8(%eax),%edx
80101637:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010163a:	83 c0 0c             	add    $0xc,%eax
8010163d:	8d 53 5c             	lea    0x5c(%ebx),%edx
80101640:	83 c4 0c             	add    $0xc,%esp
80101643:	6a 34                	push   $0x34
80101645:	50                   	push   %eax
80101646:	52                   	push   %edx
80101647:	e8 c3 26 00 00       	call   80103d0f <memmove>
    brelse(bp);
8010164c:	89 34 24             	mov    %esi,(%esp)
8010164f:	e8 81 eb ff ff       	call   801001d5 <brelse>
    ip->valid = 1;
80101654:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010165b:	83 c4 10             	add    $0x10,%esp
8010165e:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101663:	0f 85 72 ff ff ff    	jne    801015db <ilock+0x27>
      panic("ilock: no type");
80101669:	83 ec 0c             	sub    $0xc,%esp
8010166c:	68 98 65 10 80       	push   $0x80106598
80101671:	e8 d2 ec ff ff       	call   80100348 <panic>

80101676 <iunlock>:
{
80101676:	55                   	push   %ebp
80101677:	89 e5                	mov    %esp,%ebp
80101679:	56                   	push   %esi
8010167a:	53                   	push   %ebx
8010167b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010167e:	85 db                	test   %ebx,%ebx
80101680:	74 2c                	je     801016ae <iunlock+0x38>
80101682:	8d 73 0c             	lea    0xc(%ebx),%esi
80101685:	83 ec 0c             	sub    $0xc,%esp
80101688:	56                   	push   %esi
80101689:	e8 f7 23 00 00       	call   80103a85 <holdingsleep>
8010168e:	83 c4 10             	add    $0x10,%esp
80101691:	85 c0                	test   %eax,%eax
80101693:	74 19                	je     801016ae <iunlock+0x38>
80101695:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101699:	7e 13                	jle    801016ae <iunlock+0x38>
  releasesleep(&ip->lock);
8010169b:	83 ec 0c             	sub    $0xc,%esp
8010169e:	56                   	push   %esi
8010169f:	e8 a6 23 00 00       	call   80103a4a <releasesleep>
}
801016a4:	83 c4 10             	add    $0x10,%esp
801016a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016aa:	5b                   	pop    %ebx
801016ab:	5e                   	pop    %esi
801016ac:	5d                   	pop    %ebp
801016ad:	c3                   	ret    
    panic("iunlock");
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	68 a7 65 10 80       	push   $0x801065a7
801016b6:	e8 8d ec ff ff       	call   80100348 <panic>

801016bb <iput>:
{
801016bb:	55                   	push   %ebp
801016bc:	89 e5                	mov    %esp,%ebp
801016be:	57                   	push   %edi
801016bf:	56                   	push   %esi
801016c0:	53                   	push   %ebx
801016c1:	83 ec 18             	sub    $0x18,%esp
801016c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801016c7:	8d 73 0c             	lea    0xc(%ebx),%esi
801016ca:	56                   	push   %esi
801016cb:	e8 2b 23 00 00       	call   801039fb <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801016d0:	83 c4 10             	add    $0x10,%esp
801016d3:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801016d7:	74 07                	je     801016e0 <iput+0x25>
801016d9:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801016de:	74 35                	je     80101715 <iput+0x5a>
  releasesleep(&ip->lock);
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	56                   	push   %esi
801016e4:	e8 61 23 00 00       	call   80103a4a <releasesleep>
  acquire(&icache.lock);
801016e9:	c7 04 24 40 1a 11 80 	movl   $0x80111a40,(%esp)
801016f0:	e8 f3 24 00 00       	call   80103be8 <acquire>
  ip->ref--;
801016f5:	8b 43 08             	mov    0x8(%ebx),%eax
801016f8:	83 e8 01             	sub    $0x1,%eax
801016fb:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801016fe:	c7 04 24 40 1a 11 80 	movl   $0x80111a40,(%esp)
80101705:	e8 43 25 00 00       	call   80103c4d <release>
}
8010170a:	83 c4 10             	add    $0x10,%esp
8010170d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101710:	5b                   	pop    %ebx
80101711:	5e                   	pop    %esi
80101712:	5f                   	pop    %edi
80101713:	5d                   	pop    %ebp
80101714:	c3                   	ret    
    acquire(&icache.lock);
80101715:	83 ec 0c             	sub    $0xc,%esp
80101718:	68 40 1a 11 80       	push   $0x80111a40
8010171d:	e8 c6 24 00 00       	call   80103be8 <acquire>
    int r = ip->ref;
80101722:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101725:	c7 04 24 40 1a 11 80 	movl   $0x80111a40,(%esp)
8010172c:	e8 1c 25 00 00       	call   80103c4d <release>
    if(r == 1){
80101731:	83 c4 10             	add    $0x10,%esp
80101734:	83 ff 01             	cmp    $0x1,%edi
80101737:	75 a7                	jne    801016e0 <iput+0x25>
      itrunc(ip);
80101739:	89 d8                	mov    %ebx,%eax
8010173b:	e8 92 fd ff ff       	call   801014d2 <itrunc>
      ip->type = 0;
80101740:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101746:	83 ec 0c             	sub    $0xc,%esp
80101749:	53                   	push   %ebx
8010174a:	e8 04 fd ff ff       	call   80101453 <iupdate>
      ip->valid = 0;
8010174f:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101756:	83 c4 10             	add    $0x10,%esp
80101759:	eb 85                	jmp    801016e0 <iput+0x25>

8010175b <iunlockput>:
{
8010175b:	55                   	push   %ebp
8010175c:	89 e5                	mov    %esp,%ebp
8010175e:	53                   	push   %ebx
8010175f:	83 ec 10             	sub    $0x10,%esp
80101762:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101765:	53                   	push   %ebx
80101766:	e8 0b ff ff ff       	call   80101676 <iunlock>
  iput(ip);
8010176b:	89 1c 24             	mov    %ebx,(%esp)
8010176e:	e8 48 ff ff ff       	call   801016bb <iput>
}
80101773:	83 c4 10             	add    $0x10,%esp
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    

8010177b <stati>:
{
8010177b:	55                   	push   %ebp
8010177c:	89 e5                	mov    %esp,%ebp
8010177e:	8b 55 08             	mov    0x8(%ebp),%edx
80101781:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101784:	8b 0a                	mov    (%edx),%ecx
80101786:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101789:	8b 4a 04             	mov    0x4(%edx),%ecx
8010178c:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
8010178f:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101793:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101796:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010179a:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
8010179e:	8b 52 58             	mov    0x58(%edx),%edx
801017a1:	89 50 10             	mov    %edx,0x10(%eax)
}
801017a4:	5d                   	pop    %ebp
801017a5:	c3                   	ret    

801017a6 <readi>:
{
801017a6:	55                   	push   %ebp
801017a7:	89 e5                	mov    %esp,%ebp
801017a9:	57                   	push   %edi
801017aa:	56                   	push   %esi
801017ab:	53                   	push   %ebx
801017ac:	83 ec 1c             	sub    $0x1c,%esp
801017af:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
801017b2:	8b 45 08             	mov    0x8(%ebp),%eax
801017b5:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801017ba:	74 2c                	je     801017e8 <readi+0x42>
  if(off > ip->size || off + n < off)
801017bc:	8b 45 08             	mov    0x8(%ebp),%eax
801017bf:	8b 40 58             	mov    0x58(%eax),%eax
801017c2:	39 f8                	cmp    %edi,%eax
801017c4:	0f 82 cb 00 00 00    	jb     80101895 <readi+0xef>
801017ca:	89 fa                	mov    %edi,%edx
801017cc:	03 55 14             	add    0x14(%ebp),%edx
801017cf:	0f 82 c7 00 00 00    	jb     8010189c <readi+0xf6>
  if(off + n > ip->size)
801017d5:	39 d0                	cmp    %edx,%eax
801017d7:	73 05                	jae    801017de <readi+0x38>
    n = ip->size - off;
801017d9:	29 f8                	sub    %edi,%eax
801017db:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017de:	be 00 00 00 00       	mov    $0x0,%esi
801017e3:	e9 8f 00 00 00       	jmp    80101877 <readi+0xd1>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801017e8:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801017ec:	66 83 f8 09          	cmp    $0x9,%ax
801017f0:	0f 87 91 00 00 00    	ja     80101887 <readi+0xe1>
801017f6:	98                   	cwtl   
801017f7:	8b 04 c5 c0 19 11 80 	mov    -0x7feee640(,%eax,8),%eax
801017fe:	85 c0                	test   %eax,%eax
80101800:	0f 84 88 00 00 00    	je     8010188e <readi+0xe8>
    return devsw[ip->major].read(ip, dst, n);
80101806:	83 ec 04             	sub    $0x4,%esp
80101809:	ff 75 14             	pushl  0x14(%ebp)
8010180c:	ff 75 0c             	pushl  0xc(%ebp)
8010180f:	ff 75 08             	pushl  0x8(%ebp)
80101812:	ff d0                	call   *%eax
80101814:	83 c4 10             	add    $0x10,%esp
80101817:	eb 66                	jmp    8010187f <readi+0xd9>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101819:	89 fa                	mov    %edi,%edx
8010181b:	c1 ea 09             	shr    $0x9,%edx
8010181e:	8b 45 08             	mov    0x8(%ebp),%eax
80101821:	e8 ee f8 ff ff       	call   80101114 <bmap>
80101826:	83 ec 08             	sub    $0x8,%esp
80101829:	50                   	push   %eax
8010182a:	8b 45 08             	mov    0x8(%ebp),%eax
8010182d:	ff 30                	pushl  (%eax)
8010182f:	e8 38 e9 ff ff       	call   8010016c <bread>
80101834:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
80101836:	89 f8                	mov    %edi,%eax
80101838:	25 ff 01 00 00       	and    $0x1ff,%eax
8010183d:	bb 00 02 00 00       	mov    $0x200,%ebx
80101842:	29 c3                	sub    %eax,%ebx
80101844:	8b 55 14             	mov    0x14(%ebp),%edx
80101847:	29 f2                	sub    %esi,%edx
80101849:	83 c4 0c             	add    $0xc,%esp
8010184c:	39 d3                	cmp    %edx,%ebx
8010184e:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101851:	53                   	push   %ebx
80101852:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101855:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101859:	50                   	push   %eax
8010185a:	ff 75 0c             	pushl  0xc(%ebp)
8010185d:	e8 ad 24 00 00       	call   80103d0f <memmove>
    brelse(bp);
80101862:	83 c4 04             	add    $0x4,%esp
80101865:	ff 75 e4             	pushl  -0x1c(%ebp)
80101868:	e8 68 e9 ff ff       	call   801001d5 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010186d:	01 de                	add    %ebx,%esi
8010186f:	01 df                	add    %ebx,%edi
80101871:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101874:	83 c4 10             	add    $0x10,%esp
80101877:	39 75 14             	cmp    %esi,0x14(%ebp)
8010187a:	77 9d                	ja     80101819 <readi+0x73>
  return n;
8010187c:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010187f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101882:	5b                   	pop    %ebx
80101883:	5e                   	pop    %esi
80101884:	5f                   	pop    %edi
80101885:	5d                   	pop    %ebp
80101886:	c3                   	ret    
      return -1;
80101887:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010188c:	eb f1                	jmp    8010187f <readi+0xd9>
8010188e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101893:	eb ea                	jmp    8010187f <readi+0xd9>
    return -1;
80101895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010189a:	eb e3                	jmp    8010187f <readi+0xd9>
8010189c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018a1:	eb dc                	jmp    8010187f <readi+0xd9>

801018a3 <writei>:
{
801018a3:	55                   	push   %ebp
801018a4:	89 e5                	mov    %esp,%ebp
801018a6:	57                   	push   %edi
801018a7:	56                   	push   %esi
801018a8:	53                   	push   %ebx
801018a9:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
801018ac:	8b 45 08             	mov    0x8(%ebp),%eax
801018af:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801018b4:	74 2f                	je     801018e5 <writei+0x42>
  if(off > ip->size || off + n < off)
801018b6:	8b 45 08             	mov    0x8(%ebp),%eax
801018b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
801018bc:	39 48 58             	cmp    %ecx,0x58(%eax)
801018bf:	0f 82 f4 00 00 00    	jb     801019b9 <writei+0x116>
801018c5:	89 c8                	mov    %ecx,%eax
801018c7:	03 45 14             	add    0x14(%ebp),%eax
801018ca:	0f 82 f0 00 00 00    	jb     801019c0 <writei+0x11d>
  if(off + n > MAXFILE*BSIZE)
801018d0:	3d 00 18 01 00       	cmp    $0x11800,%eax
801018d5:	0f 87 ec 00 00 00    	ja     801019c7 <writei+0x124>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801018db:	be 00 00 00 00       	mov    $0x0,%esi
801018e0:	e9 94 00 00 00       	jmp    80101979 <writei+0xd6>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801018e5:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801018e9:	66 83 f8 09          	cmp    $0x9,%ax
801018ed:	0f 87 b8 00 00 00    	ja     801019ab <writei+0x108>
801018f3:	98                   	cwtl   
801018f4:	8b 04 c5 c4 19 11 80 	mov    -0x7feee63c(,%eax,8),%eax
801018fb:	85 c0                	test   %eax,%eax
801018fd:	0f 84 af 00 00 00    	je     801019b2 <writei+0x10f>
    return devsw[ip->major].write(ip, src, n);
80101903:	83 ec 04             	sub    $0x4,%esp
80101906:	ff 75 14             	pushl  0x14(%ebp)
80101909:	ff 75 0c             	pushl  0xc(%ebp)
8010190c:	ff 75 08             	pushl  0x8(%ebp)
8010190f:	ff d0                	call   *%eax
80101911:	83 c4 10             	add    $0x10,%esp
80101914:	eb 7c                	jmp    80101992 <writei+0xef>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101916:	8b 55 10             	mov    0x10(%ebp),%edx
80101919:	c1 ea 09             	shr    $0x9,%edx
8010191c:	8b 45 08             	mov    0x8(%ebp),%eax
8010191f:	e8 f0 f7 ff ff       	call   80101114 <bmap>
80101924:	83 ec 08             	sub    $0x8,%esp
80101927:	50                   	push   %eax
80101928:	8b 45 08             	mov    0x8(%ebp),%eax
8010192b:	ff 30                	pushl  (%eax)
8010192d:	e8 3a e8 ff ff       	call   8010016c <bread>
80101932:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101934:	8b 45 10             	mov    0x10(%ebp),%eax
80101937:	25 ff 01 00 00       	and    $0x1ff,%eax
8010193c:	bb 00 02 00 00       	mov    $0x200,%ebx
80101941:	29 c3                	sub    %eax,%ebx
80101943:	8b 55 14             	mov    0x14(%ebp),%edx
80101946:	29 f2                	sub    %esi,%edx
80101948:	83 c4 0c             	add    $0xc,%esp
8010194b:	39 d3                	cmp    %edx,%ebx
8010194d:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101950:	53                   	push   %ebx
80101951:	ff 75 0c             	pushl  0xc(%ebp)
80101954:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101958:	50                   	push   %eax
80101959:	e8 b1 23 00 00       	call   80103d0f <memmove>
    log_write(bp);
8010195e:	89 3c 24             	mov    %edi,(%esp)
80101961:	e8 a4 0f 00 00       	call   8010290a <log_write>
    brelse(bp);
80101966:	89 3c 24             	mov    %edi,(%esp)
80101969:	e8 67 e8 ff ff       	call   801001d5 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010196e:	01 de                	add    %ebx,%esi
80101970:	01 5d 10             	add    %ebx,0x10(%ebp)
80101973:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101976:	83 c4 10             	add    $0x10,%esp
80101979:	3b 75 14             	cmp    0x14(%ebp),%esi
8010197c:	72 98                	jb     80101916 <writei+0x73>
  if(n > 0 && off > ip->size){
8010197e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80101982:	74 0b                	je     8010198f <writei+0xec>
80101984:	8b 45 08             	mov    0x8(%ebp),%eax
80101987:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010198a:	39 48 58             	cmp    %ecx,0x58(%eax)
8010198d:	72 0b                	jb     8010199a <writei+0xf7>
  return n;
8010198f:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101992:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101995:	5b                   	pop    %ebx
80101996:	5e                   	pop    %esi
80101997:	5f                   	pop    %edi
80101998:	5d                   	pop    %ebp
80101999:	c3                   	ret    
    ip->size = off;
8010199a:	89 48 58             	mov    %ecx,0x58(%eax)
    iupdate(ip);
8010199d:	83 ec 0c             	sub    $0xc,%esp
801019a0:	50                   	push   %eax
801019a1:	e8 ad fa ff ff       	call   80101453 <iupdate>
801019a6:	83 c4 10             	add    $0x10,%esp
801019a9:	eb e4                	jmp    8010198f <writei+0xec>
      return -1;
801019ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019b0:	eb e0                	jmp    80101992 <writei+0xef>
801019b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019b7:	eb d9                	jmp    80101992 <writei+0xef>
    return -1;
801019b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019be:	eb d2                	jmp    80101992 <writei+0xef>
801019c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019c5:	eb cb                	jmp    80101992 <writei+0xef>
    return -1;
801019c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019cc:	eb c4                	jmp    80101992 <writei+0xef>

801019ce <namecmp>:
{
801019ce:	55                   	push   %ebp
801019cf:	89 e5                	mov    %esp,%ebp
801019d1:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801019d4:	6a 0e                	push   $0xe
801019d6:	ff 75 0c             	pushl  0xc(%ebp)
801019d9:	ff 75 08             	pushl  0x8(%ebp)
801019dc:	e8 95 23 00 00       	call   80103d76 <strncmp>
}
801019e1:	c9                   	leave  
801019e2:	c3                   	ret    

801019e3 <dirlookup>:
{
801019e3:	55                   	push   %ebp
801019e4:	89 e5                	mov    %esp,%ebp
801019e6:	57                   	push   %edi
801019e7:	56                   	push   %esi
801019e8:	53                   	push   %ebx
801019e9:	83 ec 1c             	sub    $0x1c,%esp
801019ec:	8b 75 08             	mov    0x8(%ebp),%esi
801019ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
801019f2:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801019f7:	75 07                	jne    80101a00 <dirlookup+0x1d>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019f9:	bb 00 00 00 00       	mov    $0x0,%ebx
801019fe:	eb 1d                	jmp    80101a1d <dirlookup+0x3a>
    panic("dirlookup not DIR");
80101a00:	83 ec 0c             	sub    $0xc,%esp
80101a03:	68 af 65 10 80       	push   $0x801065af
80101a08:	e8 3b e9 ff ff       	call   80100348 <panic>
      panic("dirlookup read");
80101a0d:	83 ec 0c             	sub    $0xc,%esp
80101a10:	68 c1 65 10 80       	push   $0x801065c1
80101a15:	e8 2e e9 ff ff       	call   80100348 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a1a:	83 c3 10             	add    $0x10,%ebx
80101a1d:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a20:	76 48                	jbe    80101a6a <dirlookup+0x87>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a22:	6a 10                	push   $0x10
80101a24:	53                   	push   %ebx
80101a25:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101a28:	50                   	push   %eax
80101a29:	56                   	push   %esi
80101a2a:	e8 77 fd ff ff       	call   801017a6 <readi>
80101a2f:	83 c4 10             	add    $0x10,%esp
80101a32:	83 f8 10             	cmp    $0x10,%eax
80101a35:	75 d6                	jne    80101a0d <dirlookup+0x2a>
    if(de.inum == 0)
80101a37:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a3c:	74 dc                	je     80101a1a <dirlookup+0x37>
    if(namecmp(name, de.name) == 0){
80101a3e:	83 ec 08             	sub    $0x8,%esp
80101a41:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a44:	50                   	push   %eax
80101a45:	57                   	push   %edi
80101a46:	e8 83 ff ff ff       	call   801019ce <namecmp>
80101a4b:	83 c4 10             	add    $0x10,%esp
80101a4e:	85 c0                	test   %eax,%eax
80101a50:	75 c8                	jne    80101a1a <dirlookup+0x37>
      if(poff)
80101a52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a56:	74 05                	je     80101a5d <dirlookup+0x7a>
        *poff = off;
80101a58:	8b 45 10             	mov    0x10(%ebp),%eax
80101a5b:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a5d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a61:	8b 06                	mov    (%esi),%eax
80101a63:	e8 52 f7 ff ff       	call   801011ba <iget>
80101a68:	eb 05                	jmp    80101a6f <dirlookup+0x8c>
  return 0;
80101a6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a72:	5b                   	pop    %ebx
80101a73:	5e                   	pop    %esi
80101a74:	5f                   	pop    %edi
80101a75:	5d                   	pop    %ebp
80101a76:	c3                   	ret    

80101a77 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a77:	55                   	push   %ebp
80101a78:	89 e5                	mov    %esp,%ebp
80101a7a:	57                   	push   %edi
80101a7b:	56                   	push   %esi
80101a7c:	53                   	push   %ebx
80101a7d:	83 ec 1c             	sub    $0x1c,%esp
80101a80:	89 c6                	mov    %eax,%esi
80101a82:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101a85:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a88:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a8b:	74 17                	je     80101aa4 <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a8d:	e8 af 17 00 00       	call   80103241 <myproc>
80101a92:	83 ec 0c             	sub    $0xc,%esp
80101a95:	ff 70 68             	pushl  0x68(%eax)
80101a98:	e8 e7 fa ff ff       	call   80101584 <idup>
80101a9d:	89 c3                	mov    %eax,%ebx
80101a9f:	83 c4 10             	add    $0x10,%esp
80101aa2:	eb 53                	jmp    80101af7 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101aa4:	ba 01 00 00 00       	mov    $0x1,%edx
80101aa9:	b8 01 00 00 00       	mov    $0x1,%eax
80101aae:	e8 07 f7 ff ff       	call   801011ba <iget>
80101ab3:	89 c3                	mov    %eax,%ebx
80101ab5:	eb 40                	jmp    80101af7 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101ab7:	83 ec 0c             	sub    $0xc,%esp
80101aba:	53                   	push   %ebx
80101abb:	e8 9b fc ff ff       	call   8010175b <iunlockput>
      return 0;
80101ac0:	83 c4 10             	add    $0x10,%esp
80101ac3:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101acd:	5b                   	pop    %ebx
80101ace:	5e                   	pop    %esi
80101acf:	5f                   	pop    %edi
80101ad0:	5d                   	pop    %ebp
80101ad1:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101ad2:	83 ec 04             	sub    $0x4,%esp
80101ad5:	6a 00                	push   $0x0
80101ad7:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ada:	53                   	push   %ebx
80101adb:	e8 03 ff ff ff       	call   801019e3 <dirlookup>
80101ae0:	89 c7                	mov    %eax,%edi
80101ae2:	83 c4 10             	add    $0x10,%esp
80101ae5:	85 c0                	test   %eax,%eax
80101ae7:	74 4a                	je     80101b33 <namex+0xbc>
    iunlockput(ip);
80101ae9:	83 ec 0c             	sub    $0xc,%esp
80101aec:	53                   	push   %ebx
80101aed:	e8 69 fc ff ff       	call   8010175b <iunlockput>
    ip = next;
80101af2:	83 c4 10             	add    $0x10,%esp
80101af5:	89 fb                	mov    %edi,%ebx
  while((path = skipelem(path, name)) != 0){
80101af7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101afa:	89 f0                	mov    %esi,%eax
80101afc:	e8 77 f4 ff ff       	call   80100f78 <skipelem>
80101b01:	89 c6                	mov    %eax,%esi
80101b03:	85 c0                	test   %eax,%eax
80101b05:	74 3c                	je     80101b43 <namex+0xcc>
    ilock(ip);
80101b07:	83 ec 0c             	sub    $0xc,%esp
80101b0a:	53                   	push   %ebx
80101b0b:	e8 a4 fa ff ff       	call   801015b4 <ilock>
    if(ip->type != T_DIR){
80101b10:	83 c4 10             	add    $0x10,%esp
80101b13:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101b18:	75 9d                	jne    80101ab7 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101b1a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b1e:	74 b2                	je     80101ad2 <namex+0x5b>
80101b20:	80 3e 00             	cmpb   $0x0,(%esi)
80101b23:	75 ad                	jne    80101ad2 <namex+0x5b>
      iunlock(ip);
80101b25:	83 ec 0c             	sub    $0xc,%esp
80101b28:	53                   	push   %ebx
80101b29:	e8 48 fb ff ff       	call   80101676 <iunlock>
      return ip;
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	eb 95                	jmp    80101ac8 <namex+0x51>
      iunlockput(ip);
80101b33:	83 ec 0c             	sub    $0xc,%esp
80101b36:	53                   	push   %ebx
80101b37:	e8 1f fc ff ff       	call   8010175b <iunlockput>
      return 0;
80101b3c:	83 c4 10             	add    $0x10,%esp
80101b3f:	89 fb                	mov    %edi,%ebx
80101b41:	eb 85                	jmp    80101ac8 <namex+0x51>
  if(nameiparent){
80101b43:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b47:	0f 84 7b ff ff ff    	je     80101ac8 <namex+0x51>
    iput(ip);
80101b4d:	83 ec 0c             	sub    $0xc,%esp
80101b50:	53                   	push   %ebx
80101b51:	e8 65 fb ff ff       	call   801016bb <iput>
    return 0;
80101b56:	83 c4 10             	add    $0x10,%esp
80101b59:	bb 00 00 00 00       	mov    $0x0,%ebx
80101b5e:	e9 65 ff ff ff       	jmp    80101ac8 <namex+0x51>

80101b63 <dirlink>:
{
80101b63:	55                   	push   %ebp
80101b64:	89 e5                	mov    %esp,%ebp
80101b66:	57                   	push   %edi
80101b67:	56                   	push   %esi
80101b68:	53                   	push   %ebx
80101b69:	83 ec 20             	sub    $0x20,%esp
80101b6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101b6f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101b72:	6a 00                	push   $0x0
80101b74:	57                   	push   %edi
80101b75:	53                   	push   %ebx
80101b76:	e8 68 fe ff ff       	call   801019e3 <dirlookup>
80101b7b:	83 c4 10             	add    $0x10,%esp
80101b7e:	85 c0                	test   %eax,%eax
80101b80:	75 2d                	jne    80101baf <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b82:	b8 00 00 00 00       	mov    $0x0,%eax
80101b87:	89 c6                	mov    %eax,%esi
80101b89:	39 43 58             	cmp    %eax,0x58(%ebx)
80101b8c:	76 41                	jbe    80101bcf <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b8e:	6a 10                	push   $0x10
80101b90:	50                   	push   %eax
80101b91:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101b94:	50                   	push   %eax
80101b95:	53                   	push   %ebx
80101b96:	e8 0b fc ff ff       	call   801017a6 <readi>
80101b9b:	83 c4 10             	add    $0x10,%esp
80101b9e:	83 f8 10             	cmp    $0x10,%eax
80101ba1:	75 1f                	jne    80101bc2 <dirlink+0x5f>
    if(de.inum == 0)
80101ba3:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ba8:	74 25                	je     80101bcf <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101baa:	8d 46 10             	lea    0x10(%esi),%eax
80101bad:	eb d8                	jmp    80101b87 <dirlink+0x24>
    iput(ip);
80101baf:	83 ec 0c             	sub    $0xc,%esp
80101bb2:	50                   	push   %eax
80101bb3:	e8 03 fb ff ff       	call   801016bb <iput>
    return -1;
80101bb8:	83 c4 10             	add    $0x10,%esp
80101bbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bc0:	eb 3d                	jmp    80101bff <dirlink+0x9c>
      panic("dirlink read");
80101bc2:	83 ec 0c             	sub    $0xc,%esp
80101bc5:	68 d0 65 10 80       	push   $0x801065d0
80101bca:	e8 79 e7 ff ff       	call   80100348 <panic>
  strncpy(de.name, name, DIRSIZ);
80101bcf:	83 ec 04             	sub    $0x4,%esp
80101bd2:	6a 0e                	push   $0xe
80101bd4:	57                   	push   %edi
80101bd5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101bd8:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bdb:	50                   	push   %eax
80101bdc:	e8 d2 21 00 00       	call   80103db3 <strncpy>
  de.inum = inum;
80101be1:	8b 45 10             	mov    0x10(%ebp),%eax
80101be4:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be8:	6a 10                	push   $0x10
80101bea:	56                   	push   %esi
80101beb:	57                   	push   %edi
80101bec:	53                   	push   %ebx
80101bed:	e8 b1 fc ff ff       	call   801018a3 <writei>
80101bf2:	83 c4 20             	add    $0x20,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 0d                	jne    80101c07 <dirlink+0xa4>
  return 0;
80101bfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101bff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c02:	5b                   	pop    %ebx
80101c03:	5e                   	pop    %esi
80101c04:	5f                   	pop    %edi
80101c05:	5d                   	pop    %ebp
80101c06:	c3                   	ret    
    panic("dirlink");
80101c07:	83 ec 0c             	sub    $0xc,%esp
80101c0a:	68 b4 6b 10 80       	push   $0x80106bb4
80101c0f:	e8 34 e7 ff ff       	call   80100348 <panic>

80101c14 <namei>:

struct inode*
namei(char *path)
{
80101c14:	55                   	push   %ebp
80101c15:	89 e5                	mov    %esp,%ebp
80101c17:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c1a:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c1d:	ba 00 00 00 00       	mov    $0x0,%edx
80101c22:	8b 45 08             	mov    0x8(%ebp),%eax
80101c25:	e8 4d fe ff ff       	call   80101a77 <namex>
}
80101c2a:	c9                   	leave  
80101c2b:	c3                   	ret    

80101c2c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101c2c:	55                   	push   %ebp
80101c2d:	89 e5                	mov    %esp,%ebp
80101c2f:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101c32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101c35:	ba 01 00 00 00       	mov    $0x1,%edx
80101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3d:	e8 35 fe ff ff       	call   80101a77 <namex>
}
80101c42:	c9                   	leave  
80101c43:	c3                   	ret    

80101c44 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101c44:	55                   	push   %ebp
80101c45:	89 e5                	mov    %esp,%ebp
80101c47:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101c49:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c4e:	ec                   	in     (%dx),%al
80101c4f:	89 c2                	mov    %eax,%edx
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101c51:	83 e0 c0             	and    $0xffffffc0,%eax
80101c54:	3c 40                	cmp    $0x40,%al
80101c56:	75 f1                	jne    80101c49 <idewait+0x5>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101c58:	85 c9                	test   %ecx,%ecx
80101c5a:	74 0c                	je     80101c68 <idewait+0x24>
80101c5c:	f6 c2 21             	test   $0x21,%dl
80101c5f:	75 0e                	jne    80101c6f <idewait+0x2b>
    return -1;
  return 0;
80101c61:	b8 00 00 00 00       	mov    $0x0,%eax
80101c66:	eb 05                	jmp    80101c6d <idewait+0x29>
80101c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c6d:	5d                   	pop    %ebp
80101c6e:	c3                   	ret    
    return -1;
80101c6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c74:	eb f7                	jmp    80101c6d <idewait+0x29>

80101c76 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101c76:	55                   	push   %ebp
80101c77:	89 e5                	mov    %esp,%ebp
80101c79:	56                   	push   %esi
80101c7a:	53                   	push   %ebx
  if(b == 0)
80101c7b:	85 c0                	test   %eax,%eax
80101c7d:	74 7d                	je     80101cfc <idestart+0x86>
80101c7f:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101c81:	8b 58 08             	mov    0x8(%eax),%ebx
80101c84:	81 fb cf 07 00 00    	cmp    $0x7cf,%ebx
80101c8a:	77 7d                	ja     80101d09 <idestart+0x93>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101c8c:	b8 00 00 00 00       	mov    $0x0,%eax
80101c91:	e8 ae ff ff ff       	call   80101c44 <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101c96:	b8 00 00 00 00       	mov    $0x0,%eax
80101c9b:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ca0:	ee                   	out    %al,(%dx)
80101ca1:	b8 01 00 00 00       	mov    $0x1,%eax
80101ca6:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101cab:	ee                   	out    %al,(%dx)
80101cac:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101cb1:	89 d8                	mov    %ebx,%eax
80101cb3:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101cb4:	89 d8                	mov    %ebx,%eax
80101cb6:	c1 f8 08             	sar    $0x8,%eax
80101cb9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101cbe:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101cbf:	89 d8                	mov    %ebx,%eax
80101cc1:	c1 f8 10             	sar    $0x10,%eax
80101cc4:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101cc9:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101cca:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101cce:	c1 e0 04             	shl    $0x4,%eax
80101cd1:	83 e0 10             	and    $0x10,%eax
80101cd4:	c1 fb 18             	sar    $0x18,%ebx
80101cd7:	83 e3 0f             	and    $0xf,%ebx
80101cda:	09 d8                	or     %ebx,%eax
80101cdc:	83 c8 e0             	or     $0xffffffe0,%eax
80101cdf:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ce4:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101ce5:	f6 06 04             	testb  $0x4,(%esi)
80101ce8:	75 2c                	jne    80101d16 <idestart+0xa0>
80101cea:	b8 20 00 00 00       	mov    $0x20,%eax
80101cef:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cf4:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101cf5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101cf8:	5b                   	pop    %ebx
80101cf9:	5e                   	pop    %esi
80101cfa:	5d                   	pop    %ebp
80101cfb:	c3                   	ret    
    panic("idestart");
80101cfc:	83 ec 0c             	sub    $0xc,%esp
80101cff:	68 33 66 10 80       	push   $0x80106633
80101d04:	e8 3f e6 ff ff       	call   80100348 <panic>
    panic("incorrect blockno");
80101d09:	83 ec 0c             	sub    $0xc,%esp
80101d0c:	68 3c 66 10 80       	push   $0x8010663c
80101d11:	e8 32 e6 ff ff       	call   80100348 <panic>
80101d16:	b8 30 00 00 00       	mov    $0x30,%eax
80101d1b:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d20:	ee                   	out    %al,(%dx)
    outsl(0x1f0, b->data, BSIZE/4);
80101d21:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101d24:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d29:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d2e:	fc                   	cld    
80101d2f:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101d31:	eb c2                	jmp    80101cf5 <idestart+0x7f>

80101d33 <ideinit>:
{
80101d33:	55                   	push   %ebp
80101d34:	89 e5                	mov    %esp,%ebp
80101d36:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101d39:	68 4e 66 10 80       	push   $0x8010664e
80101d3e:	68 80 95 10 80       	push   $0x80109580
80101d43:	e8 64 1d 00 00       	call   80103aac <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d48:	83 c4 08             	add    $0x8,%esp
80101d4b:	a1 60 3d 11 80       	mov    0x80113d60,%eax
80101d50:	83 e8 01             	sub    $0x1,%eax
80101d53:	50                   	push   %eax
80101d54:	6a 0e                	push   $0xe
80101d56:	e8 56 02 00 00       	call   80101fb1 <ioapicenable>
  idewait(0);
80101d5b:	b8 00 00 00 00       	mov    $0x0,%eax
80101d60:	e8 df fe ff ff       	call   80101c44 <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d65:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101d6a:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d6f:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101d70:	83 c4 10             	add    $0x10,%esp
80101d73:	b9 00 00 00 00       	mov    $0x0,%ecx
80101d78:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101d7e:	7f 19                	jg     80101d99 <ideinit+0x66>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d80:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d85:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101d86:	84 c0                	test   %al,%al
80101d88:	75 05                	jne    80101d8f <ideinit+0x5c>
  for(i=0; i<1000; i++){
80101d8a:	83 c1 01             	add    $0x1,%ecx
80101d8d:	eb e9                	jmp    80101d78 <ideinit+0x45>
      havedisk1 = 1;
80101d8f:	c7 05 60 95 10 80 01 	movl   $0x1,0x80109560
80101d96:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d99:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101d9e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101da3:	ee                   	out    %al,(%dx)
}
80101da4:	c9                   	leave  
80101da5:	c3                   	ret    

80101da6 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101da6:	55                   	push   %ebp
80101da7:	89 e5                	mov    %esp,%ebp
80101da9:	57                   	push   %edi
80101daa:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101dab:	83 ec 0c             	sub    $0xc,%esp
80101dae:	68 80 95 10 80       	push   $0x80109580
80101db3:	e8 30 1e 00 00       	call   80103be8 <acquire>

  if((b = idequeue) == 0){
80101db8:	8b 1d 64 95 10 80    	mov    0x80109564,%ebx
80101dbe:	83 c4 10             	add    $0x10,%esp
80101dc1:	85 db                	test   %ebx,%ebx
80101dc3:	74 48                	je     80101e0d <ideintr+0x67>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101dc5:	8b 43 58             	mov    0x58(%ebx),%eax
80101dc8:	a3 64 95 10 80       	mov    %eax,0x80109564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101dcd:	f6 03 04             	testb  $0x4,(%ebx)
80101dd0:	74 4d                	je     80101e1f <ideintr+0x79>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101dd2:	8b 03                	mov    (%ebx),%eax
80101dd4:	83 c8 02             	or     $0x2,%eax
  b->flags &= ~B_DIRTY;
80101dd7:	83 e0 fb             	and    $0xfffffffb,%eax
80101dda:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101ddc:	83 ec 0c             	sub    $0xc,%esp
80101ddf:	53                   	push   %ebx
80101de0:	e8 87 1a 00 00       	call   8010386c <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101de5:	a1 64 95 10 80       	mov    0x80109564,%eax
80101dea:	83 c4 10             	add    $0x10,%esp
80101ded:	85 c0                	test   %eax,%eax
80101def:	74 05                	je     80101df6 <ideintr+0x50>
    idestart(idequeue);
80101df1:	e8 80 fe ff ff       	call   80101c76 <idestart>

  release(&idelock);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	68 80 95 10 80       	push   $0x80109580
80101dfe:	e8 4a 1e 00 00       	call   80103c4d <release>
80101e03:	83 c4 10             	add    $0x10,%esp
}
80101e06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e09:	5b                   	pop    %ebx
80101e0a:	5f                   	pop    %edi
80101e0b:	5d                   	pop    %ebp
80101e0c:	c3                   	ret    
    release(&idelock);
80101e0d:	83 ec 0c             	sub    $0xc,%esp
80101e10:	68 80 95 10 80       	push   $0x80109580
80101e15:	e8 33 1e 00 00       	call   80103c4d <release>
    return;
80101e1a:	83 c4 10             	add    $0x10,%esp
80101e1d:	eb e7                	jmp    80101e06 <ideintr+0x60>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e1f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e24:	e8 1b fe ff ff       	call   80101c44 <idewait>
80101e29:	85 c0                	test   %eax,%eax
80101e2b:	78 a5                	js     80101dd2 <ideintr+0x2c>
    insl(0x1f0, b->data, BSIZE/4);
80101e2d:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101e30:	b9 80 00 00 00       	mov    $0x80,%ecx
80101e35:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101e3a:	fc                   	cld    
80101e3b:	f3 6d                	rep insl (%dx),%es:(%edi)
80101e3d:	eb 93                	jmp    80101dd2 <ideintr+0x2c>

80101e3f <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101e3f:	55                   	push   %ebp
80101e40:	89 e5                	mov    %esp,%ebp
80101e42:	53                   	push   %ebx
80101e43:	83 ec 10             	sub    $0x10,%esp
80101e46:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e49:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e4c:	50                   	push   %eax
80101e4d:	e8 33 1c 00 00       	call   80103a85 <holdingsleep>
80101e52:	83 c4 10             	add    $0x10,%esp
80101e55:	85 c0                	test   %eax,%eax
80101e57:	74 37                	je     80101e90 <iderw+0x51>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101e59:	8b 03                	mov    (%ebx),%eax
80101e5b:	83 e0 06             	and    $0x6,%eax
80101e5e:	83 f8 02             	cmp    $0x2,%eax
80101e61:	74 3a                	je     80101e9d <iderw+0x5e>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101e63:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101e67:	74 09                	je     80101e72 <iderw+0x33>
80101e69:	83 3d 60 95 10 80 00 	cmpl   $0x0,0x80109560
80101e70:	74 38                	je     80101eaa <iderw+0x6b>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101e72:	83 ec 0c             	sub    $0xc,%esp
80101e75:	68 80 95 10 80       	push   $0x80109580
80101e7a:	e8 69 1d 00 00       	call   80103be8 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101e7f:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e86:	83 c4 10             	add    $0x10,%esp
80101e89:	ba 64 95 10 80       	mov    $0x80109564,%edx
80101e8e:	eb 2a                	jmp    80101eba <iderw+0x7b>
    panic("iderw: buf not locked");
80101e90:	83 ec 0c             	sub    $0xc,%esp
80101e93:	68 52 66 10 80       	push   $0x80106652
80101e98:	e8 ab e4 ff ff       	call   80100348 <panic>
    panic("iderw: nothing to do");
80101e9d:	83 ec 0c             	sub    $0xc,%esp
80101ea0:	68 68 66 10 80       	push   $0x80106668
80101ea5:	e8 9e e4 ff ff       	call   80100348 <panic>
    panic("iderw: ide disk 1 not present");
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	68 7d 66 10 80       	push   $0x8010667d
80101eb2:	e8 91 e4 ff ff       	call   80100348 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101eb7:	8d 50 58             	lea    0x58(%eax),%edx
80101eba:	8b 02                	mov    (%edx),%eax
80101ebc:	85 c0                	test   %eax,%eax
80101ebe:	75 f7                	jne    80101eb7 <iderw+0x78>
    ;
  *pp = b;
80101ec0:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101ec2:	39 1d 64 95 10 80    	cmp    %ebx,0x80109564
80101ec8:	75 1a                	jne    80101ee4 <iderw+0xa5>
    idestart(b);
80101eca:	89 d8                	mov    %ebx,%eax
80101ecc:	e8 a5 fd ff ff       	call   80101c76 <idestart>
80101ed1:	eb 11                	jmp    80101ee4 <iderw+0xa5>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101ed3:	83 ec 08             	sub    $0x8,%esp
80101ed6:	68 80 95 10 80       	push   $0x80109580
80101edb:	53                   	push   %ebx
80101edc:	e8 27 18 00 00       	call   80103708 <sleep>
80101ee1:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101ee4:	8b 03                	mov    (%ebx),%eax
80101ee6:	83 e0 06             	and    $0x6,%eax
80101ee9:	83 f8 02             	cmp    $0x2,%eax
80101eec:	75 e5                	jne    80101ed3 <iderw+0x94>
  }


  release(&idelock);
80101eee:	83 ec 0c             	sub    $0xc,%esp
80101ef1:	68 80 95 10 80       	push   $0x80109580
80101ef6:	e8 52 1d 00 00       	call   80103c4d <release>
}
80101efb:	83 c4 10             	add    $0x10,%esp
80101efe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f01:	c9                   	leave  
80101f02:	c3                   	ret    

80101f03 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80101f03:	55                   	push   %ebp
80101f04:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80101f06:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80101f0c:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101f0e:	a1 94 36 11 80       	mov    0x80113694,%eax
80101f13:	8b 40 10             	mov    0x10(%eax),%eax
}
80101f16:	5d                   	pop    %ebp
80101f17:	c3                   	ret    

80101f18 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80101f18:	55                   	push   %ebp
80101f19:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80101f1b:	8b 0d 94 36 11 80    	mov    0x80113694,%ecx
80101f21:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101f23:	a1 94 36 11 80       	mov    0x80113694,%eax
80101f28:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f2b:	5d                   	pop    %ebp
80101f2c:	c3                   	ret    

80101f2d <ioapicinit>:

void
ioapicinit(void)
{
80101f2d:	55                   	push   %ebp
80101f2e:	89 e5                	mov    %esp,%ebp
80101f30:	57                   	push   %edi
80101f31:	56                   	push   %esi
80101f32:	53                   	push   %ebx
80101f33:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101f36:	c7 05 94 36 11 80 00 	movl   $0xfec00000,0x80113694
80101f3d:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101f40:	b8 01 00 00 00       	mov    $0x1,%eax
80101f45:	e8 b9 ff ff ff       	call   80101f03 <ioapicread>
80101f4a:	c1 e8 10             	shr    $0x10,%eax
80101f4d:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101f50:	b8 00 00 00 00       	mov    $0x0,%eax
80101f55:	e8 a9 ff ff ff       	call   80101f03 <ioapicread>
80101f5a:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101f5d:	0f b6 15 c0 37 11 80 	movzbl 0x801137c0,%edx
80101f64:	39 c2                	cmp    %eax,%edx
80101f66:	75 07                	jne    80101f6f <ioapicinit+0x42>
{
80101f68:	bb 00 00 00 00       	mov    $0x0,%ebx
80101f6d:	eb 36                	jmp    80101fa5 <ioapicinit+0x78>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101f6f:	83 ec 0c             	sub    $0xc,%esp
80101f72:	68 9c 66 10 80       	push   $0x8010669c
80101f77:	e8 8f e6 ff ff       	call   8010060b <cprintf>
80101f7c:	83 c4 10             	add    $0x10,%esp
80101f7f:	eb e7                	jmp    80101f68 <ioapicinit+0x3b>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101f81:	8d 53 20             	lea    0x20(%ebx),%edx
80101f84:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101f8a:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101f8e:	89 f0                	mov    %esi,%eax
80101f90:	e8 83 ff ff ff       	call   80101f18 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101f95:	8d 46 01             	lea    0x1(%esi),%eax
80101f98:	ba 00 00 00 00       	mov    $0x0,%edx
80101f9d:	e8 76 ff ff ff       	call   80101f18 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101fa2:	83 c3 01             	add    $0x1,%ebx
80101fa5:	39 fb                	cmp    %edi,%ebx
80101fa7:	7e d8                	jle    80101f81 <ioapicinit+0x54>
  }
}
80101fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fac:	5b                   	pop    %ebx
80101fad:	5e                   	pop    %esi
80101fae:	5f                   	pop    %edi
80101faf:	5d                   	pop    %ebp
80101fb0:	c3                   	ret    

80101fb1 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101fb1:	55                   	push   %ebp
80101fb2:	89 e5                	mov    %esp,%ebp
80101fb4:	53                   	push   %ebx
80101fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80101fb8:	8d 50 20             	lea    0x20(%eax),%edx
80101fbb:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80101fbf:	89 d8                	mov    %ebx,%eax
80101fc1:	e8 52 ff ff ff       	call   80101f18 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80101fc6:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fc9:	c1 e2 18             	shl    $0x18,%edx
80101fcc:	8d 43 01             	lea    0x1(%ebx),%eax
80101fcf:	e8 44 ff ff ff       	call   80101f18 <ioapicwrite>
}
80101fd4:	5b                   	pop    %ebx
80101fd5:	5d                   	pop    %ebp
80101fd6:	c3                   	ret    

80101fd7 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80101fd7:	55                   	push   %ebp
80101fd8:	89 e5                	mov    %esp,%ebp
80101fda:	53                   	push   %ebx
80101fdb:	83 ec 04             	sub    $0x4,%esp
80101fde:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80101fe1:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80101fe7:	75 4c                	jne    80102035 <kfree+0x5e>
80101fe9:	81 fb 88 45 11 80    	cmp    $0x80114588,%ebx
80101fef:	72 44                	jb     80102035 <kfree+0x5e>
80101ff1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80101ff7:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80101ffc:	77 37                	ja     80102035 <kfree+0x5e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80101ffe:	83 ec 04             	sub    $0x4,%esp
80102001:	68 00 10 00 00       	push   $0x1000
80102006:	6a 01                	push   $0x1
80102008:	53                   	push   %ebx
80102009:	e8 86 1c 00 00       	call   80103c94 <memset>

  if(kmem.use_lock)
8010200e:	83 c4 10             	add    $0x10,%esp
80102011:	83 3d d4 36 11 80 00 	cmpl   $0x0,0x801136d4
80102018:	75 28                	jne    80102042 <kfree+0x6b>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
8010201a:	a1 d8 36 11 80       	mov    0x801136d8,%eax
8010201f:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102021:	89 1d d8 36 11 80    	mov    %ebx,0x801136d8
  if(kmem.use_lock)
80102027:	83 3d d4 36 11 80 00 	cmpl   $0x0,0x801136d4
8010202e:	75 24                	jne    80102054 <kfree+0x7d>
    release(&kmem.lock);
}
80102030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102033:	c9                   	leave  
80102034:	c3                   	ret    
    panic("kfree");
80102035:	83 ec 0c             	sub    $0xc,%esp
80102038:	68 ce 66 10 80       	push   $0x801066ce
8010203d:	e8 06 e3 ff ff       	call   80100348 <panic>
    acquire(&kmem.lock);
80102042:	83 ec 0c             	sub    $0xc,%esp
80102045:	68 a0 36 11 80       	push   $0x801136a0
8010204a:	e8 99 1b 00 00       	call   80103be8 <acquire>
8010204f:	83 c4 10             	add    $0x10,%esp
80102052:	eb c6                	jmp    8010201a <kfree+0x43>
    release(&kmem.lock);
80102054:	83 ec 0c             	sub    $0xc,%esp
80102057:	68 a0 36 11 80       	push   $0x801136a0
8010205c:	e8 ec 1b 00 00       	call   80103c4d <release>
80102061:	83 c4 10             	add    $0x10,%esp
}
80102064:	eb ca                	jmp    80102030 <kfree+0x59>

80102066 <freerange>:
{
80102066:	55                   	push   %ebp
80102067:	89 e5                	mov    %esp,%ebp
80102069:	56                   	push   %esi
8010206a:	53                   	push   %ebx
8010206b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010206e:	8b 45 08             	mov    0x8(%ebp),%eax
80102071:	05 ff 0f 00 00       	add    $0xfff,%eax
80102076:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010207b:	eb 0e                	jmp    8010208b <freerange+0x25>
    kfree(p);
8010207d:	83 ec 0c             	sub    $0xc,%esp
80102080:	50                   	push   %eax
80102081:	e8 51 ff ff ff       	call   80101fd7 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102086:	83 c4 10             	add    $0x10,%esp
80102089:	89 f0                	mov    %esi,%eax
8010208b:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
80102091:	39 de                	cmp    %ebx,%esi
80102093:	76 e8                	jbe    8010207d <freerange+0x17>
}
80102095:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102098:	5b                   	pop    %ebx
80102099:	5e                   	pop    %esi
8010209a:	5d                   	pop    %ebp
8010209b:	c3                   	ret    

8010209c <kinit1>:
{
8010209c:	55                   	push   %ebp
8010209d:	89 e5                	mov    %esp,%ebp
8010209f:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
801020a2:	68 d4 66 10 80       	push   $0x801066d4
801020a7:	68 a0 36 11 80       	push   $0x801136a0
801020ac:	e8 fb 19 00 00       	call   80103aac <initlock>
  kmem.use_lock = 0;
801020b1:	c7 05 d4 36 11 80 00 	movl   $0x0,0x801136d4
801020b8:	00 00 00 
  freerange(vstart, vend);
801020bb:	83 c4 08             	add    $0x8,%esp
801020be:	ff 75 0c             	pushl  0xc(%ebp)
801020c1:	ff 75 08             	pushl  0x8(%ebp)
801020c4:	e8 9d ff ff ff       	call   80102066 <freerange>
}
801020c9:	83 c4 10             	add    $0x10,%esp
801020cc:	c9                   	leave  
801020cd:	c3                   	ret    

801020ce <kinit2>:
{
801020ce:	55                   	push   %ebp
801020cf:	89 e5                	mov    %esp,%ebp
801020d1:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
801020d4:	ff 75 0c             	pushl  0xc(%ebp)
801020d7:	ff 75 08             	pushl  0x8(%ebp)
801020da:	e8 87 ff ff ff       	call   80102066 <freerange>
  kmem.use_lock = 1;
801020df:	c7 05 d4 36 11 80 01 	movl   $0x1,0x801136d4
801020e6:	00 00 00 
}
801020e9:	83 c4 10             	add    $0x10,%esp
801020ec:	c9                   	leave  
801020ed:	c3                   	ret    

801020ee <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801020ee:	55                   	push   %ebp
801020ef:	89 e5                	mov    %esp,%ebp
801020f1:	53                   	push   %ebx
801020f2:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801020f5:	83 3d d4 36 11 80 00 	cmpl   $0x0,0x801136d4
801020fc:	75 21                	jne    8010211f <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
801020fe:	8b 1d d8 36 11 80    	mov    0x801136d8,%ebx
  if(r)
80102104:	85 db                	test   %ebx,%ebx
80102106:	74 07                	je     8010210f <kalloc+0x21>
    kmem.freelist = r->next;
80102108:	8b 03                	mov    (%ebx),%eax
8010210a:	a3 d8 36 11 80       	mov    %eax,0x801136d8
  if(kmem.use_lock)
8010210f:	83 3d d4 36 11 80 00 	cmpl   $0x0,0x801136d4
80102116:	75 19                	jne    80102131 <kalloc+0x43>
    release(&kmem.lock);
  return (char*)r;
}
80102118:	89 d8                	mov    %ebx,%eax
8010211a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010211d:	c9                   	leave  
8010211e:	c3                   	ret    
    acquire(&kmem.lock);
8010211f:	83 ec 0c             	sub    $0xc,%esp
80102122:	68 a0 36 11 80       	push   $0x801136a0
80102127:	e8 bc 1a 00 00       	call   80103be8 <acquire>
8010212c:	83 c4 10             	add    $0x10,%esp
8010212f:	eb cd                	jmp    801020fe <kalloc+0x10>
    release(&kmem.lock);
80102131:	83 ec 0c             	sub    $0xc,%esp
80102134:	68 a0 36 11 80       	push   $0x801136a0
80102139:	e8 0f 1b 00 00       	call   80103c4d <release>
8010213e:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102141:	eb d5                	jmp    80102118 <kalloc+0x2a>

80102143 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102143:	55                   	push   %ebp
80102144:	89 e5                	mov    %esp,%ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102146:	ba 64 00 00 00       	mov    $0x64,%edx
8010214b:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010214c:	a8 01                	test   $0x1,%al
8010214e:	0f 84 b5 00 00 00    	je     80102209 <kbdgetc+0xc6>
80102154:	ba 60 00 00 00       	mov    $0x60,%edx
80102159:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010215a:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010215d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102163:	74 5c                	je     801021c1 <kbdgetc+0x7e>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102165:	84 c0                	test   %al,%al
80102167:	78 66                	js     801021cf <kbdgetc+0x8c>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102169:	8b 0d b4 95 10 80    	mov    0x801095b4,%ecx
8010216f:	f6 c1 40             	test   $0x40,%cl
80102172:	74 0f                	je     80102183 <kbdgetc+0x40>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102174:	83 c8 80             	or     $0xffffff80,%eax
80102177:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
8010217a:	83 e1 bf             	and    $0xffffffbf,%ecx
8010217d:	89 0d b4 95 10 80    	mov    %ecx,0x801095b4
  }

  shift |= shiftcode[data];
80102183:	0f b6 8a 00 68 10 80 	movzbl -0x7fef9800(%edx),%ecx
8010218a:	0b 0d b4 95 10 80    	or     0x801095b4,%ecx
  shift ^= togglecode[data];
80102190:	0f b6 82 00 67 10 80 	movzbl -0x7fef9900(%edx),%eax
80102197:	31 c1                	xor    %eax,%ecx
80102199:	89 0d b4 95 10 80    	mov    %ecx,0x801095b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010219f:	89 c8                	mov    %ecx,%eax
801021a1:	83 e0 03             	and    $0x3,%eax
801021a4:	8b 04 85 e0 66 10 80 	mov    -0x7fef9920(,%eax,4),%eax
801021ab:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801021af:	f6 c1 08             	test   $0x8,%cl
801021b2:	74 19                	je     801021cd <kbdgetc+0x8a>
    if('a' <= c && c <= 'z')
801021b4:	8d 50 9f             	lea    -0x61(%eax),%edx
801021b7:	83 fa 19             	cmp    $0x19,%edx
801021ba:	77 40                	ja     801021fc <kbdgetc+0xb9>
      c += 'A' - 'a';
801021bc:	83 e8 20             	sub    $0x20,%eax
801021bf:	eb 0c                	jmp    801021cd <kbdgetc+0x8a>
    shift |= E0ESC;
801021c1:	83 0d b4 95 10 80 40 	orl    $0x40,0x801095b4
    return 0;
801021c8:	b8 00 00 00 00       	mov    $0x0,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801021cd:	5d                   	pop    %ebp
801021ce:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801021cf:	8b 0d b4 95 10 80    	mov    0x801095b4,%ecx
801021d5:	f6 c1 40             	test   $0x40,%cl
801021d8:	75 05                	jne    801021df <kbdgetc+0x9c>
801021da:	89 c2                	mov    %eax,%edx
801021dc:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801021df:	0f b6 82 00 68 10 80 	movzbl -0x7fef9800(%edx),%eax
801021e6:	83 c8 40             	or     $0x40,%eax
801021e9:	0f b6 c0             	movzbl %al,%eax
801021ec:	f7 d0                	not    %eax
801021ee:	21 c8                	and    %ecx,%eax
801021f0:	a3 b4 95 10 80       	mov    %eax,0x801095b4
    return 0;
801021f5:	b8 00 00 00 00       	mov    $0x0,%eax
801021fa:	eb d1                	jmp    801021cd <kbdgetc+0x8a>
    else if('A' <= c && c <= 'Z')
801021fc:	8d 50 bf             	lea    -0x41(%eax),%edx
801021ff:	83 fa 19             	cmp    $0x19,%edx
80102202:	77 c9                	ja     801021cd <kbdgetc+0x8a>
      c += 'a' - 'A';
80102204:	83 c0 20             	add    $0x20,%eax
  return c;
80102207:	eb c4                	jmp    801021cd <kbdgetc+0x8a>
    return -1;
80102209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010220e:	eb bd                	jmp    801021cd <kbdgetc+0x8a>

80102210 <kbdintr>:

void
kbdintr(void)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102216:	68 43 21 10 80       	push   $0x80102143
8010221b:	e8 3f e5 ff ff       	call   8010075f <consoleintr>
}
80102220:	83 c4 10             	add    $0x10,%esp
80102223:	c9                   	leave  
80102224:	c3                   	ret    

80102225 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102225:	55                   	push   %ebp
80102226:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102228:	8b 0d dc 36 11 80    	mov    0x801136dc,%ecx
8010222e:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80102231:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102233:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102238:	8b 40 20             	mov    0x20(%eax),%eax
}
8010223b:	5d                   	pop    %ebp
8010223c:	c3                   	ret    

8010223d <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010223d:	55                   	push   %ebp
8010223e:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102240:	ba 70 00 00 00       	mov    $0x70,%edx
80102245:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102246:	ba 71 00 00 00       	mov    $0x71,%edx
8010224b:	ec                   	in     (%dx),%al
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
8010224c:	0f b6 c0             	movzbl %al,%eax
}
8010224f:	5d                   	pop    %ebp
80102250:	c3                   	ret    

80102251 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80102251:	55                   	push   %ebp
80102252:	89 e5                	mov    %esp,%ebp
80102254:	53                   	push   %ebx
80102255:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
80102257:	b8 00 00 00 00       	mov    $0x0,%eax
8010225c:	e8 dc ff ff ff       	call   8010223d <cmos_read>
80102261:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
80102263:	b8 02 00 00 00       	mov    $0x2,%eax
80102268:	e8 d0 ff ff ff       	call   8010223d <cmos_read>
8010226d:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
80102270:	b8 04 00 00 00       	mov    $0x4,%eax
80102275:	e8 c3 ff ff ff       	call   8010223d <cmos_read>
8010227a:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
8010227d:	b8 07 00 00 00       	mov    $0x7,%eax
80102282:	e8 b6 ff ff ff       	call   8010223d <cmos_read>
80102287:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
8010228a:	b8 08 00 00 00       	mov    $0x8,%eax
8010228f:	e8 a9 ff ff ff       	call   8010223d <cmos_read>
80102294:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
80102297:	b8 09 00 00 00       	mov    $0x9,%eax
8010229c:	e8 9c ff ff ff       	call   8010223d <cmos_read>
801022a1:	89 43 14             	mov    %eax,0x14(%ebx)
}
801022a4:	5b                   	pop    %ebx
801022a5:	5d                   	pop    %ebp
801022a6:	c3                   	ret    

801022a7 <lapicinit>:
  if(!lapic)
801022a7:	83 3d dc 36 11 80 00 	cmpl   $0x0,0x801136dc
801022ae:	0f 84 fb 00 00 00    	je     801023af <lapicinit+0x108>
{
801022b4:	55                   	push   %ebp
801022b5:	89 e5                	mov    %esp,%ebp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801022b7:	ba 3f 01 00 00       	mov    $0x13f,%edx
801022bc:	b8 3c 00 00 00       	mov    $0x3c,%eax
801022c1:	e8 5f ff ff ff       	call   80102225 <lapicw>
  lapicw(TDCR, X1);
801022c6:	ba 0b 00 00 00       	mov    $0xb,%edx
801022cb:	b8 f8 00 00 00       	mov    $0xf8,%eax
801022d0:	e8 50 ff ff ff       	call   80102225 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801022d5:	ba 20 00 02 00       	mov    $0x20020,%edx
801022da:	b8 c8 00 00 00       	mov    $0xc8,%eax
801022df:	e8 41 ff ff ff       	call   80102225 <lapicw>
  lapicw(TICR, 1000000);
801022e4:	ba 40 42 0f 00       	mov    $0xf4240,%edx
801022e9:	b8 e0 00 00 00       	mov    $0xe0,%eax
801022ee:	e8 32 ff ff ff       	call   80102225 <lapicw>
  lapicw(LINT0, MASKED);
801022f3:	ba 00 00 01 00       	mov    $0x10000,%edx
801022f8:	b8 d4 00 00 00       	mov    $0xd4,%eax
801022fd:	e8 23 ff ff ff       	call   80102225 <lapicw>
  lapicw(LINT1, MASKED);
80102302:	ba 00 00 01 00       	mov    $0x10000,%edx
80102307:	b8 d8 00 00 00       	mov    $0xd8,%eax
8010230c:	e8 14 ff ff ff       	call   80102225 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102311:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102316:	8b 40 30             	mov    0x30(%eax),%eax
80102319:	c1 e8 10             	shr    $0x10,%eax
8010231c:	3c 03                	cmp    $0x3,%al
8010231e:	77 7b                	ja     8010239b <lapicinit+0xf4>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102320:	ba 33 00 00 00       	mov    $0x33,%edx
80102325:	b8 dc 00 00 00       	mov    $0xdc,%eax
8010232a:	e8 f6 fe ff ff       	call   80102225 <lapicw>
  lapicw(ESR, 0);
8010232f:	ba 00 00 00 00       	mov    $0x0,%edx
80102334:	b8 a0 00 00 00       	mov    $0xa0,%eax
80102339:	e8 e7 fe ff ff       	call   80102225 <lapicw>
  lapicw(ESR, 0);
8010233e:	ba 00 00 00 00       	mov    $0x0,%edx
80102343:	b8 a0 00 00 00       	mov    $0xa0,%eax
80102348:	e8 d8 fe ff ff       	call   80102225 <lapicw>
  lapicw(EOI, 0);
8010234d:	ba 00 00 00 00       	mov    $0x0,%edx
80102352:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102357:	e8 c9 fe ff ff       	call   80102225 <lapicw>
  lapicw(ICRHI, 0);
8010235c:	ba 00 00 00 00       	mov    $0x0,%edx
80102361:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102366:	e8 ba fe ff ff       	call   80102225 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010236b:	ba 00 85 08 00       	mov    $0x88500,%edx
80102370:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102375:	e8 ab fe ff ff       	call   80102225 <lapicw>
  while(lapic[ICRLO] & DELIVS)
8010237a:	a1 dc 36 11 80       	mov    0x801136dc,%eax
8010237f:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
80102385:	f6 c4 10             	test   $0x10,%ah
80102388:	75 f0                	jne    8010237a <lapicinit+0xd3>
  lapicw(TPR, 0);
8010238a:	ba 00 00 00 00       	mov    $0x0,%edx
8010238f:	b8 20 00 00 00       	mov    $0x20,%eax
80102394:	e8 8c fe ff ff       	call   80102225 <lapicw>
}
80102399:	5d                   	pop    %ebp
8010239a:	c3                   	ret    
    lapicw(PCINT, MASKED);
8010239b:	ba 00 00 01 00       	mov    $0x10000,%edx
801023a0:	b8 d0 00 00 00       	mov    $0xd0,%eax
801023a5:	e8 7b fe ff ff       	call   80102225 <lapicw>
801023aa:	e9 71 ff ff ff       	jmp    80102320 <lapicinit+0x79>
801023af:	f3 c3                	repz ret 

801023b1 <lapicid>:
{
801023b1:	55                   	push   %ebp
801023b2:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801023b4:	a1 dc 36 11 80       	mov    0x801136dc,%eax
801023b9:	85 c0                	test   %eax,%eax
801023bb:	74 08                	je     801023c5 <lapicid+0x14>
  return lapic[ID] >> 24;
801023bd:	8b 40 20             	mov    0x20(%eax),%eax
801023c0:	c1 e8 18             	shr    $0x18,%eax
}
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
    return 0;
801023c5:	b8 00 00 00 00       	mov    $0x0,%eax
801023ca:	eb f7                	jmp    801023c3 <lapicid+0x12>

801023cc <lapiceoi>:
  if(lapic)
801023cc:	83 3d dc 36 11 80 00 	cmpl   $0x0,0x801136dc
801023d3:	74 14                	je     801023e9 <lapiceoi+0x1d>
{
801023d5:	55                   	push   %ebp
801023d6:	89 e5                	mov    %esp,%ebp
    lapicw(EOI, 0);
801023d8:	ba 00 00 00 00       	mov    $0x0,%edx
801023dd:	b8 2c 00 00 00       	mov    $0x2c,%eax
801023e2:	e8 3e fe ff ff       	call   80102225 <lapicw>
}
801023e7:	5d                   	pop    %ebp
801023e8:	c3                   	ret    
801023e9:	f3 c3                	repz ret 

801023eb <microdelay>:
{
801023eb:	55                   	push   %ebp
801023ec:	89 e5                	mov    %esp,%ebp
}
801023ee:	5d                   	pop    %ebp
801023ef:	c3                   	ret    

801023f0 <lapicstartap>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	57                   	push   %edi
801023f4:	56                   	push   %esi
801023f5:	53                   	push   %ebx
801023f6:	8b 75 08             	mov    0x8(%ebp),%esi
801023f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023fc:	b8 0f 00 00 00       	mov    $0xf,%eax
80102401:	ba 70 00 00 00       	mov    $0x70,%edx
80102406:	ee                   	out    %al,(%dx)
80102407:	b8 0a 00 00 00       	mov    $0xa,%eax
8010240c:	ba 71 00 00 00       	mov    $0x71,%edx
80102411:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
80102412:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
80102419:	00 00 
  wrv[1] = addr >> 4;
8010241b:	89 f8                	mov    %edi,%eax
8010241d:	c1 e8 04             	shr    $0x4,%eax
80102420:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
80102426:	c1 e6 18             	shl    $0x18,%esi
80102429:	89 f2                	mov    %esi,%edx
8010242b:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102430:	e8 f0 fd ff ff       	call   80102225 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102435:	ba 00 c5 00 00       	mov    $0xc500,%edx
8010243a:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010243f:	e8 e1 fd ff ff       	call   80102225 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
80102444:	ba 00 85 00 00       	mov    $0x8500,%edx
80102449:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010244e:	e8 d2 fd ff ff       	call   80102225 <lapicw>
  for(i = 0; i < 2; i++){
80102453:	bb 00 00 00 00       	mov    $0x0,%ebx
80102458:	eb 21                	jmp    8010247b <lapicstartap+0x8b>
    lapicw(ICRHI, apicid<<24);
8010245a:	89 f2                	mov    %esi,%edx
8010245c:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102461:	e8 bf fd ff ff       	call   80102225 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102466:	89 fa                	mov    %edi,%edx
80102468:	c1 ea 0c             	shr    $0xc,%edx
8010246b:	80 ce 06             	or     $0x6,%dh
8010246e:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102473:	e8 ad fd ff ff       	call   80102225 <lapicw>
  for(i = 0; i < 2; i++){
80102478:	83 c3 01             	add    $0x1,%ebx
8010247b:	83 fb 01             	cmp    $0x1,%ebx
8010247e:	7e da                	jle    8010245a <lapicstartap+0x6a>
}
80102480:	5b                   	pop    %ebx
80102481:	5e                   	pop    %esi
80102482:	5f                   	pop    %edi
80102483:	5d                   	pop    %ebp
80102484:	c3                   	ret    

80102485 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102485:	55                   	push   %ebp
80102486:	89 e5                	mov    %esp,%ebp
80102488:	57                   	push   %edi
80102489:	56                   	push   %esi
8010248a:	53                   	push   %ebx
8010248b:	83 ec 3c             	sub    $0x3c,%esp
8010248e:	8b 75 08             	mov    0x8(%ebp),%esi
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80102491:	b8 0b 00 00 00       	mov    $0xb,%eax
80102496:	e8 a2 fd ff ff       	call   8010223d <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
8010249b:	83 e0 04             	and    $0x4,%eax
8010249e:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801024a0:	8d 45 d0             	lea    -0x30(%ebp),%eax
801024a3:	e8 a9 fd ff ff       	call   80102251 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801024a8:	b8 0a 00 00 00       	mov    $0xa,%eax
801024ad:	e8 8b fd ff ff       	call   8010223d <cmos_read>
801024b2:	a8 80                	test   $0x80,%al
801024b4:	75 ea                	jne    801024a0 <cmostime+0x1b>
        continue;
    fill_rtcdate(&t2);
801024b6:	8d 5d b8             	lea    -0x48(%ebp),%ebx
801024b9:	89 d8                	mov    %ebx,%eax
801024bb:	e8 91 fd ff ff       	call   80102251 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801024c0:	83 ec 04             	sub    $0x4,%esp
801024c3:	6a 18                	push   $0x18
801024c5:	53                   	push   %ebx
801024c6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801024c9:	50                   	push   %eax
801024ca:	e8 0b 18 00 00       	call   80103cda <memcmp>
801024cf:	83 c4 10             	add    $0x10,%esp
801024d2:	85 c0                	test   %eax,%eax
801024d4:	75 ca                	jne    801024a0 <cmostime+0x1b>
      break;
  }

  // convert
  if(bcd) {
801024d6:	85 ff                	test   %edi,%edi
801024d8:	0f 85 84 00 00 00    	jne    80102562 <cmostime+0xdd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801024de:	8b 55 d0             	mov    -0x30(%ebp),%edx
801024e1:	89 d0                	mov    %edx,%eax
801024e3:	c1 e8 04             	shr    $0x4,%eax
801024e6:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801024e9:	8d 04 09             	lea    (%ecx,%ecx,1),%eax
801024ec:	83 e2 0f             	and    $0xf,%edx
801024ef:	01 d0                	add    %edx,%eax
801024f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
801024f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801024f7:	89 d0                	mov    %edx,%eax
801024f9:	c1 e8 04             	shr    $0x4,%eax
801024fc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801024ff:	8d 04 09             	lea    (%ecx,%ecx,1),%eax
80102502:	83 e2 0f             	and    $0xf,%edx
80102505:	01 d0                	add    %edx,%eax
80102507:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
8010250a:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010250d:	89 d0                	mov    %edx,%eax
8010250f:	c1 e8 04             	shr    $0x4,%eax
80102512:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102515:	8d 04 09             	lea    (%ecx,%ecx,1),%eax
80102518:	83 e2 0f             	and    $0xf,%edx
8010251b:	01 d0                	add    %edx,%eax
8010251d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
80102520:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102523:	89 d0                	mov    %edx,%eax
80102525:	c1 e8 04             	shr    $0x4,%eax
80102528:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010252b:	8d 04 09             	lea    (%ecx,%ecx,1),%eax
8010252e:	83 e2 0f             	and    $0xf,%edx
80102531:	01 d0                	add    %edx,%eax
80102533:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
80102536:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102539:	89 d0                	mov    %edx,%eax
8010253b:	c1 e8 04             	shr    $0x4,%eax
8010253e:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102541:	8d 04 09             	lea    (%ecx,%ecx,1),%eax
80102544:	83 e2 0f             	and    $0xf,%edx
80102547:	01 d0                	add    %edx,%eax
80102549:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
8010254c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010254f:	89 d0                	mov    %edx,%eax
80102551:	c1 e8 04             	shr    $0x4,%eax
80102554:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102557:	8d 04 09             	lea    (%ecx,%ecx,1),%eax
8010255a:	83 e2 0f             	and    $0xf,%edx
8010255d:	01 d0                	add    %edx,%eax
8010255f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
80102562:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102565:	89 06                	mov    %eax,(%esi)
80102567:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010256a:	89 46 04             	mov    %eax,0x4(%esi)
8010256d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102570:	89 46 08             	mov    %eax,0x8(%esi)
80102573:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102576:	89 46 0c             	mov    %eax,0xc(%esi)
80102579:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010257c:	89 46 10             	mov    %eax,0x10(%esi)
8010257f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102582:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102585:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010258c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010258f:	5b                   	pop    %ebx
80102590:	5e                   	pop    %esi
80102591:	5f                   	pop    %edi
80102592:	5d                   	pop    %ebp
80102593:	c3                   	ret    

80102594 <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80102594:	55                   	push   %ebp
80102595:	89 e5                	mov    %esp,%ebp
80102597:	53                   	push   %ebx
80102598:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
8010259b:	ff 35 14 37 11 80    	pushl  0x80113714
801025a1:	ff 35 24 37 11 80    	pushl  0x80113724
801025a7:	e8 c0 db ff ff       	call   8010016c <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
801025ac:	8b 58 5c             	mov    0x5c(%eax),%ebx
801025af:	89 1d 28 37 11 80    	mov    %ebx,0x80113728
  for (i = 0; i < log.lh.n; i++) {
801025b5:	83 c4 10             	add    $0x10,%esp
801025b8:	ba 00 00 00 00       	mov    $0x0,%edx
801025bd:	eb 0e                	jmp    801025cd <read_head+0x39>
    log.lh.block[i] = lh->block[i];
801025bf:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801025c3:	89 0c 95 2c 37 11 80 	mov    %ecx,-0x7feec8d4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801025ca:	83 c2 01             	add    $0x1,%edx
801025cd:	39 d3                	cmp    %edx,%ebx
801025cf:	7f ee                	jg     801025bf <read_head+0x2b>
  }
  brelse(buf);
801025d1:	83 ec 0c             	sub    $0xc,%esp
801025d4:	50                   	push   %eax
801025d5:	e8 fb db ff ff       	call   801001d5 <brelse>
}
801025da:	83 c4 10             	add    $0x10,%esp
801025dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025e0:	c9                   	leave  
801025e1:	c3                   	ret    

801025e2 <install_trans>:
{
801025e2:	55                   	push   %ebp
801025e3:	89 e5                	mov    %esp,%ebp
801025e5:	57                   	push   %edi
801025e6:	56                   	push   %esi
801025e7:	53                   	push   %ebx
801025e8:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801025eb:	bb 00 00 00 00       	mov    $0x0,%ebx
801025f0:	eb 66                	jmp    80102658 <install_trans+0x76>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801025f2:	89 d8                	mov    %ebx,%eax
801025f4:	03 05 14 37 11 80    	add    0x80113714,%eax
801025fa:	83 c0 01             	add    $0x1,%eax
801025fd:	83 ec 08             	sub    $0x8,%esp
80102600:	50                   	push   %eax
80102601:	ff 35 24 37 11 80    	pushl  0x80113724
80102607:	e8 60 db ff ff       	call   8010016c <bread>
8010260c:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010260e:	83 c4 08             	add    $0x8,%esp
80102611:	ff 34 9d 2c 37 11 80 	pushl  -0x7feec8d4(,%ebx,4)
80102618:	ff 35 24 37 11 80    	pushl  0x80113724
8010261e:	e8 49 db ff ff       	call   8010016c <bread>
80102623:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102625:	8d 57 5c             	lea    0x5c(%edi),%edx
80102628:	8d 40 5c             	lea    0x5c(%eax),%eax
8010262b:	83 c4 0c             	add    $0xc,%esp
8010262e:	68 00 02 00 00       	push   $0x200
80102633:	52                   	push   %edx
80102634:	50                   	push   %eax
80102635:	e8 d5 16 00 00       	call   80103d0f <memmove>
    bwrite(dbuf);  // write dst to disk
8010263a:	89 34 24             	mov    %esi,(%esp)
8010263d:	e8 58 db ff ff       	call   8010019a <bwrite>
    brelse(lbuf);
80102642:	89 3c 24             	mov    %edi,(%esp)
80102645:	e8 8b db ff ff       	call   801001d5 <brelse>
    brelse(dbuf);
8010264a:	89 34 24             	mov    %esi,(%esp)
8010264d:	e8 83 db ff ff       	call   801001d5 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102652:	83 c3 01             	add    $0x1,%ebx
80102655:	83 c4 10             	add    $0x10,%esp
80102658:	39 1d 28 37 11 80    	cmp    %ebx,0x80113728
8010265e:	7f 92                	jg     801025f2 <install_trans+0x10>
}
80102660:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102663:	5b                   	pop    %ebx
80102664:	5e                   	pop    %esi
80102665:	5f                   	pop    %edi
80102666:	5d                   	pop    %ebp
80102667:	c3                   	ret    

80102668 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102668:	55                   	push   %ebp
80102669:	89 e5                	mov    %esp,%ebp
8010266b:	53                   	push   %ebx
8010266c:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
8010266f:	ff 35 14 37 11 80    	pushl  0x80113714
80102675:	ff 35 24 37 11 80    	pushl  0x80113724
8010267b:	e8 ec da ff ff       	call   8010016c <bread>
80102680:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102682:	8b 0d 28 37 11 80    	mov    0x80113728,%ecx
80102688:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010268b:	83 c4 10             	add    $0x10,%esp
8010268e:	b8 00 00 00 00       	mov    $0x0,%eax
80102693:	eb 0e                	jmp    801026a3 <write_head+0x3b>
    hb->block[i] = log.lh.block[i];
80102695:	8b 14 85 2c 37 11 80 	mov    -0x7feec8d4(,%eax,4),%edx
8010269c:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
801026a0:	83 c0 01             	add    $0x1,%eax
801026a3:	39 c1                	cmp    %eax,%ecx
801026a5:	7f ee                	jg     80102695 <write_head+0x2d>
  }
  bwrite(buf);
801026a7:	83 ec 0c             	sub    $0xc,%esp
801026aa:	53                   	push   %ebx
801026ab:	e8 ea da ff ff       	call   8010019a <bwrite>
  brelse(buf);
801026b0:	89 1c 24             	mov    %ebx,(%esp)
801026b3:	e8 1d db ff ff       	call   801001d5 <brelse>
}
801026b8:	83 c4 10             	add    $0x10,%esp
801026bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026be:	c9                   	leave  
801026bf:	c3                   	ret    

801026c0 <recover_from_log>:

static void
recover_from_log(void)
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	83 ec 08             	sub    $0x8,%esp
  read_head();
801026c6:	e8 c9 fe ff ff       	call   80102594 <read_head>
  install_trans(); // if committed, copy from log to disk
801026cb:	e8 12 ff ff ff       	call   801025e2 <install_trans>
  log.lh.n = 0;
801026d0:	c7 05 28 37 11 80 00 	movl   $0x0,0x80113728
801026d7:	00 00 00 
  write_head(); // clear the log
801026da:	e8 89 ff ff ff       	call   80102668 <write_head>
}
801026df:	c9                   	leave  
801026e0:	c3                   	ret    

801026e1 <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801026e1:	55                   	push   %ebp
801026e2:	89 e5                	mov    %esp,%ebp
801026e4:	57                   	push   %edi
801026e5:	56                   	push   %esi
801026e6:	53                   	push   %ebx
801026e7:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801026ea:	bb 00 00 00 00       	mov    $0x0,%ebx
801026ef:	eb 66                	jmp    80102757 <write_log+0x76>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801026f1:	89 d8                	mov    %ebx,%eax
801026f3:	03 05 14 37 11 80    	add    0x80113714,%eax
801026f9:	83 c0 01             	add    $0x1,%eax
801026fc:	83 ec 08             	sub    $0x8,%esp
801026ff:	50                   	push   %eax
80102700:	ff 35 24 37 11 80    	pushl  0x80113724
80102706:	e8 61 da ff ff       	call   8010016c <bread>
8010270b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010270d:	83 c4 08             	add    $0x8,%esp
80102710:	ff 34 9d 2c 37 11 80 	pushl  -0x7feec8d4(,%ebx,4)
80102717:	ff 35 24 37 11 80    	pushl  0x80113724
8010271d:	e8 4a da ff ff       	call   8010016c <bread>
80102722:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102724:	8d 50 5c             	lea    0x5c(%eax),%edx
80102727:	8d 46 5c             	lea    0x5c(%esi),%eax
8010272a:	83 c4 0c             	add    $0xc,%esp
8010272d:	68 00 02 00 00       	push   $0x200
80102732:	52                   	push   %edx
80102733:	50                   	push   %eax
80102734:	e8 d6 15 00 00       	call   80103d0f <memmove>
    bwrite(to);  // write the log
80102739:	89 34 24             	mov    %esi,(%esp)
8010273c:	e8 59 da ff ff       	call   8010019a <bwrite>
    brelse(from);
80102741:	89 3c 24             	mov    %edi,(%esp)
80102744:	e8 8c da ff ff       	call   801001d5 <brelse>
    brelse(to);
80102749:	89 34 24             	mov    %esi,(%esp)
8010274c:	e8 84 da ff ff       	call   801001d5 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102751:	83 c3 01             	add    $0x1,%ebx
80102754:	83 c4 10             	add    $0x10,%esp
80102757:	39 1d 28 37 11 80    	cmp    %ebx,0x80113728
8010275d:	7f 92                	jg     801026f1 <write_log+0x10>
  }
}
8010275f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102762:	5b                   	pop    %ebx
80102763:	5e                   	pop    %esi
80102764:	5f                   	pop    %edi
80102765:	5d                   	pop    %ebp
80102766:	c3                   	ret    

80102767 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
80102767:	83 3d 28 37 11 80 00 	cmpl   $0x0,0x80113728
8010276e:	7e 26                	jle    80102796 <commit+0x2f>
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
80102776:	e8 66 ff ff ff       	call   801026e1 <write_log>
    write_head();    // Write header to disk -- the real commit
8010277b:	e8 e8 fe ff ff       	call   80102668 <write_head>
    install_trans(); // Now install writes to home locations
80102780:	e8 5d fe ff ff       	call   801025e2 <install_trans>
    log.lh.n = 0;
80102785:	c7 05 28 37 11 80 00 	movl   $0x0,0x80113728
8010278c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010278f:	e8 d4 fe ff ff       	call   80102668 <write_head>
  }
}
80102794:	c9                   	leave  
80102795:	c3                   	ret    
80102796:	f3 c3                	repz ret 

80102798 <initlog>:
{
80102798:	55                   	push   %ebp
80102799:	89 e5                	mov    %esp,%ebp
8010279b:	53                   	push   %ebx
8010279c:	83 ec 2c             	sub    $0x2c,%esp
8010279f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801027a2:	68 00 69 10 80       	push   $0x80106900
801027a7:	68 e0 36 11 80       	push   $0x801136e0
801027ac:	e8 fb 12 00 00       	call   80103aac <initlock>
  readsb(dev, &sb);
801027b1:	83 c4 08             	add    $0x8,%esp
801027b4:	8d 45 dc             	lea    -0x24(%ebp),%eax
801027b7:	50                   	push   %eax
801027b8:	53                   	push   %ebx
801027b9:	e8 ab ea ff ff       	call   80101269 <readsb>
  log.start = sb.logstart;
801027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801027c1:	a3 14 37 11 80       	mov    %eax,0x80113714
  log.size = sb.nlog;
801027c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801027c9:	a3 18 37 11 80       	mov    %eax,0x80113718
  log.dev = dev;
801027ce:	89 1d 24 37 11 80    	mov    %ebx,0x80113724
  recover_from_log();
801027d4:	e8 e7 fe ff ff       	call   801026c0 <recover_from_log>
}
801027d9:	83 c4 10             	add    $0x10,%esp
801027dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027df:	c9                   	leave  
801027e0:	c3                   	ret    

801027e1 <begin_op>:
{
801027e1:	55                   	push   %ebp
801027e2:	89 e5                	mov    %esp,%ebp
801027e4:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801027e7:	68 e0 36 11 80       	push   $0x801136e0
801027ec:	e8 f7 13 00 00       	call   80103be8 <acquire>
801027f1:	83 c4 10             	add    $0x10,%esp
801027f4:	eb 15                	jmp    8010280b <begin_op+0x2a>
      sleep(&log, &log.lock);
801027f6:	83 ec 08             	sub    $0x8,%esp
801027f9:	68 e0 36 11 80       	push   $0x801136e0
801027fe:	68 e0 36 11 80       	push   $0x801136e0
80102803:	e8 00 0f 00 00       	call   80103708 <sleep>
80102808:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010280b:	83 3d 20 37 11 80 00 	cmpl   $0x0,0x80113720
80102812:	75 e2                	jne    801027f6 <begin_op+0x15>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102814:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102819:	83 c0 01             	add    $0x1,%eax
8010281c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010281f:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
80102822:	03 15 28 37 11 80    	add    0x80113728,%edx
80102828:	83 fa 1e             	cmp    $0x1e,%edx
8010282b:	7e 17                	jle    80102844 <begin_op+0x63>
      sleep(&log, &log.lock);
8010282d:	83 ec 08             	sub    $0x8,%esp
80102830:	68 e0 36 11 80       	push   $0x801136e0
80102835:	68 e0 36 11 80       	push   $0x801136e0
8010283a:	e8 c9 0e 00 00       	call   80103708 <sleep>
8010283f:	83 c4 10             	add    $0x10,%esp
80102842:	eb c7                	jmp    8010280b <begin_op+0x2a>
      log.outstanding += 1;
80102844:	a3 1c 37 11 80       	mov    %eax,0x8011371c
      release(&log.lock);
80102849:	83 ec 0c             	sub    $0xc,%esp
8010284c:	68 e0 36 11 80       	push   $0x801136e0
80102851:	e8 f7 13 00 00       	call   80103c4d <release>
}
80102856:	83 c4 10             	add    $0x10,%esp
80102859:	c9                   	leave  
8010285a:	c3                   	ret    

8010285b <end_op>:
{
8010285b:	55                   	push   %ebp
8010285c:	89 e5                	mov    %esp,%ebp
8010285e:	53                   	push   %ebx
8010285f:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
80102862:	68 e0 36 11 80       	push   $0x801136e0
80102867:	e8 7c 13 00 00       	call   80103be8 <acquire>
  log.outstanding -= 1;
8010286c:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102871:	83 e8 01             	sub    $0x1,%eax
80102874:	a3 1c 37 11 80       	mov    %eax,0x8011371c
  if(log.committing)
80102879:	8b 1d 20 37 11 80    	mov    0x80113720,%ebx
8010287f:	83 c4 10             	add    $0x10,%esp
80102882:	85 db                	test   %ebx,%ebx
80102884:	75 2c                	jne    801028b2 <end_op+0x57>
  if(log.outstanding == 0){
80102886:	85 c0                	test   %eax,%eax
80102888:	75 35                	jne    801028bf <end_op+0x64>
    log.committing = 1;
8010288a:	c7 05 20 37 11 80 01 	movl   $0x1,0x80113720
80102891:	00 00 00 
    do_commit = 1;
80102894:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
80102899:	83 ec 0c             	sub    $0xc,%esp
8010289c:	68 e0 36 11 80       	push   $0x801136e0
801028a1:	e8 a7 13 00 00       	call   80103c4d <release>
  if(do_commit){
801028a6:	83 c4 10             	add    $0x10,%esp
801028a9:	85 db                	test   %ebx,%ebx
801028ab:	75 24                	jne    801028d1 <end_op+0x76>
}
801028ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028b0:	c9                   	leave  
801028b1:	c3                   	ret    
    panic("log.committing");
801028b2:	83 ec 0c             	sub    $0xc,%esp
801028b5:	68 04 69 10 80       	push   $0x80106904
801028ba:	e8 89 da ff ff       	call   80100348 <panic>
    wakeup(&log);
801028bf:	83 ec 0c             	sub    $0xc,%esp
801028c2:	68 e0 36 11 80       	push   $0x801136e0
801028c7:	e8 a0 0f 00 00       	call   8010386c <wakeup>
801028cc:	83 c4 10             	add    $0x10,%esp
801028cf:	eb c8                	jmp    80102899 <end_op+0x3e>
    commit();
801028d1:	e8 91 fe ff ff       	call   80102767 <commit>
    acquire(&log.lock);
801028d6:	83 ec 0c             	sub    $0xc,%esp
801028d9:	68 e0 36 11 80       	push   $0x801136e0
801028de:	e8 05 13 00 00       	call   80103be8 <acquire>
    log.committing = 0;
801028e3:	c7 05 20 37 11 80 00 	movl   $0x0,0x80113720
801028ea:	00 00 00 
    wakeup(&log);
801028ed:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
801028f4:	e8 73 0f 00 00       	call   8010386c <wakeup>
    release(&log.lock);
801028f9:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80102900:	e8 48 13 00 00       	call   80103c4d <release>
80102905:	83 c4 10             	add    $0x10,%esp
}
80102908:	eb a3                	jmp    801028ad <end_op+0x52>

8010290a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010290a:	55                   	push   %ebp
8010290b:	89 e5                	mov    %esp,%ebp
8010290d:	53                   	push   %ebx
8010290e:	83 ec 04             	sub    $0x4,%esp
80102911:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102914:	8b 15 28 37 11 80    	mov    0x80113728,%edx
8010291a:	83 fa 1d             	cmp    $0x1d,%edx
8010291d:	7f 45                	jg     80102964 <log_write+0x5a>
8010291f:	a1 18 37 11 80       	mov    0x80113718,%eax
80102924:	83 e8 01             	sub    $0x1,%eax
80102927:	39 c2                	cmp    %eax,%edx
80102929:	7d 39                	jge    80102964 <log_write+0x5a>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010292b:	83 3d 1c 37 11 80 00 	cmpl   $0x0,0x8011371c
80102932:	7e 3d                	jle    80102971 <log_write+0x67>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102934:	83 ec 0c             	sub    $0xc,%esp
80102937:	68 e0 36 11 80       	push   $0x801136e0
8010293c:	e8 a7 12 00 00       	call   80103be8 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102941:	83 c4 10             	add    $0x10,%esp
80102944:	b8 00 00 00 00       	mov    $0x0,%eax
80102949:	8b 15 28 37 11 80    	mov    0x80113728,%edx
8010294f:	39 c2                	cmp    %eax,%edx
80102951:	7e 2b                	jle    8010297e <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102953:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102956:	39 0c 85 2c 37 11 80 	cmp    %ecx,-0x7feec8d4(,%eax,4)
8010295d:	74 1f                	je     8010297e <log_write+0x74>
  for (i = 0; i < log.lh.n; i++) {
8010295f:	83 c0 01             	add    $0x1,%eax
80102962:	eb e5                	jmp    80102949 <log_write+0x3f>
    panic("too big a transaction");
80102964:	83 ec 0c             	sub    $0xc,%esp
80102967:	68 13 69 10 80       	push   $0x80106913
8010296c:	e8 d7 d9 ff ff       	call   80100348 <panic>
    panic("log_write outside of trans");
80102971:	83 ec 0c             	sub    $0xc,%esp
80102974:	68 29 69 10 80       	push   $0x80106929
80102979:	e8 ca d9 ff ff       	call   80100348 <panic>
      break;
  }
  log.lh.block[i] = b->blockno;
8010297e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102981:	89 0c 85 2c 37 11 80 	mov    %ecx,-0x7feec8d4(,%eax,4)
  if (i == log.lh.n)
80102988:	39 c2                	cmp    %eax,%edx
8010298a:	74 18                	je     801029a4 <log_write+0x9a>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010298c:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
8010298f:	83 ec 0c             	sub    $0xc,%esp
80102992:	68 e0 36 11 80       	push   $0x801136e0
80102997:	e8 b1 12 00 00       	call   80103c4d <release>
}
8010299c:	83 c4 10             	add    $0x10,%esp
8010299f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029a2:	c9                   	leave  
801029a3:	c3                   	ret    
    log.lh.n++;
801029a4:	83 c2 01             	add    $0x1,%edx
801029a7:	89 15 28 37 11 80    	mov    %edx,0x80113728
801029ad:	eb dd                	jmp    8010298c <log_write+0x82>

801029af <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801029af:	55                   	push   %ebp
801029b0:	89 e5                	mov    %esp,%ebp
801029b2:	53                   	push   %ebx
801029b3:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801029b6:	68 8a 00 00 00       	push   $0x8a
801029bb:	68 8c 94 10 80       	push   $0x8010948c
801029c0:	68 00 70 00 80       	push   $0x80007000
801029c5:	e8 45 13 00 00       	call   80103d0f <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801029ca:	83 c4 10             	add    $0x10,%esp
801029cd:	bb e0 37 11 80       	mov    $0x801137e0,%ebx
801029d2:	eb 06                	jmp    801029da <startothers+0x2b>
801029d4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801029da:	69 05 60 3d 11 80 b0 	imul   $0xb0,0x80113d60,%eax
801029e1:	00 00 00 
801029e4:	05 e0 37 11 80       	add    $0x801137e0,%eax
801029e9:	39 d8                	cmp    %ebx,%eax
801029eb:	76 4c                	jbe    80102a39 <startothers+0x8a>
    if(c == mycpu())  // We've started already.
801029ed:	e8 d8 07 00 00       	call   801031ca <mycpu>
801029f2:	39 d8                	cmp    %ebx,%eax
801029f4:	74 de                	je     801029d4 <startothers+0x25>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801029f6:	e8 f3 f6 ff ff       	call   801020ee <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801029fb:	05 00 10 00 00       	add    $0x1000,%eax
80102a00:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
80102a05:	c7 05 f8 6f 00 80 7d 	movl   $0x80102a7d,0x80006ff8
80102a0c:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102a0f:	c7 05 f4 6f 00 80 00 	movl   $0x108000,0x80006ff4
80102a16:	80 10 00 

    lapicstartap(c->apicid, V2P(code));
80102a19:	83 ec 08             	sub    $0x8,%esp
80102a1c:	68 00 70 00 00       	push   $0x7000
80102a21:	0f b6 03             	movzbl (%ebx),%eax
80102a24:	50                   	push   %eax
80102a25:	e8 c6 f9 ff ff       	call   801023f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102a2a:	83 c4 10             	add    $0x10,%esp
80102a2d:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102a33:	85 c0                	test   %eax,%eax
80102a35:	74 f6                	je     80102a2d <startothers+0x7e>
80102a37:	eb 9b                	jmp    801029d4 <startothers+0x25>
      ;
  }
}
80102a39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a3c:	c9                   	leave  
80102a3d:	c3                   	ret    

80102a3e <mpmain>:
{
80102a3e:	55                   	push   %ebp
80102a3f:	89 e5                	mov    %esp,%ebp
80102a41:	53                   	push   %ebx
80102a42:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102a45:	e8 dc 07 00 00       	call   80103226 <cpuid>
80102a4a:	89 c3                	mov    %eax,%ebx
80102a4c:	e8 d5 07 00 00       	call   80103226 <cpuid>
80102a51:	83 ec 04             	sub    $0x4,%esp
80102a54:	53                   	push   %ebx
80102a55:	50                   	push   %eax
80102a56:	68 44 69 10 80       	push   $0x80106944
80102a5b:	e8 ab db ff ff       	call   8010060b <cprintf>
  idtinit();       // load idt register
80102a60:	e8 6d 23 00 00       	call   80104dd2 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102a65:	e8 60 07 00 00       	call   801031ca <mycpu>
80102a6a:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a6c:	b8 01 00 00 00       	mov    $0x1,%eax
80102a71:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102a78:	e8 43 0a 00 00       	call   801034c0 <scheduler>

80102a7d <mpenter>:
{
80102a7d:	55                   	push   %ebp
80102a7e:	89 e5                	mov    %esp,%ebp
80102a80:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a83:	e8 5b 33 00 00       	call   80105de3 <switchkvm>
  seginit();
80102a88:	e8 0a 32 00 00       	call   80105c97 <seginit>
  lapicinit();
80102a8d:	e8 15 f8 ff ff       	call   801022a7 <lapicinit>
  mpmain();
80102a92:	e8 a7 ff ff ff       	call   80102a3e <mpmain>

80102a97 <main>:
{
80102a97:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102a9b:	83 e4 f0             	and    $0xfffffff0,%esp
80102a9e:	ff 71 fc             	pushl  -0x4(%ecx)
80102aa1:	55                   	push   %ebp
80102aa2:	89 e5                	mov    %esp,%ebp
80102aa4:	51                   	push   %ecx
80102aa5:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102aa8:	68 00 00 40 80       	push   $0x80400000
80102aad:	68 88 45 11 80       	push   $0x80114588
80102ab2:	e8 e5 f5 ff ff       	call   8010209c <kinit1>
  kvmalloc();      // kernel page table
80102ab7:	e8 b4 37 00 00       	call   80106270 <kvmalloc>
  mpinit();        // detect other processors
80102abc:	e8 c9 01 00 00       	call   80102c8a <mpinit>
  lapicinit();     // interrupt controller
80102ac1:	e8 e1 f7 ff ff       	call   801022a7 <lapicinit>
  seginit();       // segment descriptors
80102ac6:	e8 cc 31 00 00       	call   80105c97 <seginit>
  picinit();       // disable pic
80102acb:	e8 82 02 00 00       	call   80102d52 <picinit>
  ioapicinit();    // another interrupt controller
80102ad0:	e8 58 f4 ff ff       	call   80101f2d <ioapicinit>
  consoleinit();   // console hardware
80102ad5:	e8 f7 dd ff ff       	call   801008d1 <consoleinit>
  uartinit();      // serial port
80102ada:	e8 a9 25 00 00       	call   80105088 <uartinit>
  pinit();         // process table
80102adf:	e8 cc 06 00 00       	call   801031b0 <pinit>
  tvinit();        // trap vectors
80102ae4:	e8 50 22 00 00       	call   80104d39 <tvinit>
  binit();         // buffer cache
80102ae9:	e8 06 d6 ff ff       	call   801000f4 <binit>
  fileinit();      // file table
80102aee:	e8 53 e1 ff ff       	call   80100c46 <fileinit>
  ideinit();       // disk 
80102af3:	e8 3b f2 ff ff       	call   80101d33 <ideinit>
  startothers();   // start other processors
80102af8:	e8 b2 fe ff ff       	call   801029af <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102afd:	83 c4 08             	add    $0x8,%esp
80102b00:	68 00 00 00 8e       	push   $0x8e000000
80102b05:	68 00 00 40 80       	push   $0x80400000
80102b0a:	e8 bf f5 ff ff       	call   801020ce <kinit2>
  userinit();      // first user process
80102b0f:	e8 51 07 00 00       	call   80103265 <userinit>
  mpmain();        // finish this processor's setup
80102b14:	e8 25 ff ff ff       	call   80102a3e <mpmain>

80102b19 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102b19:	55                   	push   %ebp
80102b1a:	89 e5                	mov    %esp,%ebp
80102b1c:	56                   	push   %esi
80102b1d:	53                   	push   %ebx
  int i, sum;

  sum = 0;
80102b1e:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(i=0; i<len; i++)
80102b23:	b9 00 00 00 00       	mov    $0x0,%ecx
80102b28:	eb 09                	jmp    80102b33 <sum+0x1a>
    sum += addr[i];
80102b2a:	0f b6 34 08          	movzbl (%eax,%ecx,1),%esi
80102b2e:	01 f3                	add    %esi,%ebx
  for(i=0; i<len; i++)
80102b30:	83 c1 01             	add    $0x1,%ecx
80102b33:	39 d1                	cmp    %edx,%ecx
80102b35:	7c f3                	jl     80102b2a <sum+0x11>
  return sum;
}
80102b37:	89 d8                	mov    %ebx,%eax
80102b39:	5b                   	pop    %ebx
80102b3a:	5e                   	pop    %esi
80102b3b:	5d                   	pop    %ebp
80102b3c:	c3                   	ret    

80102b3d <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102b3d:	55                   	push   %ebp
80102b3e:	89 e5                	mov    %esp,%ebp
80102b40:	56                   	push   %esi
80102b41:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102b42:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102b48:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102b4a:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102b4c:	eb 03                	jmp    80102b51 <mpsearch1+0x14>
80102b4e:	83 c3 10             	add    $0x10,%ebx
80102b51:	39 f3                	cmp    %esi,%ebx
80102b53:	73 29                	jae    80102b7e <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102b55:	83 ec 04             	sub    $0x4,%esp
80102b58:	6a 04                	push   $0x4
80102b5a:	68 58 69 10 80       	push   $0x80106958
80102b5f:	53                   	push   %ebx
80102b60:	e8 75 11 00 00       	call   80103cda <memcmp>
80102b65:	83 c4 10             	add    $0x10,%esp
80102b68:	85 c0                	test   %eax,%eax
80102b6a:	75 e2                	jne    80102b4e <mpsearch1+0x11>
80102b6c:	ba 10 00 00 00       	mov    $0x10,%edx
80102b71:	89 d8                	mov    %ebx,%eax
80102b73:	e8 a1 ff ff ff       	call   80102b19 <sum>
80102b78:	84 c0                	test   %al,%al
80102b7a:	75 d2                	jne    80102b4e <mpsearch1+0x11>
80102b7c:	eb 05                	jmp    80102b83 <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102b7e:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102b83:	89 d8                	mov    %ebx,%eax
80102b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b88:	5b                   	pop    %ebx
80102b89:	5e                   	pop    %esi
80102b8a:	5d                   	pop    %ebp
80102b8b:	c3                   	ret    

80102b8c <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102b8c:	55                   	push   %ebp
80102b8d:	89 e5                	mov    %esp,%ebp
80102b8f:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102b92:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102b99:	c1 e0 08             	shl    $0x8,%eax
80102b9c:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102ba3:	09 d0                	or     %edx,%eax
80102ba5:	c1 e0 04             	shl    $0x4,%eax
80102ba8:	85 c0                	test   %eax,%eax
80102baa:	74 1f                	je     80102bcb <mpsearch+0x3f>
    if((mp = mpsearch1(p, 1024)))
80102bac:	ba 00 04 00 00       	mov    $0x400,%edx
80102bb1:	e8 87 ff ff ff       	call   80102b3d <mpsearch1>
80102bb6:	85 c0                	test   %eax,%eax
80102bb8:	75 0f                	jne    80102bc9 <mpsearch+0x3d>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102bba:	ba 00 00 01 00       	mov    $0x10000,%edx
80102bbf:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102bc4:	e8 74 ff ff ff       	call   80102b3d <mpsearch1>
}
80102bc9:	c9                   	leave  
80102bca:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102bcb:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102bd2:	c1 e0 08             	shl    $0x8,%eax
80102bd5:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102bdc:	09 d0                	or     %edx,%eax
80102bde:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102be1:	2d 00 04 00 00       	sub    $0x400,%eax
80102be6:	ba 00 04 00 00       	mov    $0x400,%edx
80102beb:	e8 4d ff ff ff       	call   80102b3d <mpsearch1>
80102bf0:	85 c0                	test   %eax,%eax
80102bf2:	75 d5                	jne    80102bc9 <mpsearch+0x3d>
80102bf4:	eb c4                	jmp    80102bba <mpsearch+0x2e>

80102bf6 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102bf6:	55                   	push   %ebp
80102bf7:	89 e5                	mov    %esp,%ebp
80102bf9:	57                   	push   %edi
80102bfa:	56                   	push   %esi
80102bfb:	53                   	push   %ebx
80102bfc:	83 ec 1c             	sub    $0x1c,%esp
80102bff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102c02:	e8 85 ff ff ff       	call   80102b8c <mpsearch>
80102c07:	85 c0                	test   %eax,%eax
80102c09:	74 5c                	je     80102c67 <mpconfig+0x71>
80102c0b:	89 c7                	mov    %eax,%edi
80102c0d:	8b 58 04             	mov    0x4(%eax),%ebx
80102c10:	85 db                	test   %ebx,%ebx
80102c12:	74 5a                	je     80102c6e <mpconfig+0x78>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c14:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80102c1a:	83 ec 04             	sub    $0x4,%esp
80102c1d:	6a 04                	push   $0x4
80102c1f:	68 5d 69 10 80       	push   $0x8010695d
80102c24:	56                   	push   %esi
80102c25:	e8 b0 10 00 00       	call   80103cda <memcmp>
80102c2a:	83 c4 10             	add    $0x10,%esp
80102c2d:	85 c0                	test   %eax,%eax
80102c2f:	75 44                	jne    80102c75 <mpconfig+0x7f>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102c31:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80102c38:	3c 01                	cmp    $0x1,%al
80102c3a:	0f 95 c2             	setne  %dl
80102c3d:	3c 04                	cmp    $0x4,%al
80102c3f:	0f 95 c0             	setne  %al
80102c42:	84 c2                	test   %al,%dl
80102c44:	75 36                	jne    80102c7c <mpconfig+0x86>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102c46:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80102c4d:	89 f0                	mov    %esi,%eax
80102c4f:	e8 c5 fe ff ff       	call   80102b19 <sum>
80102c54:	84 c0                	test   %al,%al
80102c56:	75 2b                	jne    80102c83 <mpconfig+0x8d>
    return 0;
  *pmp = mp;
80102c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102c5b:	89 38                	mov    %edi,(%eax)
  return conf;
}
80102c5d:	89 f0                	mov    %esi,%eax
80102c5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c62:	5b                   	pop    %ebx
80102c63:	5e                   	pop    %esi
80102c64:	5f                   	pop    %edi
80102c65:	5d                   	pop    %ebp
80102c66:	c3                   	ret    
    return 0;
80102c67:	be 00 00 00 00       	mov    $0x0,%esi
80102c6c:	eb ef                	jmp    80102c5d <mpconfig+0x67>
80102c6e:	be 00 00 00 00       	mov    $0x0,%esi
80102c73:	eb e8                	jmp    80102c5d <mpconfig+0x67>
    return 0;
80102c75:	be 00 00 00 00       	mov    $0x0,%esi
80102c7a:	eb e1                	jmp    80102c5d <mpconfig+0x67>
    return 0;
80102c7c:	be 00 00 00 00       	mov    $0x0,%esi
80102c81:	eb da                	jmp    80102c5d <mpconfig+0x67>
    return 0;
80102c83:	be 00 00 00 00       	mov    $0x0,%esi
80102c88:	eb d3                	jmp    80102c5d <mpconfig+0x67>

80102c8a <mpinit>:

void
mpinit(void)
{
80102c8a:	55                   	push   %ebp
80102c8b:	89 e5                	mov    %esp,%ebp
80102c8d:	57                   	push   %edi
80102c8e:	56                   	push   %esi
80102c8f:	53                   	push   %ebx
80102c90:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102c93:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102c96:	e8 5b ff ff ff       	call   80102bf6 <mpconfig>
80102c9b:	85 c0                	test   %eax,%eax
80102c9d:	74 19                	je     80102cb8 <mpinit+0x2e>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102c9f:	8b 50 24             	mov    0x24(%eax),%edx
80102ca2:	89 15 dc 36 11 80    	mov    %edx,0x801136dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102ca8:	8d 50 2c             	lea    0x2c(%eax),%edx
80102cab:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102caf:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102cb1:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cb6:	eb 34                	jmp    80102cec <mpinit+0x62>
    panic("Expect to run on an SMP");
80102cb8:	83 ec 0c             	sub    $0xc,%esp
80102cbb:	68 62 69 10 80       	push   $0x80106962
80102cc0:	e8 83 d6 ff ff       	call   80100348 <panic>
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80102cc5:	8b 35 60 3d 11 80    	mov    0x80113d60,%esi
80102ccb:	83 fe 07             	cmp    $0x7,%esi
80102cce:	7f 19                	jg     80102ce9 <mpinit+0x5f>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102cd0:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102cd4:	69 fe b0 00 00 00    	imul   $0xb0,%esi,%edi
80102cda:	88 87 e0 37 11 80    	mov    %al,-0x7feec820(%edi)
        ncpu++;
80102ce0:	83 c6 01             	add    $0x1,%esi
80102ce3:	89 35 60 3d 11 80    	mov    %esi,0x80113d60
      }
      p += sizeof(struct mpproc);
80102ce9:	83 c2 14             	add    $0x14,%edx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cec:	39 ca                	cmp    %ecx,%edx
80102cee:	73 2b                	jae    80102d1b <mpinit+0x91>
    switch(*p){
80102cf0:	0f b6 02             	movzbl (%edx),%eax
80102cf3:	3c 04                	cmp    $0x4,%al
80102cf5:	77 1d                	ja     80102d14 <mpinit+0x8a>
80102cf7:	0f b6 c0             	movzbl %al,%eax
80102cfa:	ff 24 85 9c 69 10 80 	jmp    *-0x7fef9664(,%eax,4)
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80102d01:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102d05:	a2 c0 37 11 80       	mov    %al,0x801137c0
      p += sizeof(struct mpioapic);
80102d0a:	83 c2 08             	add    $0x8,%edx
      continue;
80102d0d:	eb dd                	jmp    80102cec <mpinit+0x62>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102d0f:	83 c2 08             	add    $0x8,%edx
      continue;
80102d12:	eb d8                	jmp    80102cec <mpinit+0x62>
    default:
      ismp = 0;
80102d14:	bb 00 00 00 00       	mov    $0x0,%ebx
80102d19:	eb d1                	jmp    80102cec <mpinit+0x62>
      break;
    }
  }
  if(!ismp)
80102d1b:	85 db                	test   %ebx,%ebx
80102d1d:	74 26                	je     80102d45 <mpinit+0xbb>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d22:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102d26:	74 15                	je     80102d3d <mpinit+0xb3>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d28:	b8 70 00 00 00       	mov    $0x70,%eax
80102d2d:	ba 22 00 00 00       	mov    $0x22,%edx
80102d32:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d33:	ba 23 00 00 00       	mov    $0x23,%edx
80102d38:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102d39:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d3c:	ee                   	out    %al,(%dx)
  }
}
80102d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d40:	5b                   	pop    %ebx
80102d41:	5e                   	pop    %esi
80102d42:	5f                   	pop    %edi
80102d43:	5d                   	pop    %ebp
80102d44:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102d45:	83 ec 0c             	sub    $0xc,%esp
80102d48:	68 7c 69 10 80       	push   $0x8010697c
80102d4d:	e8 f6 d5 ff ff       	call   80100348 <panic>

80102d52 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102d52:	55                   	push   %ebp
80102d53:	89 e5                	mov    %esp,%ebp
80102d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d5a:	ba 21 00 00 00       	mov    $0x21,%edx
80102d5f:	ee                   	out    %al,(%dx)
80102d60:	ba a1 00 00 00       	mov    $0xa1,%edx
80102d65:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102d66:	5d                   	pop    %ebp
80102d67:	c3                   	ret    

80102d68 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102d68:	55                   	push   %ebp
80102d69:	89 e5                	mov    %esp,%ebp
80102d6b:	57                   	push   %edi
80102d6c:	56                   	push   %esi
80102d6d:	53                   	push   %ebx
80102d6e:	83 ec 0c             	sub    $0xc,%esp
80102d71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d74:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102d77:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102d7d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102d83:	e8 d8 de ff ff       	call   80100c60 <filealloc>
80102d88:	89 03                	mov    %eax,(%ebx)
80102d8a:	85 c0                	test   %eax,%eax
80102d8c:	74 16                	je     80102da4 <pipealloc+0x3c>
80102d8e:	e8 cd de ff ff       	call   80100c60 <filealloc>
80102d93:	89 06                	mov    %eax,(%esi)
80102d95:	85 c0                	test   %eax,%eax
80102d97:	74 0b                	je     80102da4 <pipealloc+0x3c>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102d99:	e8 50 f3 ff ff       	call   801020ee <kalloc>
80102d9e:	89 c7                	mov    %eax,%edi
80102da0:	85 c0                	test   %eax,%eax
80102da2:	75 35                	jne    80102dd9 <pipealloc+0x71>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102da4:	8b 03                	mov    (%ebx),%eax
80102da6:	85 c0                	test   %eax,%eax
80102da8:	74 0c                	je     80102db6 <pipealloc+0x4e>
    fileclose(*f0);
80102daa:	83 ec 0c             	sub    $0xc,%esp
80102dad:	50                   	push   %eax
80102dae:	e8 53 df ff ff       	call   80100d06 <fileclose>
80102db3:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102db6:	8b 06                	mov    (%esi),%eax
80102db8:	85 c0                	test   %eax,%eax
80102dba:	0f 84 8b 00 00 00    	je     80102e4b <pipealloc+0xe3>
    fileclose(*f1);
80102dc0:	83 ec 0c             	sub    $0xc,%esp
80102dc3:	50                   	push   %eax
80102dc4:	e8 3d df ff ff       	call   80100d06 <fileclose>
80102dc9:	83 c4 10             	add    $0x10,%esp
  return -1;
80102dcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dd4:	5b                   	pop    %ebx
80102dd5:	5e                   	pop    %esi
80102dd6:	5f                   	pop    %edi
80102dd7:	5d                   	pop    %ebp
80102dd8:	c3                   	ret    
  p->readopen = 1;
80102dd9:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102de0:	00 00 00 
  p->writeopen = 1;
80102de3:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102dea:	00 00 00 
  p->nwrite = 0;
80102ded:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102df4:	00 00 00 
  p->nread = 0;
80102df7:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102dfe:	00 00 00 
  initlock(&p->lock, "pipe");
80102e01:	83 ec 08             	sub    $0x8,%esp
80102e04:	68 b0 69 10 80       	push   $0x801069b0
80102e09:	50                   	push   %eax
80102e0a:	e8 9d 0c 00 00       	call   80103aac <initlock>
  (*f0)->type = FD_PIPE;
80102e0f:	8b 03                	mov    (%ebx),%eax
80102e11:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102e17:	8b 03                	mov    (%ebx),%eax
80102e19:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102e1d:	8b 03                	mov    (%ebx),%eax
80102e1f:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102e23:	8b 03                	mov    (%ebx),%eax
80102e25:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102e28:	8b 06                	mov    (%esi),%eax
80102e2a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102e30:	8b 06                	mov    (%esi),%eax
80102e32:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102e36:	8b 06                	mov    (%esi),%eax
80102e38:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102e3c:	8b 06                	mov    (%esi),%eax
80102e3e:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102e41:	83 c4 10             	add    $0x10,%esp
80102e44:	b8 00 00 00 00       	mov    $0x0,%eax
80102e49:	eb 86                	jmp    80102dd1 <pipealloc+0x69>
  return -1;
80102e4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e50:	e9 7c ff ff ff       	jmp    80102dd1 <pipealloc+0x69>

80102e55 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102e55:	55                   	push   %ebp
80102e56:	89 e5                	mov    %esp,%ebp
80102e58:	53                   	push   %ebx
80102e59:	83 ec 10             	sub    $0x10,%esp
80102e5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102e5f:	53                   	push   %ebx
80102e60:	e8 83 0d 00 00       	call   80103be8 <acquire>
  if(writable){
80102e65:	83 c4 10             	add    $0x10,%esp
80102e68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102e6c:	74 3f                	je     80102ead <pipeclose+0x58>
    p->writeopen = 0;
80102e6e:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102e75:	00 00 00 
    wakeup(&p->nread);
80102e78:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e7e:	83 ec 0c             	sub    $0xc,%esp
80102e81:	50                   	push   %eax
80102e82:	e8 e5 09 00 00       	call   8010386c <wakeup>
80102e87:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102e8a:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102e91:	75 09                	jne    80102e9c <pipeclose+0x47>
80102e93:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102e9a:	74 2f                	je     80102ecb <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102e9c:	83 ec 0c             	sub    $0xc,%esp
80102e9f:	53                   	push   %ebx
80102ea0:	e8 a8 0d 00 00       	call   80103c4d <release>
80102ea5:	83 c4 10             	add    $0x10,%esp
}
80102ea8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102eab:	c9                   	leave  
80102eac:	c3                   	ret    
    p->readopen = 0;
80102ead:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102eb4:	00 00 00 
    wakeup(&p->nwrite);
80102eb7:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102ebd:	83 ec 0c             	sub    $0xc,%esp
80102ec0:	50                   	push   %eax
80102ec1:	e8 a6 09 00 00       	call   8010386c <wakeup>
80102ec6:	83 c4 10             	add    $0x10,%esp
80102ec9:	eb bf                	jmp    80102e8a <pipeclose+0x35>
    release(&p->lock);
80102ecb:	83 ec 0c             	sub    $0xc,%esp
80102ece:	53                   	push   %ebx
80102ecf:	e8 79 0d 00 00       	call   80103c4d <release>
    kfree((char*)p);
80102ed4:	89 1c 24             	mov    %ebx,(%esp)
80102ed7:	e8 fb f0 ff ff       	call   80101fd7 <kfree>
80102edc:	83 c4 10             	add    $0x10,%esp
80102edf:	eb c7                	jmp    80102ea8 <pipeclose+0x53>

80102ee1 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102ee1:	55                   	push   %ebp
80102ee2:	89 e5                	mov    %esp,%ebp
80102ee4:	57                   	push   %edi
80102ee5:	56                   	push   %esi
80102ee6:	53                   	push   %ebx
80102ee7:	83 ec 18             	sub    $0x18,%esp
80102eea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102eed:	89 de                	mov    %ebx,%esi
80102eef:	53                   	push   %ebx
80102ef0:	e8 f3 0c 00 00       	call   80103be8 <acquire>
  for(i = 0; i < n; i++){
80102ef5:	83 c4 10             	add    $0x10,%esp
80102ef8:	bf 00 00 00 00       	mov    $0x0,%edi
80102efd:	3b 7d 10             	cmp    0x10(%ebp),%edi
80102f00:	0f 8d 88 00 00 00    	jge    80102f8e <pipewrite+0xad>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102f06:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102f0c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102f12:	05 00 02 00 00       	add    $0x200,%eax
80102f17:	39 c2                	cmp    %eax,%edx
80102f19:	75 51                	jne    80102f6c <pipewrite+0x8b>
      if(p->readopen == 0 || myproc()->killed){
80102f1b:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f22:	74 2f                	je     80102f53 <pipewrite+0x72>
80102f24:	e8 18 03 00 00       	call   80103241 <myproc>
80102f29:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f2d:	75 24                	jne    80102f53 <pipewrite+0x72>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80102f2f:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f35:	83 ec 0c             	sub    $0xc,%esp
80102f38:	50                   	push   %eax
80102f39:	e8 2e 09 00 00       	call   8010386c <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102f3e:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f44:	83 c4 08             	add    $0x8,%esp
80102f47:	56                   	push   %esi
80102f48:	50                   	push   %eax
80102f49:	e8 ba 07 00 00       	call   80103708 <sleep>
80102f4e:	83 c4 10             	add    $0x10,%esp
80102f51:	eb b3                	jmp    80102f06 <pipewrite+0x25>
        release(&p->lock);
80102f53:	83 ec 0c             	sub    $0xc,%esp
80102f56:	53                   	push   %ebx
80102f57:	e8 f1 0c 00 00       	call   80103c4d <release>
        return -1;
80102f5c:	83 c4 10             	add    $0x10,%esp
80102f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80102f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f67:	5b                   	pop    %ebx
80102f68:	5e                   	pop    %esi
80102f69:	5f                   	pop    %edi
80102f6a:	5d                   	pop    %ebp
80102f6b:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102f6c:	8d 42 01             	lea    0x1(%edx),%eax
80102f6f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102f75:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f7e:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
80102f82:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102f86:	83 c7 01             	add    $0x1,%edi
80102f89:	e9 6f ff ff ff       	jmp    80102efd <pipewrite+0x1c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102f8e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f94:	83 ec 0c             	sub    $0xc,%esp
80102f97:	50                   	push   %eax
80102f98:	e8 cf 08 00 00       	call   8010386c <wakeup>
  release(&p->lock);
80102f9d:	89 1c 24             	mov    %ebx,(%esp)
80102fa0:	e8 a8 0c 00 00       	call   80103c4d <release>
  return n;
80102fa5:	83 c4 10             	add    $0x10,%esp
80102fa8:	8b 45 10             	mov    0x10(%ebp),%eax
80102fab:	eb b7                	jmp    80102f64 <pipewrite+0x83>

80102fad <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102fad:	55                   	push   %ebp
80102fae:	89 e5                	mov    %esp,%ebp
80102fb0:	57                   	push   %edi
80102fb1:	56                   	push   %esi
80102fb2:	53                   	push   %ebx
80102fb3:	83 ec 18             	sub    $0x18,%esp
80102fb6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102fb9:	89 df                	mov    %ebx,%edi
80102fbb:	53                   	push   %ebx
80102fbc:	e8 27 0c 00 00       	call   80103be8 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102fc1:	83 c4 10             	add    $0x10,%esp
80102fc4:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102fca:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102fd0:	75 3d                	jne    8010300f <piperead+0x62>
80102fd2:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80102fd8:	85 f6                	test   %esi,%esi
80102fda:	74 38                	je     80103014 <piperead+0x67>
    if(myproc()->killed){
80102fdc:	e8 60 02 00 00       	call   80103241 <myproc>
80102fe1:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102fe5:	75 15                	jne    80102ffc <piperead+0x4f>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102fe7:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102fed:	83 ec 08             	sub    $0x8,%esp
80102ff0:	57                   	push   %edi
80102ff1:	50                   	push   %eax
80102ff2:	e8 11 07 00 00       	call   80103708 <sleep>
80102ff7:	83 c4 10             	add    $0x10,%esp
80102ffa:	eb c8                	jmp    80102fc4 <piperead+0x17>
      release(&p->lock);
80102ffc:	83 ec 0c             	sub    $0xc,%esp
80102fff:	53                   	push   %ebx
80103000:	e8 48 0c 00 00       	call   80103c4d <release>
      return -1;
80103005:	83 c4 10             	add    $0x10,%esp
80103008:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010300d:	eb 50                	jmp    8010305f <piperead+0xb2>
8010300f:	be 00 00 00 00       	mov    $0x0,%esi
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103014:	3b 75 10             	cmp    0x10(%ebp),%esi
80103017:	7d 2c                	jge    80103045 <piperead+0x98>
    if(p->nread == p->nwrite)
80103019:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010301f:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103025:	74 1e                	je     80103045 <piperead+0x98>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103027:	8d 50 01             	lea    0x1(%eax),%edx
8010302a:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80103030:	25 ff 01 00 00       	and    $0x1ff,%eax
80103035:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
8010303a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010303d:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103040:	83 c6 01             	add    $0x1,%esi
80103043:	eb cf                	jmp    80103014 <piperead+0x67>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103045:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010304b:	83 ec 0c             	sub    $0xc,%esp
8010304e:	50                   	push   %eax
8010304f:	e8 18 08 00 00       	call   8010386c <wakeup>
  release(&p->lock);
80103054:	89 1c 24             	mov    %ebx,(%esp)
80103057:	e8 f1 0b 00 00       	call   80103c4d <release>
  return i;
8010305c:	83 c4 10             	add    $0x10,%esp
}
8010305f:	89 f0                	mov    %esi,%eax
80103061:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103064:	5b                   	pop    %ebx
80103065:	5e                   	pop    %esi
80103066:	5f                   	pop    %edi
80103067:	5d                   	pop    %ebp
80103068:	c3                   	ret    

80103069 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103069:	55                   	push   %ebp
8010306a:	89 e5                	mov    %esp,%ebp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010306c:	ba 14 96 10 80       	mov    $0x80109614,%edx
80103071:	eb 03                	jmp    80103076 <wakeup1+0xd>
80103073:	83 ea 80             	sub    $0xffffff80,%edx
80103076:	81 fa 14 b6 10 80    	cmp    $0x8010b614,%edx
8010307c:	73 14                	jae    80103092 <wakeup1+0x29>
    if(p->state == SLEEPING && p->chan == chan)
8010307e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103082:	75 ef                	jne    80103073 <wakeup1+0xa>
80103084:	39 42 20             	cmp    %eax,0x20(%edx)
80103087:	75 ea                	jne    80103073 <wakeup1+0xa>
      p->state = RUNNABLE;
80103089:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103090:	eb e1                	jmp    80103073 <wakeup1+0xa>
}
80103092:	5d                   	pop    %ebp
80103093:	c3                   	ret    

80103094 <allocproc>:
{
80103094:	55                   	push   %ebp
80103095:	89 e5                	mov    %esp,%ebp
80103097:	53                   	push   %ebx
80103098:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010309b:	68 e0 95 10 80       	push   $0x801095e0
801030a0:	e8 43 0b 00 00       	call   80103be8 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801030a5:	83 c4 10             	add    $0x10,%esp
801030a8:	bb 14 96 10 80       	mov    $0x80109614,%ebx
801030ad:	81 fb 14 b6 10 80    	cmp    $0x8010b614,%ebx
801030b3:	73 0b                	jae    801030c0 <allocproc+0x2c>
    if(p->state == UNUSED) {
801030b5:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
801030b9:	74 0c                	je     801030c7 <allocproc+0x33>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801030bb:	83 eb 80             	sub    $0xffffff80,%ebx
801030be:	eb ed                	jmp    801030ad <allocproc+0x19>
  int found = 0;
801030c0:	b8 00 00 00 00       	mov    $0x0,%eax
801030c5:	eb 05                	jmp    801030cc <allocproc+0x38>
      found = 1;
801030c7:	b8 01 00 00 00       	mov    $0x1,%eax
  if (!found) {
801030cc:	85 c0                	test   %eax,%eax
801030ce:	74 78                	je     80103148 <allocproc+0xb4>
  p->state = EMBRYO;
801030d0:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801030d7:	a1 04 90 10 80       	mov    0x80109004,%eax
801030dc:	8d 50 01             	lea    0x1(%eax),%edx
801030df:	89 15 04 90 10 80    	mov    %edx,0x80109004
801030e5:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801030e8:	83 ec 0c             	sub    $0xc,%esp
801030eb:	68 e0 95 10 80       	push   $0x801095e0
801030f0:	e8 58 0b 00 00       	call   80103c4d <release>
  if((p->kstack = kalloc()) == 0){
801030f5:	e8 f4 ef ff ff       	call   801020ee <kalloc>
801030fa:	89 43 08             	mov    %eax,0x8(%ebx)
801030fd:	83 c4 10             	add    $0x10,%esp
80103100:	85 c0                	test   %eax,%eax
80103102:	74 5b                	je     8010315f <allocproc+0xcb>
  sp -= sizeof *p->tf;
80103104:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
8010310a:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010310d:	c7 80 b0 0f 00 00 2e 	movl   $0x80104d2e,0xfb0(%eax)
80103114:	4d 10 80 
  sp -= sizeof *p->context;
80103117:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
8010311c:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010311f:	83 ec 04             	sub    $0x4,%esp
80103122:	6a 14                	push   $0x14
80103124:	6a 00                	push   $0x0
80103126:	50                   	push   %eax
80103127:	e8 68 0b 00 00       	call   80103c94 <memset>
  p->context->eip = (uint)forkret;
8010312c:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010312f:	c7 40 10 6d 31 10 80 	movl   $0x8010316d,0x10(%eax)
  p->start_ticks = ticks;
80103136:	a1 80 45 11 80       	mov    0x80114580,%eax
8010313b:	89 43 7c             	mov    %eax,0x7c(%ebx)
  return p;
8010313e:	83 c4 10             	add    $0x10,%esp
}
80103141:	89 d8                	mov    %ebx,%eax
80103143:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103146:	c9                   	leave  
80103147:	c3                   	ret    
    release(&ptable.lock);
80103148:	83 ec 0c             	sub    $0xc,%esp
8010314b:	68 e0 95 10 80       	push   $0x801095e0
80103150:	e8 f8 0a 00 00       	call   80103c4d <release>
    return 0;
80103155:	83 c4 10             	add    $0x10,%esp
80103158:	bb 00 00 00 00       	mov    $0x0,%ebx
8010315d:	eb e2                	jmp    80103141 <allocproc+0xad>
    p->state = UNUSED;
8010315f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103166:	bb 00 00 00 00       	mov    $0x0,%ebx
8010316b:	eb d4                	jmp    80103141 <allocproc+0xad>

8010316d <forkret>:
{
8010316d:	55                   	push   %ebp
8010316e:	89 e5                	mov    %esp,%ebp
80103170:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103173:	68 e0 95 10 80       	push   $0x801095e0
80103178:	e8 d0 0a 00 00       	call   80103c4d <release>
  if (first) {
8010317d:	83 c4 10             	add    $0x10,%esp
80103180:	83 3d 00 90 10 80 00 	cmpl   $0x0,0x80109000
80103187:	75 02                	jne    8010318b <forkret+0x1e>
}
80103189:	c9                   	leave  
8010318a:	c3                   	ret    
    first = 0;
8010318b:	c7 05 00 90 10 80 00 	movl   $0x0,0x80109000
80103192:	00 00 00 
    iinit(ROOTDEV);
80103195:	83 ec 0c             	sub    $0xc,%esp
80103198:	6a 01                	push   $0x1
8010319a:	e8 80 e1 ff ff       	call   8010131f <iinit>
    initlog(ROOTDEV);
8010319f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801031a6:	e8 ed f5 ff ff       	call   80102798 <initlog>
801031ab:	83 c4 10             	add    $0x10,%esp
}
801031ae:	eb d9                	jmp    80103189 <forkret+0x1c>

801031b0 <pinit>:
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801031b6:	68 b5 69 10 80       	push   $0x801069b5
801031bb:	68 e0 95 10 80       	push   $0x801095e0
801031c0:	e8 e7 08 00 00       	call   80103aac <initlock>
}
801031c5:	83 c4 10             	add    $0x10,%esp
801031c8:	c9                   	leave  
801031c9:	c3                   	ret    

801031ca <mycpu>:
{
801031ca:	55                   	push   %ebp
801031cb:	89 e5                	mov    %esp,%ebp
801031cd:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801031d0:	9c                   	pushf  
801031d1:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801031d2:	f6 c4 02             	test   $0x2,%ah
801031d5:	75 28                	jne    801031ff <mycpu+0x35>
  apicid = lapicid();
801031d7:	e8 d5 f1 ff ff       	call   801023b1 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801031dc:	ba 00 00 00 00       	mov    $0x0,%edx
801031e1:	39 15 60 3d 11 80    	cmp    %edx,0x80113d60
801031e7:	7e 23                	jle    8010320c <mycpu+0x42>
    if (cpus[i].apicid == apicid) {
801031e9:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801031ef:	0f b6 89 e0 37 11 80 	movzbl -0x7feec820(%ecx),%ecx
801031f6:	39 c1                	cmp    %eax,%ecx
801031f8:	74 1f                	je     80103219 <mycpu+0x4f>
  for (i = 0; i < ncpu; ++i) {
801031fa:	83 c2 01             	add    $0x1,%edx
801031fd:	eb e2                	jmp    801031e1 <mycpu+0x17>
    panic("mycpu called with interrupts enabled\n");
801031ff:	83 ec 0c             	sub    $0xc,%esp
80103202:	68 88 6a 10 80       	push   $0x80106a88
80103207:	e8 3c d1 ff ff       	call   80100348 <panic>
  panic("unknown apicid\n");
8010320c:	83 ec 0c             	sub    $0xc,%esp
8010320f:	68 bc 69 10 80       	push   $0x801069bc
80103214:	e8 2f d1 ff ff       	call   80100348 <panic>
      return &cpus[i];
80103219:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010321f:	05 e0 37 11 80       	add    $0x801137e0,%eax
}
80103224:	c9                   	leave  
80103225:	c3                   	ret    

80103226 <cpuid>:
cpuid() {
80103226:	55                   	push   %ebp
80103227:	89 e5                	mov    %esp,%ebp
80103229:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010322c:	e8 99 ff ff ff       	call   801031ca <mycpu>
80103231:	2d e0 37 11 80       	sub    $0x801137e0,%eax
80103236:	c1 f8 04             	sar    $0x4,%eax
80103239:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010323f:	c9                   	leave  
80103240:	c3                   	ret    

80103241 <myproc>:
myproc(void) {
80103241:	55                   	push   %ebp
80103242:	89 e5                	mov    %esp,%ebp
80103244:	53                   	push   %ebx
80103245:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103248:	e8 be 08 00 00       	call   80103b0b <pushcli>
  c = mycpu();
8010324d:	e8 78 ff ff ff       	call   801031ca <mycpu>
  p = c->proc;
80103252:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103258:	e8 eb 08 00 00       	call   80103b48 <popcli>
}
8010325d:	89 d8                	mov    %ebx,%eax
8010325f:	83 c4 04             	add    $0x4,%esp
80103262:	5b                   	pop    %ebx
80103263:	5d                   	pop    %ebp
80103264:	c3                   	ret    

80103265 <userinit>:
{
80103265:	55                   	push   %ebp
80103266:	89 e5                	mov    %esp,%ebp
80103268:	53                   	push   %ebx
80103269:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010326c:	e8 23 fe ff ff       	call   80103094 <allocproc>
80103271:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103273:	a3 c0 95 10 80       	mov    %eax,0x801095c0
  if((p->pgdir = setupkvm()) == 0)
80103278:	e8 85 2f 00 00       	call   80106202 <setupkvm>
8010327d:	89 43 04             	mov    %eax,0x4(%ebx)
80103280:	85 c0                	test   %eax,%eax
80103282:	0f 84 b7 00 00 00    	je     8010333f <userinit+0xda>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103288:	83 ec 04             	sub    $0x4,%esp
8010328b:	68 2c 00 00 00       	push   $0x2c
80103290:	68 60 94 10 80       	push   $0x80109460
80103295:	50                   	push   %eax
80103296:	e8 72 2c 00 00       	call   80105f0d <inituvm>
  p->sz = PGSIZE;
8010329b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801032a1:	83 c4 0c             	add    $0xc,%esp
801032a4:	6a 4c                	push   $0x4c
801032a6:	6a 00                	push   $0x0
801032a8:	ff 73 18             	pushl  0x18(%ebx)
801032ab:	e8 e4 09 00 00       	call   80103c94 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801032b0:	8b 43 18             	mov    0x18(%ebx),%eax
801032b3:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801032b9:	8b 43 18             	mov    0x18(%ebx),%eax
801032bc:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801032c2:	8b 43 18             	mov    0x18(%ebx),%eax
801032c5:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801032c9:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801032cd:	8b 43 18             	mov    0x18(%ebx),%eax
801032d0:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801032d4:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801032d8:	8b 43 18             	mov    0x18(%ebx),%eax
801032db:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801032e2:	8b 43 18             	mov    0x18(%ebx),%eax
801032e5:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801032ec:	8b 43 18             	mov    0x18(%ebx),%eax
801032ef:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801032f6:	8d 43 6c             	lea    0x6c(%ebx),%eax
801032f9:	83 c4 0c             	add    $0xc,%esp
801032fc:	6a 10                	push   $0x10
801032fe:	68 e5 69 10 80       	push   $0x801069e5
80103303:	50                   	push   %eax
80103304:	e8 f2 0a 00 00       	call   80103dfb <safestrcpy>
  p->cwd = namei("/");
80103309:	c7 04 24 ee 69 10 80 	movl   $0x801069ee,(%esp)
80103310:	e8 ff e8 ff ff       	call   80101c14 <namei>
80103315:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103318:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
8010331f:	e8 c4 08 00 00       	call   80103be8 <acquire>
  p->state = RUNNABLE;
80103324:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010332b:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
80103332:	e8 16 09 00 00       	call   80103c4d <release>
}
80103337:	83 c4 10             	add    $0x10,%esp
8010333a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010333d:	c9                   	leave  
8010333e:	c3                   	ret    
    panic("userinit: out of memory?");
8010333f:	83 ec 0c             	sub    $0xc,%esp
80103342:	68 cc 69 10 80       	push   $0x801069cc
80103347:	e8 fc cf ff ff       	call   80100348 <panic>

8010334c <growproc>:
{
8010334c:	55                   	push   %ebp
8010334d:	89 e5                	mov    %esp,%ebp
8010334f:	56                   	push   %esi
80103350:	53                   	push   %ebx
80103351:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
80103354:	e8 e8 fe ff ff       	call   80103241 <myproc>
80103359:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
8010335b:	8b 00                	mov    (%eax),%eax
  if(n > 0){
8010335d:	85 f6                	test   %esi,%esi
8010335f:	7f 21                	jg     80103382 <growproc+0x36>
  } else if(n < 0){
80103361:	85 f6                	test   %esi,%esi
80103363:	79 33                	jns    80103398 <growproc+0x4c>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103365:	83 ec 04             	sub    $0x4,%esp
80103368:	01 c6                	add    %eax,%esi
8010336a:	56                   	push   %esi
8010336b:	50                   	push   %eax
8010336c:	ff 73 04             	pushl  0x4(%ebx)
8010336f:	e8 a2 2c 00 00       	call   80106016 <deallocuvm>
80103374:	83 c4 10             	add    $0x10,%esp
80103377:	85 c0                	test   %eax,%eax
80103379:	75 1d                	jne    80103398 <growproc+0x4c>
      return -1;
8010337b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103380:	eb 29                	jmp    801033ab <growproc+0x5f>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103382:	83 ec 04             	sub    $0x4,%esp
80103385:	01 c6                	add    %eax,%esi
80103387:	56                   	push   %esi
80103388:	50                   	push   %eax
80103389:	ff 73 04             	pushl  0x4(%ebx)
8010338c:	e8 17 2d 00 00       	call   801060a8 <allocuvm>
80103391:	83 c4 10             	add    $0x10,%esp
80103394:	85 c0                	test   %eax,%eax
80103396:	74 1a                	je     801033b2 <growproc+0x66>
  curproc->sz = sz;
80103398:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010339a:	83 ec 0c             	sub    $0xc,%esp
8010339d:	53                   	push   %ebx
8010339e:	e8 52 2a 00 00       	call   80105df5 <switchuvm>
  return 0;
801033a3:	83 c4 10             	add    $0x10,%esp
801033a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801033ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033ae:	5b                   	pop    %ebx
801033af:	5e                   	pop    %esi
801033b0:	5d                   	pop    %ebp
801033b1:	c3                   	ret    
      return -1;
801033b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033b7:	eb f2                	jmp    801033ab <growproc+0x5f>

801033b9 <fork>:
{
801033b9:	55                   	push   %ebp
801033ba:	89 e5                	mov    %esp,%ebp
801033bc:	57                   	push   %edi
801033bd:	56                   	push   %esi
801033be:	53                   	push   %ebx
801033bf:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801033c2:	e8 7a fe ff ff       	call   80103241 <myproc>
801033c7:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801033c9:	e8 c6 fc ff ff       	call   80103094 <allocproc>
801033ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801033d1:	85 c0                	test   %eax,%eax
801033d3:	0f 84 e0 00 00 00    	je     801034b9 <fork+0x100>
801033d9:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801033db:	83 ec 08             	sub    $0x8,%esp
801033de:	ff 33                	pushl  (%ebx)
801033e0:	ff 73 04             	pushl  0x4(%ebx)
801033e3:	e8 cb 2e 00 00       	call   801062b3 <copyuvm>
801033e8:	89 47 04             	mov    %eax,0x4(%edi)
801033eb:	83 c4 10             	add    $0x10,%esp
801033ee:	85 c0                	test   %eax,%eax
801033f0:	74 2a                	je     8010341c <fork+0x63>
  np->sz = curproc->sz;
801033f2:	8b 03                	mov    (%ebx),%eax
801033f4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033f7:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801033f9:	89 c8                	mov    %ecx,%eax
801033fb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801033fe:	8b 73 18             	mov    0x18(%ebx),%esi
80103401:	8b 79 18             	mov    0x18(%ecx),%edi
80103404:	b9 13 00 00 00       	mov    $0x13,%ecx
80103409:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
8010340b:	8b 40 18             	mov    0x18(%eax),%eax
8010340e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103415:	be 00 00 00 00       	mov    $0x0,%esi
8010341a:	eb 29                	jmp    80103445 <fork+0x8c>
    kfree(np->kstack);
8010341c:	83 ec 0c             	sub    $0xc,%esp
8010341f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103422:	ff 73 08             	pushl  0x8(%ebx)
80103425:	e8 ad eb ff ff       	call   80101fd7 <kfree>
    np->kstack = 0;
8010342a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103431:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103438:	83 c4 10             	add    $0x10,%esp
8010343b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103440:	eb 6f                	jmp    801034b1 <fork+0xf8>
  for(i = 0; i < NOFILE; i++)
80103442:	83 c6 01             	add    $0x1,%esi
80103445:	83 fe 0f             	cmp    $0xf,%esi
80103448:	7f 1d                	jg     80103467 <fork+0xae>
    if(curproc->ofile[i])
8010344a:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010344e:	85 c0                	test   %eax,%eax
80103450:	74 f0                	je     80103442 <fork+0x89>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103452:	83 ec 0c             	sub    $0xc,%esp
80103455:	50                   	push   %eax
80103456:	e8 66 d8 ff ff       	call   80100cc1 <filedup>
8010345b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010345e:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80103462:	83 c4 10             	add    $0x10,%esp
80103465:	eb db                	jmp    80103442 <fork+0x89>
  np->cwd = idup(curproc->cwd);
80103467:	83 ec 0c             	sub    $0xc,%esp
8010346a:	ff 73 68             	pushl  0x68(%ebx)
8010346d:	e8 12 e1 ff ff       	call   80101584 <idup>
80103472:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103475:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103478:	83 c3 6c             	add    $0x6c,%ebx
8010347b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010347e:	83 c4 0c             	add    $0xc,%esp
80103481:	6a 10                	push   $0x10
80103483:	53                   	push   %ebx
80103484:	50                   	push   %eax
80103485:	e8 71 09 00 00       	call   80103dfb <safestrcpy>
  pid = np->pid;
8010348a:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
8010348d:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
80103494:	e8 4f 07 00 00       	call   80103be8 <acquire>
  np->state = RUNNABLE;
80103499:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801034a0:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
801034a7:	e8 a1 07 00 00       	call   80103c4d <release>
  return pid;
801034ac:	89 d8                	mov    %ebx,%eax
801034ae:	83 c4 10             	add    $0x10,%esp
}
801034b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034b4:	5b                   	pop    %ebx
801034b5:	5e                   	pop    %esi
801034b6:	5f                   	pop    %edi
801034b7:	5d                   	pop    %ebp
801034b8:	c3                   	ret    
    return -1;
801034b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034be:	eb f1                	jmp    801034b1 <fork+0xf8>

801034c0 <scheduler>:
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	57                   	push   %edi
801034c4:	56                   	push   %esi
801034c5:	53                   	push   %ebx
801034c6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801034c9:	e8 fc fc ff ff       	call   801031ca <mycpu>
801034ce:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801034d0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801034d7:	00 00 00 
801034da:	eb 65                	jmp    80103541 <scheduler+0x81>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801034dc:	83 eb 80             	sub    $0xffffff80,%ebx
801034df:	81 fb 14 b6 10 80    	cmp    $0x8010b614,%ebx
801034e5:	73 44                	jae    8010352b <scheduler+0x6b>
      if(p->state != RUNNABLE)
801034e7:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801034eb:	75 ef                	jne    801034dc <scheduler+0x1c>
      c->proc = p;
801034ed:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801034f3:	83 ec 0c             	sub    $0xc,%esp
801034f6:	53                   	push   %ebx
801034f7:	e8 f9 28 00 00       	call   80105df5 <switchuvm>
      p->state = RUNNING;
801034fc:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103503:	83 c4 08             	add    $0x8,%esp
80103506:	ff 73 1c             	pushl  0x1c(%ebx)
80103509:	8d 46 04             	lea    0x4(%esi),%eax
8010350c:	50                   	push   %eax
8010350d:	e8 3c 09 00 00       	call   80103e4e <swtch>
      switchkvm();
80103512:	e8 cc 28 00 00       	call   80105de3 <switchkvm>
      c->proc = 0;
80103517:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010351e:	00 00 00 
80103521:	83 c4 10             	add    $0x10,%esp
      idle = 0;  // not idle this timeslice
80103524:	bf 00 00 00 00       	mov    $0x0,%edi
80103529:	eb b1                	jmp    801034dc <scheduler+0x1c>
    release(&ptable.lock);
8010352b:	83 ec 0c             	sub    $0xc,%esp
8010352e:	68 e0 95 10 80       	push   $0x801095e0
80103533:	e8 15 07 00 00       	call   80103c4d <release>
    if (idle) {
80103538:	83 c4 10             	add    $0x10,%esp
8010353b:	85 ff                	test   %edi,%edi
8010353d:	74 02                	je     80103541 <scheduler+0x81>
  asm volatile("sti");
8010353f:	fb                   	sti    

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
  asm volatile("hlt");
80103540:	f4                   	hlt    
80103541:	fb                   	sti    
    acquire(&ptable.lock);
80103542:	83 ec 0c             	sub    $0xc,%esp
80103545:	68 e0 95 10 80       	push   $0x801095e0
8010354a:	e8 99 06 00 00       	call   80103be8 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010354f:	83 c4 10             	add    $0x10,%esp
    idle = 1;  // assume idle unless we schedule a process
80103552:	bf 01 00 00 00       	mov    $0x1,%edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103557:	bb 14 96 10 80       	mov    $0x80109614,%ebx
8010355c:	eb 81                	jmp    801034df <scheduler+0x1f>

8010355e <sched>:
{
8010355e:	55                   	push   %ebp
8010355f:	89 e5                	mov    %esp,%ebp
80103561:	56                   	push   %esi
80103562:	53                   	push   %ebx
  struct proc *p = myproc();
80103563:	e8 d9 fc ff ff       	call   80103241 <myproc>
80103568:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
8010356a:	83 ec 0c             	sub    $0xc,%esp
8010356d:	68 e0 95 10 80       	push   $0x801095e0
80103572:	e8 31 06 00 00       	call   80103ba8 <holding>
80103577:	83 c4 10             	add    $0x10,%esp
8010357a:	85 c0                	test   %eax,%eax
8010357c:	74 4f                	je     801035cd <sched+0x6f>
  if(mycpu()->ncli != 1)
8010357e:	e8 47 fc ff ff       	call   801031ca <mycpu>
80103583:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010358a:	75 4e                	jne    801035da <sched+0x7c>
  if(p->state == RUNNING)
8010358c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103590:	74 55                	je     801035e7 <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103592:	9c                   	pushf  
80103593:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103594:	f6 c4 02             	test   $0x2,%ah
80103597:	75 5b                	jne    801035f4 <sched+0x96>
  intena = mycpu()->intena;
80103599:	e8 2c fc ff ff       	call   801031ca <mycpu>
8010359e:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801035a4:	e8 21 fc ff ff       	call   801031ca <mycpu>
801035a9:	83 ec 08             	sub    $0x8,%esp
801035ac:	ff 70 04             	pushl  0x4(%eax)
801035af:	83 c3 1c             	add    $0x1c,%ebx
801035b2:	53                   	push   %ebx
801035b3:	e8 96 08 00 00       	call   80103e4e <swtch>
  mycpu()->intena = intena;
801035b8:	e8 0d fc ff ff       	call   801031ca <mycpu>
801035bd:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801035c3:	83 c4 10             	add    $0x10,%esp
801035c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035c9:	5b                   	pop    %ebx
801035ca:	5e                   	pop    %esi
801035cb:	5d                   	pop    %ebp
801035cc:	c3                   	ret    
    panic("sched ptable.lock");
801035cd:	83 ec 0c             	sub    $0xc,%esp
801035d0:	68 f0 69 10 80       	push   $0x801069f0
801035d5:	e8 6e cd ff ff       	call   80100348 <panic>
    panic("sched locks");
801035da:	83 ec 0c             	sub    $0xc,%esp
801035dd:	68 02 6a 10 80       	push   $0x80106a02
801035e2:	e8 61 cd ff ff       	call   80100348 <panic>
    panic("sched running");
801035e7:	83 ec 0c             	sub    $0xc,%esp
801035ea:	68 0e 6a 10 80       	push   $0x80106a0e
801035ef:	e8 54 cd ff ff       	call   80100348 <panic>
    panic("sched interruptible");
801035f4:	83 ec 0c             	sub    $0xc,%esp
801035f7:	68 1c 6a 10 80       	push   $0x80106a1c
801035fc:	e8 47 cd ff ff       	call   80100348 <panic>

80103601 <exit>:
{
80103601:	55                   	push   %ebp
80103602:	89 e5                	mov    %esp,%ebp
80103604:	56                   	push   %esi
80103605:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103606:	e8 36 fc ff ff       	call   80103241 <myproc>
  if(curproc == initproc)
8010360b:	39 05 c0 95 10 80    	cmp    %eax,0x801095c0
80103611:	74 09                	je     8010361c <exit+0x1b>
80103613:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
80103615:	bb 00 00 00 00       	mov    $0x0,%ebx
8010361a:	eb 10                	jmp    8010362c <exit+0x2b>
    panic("init exiting");
8010361c:	83 ec 0c             	sub    $0xc,%esp
8010361f:	68 30 6a 10 80       	push   $0x80106a30
80103624:	e8 1f cd ff ff       	call   80100348 <panic>
  for(fd = 0; fd < NOFILE; fd++){
80103629:	83 c3 01             	add    $0x1,%ebx
8010362c:	83 fb 0f             	cmp    $0xf,%ebx
8010362f:	7f 1e                	jg     8010364f <exit+0x4e>
    if(curproc->ofile[fd]){
80103631:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
80103635:	85 c0                	test   %eax,%eax
80103637:	74 f0                	je     80103629 <exit+0x28>
      fileclose(curproc->ofile[fd]);
80103639:	83 ec 0c             	sub    $0xc,%esp
8010363c:	50                   	push   %eax
8010363d:	e8 c4 d6 ff ff       	call   80100d06 <fileclose>
      curproc->ofile[fd] = 0;
80103642:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
80103649:	00 
8010364a:	83 c4 10             	add    $0x10,%esp
8010364d:	eb da                	jmp    80103629 <exit+0x28>
  begin_op();
8010364f:	e8 8d f1 ff ff       	call   801027e1 <begin_op>
  iput(curproc->cwd);
80103654:	83 ec 0c             	sub    $0xc,%esp
80103657:	ff 76 68             	pushl  0x68(%esi)
8010365a:	e8 5c e0 ff ff       	call   801016bb <iput>
  end_op();
8010365f:	e8 f7 f1 ff ff       	call   8010285b <end_op>
  curproc->cwd = 0;
80103664:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010366b:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
80103672:	e8 71 05 00 00       	call   80103be8 <acquire>
  wakeup1(curproc->parent);
80103677:	8b 46 14             	mov    0x14(%esi),%eax
8010367a:	e8 ea f9 ff ff       	call   80103069 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010367f:	83 c4 10             	add    $0x10,%esp
80103682:	bb 14 96 10 80       	mov    $0x80109614,%ebx
80103687:	eb 03                	jmp    8010368c <exit+0x8b>
80103689:	83 eb 80             	sub    $0xffffff80,%ebx
8010368c:	81 fb 14 b6 10 80    	cmp    $0x8010b614,%ebx
80103692:	73 1a                	jae    801036ae <exit+0xad>
    if(p->parent == curproc){
80103694:	39 73 14             	cmp    %esi,0x14(%ebx)
80103697:	75 f0                	jne    80103689 <exit+0x88>
      p->parent = initproc;
80103699:	a1 c0 95 10 80       	mov    0x801095c0,%eax
8010369e:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
801036a1:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801036a5:	75 e2                	jne    80103689 <exit+0x88>
        wakeup1(initproc);
801036a7:	e8 bd f9 ff ff       	call   80103069 <wakeup1>
801036ac:	eb db                	jmp    80103689 <exit+0x88>
  curproc->state = ZOMBIE;
801036ae:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  curproc->sz = 0;
801036b5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  sched();
801036bb:	e8 9e fe ff ff       	call   8010355e <sched>
  panic("zombie exit");
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	68 3d 6a 10 80       	push   $0x80106a3d
801036c8:	e8 7b cc ff ff       	call   80100348 <panic>

801036cd <yield>:
{
801036cd:	55                   	push   %ebp
801036ce:	89 e5                	mov    %esp,%ebp
801036d0:	53                   	push   %ebx
801036d1:	83 ec 04             	sub    $0x4,%esp
  struct proc *curproc = myproc();
801036d4:	e8 68 fb ff ff       	call   80103241 <myproc>
801036d9:	89 c3                	mov    %eax,%ebx
  acquire(&ptable.lock);  //DOC: yieldlock
801036db:	83 ec 0c             	sub    $0xc,%esp
801036de:	68 e0 95 10 80       	push   $0x801095e0
801036e3:	e8 00 05 00 00       	call   80103be8 <acquire>
  curproc->state = RUNNABLE;
801036e8:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801036ef:	e8 6a fe ff ff       	call   8010355e <sched>
  release(&ptable.lock);
801036f4:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
801036fb:	e8 4d 05 00 00       	call   80103c4d <release>
}
80103700:	83 c4 10             	add    $0x10,%esp
80103703:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103706:	c9                   	leave  
80103707:	c3                   	ret    

80103708 <sleep>:
{
80103708:	55                   	push   %ebp
80103709:	89 e5                	mov    %esp,%ebp
8010370b:	56                   	push   %esi
8010370c:	53                   	push   %ebx
8010370d:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103710:	e8 2c fb ff ff       	call   80103241 <myproc>
  if(p == 0)
80103715:	85 c0                	test   %eax,%eax
80103717:	74 72                	je     8010378b <sleep+0x83>
80103719:	89 c3                	mov    %eax,%ebx
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010371b:	81 fe e0 95 10 80    	cmp    $0x801095e0,%esi
80103721:	74 20                	je     80103743 <sleep+0x3b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103723:	83 ec 0c             	sub    $0xc,%esp
80103726:	68 e0 95 10 80       	push   $0x801095e0
8010372b:	e8 b8 04 00 00       	call   80103be8 <acquire>
    if (lk) release(lk);
80103730:	83 c4 10             	add    $0x10,%esp
80103733:	85 f6                	test   %esi,%esi
80103735:	74 0c                	je     80103743 <sleep+0x3b>
80103737:	83 ec 0c             	sub    $0xc,%esp
8010373a:	56                   	push   %esi
8010373b:	e8 0d 05 00 00       	call   80103c4d <release>
80103740:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80103743:	8b 45 08             	mov    0x8(%ebp),%eax
80103746:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
80103749:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103750:	e8 09 fe ff ff       	call   8010355e <sched>
  p->chan = 0;
80103755:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010375c:	81 fe e0 95 10 80    	cmp    $0x801095e0,%esi
80103762:	74 20                	je     80103784 <sleep+0x7c>
    release(&ptable.lock);
80103764:	83 ec 0c             	sub    $0xc,%esp
80103767:	68 e0 95 10 80       	push   $0x801095e0
8010376c:	e8 dc 04 00 00       	call   80103c4d <release>
    if (lk) acquire(lk);
80103771:	83 c4 10             	add    $0x10,%esp
80103774:	85 f6                	test   %esi,%esi
80103776:	74 0c                	je     80103784 <sleep+0x7c>
80103778:	83 ec 0c             	sub    $0xc,%esp
8010377b:	56                   	push   %esi
8010377c:	e8 67 04 00 00       	call   80103be8 <acquire>
80103781:	83 c4 10             	add    $0x10,%esp
}
80103784:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103787:	5b                   	pop    %ebx
80103788:	5e                   	pop    %esi
80103789:	5d                   	pop    %ebp
8010378a:	c3                   	ret    
    panic("sleep");
8010378b:	83 ec 0c             	sub    $0xc,%esp
8010378e:	68 49 6a 10 80       	push   $0x80106a49
80103793:	e8 b0 cb ff ff       	call   80100348 <panic>

80103798 <wait>:
{
80103798:	55                   	push   %ebp
80103799:	89 e5                	mov    %esp,%ebp
8010379b:	56                   	push   %esi
8010379c:	53                   	push   %ebx
  struct proc *curproc = myproc();
8010379d:	e8 9f fa ff ff       	call   80103241 <myproc>
801037a2:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801037a4:	83 ec 0c             	sub    $0xc,%esp
801037a7:	68 e0 95 10 80       	push   $0x801095e0
801037ac:	e8 37 04 00 00       	call   80103be8 <acquire>
801037b1:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801037b4:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037b9:	bb 14 96 10 80       	mov    $0x80109614,%ebx
801037be:	eb 5b                	jmp    8010381b <wait+0x83>
        pid = p->pid;
801037c0:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801037c3:	83 ec 0c             	sub    $0xc,%esp
801037c6:	ff 73 08             	pushl  0x8(%ebx)
801037c9:	e8 09 e8 ff ff       	call   80101fd7 <kfree>
        p->kstack = 0;
801037ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801037d5:	83 c4 04             	add    $0x4,%esp
801037d8:	ff 73 04             	pushl  0x4(%ebx)
801037db:	e8 b2 29 00 00       	call   80106192 <freevm>
        p->pid = 0;
801037e0:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801037e7:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801037ee:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801037f2:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801037f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103800:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
80103807:	e8 41 04 00 00       	call   80103c4d <release>
        return pid;
8010380c:	89 f0                	mov    %esi,%eax
8010380e:	83 c4 10             	add    $0x10,%esp
}
80103811:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103814:	5b                   	pop    %ebx
80103815:	5e                   	pop    %esi
80103816:	5d                   	pop    %ebp
80103817:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103818:	83 eb 80             	sub    $0xffffff80,%ebx
8010381b:	81 fb 14 b6 10 80    	cmp    $0x8010b614,%ebx
80103821:	73 12                	jae    80103835 <wait+0x9d>
      if(p->parent != curproc)
80103823:	39 73 14             	cmp    %esi,0x14(%ebx)
80103826:	75 f0                	jne    80103818 <wait+0x80>
      if(p->state == ZOMBIE){
80103828:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010382c:	74 92                	je     801037c0 <wait+0x28>
      havekids = 1;
8010382e:	b8 01 00 00 00       	mov    $0x1,%eax
80103833:	eb e3                	jmp    80103818 <wait+0x80>
    if(!havekids || curproc->killed){
80103835:	85 c0                	test   %eax,%eax
80103837:	74 06                	je     8010383f <wait+0xa7>
80103839:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
8010383d:	74 17                	je     80103856 <wait+0xbe>
      release(&ptable.lock);
8010383f:	83 ec 0c             	sub    $0xc,%esp
80103842:	68 e0 95 10 80       	push   $0x801095e0
80103847:	e8 01 04 00 00       	call   80103c4d <release>
      return -1;
8010384c:	83 c4 10             	add    $0x10,%esp
8010384f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103854:	eb bb                	jmp    80103811 <wait+0x79>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103856:	83 ec 08             	sub    $0x8,%esp
80103859:	68 e0 95 10 80       	push   $0x801095e0
8010385e:	56                   	push   %esi
8010385f:	e8 a4 fe ff ff       	call   80103708 <sleep>
    havekids = 0;
80103864:	83 c4 10             	add    $0x10,%esp
80103867:	e9 48 ff ff ff       	jmp    801037b4 <wait+0x1c>

8010386c <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010386c:	55                   	push   %ebp
8010386d:	89 e5                	mov    %esp,%ebp
8010386f:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80103872:	68 e0 95 10 80       	push   $0x801095e0
80103877:	e8 6c 03 00 00       	call   80103be8 <acquire>
  wakeup1(chan);
8010387c:	8b 45 08             	mov    0x8(%ebp),%eax
8010387f:	e8 e5 f7 ff ff       	call   80103069 <wakeup1>
  release(&ptable.lock);
80103884:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
8010388b:	e8 bd 03 00 00       	call   80103c4d <release>
}
80103890:	83 c4 10             	add    $0x10,%esp
80103893:	c9                   	leave  
80103894:	c3                   	ret    

80103895 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103895:	55                   	push   %ebp
80103896:	89 e5                	mov    %esp,%ebp
80103898:	53                   	push   %ebx
80103899:	83 ec 10             	sub    $0x10,%esp
8010389c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010389f:	68 e0 95 10 80       	push   $0x801095e0
801038a4:	e8 3f 03 00 00       	call   80103be8 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038a9:	83 c4 10             	add    $0x10,%esp
801038ac:	b8 14 96 10 80       	mov    $0x80109614,%eax
801038b1:	3d 14 b6 10 80       	cmp    $0x8010b614,%eax
801038b6:	73 3a                	jae    801038f2 <kill+0x5d>
    if(p->pid == pid){
801038b8:	39 58 10             	cmp    %ebx,0x10(%eax)
801038bb:	74 05                	je     801038c2 <kill+0x2d>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038bd:	83 e8 80             	sub    $0xffffff80,%eax
801038c0:	eb ef                	jmp    801038b1 <kill+0x1c>
      p->killed = 1;
801038c2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801038c9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801038cd:	74 1a                	je     801038e9 <kill+0x54>
        p->state = RUNNABLE;
      release(&ptable.lock);
801038cf:	83 ec 0c             	sub    $0xc,%esp
801038d2:	68 e0 95 10 80       	push   $0x801095e0
801038d7:	e8 71 03 00 00       	call   80103c4d <release>
      return 0;
801038dc:	83 c4 10             	add    $0x10,%esp
801038df:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801038e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038e7:	c9                   	leave  
801038e8:	c3                   	ret    
        p->state = RUNNABLE;
801038e9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801038f0:	eb dd                	jmp    801038cf <kill+0x3a>
  release(&ptable.lock);
801038f2:	83 ec 0c             	sub    $0xc,%esp
801038f5:	68 e0 95 10 80       	push   $0x801095e0
801038fa:	e8 4e 03 00 00       	call   80103c4d <release>
  return -1;
801038ff:	83 c4 10             	add    $0x10,%esp
80103902:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103907:	eb db                	jmp    801038e4 <kill+0x4f>

80103909 <procdump>:
}
#endif

void
procdump(void)
{
80103909:	55                   	push   %ebp
8010390a:	89 e5                	mov    %esp,%ebp
8010390c:	56                   	push   %esi
8010390d:	53                   	push   %ebx
8010390e:	83 ec 3c             	sub    $0x3c,%esp
#define HEADER "\nPID\tName         Elapsed\tState\tSize\t PCs\n"
#else
#define HEADER "\n"
#endif

  cprintf(HEADER);  // not conditionally compiled as must work in all project states
80103911:	68 b7 6d 10 80       	push   $0x80106db7
80103916:	e8 f0 cc ff ff       	call   8010060b <cprintf>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010391b:	83 c4 10             	add    $0x10,%esp
8010391e:	bb 14 96 10 80       	mov    $0x80109614,%ebx
80103923:	eb 33                	jmp    80103958 <procdump+0x4f>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
80103925:	b8 4f 6a 10 80       	mov    $0x80106a4f,%eax
#if defined(CS333_P2)
    procdumpP2P3P4(p, state);
#elif defined(CS333_P1)
    procdumpP1(p, state);
#else
    cprintf("%d\t%s\t%s\t", p->pid, p->name, state);
8010392a:	8d 53 6c             	lea    0x6c(%ebx),%edx
8010392d:	50                   	push   %eax
8010392e:	52                   	push   %edx
8010392f:	ff 73 10             	pushl  0x10(%ebx)
80103932:	68 53 6a 10 80       	push   $0x80106a53
80103937:	e8 cf cc ff ff       	call   8010060b <cprintf>
#endif

    if(p->state == SLEEPING){
8010393c:	83 c4 10             	add    $0x10,%esp
8010393f:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103943:	74 39                	je     8010397e <procdump+0x75>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103945:	83 ec 0c             	sub    $0xc,%esp
80103948:	68 b7 6d 10 80       	push   $0x80106db7
8010394d:	e8 b9 cc ff ff       	call   8010060b <cprintf>
80103952:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103955:	83 eb 80             	sub    $0xffffff80,%ebx
80103958:	81 fb 14 b6 10 80    	cmp    $0x8010b614,%ebx
8010395e:	73 61                	jae    801039c1 <procdump+0xb8>
    if(p->state == UNUSED)
80103960:	8b 43 0c             	mov    0xc(%ebx),%eax
80103963:	85 c0                	test   %eax,%eax
80103965:	74 ee                	je     80103955 <procdump+0x4c>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103967:	83 f8 05             	cmp    $0x5,%eax
8010396a:	77 b9                	ja     80103925 <procdump+0x1c>
8010396c:	8b 04 85 b0 6a 10 80 	mov    -0x7fef9550(,%eax,4),%eax
80103973:	85 c0                	test   %eax,%eax
80103975:	75 b3                	jne    8010392a <procdump+0x21>
      state = "???";
80103977:	b8 4f 6a 10 80       	mov    $0x80106a4f,%eax
8010397c:	eb ac                	jmp    8010392a <procdump+0x21>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010397e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103981:	8b 40 0c             	mov    0xc(%eax),%eax
80103984:	83 c0 08             	add    $0x8,%eax
80103987:	83 ec 08             	sub    $0x8,%esp
8010398a:	8d 55 d0             	lea    -0x30(%ebp),%edx
8010398d:	52                   	push   %edx
8010398e:	50                   	push   %eax
8010398f:	e8 33 01 00 00       	call   80103ac7 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103994:	83 c4 10             	add    $0x10,%esp
80103997:	be 00 00 00 00       	mov    $0x0,%esi
8010399c:	eb 14                	jmp    801039b2 <procdump+0xa9>
        cprintf(" %p", pc[i]);
8010399e:	83 ec 08             	sub    $0x8,%esp
801039a1:	50                   	push   %eax
801039a2:	68 a1 64 10 80       	push   $0x801064a1
801039a7:	e8 5f cc ff ff       	call   8010060b <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801039ac:	83 c6 01             	add    $0x1,%esi
801039af:	83 c4 10             	add    $0x10,%esp
801039b2:	83 fe 09             	cmp    $0x9,%esi
801039b5:	7f 8e                	jg     80103945 <procdump+0x3c>
801039b7:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
801039bb:	85 c0                	test   %eax,%eax
801039bd:	75 df                	jne    8010399e <procdump+0x95>
801039bf:	eb 84                	jmp    80103945 <procdump+0x3c>
  }
#ifdef CS333_P1
  cprintf("$ ");  // simulate shell prompt
#endif // CS333_P1
}
801039c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039c4:	5b                   	pop    %ebx
801039c5:	5e                   	pop    %esi
801039c6:	5d                   	pop    %ebp
801039c7:	c3                   	ret    

801039c8 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801039c8:	55                   	push   %ebp
801039c9:	89 e5                	mov    %esp,%ebp
801039cb:	53                   	push   %ebx
801039cc:	83 ec 0c             	sub    $0xc,%esp
801039cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801039d2:	68 c8 6a 10 80       	push   $0x80106ac8
801039d7:	8d 43 04             	lea    0x4(%ebx),%eax
801039da:	50                   	push   %eax
801039db:	e8 cc 00 00 00       	call   80103aac <initlock>
  lk->name = name;
801039e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801039e3:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
801039e6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801039ec:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
801039f3:	83 c4 10             	add    $0x10,%esp
801039f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039f9:	c9                   	leave  
801039fa:	c3                   	ret    

801039fb <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801039fb:	55                   	push   %ebp
801039fc:	89 e5                	mov    %esp,%ebp
801039fe:	56                   	push   %esi
801039ff:	53                   	push   %ebx
80103a00:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103a03:	8d 73 04             	lea    0x4(%ebx),%esi
80103a06:	83 ec 0c             	sub    $0xc,%esp
80103a09:	56                   	push   %esi
80103a0a:	e8 d9 01 00 00       	call   80103be8 <acquire>
  while (lk->locked) {
80103a0f:	83 c4 10             	add    $0x10,%esp
80103a12:	eb 0d                	jmp    80103a21 <acquiresleep+0x26>
    sleep(lk, &lk->lk);
80103a14:	83 ec 08             	sub    $0x8,%esp
80103a17:	56                   	push   %esi
80103a18:	53                   	push   %ebx
80103a19:	e8 ea fc ff ff       	call   80103708 <sleep>
80103a1e:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80103a21:	83 3b 00             	cmpl   $0x0,(%ebx)
80103a24:	75 ee                	jne    80103a14 <acquiresleep+0x19>
  }
  lk->locked = 1;
80103a26:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103a2c:	e8 10 f8 ff ff       	call   80103241 <myproc>
80103a31:	8b 40 10             	mov    0x10(%eax),%eax
80103a34:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103a37:	83 ec 0c             	sub    $0xc,%esp
80103a3a:	56                   	push   %esi
80103a3b:	e8 0d 02 00 00       	call   80103c4d <release>
}
80103a40:	83 c4 10             	add    $0x10,%esp
80103a43:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a46:	5b                   	pop    %ebx
80103a47:	5e                   	pop    %esi
80103a48:	5d                   	pop    %ebp
80103a49:	c3                   	ret    

80103a4a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103a4a:	55                   	push   %ebp
80103a4b:	89 e5                	mov    %esp,%ebp
80103a4d:	56                   	push   %esi
80103a4e:	53                   	push   %ebx
80103a4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103a52:	8d 73 04             	lea    0x4(%ebx),%esi
80103a55:	83 ec 0c             	sub    $0xc,%esp
80103a58:	56                   	push   %esi
80103a59:	e8 8a 01 00 00       	call   80103be8 <acquire>
  lk->locked = 0;
80103a5e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103a64:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103a6b:	89 1c 24             	mov    %ebx,(%esp)
80103a6e:	e8 f9 fd ff ff       	call   8010386c <wakeup>
  release(&lk->lk);
80103a73:	89 34 24             	mov    %esi,(%esp)
80103a76:	e8 d2 01 00 00       	call   80103c4d <release>
}
80103a7b:	83 c4 10             	add    $0x10,%esp
80103a7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a81:	5b                   	pop    %ebx
80103a82:	5e                   	pop    %esi
80103a83:	5d                   	pop    %ebp
80103a84:	c3                   	ret    

80103a85 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103a85:	55                   	push   %ebp
80103a86:	89 e5                	mov    %esp,%ebp
80103a88:	56                   	push   %esi
80103a89:	53                   	push   %ebx
80103a8a:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80103a8d:	8d 5e 04             	lea    0x4(%esi),%ebx
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	53                   	push   %ebx
80103a94:	e8 4f 01 00 00       	call   80103be8 <acquire>
  r = lk->locked;
80103a99:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80103a9b:	89 1c 24             	mov    %ebx,(%esp)
80103a9e:	e8 aa 01 00 00       	call   80103c4d <release>
  return r;
}
80103aa3:	89 f0                	mov    %esi,%eax
80103aa5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aa8:	5b                   	pop    %ebx
80103aa9:	5e                   	pop    %esi
80103aaa:	5d                   	pop    %ebp
80103aab:	c3                   	ret    

80103aac <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103aac:	55                   	push   %ebp
80103aad:	89 e5                	mov    %esp,%ebp
80103aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103ab2:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ab5:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103ab8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103abe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103ac5:	5d                   	pop    %ebp
80103ac6:	c3                   	ret    

80103ac7 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103ac7:	55                   	push   %ebp
80103ac8:	89 e5                	mov    %esp,%ebp
80103aca:	53                   	push   %ebx
80103acb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103ace:	8b 45 08             	mov    0x8(%ebp),%eax
80103ad1:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103ad4:	b8 00 00 00 00       	mov    $0x0,%eax
80103ad9:	83 f8 09             	cmp    $0x9,%eax
80103adc:	7f 25                	jg     80103b03 <getcallerpcs+0x3c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103ade:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103ae4:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103aea:	77 17                	ja     80103b03 <getcallerpcs+0x3c>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103aec:	8b 5a 04             	mov    0x4(%edx),%ebx
80103aef:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103af2:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103af4:	83 c0 01             	add    $0x1,%eax
80103af7:	eb e0                	jmp    80103ad9 <getcallerpcs+0x12>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103af9:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103b00:	83 c0 01             	add    $0x1,%eax
80103b03:	83 f8 09             	cmp    $0x9,%eax
80103b06:	7e f1                	jle    80103af9 <getcallerpcs+0x32>
}
80103b08:	5b                   	pop    %ebx
80103b09:	5d                   	pop    %ebp
80103b0a:	c3                   	ret    

80103b0b <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103b0b:	55                   	push   %ebp
80103b0c:	89 e5                	mov    %esp,%ebp
80103b0e:	53                   	push   %ebx
80103b0f:	83 ec 04             	sub    $0x4,%esp
80103b12:	9c                   	pushf  
80103b13:	5b                   	pop    %ebx
  asm volatile("cli");
80103b14:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103b15:	e8 b0 f6 ff ff       	call   801031ca <mycpu>
80103b1a:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103b21:	74 12                	je     80103b35 <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103b23:	e8 a2 f6 ff ff       	call   801031ca <mycpu>
80103b28:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103b2f:	83 c4 04             	add    $0x4,%esp
80103b32:	5b                   	pop    %ebx
80103b33:	5d                   	pop    %ebp
80103b34:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103b35:	e8 90 f6 ff ff       	call   801031ca <mycpu>
80103b3a:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103b40:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103b46:	eb db                	jmp    80103b23 <pushcli+0x18>

80103b48 <popcli>:

void
popcli(void)
{
80103b48:	55                   	push   %ebp
80103b49:	89 e5                	mov    %esp,%ebp
80103b4b:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b4e:	9c                   	pushf  
80103b4f:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b50:	f6 c4 02             	test   $0x2,%ah
80103b53:	75 28                	jne    80103b7d <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103b55:	e8 70 f6 ff ff       	call   801031ca <mycpu>
80103b5a:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103b60:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103b63:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103b69:	85 d2                	test   %edx,%edx
80103b6b:	78 1d                	js     80103b8a <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103b6d:	e8 58 f6 ff ff       	call   801031ca <mycpu>
80103b72:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103b79:	74 1c                	je     80103b97 <popcli+0x4f>
    sti();
}
80103b7b:	c9                   	leave  
80103b7c:	c3                   	ret    
    panic("popcli - interruptible");
80103b7d:	83 ec 0c             	sub    $0xc,%esp
80103b80:	68 d3 6a 10 80       	push   $0x80106ad3
80103b85:	e8 be c7 ff ff       	call   80100348 <panic>
    panic("popcli");
80103b8a:	83 ec 0c             	sub    $0xc,%esp
80103b8d:	68 ea 6a 10 80       	push   $0x80106aea
80103b92:	e8 b1 c7 ff ff       	call   80100348 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103b97:	e8 2e f6 ff ff       	call   801031ca <mycpu>
80103b9c:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103ba3:	74 d6                	je     80103b7b <popcli+0x33>
  asm volatile("sti");
80103ba5:	fb                   	sti    
}
80103ba6:	eb d3                	jmp    80103b7b <popcli+0x33>

80103ba8 <holding>:
{
80103ba8:	55                   	push   %ebp
80103ba9:	89 e5                	mov    %esp,%ebp
80103bab:	53                   	push   %ebx
80103bac:	83 ec 04             	sub    $0x4,%esp
80103baf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103bb2:	e8 54 ff ff ff       	call   80103b0b <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103bb7:	83 3b 00             	cmpl   $0x0,(%ebx)
80103bba:	75 12                	jne    80103bce <holding+0x26>
80103bbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103bc1:	e8 82 ff ff ff       	call   80103b48 <popcli>
}
80103bc6:	89 d8                	mov    %ebx,%eax
80103bc8:	83 c4 04             	add    $0x4,%esp
80103bcb:	5b                   	pop    %ebx
80103bcc:	5d                   	pop    %ebp
80103bcd:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103bce:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103bd1:	e8 f4 f5 ff ff       	call   801031ca <mycpu>
80103bd6:	39 c3                	cmp    %eax,%ebx
80103bd8:	74 07                	je     80103be1 <holding+0x39>
80103bda:	bb 00 00 00 00       	mov    $0x0,%ebx
80103bdf:	eb e0                	jmp    80103bc1 <holding+0x19>
80103be1:	bb 01 00 00 00       	mov    $0x1,%ebx
80103be6:	eb d9                	jmp    80103bc1 <holding+0x19>

80103be8 <acquire>:
{
80103be8:	55                   	push   %ebp
80103be9:	89 e5                	mov    %esp,%ebp
80103beb:	53                   	push   %ebx
80103bec:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103bef:	e8 17 ff ff ff       	call   80103b0b <pushcli>
  if(holding(lk))
80103bf4:	83 ec 0c             	sub    $0xc,%esp
80103bf7:	ff 75 08             	pushl  0x8(%ebp)
80103bfa:	e8 a9 ff ff ff       	call   80103ba8 <holding>
80103bff:	83 c4 10             	add    $0x10,%esp
80103c02:	85 c0                	test   %eax,%eax
80103c04:	75 3a                	jne    80103c40 <acquire+0x58>
  while(xchg(&lk->locked, 1) != 0)
80103c06:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103c09:	b8 01 00 00 00       	mov    $0x1,%eax
80103c0e:	f0 87 02             	lock xchg %eax,(%edx)
80103c11:	85 c0                	test   %eax,%eax
80103c13:	75 f1                	jne    80103c06 <acquire+0x1e>
  __sync_synchronize();
80103c15:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103c1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c1d:	e8 a8 f5 ff ff       	call   801031ca <mycpu>
80103c22:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103c25:	8b 45 08             	mov    0x8(%ebp),%eax
80103c28:	83 c0 0c             	add    $0xc,%eax
80103c2b:	83 ec 08             	sub    $0x8,%esp
80103c2e:	50                   	push   %eax
80103c2f:	8d 45 08             	lea    0x8(%ebp),%eax
80103c32:	50                   	push   %eax
80103c33:	e8 8f fe ff ff       	call   80103ac7 <getcallerpcs>
}
80103c38:	83 c4 10             	add    $0x10,%esp
80103c3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c3e:	c9                   	leave  
80103c3f:	c3                   	ret    
    panic("acquire");
80103c40:	83 ec 0c             	sub    $0xc,%esp
80103c43:	68 f1 6a 10 80       	push   $0x80106af1
80103c48:	e8 fb c6 ff ff       	call   80100348 <panic>

80103c4d <release>:
{
80103c4d:	55                   	push   %ebp
80103c4e:	89 e5                	mov    %esp,%ebp
80103c50:	53                   	push   %ebx
80103c51:	83 ec 10             	sub    $0x10,%esp
80103c54:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103c57:	53                   	push   %ebx
80103c58:	e8 4b ff ff ff       	call   80103ba8 <holding>
80103c5d:	83 c4 10             	add    $0x10,%esp
80103c60:	85 c0                	test   %eax,%eax
80103c62:	74 23                	je     80103c87 <release+0x3a>
  lk->pcs[0] = 0;
80103c64:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103c6b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103c72:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103c77:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103c7d:	e8 c6 fe ff ff       	call   80103b48 <popcli>
}
80103c82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c85:	c9                   	leave  
80103c86:	c3                   	ret    
    panic("release");
80103c87:	83 ec 0c             	sub    $0xc,%esp
80103c8a:	68 f9 6a 10 80       	push   $0x80106af9
80103c8f:	e8 b4 c6 ff ff       	call   80100348 <panic>

80103c94 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	57                   	push   %edi
80103c98:	53                   	push   %ebx
80103c99:	8b 55 08             	mov    0x8(%ebp),%edx
80103c9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80103c9f:	f6 c2 03             	test   $0x3,%dl
80103ca2:	75 05                	jne    80103ca9 <memset+0x15>
80103ca4:	f6 c1 03             	test   $0x3,%cl
80103ca7:	74 0e                	je     80103cb7 <memset+0x23>
  asm volatile("cld; rep stosb" :
80103ca9:	89 d7                	mov    %edx,%edi
80103cab:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cae:	fc                   	cld    
80103caf:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80103cb1:	89 d0                	mov    %edx,%eax
80103cb3:	5b                   	pop    %ebx
80103cb4:	5f                   	pop    %edi
80103cb5:	5d                   	pop    %ebp
80103cb6:	c3                   	ret    
    c &= 0xFF;
80103cb7:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103cbb:	c1 e9 02             	shr    $0x2,%ecx
80103cbe:	89 f8                	mov    %edi,%eax
80103cc0:	c1 e0 18             	shl    $0x18,%eax
80103cc3:	89 fb                	mov    %edi,%ebx
80103cc5:	c1 e3 10             	shl    $0x10,%ebx
80103cc8:	09 d8                	or     %ebx,%eax
80103cca:	89 fb                	mov    %edi,%ebx
80103ccc:	c1 e3 08             	shl    $0x8,%ebx
80103ccf:	09 d8                	or     %ebx,%eax
80103cd1:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103cd3:	89 d7                	mov    %edx,%edi
80103cd5:	fc                   	cld    
80103cd6:	f3 ab                	rep stos %eax,%es:(%edi)
80103cd8:	eb d7                	jmp    80103cb1 <memset+0x1d>

80103cda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103cda:	55                   	push   %ebp
80103cdb:	89 e5                	mov    %esp,%ebp
80103cdd:	56                   	push   %esi
80103cde:	53                   	push   %ebx
80103cdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103ce8:	8d 70 ff             	lea    -0x1(%eax),%esi
80103ceb:	85 c0                	test   %eax,%eax
80103ced:	74 1c                	je     80103d0b <memcmp+0x31>
    if(*s1 != *s2)
80103cef:	0f b6 01             	movzbl (%ecx),%eax
80103cf2:	0f b6 1a             	movzbl (%edx),%ebx
80103cf5:	38 d8                	cmp    %bl,%al
80103cf7:	75 0a                	jne    80103d03 <memcmp+0x29>
      return *s1 - *s2;
    s1++, s2++;
80103cf9:	83 c1 01             	add    $0x1,%ecx
80103cfc:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80103cff:	89 f0                	mov    %esi,%eax
80103d01:	eb e5                	jmp    80103ce8 <memcmp+0xe>
      return *s1 - *s2;
80103d03:	0f b6 c0             	movzbl %al,%eax
80103d06:	0f b6 db             	movzbl %bl,%ebx
80103d09:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80103d0b:	5b                   	pop    %ebx
80103d0c:	5e                   	pop    %esi
80103d0d:	5d                   	pop    %ebp
80103d0e:	c3                   	ret    

80103d0f <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103d0f:	55                   	push   %ebp
80103d10:	89 e5                	mov    %esp,%ebp
80103d12:	56                   	push   %esi
80103d13:	53                   	push   %ebx
80103d14:	8b 45 08             	mov    0x8(%ebp),%eax
80103d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103d1a:	8b 55 10             	mov    0x10(%ebp),%edx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103d1d:	39 c1                	cmp    %eax,%ecx
80103d1f:	73 3a                	jae    80103d5b <memmove+0x4c>
80103d21:	8d 1c 11             	lea    (%ecx,%edx,1),%ebx
80103d24:	39 c3                	cmp    %eax,%ebx
80103d26:	76 37                	jbe    80103d5f <memmove+0x50>
    s += n;
    d += n;
80103d28:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    while(n-- > 0)
80103d2b:	eb 0d                	jmp    80103d3a <memmove+0x2b>
      *--d = *--s;
80103d2d:	83 eb 01             	sub    $0x1,%ebx
80103d30:	83 e9 01             	sub    $0x1,%ecx
80103d33:	0f b6 13             	movzbl (%ebx),%edx
80103d36:	88 11                	mov    %dl,(%ecx)
    while(n-- > 0)
80103d38:	89 f2                	mov    %esi,%edx
80103d3a:	8d 72 ff             	lea    -0x1(%edx),%esi
80103d3d:	85 d2                	test   %edx,%edx
80103d3f:	75 ec                	jne    80103d2d <memmove+0x1e>
80103d41:	eb 14                	jmp    80103d57 <memmove+0x48>
  } else
    while(n-- > 0)
      *d++ = *s++;
80103d43:	0f b6 11             	movzbl (%ecx),%edx
80103d46:	88 13                	mov    %dl,(%ebx)
80103d48:	8d 5b 01             	lea    0x1(%ebx),%ebx
80103d4b:	8d 49 01             	lea    0x1(%ecx),%ecx
    while(n-- > 0)
80103d4e:	89 f2                	mov    %esi,%edx
80103d50:	8d 72 ff             	lea    -0x1(%edx),%esi
80103d53:	85 d2                	test   %edx,%edx
80103d55:	75 ec                	jne    80103d43 <memmove+0x34>

  return dst;
}
80103d57:	5b                   	pop    %ebx
80103d58:	5e                   	pop    %esi
80103d59:	5d                   	pop    %ebp
80103d5a:	c3                   	ret    
80103d5b:	89 c3                	mov    %eax,%ebx
80103d5d:	eb f1                	jmp    80103d50 <memmove+0x41>
80103d5f:	89 c3                	mov    %eax,%ebx
80103d61:	eb ed                	jmp    80103d50 <memmove+0x41>

80103d63 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103d63:	55                   	push   %ebp
80103d64:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80103d66:	ff 75 10             	pushl  0x10(%ebp)
80103d69:	ff 75 0c             	pushl  0xc(%ebp)
80103d6c:	ff 75 08             	pushl  0x8(%ebp)
80103d6f:	e8 9b ff ff ff       	call   80103d0f <memmove>
}
80103d74:	c9                   	leave  
80103d75:	c3                   	ret    

80103d76 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103d76:	55                   	push   %ebp
80103d77:	89 e5                	mov    %esp,%ebp
80103d79:	53                   	push   %ebx
80103d7a:	8b 55 08             	mov    0x8(%ebp),%edx
80103d7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103d80:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80103d83:	eb 09                	jmp    80103d8e <strncmp+0x18>
    n--, p++, q++;
80103d85:	83 e8 01             	sub    $0x1,%eax
80103d88:	83 c2 01             	add    $0x1,%edx
80103d8b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80103d8e:	85 c0                	test   %eax,%eax
80103d90:	74 0b                	je     80103d9d <strncmp+0x27>
80103d92:	0f b6 1a             	movzbl (%edx),%ebx
80103d95:	84 db                	test   %bl,%bl
80103d97:	74 04                	je     80103d9d <strncmp+0x27>
80103d99:	3a 19                	cmp    (%ecx),%bl
80103d9b:	74 e8                	je     80103d85 <strncmp+0xf>
  if(n == 0)
80103d9d:	85 c0                	test   %eax,%eax
80103d9f:	74 0b                	je     80103dac <strncmp+0x36>
    return 0;
  return (uchar)*p - (uchar)*q;
80103da1:	0f b6 02             	movzbl (%edx),%eax
80103da4:	0f b6 11             	movzbl (%ecx),%edx
80103da7:	29 d0                	sub    %edx,%eax
}
80103da9:	5b                   	pop    %ebx
80103daa:	5d                   	pop    %ebp
80103dab:	c3                   	ret    
    return 0;
80103dac:	b8 00 00 00 00       	mov    $0x0,%eax
80103db1:	eb f6                	jmp    80103da9 <strncmp+0x33>

80103db3 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103db3:	55                   	push   %ebp
80103db4:	89 e5                	mov    %esp,%ebp
80103db6:	57                   	push   %edi
80103db7:	56                   	push   %esi
80103db8:	53                   	push   %ebx
80103db9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103dbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103dbf:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc2:	eb 04                	jmp    80103dc8 <strncpy+0x15>
80103dc4:	89 fb                	mov    %edi,%ebx
80103dc6:	89 f0                	mov    %esi,%eax
80103dc8:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103dcb:	85 c9                	test   %ecx,%ecx
80103dcd:	7e 1d                	jle    80103dec <strncpy+0x39>
80103dcf:	8d 7b 01             	lea    0x1(%ebx),%edi
80103dd2:	8d 70 01             	lea    0x1(%eax),%esi
80103dd5:	0f b6 1b             	movzbl (%ebx),%ebx
80103dd8:	88 18                	mov    %bl,(%eax)
80103dda:	89 d1                	mov    %edx,%ecx
80103ddc:	84 db                	test   %bl,%bl
80103dde:	75 e4                	jne    80103dc4 <strncpy+0x11>
80103de0:	89 f0                	mov    %esi,%eax
80103de2:	eb 08                	jmp    80103dec <strncpy+0x39>
    ;
  while(n-- > 0)
    *s++ = 0;
80103de4:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80103de7:	89 ca                	mov    %ecx,%edx
    *s++ = 0;
80103de9:	8d 40 01             	lea    0x1(%eax),%eax
  while(n-- > 0)
80103dec:	8d 4a ff             	lea    -0x1(%edx),%ecx
80103def:	85 d2                	test   %edx,%edx
80103df1:	7f f1                	jg     80103de4 <strncpy+0x31>
  return os;
}
80103df3:	8b 45 08             	mov    0x8(%ebp),%eax
80103df6:	5b                   	pop    %ebx
80103df7:	5e                   	pop    %esi
80103df8:	5f                   	pop    %edi
80103df9:	5d                   	pop    %ebp
80103dfa:	c3                   	ret    

80103dfb <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103dfb:	55                   	push   %ebp
80103dfc:	89 e5                	mov    %esp,%ebp
80103dfe:	57                   	push   %edi
80103dff:	56                   	push   %esi
80103e00:	53                   	push   %ebx
80103e01:	8b 45 08             	mov    0x8(%ebp),%eax
80103e04:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103e07:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80103e0a:	85 d2                	test   %edx,%edx
80103e0c:	7e 23                	jle    80103e31 <safestrcpy+0x36>
80103e0e:	89 c1                	mov    %eax,%ecx
80103e10:	eb 04                	jmp    80103e16 <safestrcpy+0x1b>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103e12:	89 fb                	mov    %edi,%ebx
80103e14:	89 f1                	mov    %esi,%ecx
80103e16:	83 ea 01             	sub    $0x1,%edx
80103e19:	85 d2                	test   %edx,%edx
80103e1b:	7e 11                	jle    80103e2e <safestrcpy+0x33>
80103e1d:	8d 7b 01             	lea    0x1(%ebx),%edi
80103e20:	8d 71 01             	lea    0x1(%ecx),%esi
80103e23:	0f b6 1b             	movzbl (%ebx),%ebx
80103e26:	88 19                	mov    %bl,(%ecx)
80103e28:	84 db                	test   %bl,%bl
80103e2a:	75 e6                	jne    80103e12 <safestrcpy+0x17>
80103e2c:	89 f1                	mov    %esi,%ecx
    ;
  *s = 0;
80103e2e:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80103e31:	5b                   	pop    %ebx
80103e32:	5e                   	pop    %esi
80103e33:	5f                   	pop    %edi
80103e34:	5d                   	pop    %ebp
80103e35:	c3                   	ret    

80103e36 <strlen>:

int
strlen(const char *s)
{
80103e36:	55                   	push   %ebp
80103e37:	89 e5                	mov    %esp,%ebp
80103e39:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103e3c:	b8 00 00 00 00       	mov    $0x0,%eax
80103e41:	eb 03                	jmp    80103e46 <strlen+0x10>
80103e43:	83 c0 01             	add    $0x1,%eax
80103e46:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103e4a:	75 f7                	jne    80103e43 <strlen+0xd>
    ;
  return n;
}
80103e4c:	5d                   	pop    %ebp
80103e4d:	c3                   	ret    

80103e4e <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80103e4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80103e52:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80103e56:	55                   	push   %ebp
  pushl %ebx
80103e57:	53                   	push   %ebx
  pushl %esi
80103e58:	56                   	push   %esi
  pushl %edi
80103e59:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80103e5a:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80103e5c:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80103e5e:	5f                   	pop    %edi
  popl %esi
80103e5f:	5e                   	pop    %esi
  popl %ebx
80103e60:	5b                   	pop    %ebx
  popl %ebp
80103e61:	5d                   	pop    %ebp
  ret
80103e62:	c3                   	ret    

80103e63 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103e63:	55                   	push   %ebp
80103e64:	89 e5                	mov    %esp,%ebp
80103e66:	53                   	push   %ebx
80103e67:	83 ec 04             	sub    $0x4,%esp
80103e6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103e6d:	e8 cf f3 ff ff       	call   80103241 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103e72:	8b 00                	mov    (%eax),%eax
80103e74:	39 d8                	cmp    %ebx,%eax
80103e76:	76 19                	jbe    80103e91 <fetchint+0x2e>
80103e78:	8d 53 04             	lea    0x4(%ebx),%edx
80103e7b:	39 d0                	cmp    %edx,%eax
80103e7d:	72 19                	jb     80103e98 <fetchint+0x35>
    return -1;
  *ip = *(int*)(addr);
80103e7f:	8b 13                	mov    (%ebx),%edx
80103e81:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e84:	89 10                	mov    %edx,(%eax)
  return 0;
80103e86:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103e8b:	83 c4 04             	add    $0x4,%esp
80103e8e:	5b                   	pop    %ebx
80103e8f:	5d                   	pop    %ebp
80103e90:	c3                   	ret    
    return -1;
80103e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e96:	eb f3                	jmp    80103e8b <fetchint+0x28>
80103e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e9d:	eb ec                	jmp    80103e8b <fetchint+0x28>

80103e9f <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103e9f:	55                   	push   %ebp
80103ea0:	89 e5                	mov    %esp,%ebp
80103ea2:	53                   	push   %ebx
80103ea3:	83 ec 04             	sub    $0x4,%esp
80103ea6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103ea9:	e8 93 f3 ff ff       	call   80103241 <myproc>

  if(addr >= curproc->sz)
80103eae:	39 18                	cmp    %ebx,(%eax)
80103eb0:	76 26                	jbe    80103ed8 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
80103eb2:	8b 55 0c             	mov    0xc(%ebp),%edx
80103eb5:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80103eb7:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80103eb9:	89 d8                	mov    %ebx,%eax
80103ebb:	39 d0                	cmp    %edx,%eax
80103ebd:	73 0e                	jae    80103ecd <fetchstr+0x2e>
    if(*s == 0)
80103ebf:	80 38 00             	cmpb   $0x0,(%eax)
80103ec2:	74 05                	je     80103ec9 <fetchstr+0x2a>
  for(s = *pp; s < ep; s++){
80103ec4:	83 c0 01             	add    $0x1,%eax
80103ec7:	eb f2                	jmp    80103ebb <fetchstr+0x1c>
      return s - *pp;
80103ec9:	29 d8                	sub    %ebx,%eax
80103ecb:	eb 05                	jmp    80103ed2 <fetchstr+0x33>
  }
  return -1;
80103ecd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ed2:	83 c4 04             	add    $0x4,%esp
80103ed5:	5b                   	pop    %ebx
80103ed6:	5d                   	pop    %ebp
80103ed7:	c3                   	ret    
    return -1;
80103ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103edd:	eb f3                	jmp    80103ed2 <fetchstr+0x33>

80103edf <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80103edf:	55                   	push   %ebp
80103ee0:	89 e5                	mov    %esp,%ebp
80103ee2:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80103ee5:	e8 57 f3 ff ff       	call   80103241 <myproc>
80103eea:	8b 50 18             	mov    0x18(%eax),%edx
80103eed:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef0:	c1 e0 02             	shl    $0x2,%eax
80103ef3:	03 42 44             	add    0x44(%edx),%eax
80103ef6:	83 ec 08             	sub    $0x8,%esp
80103ef9:	ff 75 0c             	pushl  0xc(%ebp)
80103efc:	83 c0 04             	add    $0x4,%eax
80103eff:	50                   	push   %eax
80103f00:	e8 5e ff ff ff       	call   80103e63 <fetchint>
}
80103f05:	c9                   	leave  
80103f06:	c3                   	ret    

80103f07 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80103f07:	55                   	push   %ebp
80103f08:	89 e5                	mov    %esp,%ebp
80103f0a:	56                   	push   %esi
80103f0b:	53                   	push   %ebx
80103f0c:	83 ec 10             	sub    $0x10,%esp
80103f0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80103f12:	e8 2a f3 ff ff       	call   80103241 <myproc>
80103f17:	89 c6                	mov    %eax,%esi

  if(argint(n, &i) < 0)
80103f19:	83 ec 08             	sub    $0x8,%esp
80103f1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103f1f:	50                   	push   %eax
80103f20:	ff 75 08             	pushl  0x8(%ebp)
80103f23:	e8 b7 ff ff ff       	call   80103edf <argint>
80103f28:	83 c4 10             	add    $0x10,%esp
80103f2b:	85 c0                	test   %eax,%eax
80103f2d:	78 24                	js     80103f53 <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80103f2f:	85 db                	test   %ebx,%ebx
80103f31:	78 27                	js     80103f5a <argptr+0x53>
80103f33:	8b 16                	mov    (%esi),%edx
80103f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f38:	39 c2                	cmp    %eax,%edx
80103f3a:	76 25                	jbe    80103f61 <argptr+0x5a>
80103f3c:	01 c3                	add    %eax,%ebx
80103f3e:	39 da                	cmp    %ebx,%edx
80103f40:	72 26                	jb     80103f68 <argptr+0x61>
    return -1;
  *pp = (char*)i;
80103f42:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f45:	89 02                	mov    %eax,(%edx)
  return 0;
80103f47:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103f4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f4f:	5b                   	pop    %ebx
80103f50:	5e                   	pop    %esi
80103f51:	5d                   	pop    %ebp
80103f52:	c3                   	ret    
    return -1;
80103f53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f58:	eb f2                	jmp    80103f4c <argptr+0x45>
    return -1;
80103f5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f5f:	eb eb                	jmp    80103f4c <argptr+0x45>
80103f61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f66:	eb e4                	jmp    80103f4c <argptr+0x45>
80103f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f6d:	eb dd                	jmp    80103f4c <argptr+0x45>

80103f6f <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80103f6f:	55                   	push   %ebp
80103f70:	89 e5                	mov    %esp,%ebp
80103f72:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80103f75:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103f78:	50                   	push   %eax
80103f79:	ff 75 08             	pushl  0x8(%ebp)
80103f7c:	e8 5e ff ff ff       	call   80103edf <argint>
80103f81:	83 c4 10             	add    $0x10,%esp
80103f84:	85 c0                	test   %eax,%eax
80103f86:	78 13                	js     80103f9b <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
80103f88:	83 ec 08             	sub    $0x8,%esp
80103f8b:	ff 75 0c             	pushl  0xc(%ebp)
80103f8e:	ff 75 f4             	pushl  -0xc(%ebp)
80103f91:	e8 09 ff ff ff       	call   80103e9f <fetchstr>
80103f96:	83 c4 10             	add    $0x10,%esp
}
80103f99:	c9                   	leave  
80103f9a:	c3                   	ret    
    return -1;
80103f9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fa0:	eb f7                	jmp    80103f99 <argstr+0x2a>

80103fa2 <syscall>:
};
#endif // PRINT_SYSCALLS

void
syscall(void)
{
80103fa2:	55                   	push   %ebp
80103fa3:	89 e5                	mov    %esp,%ebp
80103fa5:	53                   	push   %ebx
80103fa6:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80103fa9:	e8 93 f2 ff ff       	call   80103241 <myproc>
80103fae:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80103fb0:	8b 40 18             	mov    0x18(%eax),%eax
80103fb3:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80103fb6:	8d 50 ff             	lea    -0x1(%eax),%edx
80103fb9:	83 fa 15             	cmp    $0x15,%edx
80103fbc:	77 18                	ja     80103fd6 <syscall+0x34>
80103fbe:	8b 14 85 20 6b 10 80 	mov    -0x7fef94e0(,%eax,4),%edx
80103fc5:	85 d2                	test   %edx,%edx
80103fc7:	74 0d                	je     80103fd6 <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
80103fc9:	ff d2                	call   *%edx
80103fcb:	8b 53 18             	mov    0x18(%ebx),%edx
80103fce:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80103fd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fd4:	c9                   	leave  
80103fd5:	c3                   	ret    
            curproc->pid, curproc->name, num);
80103fd6:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
80103fd9:	50                   	push   %eax
80103fda:	52                   	push   %edx
80103fdb:	ff 73 10             	pushl  0x10(%ebx)
80103fde:	68 01 6b 10 80       	push   $0x80106b01
80103fe3:	e8 23 c6 ff ff       	call   8010060b <cprintf>
    curproc->tf->eax = -1;
80103fe8:	8b 43 18             	mov    0x18(%ebx),%eax
80103feb:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80103ff2:	83 c4 10             	add    $0x10,%esp
}
80103ff5:	eb da                	jmp    80103fd1 <syscall+0x2f>

80103ff7 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80103ff7:	55                   	push   %ebp
80103ff8:	89 e5                	mov    %esp,%ebp
80103ffa:	56                   	push   %esi
80103ffb:	53                   	push   %ebx
80103ffc:	83 ec 18             	sub    $0x18,%esp
80103fff:	89 d6                	mov    %edx,%esi
80104001:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104003:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104006:	52                   	push   %edx
80104007:	50                   	push   %eax
80104008:	e8 d2 fe ff ff       	call   80103edf <argint>
8010400d:	83 c4 10             	add    $0x10,%esp
80104010:	85 c0                	test   %eax,%eax
80104012:	78 2e                	js     80104042 <argfd+0x4b>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104014:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104018:	77 2f                	ja     80104049 <argfd+0x52>
8010401a:	e8 22 f2 ff ff       	call   80103241 <myproc>
8010401f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104022:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104026:	85 c0                	test   %eax,%eax
80104028:	74 26                	je     80104050 <argfd+0x59>
    return -1;
  if(pfd)
8010402a:	85 f6                	test   %esi,%esi
8010402c:	74 02                	je     80104030 <argfd+0x39>
    *pfd = fd;
8010402e:	89 16                	mov    %edx,(%esi)
  if(pf)
80104030:	85 db                	test   %ebx,%ebx
80104032:	74 23                	je     80104057 <argfd+0x60>
    *pf = f;
80104034:	89 03                	mov    %eax,(%ebx)
  return 0;
80104036:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010403b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010403e:	5b                   	pop    %ebx
8010403f:	5e                   	pop    %esi
80104040:	5d                   	pop    %ebp
80104041:	c3                   	ret    
    return -1;
80104042:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104047:	eb f2                	jmp    8010403b <argfd+0x44>
    return -1;
80104049:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010404e:	eb eb                	jmp    8010403b <argfd+0x44>
80104050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104055:	eb e4                	jmp    8010403b <argfd+0x44>
  return 0;
80104057:	b8 00 00 00 00       	mov    $0x0,%eax
8010405c:	eb dd                	jmp    8010403b <argfd+0x44>

8010405e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010405e:	55                   	push   %ebp
8010405f:	89 e5                	mov    %esp,%ebp
80104061:	53                   	push   %ebx
80104062:	83 ec 04             	sub    $0x4,%esp
80104065:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80104067:	e8 d5 f1 ff ff       	call   80103241 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010406c:	ba 00 00 00 00       	mov    $0x0,%edx
80104071:	83 fa 0f             	cmp    $0xf,%edx
80104074:	7f 18                	jg     8010408e <fdalloc+0x30>
    if(curproc->ofile[fd] == 0){
80104076:	83 7c 90 28 00       	cmpl   $0x0,0x28(%eax,%edx,4)
8010407b:	74 05                	je     80104082 <fdalloc+0x24>
  for(fd = 0; fd < NOFILE; fd++){
8010407d:	83 c2 01             	add    $0x1,%edx
80104080:	eb ef                	jmp    80104071 <fdalloc+0x13>
      curproc->ofile[fd] = f;
80104082:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
      return fd;
    }
  }
  return -1;
}
80104086:	89 d0                	mov    %edx,%eax
80104088:	83 c4 04             	add    $0x4,%esp
8010408b:	5b                   	pop    %ebx
8010408c:	5d                   	pop    %ebp
8010408d:	c3                   	ret    
  return -1;
8010408e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80104093:	eb f1                	jmp    80104086 <fdalloc+0x28>

80104095 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80104095:	55                   	push   %ebp
80104096:	89 e5                	mov    %esp,%ebp
80104098:	56                   	push   %esi
80104099:	53                   	push   %ebx
8010409a:	83 ec 10             	sub    $0x10,%esp
8010409d:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010409f:	b8 20 00 00 00       	mov    $0x20,%eax
801040a4:	89 c6                	mov    %eax,%esi
801040a6:	39 43 58             	cmp    %eax,0x58(%ebx)
801040a9:	76 2e                	jbe    801040d9 <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801040ab:	6a 10                	push   $0x10
801040ad:	50                   	push   %eax
801040ae:	8d 45 e8             	lea    -0x18(%ebp),%eax
801040b1:	50                   	push   %eax
801040b2:	53                   	push   %ebx
801040b3:	e8 ee d6 ff ff       	call   801017a6 <readi>
801040b8:	83 c4 10             	add    $0x10,%esp
801040bb:	83 f8 10             	cmp    $0x10,%eax
801040be:	75 0c                	jne    801040cc <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
801040c0:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
801040c5:	75 1e                	jne    801040e5 <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801040c7:	8d 46 10             	lea    0x10(%esi),%eax
801040ca:	eb d8                	jmp    801040a4 <isdirempty+0xf>
      panic("isdirempty: readi");
801040cc:	83 ec 0c             	sub    $0xc,%esp
801040cf:	68 7c 6b 10 80       	push   $0x80106b7c
801040d4:	e8 6f c2 ff ff       	call   80100348 <panic>
      return 0;
  }
  return 1;
801040d9:	b8 01 00 00 00       	mov    $0x1,%eax
}
801040de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040e1:	5b                   	pop    %ebx
801040e2:	5e                   	pop    %esi
801040e3:	5d                   	pop    %ebp
801040e4:	c3                   	ret    
      return 0;
801040e5:	b8 00 00 00 00       	mov    $0x0,%eax
801040ea:	eb f2                	jmp    801040de <isdirempty+0x49>

801040ec <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801040ec:	55                   	push   %ebp
801040ed:	89 e5                	mov    %esp,%ebp
801040ef:	57                   	push   %edi
801040f0:	56                   	push   %esi
801040f1:	53                   	push   %ebx
801040f2:	83 ec 44             	sub    $0x44,%esp
801040f5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801040f8:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801040fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801040fe:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80104101:	52                   	push   %edx
80104102:	50                   	push   %eax
80104103:	e8 24 db ff ff       	call   80101c2c <nameiparent>
80104108:	89 c6                	mov    %eax,%esi
8010410a:	83 c4 10             	add    $0x10,%esp
8010410d:	85 c0                	test   %eax,%eax
8010410f:	0f 84 3a 01 00 00    	je     8010424f <create+0x163>
    return 0;
  ilock(dp);
80104115:	83 ec 0c             	sub    $0xc,%esp
80104118:	50                   	push   %eax
80104119:	e8 96 d4 ff ff       	call   801015b4 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010411e:	83 c4 0c             	add    $0xc,%esp
80104121:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104124:	50                   	push   %eax
80104125:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104128:	50                   	push   %eax
80104129:	56                   	push   %esi
8010412a:	e8 b4 d8 ff ff       	call   801019e3 <dirlookup>
8010412f:	89 c3                	mov    %eax,%ebx
80104131:	83 c4 10             	add    $0x10,%esp
80104134:	85 c0                	test   %eax,%eax
80104136:	74 3f                	je     80104177 <create+0x8b>
    iunlockput(dp);
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	56                   	push   %esi
8010413c:	e8 1a d6 ff ff       	call   8010175b <iunlockput>
    ilock(ip);
80104141:	89 1c 24             	mov    %ebx,(%esp)
80104144:	e8 6b d4 ff ff       	call   801015b4 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104149:	83 c4 10             	add    $0x10,%esp
8010414c:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104151:	75 11                	jne    80104164 <create+0x78>
80104153:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104158:	75 0a                	jne    80104164 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010415a:	89 d8                	mov    %ebx,%eax
8010415c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010415f:	5b                   	pop    %ebx
80104160:	5e                   	pop    %esi
80104161:	5f                   	pop    %edi
80104162:	5d                   	pop    %ebp
80104163:	c3                   	ret    
    iunlockput(ip);
80104164:	83 ec 0c             	sub    $0xc,%esp
80104167:	53                   	push   %ebx
80104168:	e8 ee d5 ff ff       	call   8010175b <iunlockput>
    return 0;
8010416d:	83 c4 10             	add    $0x10,%esp
80104170:	bb 00 00 00 00       	mov    $0x0,%ebx
80104175:	eb e3                	jmp    8010415a <create+0x6e>
  if((ip = ialloc(dp->dev, type)) == 0)
80104177:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
8010417b:	83 ec 08             	sub    $0x8,%esp
8010417e:	50                   	push   %eax
8010417f:	ff 36                	pushl  (%esi)
80104181:	e8 2b d2 ff ff       	call   801013b1 <ialloc>
80104186:	89 c3                	mov    %eax,%ebx
80104188:	83 c4 10             	add    $0x10,%esp
8010418b:	85 c0                	test   %eax,%eax
8010418d:	74 55                	je     801041e4 <create+0xf8>
  ilock(ip);
8010418f:	83 ec 0c             	sub    $0xc,%esp
80104192:	50                   	push   %eax
80104193:	e8 1c d4 ff ff       	call   801015b4 <ilock>
  ip->major = major;
80104198:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
8010419c:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801041a0:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
801041a4:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
801041aa:	89 1c 24             	mov    %ebx,(%esp)
801041ad:	e8 a1 d2 ff ff       	call   80101453 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801041b2:	83 c4 10             	add    $0x10,%esp
801041b5:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801041ba:	74 35                	je     801041f1 <create+0x105>
  if(dirlink(dp, name, ip->inum) < 0)
801041bc:	83 ec 04             	sub    $0x4,%esp
801041bf:	ff 73 04             	pushl  0x4(%ebx)
801041c2:	8d 45 d6             	lea    -0x2a(%ebp),%eax
801041c5:	50                   	push   %eax
801041c6:	56                   	push   %esi
801041c7:	e8 97 d9 ff ff       	call   80101b63 <dirlink>
801041cc:	83 c4 10             	add    $0x10,%esp
801041cf:	85 c0                	test   %eax,%eax
801041d1:	78 6f                	js     80104242 <create+0x156>
  iunlockput(dp);
801041d3:	83 ec 0c             	sub    $0xc,%esp
801041d6:	56                   	push   %esi
801041d7:	e8 7f d5 ff ff       	call   8010175b <iunlockput>
  return ip;
801041dc:	83 c4 10             	add    $0x10,%esp
801041df:	e9 76 ff ff ff       	jmp    8010415a <create+0x6e>
    panic("create: ialloc");
801041e4:	83 ec 0c             	sub    $0xc,%esp
801041e7:	68 8e 6b 10 80       	push   $0x80106b8e
801041ec:	e8 57 c1 ff ff       	call   80100348 <panic>
    dp->nlink++;  // for ".."
801041f1:	0f b7 46 56          	movzwl 0x56(%esi),%eax
801041f5:	83 c0 01             	add    $0x1,%eax
801041f8:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
801041fc:	83 ec 0c             	sub    $0xc,%esp
801041ff:	56                   	push   %esi
80104200:	e8 4e d2 ff ff       	call   80101453 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104205:	83 c4 0c             	add    $0xc,%esp
80104208:	ff 73 04             	pushl  0x4(%ebx)
8010420b:	68 9e 6b 10 80       	push   $0x80106b9e
80104210:	53                   	push   %ebx
80104211:	e8 4d d9 ff ff       	call   80101b63 <dirlink>
80104216:	83 c4 10             	add    $0x10,%esp
80104219:	85 c0                	test   %eax,%eax
8010421b:	78 18                	js     80104235 <create+0x149>
8010421d:	83 ec 04             	sub    $0x4,%esp
80104220:	ff 76 04             	pushl  0x4(%esi)
80104223:	68 9d 6b 10 80       	push   $0x80106b9d
80104228:	53                   	push   %ebx
80104229:	e8 35 d9 ff ff       	call   80101b63 <dirlink>
8010422e:	83 c4 10             	add    $0x10,%esp
80104231:	85 c0                	test   %eax,%eax
80104233:	79 87                	jns    801041bc <create+0xd0>
      panic("create dots");
80104235:	83 ec 0c             	sub    $0xc,%esp
80104238:	68 a0 6b 10 80       	push   $0x80106ba0
8010423d:	e8 06 c1 ff ff       	call   80100348 <panic>
    panic("create: dirlink");
80104242:	83 ec 0c             	sub    $0xc,%esp
80104245:	68 ac 6b 10 80       	push   $0x80106bac
8010424a:	e8 f9 c0 ff ff       	call   80100348 <panic>
    return 0;
8010424f:	89 c3                	mov    %eax,%ebx
80104251:	e9 04 ff ff ff       	jmp    8010415a <create+0x6e>

80104256 <sys_dup>:
{
80104256:	55                   	push   %ebp
80104257:	89 e5                	mov    %esp,%ebp
80104259:	53                   	push   %ebx
8010425a:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
8010425d:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104260:	ba 00 00 00 00       	mov    $0x0,%edx
80104265:	b8 00 00 00 00       	mov    $0x0,%eax
8010426a:	e8 88 fd ff ff       	call   80103ff7 <argfd>
8010426f:	85 c0                	test   %eax,%eax
80104271:	78 23                	js     80104296 <sys_dup+0x40>
  if((fd=fdalloc(f)) < 0)
80104273:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104276:	e8 e3 fd ff ff       	call   8010405e <fdalloc>
8010427b:	89 c3                	mov    %eax,%ebx
8010427d:	85 c0                	test   %eax,%eax
8010427f:	78 1c                	js     8010429d <sys_dup+0x47>
  filedup(f);
80104281:	83 ec 0c             	sub    $0xc,%esp
80104284:	ff 75 f4             	pushl  -0xc(%ebp)
80104287:	e8 35 ca ff ff       	call   80100cc1 <filedup>
  return fd;
8010428c:	83 c4 10             	add    $0x10,%esp
}
8010428f:	89 d8                	mov    %ebx,%eax
80104291:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104294:	c9                   	leave  
80104295:	c3                   	ret    
    return -1;
80104296:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010429b:	eb f2                	jmp    8010428f <sys_dup+0x39>
    return -1;
8010429d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801042a2:	eb eb                	jmp    8010428f <sys_dup+0x39>

801042a4 <sys_read>:
{
801042a4:	55                   	push   %ebp
801042a5:	89 e5                	mov    %esp,%ebp
801042a7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801042aa:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801042ad:	ba 00 00 00 00       	mov    $0x0,%edx
801042b2:	b8 00 00 00 00       	mov    $0x0,%eax
801042b7:	e8 3b fd ff ff       	call   80103ff7 <argfd>
801042bc:	85 c0                	test   %eax,%eax
801042be:	78 43                	js     80104303 <sys_read+0x5f>
801042c0:	83 ec 08             	sub    $0x8,%esp
801042c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801042c6:	50                   	push   %eax
801042c7:	6a 02                	push   $0x2
801042c9:	e8 11 fc ff ff       	call   80103edf <argint>
801042ce:	83 c4 10             	add    $0x10,%esp
801042d1:	85 c0                	test   %eax,%eax
801042d3:	78 35                	js     8010430a <sys_read+0x66>
801042d5:	83 ec 04             	sub    $0x4,%esp
801042d8:	ff 75 f0             	pushl  -0x10(%ebp)
801042db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801042de:	50                   	push   %eax
801042df:	6a 01                	push   $0x1
801042e1:	e8 21 fc ff ff       	call   80103f07 <argptr>
801042e6:	83 c4 10             	add    $0x10,%esp
801042e9:	85 c0                	test   %eax,%eax
801042eb:	78 24                	js     80104311 <sys_read+0x6d>
  return fileread(f, p, n);
801042ed:	83 ec 04             	sub    $0x4,%esp
801042f0:	ff 75 f0             	pushl  -0x10(%ebp)
801042f3:	ff 75 ec             	pushl  -0x14(%ebp)
801042f6:	ff 75 f4             	pushl  -0xc(%ebp)
801042f9:	e8 0c cb ff ff       	call   80100e0a <fileread>
801042fe:	83 c4 10             	add    $0x10,%esp
}
80104301:	c9                   	leave  
80104302:	c3                   	ret    
    return -1;
80104303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104308:	eb f7                	jmp    80104301 <sys_read+0x5d>
8010430a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010430f:	eb f0                	jmp    80104301 <sys_read+0x5d>
80104311:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104316:	eb e9                	jmp    80104301 <sys_read+0x5d>

80104318 <sys_write>:
{
80104318:	55                   	push   %ebp
80104319:	89 e5                	mov    %esp,%ebp
8010431b:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010431e:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104321:	ba 00 00 00 00       	mov    $0x0,%edx
80104326:	b8 00 00 00 00       	mov    $0x0,%eax
8010432b:	e8 c7 fc ff ff       	call   80103ff7 <argfd>
80104330:	85 c0                	test   %eax,%eax
80104332:	78 43                	js     80104377 <sys_write+0x5f>
80104334:	83 ec 08             	sub    $0x8,%esp
80104337:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010433a:	50                   	push   %eax
8010433b:	6a 02                	push   $0x2
8010433d:	e8 9d fb ff ff       	call   80103edf <argint>
80104342:	83 c4 10             	add    $0x10,%esp
80104345:	85 c0                	test   %eax,%eax
80104347:	78 35                	js     8010437e <sys_write+0x66>
80104349:	83 ec 04             	sub    $0x4,%esp
8010434c:	ff 75 f0             	pushl  -0x10(%ebp)
8010434f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104352:	50                   	push   %eax
80104353:	6a 01                	push   $0x1
80104355:	e8 ad fb ff ff       	call   80103f07 <argptr>
8010435a:	83 c4 10             	add    $0x10,%esp
8010435d:	85 c0                	test   %eax,%eax
8010435f:	78 24                	js     80104385 <sys_write+0x6d>
  return filewrite(f, p, n);
80104361:	83 ec 04             	sub    $0x4,%esp
80104364:	ff 75 f0             	pushl  -0x10(%ebp)
80104367:	ff 75 ec             	pushl  -0x14(%ebp)
8010436a:	ff 75 f4             	pushl  -0xc(%ebp)
8010436d:	e8 1d cb ff ff       	call   80100e8f <filewrite>
80104372:	83 c4 10             	add    $0x10,%esp
}
80104375:	c9                   	leave  
80104376:	c3                   	ret    
    return -1;
80104377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010437c:	eb f7                	jmp    80104375 <sys_write+0x5d>
8010437e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104383:	eb f0                	jmp    80104375 <sys_write+0x5d>
80104385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010438a:	eb e9                	jmp    80104375 <sys_write+0x5d>

8010438c <sys_close>:
{
8010438c:	55                   	push   %ebp
8010438d:	89 e5                	mov    %esp,%ebp
8010438f:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104392:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104395:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104398:	b8 00 00 00 00       	mov    $0x0,%eax
8010439d:	e8 55 fc ff ff       	call   80103ff7 <argfd>
801043a2:	85 c0                	test   %eax,%eax
801043a4:	78 25                	js     801043cb <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
801043a6:	e8 96 ee ff ff       	call   80103241 <myproc>
801043ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043ae:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801043b5:	00 
  fileclose(f);
801043b6:	83 ec 0c             	sub    $0xc,%esp
801043b9:	ff 75 f0             	pushl  -0x10(%ebp)
801043bc:	e8 45 c9 ff ff       	call   80100d06 <fileclose>
  return 0;
801043c1:	83 c4 10             	add    $0x10,%esp
801043c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801043c9:	c9                   	leave  
801043ca:	c3                   	ret    
    return -1;
801043cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043d0:	eb f7                	jmp    801043c9 <sys_close+0x3d>

801043d2 <sys_fstat>:
{
801043d2:	55                   	push   %ebp
801043d3:	89 e5                	mov    %esp,%ebp
801043d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801043d8:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043db:	ba 00 00 00 00       	mov    $0x0,%edx
801043e0:	b8 00 00 00 00       	mov    $0x0,%eax
801043e5:	e8 0d fc ff ff       	call   80103ff7 <argfd>
801043ea:	85 c0                	test   %eax,%eax
801043ec:	78 2a                	js     80104418 <sys_fstat+0x46>
801043ee:	83 ec 04             	sub    $0x4,%esp
801043f1:	6a 14                	push   $0x14
801043f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801043f6:	50                   	push   %eax
801043f7:	6a 01                	push   $0x1
801043f9:	e8 09 fb ff ff       	call   80103f07 <argptr>
801043fe:	83 c4 10             	add    $0x10,%esp
80104401:	85 c0                	test   %eax,%eax
80104403:	78 1a                	js     8010441f <sys_fstat+0x4d>
  return filestat(f, st);
80104405:	83 ec 08             	sub    $0x8,%esp
80104408:	ff 75 f0             	pushl  -0x10(%ebp)
8010440b:	ff 75 f4             	pushl  -0xc(%ebp)
8010440e:	e8 b0 c9 ff ff       	call   80100dc3 <filestat>
80104413:	83 c4 10             	add    $0x10,%esp
}
80104416:	c9                   	leave  
80104417:	c3                   	ret    
    return -1;
80104418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010441d:	eb f7                	jmp    80104416 <sys_fstat+0x44>
8010441f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104424:	eb f0                	jmp    80104416 <sys_fstat+0x44>

80104426 <sys_link>:
{
80104426:	55                   	push   %ebp
80104427:	89 e5                	mov    %esp,%ebp
80104429:	56                   	push   %esi
8010442a:	53                   	push   %ebx
8010442b:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010442e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104431:	50                   	push   %eax
80104432:	6a 00                	push   $0x0
80104434:	e8 36 fb ff ff       	call   80103f6f <argstr>
80104439:	83 c4 10             	add    $0x10,%esp
8010443c:	85 c0                	test   %eax,%eax
8010443e:	0f 88 32 01 00 00    	js     80104576 <sys_link+0x150>
80104444:	83 ec 08             	sub    $0x8,%esp
80104447:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010444a:	50                   	push   %eax
8010444b:	6a 01                	push   $0x1
8010444d:	e8 1d fb ff ff       	call   80103f6f <argstr>
80104452:	83 c4 10             	add    $0x10,%esp
80104455:	85 c0                	test   %eax,%eax
80104457:	0f 88 20 01 00 00    	js     8010457d <sys_link+0x157>
  begin_op();
8010445d:	e8 7f e3 ff ff       	call   801027e1 <begin_op>
  if((ip = namei(old)) == 0){
80104462:	83 ec 0c             	sub    $0xc,%esp
80104465:	ff 75 e0             	pushl  -0x20(%ebp)
80104468:	e8 a7 d7 ff ff       	call   80101c14 <namei>
8010446d:	89 c3                	mov    %eax,%ebx
8010446f:	83 c4 10             	add    $0x10,%esp
80104472:	85 c0                	test   %eax,%eax
80104474:	0f 84 99 00 00 00    	je     80104513 <sys_link+0xed>
  ilock(ip);
8010447a:	83 ec 0c             	sub    $0xc,%esp
8010447d:	50                   	push   %eax
8010447e:	e8 31 d1 ff ff       	call   801015b4 <ilock>
  if(ip->type == T_DIR){
80104483:	83 c4 10             	add    $0x10,%esp
80104486:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010448b:	0f 84 8e 00 00 00    	je     8010451f <sys_link+0xf9>
  ip->nlink++;
80104491:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104495:	83 c0 01             	add    $0x1,%eax
80104498:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010449c:	83 ec 0c             	sub    $0xc,%esp
8010449f:	53                   	push   %ebx
801044a0:	e8 ae cf ff ff       	call   80101453 <iupdate>
  iunlock(ip);
801044a5:	89 1c 24             	mov    %ebx,(%esp)
801044a8:	e8 c9 d1 ff ff       	call   80101676 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801044ad:	83 c4 08             	add    $0x8,%esp
801044b0:	8d 45 ea             	lea    -0x16(%ebp),%eax
801044b3:	50                   	push   %eax
801044b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801044b7:	e8 70 d7 ff ff       	call   80101c2c <nameiparent>
801044bc:	89 c6                	mov    %eax,%esi
801044be:	83 c4 10             	add    $0x10,%esp
801044c1:	85 c0                	test   %eax,%eax
801044c3:	74 7e                	je     80104543 <sys_link+0x11d>
  ilock(dp);
801044c5:	83 ec 0c             	sub    $0xc,%esp
801044c8:	50                   	push   %eax
801044c9:	e8 e6 d0 ff ff       	call   801015b4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801044ce:	83 c4 10             	add    $0x10,%esp
801044d1:	8b 03                	mov    (%ebx),%eax
801044d3:	39 06                	cmp    %eax,(%esi)
801044d5:	75 60                	jne    80104537 <sys_link+0x111>
801044d7:	83 ec 04             	sub    $0x4,%esp
801044da:	ff 73 04             	pushl  0x4(%ebx)
801044dd:	8d 45 ea             	lea    -0x16(%ebp),%eax
801044e0:	50                   	push   %eax
801044e1:	56                   	push   %esi
801044e2:	e8 7c d6 ff ff       	call   80101b63 <dirlink>
801044e7:	83 c4 10             	add    $0x10,%esp
801044ea:	85 c0                	test   %eax,%eax
801044ec:	78 49                	js     80104537 <sys_link+0x111>
  iunlockput(dp);
801044ee:	83 ec 0c             	sub    $0xc,%esp
801044f1:	56                   	push   %esi
801044f2:	e8 64 d2 ff ff       	call   8010175b <iunlockput>
  iput(ip);
801044f7:	89 1c 24             	mov    %ebx,(%esp)
801044fa:	e8 bc d1 ff ff       	call   801016bb <iput>
  end_op();
801044ff:	e8 57 e3 ff ff       	call   8010285b <end_op>
  return 0;
80104504:	83 c4 10             	add    $0x10,%esp
80104507:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010450c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010450f:	5b                   	pop    %ebx
80104510:	5e                   	pop    %esi
80104511:	5d                   	pop    %ebp
80104512:	c3                   	ret    
    end_op();
80104513:	e8 43 e3 ff ff       	call   8010285b <end_op>
    return -1;
80104518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010451d:	eb ed                	jmp    8010450c <sys_link+0xe6>
    iunlockput(ip);
8010451f:	83 ec 0c             	sub    $0xc,%esp
80104522:	53                   	push   %ebx
80104523:	e8 33 d2 ff ff       	call   8010175b <iunlockput>
    end_op();
80104528:	e8 2e e3 ff ff       	call   8010285b <end_op>
    return -1;
8010452d:	83 c4 10             	add    $0x10,%esp
80104530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104535:	eb d5                	jmp    8010450c <sys_link+0xe6>
    iunlockput(dp);
80104537:	83 ec 0c             	sub    $0xc,%esp
8010453a:	56                   	push   %esi
8010453b:	e8 1b d2 ff ff       	call   8010175b <iunlockput>
    goto bad;
80104540:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104543:	83 ec 0c             	sub    $0xc,%esp
80104546:	53                   	push   %ebx
80104547:	e8 68 d0 ff ff       	call   801015b4 <ilock>
  ip->nlink--;
8010454c:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104550:	83 e8 01             	sub    $0x1,%eax
80104553:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104557:	89 1c 24             	mov    %ebx,(%esp)
8010455a:	e8 f4 ce ff ff       	call   80101453 <iupdate>
  iunlockput(ip);
8010455f:	89 1c 24             	mov    %ebx,(%esp)
80104562:	e8 f4 d1 ff ff       	call   8010175b <iunlockput>
  end_op();
80104567:	e8 ef e2 ff ff       	call   8010285b <end_op>
  return -1;
8010456c:	83 c4 10             	add    $0x10,%esp
8010456f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104574:	eb 96                	jmp    8010450c <sys_link+0xe6>
    return -1;
80104576:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010457b:	eb 8f                	jmp    8010450c <sys_link+0xe6>
8010457d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104582:	eb 88                	jmp    8010450c <sys_link+0xe6>

80104584 <sys_unlink>:
{
80104584:	55                   	push   %ebp
80104585:	89 e5                	mov    %esp,%ebp
80104587:	57                   	push   %edi
80104588:	56                   	push   %esi
80104589:	53                   	push   %ebx
8010458a:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010458d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104590:	50                   	push   %eax
80104591:	6a 00                	push   $0x0
80104593:	e8 d7 f9 ff ff       	call   80103f6f <argstr>
80104598:	83 c4 10             	add    $0x10,%esp
8010459b:	85 c0                	test   %eax,%eax
8010459d:	0f 88 83 01 00 00    	js     80104726 <sys_unlink+0x1a2>
  begin_op();
801045a3:	e8 39 e2 ff ff       	call   801027e1 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801045a8:	83 ec 08             	sub    $0x8,%esp
801045ab:	8d 45 ca             	lea    -0x36(%ebp),%eax
801045ae:	50                   	push   %eax
801045af:	ff 75 c4             	pushl  -0x3c(%ebp)
801045b2:	e8 75 d6 ff ff       	call   80101c2c <nameiparent>
801045b7:	89 c6                	mov    %eax,%esi
801045b9:	83 c4 10             	add    $0x10,%esp
801045bc:	85 c0                	test   %eax,%eax
801045be:	0f 84 ed 00 00 00    	je     801046b1 <sys_unlink+0x12d>
  ilock(dp);
801045c4:	83 ec 0c             	sub    $0xc,%esp
801045c7:	50                   	push   %eax
801045c8:	e8 e7 cf ff ff       	call   801015b4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801045cd:	83 c4 08             	add    $0x8,%esp
801045d0:	68 9e 6b 10 80       	push   $0x80106b9e
801045d5:	8d 45 ca             	lea    -0x36(%ebp),%eax
801045d8:	50                   	push   %eax
801045d9:	e8 f0 d3 ff ff       	call   801019ce <namecmp>
801045de:	83 c4 10             	add    $0x10,%esp
801045e1:	85 c0                	test   %eax,%eax
801045e3:	0f 84 fc 00 00 00    	je     801046e5 <sys_unlink+0x161>
801045e9:	83 ec 08             	sub    $0x8,%esp
801045ec:	68 9d 6b 10 80       	push   $0x80106b9d
801045f1:	8d 45 ca             	lea    -0x36(%ebp),%eax
801045f4:	50                   	push   %eax
801045f5:	e8 d4 d3 ff ff       	call   801019ce <namecmp>
801045fa:	83 c4 10             	add    $0x10,%esp
801045fd:	85 c0                	test   %eax,%eax
801045ff:	0f 84 e0 00 00 00    	je     801046e5 <sys_unlink+0x161>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104605:	83 ec 04             	sub    $0x4,%esp
80104608:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010460b:	50                   	push   %eax
8010460c:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010460f:	50                   	push   %eax
80104610:	56                   	push   %esi
80104611:	e8 cd d3 ff ff       	call   801019e3 <dirlookup>
80104616:	89 c3                	mov    %eax,%ebx
80104618:	83 c4 10             	add    $0x10,%esp
8010461b:	85 c0                	test   %eax,%eax
8010461d:	0f 84 c2 00 00 00    	je     801046e5 <sys_unlink+0x161>
  ilock(ip);
80104623:	83 ec 0c             	sub    $0xc,%esp
80104626:	50                   	push   %eax
80104627:	e8 88 cf ff ff       	call   801015b4 <ilock>
  if(ip->nlink < 1)
8010462c:	83 c4 10             	add    $0x10,%esp
8010462f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104634:	0f 8e 83 00 00 00    	jle    801046bd <sys_unlink+0x139>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010463a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010463f:	0f 84 85 00 00 00    	je     801046ca <sys_unlink+0x146>
  memset(&de, 0, sizeof(de));
80104645:	83 ec 04             	sub    $0x4,%esp
80104648:	6a 10                	push   $0x10
8010464a:	6a 00                	push   $0x0
8010464c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010464f:	57                   	push   %edi
80104650:	e8 3f f6 ff ff       	call   80103c94 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104655:	6a 10                	push   $0x10
80104657:	ff 75 c0             	pushl  -0x40(%ebp)
8010465a:	57                   	push   %edi
8010465b:	56                   	push   %esi
8010465c:	e8 42 d2 ff ff       	call   801018a3 <writei>
80104661:	83 c4 20             	add    $0x20,%esp
80104664:	83 f8 10             	cmp    $0x10,%eax
80104667:	0f 85 90 00 00 00    	jne    801046fd <sys_unlink+0x179>
  if(ip->type == T_DIR){
8010466d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104672:	0f 84 92 00 00 00    	je     8010470a <sys_unlink+0x186>
  iunlockput(dp);
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	56                   	push   %esi
8010467c:	e8 da d0 ff ff       	call   8010175b <iunlockput>
  ip->nlink--;
80104681:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104685:	83 e8 01             	sub    $0x1,%eax
80104688:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010468c:	89 1c 24             	mov    %ebx,(%esp)
8010468f:	e8 bf cd ff ff       	call   80101453 <iupdate>
  iunlockput(ip);
80104694:	89 1c 24             	mov    %ebx,(%esp)
80104697:	e8 bf d0 ff ff       	call   8010175b <iunlockput>
  end_op();
8010469c:	e8 ba e1 ff ff       	call   8010285b <end_op>
  return 0;
801046a1:	83 c4 10             	add    $0x10,%esp
801046a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046ac:	5b                   	pop    %ebx
801046ad:	5e                   	pop    %esi
801046ae:	5f                   	pop    %edi
801046af:	5d                   	pop    %ebp
801046b0:	c3                   	ret    
    end_op();
801046b1:	e8 a5 e1 ff ff       	call   8010285b <end_op>
    return -1;
801046b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046bb:	eb ec                	jmp    801046a9 <sys_unlink+0x125>
    panic("unlink: nlink < 1");
801046bd:	83 ec 0c             	sub    $0xc,%esp
801046c0:	68 bc 6b 10 80       	push   $0x80106bbc
801046c5:	e8 7e bc ff ff       	call   80100348 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801046ca:	89 d8                	mov    %ebx,%eax
801046cc:	e8 c4 f9 ff ff       	call   80104095 <isdirempty>
801046d1:	85 c0                	test   %eax,%eax
801046d3:	0f 85 6c ff ff ff    	jne    80104645 <sys_unlink+0xc1>
    iunlockput(ip);
801046d9:	83 ec 0c             	sub    $0xc,%esp
801046dc:	53                   	push   %ebx
801046dd:	e8 79 d0 ff ff       	call   8010175b <iunlockput>
    goto bad;
801046e2:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801046e5:	83 ec 0c             	sub    $0xc,%esp
801046e8:	56                   	push   %esi
801046e9:	e8 6d d0 ff ff       	call   8010175b <iunlockput>
  end_op();
801046ee:	e8 68 e1 ff ff       	call   8010285b <end_op>
  return -1;
801046f3:	83 c4 10             	add    $0x10,%esp
801046f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046fb:	eb ac                	jmp    801046a9 <sys_unlink+0x125>
    panic("unlink: writei");
801046fd:	83 ec 0c             	sub    $0xc,%esp
80104700:	68 ce 6b 10 80       	push   $0x80106bce
80104705:	e8 3e bc ff ff       	call   80100348 <panic>
    dp->nlink--;
8010470a:	0f b7 46 56          	movzwl 0x56(%esi),%eax
8010470e:	83 e8 01             	sub    $0x1,%eax
80104711:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104715:	83 ec 0c             	sub    $0xc,%esp
80104718:	56                   	push   %esi
80104719:	e8 35 cd ff ff       	call   80101453 <iupdate>
8010471e:	83 c4 10             	add    $0x10,%esp
80104721:	e9 52 ff ff ff       	jmp    80104678 <sys_unlink+0xf4>
    return -1;
80104726:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010472b:	e9 79 ff ff ff       	jmp    801046a9 <sys_unlink+0x125>

80104730 <sys_open>:

int
sys_open(void)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	56                   	push   %esi
80104735:	53                   	push   %ebx
80104736:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104739:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010473c:	50                   	push   %eax
8010473d:	6a 00                	push   $0x0
8010473f:	e8 2b f8 ff ff       	call   80103f6f <argstr>
80104744:	83 c4 10             	add    $0x10,%esp
80104747:	85 c0                	test   %eax,%eax
80104749:	0f 88 30 01 00 00    	js     8010487f <sys_open+0x14f>
8010474f:	83 ec 08             	sub    $0x8,%esp
80104752:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104755:	50                   	push   %eax
80104756:	6a 01                	push   $0x1
80104758:	e8 82 f7 ff ff       	call   80103edf <argint>
8010475d:	83 c4 10             	add    $0x10,%esp
80104760:	85 c0                	test   %eax,%eax
80104762:	0f 88 21 01 00 00    	js     80104889 <sys_open+0x159>
    return -1;

  begin_op();
80104768:	e8 74 e0 ff ff       	call   801027e1 <begin_op>

  if(omode & O_CREATE){
8010476d:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104771:	0f 84 84 00 00 00    	je     801047fb <sys_open+0xcb>
    ip = create(path, T_FILE, 0, 0);
80104777:	83 ec 0c             	sub    $0xc,%esp
8010477a:	6a 00                	push   $0x0
8010477c:	b9 00 00 00 00       	mov    $0x0,%ecx
80104781:	ba 02 00 00 00       	mov    $0x2,%edx
80104786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104789:	e8 5e f9 ff ff       	call   801040ec <create>
8010478e:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104790:	83 c4 10             	add    $0x10,%esp
80104793:	85 c0                	test   %eax,%eax
80104795:	74 58                	je     801047ef <sys_open+0xbf>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104797:	e8 c4 c4 ff ff       	call   80100c60 <filealloc>
8010479c:	89 c3                	mov    %eax,%ebx
8010479e:	85 c0                	test   %eax,%eax
801047a0:	0f 84 ae 00 00 00    	je     80104854 <sys_open+0x124>
801047a6:	e8 b3 f8 ff ff       	call   8010405e <fdalloc>
801047ab:	89 c7                	mov    %eax,%edi
801047ad:	85 c0                	test   %eax,%eax
801047af:	0f 88 9f 00 00 00    	js     80104854 <sys_open+0x124>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801047b5:	83 ec 0c             	sub    $0xc,%esp
801047b8:	56                   	push   %esi
801047b9:	e8 b8 ce ff ff       	call   80101676 <iunlock>
  end_op();
801047be:	e8 98 e0 ff ff       	call   8010285b <end_op>

  f->type = FD_INODE;
801047c3:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
801047c9:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
801047cc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
801047d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047d6:	83 c4 10             	add    $0x10,%esp
801047d9:	a8 01                	test   $0x1,%al
801047db:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801047df:	a8 03                	test   $0x3,%al
801047e1:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
801047e5:	89 f8                	mov    %edi,%eax
801047e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047ea:	5b                   	pop    %ebx
801047eb:	5e                   	pop    %esi
801047ec:	5f                   	pop    %edi
801047ed:	5d                   	pop    %ebp
801047ee:	c3                   	ret    
      end_op();
801047ef:	e8 67 e0 ff ff       	call   8010285b <end_op>
      return -1;
801047f4:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801047f9:	eb ea                	jmp    801047e5 <sys_open+0xb5>
    if((ip = namei(path)) == 0){
801047fb:	83 ec 0c             	sub    $0xc,%esp
801047fe:	ff 75 e4             	pushl  -0x1c(%ebp)
80104801:	e8 0e d4 ff ff       	call   80101c14 <namei>
80104806:	89 c6                	mov    %eax,%esi
80104808:	83 c4 10             	add    $0x10,%esp
8010480b:	85 c0                	test   %eax,%eax
8010480d:	74 39                	je     80104848 <sys_open+0x118>
    ilock(ip);
8010480f:	83 ec 0c             	sub    $0xc,%esp
80104812:	50                   	push   %eax
80104813:	e8 9c cd ff ff       	call   801015b4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104818:	83 c4 10             	add    $0x10,%esp
8010481b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104820:	0f 85 71 ff ff ff    	jne    80104797 <sys_open+0x67>
80104826:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010482a:	0f 84 67 ff ff ff    	je     80104797 <sys_open+0x67>
      iunlockput(ip);
80104830:	83 ec 0c             	sub    $0xc,%esp
80104833:	56                   	push   %esi
80104834:	e8 22 cf ff ff       	call   8010175b <iunlockput>
      end_op();
80104839:	e8 1d e0 ff ff       	call   8010285b <end_op>
      return -1;
8010483e:	83 c4 10             	add    $0x10,%esp
80104841:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104846:	eb 9d                	jmp    801047e5 <sys_open+0xb5>
      end_op();
80104848:	e8 0e e0 ff ff       	call   8010285b <end_op>
      return -1;
8010484d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104852:	eb 91                	jmp    801047e5 <sys_open+0xb5>
    if(f)
80104854:	85 db                	test   %ebx,%ebx
80104856:	74 0c                	je     80104864 <sys_open+0x134>
      fileclose(f);
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	53                   	push   %ebx
8010485c:	e8 a5 c4 ff ff       	call   80100d06 <fileclose>
80104861:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104864:	83 ec 0c             	sub    $0xc,%esp
80104867:	56                   	push   %esi
80104868:	e8 ee ce ff ff       	call   8010175b <iunlockput>
    end_op();
8010486d:	e8 e9 df ff ff       	call   8010285b <end_op>
    return -1;
80104872:	83 c4 10             	add    $0x10,%esp
80104875:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010487a:	e9 66 ff ff ff       	jmp    801047e5 <sys_open+0xb5>
    return -1;
8010487f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104884:	e9 5c ff ff ff       	jmp    801047e5 <sys_open+0xb5>
80104889:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010488e:	e9 52 ff ff ff       	jmp    801047e5 <sys_open+0xb5>

80104893 <sys_mkdir>:

int
sys_mkdir(void)
{
80104893:	55                   	push   %ebp
80104894:	89 e5                	mov    %esp,%ebp
80104896:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104899:	e8 43 df ff ff       	call   801027e1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010489e:	83 ec 08             	sub    $0x8,%esp
801048a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048a4:	50                   	push   %eax
801048a5:	6a 00                	push   $0x0
801048a7:	e8 c3 f6 ff ff       	call   80103f6f <argstr>
801048ac:	83 c4 10             	add    $0x10,%esp
801048af:	85 c0                	test   %eax,%eax
801048b1:	78 36                	js     801048e9 <sys_mkdir+0x56>
801048b3:	83 ec 0c             	sub    $0xc,%esp
801048b6:	6a 00                	push   $0x0
801048b8:	b9 00 00 00 00       	mov    $0x0,%ecx
801048bd:	ba 01 00 00 00       	mov    $0x1,%edx
801048c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c5:	e8 22 f8 ff ff       	call   801040ec <create>
801048ca:	83 c4 10             	add    $0x10,%esp
801048cd:	85 c0                	test   %eax,%eax
801048cf:	74 18                	je     801048e9 <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
801048d1:	83 ec 0c             	sub    $0xc,%esp
801048d4:	50                   	push   %eax
801048d5:	e8 81 ce ff ff       	call   8010175b <iunlockput>
  end_op();
801048da:	e8 7c df ff ff       	call   8010285b <end_op>
  return 0;
801048df:	83 c4 10             	add    $0x10,%esp
801048e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801048e7:	c9                   	leave  
801048e8:	c3                   	ret    
    end_op();
801048e9:	e8 6d df ff ff       	call   8010285b <end_op>
    return -1;
801048ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048f3:	eb f2                	jmp    801048e7 <sys_mkdir+0x54>

801048f5 <sys_mknod>:

int
sys_mknod(void)
{
801048f5:	55                   	push   %ebp
801048f6:	89 e5                	mov    %esp,%ebp
801048f8:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801048fb:	e8 e1 de ff ff       	call   801027e1 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104900:	83 ec 08             	sub    $0x8,%esp
80104903:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104906:	50                   	push   %eax
80104907:	6a 00                	push   $0x0
80104909:	e8 61 f6 ff ff       	call   80103f6f <argstr>
8010490e:	83 c4 10             	add    $0x10,%esp
80104911:	85 c0                	test   %eax,%eax
80104913:	78 62                	js     80104977 <sys_mknod+0x82>
     argint(1, &major) < 0 ||
80104915:	83 ec 08             	sub    $0x8,%esp
80104918:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010491b:	50                   	push   %eax
8010491c:	6a 01                	push   $0x1
8010491e:	e8 bc f5 ff ff       	call   80103edf <argint>
  if((argstr(0, &path)) < 0 ||
80104923:	83 c4 10             	add    $0x10,%esp
80104926:	85 c0                	test   %eax,%eax
80104928:	78 4d                	js     80104977 <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
8010492a:	83 ec 08             	sub    $0x8,%esp
8010492d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104930:	50                   	push   %eax
80104931:	6a 02                	push   $0x2
80104933:	e8 a7 f5 ff ff       	call   80103edf <argint>
     argint(1, &major) < 0 ||
80104938:	83 c4 10             	add    $0x10,%esp
8010493b:	85 c0                	test   %eax,%eax
8010493d:	78 38                	js     80104977 <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010493f:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104943:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80104947:	83 ec 0c             	sub    $0xc,%esp
8010494a:	50                   	push   %eax
8010494b:	ba 03 00 00 00       	mov    $0x3,%edx
80104950:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104953:	e8 94 f7 ff ff       	call   801040ec <create>
80104958:	83 c4 10             	add    $0x10,%esp
8010495b:	85 c0                	test   %eax,%eax
8010495d:	74 18                	je     80104977 <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010495f:	83 ec 0c             	sub    $0xc,%esp
80104962:	50                   	push   %eax
80104963:	e8 f3 cd ff ff       	call   8010175b <iunlockput>
  end_op();
80104968:	e8 ee de ff ff       	call   8010285b <end_op>
  return 0;
8010496d:	83 c4 10             	add    $0x10,%esp
80104970:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104975:	c9                   	leave  
80104976:	c3                   	ret    
    end_op();
80104977:	e8 df de ff ff       	call   8010285b <end_op>
    return -1;
8010497c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104981:	eb f2                	jmp    80104975 <sys_mknod+0x80>

80104983 <sys_chdir>:

int
sys_chdir(void)
{
80104983:	55                   	push   %ebp
80104984:	89 e5                	mov    %esp,%ebp
80104986:	56                   	push   %esi
80104987:	53                   	push   %ebx
80104988:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010498b:	e8 b1 e8 ff ff       	call   80103241 <myproc>
80104990:	89 c6                	mov    %eax,%esi

  begin_op();
80104992:	e8 4a de ff ff       	call   801027e1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104997:	83 ec 08             	sub    $0x8,%esp
8010499a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010499d:	50                   	push   %eax
8010499e:	6a 00                	push   $0x0
801049a0:	e8 ca f5 ff ff       	call   80103f6f <argstr>
801049a5:	83 c4 10             	add    $0x10,%esp
801049a8:	85 c0                	test   %eax,%eax
801049aa:	78 52                	js     801049fe <sys_chdir+0x7b>
801049ac:	83 ec 0c             	sub    $0xc,%esp
801049af:	ff 75 f4             	pushl  -0xc(%ebp)
801049b2:	e8 5d d2 ff ff       	call   80101c14 <namei>
801049b7:	89 c3                	mov    %eax,%ebx
801049b9:	83 c4 10             	add    $0x10,%esp
801049bc:	85 c0                	test   %eax,%eax
801049be:	74 3e                	je     801049fe <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
801049c0:	83 ec 0c             	sub    $0xc,%esp
801049c3:	50                   	push   %eax
801049c4:	e8 eb cb ff ff       	call   801015b4 <ilock>
  if(ip->type != T_DIR){
801049c9:	83 c4 10             	add    $0x10,%esp
801049cc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801049d1:	75 37                	jne    80104a0a <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801049d3:	83 ec 0c             	sub    $0xc,%esp
801049d6:	53                   	push   %ebx
801049d7:	e8 9a cc ff ff       	call   80101676 <iunlock>
  iput(curproc->cwd);
801049dc:	83 c4 04             	add    $0x4,%esp
801049df:	ff 76 68             	pushl  0x68(%esi)
801049e2:	e8 d4 cc ff ff       	call   801016bb <iput>
  end_op();
801049e7:	e8 6f de ff ff       	call   8010285b <end_op>
  curproc->cwd = ip;
801049ec:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801049ef:	83 c4 10             	add    $0x10,%esp
801049f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049fa:	5b                   	pop    %ebx
801049fb:	5e                   	pop    %esi
801049fc:	5d                   	pop    %ebp
801049fd:	c3                   	ret    
    end_op();
801049fe:	e8 58 de ff ff       	call   8010285b <end_op>
    return -1;
80104a03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a08:	eb ed                	jmp    801049f7 <sys_chdir+0x74>
    iunlockput(ip);
80104a0a:	83 ec 0c             	sub    $0xc,%esp
80104a0d:	53                   	push   %ebx
80104a0e:	e8 48 cd ff ff       	call   8010175b <iunlockput>
    end_op();
80104a13:	e8 43 de ff ff       	call   8010285b <end_op>
    return -1;
80104a18:	83 c4 10             	add    $0x10,%esp
80104a1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a20:	eb d5                	jmp    801049f7 <sys_chdir+0x74>

80104a22 <sys_exec>:

int
sys_exec(void)
{
80104a22:	55                   	push   %ebp
80104a23:	89 e5                	mov    %esp,%ebp
80104a25:	53                   	push   %ebx
80104a26:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104a2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a2f:	50                   	push   %eax
80104a30:	6a 00                	push   $0x0
80104a32:	e8 38 f5 ff ff       	call   80103f6f <argstr>
80104a37:	83 c4 10             	add    $0x10,%esp
80104a3a:	85 c0                	test   %eax,%eax
80104a3c:	0f 88 a8 00 00 00    	js     80104aea <sys_exec+0xc8>
80104a42:	83 ec 08             	sub    $0x8,%esp
80104a45:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104a4b:	50                   	push   %eax
80104a4c:	6a 01                	push   $0x1
80104a4e:	e8 8c f4 ff ff       	call   80103edf <argint>
80104a53:	83 c4 10             	add    $0x10,%esp
80104a56:	85 c0                	test   %eax,%eax
80104a58:	0f 88 93 00 00 00    	js     80104af1 <sys_exec+0xcf>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104a5e:	83 ec 04             	sub    $0x4,%esp
80104a61:	68 80 00 00 00       	push   $0x80
80104a66:	6a 00                	push   $0x0
80104a68:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104a6e:	50                   	push   %eax
80104a6f:	e8 20 f2 ff ff       	call   80103c94 <memset>
80104a74:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104a77:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(i >= NELEM(argv))
80104a7c:	83 fb 1f             	cmp    $0x1f,%ebx
80104a7f:	77 77                	ja     80104af8 <sys_exec+0xd6>
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104a81:	83 ec 08             	sub    $0x8,%esp
80104a84:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104a8a:	50                   	push   %eax
80104a8b:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104a91:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104a94:	50                   	push   %eax
80104a95:	e8 c9 f3 ff ff       	call   80103e63 <fetchint>
80104a9a:	83 c4 10             	add    $0x10,%esp
80104a9d:	85 c0                	test   %eax,%eax
80104a9f:	78 5e                	js     80104aff <sys_exec+0xdd>
      return -1;
    if(uarg == 0){
80104aa1:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104aa7:	85 c0                	test   %eax,%eax
80104aa9:	74 1d                	je     80104ac8 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104aab:	83 ec 08             	sub    $0x8,%esp
80104aae:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104ab5:	52                   	push   %edx
80104ab6:	50                   	push   %eax
80104ab7:	e8 e3 f3 ff ff       	call   80103e9f <fetchstr>
80104abc:	83 c4 10             	add    $0x10,%esp
80104abf:	85 c0                	test   %eax,%eax
80104ac1:	78 46                	js     80104b09 <sys_exec+0xe7>
  for(i=0;; i++){
80104ac3:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80104ac6:	eb b4                	jmp    80104a7c <sys_exec+0x5a>
      argv[i] = 0;
80104ac8:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104acf:	00 00 00 00 
      return -1;
  }
  return exec(path, argv);
80104ad3:	83 ec 08             	sub    $0x8,%esp
80104ad6:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104adc:	50                   	push   %eax
80104add:	ff 75 f4             	pushl  -0xc(%ebp)
80104ae0:	e8 30 be ff ff       	call   80100915 <exec>
80104ae5:	83 c4 10             	add    $0x10,%esp
80104ae8:	eb 1a                	jmp    80104b04 <sys_exec+0xe2>
    return -1;
80104aea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aef:	eb 13                	jmp    80104b04 <sys_exec+0xe2>
80104af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104af6:	eb 0c                	jmp    80104b04 <sys_exec+0xe2>
      return -1;
80104af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104afd:	eb 05                	jmp    80104b04 <sys_exec+0xe2>
      return -1;
80104aff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b07:	c9                   	leave  
80104b08:	c3                   	ret    
      return -1;
80104b09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b0e:	eb f4                	jmp    80104b04 <sys_exec+0xe2>

80104b10 <sys_pipe>:

int
sys_pipe(void)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104b17:	6a 08                	push   $0x8
80104b19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b1c:	50                   	push   %eax
80104b1d:	6a 00                	push   $0x0
80104b1f:	e8 e3 f3 ff ff       	call   80103f07 <argptr>
80104b24:	83 c4 10             	add    $0x10,%esp
80104b27:	85 c0                	test   %eax,%eax
80104b29:	78 77                	js     80104ba2 <sys_pipe+0x92>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104b2b:	83 ec 08             	sub    $0x8,%esp
80104b2e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104b31:	50                   	push   %eax
80104b32:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b35:	50                   	push   %eax
80104b36:	e8 2d e2 ff ff       	call   80102d68 <pipealloc>
80104b3b:	83 c4 10             	add    $0x10,%esp
80104b3e:	85 c0                	test   %eax,%eax
80104b40:	78 67                	js     80104ba9 <sys_pipe+0x99>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b45:	e8 14 f5 ff ff       	call   8010405e <fdalloc>
80104b4a:	89 c3                	mov    %eax,%ebx
80104b4c:	85 c0                	test   %eax,%eax
80104b4e:	78 21                	js     80104b71 <sys_pipe+0x61>
80104b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b53:	e8 06 f5 ff ff       	call   8010405e <fdalloc>
80104b58:	85 c0                	test   %eax,%eax
80104b5a:	78 15                	js     80104b71 <sys_pipe+0x61>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104b5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b5f:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104b61:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b64:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b6f:	c9                   	leave  
80104b70:	c3                   	ret    
    if(fd0 >= 0)
80104b71:	85 db                	test   %ebx,%ebx
80104b73:	78 0d                	js     80104b82 <sys_pipe+0x72>
      myproc()->ofile[fd0] = 0;
80104b75:	e8 c7 e6 ff ff       	call   80103241 <myproc>
80104b7a:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104b81:	00 
    fileclose(rf);
80104b82:	83 ec 0c             	sub    $0xc,%esp
80104b85:	ff 75 f0             	pushl  -0x10(%ebp)
80104b88:	e8 79 c1 ff ff       	call   80100d06 <fileclose>
    fileclose(wf);
80104b8d:	83 c4 04             	add    $0x4,%esp
80104b90:	ff 75 ec             	pushl  -0x14(%ebp)
80104b93:	e8 6e c1 ff ff       	call   80100d06 <fileclose>
    return -1;
80104b98:	83 c4 10             	add    $0x10,%esp
80104b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba0:	eb ca                	jmp    80104b6c <sys_pipe+0x5c>
    return -1;
80104ba2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba7:	eb c3                	jmp    80104b6c <sys_pipe+0x5c>
    return -1;
80104ba9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bae:	eb bc                	jmp    80104b6c <sys_pipe+0x5c>

80104bb0 <sys_fork>:
#include "pdx-kernel.h"
#endif // PDX_XV6

int
sys_fork(void)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104bb6:	e8 fe e7 ff ff       	call   801033b9 <fork>
}
80104bbb:	c9                   	leave  
80104bbc:	c3                   	ret    

80104bbd <sys_exit>:

int
sys_exit(void)
{
80104bbd:	55                   	push   %ebp
80104bbe:	89 e5                	mov    %esp,%ebp
80104bc0:	83 ec 08             	sub    $0x8,%esp
  exit();
80104bc3:	e8 39 ea ff ff       	call   80103601 <exit>
  return 0;  // not reached
}
80104bc8:	b8 00 00 00 00       	mov    $0x0,%eax
80104bcd:	c9                   	leave  
80104bce:	c3                   	ret    

80104bcf <sys_wait>:

int
sys_wait(void)
{
80104bcf:	55                   	push   %ebp
80104bd0:	89 e5                	mov    %esp,%ebp
80104bd2:	83 ec 08             	sub    $0x8,%esp
  return wait();
80104bd5:	e8 be eb ff ff       	call   80103798 <wait>
}
80104bda:	c9                   	leave  
80104bdb:	c3                   	ret    

80104bdc <sys_kill>:

int
sys_kill(void)
{
80104bdc:	55                   	push   %ebp
80104bdd:	89 e5                	mov    %esp,%ebp
80104bdf:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104be2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104be5:	50                   	push   %eax
80104be6:	6a 00                	push   $0x0
80104be8:	e8 f2 f2 ff ff       	call   80103edf <argint>
80104bed:	83 c4 10             	add    $0x10,%esp
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	78 10                	js     80104c04 <sys_kill+0x28>
    return -1;
  return kill(pid);
80104bf4:	83 ec 0c             	sub    $0xc,%esp
80104bf7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bfa:	e8 96 ec ff ff       	call   80103895 <kill>
80104bff:	83 c4 10             	add    $0x10,%esp
}
80104c02:	c9                   	leave  
80104c03:	c3                   	ret    
    return -1;
80104c04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c09:	eb f7                	jmp    80104c02 <sys_kill+0x26>

80104c0b <sys_getpid>:

int
sys_getpid(void)
{
80104c0b:	55                   	push   %ebp
80104c0c:	89 e5                	mov    %esp,%ebp
80104c0e:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104c11:	e8 2b e6 ff ff       	call   80103241 <myproc>
80104c16:	8b 40 10             	mov    0x10(%eax),%eax
}
80104c19:	c9                   	leave  
80104c1a:	c3                   	ret    

80104c1b <sys_sbrk>:

int
sys_sbrk(void)
{
80104c1b:	55                   	push   %ebp
80104c1c:	89 e5                	mov    %esp,%ebp
80104c1e:	53                   	push   %ebx
80104c1f:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104c22:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c25:	50                   	push   %eax
80104c26:	6a 00                	push   $0x0
80104c28:	e8 b2 f2 ff ff       	call   80103edf <argint>
80104c2d:	83 c4 10             	add    $0x10,%esp
80104c30:	85 c0                	test   %eax,%eax
80104c32:	78 27                	js     80104c5b <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80104c34:	e8 08 e6 ff ff       	call   80103241 <myproc>
80104c39:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104c3b:	83 ec 0c             	sub    $0xc,%esp
80104c3e:	ff 75 f4             	pushl  -0xc(%ebp)
80104c41:	e8 06 e7 ff ff       	call   8010334c <growproc>
80104c46:	83 c4 10             	add    $0x10,%esp
80104c49:	85 c0                	test   %eax,%eax
80104c4b:	78 07                	js     80104c54 <sys_sbrk+0x39>
    return -1;
  return addr;
}
80104c4d:	89 d8                	mov    %ebx,%eax
80104c4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c52:	c9                   	leave  
80104c53:	c3                   	ret    
    return -1;
80104c54:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104c59:	eb f2                	jmp    80104c4d <sys_sbrk+0x32>
    return -1;
80104c5b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104c60:	eb eb                	jmp    80104c4d <sys_sbrk+0x32>

80104c62 <sys_sleep>:

int
sys_sleep(void)
{
80104c62:	55                   	push   %ebp
80104c63:	89 e5                	mov    %esp,%ebp
80104c65:	53                   	push   %ebx
80104c66:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104c69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c6c:	50                   	push   %eax
80104c6d:	6a 00                	push   $0x0
80104c6f:	e8 6b f2 ff ff       	call   80103edf <argint>
80104c74:	83 c4 10             	add    $0x10,%esp
80104c77:	85 c0                	test   %eax,%eax
80104c79:	78 3b                	js     80104cb6 <sys_sleep+0x54>
    return -1;
  ticks0 = ticks;
80104c7b:	8b 1d 80 45 11 80    	mov    0x80114580,%ebx
  while(ticks - ticks0 < n){
80104c81:	a1 80 45 11 80       	mov    0x80114580,%eax
80104c86:	29 d8                	sub    %ebx,%eax
80104c88:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104c8b:	73 1f                	jae    80104cac <sys_sleep+0x4a>
    if(myproc()->killed){
80104c8d:	e8 af e5 ff ff       	call   80103241 <myproc>
80104c92:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104c96:	75 25                	jne    80104cbd <sys_sleep+0x5b>
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
80104c98:	83 ec 08             	sub    $0x8,%esp
80104c9b:	6a 00                	push   $0x0
80104c9d:	68 80 45 11 80       	push   $0x80114580
80104ca2:	e8 61 ea ff ff       	call   80103708 <sleep>
80104ca7:	83 c4 10             	add    $0x10,%esp
80104caa:	eb d5                	jmp    80104c81 <sys_sleep+0x1f>
  }
  return 0;
80104cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb4:	c9                   	leave  
80104cb5:	c3                   	ret    
    return -1;
80104cb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cbb:	eb f4                	jmp    80104cb1 <sys_sleep+0x4f>
      return -1;
80104cbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cc2:	eb ed                	jmp    80104cb1 <sys_sleep+0x4f>

80104cc4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104cc4:	55                   	push   %ebp
80104cc5:	89 e5                	mov    %esp,%ebp
  uint xticks;

  xticks = ticks;
  return xticks;
}
80104cc7:	a1 80 45 11 80       	mov    0x80114580,%eax
80104ccc:	5d                   	pop    %ebp
80104ccd:	c3                   	ret    

80104cce <sys_halt>:

#ifdef PDX_XV6
// shutdown QEMU
int
sys_halt(void)
{
80104cce:	55                   	push   %ebp
80104ccf:	89 e5                	mov    %esp,%ebp
80104cd1:	83 ec 08             	sub    $0x8,%esp
  do_shutdown();  // never returns
80104cd4:	e8 65 ba ff ff       	call   8010073e <do_shutdown>
  return 0;
}
80104cd9:	b8 00 00 00 00       	mov    $0x0,%eax
80104cde:	c9                   	leave  
80104cdf:	c3                   	ret    

80104ce0 <sys_date>:
#endif // PDX_XV6

int
sys_date(void)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	83 ec 1c             	sub    $0x1c,%esp
struct rtcdate *d;
	if(argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0)
80104ce6:	6a 18                	push   $0x18
80104ce8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ceb:	50                   	push   %eax
80104cec:	6a 00                	push   $0x0
80104cee:	e8 14 f2 ff ff       	call   80103f07 <argptr>
80104cf3:	83 c4 10             	add    $0x10,%esp
80104cf6:	85 c0                	test   %eax,%eax
80104cf8:	78 15                	js     80104d0f <sys_date+0x2f>
	return -1;
else {
	cmostime(d);
80104cfa:	83 ec 0c             	sub    $0xc,%esp
80104cfd:	ff 75 f4             	pushl  -0xc(%ebp)
80104d00:	e8 80 d7 ff ff       	call   80102485 <cmostime>
	return 0;
80104d05:	83 c4 10             	add    $0x10,%esp
80104d08:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
80104d0d:	c9                   	leave  
80104d0e:	c3                   	ret    
	return -1;
80104d0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d14:	eb f7                	jmp    80104d0d <sys_date+0x2d>

80104d16 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104d16:	1e                   	push   %ds
  pushl %es
80104d17:	06                   	push   %es
  pushl %fs
80104d18:	0f a0                	push   %fs
  pushl %gs
80104d1a:	0f a8                	push   %gs
  pushal
80104d1c:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104d1d:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104d21:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104d23:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104d25:	54                   	push   %esp
  call trap
80104d26:	e8 cb 00 00 00       	call   80104df6 <trap>
  addl $4, %esp
80104d2b:	83 c4 04             	add    $0x4,%esp

80104d2e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104d2e:	61                   	popa   
  popl %gs
80104d2f:	0f a9                	pop    %gs
  popl %fs
80104d31:	0f a1                	pop    %fs
  popl %es
80104d33:	07                   	pop    %es
  popl %ds
80104d34:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104d35:	83 c4 08             	add    $0x8,%esp
  iret
80104d38:	cf                   	iret   

80104d39 <tvinit>:
uint ticks;
#endif // PDX_XV6

void
tvinit(void)
{
80104d39:	55                   	push   %ebp
80104d3a:	89 e5                	mov    %esp,%ebp
  int i;

  for(i = 0; i < 256; i++)
80104d3c:	b8 00 00 00 00       	mov    $0x0,%eax
80104d41:	eb 4a                	jmp    80104d8d <tvinit+0x54>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104d43:	8b 0c 85 08 90 10 80 	mov    -0x7fef6ff8(,%eax,4),%ecx
80104d4a:	66 89 0c c5 80 3d 11 	mov    %cx,-0x7feec280(,%eax,8)
80104d51:	80 
80104d52:	66 c7 04 c5 82 3d 11 	movw   $0x8,-0x7feec27e(,%eax,8)
80104d59:	80 08 00 
80104d5c:	c6 04 c5 84 3d 11 80 	movb   $0x0,-0x7feec27c(,%eax,8)
80104d63:	00 
80104d64:	0f b6 14 c5 85 3d 11 	movzbl -0x7feec27b(,%eax,8),%edx
80104d6b:	80 
80104d6c:	83 e2 f0             	and    $0xfffffff0,%edx
80104d6f:	83 ca 0e             	or     $0xe,%edx
80104d72:	83 e2 8f             	and    $0xffffff8f,%edx
80104d75:	83 ca 80             	or     $0xffffff80,%edx
80104d78:	88 14 c5 85 3d 11 80 	mov    %dl,-0x7feec27b(,%eax,8)
80104d7f:	c1 e9 10             	shr    $0x10,%ecx
80104d82:	66 89 0c c5 86 3d 11 	mov    %cx,-0x7feec27a(,%eax,8)
80104d89:	80 
  for(i = 0; i < 256; i++)
80104d8a:	83 c0 01             	add    $0x1,%eax
80104d8d:	3d ff 00 00 00       	cmp    $0xff,%eax
80104d92:	7e af                	jle    80104d43 <tvinit+0xa>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104d94:	8b 15 08 91 10 80    	mov    0x80109108,%edx
80104d9a:	66 89 15 80 3f 11 80 	mov    %dx,0x80113f80
80104da1:	66 c7 05 82 3f 11 80 	movw   $0x8,0x80113f82
80104da8:	08 00 
80104daa:	c6 05 84 3f 11 80 00 	movb   $0x0,0x80113f84
80104db1:	0f b6 05 85 3f 11 80 	movzbl 0x80113f85,%eax
80104db8:	83 c8 0f             	or     $0xf,%eax
80104dbb:	83 e0 ef             	and    $0xffffffef,%eax
80104dbe:	83 c8 e0             	or     $0xffffffe0,%eax
80104dc1:	a2 85 3f 11 80       	mov    %al,0x80113f85
80104dc6:	c1 ea 10             	shr    $0x10,%edx
80104dc9:	66 89 15 86 3f 11 80 	mov    %dx,0x80113f86

#ifndef PDX_XV6
  initlock(&tickslock, "time");
#endif // PDX_XV6
}
80104dd0:	5d                   	pop    %ebp
80104dd1:	c3                   	ret    

80104dd2 <idtinit>:

void
idtinit(void)
{
80104dd2:	55                   	push   %ebp
80104dd3:	89 e5                	mov    %esp,%ebp
80104dd5:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104dd8:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104dde:	b8 80 3d 11 80       	mov    $0x80113d80,%eax
80104de3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104de7:	c1 e8 10             	shr    $0x10,%eax
80104dea:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80104dee:	8d 45 fa             	lea    -0x6(%ebp),%eax
80104df1:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80104df4:	c9                   	leave  
80104df5:	c3                   	ret    

80104df6 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80104df6:	55                   	push   %ebp
80104df7:	89 e5                	mov    %esp,%ebp
80104df9:	57                   	push   %edi
80104dfa:	56                   	push   %esi
80104dfb:	53                   	push   %ebx
80104dfc:	83 ec 1c             	sub    $0x1c,%esp
80104dff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80104e02:	8b 43 30             	mov    0x30(%ebx),%eax
80104e05:	83 f8 40             	cmp    $0x40,%eax
80104e08:	74 13                	je     80104e1d <trap+0x27>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80104e0a:	83 e8 20             	sub    $0x20,%eax
80104e0d:	83 f8 1f             	cmp    $0x1f,%eax
80104e10:	0f 87 22 01 00 00    	ja     80104f38 <trap+0x142>
80104e16:	ff 24 85 80 6c 10 80 	jmp    *-0x7fef9380(,%eax,4)
    if(myproc()->killed)
80104e1d:	e8 1f e4 ff ff       	call   80103241 <myproc>
80104e22:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104e26:	75 1f                	jne    80104e47 <trap+0x51>
    myproc()->tf = tf;
80104e28:	e8 14 e4 ff ff       	call   80103241 <myproc>
80104e2d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80104e30:	e8 6d f1 ff ff       	call   80103fa2 <syscall>
    if(myproc()->killed)
80104e35:	e8 07 e4 ff ff       	call   80103241 <myproc>
80104e3a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104e3e:	74 7e                	je     80104ebe <trap+0xc8>
      exit();
80104e40:	e8 bc e7 ff ff       	call   80103601 <exit>
80104e45:	eb 77                	jmp    80104ebe <trap+0xc8>
      exit();
80104e47:	e8 b5 e7 ff ff       	call   80103601 <exit>
80104e4c:	eb da                	jmp    80104e28 <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80104e4e:	e8 d3 e3 ff ff       	call   80103226 <cpuid>
80104e53:	85 c0                	test   %eax,%eax
80104e55:	74 6f                	je     80104ec6 <trap+0xd0>
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
#endif // PDX_XV6
    }
    lapiceoi();
80104e57:	e8 70 d5 ff ff       	call   801023cc <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104e5c:	e8 e0 e3 ff ff       	call   80103241 <myproc>
80104e61:	85 c0                	test   %eax,%eax
80104e63:	74 1c                	je     80104e81 <trap+0x8b>
80104e65:	e8 d7 e3 ff ff       	call   80103241 <myproc>
80104e6a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104e6e:	74 11                	je     80104e81 <trap+0x8b>
80104e70:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80104e74:	83 e0 03             	and    $0x3,%eax
80104e77:	66 83 f8 03          	cmp    $0x3,%ax
80104e7b:	0f 84 4a 01 00 00    	je     80104fcb <trap+0x1d5>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80104e81:	e8 bb e3 ff ff       	call   80103241 <myproc>
80104e86:	85 c0                	test   %eax,%eax
80104e88:	74 0f                	je     80104e99 <trap+0xa3>
80104e8a:	e8 b2 e3 ff ff       	call   80103241 <myproc>
80104e8f:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80104e93:	0f 84 3c 01 00 00    	je     80104fd5 <trap+0x1df>
    tf->trapno == T_IRQ0+IRQ_TIMER)
#endif // PDX_XV6
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104e99:	e8 a3 e3 ff ff       	call   80103241 <myproc>
80104e9e:	85 c0                	test   %eax,%eax
80104ea0:	74 1c                	je     80104ebe <trap+0xc8>
80104ea2:	e8 9a e3 ff ff       	call   80103241 <myproc>
80104ea7:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104eab:	74 11                	je     80104ebe <trap+0xc8>
80104ead:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80104eb1:	83 e0 03             	and    $0x3,%eax
80104eb4:	66 83 f8 03          	cmp    $0x3,%ax
80104eb8:	0f 84 4b 01 00 00    	je     80105009 <trap+0x213>
    exit();
}
80104ebe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ec1:	5b                   	pop    %ebx
80104ec2:	5e                   	pop    %esi
80104ec3:	5f                   	pop    %edi
80104ec4:	5d                   	pop    %ebp
80104ec5:	c3                   	ret    
// atom_inc() necessary for removal of tickslock
// other atomic ops added for completeness
static inline void
atom_inc(volatile int *num)
{
  asm volatile ( "lock incl %0" : "=m" (*num));
80104ec6:	f0 ff 05 80 45 11 80 	lock incl 0x80114580
      wakeup(&ticks);
80104ecd:	83 ec 0c             	sub    $0xc,%esp
80104ed0:	68 80 45 11 80       	push   $0x80114580
80104ed5:	e8 92 e9 ff ff       	call   8010386c <wakeup>
80104eda:	83 c4 10             	add    $0x10,%esp
80104edd:	e9 75 ff ff ff       	jmp    80104e57 <trap+0x61>
    ideintr();
80104ee2:	e8 bf ce ff ff       	call   80101da6 <ideintr>
    lapiceoi();
80104ee7:	e8 e0 d4 ff ff       	call   801023cc <lapiceoi>
    break;
80104eec:	e9 6b ff ff ff       	jmp    80104e5c <trap+0x66>
    kbdintr();
80104ef1:	e8 1a d3 ff ff       	call   80102210 <kbdintr>
    lapiceoi();
80104ef6:	e8 d1 d4 ff ff       	call   801023cc <lapiceoi>
    break;
80104efb:	e9 5c ff ff ff       	jmp    80104e5c <trap+0x66>
    uartintr();
80104f00:	e8 25 02 00 00       	call   8010512a <uartintr>
    lapiceoi();
80104f05:	e8 c2 d4 ff ff       	call   801023cc <lapiceoi>
    break;
80104f0a:	e9 4d ff ff ff       	jmp    80104e5c <trap+0x66>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80104f0f:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
80104f12:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80104f16:	e8 0b e3 ff ff       	call   80103226 <cpuid>
80104f1b:	57                   	push   %edi
80104f1c:	0f b7 f6             	movzwl %si,%esi
80104f1f:	56                   	push   %esi
80104f20:	50                   	push   %eax
80104f21:	68 e0 6b 10 80       	push   $0x80106be0
80104f26:	e8 e0 b6 ff ff       	call   8010060b <cprintf>
    lapiceoi();
80104f2b:	e8 9c d4 ff ff       	call   801023cc <lapiceoi>
    break;
80104f30:	83 c4 10             	add    $0x10,%esp
80104f33:	e9 24 ff ff ff       	jmp    80104e5c <trap+0x66>
    if(myproc() == 0 || (tf->cs&3) == 0){
80104f38:	e8 04 e3 ff ff       	call   80103241 <myproc>
80104f3d:	85 c0                	test   %eax,%eax
80104f3f:	74 5f                	je     80104fa0 <trap+0x1aa>
80104f41:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80104f45:	74 59                	je     80104fa0 <trap+0x1aa>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80104f47:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80104f4a:	8b 43 38             	mov    0x38(%ebx),%eax
80104f4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104f50:	e8 d1 e2 ff ff       	call   80103226 <cpuid>
80104f55:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104f58:	8b 4b 34             	mov    0x34(%ebx),%ecx
80104f5b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80104f5e:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80104f61:	e8 db e2 ff ff       	call   80103241 <myproc>
80104f66:	8d 50 6c             	lea    0x6c(%eax),%edx
80104f69:	89 55 d8             	mov    %edx,-0x28(%ebp)
80104f6c:	e8 d0 e2 ff ff       	call   80103241 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80104f71:	57                   	push   %edi
80104f72:	ff 75 e4             	pushl  -0x1c(%ebp)
80104f75:	ff 75 e0             	pushl  -0x20(%ebp)
80104f78:	ff 75 dc             	pushl  -0x24(%ebp)
80104f7b:	56                   	push   %esi
80104f7c:	ff 75 d8             	pushl  -0x28(%ebp)
80104f7f:	ff 70 10             	pushl  0x10(%eax)
80104f82:	68 38 6c 10 80       	push   $0x80106c38
80104f87:	e8 7f b6 ff ff       	call   8010060b <cprintf>
    myproc()->killed = 1;
80104f8c:	83 c4 20             	add    $0x20,%esp
80104f8f:	e8 ad e2 ff ff       	call   80103241 <myproc>
80104f94:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80104f9b:	e9 bc fe ff ff       	jmp    80104e5c <trap+0x66>
80104fa0:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80104fa3:	8b 73 38             	mov    0x38(%ebx),%esi
80104fa6:	e8 7b e2 ff ff       	call   80103226 <cpuid>
80104fab:	83 ec 0c             	sub    $0xc,%esp
80104fae:	57                   	push   %edi
80104faf:	56                   	push   %esi
80104fb0:	50                   	push   %eax
80104fb1:	ff 73 30             	pushl  0x30(%ebx)
80104fb4:	68 04 6c 10 80       	push   $0x80106c04
80104fb9:	e8 4d b6 ff ff       	call   8010060b <cprintf>
      panic("trap");
80104fbe:	83 c4 14             	add    $0x14,%esp
80104fc1:	68 7b 6c 10 80       	push   $0x80106c7b
80104fc6:	e8 7d b3 ff ff       	call   80100348 <panic>
    exit();
80104fcb:	e8 31 e6 ff ff       	call   80103601 <exit>
80104fd0:	e9 ac fe ff ff       	jmp    80104e81 <trap+0x8b>
  if(myproc() && myproc()->state == RUNNING &&
80104fd5:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80104fd9:	0f 85 ba fe ff ff    	jne    80104e99 <trap+0xa3>
    tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80104fdf:	8b 0d 80 45 11 80    	mov    0x80114580,%ecx
80104fe5:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80104fea:	89 c8                	mov    %ecx,%eax
80104fec:	f7 e2                	mul    %edx
80104fee:	c1 ea 03             	shr    $0x3,%edx
80104ff1:	8d 14 92             	lea    (%edx,%edx,4),%edx
80104ff4:	8d 04 12             	lea    (%edx,%edx,1),%eax
80104ff7:	39 c1                	cmp    %eax,%ecx
80104ff9:	0f 85 9a fe ff ff    	jne    80104e99 <trap+0xa3>
    yield();
80104fff:	e8 c9 e6 ff ff       	call   801036cd <yield>
80105004:	e9 90 fe ff ff       	jmp    80104e99 <trap+0xa3>
    exit();
80105009:	e8 f3 e5 ff ff       	call   80103601 <exit>
8010500e:	e9 ab fe ff ff       	jmp    80104ebe <trap+0xc8>

80105013 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105013:	55                   	push   %ebp
80105014:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105016:	83 3d 14 b6 10 80 00 	cmpl   $0x0,0x8010b614
8010501d:	74 15                	je     80105034 <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010501f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105024:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105025:	a8 01                	test   $0x1,%al
80105027:	74 12                	je     8010503b <uartgetc+0x28>
80105029:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010502e:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010502f:	0f b6 c0             	movzbl %al,%eax
}
80105032:	5d                   	pop    %ebp
80105033:	c3                   	ret    
    return -1;
80105034:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105039:	eb f7                	jmp    80105032 <uartgetc+0x1f>
    return -1;
8010503b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105040:	eb f0                	jmp    80105032 <uartgetc+0x1f>

80105042 <uartputc>:
  if(!uart)
80105042:	83 3d 14 b6 10 80 00 	cmpl   $0x0,0x8010b614
80105049:	74 3b                	je     80105086 <uartputc+0x44>
{
8010504b:	55                   	push   %ebp
8010504c:	89 e5                	mov    %esp,%ebp
8010504e:	53                   	push   %ebx
8010504f:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105052:	bb 00 00 00 00       	mov    $0x0,%ebx
80105057:	eb 10                	jmp    80105069 <uartputc+0x27>
    microdelay(10);
80105059:	83 ec 0c             	sub    $0xc,%esp
8010505c:	6a 0a                	push   $0xa
8010505e:	e8 88 d3 ff ff       	call   801023eb <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105063:	83 c3 01             	add    $0x1,%ebx
80105066:	83 c4 10             	add    $0x10,%esp
80105069:	83 fb 7f             	cmp    $0x7f,%ebx
8010506c:	7f 0a                	jg     80105078 <uartputc+0x36>
8010506e:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105073:	ec                   	in     (%dx),%al
80105074:	a8 20                	test   $0x20,%al
80105076:	74 e1                	je     80105059 <uartputc+0x17>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105078:	8b 45 08             	mov    0x8(%ebp),%eax
8010507b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105080:	ee                   	out    %al,(%dx)
}
80105081:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105084:	c9                   	leave  
80105085:	c3                   	ret    
80105086:	f3 c3                	repz ret 

80105088 <uartinit>:
{
80105088:	55                   	push   %ebp
80105089:	89 e5                	mov    %esp,%ebp
8010508b:	56                   	push   %esi
8010508c:	53                   	push   %ebx
8010508d:	b9 00 00 00 00       	mov    $0x0,%ecx
80105092:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105097:	89 c8                	mov    %ecx,%eax
80105099:	ee                   	out    %al,(%dx)
8010509a:	be fb 03 00 00       	mov    $0x3fb,%esi
8010509f:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801050a4:	89 f2                	mov    %esi,%edx
801050a6:	ee                   	out    %al,(%dx)
801050a7:	b8 0c 00 00 00       	mov    $0xc,%eax
801050ac:	ba f8 03 00 00       	mov    $0x3f8,%edx
801050b1:	ee                   	out    %al,(%dx)
801050b2:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801050b7:	89 c8                	mov    %ecx,%eax
801050b9:	89 da                	mov    %ebx,%edx
801050bb:	ee                   	out    %al,(%dx)
801050bc:	b8 03 00 00 00       	mov    $0x3,%eax
801050c1:	89 f2                	mov    %esi,%edx
801050c3:	ee                   	out    %al,(%dx)
801050c4:	ba fc 03 00 00       	mov    $0x3fc,%edx
801050c9:	89 c8                	mov    %ecx,%eax
801050cb:	ee                   	out    %al,(%dx)
801050cc:	b8 01 00 00 00       	mov    $0x1,%eax
801050d1:	89 da                	mov    %ebx,%edx
801050d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801050d4:	ba fd 03 00 00       	mov    $0x3fd,%edx
801050d9:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801050da:	3c ff                	cmp    $0xff,%al
801050dc:	74 45                	je     80105123 <uartinit+0x9b>
  uart = 1;
801050de:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
801050e5:	00 00 00 
801050e8:	ba fa 03 00 00       	mov    $0x3fa,%edx
801050ed:	ec                   	in     (%dx),%al
801050ee:	ba f8 03 00 00       	mov    $0x3f8,%edx
801050f3:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801050f4:	83 ec 08             	sub    $0x8,%esp
801050f7:	6a 00                	push   $0x0
801050f9:	6a 04                	push   $0x4
801050fb:	e8 b1 ce ff ff       	call   80101fb1 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105100:	83 c4 10             	add    $0x10,%esp
80105103:	bb 00 6d 10 80       	mov    $0x80106d00,%ebx
80105108:	eb 12                	jmp    8010511c <uartinit+0x94>
    uartputc(*p);
8010510a:	83 ec 0c             	sub    $0xc,%esp
8010510d:	0f be c0             	movsbl %al,%eax
80105110:	50                   	push   %eax
80105111:	e8 2c ff ff ff       	call   80105042 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105116:	83 c3 01             	add    $0x1,%ebx
80105119:	83 c4 10             	add    $0x10,%esp
8010511c:	0f b6 03             	movzbl (%ebx),%eax
8010511f:	84 c0                	test   %al,%al
80105121:	75 e7                	jne    8010510a <uartinit+0x82>
}
80105123:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105126:	5b                   	pop    %ebx
80105127:	5e                   	pop    %esi
80105128:	5d                   	pop    %ebp
80105129:	c3                   	ret    

8010512a <uartintr>:

void
uartintr(void)
{
8010512a:	55                   	push   %ebp
8010512b:	89 e5                	mov    %esp,%ebp
8010512d:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105130:	68 13 50 10 80       	push   $0x80105013
80105135:	e8 25 b6 ff ff       	call   8010075f <consoleintr>
}
8010513a:	83 c4 10             	add    $0x10,%esp
8010513d:	c9                   	leave  
8010513e:	c3                   	ret    

8010513f <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010513f:	6a 00                	push   $0x0
  pushl $0
80105141:	6a 00                	push   $0x0
  jmp alltraps
80105143:	e9 ce fb ff ff       	jmp    80104d16 <alltraps>

80105148 <vector1>:
.globl vector1
vector1:
  pushl $0
80105148:	6a 00                	push   $0x0
  pushl $1
8010514a:	6a 01                	push   $0x1
  jmp alltraps
8010514c:	e9 c5 fb ff ff       	jmp    80104d16 <alltraps>

80105151 <vector2>:
.globl vector2
vector2:
  pushl $0
80105151:	6a 00                	push   $0x0
  pushl $2
80105153:	6a 02                	push   $0x2
  jmp alltraps
80105155:	e9 bc fb ff ff       	jmp    80104d16 <alltraps>

8010515a <vector3>:
.globl vector3
vector3:
  pushl $0
8010515a:	6a 00                	push   $0x0
  pushl $3
8010515c:	6a 03                	push   $0x3
  jmp alltraps
8010515e:	e9 b3 fb ff ff       	jmp    80104d16 <alltraps>

80105163 <vector4>:
.globl vector4
vector4:
  pushl $0
80105163:	6a 00                	push   $0x0
  pushl $4
80105165:	6a 04                	push   $0x4
  jmp alltraps
80105167:	e9 aa fb ff ff       	jmp    80104d16 <alltraps>

8010516c <vector5>:
.globl vector5
vector5:
  pushl $0
8010516c:	6a 00                	push   $0x0
  pushl $5
8010516e:	6a 05                	push   $0x5
  jmp alltraps
80105170:	e9 a1 fb ff ff       	jmp    80104d16 <alltraps>

80105175 <vector6>:
.globl vector6
vector6:
  pushl $0
80105175:	6a 00                	push   $0x0
  pushl $6
80105177:	6a 06                	push   $0x6
  jmp alltraps
80105179:	e9 98 fb ff ff       	jmp    80104d16 <alltraps>

8010517e <vector7>:
.globl vector7
vector7:
  pushl $0
8010517e:	6a 00                	push   $0x0
  pushl $7
80105180:	6a 07                	push   $0x7
  jmp alltraps
80105182:	e9 8f fb ff ff       	jmp    80104d16 <alltraps>

80105187 <vector8>:
.globl vector8
vector8:
  pushl $8
80105187:	6a 08                	push   $0x8
  jmp alltraps
80105189:	e9 88 fb ff ff       	jmp    80104d16 <alltraps>

8010518e <vector9>:
.globl vector9
vector9:
  pushl $0
8010518e:	6a 00                	push   $0x0
  pushl $9
80105190:	6a 09                	push   $0x9
  jmp alltraps
80105192:	e9 7f fb ff ff       	jmp    80104d16 <alltraps>

80105197 <vector10>:
.globl vector10
vector10:
  pushl $10
80105197:	6a 0a                	push   $0xa
  jmp alltraps
80105199:	e9 78 fb ff ff       	jmp    80104d16 <alltraps>

8010519e <vector11>:
.globl vector11
vector11:
  pushl $11
8010519e:	6a 0b                	push   $0xb
  jmp alltraps
801051a0:	e9 71 fb ff ff       	jmp    80104d16 <alltraps>

801051a5 <vector12>:
.globl vector12
vector12:
  pushl $12
801051a5:	6a 0c                	push   $0xc
  jmp alltraps
801051a7:	e9 6a fb ff ff       	jmp    80104d16 <alltraps>

801051ac <vector13>:
.globl vector13
vector13:
  pushl $13
801051ac:	6a 0d                	push   $0xd
  jmp alltraps
801051ae:	e9 63 fb ff ff       	jmp    80104d16 <alltraps>

801051b3 <vector14>:
.globl vector14
vector14:
  pushl $14
801051b3:	6a 0e                	push   $0xe
  jmp alltraps
801051b5:	e9 5c fb ff ff       	jmp    80104d16 <alltraps>

801051ba <vector15>:
.globl vector15
vector15:
  pushl $0
801051ba:	6a 00                	push   $0x0
  pushl $15
801051bc:	6a 0f                	push   $0xf
  jmp alltraps
801051be:	e9 53 fb ff ff       	jmp    80104d16 <alltraps>

801051c3 <vector16>:
.globl vector16
vector16:
  pushl $0
801051c3:	6a 00                	push   $0x0
  pushl $16
801051c5:	6a 10                	push   $0x10
  jmp alltraps
801051c7:	e9 4a fb ff ff       	jmp    80104d16 <alltraps>

801051cc <vector17>:
.globl vector17
vector17:
  pushl $17
801051cc:	6a 11                	push   $0x11
  jmp alltraps
801051ce:	e9 43 fb ff ff       	jmp    80104d16 <alltraps>

801051d3 <vector18>:
.globl vector18
vector18:
  pushl $0
801051d3:	6a 00                	push   $0x0
  pushl $18
801051d5:	6a 12                	push   $0x12
  jmp alltraps
801051d7:	e9 3a fb ff ff       	jmp    80104d16 <alltraps>

801051dc <vector19>:
.globl vector19
vector19:
  pushl $0
801051dc:	6a 00                	push   $0x0
  pushl $19
801051de:	6a 13                	push   $0x13
  jmp alltraps
801051e0:	e9 31 fb ff ff       	jmp    80104d16 <alltraps>

801051e5 <vector20>:
.globl vector20
vector20:
  pushl $0
801051e5:	6a 00                	push   $0x0
  pushl $20
801051e7:	6a 14                	push   $0x14
  jmp alltraps
801051e9:	e9 28 fb ff ff       	jmp    80104d16 <alltraps>

801051ee <vector21>:
.globl vector21
vector21:
  pushl $0
801051ee:	6a 00                	push   $0x0
  pushl $21
801051f0:	6a 15                	push   $0x15
  jmp alltraps
801051f2:	e9 1f fb ff ff       	jmp    80104d16 <alltraps>

801051f7 <vector22>:
.globl vector22
vector22:
  pushl $0
801051f7:	6a 00                	push   $0x0
  pushl $22
801051f9:	6a 16                	push   $0x16
  jmp alltraps
801051fb:	e9 16 fb ff ff       	jmp    80104d16 <alltraps>

80105200 <vector23>:
.globl vector23
vector23:
  pushl $0
80105200:	6a 00                	push   $0x0
  pushl $23
80105202:	6a 17                	push   $0x17
  jmp alltraps
80105204:	e9 0d fb ff ff       	jmp    80104d16 <alltraps>

80105209 <vector24>:
.globl vector24
vector24:
  pushl $0
80105209:	6a 00                	push   $0x0
  pushl $24
8010520b:	6a 18                	push   $0x18
  jmp alltraps
8010520d:	e9 04 fb ff ff       	jmp    80104d16 <alltraps>

80105212 <vector25>:
.globl vector25
vector25:
  pushl $0
80105212:	6a 00                	push   $0x0
  pushl $25
80105214:	6a 19                	push   $0x19
  jmp alltraps
80105216:	e9 fb fa ff ff       	jmp    80104d16 <alltraps>

8010521b <vector26>:
.globl vector26
vector26:
  pushl $0
8010521b:	6a 00                	push   $0x0
  pushl $26
8010521d:	6a 1a                	push   $0x1a
  jmp alltraps
8010521f:	e9 f2 fa ff ff       	jmp    80104d16 <alltraps>

80105224 <vector27>:
.globl vector27
vector27:
  pushl $0
80105224:	6a 00                	push   $0x0
  pushl $27
80105226:	6a 1b                	push   $0x1b
  jmp alltraps
80105228:	e9 e9 fa ff ff       	jmp    80104d16 <alltraps>

8010522d <vector28>:
.globl vector28
vector28:
  pushl $0
8010522d:	6a 00                	push   $0x0
  pushl $28
8010522f:	6a 1c                	push   $0x1c
  jmp alltraps
80105231:	e9 e0 fa ff ff       	jmp    80104d16 <alltraps>

80105236 <vector29>:
.globl vector29
vector29:
  pushl $0
80105236:	6a 00                	push   $0x0
  pushl $29
80105238:	6a 1d                	push   $0x1d
  jmp alltraps
8010523a:	e9 d7 fa ff ff       	jmp    80104d16 <alltraps>

8010523f <vector30>:
.globl vector30
vector30:
  pushl $0
8010523f:	6a 00                	push   $0x0
  pushl $30
80105241:	6a 1e                	push   $0x1e
  jmp alltraps
80105243:	e9 ce fa ff ff       	jmp    80104d16 <alltraps>

80105248 <vector31>:
.globl vector31
vector31:
  pushl $0
80105248:	6a 00                	push   $0x0
  pushl $31
8010524a:	6a 1f                	push   $0x1f
  jmp alltraps
8010524c:	e9 c5 fa ff ff       	jmp    80104d16 <alltraps>

80105251 <vector32>:
.globl vector32
vector32:
  pushl $0
80105251:	6a 00                	push   $0x0
  pushl $32
80105253:	6a 20                	push   $0x20
  jmp alltraps
80105255:	e9 bc fa ff ff       	jmp    80104d16 <alltraps>

8010525a <vector33>:
.globl vector33
vector33:
  pushl $0
8010525a:	6a 00                	push   $0x0
  pushl $33
8010525c:	6a 21                	push   $0x21
  jmp alltraps
8010525e:	e9 b3 fa ff ff       	jmp    80104d16 <alltraps>

80105263 <vector34>:
.globl vector34
vector34:
  pushl $0
80105263:	6a 00                	push   $0x0
  pushl $34
80105265:	6a 22                	push   $0x22
  jmp alltraps
80105267:	e9 aa fa ff ff       	jmp    80104d16 <alltraps>

8010526c <vector35>:
.globl vector35
vector35:
  pushl $0
8010526c:	6a 00                	push   $0x0
  pushl $35
8010526e:	6a 23                	push   $0x23
  jmp alltraps
80105270:	e9 a1 fa ff ff       	jmp    80104d16 <alltraps>

80105275 <vector36>:
.globl vector36
vector36:
  pushl $0
80105275:	6a 00                	push   $0x0
  pushl $36
80105277:	6a 24                	push   $0x24
  jmp alltraps
80105279:	e9 98 fa ff ff       	jmp    80104d16 <alltraps>

8010527e <vector37>:
.globl vector37
vector37:
  pushl $0
8010527e:	6a 00                	push   $0x0
  pushl $37
80105280:	6a 25                	push   $0x25
  jmp alltraps
80105282:	e9 8f fa ff ff       	jmp    80104d16 <alltraps>

80105287 <vector38>:
.globl vector38
vector38:
  pushl $0
80105287:	6a 00                	push   $0x0
  pushl $38
80105289:	6a 26                	push   $0x26
  jmp alltraps
8010528b:	e9 86 fa ff ff       	jmp    80104d16 <alltraps>

80105290 <vector39>:
.globl vector39
vector39:
  pushl $0
80105290:	6a 00                	push   $0x0
  pushl $39
80105292:	6a 27                	push   $0x27
  jmp alltraps
80105294:	e9 7d fa ff ff       	jmp    80104d16 <alltraps>

80105299 <vector40>:
.globl vector40
vector40:
  pushl $0
80105299:	6a 00                	push   $0x0
  pushl $40
8010529b:	6a 28                	push   $0x28
  jmp alltraps
8010529d:	e9 74 fa ff ff       	jmp    80104d16 <alltraps>

801052a2 <vector41>:
.globl vector41
vector41:
  pushl $0
801052a2:	6a 00                	push   $0x0
  pushl $41
801052a4:	6a 29                	push   $0x29
  jmp alltraps
801052a6:	e9 6b fa ff ff       	jmp    80104d16 <alltraps>

801052ab <vector42>:
.globl vector42
vector42:
  pushl $0
801052ab:	6a 00                	push   $0x0
  pushl $42
801052ad:	6a 2a                	push   $0x2a
  jmp alltraps
801052af:	e9 62 fa ff ff       	jmp    80104d16 <alltraps>

801052b4 <vector43>:
.globl vector43
vector43:
  pushl $0
801052b4:	6a 00                	push   $0x0
  pushl $43
801052b6:	6a 2b                	push   $0x2b
  jmp alltraps
801052b8:	e9 59 fa ff ff       	jmp    80104d16 <alltraps>

801052bd <vector44>:
.globl vector44
vector44:
  pushl $0
801052bd:	6a 00                	push   $0x0
  pushl $44
801052bf:	6a 2c                	push   $0x2c
  jmp alltraps
801052c1:	e9 50 fa ff ff       	jmp    80104d16 <alltraps>

801052c6 <vector45>:
.globl vector45
vector45:
  pushl $0
801052c6:	6a 00                	push   $0x0
  pushl $45
801052c8:	6a 2d                	push   $0x2d
  jmp alltraps
801052ca:	e9 47 fa ff ff       	jmp    80104d16 <alltraps>

801052cf <vector46>:
.globl vector46
vector46:
  pushl $0
801052cf:	6a 00                	push   $0x0
  pushl $46
801052d1:	6a 2e                	push   $0x2e
  jmp alltraps
801052d3:	e9 3e fa ff ff       	jmp    80104d16 <alltraps>

801052d8 <vector47>:
.globl vector47
vector47:
  pushl $0
801052d8:	6a 00                	push   $0x0
  pushl $47
801052da:	6a 2f                	push   $0x2f
  jmp alltraps
801052dc:	e9 35 fa ff ff       	jmp    80104d16 <alltraps>

801052e1 <vector48>:
.globl vector48
vector48:
  pushl $0
801052e1:	6a 00                	push   $0x0
  pushl $48
801052e3:	6a 30                	push   $0x30
  jmp alltraps
801052e5:	e9 2c fa ff ff       	jmp    80104d16 <alltraps>

801052ea <vector49>:
.globl vector49
vector49:
  pushl $0
801052ea:	6a 00                	push   $0x0
  pushl $49
801052ec:	6a 31                	push   $0x31
  jmp alltraps
801052ee:	e9 23 fa ff ff       	jmp    80104d16 <alltraps>

801052f3 <vector50>:
.globl vector50
vector50:
  pushl $0
801052f3:	6a 00                	push   $0x0
  pushl $50
801052f5:	6a 32                	push   $0x32
  jmp alltraps
801052f7:	e9 1a fa ff ff       	jmp    80104d16 <alltraps>

801052fc <vector51>:
.globl vector51
vector51:
  pushl $0
801052fc:	6a 00                	push   $0x0
  pushl $51
801052fe:	6a 33                	push   $0x33
  jmp alltraps
80105300:	e9 11 fa ff ff       	jmp    80104d16 <alltraps>

80105305 <vector52>:
.globl vector52
vector52:
  pushl $0
80105305:	6a 00                	push   $0x0
  pushl $52
80105307:	6a 34                	push   $0x34
  jmp alltraps
80105309:	e9 08 fa ff ff       	jmp    80104d16 <alltraps>

8010530e <vector53>:
.globl vector53
vector53:
  pushl $0
8010530e:	6a 00                	push   $0x0
  pushl $53
80105310:	6a 35                	push   $0x35
  jmp alltraps
80105312:	e9 ff f9 ff ff       	jmp    80104d16 <alltraps>

80105317 <vector54>:
.globl vector54
vector54:
  pushl $0
80105317:	6a 00                	push   $0x0
  pushl $54
80105319:	6a 36                	push   $0x36
  jmp alltraps
8010531b:	e9 f6 f9 ff ff       	jmp    80104d16 <alltraps>

80105320 <vector55>:
.globl vector55
vector55:
  pushl $0
80105320:	6a 00                	push   $0x0
  pushl $55
80105322:	6a 37                	push   $0x37
  jmp alltraps
80105324:	e9 ed f9 ff ff       	jmp    80104d16 <alltraps>

80105329 <vector56>:
.globl vector56
vector56:
  pushl $0
80105329:	6a 00                	push   $0x0
  pushl $56
8010532b:	6a 38                	push   $0x38
  jmp alltraps
8010532d:	e9 e4 f9 ff ff       	jmp    80104d16 <alltraps>

80105332 <vector57>:
.globl vector57
vector57:
  pushl $0
80105332:	6a 00                	push   $0x0
  pushl $57
80105334:	6a 39                	push   $0x39
  jmp alltraps
80105336:	e9 db f9 ff ff       	jmp    80104d16 <alltraps>

8010533b <vector58>:
.globl vector58
vector58:
  pushl $0
8010533b:	6a 00                	push   $0x0
  pushl $58
8010533d:	6a 3a                	push   $0x3a
  jmp alltraps
8010533f:	e9 d2 f9 ff ff       	jmp    80104d16 <alltraps>

80105344 <vector59>:
.globl vector59
vector59:
  pushl $0
80105344:	6a 00                	push   $0x0
  pushl $59
80105346:	6a 3b                	push   $0x3b
  jmp alltraps
80105348:	e9 c9 f9 ff ff       	jmp    80104d16 <alltraps>

8010534d <vector60>:
.globl vector60
vector60:
  pushl $0
8010534d:	6a 00                	push   $0x0
  pushl $60
8010534f:	6a 3c                	push   $0x3c
  jmp alltraps
80105351:	e9 c0 f9 ff ff       	jmp    80104d16 <alltraps>

80105356 <vector61>:
.globl vector61
vector61:
  pushl $0
80105356:	6a 00                	push   $0x0
  pushl $61
80105358:	6a 3d                	push   $0x3d
  jmp alltraps
8010535a:	e9 b7 f9 ff ff       	jmp    80104d16 <alltraps>

8010535f <vector62>:
.globl vector62
vector62:
  pushl $0
8010535f:	6a 00                	push   $0x0
  pushl $62
80105361:	6a 3e                	push   $0x3e
  jmp alltraps
80105363:	e9 ae f9 ff ff       	jmp    80104d16 <alltraps>

80105368 <vector63>:
.globl vector63
vector63:
  pushl $0
80105368:	6a 00                	push   $0x0
  pushl $63
8010536a:	6a 3f                	push   $0x3f
  jmp alltraps
8010536c:	e9 a5 f9 ff ff       	jmp    80104d16 <alltraps>

80105371 <vector64>:
.globl vector64
vector64:
  pushl $0
80105371:	6a 00                	push   $0x0
  pushl $64
80105373:	6a 40                	push   $0x40
  jmp alltraps
80105375:	e9 9c f9 ff ff       	jmp    80104d16 <alltraps>

8010537a <vector65>:
.globl vector65
vector65:
  pushl $0
8010537a:	6a 00                	push   $0x0
  pushl $65
8010537c:	6a 41                	push   $0x41
  jmp alltraps
8010537e:	e9 93 f9 ff ff       	jmp    80104d16 <alltraps>

80105383 <vector66>:
.globl vector66
vector66:
  pushl $0
80105383:	6a 00                	push   $0x0
  pushl $66
80105385:	6a 42                	push   $0x42
  jmp alltraps
80105387:	e9 8a f9 ff ff       	jmp    80104d16 <alltraps>

8010538c <vector67>:
.globl vector67
vector67:
  pushl $0
8010538c:	6a 00                	push   $0x0
  pushl $67
8010538e:	6a 43                	push   $0x43
  jmp alltraps
80105390:	e9 81 f9 ff ff       	jmp    80104d16 <alltraps>

80105395 <vector68>:
.globl vector68
vector68:
  pushl $0
80105395:	6a 00                	push   $0x0
  pushl $68
80105397:	6a 44                	push   $0x44
  jmp alltraps
80105399:	e9 78 f9 ff ff       	jmp    80104d16 <alltraps>

8010539e <vector69>:
.globl vector69
vector69:
  pushl $0
8010539e:	6a 00                	push   $0x0
  pushl $69
801053a0:	6a 45                	push   $0x45
  jmp alltraps
801053a2:	e9 6f f9 ff ff       	jmp    80104d16 <alltraps>

801053a7 <vector70>:
.globl vector70
vector70:
  pushl $0
801053a7:	6a 00                	push   $0x0
  pushl $70
801053a9:	6a 46                	push   $0x46
  jmp alltraps
801053ab:	e9 66 f9 ff ff       	jmp    80104d16 <alltraps>

801053b0 <vector71>:
.globl vector71
vector71:
  pushl $0
801053b0:	6a 00                	push   $0x0
  pushl $71
801053b2:	6a 47                	push   $0x47
  jmp alltraps
801053b4:	e9 5d f9 ff ff       	jmp    80104d16 <alltraps>

801053b9 <vector72>:
.globl vector72
vector72:
  pushl $0
801053b9:	6a 00                	push   $0x0
  pushl $72
801053bb:	6a 48                	push   $0x48
  jmp alltraps
801053bd:	e9 54 f9 ff ff       	jmp    80104d16 <alltraps>

801053c2 <vector73>:
.globl vector73
vector73:
  pushl $0
801053c2:	6a 00                	push   $0x0
  pushl $73
801053c4:	6a 49                	push   $0x49
  jmp alltraps
801053c6:	e9 4b f9 ff ff       	jmp    80104d16 <alltraps>

801053cb <vector74>:
.globl vector74
vector74:
  pushl $0
801053cb:	6a 00                	push   $0x0
  pushl $74
801053cd:	6a 4a                	push   $0x4a
  jmp alltraps
801053cf:	e9 42 f9 ff ff       	jmp    80104d16 <alltraps>

801053d4 <vector75>:
.globl vector75
vector75:
  pushl $0
801053d4:	6a 00                	push   $0x0
  pushl $75
801053d6:	6a 4b                	push   $0x4b
  jmp alltraps
801053d8:	e9 39 f9 ff ff       	jmp    80104d16 <alltraps>

801053dd <vector76>:
.globl vector76
vector76:
  pushl $0
801053dd:	6a 00                	push   $0x0
  pushl $76
801053df:	6a 4c                	push   $0x4c
  jmp alltraps
801053e1:	e9 30 f9 ff ff       	jmp    80104d16 <alltraps>

801053e6 <vector77>:
.globl vector77
vector77:
  pushl $0
801053e6:	6a 00                	push   $0x0
  pushl $77
801053e8:	6a 4d                	push   $0x4d
  jmp alltraps
801053ea:	e9 27 f9 ff ff       	jmp    80104d16 <alltraps>

801053ef <vector78>:
.globl vector78
vector78:
  pushl $0
801053ef:	6a 00                	push   $0x0
  pushl $78
801053f1:	6a 4e                	push   $0x4e
  jmp alltraps
801053f3:	e9 1e f9 ff ff       	jmp    80104d16 <alltraps>

801053f8 <vector79>:
.globl vector79
vector79:
  pushl $0
801053f8:	6a 00                	push   $0x0
  pushl $79
801053fa:	6a 4f                	push   $0x4f
  jmp alltraps
801053fc:	e9 15 f9 ff ff       	jmp    80104d16 <alltraps>

80105401 <vector80>:
.globl vector80
vector80:
  pushl $0
80105401:	6a 00                	push   $0x0
  pushl $80
80105403:	6a 50                	push   $0x50
  jmp alltraps
80105405:	e9 0c f9 ff ff       	jmp    80104d16 <alltraps>

8010540a <vector81>:
.globl vector81
vector81:
  pushl $0
8010540a:	6a 00                	push   $0x0
  pushl $81
8010540c:	6a 51                	push   $0x51
  jmp alltraps
8010540e:	e9 03 f9 ff ff       	jmp    80104d16 <alltraps>

80105413 <vector82>:
.globl vector82
vector82:
  pushl $0
80105413:	6a 00                	push   $0x0
  pushl $82
80105415:	6a 52                	push   $0x52
  jmp alltraps
80105417:	e9 fa f8 ff ff       	jmp    80104d16 <alltraps>

8010541c <vector83>:
.globl vector83
vector83:
  pushl $0
8010541c:	6a 00                	push   $0x0
  pushl $83
8010541e:	6a 53                	push   $0x53
  jmp alltraps
80105420:	e9 f1 f8 ff ff       	jmp    80104d16 <alltraps>

80105425 <vector84>:
.globl vector84
vector84:
  pushl $0
80105425:	6a 00                	push   $0x0
  pushl $84
80105427:	6a 54                	push   $0x54
  jmp alltraps
80105429:	e9 e8 f8 ff ff       	jmp    80104d16 <alltraps>

8010542e <vector85>:
.globl vector85
vector85:
  pushl $0
8010542e:	6a 00                	push   $0x0
  pushl $85
80105430:	6a 55                	push   $0x55
  jmp alltraps
80105432:	e9 df f8 ff ff       	jmp    80104d16 <alltraps>

80105437 <vector86>:
.globl vector86
vector86:
  pushl $0
80105437:	6a 00                	push   $0x0
  pushl $86
80105439:	6a 56                	push   $0x56
  jmp alltraps
8010543b:	e9 d6 f8 ff ff       	jmp    80104d16 <alltraps>

80105440 <vector87>:
.globl vector87
vector87:
  pushl $0
80105440:	6a 00                	push   $0x0
  pushl $87
80105442:	6a 57                	push   $0x57
  jmp alltraps
80105444:	e9 cd f8 ff ff       	jmp    80104d16 <alltraps>

80105449 <vector88>:
.globl vector88
vector88:
  pushl $0
80105449:	6a 00                	push   $0x0
  pushl $88
8010544b:	6a 58                	push   $0x58
  jmp alltraps
8010544d:	e9 c4 f8 ff ff       	jmp    80104d16 <alltraps>

80105452 <vector89>:
.globl vector89
vector89:
  pushl $0
80105452:	6a 00                	push   $0x0
  pushl $89
80105454:	6a 59                	push   $0x59
  jmp alltraps
80105456:	e9 bb f8 ff ff       	jmp    80104d16 <alltraps>

8010545b <vector90>:
.globl vector90
vector90:
  pushl $0
8010545b:	6a 00                	push   $0x0
  pushl $90
8010545d:	6a 5a                	push   $0x5a
  jmp alltraps
8010545f:	e9 b2 f8 ff ff       	jmp    80104d16 <alltraps>

80105464 <vector91>:
.globl vector91
vector91:
  pushl $0
80105464:	6a 00                	push   $0x0
  pushl $91
80105466:	6a 5b                	push   $0x5b
  jmp alltraps
80105468:	e9 a9 f8 ff ff       	jmp    80104d16 <alltraps>

8010546d <vector92>:
.globl vector92
vector92:
  pushl $0
8010546d:	6a 00                	push   $0x0
  pushl $92
8010546f:	6a 5c                	push   $0x5c
  jmp alltraps
80105471:	e9 a0 f8 ff ff       	jmp    80104d16 <alltraps>

80105476 <vector93>:
.globl vector93
vector93:
  pushl $0
80105476:	6a 00                	push   $0x0
  pushl $93
80105478:	6a 5d                	push   $0x5d
  jmp alltraps
8010547a:	e9 97 f8 ff ff       	jmp    80104d16 <alltraps>

8010547f <vector94>:
.globl vector94
vector94:
  pushl $0
8010547f:	6a 00                	push   $0x0
  pushl $94
80105481:	6a 5e                	push   $0x5e
  jmp alltraps
80105483:	e9 8e f8 ff ff       	jmp    80104d16 <alltraps>

80105488 <vector95>:
.globl vector95
vector95:
  pushl $0
80105488:	6a 00                	push   $0x0
  pushl $95
8010548a:	6a 5f                	push   $0x5f
  jmp alltraps
8010548c:	e9 85 f8 ff ff       	jmp    80104d16 <alltraps>

80105491 <vector96>:
.globl vector96
vector96:
  pushl $0
80105491:	6a 00                	push   $0x0
  pushl $96
80105493:	6a 60                	push   $0x60
  jmp alltraps
80105495:	e9 7c f8 ff ff       	jmp    80104d16 <alltraps>

8010549a <vector97>:
.globl vector97
vector97:
  pushl $0
8010549a:	6a 00                	push   $0x0
  pushl $97
8010549c:	6a 61                	push   $0x61
  jmp alltraps
8010549e:	e9 73 f8 ff ff       	jmp    80104d16 <alltraps>

801054a3 <vector98>:
.globl vector98
vector98:
  pushl $0
801054a3:	6a 00                	push   $0x0
  pushl $98
801054a5:	6a 62                	push   $0x62
  jmp alltraps
801054a7:	e9 6a f8 ff ff       	jmp    80104d16 <alltraps>

801054ac <vector99>:
.globl vector99
vector99:
  pushl $0
801054ac:	6a 00                	push   $0x0
  pushl $99
801054ae:	6a 63                	push   $0x63
  jmp alltraps
801054b0:	e9 61 f8 ff ff       	jmp    80104d16 <alltraps>

801054b5 <vector100>:
.globl vector100
vector100:
  pushl $0
801054b5:	6a 00                	push   $0x0
  pushl $100
801054b7:	6a 64                	push   $0x64
  jmp alltraps
801054b9:	e9 58 f8 ff ff       	jmp    80104d16 <alltraps>

801054be <vector101>:
.globl vector101
vector101:
  pushl $0
801054be:	6a 00                	push   $0x0
  pushl $101
801054c0:	6a 65                	push   $0x65
  jmp alltraps
801054c2:	e9 4f f8 ff ff       	jmp    80104d16 <alltraps>

801054c7 <vector102>:
.globl vector102
vector102:
  pushl $0
801054c7:	6a 00                	push   $0x0
  pushl $102
801054c9:	6a 66                	push   $0x66
  jmp alltraps
801054cb:	e9 46 f8 ff ff       	jmp    80104d16 <alltraps>

801054d0 <vector103>:
.globl vector103
vector103:
  pushl $0
801054d0:	6a 00                	push   $0x0
  pushl $103
801054d2:	6a 67                	push   $0x67
  jmp alltraps
801054d4:	e9 3d f8 ff ff       	jmp    80104d16 <alltraps>

801054d9 <vector104>:
.globl vector104
vector104:
  pushl $0
801054d9:	6a 00                	push   $0x0
  pushl $104
801054db:	6a 68                	push   $0x68
  jmp alltraps
801054dd:	e9 34 f8 ff ff       	jmp    80104d16 <alltraps>

801054e2 <vector105>:
.globl vector105
vector105:
  pushl $0
801054e2:	6a 00                	push   $0x0
  pushl $105
801054e4:	6a 69                	push   $0x69
  jmp alltraps
801054e6:	e9 2b f8 ff ff       	jmp    80104d16 <alltraps>

801054eb <vector106>:
.globl vector106
vector106:
  pushl $0
801054eb:	6a 00                	push   $0x0
  pushl $106
801054ed:	6a 6a                	push   $0x6a
  jmp alltraps
801054ef:	e9 22 f8 ff ff       	jmp    80104d16 <alltraps>

801054f4 <vector107>:
.globl vector107
vector107:
  pushl $0
801054f4:	6a 00                	push   $0x0
  pushl $107
801054f6:	6a 6b                	push   $0x6b
  jmp alltraps
801054f8:	e9 19 f8 ff ff       	jmp    80104d16 <alltraps>

801054fd <vector108>:
.globl vector108
vector108:
  pushl $0
801054fd:	6a 00                	push   $0x0
  pushl $108
801054ff:	6a 6c                	push   $0x6c
  jmp alltraps
80105501:	e9 10 f8 ff ff       	jmp    80104d16 <alltraps>

80105506 <vector109>:
.globl vector109
vector109:
  pushl $0
80105506:	6a 00                	push   $0x0
  pushl $109
80105508:	6a 6d                	push   $0x6d
  jmp alltraps
8010550a:	e9 07 f8 ff ff       	jmp    80104d16 <alltraps>

8010550f <vector110>:
.globl vector110
vector110:
  pushl $0
8010550f:	6a 00                	push   $0x0
  pushl $110
80105511:	6a 6e                	push   $0x6e
  jmp alltraps
80105513:	e9 fe f7 ff ff       	jmp    80104d16 <alltraps>

80105518 <vector111>:
.globl vector111
vector111:
  pushl $0
80105518:	6a 00                	push   $0x0
  pushl $111
8010551a:	6a 6f                	push   $0x6f
  jmp alltraps
8010551c:	e9 f5 f7 ff ff       	jmp    80104d16 <alltraps>

80105521 <vector112>:
.globl vector112
vector112:
  pushl $0
80105521:	6a 00                	push   $0x0
  pushl $112
80105523:	6a 70                	push   $0x70
  jmp alltraps
80105525:	e9 ec f7 ff ff       	jmp    80104d16 <alltraps>

8010552a <vector113>:
.globl vector113
vector113:
  pushl $0
8010552a:	6a 00                	push   $0x0
  pushl $113
8010552c:	6a 71                	push   $0x71
  jmp alltraps
8010552e:	e9 e3 f7 ff ff       	jmp    80104d16 <alltraps>

80105533 <vector114>:
.globl vector114
vector114:
  pushl $0
80105533:	6a 00                	push   $0x0
  pushl $114
80105535:	6a 72                	push   $0x72
  jmp alltraps
80105537:	e9 da f7 ff ff       	jmp    80104d16 <alltraps>

8010553c <vector115>:
.globl vector115
vector115:
  pushl $0
8010553c:	6a 00                	push   $0x0
  pushl $115
8010553e:	6a 73                	push   $0x73
  jmp alltraps
80105540:	e9 d1 f7 ff ff       	jmp    80104d16 <alltraps>

80105545 <vector116>:
.globl vector116
vector116:
  pushl $0
80105545:	6a 00                	push   $0x0
  pushl $116
80105547:	6a 74                	push   $0x74
  jmp alltraps
80105549:	e9 c8 f7 ff ff       	jmp    80104d16 <alltraps>

8010554e <vector117>:
.globl vector117
vector117:
  pushl $0
8010554e:	6a 00                	push   $0x0
  pushl $117
80105550:	6a 75                	push   $0x75
  jmp alltraps
80105552:	e9 bf f7 ff ff       	jmp    80104d16 <alltraps>

80105557 <vector118>:
.globl vector118
vector118:
  pushl $0
80105557:	6a 00                	push   $0x0
  pushl $118
80105559:	6a 76                	push   $0x76
  jmp alltraps
8010555b:	e9 b6 f7 ff ff       	jmp    80104d16 <alltraps>

80105560 <vector119>:
.globl vector119
vector119:
  pushl $0
80105560:	6a 00                	push   $0x0
  pushl $119
80105562:	6a 77                	push   $0x77
  jmp alltraps
80105564:	e9 ad f7 ff ff       	jmp    80104d16 <alltraps>

80105569 <vector120>:
.globl vector120
vector120:
  pushl $0
80105569:	6a 00                	push   $0x0
  pushl $120
8010556b:	6a 78                	push   $0x78
  jmp alltraps
8010556d:	e9 a4 f7 ff ff       	jmp    80104d16 <alltraps>

80105572 <vector121>:
.globl vector121
vector121:
  pushl $0
80105572:	6a 00                	push   $0x0
  pushl $121
80105574:	6a 79                	push   $0x79
  jmp alltraps
80105576:	e9 9b f7 ff ff       	jmp    80104d16 <alltraps>

8010557b <vector122>:
.globl vector122
vector122:
  pushl $0
8010557b:	6a 00                	push   $0x0
  pushl $122
8010557d:	6a 7a                	push   $0x7a
  jmp alltraps
8010557f:	e9 92 f7 ff ff       	jmp    80104d16 <alltraps>

80105584 <vector123>:
.globl vector123
vector123:
  pushl $0
80105584:	6a 00                	push   $0x0
  pushl $123
80105586:	6a 7b                	push   $0x7b
  jmp alltraps
80105588:	e9 89 f7 ff ff       	jmp    80104d16 <alltraps>

8010558d <vector124>:
.globl vector124
vector124:
  pushl $0
8010558d:	6a 00                	push   $0x0
  pushl $124
8010558f:	6a 7c                	push   $0x7c
  jmp alltraps
80105591:	e9 80 f7 ff ff       	jmp    80104d16 <alltraps>

80105596 <vector125>:
.globl vector125
vector125:
  pushl $0
80105596:	6a 00                	push   $0x0
  pushl $125
80105598:	6a 7d                	push   $0x7d
  jmp alltraps
8010559a:	e9 77 f7 ff ff       	jmp    80104d16 <alltraps>

8010559f <vector126>:
.globl vector126
vector126:
  pushl $0
8010559f:	6a 00                	push   $0x0
  pushl $126
801055a1:	6a 7e                	push   $0x7e
  jmp alltraps
801055a3:	e9 6e f7 ff ff       	jmp    80104d16 <alltraps>

801055a8 <vector127>:
.globl vector127
vector127:
  pushl $0
801055a8:	6a 00                	push   $0x0
  pushl $127
801055aa:	6a 7f                	push   $0x7f
  jmp alltraps
801055ac:	e9 65 f7 ff ff       	jmp    80104d16 <alltraps>

801055b1 <vector128>:
.globl vector128
vector128:
  pushl $0
801055b1:	6a 00                	push   $0x0
  pushl $128
801055b3:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801055b8:	e9 59 f7 ff ff       	jmp    80104d16 <alltraps>

801055bd <vector129>:
.globl vector129
vector129:
  pushl $0
801055bd:	6a 00                	push   $0x0
  pushl $129
801055bf:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801055c4:	e9 4d f7 ff ff       	jmp    80104d16 <alltraps>

801055c9 <vector130>:
.globl vector130
vector130:
  pushl $0
801055c9:	6a 00                	push   $0x0
  pushl $130
801055cb:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801055d0:	e9 41 f7 ff ff       	jmp    80104d16 <alltraps>

801055d5 <vector131>:
.globl vector131
vector131:
  pushl $0
801055d5:	6a 00                	push   $0x0
  pushl $131
801055d7:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801055dc:	e9 35 f7 ff ff       	jmp    80104d16 <alltraps>

801055e1 <vector132>:
.globl vector132
vector132:
  pushl $0
801055e1:	6a 00                	push   $0x0
  pushl $132
801055e3:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801055e8:	e9 29 f7 ff ff       	jmp    80104d16 <alltraps>

801055ed <vector133>:
.globl vector133
vector133:
  pushl $0
801055ed:	6a 00                	push   $0x0
  pushl $133
801055ef:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801055f4:	e9 1d f7 ff ff       	jmp    80104d16 <alltraps>

801055f9 <vector134>:
.globl vector134
vector134:
  pushl $0
801055f9:	6a 00                	push   $0x0
  pushl $134
801055fb:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105600:	e9 11 f7 ff ff       	jmp    80104d16 <alltraps>

80105605 <vector135>:
.globl vector135
vector135:
  pushl $0
80105605:	6a 00                	push   $0x0
  pushl $135
80105607:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010560c:	e9 05 f7 ff ff       	jmp    80104d16 <alltraps>

80105611 <vector136>:
.globl vector136
vector136:
  pushl $0
80105611:	6a 00                	push   $0x0
  pushl $136
80105613:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105618:	e9 f9 f6 ff ff       	jmp    80104d16 <alltraps>

8010561d <vector137>:
.globl vector137
vector137:
  pushl $0
8010561d:	6a 00                	push   $0x0
  pushl $137
8010561f:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105624:	e9 ed f6 ff ff       	jmp    80104d16 <alltraps>

80105629 <vector138>:
.globl vector138
vector138:
  pushl $0
80105629:	6a 00                	push   $0x0
  pushl $138
8010562b:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105630:	e9 e1 f6 ff ff       	jmp    80104d16 <alltraps>

80105635 <vector139>:
.globl vector139
vector139:
  pushl $0
80105635:	6a 00                	push   $0x0
  pushl $139
80105637:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010563c:	e9 d5 f6 ff ff       	jmp    80104d16 <alltraps>

80105641 <vector140>:
.globl vector140
vector140:
  pushl $0
80105641:	6a 00                	push   $0x0
  pushl $140
80105643:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105648:	e9 c9 f6 ff ff       	jmp    80104d16 <alltraps>

8010564d <vector141>:
.globl vector141
vector141:
  pushl $0
8010564d:	6a 00                	push   $0x0
  pushl $141
8010564f:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105654:	e9 bd f6 ff ff       	jmp    80104d16 <alltraps>

80105659 <vector142>:
.globl vector142
vector142:
  pushl $0
80105659:	6a 00                	push   $0x0
  pushl $142
8010565b:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105660:	e9 b1 f6 ff ff       	jmp    80104d16 <alltraps>

80105665 <vector143>:
.globl vector143
vector143:
  pushl $0
80105665:	6a 00                	push   $0x0
  pushl $143
80105667:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010566c:	e9 a5 f6 ff ff       	jmp    80104d16 <alltraps>

80105671 <vector144>:
.globl vector144
vector144:
  pushl $0
80105671:	6a 00                	push   $0x0
  pushl $144
80105673:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105678:	e9 99 f6 ff ff       	jmp    80104d16 <alltraps>

8010567d <vector145>:
.globl vector145
vector145:
  pushl $0
8010567d:	6a 00                	push   $0x0
  pushl $145
8010567f:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105684:	e9 8d f6 ff ff       	jmp    80104d16 <alltraps>

80105689 <vector146>:
.globl vector146
vector146:
  pushl $0
80105689:	6a 00                	push   $0x0
  pushl $146
8010568b:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105690:	e9 81 f6 ff ff       	jmp    80104d16 <alltraps>

80105695 <vector147>:
.globl vector147
vector147:
  pushl $0
80105695:	6a 00                	push   $0x0
  pushl $147
80105697:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010569c:	e9 75 f6 ff ff       	jmp    80104d16 <alltraps>

801056a1 <vector148>:
.globl vector148
vector148:
  pushl $0
801056a1:	6a 00                	push   $0x0
  pushl $148
801056a3:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801056a8:	e9 69 f6 ff ff       	jmp    80104d16 <alltraps>

801056ad <vector149>:
.globl vector149
vector149:
  pushl $0
801056ad:	6a 00                	push   $0x0
  pushl $149
801056af:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801056b4:	e9 5d f6 ff ff       	jmp    80104d16 <alltraps>

801056b9 <vector150>:
.globl vector150
vector150:
  pushl $0
801056b9:	6a 00                	push   $0x0
  pushl $150
801056bb:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801056c0:	e9 51 f6 ff ff       	jmp    80104d16 <alltraps>

801056c5 <vector151>:
.globl vector151
vector151:
  pushl $0
801056c5:	6a 00                	push   $0x0
  pushl $151
801056c7:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801056cc:	e9 45 f6 ff ff       	jmp    80104d16 <alltraps>

801056d1 <vector152>:
.globl vector152
vector152:
  pushl $0
801056d1:	6a 00                	push   $0x0
  pushl $152
801056d3:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801056d8:	e9 39 f6 ff ff       	jmp    80104d16 <alltraps>

801056dd <vector153>:
.globl vector153
vector153:
  pushl $0
801056dd:	6a 00                	push   $0x0
  pushl $153
801056df:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801056e4:	e9 2d f6 ff ff       	jmp    80104d16 <alltraps>

801056e9 <vector154>:
.globl vector154
vector154:
  pushl $0
801056e9:	6a 00                	push   $0x0
  pushl $154
801056eb:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801056f0:	e9 21 f6 ff ff       	jmp    80104d16 <alltraps>

801056f5 <vector155>:
.globl vector155
vector155:
  pushl $0
801056f5:	6a 00                	push   $0x0
  pushl $155
801056f7:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801056fc:	e9 15 f6 ff ff       	jmp    80104d16 <alltraps>

80105701 <vector156>:
.globl vector156
vector156:
  pushl $0
80105701:	6a 00                	push   $0x0
  pushl $156
80105703:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105708:	e9 09 f6 ff ff       	jmp    80104d16 <alltraps>

8010570d <vector157>:
.globl vector157
vector157:
  pushl $0
8010570d:	6a 00                	push   $0x0
  pushl $157
8010570f:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105714:	e9 fd f5 ff ff       	jmp    80104d16 <alltraps>

80105719 <vector158>:
.globl vector158
vector158:
  pushl $0
80105719:	6a 00                	push   $0x0
  pushl $158
8010571b:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105720:	e9 f1 f5 ff ff       	jmp    80104d16 <alltraps>

80105725 <vector159>:
.globl vector159
vector159:
  pushl $0
80105725:	6a 00                	push   $0x0
  pushl $159
80105727:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010572c:	e9 e5 f5 ff ff       	jmp    80104d16 <alltraps>

80105731 <vector160>:
.globl vector160
vector160:
  pushl $0
80105731:	6a 00                	push   $0x0
  pushl $160
80105733:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105738:	e9 d9 f5 ff ff       	jmp    80104d16 <alltraps>

8010573d <vector161>:
.globl vector161
vector161:
  pushl $0
8010573d:	6a 00                	push   $0x0
  pushl $161
8010573f:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105744:	e9 cd f5 ff ff       	jmp    80104d16 <alltraps>

80105749 <vector162>:
.globl vector162
vector162:
  pushl $0
80105749:	6a 00                	push   $0x0
  pushl $162
8010574b:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105750:	e9 c1 f5 ff ff       	jmp    80104d16 <alltraps>

80105755 <vector163>:
.globl vector163
vector163:
  pushl $0
80105755:	6a 00                	push   $0x0
  pushl $163
80105757:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010575c:	e9 b5 f5 ff ff       	jmp    80104d16 <alltraps>

80105761 <vector164>:
.globl vector164
vector164:
  pushl $0
80105761:	6a 00                	push   $0x0
  pushl $164
80105763:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105768:	e9 a9 f5 ff ff       	jmp    80104d16 <alltraps>

8010576d <vector165>:
.globl vector165
vector165:
  pushl $0
8010576d:	6a 00                	push   $0x0
  pushl $165
8010576f:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105774:	e9 9d f5 ff ff       	jmp    80104d16 <alltraps>

80105779 <vector166>:
.globl vector166
vector166:
  pushl $0
80105779:	6a 00                	push   $0x0
  pushl $166
8010577b:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105780:	e9 91 f5 ff ff       	jmp    80104d16 <alltraps>

80105785 <vector167>:
.globl vector167
vector167:
  pushl $0
80105785:	6a 00                	push   $0x0
  pushl $167
80105787:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010578c:	e9 85 f5 ff ff       	jmp    80104d16 <alltraps>

80105791 <vector168>:
.globl vector168
vector168:
  pushl $0
80105791:	6a 00                	push   $0x0
  pushl $168
80105793:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105798:	e9 79 f5 ff ff       	jmp    80104d16 <alltraps>

8010579d <vector169>:
.globl vector169
vector169:
  pushl $0
8010579d:	6a 00                	push   $0x0
  pushl $169
8010579f:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801057a4:	e9 6d f5 ff ff       	jmp    80104d16 <alltraps>

801057a9 <vector170>:
.globl vector170
vector170:
  pushl $0
801057a9:	6a 00                	push   $0x0
  pushl $170
801057ab:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801057b0:	e9 61 f5 ff ff       	jmp    80104d16 <alltraps>

801057b5 <vector171>:
.globl vector171
vector171:
  pushl $0
801057b5:	6a 00                	push   $0x0
  pushl $171
801057b7:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801057bc:	e9 55 f5 ff ff       	jmp    80104d16 <alltraps>

801057c1 <vector172>:
.globl vector172
vector172:
  pushl $0
801057c1:	6a 00                	push   $0x0
  pushl $172
801057c3:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801057c8:	e9 49 f5 ff ff       	jmp    80104d16 <alltraps>

801057cd <vector173>:
.globl vector173
vector173:
  pushl $0
801057cd:	6a 00                	push   $0x0
  pushl $173
801057cf:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801057d4:	e9 3d f5 ff ff       	jmp    80104d16 <alltraps>

801057d9 <vector174>:
.globl vector174
vector174:
  pushl $0
801057d9:	6a 00                	push   $0x0
  pushl $174
801057db:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801057e0:	e9 31 f5 ff ff       	jmp    80104d16 <alltraps>

801057e5 <vector175>:
.globl vector175
vector175:
  pushl $0
801057e5:	6a 00                	push   $0x0
  pushl $175
801057e7:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801057ec:	e9 25 f5 ff ff       	jmp    80104d16 <alltraps>

801057f1 <vector176>:
.globl vector176
vector176:
  pushl $0
801057f1:	6a 00                	push   $0x0
  pushl $176
801057f3:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801057f8:	e9 19 f5 ff ff       	jmp    80104d16 <alltraps>

801057fd <vector177>:
.globl vector177
vector177:
  pushl $0
801057fd:	6a 00                	push   $0x0
  pushl $177
801057ff:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105804:	e9 0d f5 ff ff       	jmp    80104d16 <alltraps>

80105809 <vector178>:
.globl vector178
vector178:
  pushl $0
80105809:	6a 00                	push   $0x0
  pushl $178
8010580b:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105810:	e9 01 f5 ff ff       	jmp    80104d16 <alltraps>

80105815 <vector179>:
.globl vector179
vector179:
  pushl $0
80105815:	6a 00                	push   $0x0
  pushl $179
80105817:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010581c:	e9 f5 f4 ff ff       	jmp    80104d16 <alltraps>

80105821 <vector180>:
.globl vector180
vector180:
  pushl $0
80105821:	6a 00                	push   $0x0
  pushl $180
80105823:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105828:	e9 e9 f4 ff ff       	jmp    80104d16 <alltraps>

8010582d <vector181>:
.globl vector181
vector181:
  pushl $0
8010582d:	6a 00                	push   $0x0
  pushl $181
8010582f:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105834:	e9 dd f4 ff ff       	jmp    80104d16 <alltraps>

80105839 <vector182>:
.globl vector182
vector182:
  pushl $0
80105839:	6a 00                	push   $0x0
  pushl $182
8010583b:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105840:	e9 d1 f4 ff ff       	jmp    80104d16 <alltraps>

80105845 <vector183>:
.globl vector183
vector183:
  pushl $0
80105845:	6a 00                	push   $0x0
  pushl $183
80105847:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010584c:	e9 c5 f4 ff ff       	jmp    80104d16 <alltraps>

80105851 <vector184>:
.globl vector184
vector184:
  pushl $0
80105851:	6a 00                	push   $0x0
  pushl $184
80105853:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105858:	e9 b9 f4 ff ff       	jmp    80104d16 <alltraps>

8010585d <vector185>:
.globl vector185
vector185:
  pushl $0
8010585d:	6a 00                	push   $0x0
  pushl $185
8010585f:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105864:	e9 ad f4 ff ff       	jmp    80104d16 <alltraps>

80105869 <vector186>:
.globl vector186
vector186:
  pushl $0
80105869:	6a 00                	push   $0x0
  pushl $186
8010586b:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105870:	e9 a1 f4 ff ff       	jmp    80104d16 <alltraps>

80105875 <vector187>:
.globl vector187
vector187:
  pushl $0
80105875:	6a 00                	push   $0x0
  pushl $187
80105877:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010587c:	e9 95 f4 ff ff       	jmp    80104d16 <alltraps>

80105881 <vector188>:
.globl vector188
vector188:
  pushl $0
80105881:	6a 00                	push   $0x0
  pushl $188
80105883:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105888:	e9 89 f4 ff ff       	jmp    80104d16 <alltraps>

8010588d <vector189>:
.globl vector189
vector189:
  pushl $0
8010588d:	6a 00                	push   $0x0
  pushl $189
8010588f:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105894:	e9 7d f4 ff ff       	jmp    80104d16 <alltraps>

80105899 <vector190>:
.globl vector190
vector190:
  pushl $0
80105899:	6a 00                	push   $0x0
  pushl $190
8010589b:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801058a0:	e9 71 f4 ff ff       	jmp    80104d16 <alltraps>

801058a5 <vector191>:
.globl vector191
vector191:
  pushl $0
801058a5:	6a 00                	push   $0x0
  pushl $191
801058a7:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801058ac:	e9 65 f4 ff ff       	jmp    80104d16 <alltraps>

801058b1 <vector192>:
.globl vector192
vector192:
  pushl $0
801058b1:	6a 00                	push   $0x0
  pushl $192
801058b3:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801058b8:	e9 59 f4 ff ff       	jmp    80104d16 <alltraps>

801058bd <vector193>:
.globl vector193
vector193:
  pushl $0
801058bd:	6a 00                	push   $0x0
  pushl $193
801058bf:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801058c4:	e9 4d f4 ff ff       	jmp    80104d16 <alltraps>

801058c9 <vector194>:
.globl vector194
vector194:
  pushl $0
801058c9:	6a 00                	push   $0x0
  pushl $194
801058cb:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801058d0:	e9 41 f4 ff ff       	jmp    80104d16 <alltraps>

801058d5 <vector195>:
.globl vector195
vector195:
  pushl $0
801058d5:	6a 00                	push   $0x0
  pushl $195
801058d7:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801058dc:	e9 35 f4 ff ff       	jmp    80104d16 <alltraps>

801058e1 <vector196>:
.globl vector196
vector196:
  pushl $0
801058e1:	6a 00                	push   $0x0
  pushl $196
801058e3:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801058e8:	e9 29 f4 ff ff       	jmp    80104d16 <alltraps>

801058ed <vector197>:
.globl vector197
vector197:
  pushl $0
801058ed:	6a 00                	push   $0x0
  pushl $197
801058ef:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801058f4:	e9 1d f4 ff ff       	jmp    80104d16 <alltraps>

801058f9 <vector198>:
.globl vector198
vector198:
  pushl $0
801058f9:	6a 00                	push   $0x0
  pushl $198
801058fb:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105900:	e9 11 f4 ff ff       	jmp    80104d16 <alltraps>

80105905 <vector199>:
.globl vector199
vector199:
  pushl $0
80105905:	6a 00                	push   $0x0
  pushl $199
80105907:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010590c:	e9 05 f4 ff ff       	jmp    80104d16 <alltraps>

80105911 <vector200>:
.globl vector200
vector200:
  pushl $0
80105911:	6a 00                	push   $0x0
  pushl $200
80105913:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105918:	e9 f9 f3 ff ff       	jmp    80104d16 <alltraps>

8010591d <vector201>:
.globl vector201
vector201:
  pushl $0
8010591d:	6a 00                	push   $0x0
  pushl $201
8010591f:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105924:	e9 ed f3 ff ff       	jmp    80104d16 <alltraps>

80105929 <vector202>:
.globl vector202
vector202:
  pushl $0
80105929:	6a 00                	push   $0x0
  pushl $202
8010592b:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105930:	e9 e1 f3 ff ff       	jmp    80104d16 <alltraps>

80105935 <vector203>:
.globl vector203
vector203:
  pushl $0
80105935:	6a 00                	push   $0x0
  pushl $203
80105937:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010593c:	e9 d5 f3 ff ff       	jmp    80104d16 <alltraps>

80105941 <vector204>:
.globl vector204
vector204:
  pushl $0
80105941:	6a 00                	push   $0x0
  pushl $204
80105943:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105948:	e9 c9 f3 ff ff       	jmp    80104d16 <alltraps>

8010594d <vector205>:
.globl vector205
vector205:
  pushl $0
8010594d:	6a 00                	push   $0x0
  pushl $205
8010594f:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105954:	e9 bd f3 ff ff       	jmp    80104d16 <alltraps>

80105959 <vector206>:
.globl vector206
vector206:
  pushl $0
80105959:	6a 00                	push   $0x0
  pushl $206
8010595b:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105960:	e9 b1 f3 ff ff       	jmp    80104d16 <alltraps>

80105965 <vector207>:
.globl vector207
vector207:
  pushl $0
80105965:	6a 00                	push   $0x0
  pushl $207
80105967:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010596c:	e9 a5 f3 ff ff       	jmp    80104d16 <alltraps>

80105971 <vector208>:
.globl vector208
vector208:
  pushl $0
80105971:	6a 00                	push   $0x0
  pushl $208
80105973:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105978:	e9 99 f3 ff ff       	jmp    80104d16 <alltraps>

8010597d <vector209>:
.globl vector209
vector209:
  pushl $0
8010597d:	6a 00                	push   $0x0
  pushl $209
8010597f:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105984:	e9 8d f3 ff ff       	jmp    80104d16 <alltraps>

80105989 <vector210>:
.globl vector210
vector210:
  pushl $0
80105989:	6a 00                	push   $0x0
  pushl $210
8010598b:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105990:	e9 81 f3 ff ff       	jmp    80104d16 <alltraps>

80105995 <vector211>:
.globl vector211
vector211:
  pushl $0
80105995:	6a 00                	push   $0x0
  pushl $211
80105997:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010599c:	e9 75 f3 ff ff       	jmp    80104d16 <alltraps>

801059a1 <vector212>:
.globl vector212
vector212:
  pushl $0
801059a1:	6a 00                	push   $0x0
  pushl $212
801059a3:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801059a8:	e9 69 f3 ff ff       	jmp    80104d16 <alltraps>

801059ad <vector213>:
.globl vector213
vector213:
  pushl $0
801059ad:	6a 00                	push   $0x0
  pushl $213
801059af:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801059b4:	e9 5d f3 ff ff       	jmp    80104d16 <alltraps>

801059b9 <vector214>:
.globl vector214
vector214:
  pushl $0
801059b9:	6a 00                	push   $0x0
  pushl $214
801059bb:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801059c0:	e9 51 f3 ff ff       	jmp    80104d16 <alltraps>

801059c5 <vector215>:
.globl vector215
vector215:
  pushl $0
801059c5:	6a 00                	push   $0x0
  pushl $215
801059c7:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801059cc:	e9 45 f3 ff ff       	jmp    80104d16 <alltraps>

801059d1 <vector216>:
.globl vector216
vector216:
  pushl $0
801059d1:	6a 00                	push   $0x0
  pushl $216
801059d3:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801059d8:	e9 39 f3 ff ff       	jmp    80104d16 <alltraps>

801059dd <vector217>:
.globl vector217
vector217:
  pushl $0
801059dd:	6a 00                	push   $0x0
  pushl $217
801059df:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801059e4:	e9 2d f3 ff ff       	jmp    80104d16 <alltraps>

801059e9 <vector218>:
.globl vector218
vector218:
  pushl $0
801059e9:	6a 00                	push   $0x0
  pushl $218
801059eb:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801059f0:	e9 21 f3 ff ff       	jmp    80104d16 <alltraps>

801059f5 <vector219>:
.globl vector219
vector219:
  pushl $0
801059f5:	6a 00                	push   $0x0
  pushl $219
801059f7:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801059fc:	e9 15 f3 ff ff       	jmp    80104d16 <alltraps>

80105a01 <vector220>:
.globl vector220
vector220:
  pushl $0
80105a01:	6a 00                	push   $0x0
  pushl $220
80105a03:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105a08:	e9 09 f3 ff ff       	jmp    80104d16 <alltraps>

80105a0d <vector221>:
.globl vector221
vector221:
  pushl $0
80105a0d:	6a 00                	push   $0x0
  pushl $221
80105a0f:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105a14:	e9 fd f2 ff ff       	jmp    80104d16 <alltraps>

80105a19 <vector222>:
.globl vector222
vector222:
  pushl $0
80105a19:	6a 00                	push   $0x0
  pushl $222
80105a1b:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105a20:	e9 f1 f2 ff ff       	jmp    80104d16 <alltraps>

80105a25 <vector223>:
.globl vector223
vector223:
  pushl $0
80105a25:	6a 00                	push   $0x0
  pushl $223
80105a27:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105a2c:	e9 e5 f2 ff ff       	jmp    80104d16 <alltraps>

80105a31 <vector224>:
.globl vector224
vector224:
  pushl $0
80105a31:	6a 00                	push   $0x0
  pushl $224
80105a33:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105a38:	e9 d9 f2 ff ff       	jmp    80104d16 <alltraps>

80105a3d <vector225>:
.globl vector225
vector225:
  pushl $0
80105a3d:	6a 00                	push   $0x0
  pushl $225
80105a3f:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105a44:	e9 cd f2 ff ff       	jmp    80104d16 <alltraps>

80105a49 <vector226>:
.globl vector226
vector226:
  pushl $0
80105a49:	6a 00                	push   $0x0
  pushl $226
80105a4b:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105a50:	e9 c1 f2 ff ff       	jmp    80104d16 <alltraps>

80105a55 <vector227>:
.globl vector227
vector227:
  pushl $0
80105a55:	6a 00                	push   $0x0
  pushl $227
80105a57:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105a5c:	e9 b5 f2 ff ff       	jmp    80104d16 <alltraps>

80105a61 <vector228>:
.globl vector228
vector228:
  pushl $0
80105a61:	6a 00                	push   $0x0
  pushl $228
80105a63:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105a68:	e9 a9 f2 ff ff       	jmp    80104d16 <alltraps>

80105a6d <vector229>:
.globl vector229
vector229:
  pushl $0
80105a6d:	6a 00                	push   $0x0
  pushl $229
80105a6f:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105a74:	e9 9d f2 ff ff       	jmp    80104d16 <alltraps>

80105a79 <vector230>:
.globl vector230
vector230:
  pushl $0
80105a79:	6a 00                	push   $0x0
  pushl $230
80105a7b:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105a80:	e9 91 f2 ff ff       	jmp    80104d16 <alltraps>

80105a85 <vector231>:
.globl vector231
vector231:
  pushl $0
80105a85:	6a 00                	push   $0x0
  pushl $231
80105a87:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105a8c:	e9 85 f2 ff ff       	jmp    80104d16 <alltraps>

80105a91 <vector232>:
.globl vector232
vector232:
  pushl $0
80105a91:	6a 00                	push   $0x0
  pushl $232
80105a93:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105a98:	e9 79 f2 ff ff       	jmp    80104d16 <alltraps>

80105a9d <vector233>:
.globl vector233
vector233:
  pushl $0
80105a9d:	6a 00                	push   $0x0
  pushl $233
80105a9f:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105aa4:	e9 6d f2 ff ff       	jmp    80104d16 <alltraps>

80105aa9 <vector234>:
.globl vector234
vector234:
  pushl $0
80105aa9:	6a 00                	push   $0x0
  pushl $234
80105aab:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105ab0:	e9 61 f2 ff ff       	jmp    80104d16 <alltraps>

80105ab5 <vector235>:
.globl vector235
vector235:
  pushl $0
80105ab5:	6a 00                	push   $0x0
  pushl $235
80105ab7:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105abc:	e9 55 f2 ff ff       	jmp    80104d16 <alltraps>

80105ac1 <vector236>:
.globl vector236
vector236:
  pushl $0
80105ac1:	6a 00                	push   $0x0
  pushl $236
80105ac3:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105ac8:	e9 49 f2 ff ff       	jmp    80104d16 <alltraps>

80105acd <vector237>:
.globl vector237
vector237:
  pushl $0
80105acd:	6a 00                	push   $0x0
  pushl $237
80105acf:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105ad4:	e9 3d f2 ff ff       	jmp    80104d16 <alltraps>

80105ad9 <vector238>:
.globl vector238
vector238:
  pushl $0
80105ad9:	6a 00                	push   $0x0
  pushl $238
80105adb:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105ae0:	e9 31 f2 ff ff       	jmp    80104d16 <alltraps>

80105ae5 <vector239>:
.globl vector239
vector239:
  pushl $0
80105ae5:	6a 00                	push   $0x0
  pushl $239
80105ae7:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105aec:	e9 25 f2 ff ff       	jmp    80104d16 <alltraps>

80105af1 <vector240>:
.globl vector240
vector240:
  pushl $0
80105af1:	6a 00                	push   $0x0
  pushl $240
80105af3:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105af8:	e9 19 f2 ff ff       	jmp    80104d16 <alltraps>

80105afd <vector241>:
.globl vector241
vector241:
  pushl $0
80105afd:	6a 00                	push   $0x0
  pushl $241
80105aff:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105b04:	e9 0d f2 ff ff       	jmp    80104d16 <alltraps>

80105b09 <vector242>:
.globl vector242
vector242:
  pushl $0
80105b09:	6a 00                	push   $0x0
  pushl $242
80105b0b:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105b10:	e9 01 f2 ff ff       	jmp    80104d16 <alltraps>

80105b15 <vector243>:
.globl vector243
vector243:
  pushl $0
80105b15:	6a 00                	push   $0x0
  pushl $243
80105b17:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105b1c:	e9 f5 f1 ff ff       	jmp    80104d16 <alltraps>

80105b21 <vector244>:
.globl vector244
vector244:
  pushl $0
80105b21:	6a 00                	push   $0x0
  pushl $244
80105b23:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105b28:	e9 e9 f1 ff ff       	jmp    80104d16 <alltraps>

80105b2d <vector245>:
.globl vector245
vector245:
  pushl $0
80105b2d:	6a 00                	push   $0x0
  pushl $245
80105b2f:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105b34:	e9 dd f1 ff ff       	jmp    80104d16 <alltraps>

80105b39 <vector246>:
.globl vector246
vector246:
  pushl $0
80105b39:	6a 00                	push   $0x0
  pushl $246
80105b3b:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105b40:	e9 d1 f1 ff ff       	jmp    80104d16 <alltraps>

80105b45 <vector247>:
.globl vector247
vector247:
  pushl $0
80105b45:	6a 00                	push   $0x0
  pushl $247
80105b47:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105b4c:	e9 c5 f1 ff ff       	jmp    80104d16 <alltraps>

80105b51 <vector248>:
.globl vector248
vector248:
  pushl $0
80105b51:	6a 00                	push   $0x0
  pushl $248
80105b53:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105b58:	e9 b9 f1 ff ff       	jmp    80104d16 <alltraps>

80105b5d <vector249>:
.globl vector249
vector249:
  pushl $0
80105b5d:	6a 00                	push   $0x0
  pushl $249
80105b5f:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105b64:	e9 ad f1 ff ff       	jmp    80104d16 <alltraps>

80105b69 <vector250>:
.globl vector250
vector250:
  pushl $0
80105b69:	6a 00                	push   $0x0
  pushl $250
80105b6b:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105b70:	e9 a1 f1 ff ff       	jmp    80104d16 <alltraps>

80105b75 <vector251>:
.globl vector251
vector251:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $251
80105b77:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105b7c:	e9 95 f1 ff ff       	jmp    80104d16 <alltraps>

80105b81 <vector252>:
.globl vector252
vector252:
  pushl $0
80105b81:	6a 00                	push   $0x0
  pushl $252
80105b83:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105b88:	e9 89 f1 ff ff       	jmp    80104d16 <alltraps>

80105b8d <vector253>:
.globl vector253
vector253:
  pushl $0
80105b8d:	6a 00                	push   $0x0
  pushl $253
80105b8f:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105b94:	e9 7d f1 ff ff       	jmp    80104d16 <alltraps>

80105b99 <vector254>:
.globl vector254
vector254:
  pushl $0
80105b99:	6a 00                	push   $0x0
  pushl $254
80105b9b:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105ba0:	e9 71 f1 ff ff       	jmp    80104d16 <alltraps>

80105ba5 <vector255>:
.globl vector255
vector255:
  pushl $0
80105ba5:	6a 00                	push   $0x0
  pushl $255
80105ba7:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105bac:	e9 65 f1 ff ff       	jmp    80104d16 <alltraps>

80105bb1 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105bb1:	55                   	push   %ebp
80105bb2:	89 e5                	mov    %esp,%ebp
80105bb4:	57                   	push   %edi
80105bb5:	56                   	push   %esi
80105bb6:	53                   	push   %ebx
80105bb7:	83 ec 0c             	sub    $0xc,%esp
80105bba:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105bbc:	c1 ea 16             	shr    $0x16,%edx
80105bbf:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105bc2:	8b 1f                	mov    (%edi),%ebx
80105bc4:	f6 c3 01             	test   $0x1,%bl
80105bc7:	74 22                	je     80105beb <walkpgdir+0x3a>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105bc9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105bcf:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105bd5:	c1 ee 0c             	shr    $0xc,%esi
80105bd8:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
80105bde:	8d 1c b3             	lea    (%ebx,%esi,4),%ebx
}
80105be1:	89 d8                	mov    %ebx,%eax
80105be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be6:	5b                   	pop    %ebx
80105be7:	5e                   	pop    %esi
80105be8:	5f                   	pop    %edi
80105be9:	5d                   	pop    %ebp
80105bea:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105beb:	85 c9                	test   %ecx,%ecx
80105bed:	74 2b                	je     80105c1a <walkpgdir+0x69>
80105bef:	e8 fa c4 ff ff       	call   801020ee <kalloc>
80105bf4:	89 c3                	mov    %eax,%ebx
80105bf6:	85 c0                	test   %eax,%eax
80105bf8:	74 e7                	je     80105be1 <walkpgdir+0x30>
    memset(pgtab, 0, PGSIZE);
80105bfa:	83 ec 04             	sub    $0x4,%esp
80105bfd:	68 00 10 00 00       	push   $0x1000
80105c02:	6a 00                	push   $0x0
80105c04:	50                   	push   %eax
80105c05:	e8 8a e0 ff ff       	call   80103c94 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105c0a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105c10:	83 c8 07             	or     $0x7,%eax
80105c13:	89 07                	mov    %eax,(%edi)
80105c15:	83 c4 10             	add    $0x10,%esp
80105c18:	eb bb                	jmp    80105bd5 <walkpgdir+0x24>
      return 0;
80105c1a:	bb 00 00 00 00       	mov    $0x0,%ebx
80105c1f:	eb c0                	jmp    80105be1 <walkpgdir+0x30>

80105c21 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105c21:	55                   	push   %ebp
80105c22:	89 e5                	mov    %esp,%ebp
80105c24:	57                   	push   %edi
80105c25:	56                   	push   %esi
80105c26:	53                   	push   %ebx
80105c27:	83 ec 1c             	sub    $0x1c,%esp
80105c2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105c2d:	8b 75 08             	mov    0x8(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105c30:	89 d3                	mov    %edx,%ebx
80105c32:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105c38:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
80105c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105c42:	b9 01 00 00 00       	mov    $0x1,%ecx
80105c47:	89 da                	mov    %ebx,%edx
80105c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c4c:	e8 60 ff ff ff       	call   80105bb1 <walkpgdir>
80105c51:	85 c0                	test   %eax,%eax
80105c53:	74 2e                	je     80105c83 <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
80105c55:	f6 00 01             	testb  $0x1,(%eax)
80105c58:	75 1c                	jne    80105c76 <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
80105c5a:	89 f2                	mov    %esi,%edx
80105c5c:	0b 55 0c             	or     0xc(%ebp),%edx
80105c5f:	83 ca 01             	or     $0x1,%edx
80105c62:	89 10                	mov    %edx,(%eax)
    if(a == last)
80105c64:	39 fb                	cmp    %edi,%ebx
80105c66:	74 28                	je     80105c90 <mappages+0x6f>
      break;
    a += PGSIZE;
80105c68:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80105c6e:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105c74:	eb cc                	jmp    80105c42 <mappages+0x21>
      panic("remap");
80105c76:	83 ec 0c             	sub    $0xc,%esp
80105c79:	68 08 6d 10 80       	push   $0x80106d08
80105c7e:	e8 c5 a6 ff ff       	call   80100348 <panic>
      return -1;
80105c83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80105c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c8b:	5b                   	pop    %ebx
80105c8c:	5e                   	pop    %esi
80105c8d:	5f                   	pop    %edi
80105c8e:	5d                   	pop    %ebp
80105c8f:	c3                   	ret    
  return 0;
80105c90:	b8 00 00 00 00       	mov    $0x0,%eax
80105c95:	eb f1                	jmp    80105c88 <mappages+0x67>

80105c97 <seginit>:
{
80105c97:	55                   	push   %ebp
80105c98:	89 e5                	mov    %esp,%ebp
80105c9a:	53                   	push   %ebx
80105c9b:	83 ec 14             	sub    $0x14,%esp
  c = &cpus[cpuid()];
80105c9e:	e8 83 d5 ff ff       	call   80103226 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105ca3:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80105ca9:	66 c7 80 58 38 11 80 	movw   $0xffff,-0x7feec7a8(%eax)
80105cb0:	ff ff 
80105cb2:	66 c7 80 5a 38 11 80 	movw   $0x0,-0x7feec7a6(%eax)
80105cb9:	00 00 
80105cbb:	c6 80 5c 38 11 80 00 	movb   $0x0,-0x7feec7a4(%eax)
80105cc2:	0f b6 88 5d 38 11 80 	movzbl -0x7feec7a3(%eax),%ecx
80105cc9:	83 e1 f0             	and    $0xfffffff0,%ecx
80105ccc:	83 c9 1a             	or     $0x1a,%ecx
80105ccf:	83 e1 9f             	and    $0xffffff9f,%ecx
80105cd2:	83 c9 80             	or     $0xffffff80,%ecx
80105cd5:	88 88 5d 38 11 80    	mov    %cl,-0x7feec7a3(%eax)
80105cdb:	0f b6 88 5e 38 11 80 	movzbl -0x7feec7a2(%eax),%ecx
80105ce2:	83 c9 0f             	or     $0xf,%ecx
80105ce5:	83 e1 cf             	and    $0xffffffcf,%ecx
80105ce8:	83 c9 c0             	or     $0xffffffc0,%ecx
80105ceb:	88 88 5e 38 11 80    	mov    %cl,-0x7feec7a2(%eax)
80105cf1:	c6 80 5f 38 11 80 00 	movb   $0x0,-0x7feec7a1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105cf8:	66 c7 80 60 38 11 80 	movw   $0xffff,-0x7feec7a0(%eax)
80105cff:	ff ff 
80105d01:	66 c7 80 62 38 11 80 	movw   $0x0,-0x7feec79e(%eax)
80105d08:	00 00 
80105d0a:	c6 80 64 38 11 80 00 	movb   $0x0,-0x7feec79c(%eax)
80105d11:	0f b6 88 65 38 11 80 	movzbl -0x7feec79b(%eax),%ecx
80105d18:	83 e1 f0             	and    $0xfffffff0,%ecx
80105d1b:	83 c9 12             	or     $0x12,%ecx
80105d1e:	83 e1 9f             	and    $0xffffff9f,%ecx
80105d21:	83 c9 80             	or     $0xffffff80,%ecx
80105d24:	88 88 65 38 11 80    	mov    %cl,-0x7feec79b(%eax)
80105d2a:	0f b6 88 66 38 11 80 	movzbl -0x7feec79a(%eax),%ecx
80105d31:	83 c9 0f             	or     $0xf,%ecx
80105d34:	83 e1 cf             	and    $0xffffffcf,%ecx
80105d37:	83 c9 c0             	or     $0xffffffc0,%ecx
80105d3a:	88 88 66 38 11 80    	mov    %cl,-0x7feec79a(%eax)
80105d40:	c6 80 67 38 11 80 00 	movb   $0x0,-0x7feec799(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105d47:	66 c7 80 68 38 11 80 	movw   $0xffff,-0x7feec798(%eax)
80105d4e:	ff ff 
80105d50:	66 c7 80 6a 38 11 80 	movw   $0x0,-0x7feec796(%eax)
80105d57:	00 00 
80105d59:	c6 80 6c 38 11 80 00 	movb   $0x0,-0x7feec794(%eax)
80105d60:	c6 80 6d 38 11 80 fa 	movb   $0xfa,-0x7feec793(%eax)
80105d67:	0f b6 88 6e 38 11 80 	movzbl -0x7feec792(%eax),%ecx
80105d6e:	83 c9 0f             	or     $0xf,%ecx
80105d71:	83 e1 cf             	and    $0xffffffcf,%ecx
80105d74:	83 c9 c0             	or     $0xffffffc0,%ecx
80105d77:	88 88 6e 38 11 80    	mov    %cl,-0x7feec792(%eax)
80105d7d:	c6 80 6f 38 11 80 00 	movb   $0x0,-0x7feec791(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80105d84:	66 c7 80 70 38 11 80 	movw   $0xffff,-0x7feec790(%eax)
80105d8b:	ff ff 
80105d8d:	66 c7 80 72 38 11 80 	movw   $0x0,-0x7feec78e(%eax)
80105d94:	00 00 
80105d96:	c6 80 74 38 11 80 00 	movb   $0x0,-0x7feec78c(%eax)
80105d9d:	c6 80 75 38 11 80 f2 	movb   $0xf2,-0x7feec78b(%eax)
80105da4:	0f b6 88 76 38 11 80 	movzbl -0x7feec78a(%eax),%ecx
80105dab:	83 c9 0f             	or     $0xf,%ecx
80105dae:	83 e1 cf             	and    $0xffffffcf,%ecx
80105db1:	83 c9 c0             	or     $0xffffffc0,%ecx
80105db4:	88 88 76 38 11 80    	mov    %cl,-0x7feec78a(%eax)
80105dba:	c6 80 77 38 11 80 00 	movb   $0x0,-0x7feec789(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80105dc1:	05 50 38 11 80       	add    $0x80113850,%eax
  pd[0] = size-1;
80105dc6:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80105dcc:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80105dd0:	c1 e8 10             	shr    $0x10,%eax
80105dd3:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80105dd7:	8d 45 f2             	lea    -0xe(%ebp),%eax
80105dda:	0f 01 10             	lgdtl  (%eax)
}
80105ddd:	83 c4 14             	add    $0x14,%esp
80105de0:	5b                   	pop    %ebx
80105de1:	5d                   	pop    %ebp
80105de2:	c3                   	ret    

80105de3 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80105de3:	55                   	push   %ebp
80105de4:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80105de6:	a1 84 45 11 80       	mov    0x80114584,%eax
80105deb:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105df0:	0f 22 d8             	mov    %eax,%cr3
}
80105df3:	5d                   	pop    %ebp
80105df4:	c3                   	ret    

80105df5 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80105df5:	55                   	push   %ebp
80105df6:	89 e5                	mov    %esp,%ebp
80105df8:	57                   	push   %edi
80105df9:	56                   	push   %esi
80105dfa:	53                   	push   %ebx
80105dfb:	83 ec 1c             	sub    $0x1c,%esp
80105dfe:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80105e01:	85 f6                	test   %esi,%esi
80105e03:	0f 84 dd 00 00 00    	je     80105ee6 <switchuvm+0xf1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80105e09:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80105e0d:	0f 84 e0 00 00 00    	je     80105ef3 <switchuvm+0xfe>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80105e13:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80105e17:	0f 84 e3 00 00 00    	je     80105f00 <switchuvm+0x10b>
    panic("switchuvm: no pgdir");

  pushcli();
80105e1d:	e8 e9 dc ff ff       	call   80103b0b <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80105e22:	e8 a3 d3 ff ff       	call   801031ca <mycpu>
80105e27:	89 c3                	mov    %eax,%ebx
80105e29:	e8 9c d3 ff ff       	call   801031ca <mycpu>
80105e2e:	8d 78 08             	lea    0x8(%eax),%edi
80105e31:	e8 94 d3 ff ff       	call   801031ca <mycpu>
80105e36:	83 c0 08             	add    $0x8,%eax
80105e39:	c1 e8 10             	shr    $0x10,%eax
80105e3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105e3f:	e8 86 d3 ff ff       	call   801031ca <mycpu>
80105e44:	83 c0 08             	add    $0x8,%eax
80105e47:	c1 e8 18             	shr    $0x18,%eax
80105e4a:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80105e51:	67 00 
80105e53:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80105e5a:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
80105e5e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80105e64:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80105e6b:	83 e2 f0             	and    $0xfffffff0,%edx
80105e6e:	83 ca 19             	or     $0x19,%edx
80105e71:	83 e2 9f             	and    $0xffffff9f,%edx
80105e74:	83 ca 80             	or     $0xffffff80,%edx
80105e77:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80105e7d:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80105e84:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80105e8a:	e8 3b d3 ff ff       	call   801031ca <mycpu>
80105e8f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80105e96:	83 e2 ef             	and    $0xffffffef,%edx
80105e99:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80105e9f:	e8 26 d3 ff ff       	call   801031ca <mycpu>
80105ea4:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80105eaa:	8b 5e 08             	mov    0x8(%esi),%ebx
80105ead:	e8 18 d3 ff ff       	call   801031ca <mycpu>
80105eb2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80105eb8:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80105ebb:	e8 0a d3 ff ff       	call   801031ca <mycpu>
80105ec0:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80105ec6:	b8 28 00 00 00       	mov    $0x28,%eax
80105ecb:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80105ece:	8b 46 04             	mov    0x4(%esi),%eax
80105ed1:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105ed6:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80105ed9:	e8 6a dc ff ff       	call   80103b48 <popcli>
}
80105ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ee1:	5b                   	pop    %ebx
80105ee2:	5e                   	pop    %esi
80105ee3:	5f                   	pop    %edi
80105ee4:	5d                   	pop    %ebp
80105ee5:	c3                   	ret    
    panic("switchuvm: no process");
80105ee6:	83 ec 0c             	sub    $0xc,%esp
80105ee9:	68 0e 6d 10 80       	push   $0x80106d0e
80105eee:	e8 55 a4 ff ff       	call   80100348 <panic>
    panic("switchuvm: no kstack");
80105ef3:	83 ec 0c             	sub    $0xc,%esp
80105ef6:	68 24 6d 10 80       	push   $0x80106d24
80105efb:	e8 48 a4 ff ff       	call   80100348 <panic>
    panic("switchuvm: no pgdir");
80105f00:	83 ec 0c             	sub    $0xc,%esp
80105f03:	68 39 6d 10 80       	push   $0x80106d39
80105f08:	e8 3b a4 ff ff       	call   80100348 <panic>

80105f0d <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80105f0d:	55                   	push   %ebp
80105f0e:	89 e5                	mov    %esp,%ebp
80105f10:	56                   	push   %esi
80105f11:	53                   	push   %ebx
80105f12:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80105f15:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80105f1b:	77 4c                	ja     80105f69 <inituvm+0x5c>
    panic("inituvm: more than a page");
  mem = kalloc();
80105f1d:	e8 cc c1 ff ff       	call   801020ee <kalloc>
80105f22:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80105f24:	83 ec 04             	sub    $0x4,%esp
80105f27:	68 00 10 00 00       	push   $0x1000
80105f2c:	6a 00                	push   $0x0
80105f2e:	50                   	push   %eax
80105f2f:	e8 60 dd ff ff       	call   80103c94 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80105f34:	83 c4 08             	add    $0x8,%esp
80105f37:	6a 06                	push   $0x6
80105f39:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105f3f:	50                   	push   %eax
80105f40:	b9 00 10 00 00       	mov    $0x1000,%ecx
80105f45:	ba 00 00 00 00       	mov    $0x0,%edx
80105f4a:	8b 45 08             	mov    0x8(%ebp),%eax
80105f4d:	e8 cf fc ff ff       	call   80105c21 <mappages>
  memmove(mem, init, sz);
80105f52:	83 c4 0c             	add    $0xc,%esp
80105f55:	56                   	push   %esi
80105f56:	ff 75 0c             	pushl  0xc(%ebp)
80105f59:	53                   	push   %ebx
80105f5a:	e8 b0 dd ff ff       	call   80103d0f <memmove>
}
80105f5f:	83 c4 10             	add    $0x10,%esp
80105f62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f65:	5b                   	pop    %ebx
80105f66:	5e                   	pop    %esi
80105f67:	5d                   	pop    %ebp
80105f68:	c3                   	ret    
    panic("inituvm: more than a page");
80105f69:	83 ec 0c             	sub    $0xc,%esp
80105f6c:	68 4d 6d 10 80       	push   $0x80106d4d
80105f71:	e8 d2 a3 ff ff       	call   80100348 <panic>

80105f76 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80105f76:	55                   	push   %ebp
80105f77:	89 e5                	mov    %esp,%ebp
80105f79:	57                   	push   %edi
80105f7a:	56                   	push   %esi
80105f7b:	53                   	push   %ebx
80105f7c:	83 ec 0c             	sub    $0xc,%esp
80105f7f:	8b 7d 18             	mov    0x18(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80105f82:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80105f89:	75 07                	jne    80105f92 <loaduvm+0x1c>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80105f8b:	bb 00 00 00 00       	mov    $0x0,%ebx
80105f90:	eb 3c                	jmp    80105fce <loaduvm+0x58>
    panic("loaduvm: addr must be page aligned");
80105f92:	83 ec 0c             	sub    $0xc,%esp
80105f95:	68 08 6e 10 80       	push   $0x80106e08
80105f9a:	e8 a9 a3 ff ff       	call   80100348 <panic>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80105f9f:	83 ec 0c             	sub    $0xc,%esp
80105fa2:	68 67 6d 10 80       	push   $0x80106d67
80105fa7:	e8 9c a3 ff ff       	call   80100348 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80105fac:	05 00 00 00 80       	add    $0x80000000,%eax
80105fb1:	56                   	push   %esi
80105fb2:	89 da                	mov    %ebx,%edx
80105fb4:	03 55 14             	add    0x14(%ebp),%edx
80105fb7:	52                   	push   %edx
80105fb8:	50                   	push   %eax
80105fb9:	ff 75 10             	pushl  0x10(%ebp)
80105fbc:	e8 e5 b7 ff ff       	call   801017a6 <readi>
80105fc1:	83 c4 10             	add    $0x10,%esp
80105fc4:	39 f0                	cmp    %esi,%eax
80105fc6:	75 47                	jne    8010600f <loaduvm+0x99>
  for(i = 0; i < sz; i += PGSIZE){
80105fc8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80105fce:	39 fb                	cmp    %edi,%ebx
80105fd0:	73 30                	jae    80106002 <loaduvm+0x8c>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80105fd2:	89 da                	mov    %ebx,%edx
80105fd4:	03 55 0c             	add    0xc(%ebp),%edx
80105fd7:	b9 00 00 00 00       	mov    $0x0,%ecx
80105fdc:	8b 45 08             	mov    0x8(%ebp),%eax
80105fdf:	e8 cd fb ff ff       	call   80105bb1 <walkpgdir>
80105fe4:	85 c0                	test   %eax,%eax
80105fe6:	74 b7                	je     80105f9f <loaduvm+0x29>
    pa = PTE_ADDR(*pte);
80105fe8:	8b 00                	mov    (%eax),%eax
80105fea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80105fef:	89 fe                	mov    %edi,%esi
80105ff1:	29 de                	sub    %ebx,%esi
80105ff3:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80105ff9:	76 b1                	jbe    80105fac <loaduvm+0x36>
      n = PGSIZE;
80105ffb:	be 00 10 00 00       	mov    $0x1000,%esi
80106000:	eb aa                	jmp    80105fac <loaduvm+0x36>
      return -1;
  }
  return 0;
80106002:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106007:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010600a:	5b                   	pop    %ebx
8010600b:	5e                   	pop    %esi
8010600c:	5f                   	pop    %edi
8010600d:	5d                   	pop    %ebp
8010600e:	c3                   	ret    
      return -1;
8010600f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106014:	eb f1                	jmp    80106007 <loaduvm+0x91>

80106016 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106016:	55                   	push   %ebp
80106017:	89 e5                	mov    %esp,%ebp
80106019:	57                   	push   %edi
8010601a:	56                   	push   %esi
8010601b:	53                   	push   %ebx
8010601c:	83 ec 0c             	sub    $0xc,%esp
8010601f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106022:	39 7d 10             	cmp    %edi,0x10(%ebp)
80106025:	73 11                	jae    80106038 <deallocuvm+0x22>
    return oldsz;

  a = PGROUNDUP(newsz);
80106027:	8b 45 10             	mov    0x10(%ebp),%eax
8010602a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106030:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106036:	eb 19                	jmp    80106051 <deallocuvm+0x3b>
    return oldsz;
80106038:	89 f8                	mov    %edi,%eax
8010603a:	eb 64                	jmp    801060a0 <deallocuvm+0x8a>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010603c:	c1 eb 16             	shr    $0x16,%ebx
8010603f:	83 c3 01             	add    $0x1,%ebx
80106042:	c1 e3 16             	shl    $0x16,%ebx
80106045:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010604b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106051:	39 fb                	cmp    %edi,%ebx
80106053:	73 48                	jae    8010609d <deallocuvm+0x87>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106055:	b9 00 00 00 00       	mov    $0x0,%ecx
8010605a:	89 da                	mov    %ebx,%edx
8010605c:	8b 45 08             	mov    0x8(%ebp),%eax
8010605f:	e8 4d fb ff ff       	call   80105bb1 <walkpgdir>
80106064:	89 c6                	mov    %eax,%esi
    if(!pte)
80106066:	85 c0                	test   %eax,%eax
80106068:	74 d2                	je     8010603c <deallocuvm+0x26>
    else if((*pte & PTE_P) != 0){
8010606a:	8b 00                	mov    (%eax),%eax
8010606c:	a8 01                	test   $0x1,%al
8010606e:	74 db                	je     8010604b <deallocuvm+0x35>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106070:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106075:	74 19                	je     80106090 <deallocuvm+0x7a>
        panic("kfree");
      char *v = P2V(pa);
80106077:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010607c:	83 ec 0c             	sub    $0xc,%esp
8010607f:	50                   	push   %eax
80106080:	e8 52 bf ff ff       	call   80101fd7 <kfree>
      *pte = 0;
80106085:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010608b:	83 c4 10             	add    $0x10,%esp
8010608e:	eb bb                	jmp    8010604b <deallocuvm+0x35>
        panic("kfree");
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	68 ce 66 10 80       	push   $0x801066ce
80106098:	e8 ab a2 ff ff       	call   80100348 <panic>
    }
  }
  return newsz;
8010609d:	8b 45 10             	mov    0x10(%ebp),%eax
}
801060a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060a3:	5b                   	pop    %ebx
801060a4:	5e                   	pop    %esi
801060a5:	5f                   	pop    %edi
801060a6:	5d                   	pop    %ebp
801060a7:	c3                   	ret    

801060a8 <allocuvm>:
{
801060a8:	55                   	push   %ebp
801060a9:	89 e5                	mov    %esp,%ebp
801060ab:	57                   	push   %edi
801060ac:	56                   	push   %esi
801060ad:	53                   	push   %ebx
801060ae:	83 ec 1c             	sub    $0x1c,%esp
801060b1:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
801060b4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801060b7:	85 ff                	test   %edi,%edi
801060b9:	0f 88 c1 00 00 00    	js     80106180 <allocuvm+0xd8>
  if(newsz < oldsz)
801060bf:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801060c2:	72 5c                	jb     80106120 <allocuvm+0x78>
  a = PGROUNDUP(oldsz);
801060c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801060c7:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801060cd:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801060d3:	39 fb                	cmp    %edi,%ebx
801060d5:	0f 83 ac 00 00 00    	jae    80106187 <allocuvm+0xdf>
    mem = kalloc();
801060db:	e8 0e c0 ff ff       	call   801020ee <kalloc>
801060e0:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801060e2:	85 c0                	test   %eax,%eax
801060e4:	74 42                	je     80106128 <allocuvm+0x80>
    memset(mem, 0, PGSIZE);
801060e6:	83 ec 04             	sub    $0x4,%esp
801060e9:	68 00 10 00 00       	push   $0x1000
801060ee:	6a 00                	push   $0x0
801060f0:	50                   	push   %eax
801060f1:	e8 9e db ff ff       	call   80103c94 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801060f6:	83 c4 08             	add    $0x8,%esp
801060f9:	6a 06                	push   $0x6
801060fb:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106101:	50                   	push   %eax
80106102:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106107:	89 da                	mov    %ebx,%edx
80106109:	8b 45 08             	mov    0x8(%ebp),%eax
8010610c:	e8 10 fb ff ff       	call   80105c21 <mappages>
80106111:	83 c4 10             	add    $0x10,%esp
80106114:	85 c0                	test   %eax,%eax
80106116:	78 38                	js     80106150 <allocuvm+0xa8>
  for(; a < newsz; a += PGSIZE){
80106118:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010611e:	eb b3                	jmp    801060d3 <allocuvm+0x2b>
    return oldsz;
80106120:	8b 45 0c             	mov    0xc(%ebp),%eax
80106123:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106126:	eb 5f                	jmp    80106187 <allocuvm+0xdf>
      cprintf("allocuvm out of memory\n");
80106128:	83 ec 0c             	sub    $0xc,%esp
8010612b:	68 85 6d 10 80       	push   $0x80106d85
80106130:	e8 d6 a4 ff ff       	call   8010060b <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106135:	83 c4 0c             	add    $0xc,%esp
80106138:	ff 75 0c             	pushl  0xc(%ebp)
8010613b:	57                   	push   %edi
8010613c:	ff 75 08             	pushl  0x8(%ebp)
8010613f:	e8 d2 fe ff ff       	call   80106016 <deallocuvm>
      return 0;
80106144:	83 c4 10             	add    $0x10,%esp
80106147:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010614e:	eb 37                	jmp    80106187 <allocuvm+0xdf>
      cprintf("allocuvm out of memory (2)\n");
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	68 9d 6d 10 80       	push   $0x80106d9d
80106158:	e8 ae a4 ff ff       	call   8010060b <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010615d:	83 c4 0c             	add    $0xc,%esp
80106160:	ff 75 0c             	pushl  0xc(%ebp)
80106163:	57                   	push   %edi
80106164:	ff 75 08             	pushl  0x8(%ebp)
80106167:	e8 aa fe ff ff       	call   80106016 <deallocuvm>
      kfree(mem);
8010616c:	89 34 24             	mov    %esi,(%esp)
8010616f:	e8 63 be ff ff       	call   80101fd7 <kfree>
      return 0;
80106174:	83 c4 10             	add    $0x10,%esp
80106177:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010617e:	eb 07                	jmp    80106187 <allocuvm+0xdf>
    return 0;
80106180:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106187:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010618a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010618d:	5b                   	pop    %ebx
8010618e:	5e                   	pop    %esi
8010618f:	5f                   	pop    %edi
80106190:	5d                   	pop    %ebp
80106191:	c3                   	ret    

80106192 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106192:	55                   	push   %ebp
80106193:	89 e5                	mov    %esp,%ebp
80106195:	56                   	push   %esi
80106196:	53                   	push   %ebx
80106197:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010619a:	85 f6                	test   %esi,%esi
8010619c:	74 1a                	je     801061b8 <freevm+0x26>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
8010619e:	83 ec 04             	sub    $0x4,%esp
801061a1:	6a 00                	push   $0x0
801061a3:	68 00 00 00 80       	push   $0x80000000
801061a8:	56                   	push   %esi
801061a9:	e8 68 fe ff ff       	call   80106016 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801061ae:	83 c4 10             	add    $0x10,%esp
801061b1:	bb 00 00 00 00       	mov    $0x0,%ebx
801061b6:	eb 10                	jmp    801061c8 <freevm+0x36>
    panic("freevm: no pgdir");
801061b8:	83 ec 0c             	sub    $0xc,%esp
801061bb:	68 b9 6d 10 80       	push   $0x80106db9
801061c0:	e8 83 a1 ff ff       	call   80100348 <panic>
  for(i = 0; i < NPDENTRIES; i++){
801061c5:	83 c3 01             	add    $0x1,%ebx
801061c8:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
801061ce:	77 1f                	ja     801061ef <freevm+0x5d>
    if(pgdir[i] & PTE_P){
801061d0:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
801061d3:	a8 01                	test   $0x1,%al
801061d5:	74 ee                	je     801061c5 <freevm+0x33>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801061d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801061dc:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801061e1:	83 ec 0c             	sub    $0xc,%esp
801061e4:	50                   	push   %eax
801061e5:	e8 ed bd ff ff       	call   80101fd7 <kfree>
801061ea:	83 c4 10             	add    $0x10,%esp
801061ed:	eb d6                	jmp    801061c5 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
801061ef:	83 ec 0c             	sub    $0xc,%esp
801061f2:	56                   	push   %esi
801061f3:	e8 df bd ff ff       	call   80101fd7 <kfree>
}
801061f8:	83 c4 10             	add    $0x10,%esp
801061fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061fe:	5b                   	pop    %ebx
801061ff:	5e                   	pop    %esi
80106200:	5d                   	pop    %ebp
80106201:	c3                   	ret    

80106202 <setupkvm>:
{
80106202:	55                   	push   %ebp
80106203:	89 e5                	mov    %esp,%ebp
80106205:	56                   	push   %esi
80106206:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106207:	e8 e2 be ff ff       	call   801020ee <kalloc>
8010620c:	89 c6                	mov    %eax,%esi
8010620e:	85 c0                	test   %eax,%eax
80106210:	74 55                	je     80106267 <setupkvm+0x65>
  memset(pgdir, 0, PGSIZE);
80106212:	83 ec 04             	sub    $0x4,%esp
80106215:	68 00 10 00 00       	push   $0x1000
8010621a:	6a 00                	push   $0x0
8010621c:	50                   	push   %eax
8010621d:	e8 72 da ff ff       	call   80103c94 <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106222:	83 c4 10             	add    $0x10,%esp
80106225:	bb 20 94 10 80       	mov    $0x80109420,%ebx
8010622a:	81 fb 60 94 10 80    	cmp    $0x80109460,%ebx
80106230:	73 35                	jae    80106267 <setupkvm+0x65>
                (uint)k->phys_start, k->perm) < 0) {
80106232:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106235:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106238:	29 c1                	sub    %eax,%ecx
8010623a:	83 ec 08             	sub    $0x8,%esp
8010623d:	ff 73 0c             	pushl  0xc(%ebx)
80106240:	50                   	push   %eax
80106241:	8b 13                	mov    (%ebx),%edx
80106243:	89 f0                	mov    %esi,%eax
80106245:	e8 d7 f9 ff ff       	call   80105c21 <mappages>
8010624a:	83 c4 10             	add    $0x10,%esp
8010624d:	85 c0                	test   %eax,%eax
8010624f:	78 05                	js     80106256 <setupkvm+0x54>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106251:	83 c3 10             	add    $0x10,%ebx
80106254:	eb d4                	jmp    8010622a <setupkvm+0x28>
      freevm(pgdir);
80106256:	83 ec 0c             	sub    $0xc,%esp
80106259:	56                   	push   %esi
8010625a:	e8 33 ff ff ff       	call   80106192 <freevm>
      return 0;
8010625f:	83 c4 10             	add    $0x10,%esp
80106262:	be 00 00 00 00       	mov    $0x0,%esi
}
80106267:	89 f0                	mov    %esi,%eax
80106269:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010626c:	5b                   	pop    %ebx
8010626d:	5e                   	pop    %esi
8010626e:	5d                   	pop    %ebp
8010626f:	c3                   	ret    

80106270 <kvmalloc>:
{
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
80106273:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106276:	e8 87 ff ff ff       	call   80106202 <setupkvm>
8010627b:	a3 84 45 11 80       	mov    %eax,0x80114584
  switchkvm();
80106280:	e8 5e fb ff ff       	call   80105de3 <switchkvm>
}
80106285:	c9                   	leave  
80106286:	c3                   	ret    

80106287 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106287:	55                   	push   %ebp
80106288:	89 e5                	mov    %esp,%ebp
8010628a:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010628d:	b9 00 00 00 00       	mov    $0x0,%ecx
80106292:	8b 55 0c             	mov    0xc(%ebp),%edx
80106295:	8b 45 08             	mov    0x8(%ebp),%eax
80106298:	e8 14 f9 ff ff       	call   80105bb1 <walkpgdir>
  if(pte == 0)
8010629d:	85 c0                	test   %eax,%eax
8010629f:	74 05                	je     801062a6 <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
801062a1:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801062a4:	c9                   	leave  
801062a5:	c3                   	ret    
    panic("clearpteu");
801062a6:	83 ec 0c             	sub    $0xc,%esp
801062a9:	68 ca 6d 10 80       	push   $0x80106dca
801062ae:	e8 95 a0 ff ff       	call   80100348 <panic>

801062b3 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801062b3:	55                   	push   %ebp
801062b4:	89 e5                	mov    %esp,%ebp
801062b6:	57                   	push   %edi
801062b7:	56                   	push   %esi
801062b8:	53                   	push   %ebx
801062b9:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801062bc:	e8 41 ff ff ff       	call   80106202 <setupkvm>
801062c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
801062c4:	85 c0                	test   %eax,%eax
801062c6:	0f 84 b8 00 00 00    	je     80106384 <copyuvm+0xd1>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801062cc:	bf 00 00 00 00       	mov    $0x0,%edi
801062d1:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801062d4:	0f 83 aa 00 00 00    	jae    80106384 <copyuvm+0xd1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801062da:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801062dd:	b9 00 00 00 00       	mov    $0x0,%ecx
801062e2:	89 fa                	mov    %edi,%edx
801062e4:	8b 45 08             	mov    0x8(%ebp),%eax
801062e7:	e8 c5 f8 ff ff       	call   80105bb1 <walkpgdir>
801062ec:	85 c0                	test   %eax,%eax
801062ee:	74 65                	je     80106355 <copyuvm+0xa2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801062f0:	8b 00                	mov    (%eax),%eax
801062f2:	a8 01                	test   $0x1,%al
801062f4:	74 6c                	je     80106362 <copyuvm+0xaf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801062f6:	89 c6                	mov    %eax,%esi
801062f8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
801062fe:	25 ff 0f 00 00       	and    $0xfff,%eax
80106303:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80106306:	e8 e3 bd ff ff       	call   801020ee <kalloc>
8010630b:	89 c3                	mov    %eax,%ebx
8010630d:	85 c0                	test   %eax,%eax
8010630f:	74 5e                	je     8010636f <copyuvm+0xbc>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106311:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106317:	83 ec 04             	sub    $0x4,%esp
8010631a:	68 00 10 00 00       	push   $0x1000
8010631f:	56                   	push   %esi
80106320:	50                   	push   %eax
80106321:	e8 e9 d9 ff ff       	call   80103d0f <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106326:	83 c4 08             	add    $0x8,%esp
80106329:	ff 75 e0             	pushl  -0x20(%ebp)
8010632c:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106332:	53                   	push   %ebx
80106333:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106338:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010633b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010633e:	e8 de f8 ff ff       	call   80105c21 <mappages>
80106343:	83 c4 10             	add    $0x10,%esp
80106346:	85 c0                	test   %eax,%eax
80106348:	78 25                	js     8010636f <copyuvm+0xbc>
  for(i = 0; i < sz; i += PGSIZE){
8010634a:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106350:	e9 7c ff ff ff       	jmp    801062d1 <copyuvm+0x1e>
      panic("copyuvm: pte should exist");
80106355:	83 ec 0c             	sub    $0xc,%esp
80106358:	68 d4 6d 10 80       	push   $0x80106dd4
8010635d:	e8 e6 9f ff ff       	call   80100348 <panic>
      panic("copyuvm: page not present");
80106362:	83 ec 0c             	sub    $0xc,%esp
80106365:	68 ee 6d 10 80       	push   $0x80106dee
8010636a:	e8 d9 9f ff ff       	call   80100348 <panic>
      goto bad;
  }
  return d;

bad:
  freevm(d);
8010636f:	83 ec 0c             	sub    $0xc,%esp
80106372:	ff 75 dc             	pushl  -0x24(%ebp)
80106375:	e8 18 fe ff ff       	call   80106192 <freevm>
  return 0;
8010637a:	83 c4 10             	add    $0x10,%esp
8010637d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80106384:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106387:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010638a:	5b                   	pop    %ebx
8010638b:	5e                   	pop    %esi
8010638c:	5f                   	pop    %edi
8010638d:	5d                   	pop    %ebp
8010638e:	c3                   	ret    

8010638f <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010638f:	55                   	push   %ebp
80106390:	89 e5                	mov    %esp,%ebp
80106392:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106395:	b9 00 00 00 00       	mov    $0x0,%ecx
8010639a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010639d:	8b 45 08             	mov    0x8(%ebp),%eax
801063a0:	e8 0c f8 ff ff       	call   80105bb1 <walkpgdir>
  if((*pte & PTE_P) == 0)
801063a5:	8b 00                	mov    (%eax),%eax
801063a7:	a8 01                	test   $0x1,%al
801063a9:	74 10                	je     801063bb <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
801063ab:	a8 04                	test   $0x4,%al
801063ad:	74 13                	je     801063c2 <uva2ka+0x33>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801063af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801063b4:	05 00 00 00 80       	add    $0x80000000,%eax
}
801063b9:	c9                   	leave  
801063ba:	c3                   	ret    
    return 0;
801063bb:	b8 00 00 00 00       	mov    $0x0,%eax
801063c0:	eb f7                	jmp    801063b9 <uva2ka+0x2a>
    return 0;
801063c2:	b8 00 00 00 00       	mov    $0x0,%eax
801063c7:	eb f0                	jmp    801063b9 <uva2ka+0x2a>

801063c9 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801063c9:	55                   	push   %ebp
801063ca:	89 e5                	mov    %esp,%ebp
801063cc:	57                   	push   %edi
801063cd:	56                   	push   %esi
801063ce:	53                   	push   %ebx
801063cf:	83 ec 0c             	sub    $0xc,%esp
801063d2:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801063d5:	eb 25                	jmp    801063fc <copyout+0x33>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801063d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801063da:	29 f2                	sub    %esi,%edx
801063dc:	01 d0                	add    %edx,%eax
801063de:	83 ec 04             	sub    $0x4,%esp
801063e1:	53                   	push   %ebx
801063e2:	ff 75 10             	pushl  0x10(%ebp)
801063e5:	50                   	push   %eax
801063e6:	e8 24 d9 ff ff       	call   80103d0f <memmove>
    len -= n;
801063eb:	29 df                	sub    %ebx,%edi
    buf += n;
801063ed:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801063f0:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
801063f6:	89 45 0c             	mov    %eax,0xc(%ebp)
801063f9:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
801063fc:	85 ff                	test   %edi,%edi
801063fe:	74 2f                	je     8010642f <copyout+0x66>
    va0 = (uint)PGROUNDDOWN(va);
80106400:	8b 75 0c             	mov    0xc(%ebp),%esi
80106403:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106409:	83 ec 08             	sub    $0x8,%esp
8010640c:	56                   	push   %esi
8010640d:	ff 75 08             	pushl  0x8(%ebp)
80106410:	e8 7a ff ff ff       	call   8010638f <uva2ka>
    if(pa0 == 0)
80106415:	83 c4 10             	add    $0x10,%esp
80106418:	85 c0                	test   %eax,%eax
8010641a:	74 20                	je     8010643c <copyout+0x73>
    n = PGSIZE - (va - va0);
8010641c:	89 f3                	mov    %esi,%ebx
8010641e:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106421:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106427:	39 df                	cmp    %ebx,%edi
80106429:	73 ac                	jae    801063d7 <copyout+0xe>
      n = len;
8010642b:	89 fb                	mov    %edi,%ebx
8010642d:	eb a8                	jmp    801063d7 <copyout+0xe>
  }
  return 0;
8010642f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106434:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106437:	5b                   	pop    %ebx
80106438:	5e                   	pop    %esi
80106439:	5f                   	pop    %edi
8010643a:	5d                   	pop    %ebp
8010643b:	c3                   	ret    
      return -1;
8010643c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106441:	eb f1                	jmp    80106434 <copyout+0x6b>
