
_halt:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "pdx.h"

int
main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  halt();
  11:	e8 05 03 00 00       	call   31b <halt>
  exit();
  16:	e8 60 02 00 00       	call   27b <exit>

0000001b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  1b:	55                   	push   %ebp
  1c:	89 e5                	mov    %esp,%ebp
  1e:	53                   	push   %ebx
  1f:	8b 45 08             	mov    0x8(%ebp),%eax
  22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  25:	89 c2                	mov    %eax,%edx
  27:	0f b6 19             	movzbl (%ecx),%ebx
  2a:	88 1a                	mov    %bl,(%edx)
  2c:	8d 52 01             	lea    0x1(%edx),%edx
  2f:	8d 49 01             	lea    0x1(%ecx),%ecx
  32:	84 db                	test   %bl,%bl
  34:	75 f1                	jne    27 <strcpy+0xc>
    ;
  return os;
}
  36:	5b                   	pop    %ebx
  37:	5d                   	pop    %ebp
  38:	c3                   	ret    

00000039 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  39:	55                   	push   %ebp
  3a:	89 e5                	mov    %esp,%ebp
  3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  42:	eb 06                	jmp    4a <strcmp+0x11>
    p++, q++;
  44:	83 c1 01             	add    $0x1,%ecx
  47:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  4a:	0f b6 01             	movzbl (%ecx),%eax
  4d:	84 c0                	test   %al,%al
  4f:	74 04                	je     55 <strcmp+0x1c>
  51:	3a 02                	cmp    (%edx),%al
  53:	74 ef                	je     44 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  55:	0f b6 c0             	movzbl %al,%eax
  58:	0f b6 12             	movzbl (%edx),%edx
  5b:	29 d0                	sub    %edx,%eax
}
  5d:	5d                   	pop    %ebp
  5e:	c3                   	ret    

0000005f <strlen>:

uint
strlen(char *s)
{
  5f:	55                   	push   %ebp
  60:	89 e5                	mov    %esp,%ebp
  62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  65:	ba 00 00 00 00       	mov    $0x0,%edx
  6a:	eb 03                	jmp    6f <strlen+0x10>
  6c:	83 c2 01             	add    $0x1,%edx
  6f:	89 d0                	mov    %edx,%eax
  71:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  75:	75 f5                	jne    6c <strlen+0xd>
    ;
  return n;
}
  77:	5d                   	pop    %ebp
  78:	c3                   	ret    

00000079 <memset>:

void*
memset(void *dst, int c, uint n)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	57                   	push   %edi
  7d:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  80:	89 d7                	mov    %edx,%edi
  82:	8b 4d 10             	mov    0x10(%ebp),%ecx
  85:	8b 45 0c             	mov    0xc(%ebp),%eax
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  8b:	89 d0                	mov    %edx,%eax
  8d:	5f                   	pop    %edi
  8e:	5d                   	pop    %ebp
  8f:	c3                   	ret    

00000090 <strchr>:

char*
strchr(const char *s, char c)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  9a:	0f b6 10             	movzbl (%eax),%edx
  9d:	84 d2                	test   %dl,%dl
  9f:	74 09                	je     aa <strchr+0x1a>
    if(*s == c)
  a1:	38 ca                	cmp    %cl,%dl
  a3:	74 0a                	je     af <strchr+0x1f>
  for(; *s; s++)
  a5:	83 c0 01             	add    $0x1,%eax
  a8:	eb f0                	jmp    9a <strchr+0xa>
      return (char*)s;
  return 0;
  aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  af:	5d                   	pop    %ebp
  b0:	c3                   	ret    

000000b1 <gets>:

char*
gets(char *buf, int max)
{
  b1:	55                   	push   %ebp
  b2:	89 e5                	mov    %esp,%ebp
  b4:	57                   	push   %edi
  b5:	56                   	push   %esi
  b6:	53                   	push   %ebx
  b7:	83 ec 1c             	sub    $0x1c,%esp
  ba:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  c2:	8d 73 01             	lea    0x1(%ebx),%esi
  c5:	3b 75 0c             	cmp    0xc(%ebp),%esi
  c8:	7d 2e                	jge    f8 <gets+0x47>
    cc = read(0, &c, 1);
  ca:	83 ec 04             	sub    $0x4,%esp
  cd:	6a 01                	push   $0x1
  cf:	8d 45 e7             	lea    -0x19(%ebp),%eax
  d2:	50                   	push   %eax
  d3:	6a 00                	push   $0x0
  d5:	e8 b9 01 00 00       	call   293 <read>
    if(cc < 1)
  da:	83 c4 10             	add    $0x10,%esp
  dd:	85 c0                	test   %eax,%eax
  df:	7e 17                	jle    f8 <gets+0x47>
      break;
    buf[i++] = c;
  e1:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  e5:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
  e8:	3c 0a                	cmp    $0xa,%al
  ea:	0f 94 c2             	sete   %dl
  ed:	3c 0d                	cmp    $0xd,%al
  ef:	0f 94 c0             	sete   %al
    buf[i++] = c;
  f2:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
  f4:	08 c2                	or     %al,%dl
  f6:	74 ca                	je     c2 <gets+0x11>
      break;
  }
  buf[i] = '\0';
  f8:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
  fc:	89 f8                	mov    %edi,%eax
  fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
 101:	5b                   	pop    %ebx
 102:	5e                   	pop    %esi
 103:	5f                   	pop    %edi
 104:	5d                   	pop    %ebp
 105:	c3                   	ret    

00000106 <stat>:

int
stat(char *n, struct stat *st)
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	56                   	push   %esi
 10a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 10b:	83 ec 08             	sub    $0x8,%esp
 10e:	6a 00                	push   $0x0
 110:	ff 75 08             	pushl  0x8(%ebp)
 113:	e8 a3 01 00 00       	call   2bb <open>
  if(fd < 0)
 118:	83 c4 10             	add    $0x10,%esp
 11b:	85 c0                	test   %eax,%eax
 11d:	78 24                	js     143 <stat+0x3d>
 11f:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 121:	83 ec 08             	sub    $0x8,%esp
 124:	ff 75 0c             	pushl  0xc(%ebp)
 127:	50                   	push   %eax
 128:	e8 a6 01 00 00       	call   2d3 <fstat>
 12d:	89 c6                	mov    %eax,%esi
  close(fd);
 12f:	89 1c 24             	mov    %ebx,(%esp)
 132:	e8 6c 01 00 00       	call   2a3 <close>
  return r;
 137:	83 c4 10             	add    $0x10,%esp
}
 13a:	89 f0                	mov    %esi,%eax
 13c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 13f:	5b                   	pop    %ebx
 140:	5e                   	pop    %esi
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
    return -1;
 143:	be ff ff ff ff       	mov    $0xffffffff,%esi
 148:	eb f0                	jmp    13a <stat+0x34>

0000014a <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	57                   	push   %edi
 14e:	56                   	push   %esi
 14f:	53                   	push   %ebx
 150:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 153:	eb 03                	jmp    158 <atoi+0xe>
 155:	83 c2 01             	add    $0x1,%edx
 158:	0f b6 02             	movzbl (%edx),%eax
 15b:	3c 20                	cmp    $0x20,%al
 15d:	74 f6                	je     155 <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 15f:	3c 2d                	cmp    $0x2d,%al
 161:	74 1d                	je     180 <atoi+0x36>
 163:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 168:	3c 2b                	cmp    $0x2b,%al
 16a:	0f 94 c1             	sete   %cl
 16d:	3c 2d                	cmp    $0x2d,%al
 16f:	0f 94 c0             	sete   %al
 172:	08 c1                	or     %al,%cl
 174:	74 03                	je     179 <atoi+0x2f>
    s++;
 176:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 179:	b8 00 00 00 00       	mov    $0x0,%eax
 17e:	eb 17                	jmp    197 <atoi+0x4d>
 180:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 185:	eb e1                	jmp    168 <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 187:	8d 34 80             	lea    (%eax,%eax,4),%esi
 18a:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 18d:	83 c2 01             	add    $0x1,%edx
 190:	0f be c9             	movsbl %cl,%ecx
 193:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 197:	0f b6 0a             	movzbl (%edx),%ecx
 19a:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 19d:	80 fb 09             	cmp    $0x9,%bl
 1a0:	76 e5                	jbe    187 <atoi+0x3d>
  return sign*n;
 1a2:	0f af c7             	imul   %edi,%eax
}
 1a5:	5b                   	pop    %ebx
 1a6:	5e                   	pop    %esi
 1a7:	5f                   	pop    %edi
 1a8:	5d                   	pop    %ebp
 1a9:	c3                   	ret    

