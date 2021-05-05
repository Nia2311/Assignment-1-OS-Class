
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 70 02 00 00       	call   286 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7f 05                	jg     1f <main+0x1f>
    sleep(5);  // Let child exit before parent.
  exit();
  1a:	e8 6f 02 00 00       	call   28e <exit>
    sleep(5);  // Let child exit before parent.
  1f:	83 ec 0c             	sub    $0xc,%esp
  22:	6a 05                	push   $0x5
  24:	e8 f5 02 00 00       	call   31e <sleep>
  29:	83 c4 10             	add    $0x10,%esp
  2c:	eb ec                	jmp    1a <main+0x1a>

0000002e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  2e:	55                   	push   %ebp
  2f:	89 e5                	mov    %esp,%ebp
  31:	53                   	push   %ebx
  32:	8b 45 08             	mov    0x8(%ebp),%eax
  35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  38:	89 c2                	mov    %eax,%edx
  3a:	0f b6 19             	movzbl (%ecx),%ebx
  3d:	88 1a                	mov    %bl,(%edx)
  3f:	8d 52 01             	lea    0x1(%edx),%edx
  42:	8d 49 01             	lea    0x1(%ecx),%ecx
  45:	84 db                	test   %bl,%bl
  47:	75 f1                	jne    3a <strcpy+0xc>
    ;
  return os;
}
  49:	5b                   	pop    %ebx
  4a:	5d                   	pop    %ebp
  4b:	c3                   	ret    

0000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	55                   	push   %ebp
  4d:	89 e5                	mov    %esp,%ebp
  4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  52:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  55:	eb 06                	jmp    5d <strcmp+0x11>
    p++, q++;
  57:	83 c1 01             	add    $0x1,%ecx
  5a:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  5d:	0f b6 01             	movzbl (%ecx),%eax
  60:	84 c0                	test   %al,%al
  62:	74 04                	je     68 <strcmp+0x1c>
  64:	3a 02                	cmp    (%edx),%al
  66:	74 ef                	je     57 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  68:	0f b6 c0             	movzbl %al,%eax
  6b:	0f b6 12             	movzbl (%edx),%edx
  6e:	29 d0                	sub    %edx,%eax
}
  70:	5d                   	pop    %ebp
  71:	c3                   	ret    

00000072 <strlen>:

uint
strlen(char *s)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  78:	ba 00 00 00 00       	mov    $0x0,%edx
  7d:	eb 03                	jmp    82 <strlen+0x10>
  7f:	83 c2 01             	add    $0x1,%edx
  82:	89 d0                	mov    %edx,%eax
  84:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  88:	75 f5                	jne    7f <strlen+0xd>
    ;
  return n;
}
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <memset>:

void*
memset(void *dst, int c, uint n)
{
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	57                   	push   %edi
  90:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  93:	89 d7                	mov    %edx,%edi
  95:	8b 4d 10             	mov    0x10(%ebp),%ecx
  98:	8b 45 0c             	mov    0xc(%ebp),%eax
  9b:	fc                   	cld    
  9c:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  9e:	89 d0                	mov    %edx,%eax
  a0:	5f                   	pop    %edi
  a1:	5d                   	pop    %ebp
  a2:	c3                   	ret    

000000a3 <strchr>:

char*
strchr(const char *s, char c)
{
  a3:	55                   	push   %ebp
  a4:	89 e5                	mov    %esp,%ebp
  a6:	8b 45 08             	mov    0x8(%ebp),%eax
  a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  ad:	0f b6 10             	movzbl (%eax),%edx
  b0:	84 d2                	test   %dl,%dl
  b2:	74 09                	je     bd <strchr+0x1a>
    if(*s == c)
  b4:	38 ca                	cmp    %cl,%dl
  b6:	74 0a                	je     c2 <strchr+0x1f>
  for(; *s; s++)
  b8:	83 c0 01             	add    $0x1,%eax
  bb:	eb f0                	jmp    ad <strchr+0xa>
      return (char*)s;
  return 0;
  bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  c2:	5d                   	pop    %ebp
  c3:	c3                   	ret    

000000c4 <gets>:

char*
gets(char *buf, int max)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	57                   	push   %edi
  c8:	56                   	push   %esi
  c9:	53                   	push   %ebx
  ca:	83 ec 1c             	sub    $0x1c,%esp
  cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  d5:	8d 73 01             	lea    0x1(%ebx),%esi
  d8:	3b 75 0c             	cmp    0xc(%ebp),%esi
  db:	7d 2e                	jge    10b <gets+0x47>
    cc = read(0, &c, 1);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	6a 01                	push   $0x1
  e2:	8d 45 e7             	lea    -0x19(%ebp),%eax
  e5:	50                   	push   %eax
  e6:	6a 00                	push   $0x0
  e8:	e8 b9 01 00 00       	call   2a6 <read>
    if(cc < 1)
  ed:	83 c4 10             	add    $0x10,%esp
  f0:	85 c0                	test   %eax,%eax
  f2:	7e 17                	jle    10b <gets+0x47>
      break;
    buf[i++] = c;
  f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  f8:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
  fb:	3c 0a                	cmp    $0xa,%al
  fd:	0f 94 c2             	sete   %dl
 100:	3c 0d                	cmp    $0xd,%al
 102:	0f 94 c0             	sete   %al
    buf[i++] = c;
 105:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 107:	08 c2                	or     %al,%dl
 109:	74 ca                	je     d5 <gets+0x11>
      break;
  }
  buf[i] = '\0';
 10b:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 10f:	89 f8                	mov    %edi,%eax
 111:	8d 65 f4             	lea    -0xc(%ebp),%esp
 114:	5b                   	pop    %ebx
 115:	5e                   	pop    %esi
 116:	5f                   	pop    %edi
 117:	5d                   	pop    %ebp
 118:	c3                   	ret    

00000119 <stat>:

int
stat(char *n, struct stat *st)
{
 119:	55                   	push   %ebp
 11a:	89 e5                	mov    %esp,%ebp
 11c:	56                   	push   %esi
 11d:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 11e:	83 ec 08             	sub    $0x8,%esp
 121:	6a 00                	push   $0x0
 123:	ff 75 08             	pushl  0x8(%ebp)
 126:	e8 a3 01 00 00       	call   2ce <open>
  if(fd < 0)
 12b:	83 c4 10             	add    $0x10,%esp
 12e:	85 c0                	test   %eax,%eax
 130:	78 24                	js     156 <stat+0x3d>
 132:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 134:	83 ec 08             	sub    $0x8,%esp
 137:	ff 75 0c             	pushl  0xc(%ebp)
 13a:	50                   	push   %eax
 13b:	e8 a6 01 00 00       	call   2e6 <fstat>
 140:	89 c6                	mov    %eax,%esi
  close(fd);
 142:	89 1c 24             	mov    %ebx,(%esp)
 145:	e8 6c 01 00 00       	call   2b6 <close>
  return r;
 14a:	83 c4 10             	add    $0x10,%esp
}
 14d:	89 f0                	mov    %esi,%eax
 14f:	8d 65 f8             	lea    -0x8(%ebp),%esp
 152:	5b                   	pop    %ebx
 153:	5e                   	pop    %esi
 154:	5d                   	pop    %ebp
 155:	c3                   	ret    
    return -1;
 156:	be ff ff ff ff       	mov    $0xffffffff,%esi
 15b:	eb f0                	jmp    14d <stat+0x34>

0000015d <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	57                   	push   %edi
 161:	56                   	push   %esi
 162:	53                   	push   %ebx
 163:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 166:	eb 03                	jmp    16b <atoi+0xe>
 168:	83 c2 01             	add    $0x1,%edx
 16b:	0f b6 02             	movzbl (%edx),%eax
 16e:	3c 20                	cmp    $0x20,%al
 170:	74 f6                	je     168 <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 172:	3c 2d                	cmp    $0x2d,%al
 174:	74 1d                	je     193 <atoi+0x36>
 176:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 17b:	3c 2b                	cmp    $0x2b,%al
 17d:	0f 94 c1             	sete   %cl
 180:	3c 2d                	cmp    $0x2d,%al
 182:	0f 94 c0             	sete   %al
 185:	08 c1                	or     %al,%cl
 187:	74 03                	je     18c <atoi+0x2f>
    s++;
 189:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 18c:	b8 00 00 00 00       	mov    $0x0,%eax
 191:	eb 17                	jmp    1aa <atoi+0x4d>
 193:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 198:	eb e1                	jmp    17b <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 19a:	8d 34 80             	lea    (%eax,%eax,4),%esi
 19d:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 1a0:	83 c2 01             	add    $0x1,%edx
 1a3:	0f be c9             	movsbl %cl,%ecx
 1a6:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 1aa:	0f b6 0a             	movzbl (%edx),%ecx
 1ad:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1b0:	80 fb 09             	cmp    $0x9,%bl
 1b3:	76 e5                	jbe    19a <atoi+0x3d>
  return sign*n;
 1b5:	0f af c7             	imul   %edi,%eax
}
 1b8:	5b                   	pop    %ebx
 1b9:	5e                   	pop    %esi
 1ba:	5f                   	pop    %edi
 1bb:	5d                   	pop    %ebp
 1bc:	c3                   	ret    

