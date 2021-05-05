
_echo:     file format elf32-i386


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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  19:	b8 01 00 00 00       	mov    $0x1,%eax
  1e:	eb 1a                	jmp    3a <main+0x3a>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  20:	ba b6 06 00 00       	mov    $0x6b6,%edx
  25:	52                   	push   %edx
  26:	ff 34 87             	pushl  (%edi,%eax,4)
  29:	68 b8 06 00 00       	push   $0x6b8
  2e:	6a 01                	push   $0x1
  30:	e8 c6 03 00 00       	call   3fb <printf>
  for(i = 1; i < argc; i++)
  35:	83 c4 10             	add    $0x10,%esp
  38:	89 d8                	mov    %ebx,%eax
  3a:	39 f0                	cmp    %esi,%eax
  3c:	7d 0e                	jge    4c <main+0x4c>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  3e:	8d 58 01             	lea    0x1(%eax),%ebx
  41:	39 f3                	cmp    %esi,%ebx
  43:	7d db                	jge    20 <main+0x20>
  45:	ba b4 06 00 00       	mov    $0x6b4,%edx
  4a:	eb d9                	jmp    25 <main+0x25>
  exit();
  4c:	e8 60 02 00 00       	call   2b1 <exit>

00000051 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	53                   	push   %ebx
  55:	8b 45 08             	mov    0x8(%ebp),%eax
  58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5b:	89 c2                	mov    %eax,%edx
  5d:	0f b6 19             	movzbl (%ecx),%ebx
  60:	88 1a                	mov    %bl,(%edx)
  62:	8d 52 01             	lea    0x1(%edx),%edx
  65:	8d 49 01             	lea    0x1(%ecx),%ecx
  68:	84 db                	test   %bl,%bl
  6a:	75 f1                	jne    5d <strcpy+0xc>
    ;
  return os;
}
  6c:	5b                   	pop    %ebx
  6d:	5d                   	pop    %ebp
  6e:	c3                   	ret    

0000006f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  6f:	55                   	push   %ebp
  70:	89 e5                	mov    %esp,%ebp
  72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  75:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  78:	eb 06                	jmp    80 <strcmp+0x11>
    p++, q++;
  7a:	83 c1 01             	add    $0x1,%ecx
  7d:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  80:	0f b6 01             	movzbl (%ecx),%eax
  83:	84 c0                	test   %al,%al
  85:	74 04                	je     8b <strcmp+0x1c>
  87:	3a 02                	cmp    (%edx),%al
  89:	74 ef                	je     7a <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  8b:	0f b6 c0             	movzbl %al,%eax
  8e:	0f b6 12             	movzbl (%edx),%edx
  91:	29 d0                	sub    %edx,%eax
}
  93:	5d                   	pop    %ebp
  94:	c3                   	ret    

00000095 <strlen>:

uint
strlen(char *s)
{
  95:	55                   	push   %ebp
  96:	89 e5                	mov    %esp,%ebp
  98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  9b:	ba 00 00 00 00       	mov    $0x0,%edx
  a0:	eb 03                	jmp    a5 <strlen+0x10>
  a2:	83 c2 01             	add    $0x1,%edx
  a5:	89 d0                	mov    %edx,%eax
  a7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  ab:	75 f5                	jne    a2 <strlen+0xd>
    ;
  return n;
}
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret    

000000af <memset>:

void*
memset(void *dst, int c, uint n)
{
  af:	55                   	push   %ebp
  b0:	89 e5                	mov    %esp,%ebp
  b2:	57                   	push   %edi
  b3:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  b6:	89 d7                	mov    %edx,%edi
  b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  be:	fc                   	cld    
  bf:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c1:	89 d0                	mov    %edx,%eax
  c3:	5f                   	pop    %edi
  c4:	5d                   	pop    %ebp
  c5:	c3                   	ret    

000000c6 <strchr>:

char*
strchr(const char *s, char c)
{
  c6:	55                   	push   %ebp
  c7:	89 e5                	mov    %esp,%ebp
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  d0:	0f b6 10             	movzbl (%eax),%edx
  d3:	84 d2                	test   %dl,%dl
  d5:	74 09                	je     e0 <strchr+0x1a>
    if(*s == c)
  d7:	38 ca                	cmp    %cl,%dl
  d9:	74 0a                	je     e5 <strchr+0x1f>
  for(; *s; s++)
  db:	83 c0 01             	add    $0x1,%eax
  de:	eb f0                	jmp    d0 <strchr+0xa>
      return (char*)s;
  return 0;
  e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    

000000e7 <gets>:

char*
gets(char *buf, int max)
{
  e7:	55                   	push   %ebp
  e8:	89 e5                	mov    %esp,%ebp
  ea:	57                   	push   %edi
  eb:	56                   	push   %esi
  ec:	53                   	push   %ebx
  ed:	83 ec 1c             	sub    $0x1c,%esp
  f0:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  f8:	8d 73 01             	lea    0x1(%ebx),%esi
  fb:	3b 75 0c             	cmp    0xc(%ebp),%esi
  fe:	7d 2e                	jge    12e <gets+0x47>
    cc = read(0, &c, 1);
 100:	83 ec 04             	sub    $0x4,%esp
 103:	6a 01                	push   $0x1
 105:	8d 45 e7             	lea    -0x19(%ebp),%eax
 108:	50                   	push   %eax
 109:	6a 00                	push   $0x0
 10b:	e8 b9 01 00 00       	call   2c9 <read>
    if(cc < 1)
 110:	83 c4 10             	add    $0x10,%esp
 113:	85 c0                	test   %eax,%eax
 115:	7e 17                	jle    12e <gets+0x47>
      break;
    buf[i++] = c;
 117:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 11b:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 11e:	3c 0a                	cmp    $0xa,%al
 120:	0f 94 c2             	sete   %dl
 123:	3c 0d                	cmp    $0xd,%al
 125:	0f 94 c0             	sete   %al
    buf[i++] = c;
 128:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 12a:	08 c2                	or     %al,%dl
 12c:	74 ca                	je     f8 <gets+0x11>
      break;
  }
  buf[i] = '\0';
 12e:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 132:	89 f8                	mov    %edi,%eax
 134:	8d 65 f4             	lea    -0xc(%ebp),%esp
 137:	5b                   	pop    %ebx
 138:	5e                   	pop    %esi
 139:	5f                   	pop    %edi
 13a:	5d                   	pop    %ebp
 13b:	c3                   	ret    

0000013c <stat>:

int
stat(char *n, struct stat *st)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	56                   	push   %esi
 140:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 141:	83 ec 08             	sub    $0x8,%esp
 144:	6a 00                	push   $0x0
 146:	ff 75 08             	pushl  0x8(%ebp)
 149:	e8 a3 01 00 00       	call   2f1 <open>
  if(fd < 0)
 14e:	83 c4 10             	add    $0x10,%esp
 151:	85 c0                	test   %eax,%eax
 153:	78 24                	js     179 <stat+0x3d>
 155:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 157:	83 ec 08             	sub    $0x8,%esp
 15a:	ff 75 0c             	pushl  0xc(%ebp)
 15d:	50                   	push   %eax
 15e:	e8 a6 01 00 00       	call   309 <fstat>
 163:	89 c6                	mov    %eax,%esi
  close(fd);
 165:	89 1c 24             	mov    %ebx,(%esp)
 168:	e8 6c 01 00 00       	call   2d9 <close>
  return r;
 16d:	83 c4 10             	add    $0x10,%esp
}
 170:	89 f0                	mov    %esi,%eax
 172:	8d 65 f8             	lea    -0x8(%ebp),%esp
 175:	5b                   	pop    %ebx
 176:	5e                   	pop    %esi
 177:	5d                   	pop    %ebp
 178:	c3                   	ret    
    return -1;
 179:	be ff ff ff ff       	mov    $0xffffffff,%esi
 17e:	eb f0                	jmp    170 <stat+0x34>

00000180 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	56                   	push   %esi
 185:	53                   	push   %ebx
 186:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 189:	eb 03                	jmp    18e <atoi+0xe>
 18b:	83 c2 01             	add    $0x1,%edx
 18e:	0f b6 02             	movzbl (%edx),%eax
 191:	3c 20                	cmp    $0x20,%al
 193:	74 f6                	je     18b <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 195:	3c 2d                	cmp    $0x2d,%al
 197:	74 1d                	je     1b6 <atoi+0x36>
 199:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 19e:	3c 2b                	cmp    $0x2b,%al
 1a0:	0f 94 c1             	sete   %cl
 1a3:	3c 2d                	cmp    $0x2d,%al
 1a5:	0f 94 c0             	sete   %al
 1a8:	08 c1                	or     %al,%cl
 1aa:	74 03                	je     1af <atoi+0x2f>
    s++;
 1ac:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 1af:	b8 00 00 00 00       	mov    $0x0,%eax
 1b4:	eb 17                	jmp    1cd <atoi+0x4d>
 1b6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 1bb:	eb e1                	jmp    19e <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 1bd:	8d 34 80             	lea    (%eax,%eax,4),%esi
 1c0:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 1c3:	83 c2 01             	add    $0x1,%edx
 1c6:	0f be c9             	movsbl %cl,%ecx
 1c9:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 1cd:	0f b6 0a             	movzbl (%edx),%ecx
 1d0:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1d3:	80 fb 09             	cmp    $0x9,%bl
 1d6:	76 e5                	jbe    1bd <atoi+0x3d>
  return sign*n;
 1d8:	0f af c7             	imul   %edi,%eax
}
 1db:	5b                   	pop    %ebx
 1dc:	5e                   	pop    %esi
 1dd:	5f                   	pop    %edi
 1de:	5d                   	pop    %ebp
 1df:	c3                   	ret    

