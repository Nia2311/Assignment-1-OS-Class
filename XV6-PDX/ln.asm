
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  12:	83 39 03             	cmpl   $0x3,(%ecx)
  15:	74 14                	je     2b <main+0x2b>
    printf(2, "Usage: ln old new\n");
  17:	83 ec 08             	sub    $0x8,%esp
  1a:	68 c0 06 00 00       	push   $0x6c0
  1f:	6a 02                	push   $0x2
  21:	e8 e0 03 00 00       	call   406 <printf>
    exit();
  26:	e8 91 02 00 00       	call   2bc <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2b:	83 ec 08             	sub    $0x8,%esp
  2e:	ff 73 08             	pushl  0x8(%ebx)
  31:	ff 73 04             	pushl  0x4(%ebx)
  34:	e8 e3 02 00 00       	call   31c <link>
  39:	83 c4 10             	add    $0x10,%esp
  3c:	85 c0                	test   %eax,%eax
  3e:	78 05                	js     45 <main+0x45>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  40:	e8 77 02 00 00       	call   2bc <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  45:	ff 73 08             	pushl  0x8(%ebx)
  48:	ff 73 04             	pushl  0x4(%ebx)
  4b:	68 d3 06 00 00       	push   $0x6d3
  50:	6a 02                	push   $0x2
  52:	e8 af 03 00 00       	call   406 <printf>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	eb e4                	jmp    40 <main+0x40>

0000005c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	53                   	push   %ebx
  60:	8b 45 08             	mov    0x8(%ebp),%eax
  63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	89 c2                	mov    %eax,%edx
  68:	0f b6 19             	movzbl (%ecx),%ebx
  6b:	88 1a                	mov    %bl,(%edx)
  6d:	8d 52 01             	lea    0x1(%edx),%edx
  70:	8d 49 01             	lea    0x1(%ecx),%ecx
  73:	84 db                	test   %bl,%bl
  75:	75 f1                	jne    68 <strcpy+0xc>
    ;
  return os;
}
  77:	5b                   	pop    %ebx
  78:	5d                   	pop    %ebp
  79:	c3                   	ret    

0000007a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  83:	eb 06                	jmp    8b <strcmp+0x11>
    p++, q++;
  85:	83 c1 01             	add    $0x1,%ecx
  88:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  8b:	0f b6 01             	movzbl (%ecx),%eax
  8e:	84 c0                	test   %al,%al
  90:	74 04                	je     96 <strcmp+0x1c>
  92:	3a 02                	cmp    (%edx),%al
  94:	74 ef                	je     85 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  96:	0f b6 c0             	movzbl %al,%eax
  99:	0f b6 12             	movzbl (%edx),%edx
  9c:	29 d0                	sub    %edx,%eax
}
  9e:	5d                   	pop    %ebp
  9f:	c3                   	ret    

000000a0 <strlen>:

uint
strlen(char *s)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  a6:	ba 00 00 00 00       	mov    $0x0,%edx
  ab:	eb 03                	jmp    b0 <strlen+0x10>
  ad:	83 c2 01             	add    $0x1,%edx
  b0:	89 d0                	mov    %edx,%eax
  b2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  b6:	75 f5                	jne    ad <strlen+0xd>
    ;
  return n;
}
  b8:	5d                   	pop    %ebp
  b9:	c3                   	ret    

000000ba <memset>:

void*
memset(void *dst, int c, uint n)
{
  ba:	55                   	push   %ebp
  bb:	89 e5                	mov    %esp,%ebp
  bd:	57                   	push   %edi
  be:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c1:	89 d7                	mov    %edx,%edi
  c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  c9:	fc                   	cld    
  ca:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  cc:	89 d0                	mov    %edx,%eax
  ce:	5f                   	pop    %edi
  cf:	5d                   	pop    %ebp
  d0:	c3                   	ret    

000000d1 <strchr>:

char*
strchr(const char *s, char c)
{
  d1:	55                   	push   %ebp
  d2:	89 e5                	mov    %esp,%ebp
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  db:	0f b6 10             	movzbl (%eax),%edx
  de:	84 d2                	test   %dl,%dl
  e0:	74 09                	je     eb <strchr+0x1a>
    if(*s == c)
  e2:	38 ca                	cmp    %cl,%dl
  e4:	74 0a                	je     f0 <strchr+0x1f>
  for(; *s; s++)
  e6:	83 c0 01             	add    $0x1,%eax
  e9:	eb f0                	jmp    db <strchr+0xa>
      return (char*)s;
  return 0;
  eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  f0:	5d                   	pop    %ebp
  f1:	c3                   	ret    

000000f2 <gets>:

char*
gets(char *buf, int max)
{
  f2:	55                   	push   %ebp
  f3:	89 e5                	mov    %esp,%ebp
  f5:	57                   	push   %edi
  f6:	56                   	push   %esi
  f7:	53                   	push   %ebx
  f8:	83 ec 1c             	sub    $0x1c,%esp
  fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fe:	bb 00 00 00 00       	mov    $0x0,%ebx
 103:	8d 73 01             	lea    0x1(%ebx),%esi
 106:	3b 75 0c             	cmp    0xc(%ebp),%esi
 109:	7d 2e                	jge    139 <gets+0x47>
    cc = read(0, &c, 1);
 10b:	83 ec 04             	sub    $0x4,%esp
 10e:	6a 01                	push   $0x1
 110:	8d 45 e7             	lea    -0x19(%ebp),%eax
 113:	50                   	push   %eax
 114:	6a 00                	push   $0x0
 116:	e8 b9 01 00 00       	call   2d4 <read>
    if(cc < 1)
 11b:	83 c4 10             	add    $0x10,%esp
 11e:	85 c0                	test   %eax,%eax
 120:	7e 17                	jle    139 <gets+0x47>
      break;
    buf[i++] = c;
 122:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 126:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 129:	3c 0a                	cmp    $0xa,%al
 12b:	0f 94 c2             	sete   %dl
 12e:	3c 0d                	cmp    $0xd,%al
 130:	0f 94 c0             	sete   %al
    buf[i++] = c;
 133:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 135:	08 c2                	or     %al,%dl
 137:	74 ca                	je     103 <gets+0x11>
      break;
  }
  buf[i] = '\0';
 139:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 13d:	89 f8                	mov    %edi,%eax
 13f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 142:	5b                   	pop    %ebx
 143:	5e                   	pop    %esi
 144:	5f                   	pop    %edi
 145:	5d                   	pop    %ebp
 146:	c3                   	ret    

00000147 <stat>:

int
stat(char *n, struct stat *st)
{
 147:	55                   	push   %ebp
 148:	89 e5                	mov    %esp,%ebp
 14a:	56                   	push   %esi
 14b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 14c:	83 ec 08             	sub    $0x8,%esp
 14f:	6a 00                	push   $0x0
 151:	ff 75 08             	pushl  0x8(%ebp)
 154:	e8 a3 01 00 00       	call   2fc <open>
  if(fd < 0)
 159:	83 c4 10             	add    $0x10,%esp
 15c:	85 c0                	test   %eax,%eax
 15e:	78 24                	js     184 <stat+0x3d>
 160:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 162:	83 ec 08             	sub    $0x8,%esp
 165:	ff 75 0c             	pushl  0xc(%ebp)
 168:	50                   	push   %eax
 169:	e8 a6 01 00 00       	call   314 <fstat>
 16e:	89 c6                	mov    %eax,%esi
  close(fd);
 170:	89 1c 24             	mov    %ebx,(%esp)
 173:	e8 6c 01 00 00       	call   2e4 <close>
  return r;
 178:	83 c4 10             	add    $0x10,%esp
}
 17b:	89 f0                	mov    %esi,%eax
 17d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 180:	5b                   	pop    %ebx
 181:	5e                   	pop    %esi
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    
    return -1;
 184:	be ff ff ff ff       	mov    $0xffffffff,%esi
 189:	eb f0                	jmp    17b <stat+0x34>

0000018b <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 18b:	55                   	push   %ebp
 18c:	89 e5                	mov    %esp,%ebp
 18e:	57                   	push   %edi
 18f:	56                   	push   %esi
 190:	53                   	push   %ebx
 191:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 194:	eb 03                	jmp    199 <atoi+0xe>
 196:	83 c2 01             	add    $0x1,%edx
 199:	0f b6 02             	movzbl (%edx),%eax
 19c:	3c 20                	cmp    $0x20,%al
 19e:	74 f6                	je     196 <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 1a0:	3c 2d                	cmp    $0x2d,%al
 1a2:	74 1d                	je     1c1 <atoi+0x36>
 1a4:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1a9:	3c 2b                	cmp    $0x2b,%al
 1ab:	0f 94 c1             	sete   %cl
 1ae:	3c 2d                	cmp    $0x2d,%al
 1b0:	0f 94 c0             	sete   %al
 1b3:	08 c1                	or     %al,%cl
 1b5:	74 03                	je     1ba <atoi+0x2f>
    s++;
 1b7:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 1ba:	b8 00 00 00 00       	mov    $0x0,%eax
 1bf:	eb 17                	jmp    1d8 <atoi+0x4d>
 1c1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 1c6:	eb e1                	jmp    1a9 <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 1c8:	8d 34 80             	lea    (%eax,%eax,4),%esi
 1cb:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 1ce:	83 c2 01             	add    $0x1,%edx
 1d1:	0f be c9             	movsbl %cl,%ecx
 1d4:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 1d8:	0f b6 0a             	movzbl (%edx),%ecx
 1db:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1de:	80 fb 09             	cmp    $0x9,%bl
 1e1:	76 e5                	jbe    1c8 <atoi+0x3d>
  return sign*n;
 1e3:	0f af c7             	imul   %edi,%eax
}
 1e6:	5b                   	pop    %ebx
 1e7:	5e                   	pop    %esi
 1e8:	5f                   	pop    %edi
 1e9:	5d                   	pop    %ebp
 1ea:	c3                   	ret    

000001eb <atoo>:

int
atoo(const char *s)
{
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	57                   	push   %edi
 1ef:	56                   	push   %esi
 1f0:	53                   	push   %ebx
 1f1:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1f4:	eb 03                	jmp    1f9 <atoo+0xe>
 1f6:	83 c2 01             	add    $0x1,%edx
 1f9:	0f b6 0a             	movzbl (%edx),%ecx
 1fc:	80 f9 20             	cmp    $0x20,%cl
 1ff:	74 f5                	je     1f6 <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 201:	80 f9 2d             	cmp    $0x2d,%cl
 204:	74 23                	je     229 <atoo+0x3e>
 206:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 20b:	80 f9 2b             	cmp    $0x2b,%cl
 20e:	0f 94 c0             	sete   %al
 211:	89 c6                	mov    %eax,%esi
 213:	80 f9 2d             	cmp    $0x2d,%cl
 216:	0f 94 c0             	sete   %al
 219:	89 f3                	mov    %esi,%ebx
 21b:	08 c3                	or     %al,%bl
 21d:	74 03                	je     222 <atoo+0x37>
    s++;
 21f:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 222:	b8 00 00 00 00       	mov    $0x0,%eax
 227:	eb 11                	jmp    23a <atoo+0x4f>
 229:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 22e:	eb db                	jmp    20b <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 230:	83 c2 01             	add    $0x1,%edx
 233:	0f be c9             	movsbl %cl,%ecx
 236:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 23a:	0f b6 0a             	movzbl (%edx),%ecx
 23d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 240:	80 fb 07             	cmp    $0x7,%bl
 243:	76 eb                	jbe    230 <atoo+0x45>
  return sign*n;
 245:	0f af c7             	imul   %edi,%eax
}
 248:	5b                   	pop    %ebx
 249:	5e                   	pop    %esi
 24a:	5f                   	pop    %edi
 24b:	5d                   	pop    %ebp
 24c:	c3                   	ret    

0000024d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 24d:	55                   	push   %ebp
 24e:	89 e5                	mov    %esp,%ebp
 250:	53                   	push   %ebx
 251:	8b 55 08             	mov    0x8(%ebp),%edx
 254:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 257:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 25a:	eb 09                	jmp    265 <strncmp+0x18>
      n--, p++, q++;
 25c:	83 e8 01             	sub    $0x1,%eax
 25f:	83 c2 01             	add    $0x1,%edx
 262:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 265:	85 c0                	test   %eax,%eax
 267:	74 0b                	je     274 <strncmp+0x27>
 269:	0f b6 1a             	movzbl (%edx),%ebx
 26c:	84 db                	test   %bl,%bl
 26e:	74 04                	je     274 <strncmp+0x27>
 270:	3a 19                	cmp    (%ecx),%bl
 272:	74 e8                	je     25c <strncmp+0xf>
    if(n == 0)
 274:	85 c0                	test   %eax,%eax
 276:	74 0b                	je     283 <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 278:	0f b6 02             	movzbl (%edx),%eax
 27b:	0f b6 11             	movzbl (%ecx),%edx
 27e:	29 d0                	sub    %edx,%eax
}
 280:	5b                   	pop    %ebx
 281:	5d                   	pop    %ebp
 282:	c3                   	ret    
      return 0;
 283:	b8 00 00 00 00       	mov    $0x0,%eax
 288:	eb f6                	jmp    280 <strncmp+0x33>