000001bd <atoo>:

int
atoo(const char *s)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	56                   	push   %esi
 1c2:	53                   	push   %ebx
 1c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1c6:	eb 03                	jmp    1cb <atoo+0xe>
 1c8:	83 c2 01             	add    $0x1,%edx
 1cb:	0f b6 0a             	movzbl (%edx),%ecx
 1ce:	80 f9 20             	cmp    $0x20,%cl
 1d1:	74 f5                	je     1c8 <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 1d3:	80 f9 2d             	cmp    $0x2d,%cl
 1d6:	74 23                	je     1fb <atoo+0x3e>
 1d8:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1dd:	80 f9 2b             	cmp    $0x2b,%cl
 1e0:	0f 94 c0             	sete   %al
 1e3:	89 c6                	mov    %eax,%esi
 1e5:	80 f9 2d             	cmp    $0x2d,%cl
 1e8:	0f 94 c0             	sete   %al
 1eb:	89 f3                	mov    %esi,%ebx
 1ed:	08 c3                	or     %al,%bl
 1ef:	74 03                	je     1f4 <atoo+0x37>
    s++;
 1f1:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 1f4:	b8 00 00 00 00       	mov    $0x0,%eax
 1f9:	eb 11                	jmp    20c <atoo+0x4f>
 1fb:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 200:	eb db                	jmp    1dd <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 202:	83 c2 01             	add    $0x1,%edx
 205:	0f be c9             	movsbl %cl,%ecx
 208:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 20c:	0f b6 0a             	movzbl (%edx),%ecx
 20f:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 212:	80 fb 07             	cmp    $0x7,%bl
 215:	76 eb                	jbe    202 <atoo+0x45>
  return sign*n;
 217:	0f af c7             	imul   %edi,%eax
}
 21a:	5b                   	pop    %ebx
 21b:	5e                   	pop    %esi
 21c:	5f                   	pop    %edi
 21d:	5d                   	pop    %ebp
 21e:	c3                   	ret    

0000021f <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 21f:	55                   	push   %ebp
 220:	89 e5                	mov    %esp,%ebp
 222:	53                   	push   %ebx
 223:	8b 55 08             	mov    0x8(%ebp),%edx
 226:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 229:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 22c:	eb 09                	jmp    237 <strncmp+0x18>
      n--, p++, q++;
 22e:	83 e8 01             	sub    $0x1,%eax
 231:	83 c2 01             	add    $0x1,%edx
 234:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 237:	85 c0                	test   %eax,%eax
 239:	74 0b                	je     246 <strncmp+0x27>
 23b:	0f b6 1a             	movzbl (%edx),%ebx
 23e:	84 db                	test   %bl,%bl
 240:	74 04                	je     246 <strncmp+0x27>
 242:	3a 19                	cmp    (%ecx),%bl
 244:	74 e8                	je     22e <strncmp+0xf>
    if(n == 0)
 246:	85 c0                	test   %eax,%eax
 248:	74 0b                	je     255 <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 24a:	0f b6 02             	movzbl (%edx),%eax
 24d:	0f b6 11             	movzbl (%ecx),%edx
 250:	29 d0                	sub    %edx,%eax
}
 252:	5b                   	pop    %ebx
 253:	5d                   	pop    %ebp
 254:	c3                   	ret    
      return 0;
 255:	b8 00 00 00 00       	mov    $0x0,%eax
 25a:	eb f6                	jmp    252 <strncmp+0x33>