000001e0 <atoo>:

int
atoo(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	56                   	push   %esi
 1e5:	53                   	push   %ebx
 1e6:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1e9:	eb 03                	jmp    1ee <atoo+0xe>
 1eb:	83 c2 01             	add    $0x1,%edx
 1ee:	0f b6 0a             	movzbl (%edx),%ecx
 1f1:	80 f9 20             	cmp    $0x20,%cl
 1f4:	74 f5                	je     1eb <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 1f6:	80 f9 2d             	cmp    $0x2d,%cl
 1f9:	74 23                	je     21e <atoo+0x3e>
 1fb:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 200:	80 f9 2b             	cmp    $0x2b,%cl
 203:	0f 94 c0             	sete   %al
 206:	89 c6                	mov    %eax,%esi
 208:	80 f9 2d             	cmp    $0x2d,%cl
 20b:	0f 94 c0             	sete   %al
 20e:	89 f3                	mov    %esi,%ebx
 210:	08 c3                	or     %al,%bl
 212:	74 03                	je     217 <atoo+0x37>
    s++;
 214:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 217:	b8 00 00 00 00       	mov    $0x0,%eax
 21c:	eb 11                	jmp    22f <atoo+0x4f>
 21e:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 223:	eb db                	jmp    200 <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 225:	83 c2 01             	add    $0x1,%edx
 228:	0f be c9             	movsbl %cl,%ecx
 22b:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 22f:	0f b6 0a             	movzbl (%edx),%ecx
 232:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 235:	80 fb 07             	cmp    $0x7,%bl
 238:	76 eb                	jbe    225 <atoo+0x45>
  return sign*n;
 23a:	0f af c7             	imul   %edi,%eax
}
 23d:	5b                   	pop    %ebx
 23e:	5e                   	pop    %esi
 23f:	5f                   	pop    %edi
 240:	5d                   	pop    %ebp
 241:	c3                   	ret    