000001aa <atoo>:

int
atoo(const char *s)
{
 1aa:	55                   	push   %ebp
 1ab:	89 e5                	mov    %esp,%ebp
 1ad:	57                   	push   %edi
 1ae:	56                   	push   %esi
 1af:	53                   	push   %ebx
 1b0:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1b3:	eb 03                	jmp    1b8 <atoo+0xe>
 1b5:	83 c2 01             	add    $0x1,%edx
 1b8:	0f b6 0a             	movzbl (%edx),%ecx
 1bb:	80 f9 20             	cmp    $0x20,%cl
 1be:	74 f5                	je     1b5 <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 1c0:	80 f9 2d             	cmp    $0x2d,%cl
 1c3:	74 23                	je     1e8 <atoo+0x3e>
 1c5:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1ca:	80 f9 2b             	cmp    $0x2b,%cl
 1cd:	0f 94 c0             	sete   %al
 1d0:	89 c6                	mov    %eax,%esi
 1d2:	80 f9 2d             	cmp    $0x2d,%cl
 1d5:	0f 94 c0             	sete   %al
 1d8:	89 f3                	mov    %esi,%ebx
 1da:	08 c3                	or     %al,%bl
 1dc:	74 03                	je     1e1 <atoo+0x37>
    s++;
 1de:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 1e1:	b8 00 00 00 00       	mov    $0x0,%eax
 1e6:	eb 11                	jmp    1f9 <atoo+0x4f>
 1e8:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 1ed:	eb db                	jmp    1ca <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 1ef:	83 c2 01             	add    $0x1,%edx
 1f2:	0f be c9             	movsbl %cl,%ecx
 1f5:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 1f9:	0f b6 0a             	movzbl (%edx),%ecx
 1fc:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1ff:	80 fb 07             	cmp    $0x7,%bl
 202:	76 eb                	jbe    1ef <atoo+0x45>
  return sign*n;
 204:	0f af c7             	imul   %edi,%eax
}
 207:	5b                   	pop    %ebx
 208:	5e                   	pop    %esi
 209:	5f                   	pop    %edi
 20a:	5d                   	pop    %ebp
 20b:	c3                   	ret    

0000020c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	53                   	push   %ebx
 210:	8b 55 08             	mov    0x8(%ebp),%edx
 213:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 216:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 219:	eb 09                	jmp    224 <strncmp+0x18>
      n--, p++, q++;
 21b:	83 e8 01             	sub    $0x1,%eax
 21e:	83 c2 01             	add    $0x1,%edx
 221:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 224:	85 c0                	test   %eax,%eax
 226:	74 0b                	je     233 <strncmp+0x27>
 228:	0f b6 1a             	movzbl (%edx),%ebx
 22b:	84 db                	test   %bl,%bl
 22d:	74 04                	je     233 <strncmp+0x27>
 22f:	3a 19                	cmp    (%ecx),%bl
 231:	74 e8                	je     21b <strncmp+0xf>
    if(n == 0)
 233:	85 c0                	test   %eax,%eax
 235:	74 0b                	je     242 <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 237:	0f b6 02             	movzbl (%edx),%eax
 23a:	0f b6 11             	movzbl (%ecx),%edx
 23d:	29 d0                	sub    %edx,%eax
}
 23f:	5b                   	pop    %ebx
 240:	5d                   	pop    %ebp
 241:	c3                   	ret    
      return 0;
 242:	b8 00 00 00 00       	mov    $0x0,%eax
 247:	eb f6                	jmp    23f <strncmp+0x33>