0000025c <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 25c:	55                   	push   %ebp
 25d:	89 e5                	mov    %esp,%ebp
 25f:	56                   	push   %esi
 260:	53                   	push   %ebx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 267:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 26a:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 26c:	eb 0d                	jmp    27b <memmove+0x1f>
    *dst++ = *src++;
 26e:	0f b6 13             	movzbl (%ebx),%edx
 271:	88 11                	mov    %dl,(%ecx)
 273:	8d 5b 01             	lea    0x1(%ebx),%ebx
 276:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 279:	89 f2                	mov    %esi,%edx
 27b:	8d 72 ff             	lea    -0x1(%edx),%esi
 27e:	85 d2                	test   %edx,%edx
 280:	7f ec                	jg     26e <memmove+0x12>
  return vdst;
}
 282:	5b                   	pop    %ebx
 283:	5e                   	pop    %esi
 284:	5d                   	pop    %ebp
 285:	c3                   	ret    

00000286 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 286:	b8 01 00 00 00       	mov    $0x1,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <exit>:
SYSCALL(exit)
 28e:	b8 02 00 00 00       	mov    $0x2,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <wait>:
SYSCALL(wait)
 296:	b8 03 00 00 00       	mov    $0x3,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <pipe>:
SYSCALL(pipe)
 29e:	b8 04 00 00 00       	mov    $0x4,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <read>:
SYSCALL(read)
 2a6:	b8 05 00 00 00       	mov    $0x5,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <write>:
SYSCALL(write)
 2ae:	b8 10 00 00 00       	mov    $0x10,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <close>:
SYSCALL(close)
 2b6:	b8 15 00 00 00       	mov    $0x15,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <kill>:
SYSCALL(kill)
 2be:	b8 06 00 00 00       	mov    $0x6,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <exec>:
SYSCALL(exec)
 2c6:	b8 07 00 00 00       	mov    $0x7,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <open>:
SYSCALL(open)
 2ce:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <mknod>:
SYSCALL(mknod)
 2d6:	b8 11 00 00 00       	mov    $0x11,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <unlink>:
SYSCALL(unlink)
 2de:	b8 12 00 00 00       	mov    $0x12,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <fstat>:
SYSCALL(fstat)
 2e6:	b8 08 00 00 00       	mov    $0x8,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <link>:
SYSCALL(link)
 2ee:	b8 13 00 00 00       	mov    $0x13,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <mkdir>:
SYSCALL(mkdir)
 2f6:	b8 14 00 00 00       	mov    $0x14,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <chdir>:
SYSCALL(chdir)
 2fe:	b8 09 00 00 00       	mov    $0x9,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <dup>:
SYSCALL(dup)
 306:	b8 0a 00 00 00       	mov    $0xa,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <getpid>:
SYSCALL(getpid)
 30e:	b8 0b 00 00 00       	mov    $0xb,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <sbrk>:
SYSCALL(sbrk)
 316:	b8 0c 00 00 00       	mov    $0xc,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <sleep>:
SYSCALL(sleep)
 31e:	b8 0d 00 00 00       	mov    $0xd,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <uptime>:
SYSCALL(uptime)
 326:	b8 0e 00 00 00       	mov    $0xe,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <halt>:
SYSCALL(halt)
 32e:	b8 16 00 00 00       	mov    $0x16,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <date>:
SYSCALL(date)
 336:	b8 17 00 00 00       	mov    $0x17,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 33e:	55                   	push   %ebp
 33f:	89 e5                	mov    %esp,%ebp
 341:	83 ec 1c             	sub    $0x1c,%esp
 344:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 347:	6a 01                	push   $0x1
 349:	8d 55 f4             	lea    -0xc(%ebp),%edx
 34c:	52                   	push   %edx
 34d:	50                   	push   %eax
 34e:	e8 5b ff ff ff       	call   2ae <write>
}
 353:	83 c4 10             	add    $0x10,%esp
 356:	c9                   	leave  
 357:	c3                   	ret    

00000358 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	57                   	push   %edi
 35c:	56                   	push   %esi
 35d:	53                   	push   %ebx
 35e:	83 ec 2c             	sub    $0x2c,%esp
 361:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 363:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 367:	0f 95 c3             	setne  %bl
 36a:	89 d0                	mov    %edx,%eax
 36c:	c1 e8 1f             	shr    $0x1f,%eax
 36f:	84 c3                	test   %al,%bl
 371:	74 10                	je     383 <printint+0x2b>
    neg = 1;
    x = -xx;
 373:	f7 da                	neg    %edx
    neg = 1;
 375:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 37c:	be 00 00 00 00       	mov    $0x0,%esi
 381:	eb 0b                	jmp    38e <printint+0x36>
  neg = 0;
 383:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 38a:	eb f0                	jmp    37c <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 38c:	89 c6                	mov    %eax,%esi
 38e:	89 d0                	mov    %edx,%eax
 390:	ba 00 00 00 00       	mov    $0x0,%edx
 395:	f7 f1                	div    %ecx
 397:	89 c3                	mov    %eax,%ebx
 399:	8d 46 01             	lea    0x1(%esi),%eax
 39c:	0f b6 92 98 06 00 00 	movzbl 0x698(%edx),%edx
 3a3:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 3a7:	89 da                	mov    %ebx,%edx
 3a9:	85 db                	test   %ebx,%ebx
 3ab:	75 df                	jne    38c <printint+0x34>
 3ad:	89 c3                	mov    %eax,%ebx
  if(neg)
 3af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3b3:	74 16                	je     3cb <printint+0x73>
    buf[i++] = '-';
 3b5:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 3ba:	8d 5e 02             	lea    0x2(%esi),%ebx
 3bd:	eb 0c                	jmp    3cb <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 3bf:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3c4:	89 f8                	mov    %edi,%eax
 3c6:	e8 73 ff ff ff       	call   33e <putc>
  while(--i >= 0)
 3cb:	83 eb 01             	sub    $0x1,%ebx
 3ce:	79 ef                	jns    3bf <printint+0x67>
}
 3d0:	83 c4 2c             	add    $0x2c,%esp
 3d3:	5b                   	pop    %ebx
 3d4:	5e                   	pop    %esi
 3d5:	5f                   	pop    %edi
 3d6:	5d                   	pop    %ebp
 3d7:	c3                   	ret    