00000242 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 242:	55                   	push   %ebp
 243:	89 e5                	mov    %esp,%ebp
 245:	53                   	push   %ebx
 246:	8b 55 08             	mov    0x8(%ebp),%edx
 249:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 24c:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 24f:	eb 09                	jmp    25a <strncmp+0x18>
      n--, p++, q++;
 251:	83 e8 01             	sub    $0x1,%eax
 254:	83 c2 01             	add    $0x1,%edx
 257:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 25a:	85 c0                	test   %eax,%eax
 25c:	74 0b                	je     269 <strncmp+0x27>
 25e:	0f b6 1a             	movzbl (%edx),%ebx
 261:	84 db                	test   %bl,%bl
 263:	74 04                	je     269 <strncmp+0x27>
 265:	3a 19                	cmp    (%ecx),%bl
 267:	74 e8                	je     251 <strncmp+0xf>
    if(n == 0)
 269:	85 c0                	test   %eax,%eax
 26b:	74 0b                	je     278 <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 26d:	0f b6 02             	movzbl (%edx),%eax
 270:	0f b6 11             	movzbl (%ecx),%edx
 273:	29 d0                	sub    %edx,%eax
}
 275:	5b                   	pop    %ebx
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    
      return 0;
 278:	b8 00 00 00 00       	mov    $0x0,%eax
 27d:	eb f6                	jmp    275 <strncmp+0x33>

0000027f <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	56                   	push   %esi
 283:	53                   	push   %ebx
 284:	8b 45 08             	mov    0x8(%ebp),%eax
 287:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 28a:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 28d:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 28f:	eb 0d                	jmp    29e <memmove+0x1f>
    *dst++ = *src++;
 291:	0f b6 13             	movzbl (%ebx),%edx
 294:	88 11                	mov    %dl,(%ecx)
 296:	8d 5b 01             	lea    0x1(%ebx),%ebx
 299:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 29c:	89 f2                	mov    %esi,%edx
 29e:	8d 72 ff             	lea    -0x1(%edx),%esi
 2a1:	85 d2                	test   %edx,%edx
 2a3:	7f ec                	jg     291 <memmove+0x12>
  return vdst;
}
 2a5:	5b                   	pop    %ebx
 2a6:	5e                   	pop    %esi
 2a7:	5d                   	pop    %ebp
 2a8:	c3                   	ret    

000002a9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <exit>:
SYSCALL(exit)
 2b1:	b8 02 00 00 00       	mov    $0x2,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <wait>:
SYSCALL(wait)
 2b9:	b8 03 00 00 00       	mov    $0x3,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <pipe>:
SYSCALL(pipe)
 2c1:	b8 04 00 00 00       	mov    $0x4,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <read>:
SYSCALL(read)
 2c9:	b8 05 00 00 00       	mov    $0x5,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <write>:
SYSCALL(write)
 2d1:	b8 10 00 00 00       	mov    $0x10,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <close>:
SYSCALL(close)
 2d9:	b8 15 00 00 00       	mov    $0x15,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <kill>:
SYSCALL(kill)
 2e1:	b8 06 00 00 00       	mov    $0x6,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <exec>:
SYSCALL(exec)
 2e9:	b8 07 00 00 00       	mov    $0x7,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <open>:
SYSCALL(open)
 2f1:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <mknod>:
SYSCALL(mknod)
 2f9:	b8 11 00 00 00       	mov    $0x11,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <unlink>:
SYSCALL(unlink)
 301:	b8 12 00 00 00       	mov    $0x12,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <fstat>:
SYSCALL(fstat)
 309:	b8 08 00 00 00       	mov    $0x8,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <link>:
SYSCALL(link)
 311:	b8 13 00 00 00       	mov    $0x13,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <mkdir>:
SYSCALL(mkdir)
 319:	b8 14 00 00 00       	mov    $0x14,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <chdir>:
SYSCALL(chdir)
 321:	b8 09 00 00 00       	mov    $0x9,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <dup>:
SYSCALL(dup)
 329:	b8 0a 00 00 00       	mov    $0xa,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <getpid>:
SYSCALL(getpid)
 331:	b8 0b 00 00 00       	mov    $0xb,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <sbrk>:
SYSCALL(sbrk)
 339:	b8 0c 00 00 00       	mov    $0xc,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <sleep>:
SYSCALL(sleep)
 341:	b8 0d 00 00 00       	mov    $0xd,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <uptime>:
SYSCALL(uptime)
 349:	b8 0e 00 00 00       	mov    $0xe,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <halt>:
SYSCALL(halt)
 351:	b8 16 00 00 00       	mov    $0x16,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <date>:
SYSCALL(date)
 359:	b8 17 00 00 00       	mov    $0x17,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 361:	55                   	push   %ebp
 362:	89 e5                	mov    %esp,%ebp
 364:	83 ec 1c             	sub    $0x1c,%esp
 367:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 36a:	6a 01                	push   $0x1
 36c:	8d 55 f4             	lea    -0xc(%ebp),%edx
 36f:	52                   	push   %edx
 370:	50                   	push   %eax
 371:	e8 5b ff ff ff       	call   2d1 <write>
}
 376:	83 c4 10             	add    $0x10,%esp
 379:	c9                   	leave  
 37a:	c3                   	ret    

0000037b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37b:	55                   	push   %ebp
 37c:	89 e5                	mov    %esp,%ebp
 37e:	57                   	push   %edi
 37f:	56                   	push   %esi
 380:	53                   	push   %ebx
 381:	83 ec 2c             	sub    $0x2c,%esp
 384:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 386:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 38a:	0f 95 c3             	setne  %bl
 38d:	89 d0                	mov    %edx,%eax
 38f:	c1 e8 1f             	shr    $0x1f,%eax
 392:	84 c3                	test   %al,%bl
 394:	74 10                	je     3a6 <printint+0x2b>
    neg = 1;
    x = -xx;
 396:	f7 da                	neg    %edx
    neg = 1;
 398:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 39f:	be 00 00 00 00       	mov    $0x0,%esi
 3a4:	eb 0b                	jmp    3b1 <printint+0x36>
  neg = 0;
 3a6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3ad:	eb f0                	jmp    39f <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 3af:	89 c6                	mov    %eax,%esi
 3b1:	89 d0                	mov    %edx,%eax
 3b3:	ba 00 00 00 00       	mov    $0x0,%edx
 3b8:	f7 f1                	div    %ecx
 3ba:	89 c3                	mov    %eax,%ebx
 3bc:	8d 46 01             	lea    0x1(%esi),%eax
 3bf:	0f b6 92 c4 06 00 00 	movzbl 0x6c4(%edx),%edx
 3c6:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 3ca:	89 da                	mov    %ebx,%edx
 3cc:	85 db                	test   %ebx,%ebx
 3ce:	75 df                	jne    3af <printint+0x34>
 3d0:	89 c3                	mov    %eax,%ebx
  if(neg)
 3d2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3d6:	74 16                	je     3ee <printint+0x73>
    buf[i++] = '-';
 3d8:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 3dd:	8d 5e 02             	lea    0x2(%esi),%ebx
 3e0:	eb 0c                	jmp    3ee <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 3e2:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3e7:	89 f8                	mov    %edi,%eax
 3e9:	e8 73 ff ff ff       	call   361 <putc>
  while(--i >= 0)
 3ee:	83 eb 01             	sub    $0x1,%ebx
 3f1:	79 ef                	jns    3e2 <printint+0x67>
}
 3f3:	83 c4 2c             	add    $0x2c,%esp
 3f6:	5b                   	pop    %ebx
 3f7:	5e                   	pop    %esi
 3f8:	5f                   	pop    %edi
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret    