00000249 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 249:	55                   	push   %ebp
 24a:	89 e5                	mov    %esp,%ebp
 24c:	56                   	push   %esi
 24d:	53                   	push   %ebx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 254:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 257:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 259:	eb 0d                	jmp    268 <memmove+0x1f>
    *dst++ = *src++;
 25b:	0f b6 13             	movzbl (%ebx),%edx
 25e:	88 11                	mov    %dl,(%ecx)
 260:	8d 5b 01             	lea    0x1(%ebx),%ebx
 263:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 266:	89 f2                	mov    %esi,%edx
 268:	8d 72 ff             	lea    -0x1(%edx),%esi
 26b:	85 d2                	test   %edx,%edx
 26d:	7f ec                	jg     25b <memmove+0x12>
  return vdst;
}
 26f:	5b                   	pop    %ebx
 270:	5e                   	pop    %esi
 271:	5d                   	pop    %ebp
 272:	c3                   	ret    

00000273 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 273:	b8 01 00 00 00       	mov    $0x1,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <exit>:
SYSCALL(exit)
 27b:	b8 02 00 00 00       	mov    $0x2,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <wait>:
SYSCALL(wait)
 283:	b8 03 00 00 00       	mov    $0x3,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <pipe>:
SYSCALL(pipe)
 28b:	b8 04 00 00 00       	mov    $0x4,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <read>:
SYSCALL(read)
 293:	b8 05 00 00 00       	mov    $0x5,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <write>:
SYSCALL(write)
 29b:	b8 10 00 00 00       	mov    $0x10,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <close>:
SYSCALL(close)
 2a3:	b8 15 00 00 00       	mov    $0x15,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <kill>:
SYSCALL(kill)
 2ab:	b8 06 00 00 00       	mov    $0x6,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <exec>:
SYSCALL(exec)
 2b3:	b8 07 00 00 00       	mov    $0x7,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <open>:
SYSCALL(open)
 2bb:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <mknod>:
SYSCALL(mknod)
 2c3:	b8 11 00 00 00       	mov    $0x11,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <unlink>:
SYSCALL(unlink)
 2cb:	b8 12 00 00 00       	mov    $0x12,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <fstat>:
SYSCALL(fstat)
 2d3:	b8 08 00 00 00       	mov    $0x8,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <link>:
SYSCALL(link)
 2db:	b8 13 00 00 00       	mov    $0x13,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <mkdir>:
SYSCALL(mkdir)
 2e3:	b8 14 00 00 00       	mov    $0x14,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <chdir>:
SYSCALL(chdir)
 2eb:	b8 09 00 00 00       	mov    $0x9,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <dup>:
SYSCALL(dup)
 2f3:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <getpid>:
SYSCALL(getpid)
 2fb:	b8 0b 00 00 00       	mov    $0xb,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <sbrk>:
SYSCALL(sbrk)
 303:	b8 0c 00 00 00       	mov    $0xc,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <sleep>:
SYSCALL(sleep)
 30b:	b8 0d 00 00 00       	mov    $0xd,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <uptime>:
SYSCALL(uptime)
 313:	b8 0e 00 00 00       	mov    $0xe,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <halt>:
SYSCALL(halt)
 31b:	b8 16 00 00 00       	mov    $0x16,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <date>:
SYSCALL(date)
 323:	b8 17 00 00 00       	mov    $0x17,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 32b:	55                   	push   %ebp
 32c:	89 e5                	mov    %esp,%ebp
 32e:	83 ec 1c             	sub    $0x1c,%esp
 331:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 334:	6a 01                	push   $0x1
 336:	8d 55 f4             	lea    -0xc(%ebp),%edx
 339:	52                   	push   %edx
 33a:	50                   	push   %eax
 33b:	e8 5b ff ff ff       	call   29b <write>
}
 340:	83 c4 10             	add    $0x10,%esp
 343:	c9                   	leave  
 344:	c3                   	ret    