000003d8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3d8:	55                   	push   %ebp
 3d9:	89 e5                	mov    %esp,%ebp
 3db:	57                   	push   %edi
 3dc:	56                   	push   %esi
 3dd:	53                   	push   %ebx
 3de:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3e1:	8d 45 10             	lea    0x10(%ebp),%eax
 3e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3e7:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3ec:	bb 00 00 00 00       	mov    $0x0,%ebx
 3f1:	eb 14                	jmp    407 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3f3:	89 fa                	mov    %edi,%edx
 3f5:	8b 45 08             	mov    0x8(%ebp),%eax
 3f8:	e8 41 ff ff ff       	call   33e <putc>
 3fd:	eb 05                	jmp    404 <printf+0x2c>
      }
    } else if(state == '%'){
 3ff:	83 fe 25             	cmp    $0x25,%esi
 402:	74 25                	je     429 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 404:	83 c3 01             	add    $0x1,%ebx
 407:	8b 45 0c             	mov    0xc(%ebp),%eax
 40a:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 40e:	84 c0                	test   %al,%al
 410:	0f 84 23 01 00 00    	je     539 <printf+0x161>
    c = fmt[i] & 0xff;
 416:	0f be f8             	movsbl %al,%edi
 419:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 41c:	85 f6                	test   %esi,%esi
 41e:	75 df                	jne    3ff <printf+0x27>
      if(c == '%'){
 420:	83 f8 25             	cmp    $0x25,%eax
 423:	75 ce                	jne    3f3 <printf+0x1b>
        state = '%';
 425:	89 c6                	mov    %eax,%esi
 427:	eb db                	jmp    404 <printf+0x2c>
      if(c == 'd'){
 429:	83 f8 64             	cmp    $0x64,%eax
 42c:	74 49                	je     477 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 42e:	83 f8 78             	cmp    $0x78,%eax
 431:	0f 94 c1             	sete   %cl
 434:	83 f8 70             	cmp    $0x70,%eax
 437:	0f 94 c2             	sete   %dl
 43a:	08 d1                	or     %dl,%cl
 43c:	75 63                	jne    4a1 <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 43e:	83 f8 73             	cmp    $0x73,%eax
 441:	0f 84 84 00 00 00    	je     4cb <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 447:	83 f8 63             	cmp    $0x63,%eax
 44a:	0f 84 b7 00 00 00    	je     507 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 450:	83 f8 25             	cmp    $0x25,%eax
 453:	0f 84 cc 00 00 00    	je     525 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 459:	ba 25 00 00 00       	mov    $0x25,%edx
 45e:	8b 45 08             	mov    0x8(%ebp),%eax
 461:	e8 d8 fe ff ff       	call   33e <putc>
        putc(fd, c);
 466:	89 fa                	mov    %edi,%edx
 468:	8b 45 08             	mov    0x8(%ebp),%eax
 46b:	e8 ce fe ff ff       	call   33e <putc>
      }
      state = 0;
 470:	be 00 00 00 00       	mov    $0x0,%esi
 475:	eb 8d                	jmp    404 <printf+0x2c>
        printint(fd, *ap, 10, 1);
 477:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 47a:	8b 17                	mov    (%edi),%edx
 47c:	83 ec 0c             	sub    $0xc,%esp
 47f:	6a 01                	push   $0x1
 481:	b9 0a 00 00 00       	mov    $0xa,%ecx
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	e8 ca fe ff ff       	call   358 <printint>
        ap++;
 48e:	83 c7 04             	add    $0x4,%edi
 491:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 494:	83 c4 10             	add    $0x10,%esp
      state = 0;
 497:	be 00 00 00 00       	mov    $0x0,%esi
 49c:	e9 63 ff ff ff       	jmp    404 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4a4:	8b 17                	mov    (%edi),%edx
 4a6:	83 ec 0c             	sub    $0xc,%esp
 4a9:	6a 00                	push   $0x0
 4ab:	b9 10 00 00 00       	mov    $0x10,%ecx
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	e8 a0 fe ff ff       	call   358 <printint>
        ap++;
 4b8:	83 c7 04             	add    $0x4,%edi
 4bb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4be:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c1:	be 00 00 00 00       	mov    $0x0,%esi
 4c6:	e9 39 ff ff ff       	jmp    404 <printf+0x2c>
        s = (char*)*ap;
 4cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ce:	8b 30                	mov    (%eax),%esi
        ap++;
 4d0:	83 c0 04             	add    $0x4,%eax
 4d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4d6:	85 f6                	test   %esi,%esi
 4d8:	75 28                	jne    502 <printf+0x12a>
          s = "(null)";
 4da:	be 90 06 00 00       	mov    $0x690,%esi
 4df:	8b 7d 08             	mov    0x8(%ebp),%edi
 4e2:	eb 0d                	jmp    4f1 <printf+0x119>
          putc(fd, *s);
 4e4:	0f be d2             	movsbl %dl,%edx
 4e7:	89 f8                	mov    %edi,%eax
 4e9:	e8 50 fe ff ff       	call   33e <putc>
          s++;
 4ee:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4f1:	0f b6 16             	movzbl (%esi),%edx
 4f4:	84 d2                	test   %dl,%dl
 4f6:	75 ec                	jne    4e4 <printf+0x10c>
      state = 0;
 4f8:	be 00 00 00 00       	mov    $0x0,%esi
 4fd:	e9 02 ff ff ff       	jmp    404 <printf+0x2c>
 502:	8b 7d 08             	mov    0x8(%ebp),%edi
 505:	eb ea                	jmp    4f1 <printf+0x119>
        putc(fd, *ap);
 507:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 50a:	0f be 17             	movsbl (%edi),%edx
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	e8 29 fe ff ff       	call   33e <putc>
        ap++;
 515:	83 c7 04             	add    $0x4,%edi
 518:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 51b:	be 00 00 00 00       	mov    $0x0,%esi
 520:	e9 df fe ff ff       	jmp    404 <printf+0x2c>
        putc(fd, c);
 525:	89 fa                	mov    %edi,%edx
 527:	8b 45 08             	mov    0x8(%ebp),%eax
 52a:	e8 0f fe ff ff       	call   33e <putc>
      state = 0;
 52f:	be 00 00 00 00       	mov    $0x0,%esi
 534:	e9 cb fe ff ff       	jmp    404 <printf+0x2c>
    }
  }
}
 539:	8d 65 f4             	lea    -0xc(%ebp),%esp
 53c:	5b                   	pop    %ebx
 53d:	5e                   	pop    %esi
 53e:	5f                   	pop    %edi
 53f:	5d                   	pop    %ebp
 540:	c3                   	ret    