0000028a <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	56                   	push   %esi
 28e:	53                   	push   %ebx
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 295:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 298:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 29a:	eb 0d                	jmp    2a9 <memmove+0x1f>
    *dst++ = *src++;
 29c:	0f b6 13             	movzbl (%ebx),%edx
 29f:	88 11                	mov    %dl,(%ecx)
 2a1:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2a4:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 2a7:	89 f2                	mov    %esi,%edx
 2a9:	8d 72 ff             	lea    -0x1(%edx),%esi
 2ac:	85 d2                	test   %edx,%edx
 2ae:	7f ec                	jg     29c <memmove+0x12>
  return vdst;
}
 2b0:	5b                   	pop    %ebx
 2b1:	5e                   	pop    %esi
 2b2:	5d                   	pop    %ebp
 2b3:	c3                   	ret    

000002b4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b4:	b8 01 00 00 00       	mov    $0x1,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <exit>:
SYSCALL(exit)
 2bc:	b8 02 00 00 00       	mov    $0x2,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <wait>:
SYSCALL(wait)
 2c4:	b8 03 00 00 00       	mov    $0x3,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <pipe>:
SYSCALL(pipe)
 2cc:	b8 04 00 00 00       	mov    $0x4,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <read>:
SYSCALL(read)
 2d4:	b8 05 00 00 00       	mov    $0x5,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <write>:
SYSCALL(write)
 2dc:	b8 10 00 00 00       	mov    $0x10,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <close>:
SYSCALL(close)
 2e4:	b8 15 00 00 00       	mov    $0x15,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <kill>:
SYSCALL(kill)
 2ec:	b8 06 00 00 00       	mov    $0x6,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <exec>:
SYSCALL(exec)
 2f4:	b8 07 00 00 00       	mov    $0x7,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <open>:
SYSCALL(open)
 2fc:	b8 0f 00 00 00       	mov    $0xf,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <mknod>:
SYSCALL(mknod)
 304:	b8 11 00 00 00       	mov    $0x11,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <unlink>:
SYSCALL(unlink)
 30c:	b8 12 00 00 00       	mov    $0x12,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <fstat>:
SYSCALL(fstat)
 314:	b8 08 00 00 00       	mov    $0x8,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <link>:
SYSCALL(link)
 31c:	b8 13 00 00 00       	mov    $0x13,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <mkdir>:
SYSCALL(mkdir)
 324:	b8 14 00 00 00       	mov    $0x14,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <chdir>:
SYSCALL(chdir)
 32c:	b8 09 00 00 00       	mov    $0x9,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <dup>:
SYSCALL(dup)
 334:	b8 0a 00 00 00       	mov    $0xa,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <getpid>:
SYSCALL(getpid)
 33c:	b8 0b 00 00 00       	mov    $0xb,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <sbrk>:
SYSCALL(sbrk)
 344:	b8 0c 00 00 00       	mov    $0xc,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <sleep>:
SYSCALL(sleep)
 34c:	b8 0d 00 00 00       	mov    $0xd,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <uptime>:
SYSCALL(uptime)
 354:	b8 0e 00 00 00       	mov    $0xe,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <halt>:
SYSCALL(halt)
 35c:	b8 16 00 00 00       	mov    $0x16,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <date>:
SYSCALL(date)
 364:	b8 17 00 00 00       	mov    $0x17,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 1c             	sub    $0x1c,%esp
 372:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 375:	6a 01                	push   $0x1
 377:	8d 55 f4             	lea    -0xc(%ebp),%edx
 37a:	52                   	push   %edx
 37b:	50                   	push   %eax
 37c:	e8 5b ff ff ff       	call   2dc <write>
}
 381:	83 c4 10             	add    $0x10,%esp
 384:	c9                   	leave  
 385:	c3                   	ret    

00000386 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 386:	55                   	push   %ebp
 387:	89 e5                	mov    %esp,%ebp
 389:	57                   	push   %edi
 38a:	56                   	push   %esi
 38b:	53                   	push   %ebx
 38c:	83 ec 2c             	sub    $0x2c,%esp
 38f:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 391:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 395:	0f 95 c3             	setne  %bl
 398:	89 d0                	mov    %edx,%eax
 39a:	c1 e8 1f             	shr    $0x1f,%eax
 39d:	84 c3                	test   %al,%bl
 39f:	74 10                	je     3b1 <printint+0x2b>
    neg = 1;
    x = -xx;
 3a1:	f7 da                	neg    %edx
    neg = 1;
 3a3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3aa:	be 00 00 00 00       	mov    $0x0,%esi
 3af:	eb 0b                	jmp    3bc <printint+0x36>
  neg = 0;
 3b1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3b8:	eb f0                	jmp    3aa <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 3ba:	89 c6                	mov    %eax,%esi
 3bc:	89 d0                	mov    %edx,%eax
 3be:	ba 00 00 00 00       	mov    $0x0,%edx
 3c3:	f7 f1                	div    %ecx
 3c5:	89 c3                	mov    %eax,%ebx
 3c7:	8d 46 01             	lea    0x1(%esi),%eax
 3ca:	0f b6 92 f0 06 00 00 	movzbl 0x6f0(%edx),%edx
 3d1:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 3d5:	89 da                	mov    %ebx,%edx
 3d7:	85 db                	test   %ebx,%ebx
 3d9:	75 df                	jne    3ba <printint+0x34>
 3db:	89 c3                	mov    %eax,%ebx
  if(neg)
 3dd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3e1:	74 16                	je     3f9 <printint+0x73>
    buf[i++] = '-';
 3e3:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 3e8:	8d 5e 02             	lea    0x2(%esi),%ebx
 3eb:	eb 0c                	jmp    3f9 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 3ed:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3f2:	89 f8                	mov    %edi,%eax
 3f4:	e8 73 ff ff ff       	call   36c <putc>
  while(--i >= 0)
 3f9:	83 eb 01             	sub    $0x1,%ebx
 3fc:	79 ef                	jns    3ed <printint+0x67>
}
 3fe:	83 c4 2c             	add    $0x2c,%esp
 401:	5b                   	pop    %ebx
 402:	5e                   	pop    %esi
 403:	5f                   	pop    %edi
 404:	5d                   	pop    %ebp
 405:	c3                   	ret    