00000345 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 345:	55                   	push   %ebp
 346:	89 e5                	mov    %esp,%ebp
 348:	57                   	push   %edi
 349:	56                   	push   %esi
 34a:	53                   	push   %ebx
 34b:	83 ec 2c             	sub    $0x2c,%esp
 34e:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 350:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 354:	0f 95 c3             	setne  %bl
 357:	89 d0                	mov    %edx,%eax
 359:	c1 e8 1f             	shr    $0x1f,%eax
 35c:	84 c3                	test   %al,%bl
 35e:	74 10                	je     370 <printint+0x2b>
    neg = 1;
    x = -xx;
 360:	f7 da                	neg    %edx
    neg = 1;
 362:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 369:	be 00 00 00 00       	mov    $0x0,%esi
 36e:	eb 0b                	jmp    37b <printint+0x36>
  neg = 0;
 370:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 377:	eb f0                	jmp    369 <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 379:	89 c6                	mov    %eax,%esi
 37b:	89 d0                	mov    %edx,%eax
 37d:	ba 00 00 00 00       	mov    $0x0,%edx
 382:	f7 f1                	div    %ecx
 384:	89 c3                	mov    %eax,%ebx
 386:	8d 46 01             	lea    0x1(%esi),%eax
 389:	0f b6 92 88 06 00 00 	movzbl 0x688(%edx),%edx
 390:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 394:	89 da                	mov    %ebx,%edx
 396:	85 db                	test   %ebx,%ebx
 398:	75 df                	jne    379 <printint+0x34>
 39a:	89 c3                	mov    %eax,%ebx
  if(neg)
 39c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3a0:	74 16                	je     3b8 <printint+0x73>
    buf[i++] = '-';
 3a2:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 3a7:	8d 5e 02             	lea    0x2(%esi),%ebx
 3aa:	eb 0c                	jmp    3b8 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 3ac:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3b1:	89 f8                	mov    %edi,%eax
 3b3:	e8 73 ff ff ff       	call   32b <putc>
  while(--i >= 0)
 3b8:	83 eb 01             	sub    $0x1,%ebx
 3bb:	79 ef                	jns    3ac <printint+0x67>
}
 3bd:	83 c4 2c             	add    $0x2c,%esp
 3c0:	5b                   	pop    %ebx
 3c1:	5e                   	pop    %esi
 3c2:	5f                   	pop    %edi
 3c3:	5d                   	pop    %ebp
 3c4:	c3                   	ret    