00000541 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 541:	55                   	push   %ebp
 542:	89 e5                	mov    %esp,%ebp
 544:	57                   	push   %edi
 545:	56                   	push   %esi
 546:	53                   	push   %ebx
 547:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 54a:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 54d:	a1 8c 09 00 00       	mov    0x98c,%eax
 552:	eb 02                	jmp    556 <free+0x15>
 554:	89 d0                	mov    %edx,%eax
 556:	39 c8                	cmp    %ecx,%eax
 558:	73 04                	jae    55e <free+0x1d>
 55a:	39 08                	cmp    %ecx,(%eax)
 55c:	77 12                	ja     570 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 55e:	8b 10                	mov    (%eax),%edx
 560:	39 c2                	cmp    %eax,%edx
 562:	77 f0                	ja     554 <free+0x13>
 564:	39 c8                	cmp    %ecx,%eax
 566:	72 08                	jb     570 <free+0x2f>
 568:	39 ca                	cmp    %ecx,%edx
 56a:	77 04                	ja     570 <free+0x2f>
 56c:	89 d0                	mov    %edx,%eax
 56e:	eb e6                	jmp    556 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 570:	8b 73 fc             	mov    -0x4(%ebx),%esi
 573:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 576:	8b 10                	mov    (%eax),%edx
 578:	39 d7                	cmp    %edx,%edi
 57a:	74 19                	je     595 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 57c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 57f:	8b 50 04             	mov    0x4(%eax),%edx
 582:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 585:	39 ce                	cmp    %ecx,%esi
 587:	74 1b                	je     5a4 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 589:	89 08                	mov    %ecx,(%eax)
  freep = p;
 58b:	a3 8c 09 00 00       	mov    %eax,0x98c
}
 590:	5b                   	pop    %ebx
 591:	5e                   	pop    %esi
 592:	5f                   	pop    %edi
 593:	5d                   	pop    %ebp
 594:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 595:	03 72 04             	add    0x4(%edx),%esi
 598:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 59b:	8b 10                	mov    (%eax),%edx
 59d:	8b 12                	mov    (%edx),%edx
 59f:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5a2:	eb db                	jmp    57f <free+0x3e>
    p->s.size += bp->s.size;
 5a4:	03 53 fc             	add    -0x4(%ebx),%edx
 5a7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5aa:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5ad:	89 10                	mov    %edx,(%eax)
 5af:	eb da                	jmp    58b <free+0x4a>