000003fb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3fb:	55                   	push   %ebp
 3fc:	89 e5                	mov    %esp,%ebp
 3fe:	57                   	push   %edi
 3ff:	56                   	push   %esi
 400:	53                   	push   %ebx
 401:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 404:	8d 45 10             	lea    0x10(%ebp),%eax
 407:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 40a:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 40f:	bb 00 00 00 00       	mov    $0x0,%ebx
 414:	eb 14                	jmp    42a <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 416:	89 fa                	mov    %edi,%edx
 418:	8b 45 08             	mov    0x8(%ebp),%eax
 41b:	e8 41 ff ff ff       	call   361 <putc>
 420:	eb 05                	jmp    427 <printf+0x2c>
      }
    } else if(state == '%'){
 422:	83 fe 25             	cmp    $0x25,%esi
 425:	74 25                	je     44c <printf+0x51>
  for(i = 0; fmt[i]; i++){
 427:	83 c3 01             	add    $0x1,%ebx
 42a:	8b 45 0c             	mov    0xc(%ebp),%eax
 42d:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 431:	84 c0                	test   %al,%al
 433:	0f 84 23 01 00 00    	je     55c <printf+0x161>
    c = fmt[i] & 0xff;
 439:	0f be f8             	movsbl %al,%edi
 43c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 43f:	85 f6                	test   %esi,%esi
 441:	75 df                	jne    422 <printf+0x27>
      if(c == '%'){
 443:	83 f8 25             	cmp    $0x25,%eax
 446:	75 ce                	jne    416 <printf+0x1b>
        state = '%';
 448:	89 c6                	mov    %eax,%esi
 44a:	eb db                	jmp    427 <printf+0x2c>
      if(c == 'd'){
 44c:	83 f8 64             	cmp    $0x64,%eax
 44f:	74 49                	je     49a <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 451:	83 f8 78             	cmp    $0x78,%eax
 454:	0f 94 c1             	sete   %cl
 457:	83 f8 70             	cmp    $0x70,%eax
 45a:	0f 94 c2             	sete   %dl
 45d:	08 d1                	or     %dl,%cl
 45f:	75 63                	jne    4c4 <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 461:	83 f8 73             	cmp    $0x73,%eax
 464:	0f 84 84 00 00 00    	je     4ee <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 46a:	83 f8 63             	cmp    $0x63,%eax
 46d:	0f 84 b7 00 00 00    	je     52a <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 473:	83 f8 25             	cmp    $0x25,%eax
 476:	0f 84 cc 00 00 00    	je     548 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 47c:	ba 25 00 00 00       	mov    $0x25,%edx
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	e8 d8 fe ff ff       	call   361 <putc>
        putc(fd, c);
 489:	89 fa                	mov    %edi,%edx
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	e8 ce fe ff ff       	call   361 <putc>
      }
      state = 0;
 493:	be 00 00 00 00       	mov    $0x0,%esi
 498:	eb 8d                	jmp    427 <printf+0x2c>
        printint(fd, *ap, 10, 1);
 49a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 49d:	8b 17                	mov    (%edi),%edx
 49f:	83 ec 0c             	sub    $0xc,%esp
 4a2:	6a 01                	push   $0x1
 4a4:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ac:	e8 ca fe ff ff       	call   37b <printint>
        ap++;
 4b1:	83 c7 04             	add    $0x4,%edi
 4b4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4b7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ba:	be 00 00 00 00       	mov    $0x0,%esi
 4bf:	e9 63 ff ff ff       	jmp    427 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4c7:	8b 17                	mov    (%edi),%edx
 4c9:	83 ec 0c             	sub    $0xc,%esp
 4cc:	6a 00                	push   $0x0
 4ce:	b9 10 00 00 00       	mov    $0x10,%ecx
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	e8 a0 fe ff ff       	call   37b <printint>
        ap++;
 4db:	83 c7 04             	add    $0x4,%edi
 4de:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4e1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4e4:	be 00 00 00 00       	mov    $0x0,%esi
 4e9:	e9 39 ff ff ff       	jmp    427 <printf+0x2c>
        s = (char*)*ap;
 4ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f1:	8b 30                	mov    (%eax),%esi
        ap++;
 4f3:	83 c0 04             	add    $0x4,%eax
 4f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4f9:	85 f6                	test   %esi,%esi
 4fb:	75 28                	jne    525 <printf+0x12a>
          s = "(null)";
 4fd:	be bd 06 00 00       	mov    $0x6bd,%esi
 502:	8b 7d 08             	mov    0x8(%ebp),%edi
 505:	eb 0d                	jmp    514 <printf+0x119>
          putc(fd, *s);
 507:	0f be d2             	movsbl %dl,%edx
 50a:	89 f8                	mov    %edi,%eax
 50c:	e8 50 fe ff ff       	call   361 <putc>
          s++;
 511:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 514:	0f b6 16             	movzbl (%esi),%edx
 517:	84 d2                	test   %dl,%dl
 519:	75 ec                	jne    507 <printf+0x10c>
      state = 0;
 51b:	be 00 00 00 00       	mov    $0x0,%esi
 520:	e9 02 ff ff ff       	jmp    427 <printf+0x2c>
 525:	8b 7d 08             	mov    0x8(%ebp),%edi
 528:	eb ea                	jmp    514 <printf+0x119>
        putc(fd, *ap);
 52a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 52d:	0f be 17             	movsbl (%edi),%edx
 530:	8b 45 08             	mov    0x8(%ebp),%eax
 533:	e8 29 fe ff ff       	call   361 <putc>
        ap++;
 538:	83 c7 04             	add    $0x4,%edi
 53b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 53e:	be 00 00 00 00       	mov    $0x0,%esi
 543:	e9 df fe ff ff       	jmp    427 <printf+0x2c>
        putc(fd, c);
 548:	89 fa                	mov    %edi,%edx
 54a:	8b 45 08             	mov    0x8(%ebp),%eax
 54d:	e8 0f fe ff ff       	call   361 <putc>
      state = 0;
 552:	be 00 00 00 00       	mov    $0x0,%esi
 557:	e9 cb fe ff ff       	jmp    427 <printf+0x2c>
    }
  }
}
 55c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55f:	5b                   	pop    %ebx
 560:	5e                   	pop    %esi
 561:	5f                   	pop    %edi
 562:	5d                   	pop    %ebp
 563:	c3                   	ret    