000003c5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3c5:	55                   	push   %ebp
 3c6:	89 e5                	mov    %esp,%ebp
 3c8:	57                   	push   %edi
 3c9:	56                   	push   %esi
 3ca:	53                   	push   %ebx
 3cb:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3ce:	8d 45 10             	lea    0x10(%ebp),%eax
 3d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3d4:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3d9:	bb 00 00 00 00       	mov    $0x0,%ebx
 3de:	eb 14                	jmp    3f4 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3e0:	89 fa                	mov    %edi,%edx
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	e8 41 ff ff ff       	call   32b <putc>
 3ea:	eb 05                	jmp    3f1 <printf+0x2c>
      }
    } else if(state == '%'){
 3ec:	83 fe 25             	cmp    $0x25,%esi
 3ef:	74 25                	je     416 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 3f1:	83 c3 01             	add    $0x1,%ebx
 3f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f7:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 3fb:	84 c0                	test   %al,%al
 3fd:	0f 84 23 01 00 00    	je     526 <printf+0x161>
    c = fmt[i] & 0xff;
 403:	0f be f8             	movsbl %al,%edi
 406:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 409:	85 f6                	test   %esi,%esi
 40b:	75 df                	jne    3ec <printf+0x27>
      if(c == '%'){
 40d:	83 f8 25             	cmp    $0x25,%eax
 410:	75 ce                	jne    3e0 <printf+0x1b>
        state = '%';
 412:	89 c6                	mov    %eax,%esi
 414:	eb db                	jmp    3f1 <printf+0x2c>
      if(c == 'd'){
 416:	83 f8 64             	cmp    $0x64,%eax
 419:	74 49                	je     464 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 41b:	83 f8 78             	cmp    $0x78,%eax
 41e:	0f 94 c1             	sete   %cl
 421:	83 f8 70             	cmp    $0x70,%eax
 424:	0f 94 c2             	sete   %dl
 427:	08 d1                	or     %dl,%cl
 429:	75 63                	jne    48e <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 42b:	83 f8 73             	cmp    $0x73,%eax
 42e:	0f 84 84 00 00 00    	je     4b8 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 434:	83 f8 63             	cmp    $0x63,%eax
 437:	0f 84 b7 00 00 00    	je     4f4 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 43d:	83 f8 25             	cmp    $0x25,%eax
 440:	0f 84 cc 00 00 00    	je     512 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 446:	ba 25 00 00 00       	mov    $0x25,%edx
 44b:	8b 45 08             	mov    0x8(%ebp),%eax
 44e:	e8 d8 fe ff ff       	call   32b <putc>
        putc(fd, c);
 453:	89 fa                	mov    %edi,%edx
 455:	8b 45 08             	mov    0x8(%ebp),%eax
 458:	e8 ce fe ff ff       	call   32b <putc>
      }
      state = 0;
 45d:	be 00 00 00 00       	mov    $0x0,%esi
 462:	eb 8d                	jmp    3f1 <printf+0x2c>
        printint(fd, *ap, 10, 1);
 464:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 467:	8b 17                	mov    (%edi),%edx
 469:	83 ec 0c             	sub    $0xc,%esp
 46c:	6a 01                	push   $0x1
 46e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	e8 ca fe ff ff       	call   345 <printint>
        ap++;
 47b:	83 c7 04             	add    $0x4,%edi
 47e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 481:	83 c4 10             	add    $0x10,%esp
      state = 0;
 484:	be 00 00 00 00       	mov    $0x0,%esi
 489:	e9 63 ff ff ff       	jmp    3f1 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 48e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 491:	8b 17                	mov    (%edi),%edx
 493:	83 ec 0c             	sub    $0xc,%esp
 496:	6a 00                	push   $0x0
 498:	b9 10 00 00 00       	mov    $0x10,%ecx
 49d:	8b 45 08             	mov    0x8(%ebp),%eax
 4a0:	e8 a0 fe ff ff       	call   345 <printint>
        ap++;
 4a5:	83 c7 04             	add    $0x4,%edi
 4a8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4ab:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ae:	be 00 00 00 00       	mov    $0x0,%esi
 4b3:	e9 39 ff ff ff       	jmp    3f1 <printf+0x2c>
        s = (char*)*ap;
 4b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4bb:	8b 30                	mov    (%eax),%esi
        ap++;
 4bd:	83 c0 04             	add    $0x4,%eax
 4c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4c3:	85 f6                	test   %esi,%esi
 4c5:	75 28                	jne    4ef <printf+0x12a>
          s = "(null)";
 4c7:	be 80 06 00 00       	mov    $0x680,%esi
 4cc:	8b 7d 08             	mov    0x8(%ebp),%edi
 4cf:	eb 0d                	jmp    4de <printf+0x119>
          putc(fd, *s);
 4d1:	0f be d2             	movsbl %dl,%edx
 4d4:	89 f8                	mov    %edi,%eax
 4d6:	e8 50 fe ff ff       	call   32b <putc>
          s++;
 4db:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4de:	0f b6 16             	movzbl (%esi),%edx
 4e1:	84 d2                	test   %dl,%dl
 4e3:	75 ec                	jne    4d1 <printf+0x10c>
      state = 0;
 4e5:	be 00 00 00 00       	mov    $0x0,%esi
 4ea:	e9 02 ff ff ff       	jmp    3f1 <printf+0x2c>
 4ef:	8b 7d 08             	mov    0x8(%ebp),%edi
 4f2:	eb ea                	jmp    4de <printf+0x119>
        putc(fd, *ap);
 4f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4f7:	0f be 17             	movsbl (%edi),%edx
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
 4fd:	e8 29 fe ff ff       	call   32b <putc>
        ap++;
 502:	83 c7 04             	add    $0x4,%edi
 505:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 508:	be 00 00 00 00       	mov    $0x0,%esi
 50d:	e9 df fe ff ff       	jmp    3f1 <printf+0x2c>
        putc(fd, c);
 512:	89 fa                	mov    %edi,%edx
 514:	8b 45 08             	mov    0x8(%ebp),%eax
 517:	e8 0f fe ff ff       	call   32b <putc>
      state = 0;
 51c:	be 00 00 00 00       	mov    $0x0,%esi
 521:	e9 cb fe ff ff       	jmp    3f1 <printf+0x2c>
    }
  }
}
 526:	8d 65 f4             	lea    -0xc(%ebp),%esp
 529:	5b                   	pop    %ebx
 52a:	5e                   	pop    %esi
 52b:	5f                   	pop    %edi
 52c:	5d                   	pop    %ebp
 52d:	c3                   	ret    