000005b1 <morecore>:

static Header*
morecore(uint nu)
{
 5b1:	55                   	push   %ebp
 5b2:	89 e5                	mov    %esp,%ebp
 5b4:	53                   	push   %ebx
 5b5:	83 ec 04             	sub    $0x4,%esp
 5b8:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5ba:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5bf:	77 05                	ja     5c6 <morecore+0x15>
    nu = 4096;
 5c1:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5c6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5cd:	83 ec 0c             	sub    $0xc,%esp
 5d0:	50                   	push   %eax
 5d1:	e8 40 fd ff ff       	call   316 <sbrk>
  if(p == (char*)-1)
 5d6:	83 c4 10             	add    $0x10,%esp
 5d9:	83 f8 ff             	cmp    $0xffffffff,%eax
 5dc:	74 1c                	je     5fa <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5de:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5e1:	83 c0 08             	add    $0x8,%eax
 5e4:	83 ec 0c             	sub    $0xc,%esp
 5e7:	50                   	push   %eax
 5e8:	e8 54 ff ff ff       	call   541 <free>
  return freep;
 5ed:	a1 8c 09 00 00       	mov    0x98c,%eax
 5f2:	83 c4 10             	add    $0x10,%esp
}
 5f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5f8:	c9                   	leave  
 5f9:	c3                   	ret    
    return 0;
 5fa:	b8 00 00 00 00       	mov    $0x0,%eax
 5ff:	eb f4                	jmp    5f5 <morecore+0x44>

00000601 <malloc>:

void*
malloc(uint nbytes)
{
 601:	55                   	push   %ebp
 602:	89 e5                	mov    %esp,%ebp
 604:	53                   	push   %ebx
 605:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	8d 58 07             	lea    0x7(%eax),%ebx
 60e:	c1 eb 03             	shr    $0x3,%ebx
 611:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 614:	8b 0d 8c 09 00 00    	mov    0x98c,%ecx
 61a:	85 c9                	test   %ecx,%ecx
 61c:	74 04                	je     622 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 61e:	8b 01                	mov    (%ecx),%eax
 620:	eb 4d                	jmp    66f <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 622:	c7 05 8c 09 00 00 90 	movl   $0x990,0x98c
 629:	09 00 00 
 62c:	c7 05 90 09 00 00 90 	movl   $0x990,0x990
 633:	09 00 00 
    base.s.size = 0;
 636:	c7 05 94 09 00 00 00 	movl   $0x0,0x994
 63d:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 640:	b9 90 09 00 00       	mov    $0x990,%ecx
 645:	eb d7                	jmp    61e <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 647:	39 da                	cmp    %ebx,%edx
 649:	74 1a                	je     665 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 64b:	29 da                	sub    %ebx,%edx
 64d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 650:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 653:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 656:	89 0d 8c 09 00 00    	mov    %ecx,0x98c
      return (void*)(p + 1);
 65c:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 65f:	83 c4 04             	add    $0x4,%esp
 662:	5b                   	pop    %ebx
 663:	5d                   	pop    %ebp
 664:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 665:	8b 10                	mov    (%eax),%edx
 667:	89 11                	mov    %edx,(%ecx)
 669:	eb eb                	jmp    656 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 66b:	89 c1                	mov    %eax,%ecx
 66d:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 66f:	8b 50 04             	mov    0x4(%eax),%edx
 672:	39 da                	cmp    %ebx,%edx
 674:	73 d1                	jae    647 <malloc+0x46>
    if(p == freep)
 676:	39 05 8c 09 00 00    	cmp    %eax,0x98c
 67c:	75 ed                	jne    66b <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 67e:	89 d8                	mov    %ebx,%eax
 680:	e8 2c ff ff ff       	call   5b1 <morecore>
 685:	85 c0                	test   %eax,%eax
 687:	75 e2                	jne    66b <malloc+0x6a>
        return 0;
 689:	b8 00 00 00 00       	mov    $0x0,%eax
 68e:	eb cf                	jmp    65f <malloc+0x5e>