00000406 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 406:	55                   	push   %ebp
 407:	89 e5                	mov    %esp,%ebp
 409:	57                   	push   %edi
 40a:	56                   	push   %esi
 40b:	53                   	push   %ebx
 40c:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 40f:	8d 45 10             	lea    0x10(%ebp),%eax
 412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 415:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 41a:	bb 00 00 00 00       	mov    $0x0,%ebx
 41f:	eb 14                	jmp    435 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 421:	89 fa                	mov    %edi,%edx
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	e8 41 ff ff ff       	call   36c <putc>
 42b:	eb 05                	jmp    432 <printf+0x2c>
      }
    } else if(state == '%'){
 42d:	83 fe 25             	cmp    $0x25,%esi
 430:	74 25                	je     457 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 432:	83 c3 01             	add    $0x1,%ebx
 435:	8b 45 0c             	mov    0xc(%ebp),%eax
 438:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 43c:	84 c0                	test   %al,%al
 43e:	0f 84 23 01 00 00    	je     567 <printf+0x161>
    c = fmt[i] & 0xff;
 444:	0f be f8             	movsbl %al,%edi
 447:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 44a:	85 f6                	test   %esi,%esi
 44c:	75 df                	jne    42d <printf+0x27>
      if(c == '%'){
 44e:	83 f8 25             	cmp    $0x25,%eax
 451:	75 ce                	jne    421 <printf+0x1b>
        state = '%';
 453:	89 c6                	mov    %eax,%esi
 455:	eb db                	jmp    432 <printf+0x2c>
      if(c == 'd'){
 457:	83 f8 64             	cmp    $0x64,%eax
 45a:	74 49                	je     4a5 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 45c:	83 f8 78             	cmp    $0x78,%eax
 45f:	0f 94 c1             	sete   %cl
 462:	83 f8 70             	cmp    $0x70,%eax
 465:	0f 94 c2             	sete   %dl
 468:	08 d1                	or     %dl,%cl
 46a:	75 63                	jne    4cf <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 46c:	83 f8 73             	cmp    $0x73,%eax
 46f:	0f 84 84 00 00 00    	je     4f9 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 475:	83 f8 63             	cmp    $0x63,%eax
 478:	0f 84 b7 00 00 00    	je     535 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 47e:	83 f8 25             	cmp    $0x25,%eax
 481:	0f 84 cc 00 00 00    	je     553 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 487:	ba 25 00 00 00       	mov    $0x25,%edx
 48c:	8b 45 08             	mov    0x8(%ebp),%eax
 48f:	e8 d8 fe ff ff       	call   36c <putc>
        putc(fd, c);
 494:	89 fa                	mov    %edi,%edx
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	e8 ce fe ff ff       	call   36c <putc>
      }
      state = 0;
 49e:	be 00 00 00 00       	mov    $0x0,%esi
 4a3:	eb 8d                	jmp    432 <printf+0x2c>
        printint(fd, *ap, 10, 1);
 4a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4a8:	8b 17                	mov    (%edi),%edx
 4aa:	83 ec 0c             	sub    $0xc,%esp
 4ad:	6a 01                	push   $0x1
 4af:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4b4:	8b 45 08             	mov    0x8(%ebp),%eax
 4b7:	e8 ca fe ff ff       	call   386 <printint>
        ap++;
 4bc:	83 c7 04             	add    $0x4,%edi
 4bf:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4c2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c5:	be 00 00 00 00       	mov    $0x0,%esi
 4ca:	e9 63 ff ff ff       	jmp    432 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4d2:	8b 17                	mov    (%edi),%edx
 4d4:	83 ec 0c             	sub    $0xc,%esp
 4d7:	6a 00                	push   $0x0
 4d9:	b9 10 00 00 00       	mov    $0x10,%ecx
 4de:	8b 45 08             	mov    0x8(%ebp),%eax
 4e1:	e8 a0 fe ff ff       	call   386 <printint>
        ap++;
 4e6:	83 c7 04             	add    $0x4,%edi
 4e9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4ec:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ef:	be 00 00 00 00       	mov    $0x0,%esi
 4f4:	e9 39 ff ff ff       	jmp    432 <printf+0x2c>
        s = (char*)*ap;
 4f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4fc:	8b 30                	mov    (%eax),%esi
        ap++;
 4fe:	83 c0 04             	add    $0x4,%eax
 501:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 504:	85 f6                	test   %esi,%esi
 506:	75 28                	jne    530 <printf+0x12a>
          s = "(null)";
 508:	be e7 06 00 00       	mov    $0x6e7,%esi
 50d:	8b 7d 08             	mov    0x8(%ebp),%edi
 510:	eb 0d                	jmp    51f <printf+0x119>
          putc(fd, *s);
 512:	0f be d2             	movsbl %dl,%edx
 515:	89 f8                	mov    %edi,%eax
 517:	e8 50 fe ff ff       	call   36c <putc>
          s++;
 51c:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 51f:	0f b6 16             	movzbl (%esi),%edx
 522:	84 d2                	test   %dl,%dl
 524:	75 ec                	jne    512 <printf+0x10c>
      state = 0;
 526:	be 00 00 00 00       	mov    $0x0,%esi
 52b:	e9 02 ff ff ff       	jmp    432 <printf+0x2c>
 530:	8b 7d 08             	mov    0x8(%ebp),%edi
 533:	eb ea                	jmp    51f <printf+0x119>
        putc(fd, *ap);
 535:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 538:	0f be 17             	movsbl (%edi),%edx
 53b:	8b 45 08             	mov    0x8(%ebp),%eax
 53e:	e8 29 fe ff ff       	call   36c <putc>
        ap++;
 543:	83 c7 04             	add    $0x4,%edi
 546:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 549:	be 00 00 00 00       	mov    $0x0,%esi
 54e:	e9 df fe ff ff       	jmp    432 <printf+0x2c>
        putc(fd, c);
 553:	89 fa                	mov    %edi,%edx
 555:	8b 45 08             	mov    0x8(%ebp),%eax
 558:	e8 0f fe ff ff       	call   36c <putc>
      state = 0;
 55d:	be 00 00 00 00       	mov    $0x0,%esi
 562:	e9 cb fe ff ff       	jmp    432 <printf+0x2c>
    }
  }
}
 567:	8d 65 f4             	lea    -0xc(%ebp),%esp
 56a:	5b                   	pop    %ebx
 56b:	5e                   	pop    %esi
 56c:	5f                   	pop    %edi
 56d:	5d                   	pop    %ebp
 56e:	c3                   	ret    