0000052e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 52e:	55                   	push   %ebp
 52f:	89 e5                	mov    %esp,%ebp
 531:	57                   	push   %edi
 532:	56                   	push   %esi
 533:	53                   	push   %ebx
 534:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 537:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 53a:	a1 7c 09 00 00       	mov    0x97c,%eax
 53f:	eb 02                	jmp    543 <free+0x15>
 541:	89 d0                	mov    %edx,%eax
 543:	39 c8                	cmp    %ecx,%eax
 545:	73 04                	jae    54b <free+0x1d>
 547:	39 08                	cmp    %ecx,(%eax)
 549:	77 12                	ja     55d <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 54b:	8b 10                	mov    (%eax),%edx
 54d:	39 c2                	cmp    %eax,%edx
 54f:	77 f0                	ja     541 <free+0x13>
 551:	39 c8                	cmp    %ecx,%eax
 553:	72 08                	jb     55d <free+0x2f>
 555:	39 ca                	cmp    %ecx,%edx
 557:	77 04                	ja     55d <free+0x2f>
 559:	89 d0                	mov    %edx,%eax
 55b:	eb e6                	jmp    543 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 55d:	8b 73 fc             	mov    -0x4(%ebx),%esi
 560:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 563:	8b 10                	mov    (%eax),%edx
 565:	39 d7                	cmp    %edx,%edi
 567:	74 19                	je     582 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 569:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 56c:	8b 50 04             	mov    0x4(%eax),%edx
 56f:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 572:	39 ce                	cmp    %ecx,%esi
 574:	74 1b                	je     591 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 576:	89 08                	mov    %ecx,(%eax)
  freep = p;
 578:	a3 7c 09 00 00       	mov    %eax,0x97c
}
 57d:	5b                   	pop    %ebx
 57e:	5e                   	pop    %esi
 57f:	5f                   	pop    %edi
 580:	5d                   	pop    %ebp
 581:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 582:	03 72 04             	add    0x4(%edx),%esi
 585:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 588:	8b 10                	mov    (%eax),%edx
 58a:	8b 12                	mov    (%edx),%edx
 58c:	89 53 f8             	mov    %edx,-0x8(%ebx)
 58f:	eb db                	jmp    56c <free+0x3e>
    p->s.size += bp->s.size;
 591:	03 53 fc             	add    -0x4(%ebx),%edx
 594:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 597:	8b 53 f8             	mov    -0x8(%ebx),%edx
 59a:	89 10                	mov    %edx,(%eax)
 59c:	eb da                	jmp    578 <free+0x4a>

0000059e <morecore>:

static Header*
morecore(uint nu)
{
 59e:	55                   	push   %ebp
 59f:	89 e5                	mov    %esp,%ebp
 5a1:	53                   	push   %ebx
 5a2:	83 ec 04             	sub    $0x4,%esp
 5a5:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5a7:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5ac:	77 05                	ja     5b3 <morecore+0x15>
    nu = 4096;
 5ae:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5b3:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5ba:	83 ec 0c             	sub    $0xc,%esp
 5bd:	50                   	push   %eax
 5be:	e8 40 fd ff ff       	call   303 <sbrk>
  if(p == (char*)-1)
 5c3:	83 c4 10             	add    $0x10,%esp
 5c6:	83 f8 ff             	cmp    $0xffffffff,%eax
 5c9:	74 1c                	je     5e7 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5cb:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5ce:	83 c0 08             	add    $0x8,%eax
 5d1:	83 ec 0c             	sub    $0xc,%esp
 5d4:	50                   	push   %eax
 5d5:	e8 54 ff ff ff       	call   52e <free>
  return freep;
 5da:	a1 7c 09 00 00       	mov    0x97c,%eax
 5df:	83 c4 10             	add    $0x10,%esp
}
 5e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5e5:	c9                   	leave  
 5e6:	c3                   	ret    
    return 0;
 5e7:	b8 00 00 00 00       	mov    $0x0,%eax
 5ec:	eb f4                	jmp    5e2 <morecore+0x44>

000005ee <malloc>:

void*
malloc(uint nbytes)
{
 5ee:	55                   	push   %ebp
 5ef:	89 e5                	mov    %esp,%ebp
 5f1:	53                   	push   %ebx
 5f2:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5f5:	8b 45 08             	mov    0x8(%ebp),%eax
 5f8:	8d 58 07             	lea    0x7(%eax),%ebx
 5fb:	c1 eb 03             	shr    $0x3,%ebx
 5fe:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 601:	8b 0d 7c 09 00 00    	mov    0x97c,%ecx
 607:	85 c9                	test   %ecx,%ecx
 609:	74 04                	je     60f <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 60b:	8b 01                	mov    (%ecx),%eax
 60d:	eb 4d                	jmp    65c <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 60f:	c7 05 7c 09 00 00 80 	movl   $0x980,0x97c
 616:	09 00 00 
 619:	c7 05 80 09 00 00 80 	movl   $0x980,0x980
 620:	09 00 00 
    base.s.size = 0;
 623:	c7 05 84 09 00 00 00 	movl   $0x0,0x984
 62a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 62d:	b9 80 09 00 00       	mov    $0x980,%ecx
 632:	eb d7                	jmp    60b <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 634:	39 da                	cmp    %ebx,%edx
 636:	74 1a                	je     652 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 638:	29 da                	sub    %ebx,%edx
 63a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 63d:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 640:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 643:	89 0d 7c 09 00 00    	mov    %ecx,0x97c
      return (void*)(p + 1);
 649:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 64c:	83 c4 04             	add    $0x4,%esp
 64f:	5b                   	pop    %ebx
 650:	5d                   	pop    %ebp
 651:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 652:	8b 10                	mov    (%eax),%edx
 654:	89 11                	mov    %edx,(%ecx)
 656:	eb eb                	jmp    643 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 658:	89 c1                	mov    %eax,%ecx
 65a:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 65c:	8b 50 04             	mov    0x4(%eax),%edx
 65f:	39 da                	cmp    %ebx,%edx
 661:	73 d1                	jae    634 <malloc+0x46>
    if(p == freep)
 663:	39 05 7c 09 00 00    	cmp    %eax,0x97c
 669:	75 ed                	jne    658 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 66b:	89 d8                	mov    %ebx,%eax
 66d:	e8 2c ff ff ff       	call   59e <morecore>
 672:	85 c0                	test   %eax,%eax
 674:	75 e2                	jne    658 <malloc+0x6a>
        return 0;
 676:	b8 00 00 00 00       	mov    $0x0,%eax
 67b:	eb cf                	jmp    64c <malloc+0x5e>