00000564 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 564:	55                   	push   %ebp
 565:	89 e5                	mov    %esp,%ebp
 567:	57                   	push   %edi
 568:	56                   	push   %esi
 569:	53                   	push   %ebx
 56a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 56d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 570:	a1 c4 09 00 00       	mov    0x9c4,%eax
 575:	eb 02                	jmp    579 <free+0x15>
 577:	89 d0                	mov    %edx,%eax
 579:	39 c8                	cmp    %ecx,%eax
 57b:	73 04                	jae    581 <free+0x1d>
 57d:	39 08                	cmp    %ecx,(%eax)
 57f:	77 12                	ja     593 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 581:	8b 10                	mov    (%eax),%edx
 583:	39 c2                	cmp    %eax,%edx
 585:	77 f0                	ja     577 <free+0x13>
 587:	39 c8                	cmp    %ecx,%eax
 589:	72 08                	jb     593 <free+0x2f>
 58b:	39 ca                	cmp    %ecx,%edx
 58d:	77 04                	ja     593 <free+0x2f>
 58f:	89 d0                	mov    %edx,%eax
 591:	eb e6                	jmp    579 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 593:	8b 73 fc             	mov    -0x4(%ebx),%esi
 596:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 599:	8b 10                	mov    (%eax),%edx
 59b:	39 d7                	cmp    %edx,%edi
 59d:	74 19                	je     5b8 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 59f:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5a2:	8b 50 04             	mov    0x4(%eax),%edx
 5a5:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5a8:	39 ce                	cmp    %ecx,%esi
 5aa:	74 1b                	je     5c7 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5ac:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5ae:	a3 c4 09 00 00       	mov    %eax,0x9c4
}
 5b3:	5b                   	pop    %ebx
 5b4:	5e                   	pop    %esi
 5b5:	5f                   	pop    %edi
 5b6:	5d                   	pop    %ebp
 5b7:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5b8:	03 72 04             	add    0x4(%edx),%esi
 5bb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5be:	8b 10                	mov    (%eax),%edx
 5c0:	8b 12                	mov    (%edx),%edx
 5c2:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5c5:	eb db                	jmp    5a2 <free+0x3e>
    p->s.size += bp->s.size;
 5c7:	03 53 fc             	add    -0x4(%ebx),%edx
 5ca:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5cd:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5d0:	89 10                	mov    %edx,(%eax)
 5d2:	eb da                	jmp    5ae <free+0x4a>

000005d4 <morecore>:

static Header*
morecore(uint nu)
{
 5d4:	55                   	push   %ebp
 5d5:	89 e5                	mov    %esp,%ebp
 5d7:	53                   	push   %ebx
 5d8:	83 ec 04             	sub    $0x4,%esp
 5db:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5dd:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5e2:	77 05                	ja     5e9 <morecore+0x15>
    nu = 4096;
 5e4:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5e9:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5f0:	83 ec 0c             	sub    $0xc,%esp
 5f3:	50                   	push   %eax
 5f4:	e8 40 fd ff ff       	call   339 <sbrk>
  if(p == (char*)-1)
 5f9:	83 c4 10             	add    $0x10,%esp
 5fc:	83 f8 ff             	cmp    $0xffffffff,%eax
 5ff:	74 1c                	je     61d <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 601:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 604:	83 c0 08             	add    $0x8,%eax
 607:	83 ec 0c             	sub    $0xc,%esp
 60a:	50                   	push   %eax
 60b:	e8 54 ff ff ff       	call   564 <free>
  return freep;
 610:	a1 c4 09 00 00       	mov    0x9c4,%eax
 615:	83 c4 10             	add    $0x10,%esp
}
 618:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 61b:	c9                   	leave  
 61c:	c3                   	ret    
    return 0;
 61d:	b8 00 00 00 00       	mov    $0x0,%eax
 622:	eb f4                	jmp    618 <morecore+0x44>

00000624 <malloc>:

void*
malloc(uint nbytes)
{
 624:	55                   	push   %ebp
 625:	89 e5                	mov    %esp,%ebp
 627:	53                   	push   %ebx
 628:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 62b:	8b 45 08             	mov    0x8(%ebp),%eax
 62e:	8d 58 07             	lea    0x7(%eax),%ebx
 631:	c1 eb 03             	shr    $0x3,%ebx
 634:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 637:	8b 0d c4 09 00 00    	mov    0x9c4,%ecx
 63d:	85 c9                	test   %ecx,%ecx
 63f:	74 04                	je     645 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 641:	8b 01                	mov    (%ecx),%eax
 643:	eb 4d                	jmp    692 <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 645:	c7 05 c4 09 00 00 c8 	movl   $0x9c8,0x9c4
 64c:	09 00 00 
 64f:	c7 05 c8 09 00 00 c8 	movl   $0x9c8,0x9c8
 656:	09 00 00 
    base.s.size = 0;
 659:	c7 05 cc 09 00 00 00 	movl   $0x0,0x9cc
 660:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 663:	b9 c8 09 00 00       	mov    $0x9c8,%ecx
 668:	eb d7                	jmp    641 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 66a:	39 da                	cmp    %ebx,%edx
 66c:	74 1a                	je     688 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 66e:	29 da                	sub    %ebx,%edx
 670:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 673:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 676:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 679:	89 0d c4 09 00 00    	mov    %ecx,0x9c4
      return (void*)(p + 1);
 67f:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 682:	83 c4 04             	add    $0x4,%esp
 685:	5b                   	pop    %ebx
 686:	5d                   	pop    %ebp
 687:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 688:	8b 10                	mov    (%eax),%edx
 68a:	89 11                	mov    %edx,(%ecx)
 68c:	eb eb                	jmp    679 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 68e:	89 c1                	mov    %eax,%ecx
 690:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 692:	8b 50 04             	mov    0x4(%eax),%edx
 695:	39 da                	cmp    %ebx,%edx
 697:	73 d1                	jae    66a <malloc+0x46>
    if(p == freep)
 699:	39 05 c4 09 00 00    	cmp    %eax,0x9c4
 69f:	75 ed                	jne    68e <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 6a1:	89 d8                	mov    %ebx,%eax
 6a3:	e8 2c ff ff ff       	call   5d4 <morecore>
 6a8:	85 c0                	test   %eax,%eax
 6aa:	75 e2                	jne    68e <malloc+0x6a>
        return 0;
 6ac:	b8 00 00 00 00       	mov    $0x0,%eax
 6b1:	eb cf                	jmp    682 <malloc+0x5e>