0000056f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 56f:	55                   	push   %ebp
 570:	89 e5                	mov    %esp,%ebp
 572:	57                   	push   %edi
 573:	56                   	push   %esi
 574:	53                   	push   %ebx
 575:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 578:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 57b:	a1 e8 09 00 00       	mov    0x9e8,%eax
 580:	eb 02                	jmp    584 <free+0x15>
 582:	89 d0                	mov    %edx,%eax
 584:	39 c8                	cmp    %ecx,%eax
 586:	73 04                	jae    58c <free+0x1d>
 588:	39 08                	cmp    %ecx,(%eax)
 58a:	77 12                	ja     59e <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 58c:	8b 10                	mov    (%eax),%edx
 58e:	39 c2                	cmp    %eax,%edx
 590:	77 f0                	ja     582 <free+0x13>
 592:	39 c8                	cmp    %ecx,%eax
 594:	72 08                	jb     59e <free+0x2f>
 596:	39 ca                	cmp    %ecx,%edx
 598:	77 04                	ja     59e <free+0x2f>
 59a:	89 d0                	mov    %edx,%eax
 59c:	eb e6                	jmp    584 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 59e:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a1:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5a4:	8b 10                	mov    (%eax),%edx
 5a6:	39 d7                	cmp    %edx,%edi
 5a8:	74 19                	je     5c3 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ad:	8b 50 04             	mov    0x4(%eax),%edx
 5b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5b3:	39 ce                	cmp    %ecx,%esi
 5b5:	74 1b                	je     5d2 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5b7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5b9:	a3 e8 09 00 00       	mov    %eax,0x9e8
}
 5be:	5b                   	pop    %ebx
 5bf:	5e                   	pop    %esi
 5c0:	5f                   	pop    %edi
 5c1:	5d                   	pop    %ebp
 5c2:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5c3:	03 72 04             	add    0x4(%edx),%esi
 5c6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5c9:	8b 10                	mov    (%eax),%edx
 5cb:	8b 12                	mov    (%edx),%edx
 5cd:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5d0:	eb db                	jmp    5ad <free+0x3e>
    p->s.size += bp->s.size;
 5d2:	03 53 fc             	add    -0x4(%ebx),%edx
 5d5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5d8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5db:	89 10                	mov    %edx,(%eax)
 5dd:	eb da                	jmp    5b9 <free+0x4a>

000005df <morecore>:

static Header*
morecore(uint nu)
{
 5df:	55                   	push   %ebp
 5e0:	89 e5                	mov    %esp,%ebp
 5e2:	53                   	push   %ebx
 5e3:	83 ec 04             	sub    $0x4,%esp
 5e6:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5e8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5ed:	77 05                	ja     5f4 <morecore+0x15>
    nu = 4096;
 5ef:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5f4:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5fb:	83 ec 0c             	sub    $0xc,%esp
 5fe:	50                   	push   %eax
 5ff:	e8 40 fd ff ff       	call   344 <sbrk>
  if(p == (char*)-1)
 604:	83 c4 10             	add    $0x10,%esp
 607:	83 f8 ff             	cmp    $0xffffffff,%eax
 60a:	74 1c                	je     628 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 60c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 60f:	83 c0 08             	add    $0x8,%eax
 612:	83 ec 0c             	sub    $0xc,%esp
 615:	50                   	push   %eax
 616:	e8 54 ff ff ff       	call   56f <free>
  return freep;
 61b:	a1 e8 09 00 00       	mov    0x9e8,%eax
 620:	83 c4 10             	add    $0x10,%esp
}
 623:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 626:	c9                   	leave  
 627:	c3                   	ret    
    return 0;
 628:	b8 00 00 00 00       	mov    $0x0,%eax
 62d:	eb f4                	jmp    623 <morecore+0x44>

0000062f <malloc>:

void*
malloc(uint nbytes)
{
 62f:	55                   	push   %ebp
 630:	89 e5                	mov    %esp,%ebp
 632:	53                   	push   %ebx
 633:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 636:	8b 45 08             	mov    0x8(%ebp),%eax
 639:	8d 58 07             	lea    0x7(%eax),%ebx
 63c:	c1 eb 03             	shr    $0x3,%ebx
 63f:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 642:	8b 0d e8 09 00 00    	mov    0x9e8,%ecx
 648:	85 c9                	test   %ecx,%ecx
 64a:	74 04                	je     650 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 64c:	8b 01                	mov    (%ecx),%eax
 64e:	eb 4d                	jmp    69d <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 650:	c7 05 e8 09 00 00 ec 	movl   $0x9ec,0x9e8
 657:	09 00 00 
 65a:	c7 05 ec 09 00 00 ec 	movl   $0x9ec,0x9ec
 661:	09 00 00 
    base.s.size = 0;
 664:	c7 05 f0 09 00 00 00 	movl   $0x0,0x9f0
 66b:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 66e:	b9 ec 09 00 00       	mov    $0x9ec,%ecx
 673:	eb d7                	jmp    64c <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 675:	39 da                	cmp    %ebx,%edx
 677:	74 1a                	je     693 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 679:	29 da                	sub    %ebx,%edx
 67b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 67e:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 681:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 684:	89 0d e8 09 00 00    	mov    %ecx,0x9e8
      return (void*)(p + 1);
 68a:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 68d:	83 c4 04             	add    $0x4,%esp
 690:	5b                   	pop    %ebx
 691:	5d                   	pop    %ebp
 692:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 693:	8b 10                	mov    (%eax),%edx
 695:	89 11                	mov    %edx,(%ecx)
 697:	eb eb                	jmp    684 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 699:	89 c1                	mov    %eax,%ecx
 69b:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 69d:	8b 50 04             	mov    0x4(%eax),%edx
 6a0:	39 da                	cmp    %ebx,%edx
 6a2:	73 d1                	jae    675 <malloc+0x46>
    if(p == freep)
 6a4:	39 05 e8 09 00 00    	cmp    %eax,0x9e8
 6aa:	75 ed                	jne    699 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 6ac:	89 d8                	mov    %ebx,%eax
 6ae:	e8 2c ff ff ff       	call   5df <morecore>
 6b3:	85 c0                	test   %eax,%eax
 6b5:	75 e2                	jne    699 <malloc+0x6a>
        return 0;
 6b7:	b8 00 00 00 00       	mov    $0x0,%eax
 6bc:	eb cf                	jmp    68d <malloc+0x5e>
