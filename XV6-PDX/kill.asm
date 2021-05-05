
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "pdx.h"
#endif // PDX_XV6

int
main(int argc, char **argv)
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

  if(argc < 2){
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 07                	jle    25 <main+0x25>
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
  23:	eb 2d                	jmp    52 <main+0x52>
    printf(2, "usage: kill pid...\n");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 c0 06 00 00       	push   $0x6c0
  2d:	6a 02                	push   $0x2
  2f:	e8 d1 03 00 00       	call   405 <printf>
    exit();
  34:	e8 82 02 00 00       	call   2bb <exit>
    kill(atoi(argv[i]));
  39:	83 ec 0c             	sub    $0xc,%esp
  3c:	ff 34 9f             	pushl  (%edi,%ebx,4)
  3f:	e8 46 01 00 00       	call   18a <atoi>
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 9f 02 00 00       	call   2eb <kill>
  for(i=1; i<argc; i++)
  4c:	83 c3 01             	add    $0x1,%ebx
  4f:	83 c4 10             	add    $0x10,%esp
  52:	39 f3                	cmp    %esi,%ebx
  54:	7c e3                	jl     39 <main+0x39>
  exit();
  56:	e8 60 02 00 00       	call   2bb <exit>

0000005b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  5b:	55                   	push   %ebp
  5c:	89 e5                	mov    %esp,%ebp
  5e:	53                   	push   %ebx
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  65:	89 c2                	mov    %eax,%edx
  67:	0f b6 19             	movzbl (%ecx),%ebx
  6a:	88 1a                	mov    %bl,(%edx)
  6c:	8d 52 01             	lea    0x1(%edx),%edx
  6f:	8d 49 01             	lea    0x1(%ecx),%ecx
  72:	84 db                	test   %bl,%bl
  74:	75 f1                	jne    67 <strcpy+0xc>
    ;
  return os;
}
  76:	5b                   	pop    %ebx
  77:	5d                   	pop    %ebp
  78:	c3                   	ret    

00000079 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  82:	eb 06                	jmp    8a <strcmp+0x11>
    p++, q++;
  84:	83 c1 01             	add    $0x1,%ecx
  87:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  8a:	0f b6 01             	movzbl (%ecx),%eax
  8d:	84 c0                	test   %al,%al
  8f:	74 04                	je     95 <strcmp+0x1c>
  91:	3a 02                	cmp    (%edx),%al
  93:	74 ef                	je     84 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  95:	0f b6 c0             	movzbl %al,%eax
  98:	0f b6 12             	movzbl (%edx),%edx
  9b:	29 d0                	sub    %edx,%eax
}
  9d:	5d                   	pop    %ebp
  9e:	c3                   	ret    

0000009f <strlen>:

uint
strlen(char *s)
{
  9f:	55                   	push   %ebp
  a0:	89 e5                	mov    %esp,%ebp
  a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  a5:	ba 00 00 00 00       	mov    $0x0,%edx
  aa:	eb 03                	jmp    af <strlen+0x10>
  ac:	83 c2 01             	add    $0x1,%edx
  af:	89 d0                	mov    %edx,%eax
  b1:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  b5:	75 f5                	jne    ac <strlen+0xd>
    ;
  return n;
}
  b7:	5d                   	pop    %ebp
  b8:	c3                   	ret    

000000b9 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b9:	55                   	push   %ebp
  ba:	89 e5                	mov    %esp,%ebp
  bc:	57                   	push   %edi
  bd:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c0:	89 d7                	mov    %edx,%edi
  c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  c8:	fc                   	cld    
  c9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  cb:	89 d0                	mov    %edx,%eax
  cd:	5f                   	pop    %edi
  ce:	5d                   	pop    %ebp
  cf:	c3                   	ret    

000000d0 <strchr>:

char*
strchr(const char *s, char c)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  da:	0f b6 10             	movzbl (%eax),%edx
  dd:	84 d2                	test   %dl,%dl
  df:	74 09                	je     ea <strchr+0x1a>
    if(*s == c)
  e1:	38 ca                	cmp    %cl,%dl
  e3:	74 0a                	je     ef <strchr+0x1f>
  for(; *s; s++)
  e5:	83 c0 01             	add    $0x1,%eax
  e8:	eb f0                	jmp    da <strchr+0xa>
      return (char*)s;
  return 0;
  ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    

000000f1 <gets>:

char*
gets(char *buf, int max)
{
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	57                   	push   %edi
  f5:	56                   	push   %esi
  f6:	53                   	push   %ebx
  f7:	83 ec 1c             	sub    $0x1c,%esp
  fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fd:	bb 00 00 00 00       	mov    $0x0,%ebx
 102:	8d 73 01             	lea    0x1(%ebx),%esi
 105:	3b 75 0c             	cmp    0xc(%ebp),%esi
 108:	7d 2e                	jge    138 <gets+0x47>
    cc = read(0, &c, 1);
 10a:	83 ec 04             	sub    $0x4,%esp
 10d:	6a 01                	push   $0x1
 10f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 112:	50                   	push   %eax
 113:	6a 00                	push   $0x0
 115:	e8 b9 01 00 00       	call   2d3 <read>
    if(cc < 1)
 11a:	83 c4 10             	add    $0x10,%esp
 11d:	85 c0                	test   %eax,%eax
 11f:	7e 17                	jle    138 <gets+0x47>
      break;
    buf[i++] = c;
 121:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 125:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 128:	3c 0a                	cmp    $0xa,%al
 12a:	0f 94 c2             	sete   %dl
 12d:	3c 0d                	cmp    $0xd,%al
 12f:	0f 94 c0             	sete   %al
    buf[i++] = c;
 132:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 134:	08 c2                	or     %al,%dl
 136:	74 ca                	je     102 <gets+0x11>
      break;
  }
  buf[i] = '\0';
 138:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 13c:	89 f8                	mov    %edi,%eax
 13e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 141:	5b                   	pop    %ebx
 142:	5e                   	pop    %esi
 143:	5f                   	pop    %edi
 144:	5d                   	pop    %ebp
 145:	c3                   	ret    

00000146 <stat>:

int
stat(char *n, struct stat *st)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	56                   	push   %esi
 14a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 14b:	83 ec 08             	sub    $0x8,%esp
 14e:	6a 00                	push   $0x0
 150:	ff 75 08             	pushl  0x8(%ebp)
 153:	e8 a3 01 00 00       	call   2fb <open>
  if(fd < 0)
 158:	83 c4 10             	add    $0x10,%esp
 15b:	85 c0                	test   %eax,%eax
 15d:	78 24                	js     183 <stat+0x3d>
 15f:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 161:	83 ec 08             	sub    $0x8,%esp
 164:	ff 75 0c             	pushl  0xc(%ebp)
 167:	50                   	push   %eax
 168:	e8 a6 01 00 00       	call   313 <fstat>
 16d:	89 c6                	mov    %eax,%esi
  close(fd);
 16f:	89 1c 24             	mov    %ebx,(%esp)
 172:	e8 6c 01 00 00       	call   2e3 <close>
  return r;
 177:	83 c4 10             	add    $0x10,%esp
}
 17a:	89 f0                	mov    %esi,%eax
 17c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 17f:	5b                   	pop    %ebx
 180:	5e                   	pop    %esi
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    
    return -1;
 183:	be ff ff ff ff       	mov    $0xffffffff,%esi
 188:	eb f0                	jmp    17a <stat+0x34>

0000018a <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	57                   	push   %edi
 18e:	56                   	push   %esi
 18f:	53                   	push   %ebx
 190:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 193:	eb 03                	jmp    198 <atoi+0xe>
 195:	83 c2 01             	add    $0x1,%edx
 198:	0f b6 02             	movzbl (%edx),%eax
 19b:	3c 20                	cmp    $0x20,%al
 19d:	74 f6                	je     195 <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 19f:	3c 2d                	cmp    $0x2d,%al
 1a1:	74 1d                	je     1c0 <atoi+0x36>
 1a3:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1a8:	3c 2b                	cmp    $0x2b,%al
 1aa:	0f 94 c1             	sete   %cl
 1ad:	3c 2d                	cmp    $0x2d,%al
 1af:	0f 94 c0             	sete   %al
 1b2:	08 c1                	or     %al,%cl
 1b4:	74 03                	je     1b9 <atoi+0x2f>
    s++;
 1b6:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 1b9:	b8 00 00 00 00       	mov    $0x0,%eax
 1be:	eb 17                	jmp    1d7 <atoi+0x4d>
 1c0:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 1c5:	eb e1                	jmp    1a8 <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 1c7:	8d 34 80             	lea    (%eax,%eax,4),%esi
 1ca:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 1cd:	83 c2 01             	add    $0x1,%edx
 1d0:	0f be c9             	movsbl %cl,%ecx
 1d3:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 1d7:	0f b6 0a             	movzbl (%edx),%ecx
 1da:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1dd:	80 fb 09             	cmp    $0x9,%bl
 1e0:	76 e5                	jbe    1c7 <atoi+0x3d>
  return sign*n;
 1e2:	0f af c7             	imul   %edi,%eax
}
 1e5:	5b                   	pop    %ebx
 1e6:	5e                   	pop    %esi
 1e7:	5f                   	pop    %edi
 1e8:	5d                   	pop    %ebp
 1e9:	c3                   	ret    

000001ea <atoo>:

int
atoo(const char *s)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	57                   	push   %edi
 1ee:	56                   	push   %esi
 1ef:	53                   	push   %ebx
 1f0:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1f3:	eb 03                	jmp    1f8 <atoo+0xe>
 1f5:	83 c2 01             	add    $0x1,%edx
 1f8:	0f b6 0a             	movzbl (%edx),%ecx
 1fb:	80 f9 20             	cmp    $0x20,%cl
 1fe:	74 f5                	je     1f5 <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 200:	80 f9 2d             	cmp    $0x2d,%cl
 203:	74 23                	je     228 <atoo+0x3e>
 205:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 20a:	80 f9 2b             	cmp    $0x2b,%cl
 20d:	0f 94 c0             	sete   %al
 210:	89 c6                	mov    %eax,%esi
 212:	80 f9 2d             	cmp    $0x2d,%cl
 215:	0f 94 c0             	sete   %al
 218:	89 f3                	mov    %esi,%ebx
 21a:	08 c3                	or     %al,%bl
 21c:	74 03                	je     221 <atoo+0x37>
    s++;
 21e:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 221:	b8 00 00 00 00       	mov    $0x0,%eax
 226:	eb 11                	jmp    239 <atoo+0x4f>
 228:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 22d:	eb db                	jmp    20a <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 22f:	83 c2 01             	add    $0x1,%edx
 232:	0f be c9             	movsbl %cl,%ecx
 235:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 239:	0f b6 0a             	movzbl (%edx),%ecx
 23c:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 23f:	80 fb 07             	cmp    $0x7,%bl
 242:	76 eb                	jbe    22f <atoo+0x45>
  return sign*n;
 244:	0f af c7             	imul   %edi,%eax
}
 247:	5b                   	pop    %ebx
 248:	5e                   	pop    %esi
 249:	5f                   	pop    %edi
 24a:	5d                   	pop    %ebp
 24b:	c3                   	ret    

0000024c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 24c:	55                   	push   %ebp
 24d:	89 e5                	mov    %esp,%ebp
 24f:	53                   	push   %ebx
 250:	8b 55 08             	mov    0x8(%ebp),%edx
 253:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 256:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 259:	eb 09                	jmp    264 <strncmp+0x18>
      n--, p++, q++;
 25b:	83 e8 01             	sub    $0x1,%eax
 25e:	83 c2 01             	add    $0x1,%edx
 261:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 264:	85 c0                	test   %eax,%eax
 266:	74 0b                	je     273 <strncmp+0x27>
 268:	0f b6 1a             	movzbl (%edx),%ebx
 26b:	84 db                	test   %bl,%bl
 26d:	74 04                	je     273 <strncmp+0x27>
 26f:	3a 19                	cmp    (%ecx),%bl
 271:	74 e8                	je     25b <strncmp+0xf>
    if(n == 0)
 273:	85 c0                	test   %eax,%eax
 275:	74 0b                	je     282 <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 277:	0f b6 02             	movzbl (%edx),%eax
 27a:	0f b6 11             	movzbl (%ecx),%edx
 27d:	29 d0                	sub    %edx,%eax
}
 27f:	5b                   	pop    %ebx
 280:	5d                   	pop    %ebp
 281:	c3                   	ret    
      return 0;
 282:	b8 00 00 00 00       	mov    $0x0,%eax
 287:	eb f6                	jmp    27f <strncmp+0x33>

00000289 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	56                   	push   %esi
 28d:	53                   	push   %ebx
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 294:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 297:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 299:	eb 0d                	jmp    2a8 <memmove+0x1f>
    *dst++ = *src++;
 29b:	0f b6 13             	movzbl (%ebx),%edx
 29e:	88 11                	mov    %dl,(%ecx)
 2a0:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2a3:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 2a6:	89 f2                	mov    %esi,%edx
 2a8:	8d 72 ff             	lea    -0x1(%edx),%esi
 2ab:	85 d2                	test   %edx,%edx
 2ad:	7f ec                	jg     29b <memmove+0x12>
  return vdst;
}
 2af:	5b                   	pop    %ebx
 2b0:	5e                   	pop    %esi
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    

000002b3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b3:	b8 01 00 00 00       	mov    $0x1,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <exit>:
SYSCALL(exit)
 2bb:	b8 02 00 00 00       	mov    $0x2,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <wait>:
SYSCALL(wait)
 2c3:	b8 03 00 00 00       	mov    $0x3,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <pipe>:
SYSCALL(pipe)
 2cb:	b8 04 00 00 00       	mov    $0x4,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <read>:
SYSCALL(read)
 2d3:	b8 05 00 00 00       	mov    $0x5,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <write>:
SYSCALL(write)
 2db:	b8 10 00 00 00       	mov    $0x10,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <close>:
SYSCALL(close)
 2e3:	b8 15 00 00 00       	mov    $0x15,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <kill>:
SYSCALL(kill)
 2eb:	b8 06 00 00 00       	mov    $0x6,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <exec>:
SYSCALL(exec)
 2f3:	b8 07 00 00 00       	mov    $0x7,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <open>:
SYSCALL(open)
 2fb:	b8 0f 00 00 00       	mov    $0xf,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <mknod>:
SYSCALL(mknod)
 303:	b8 11 00 00 00       	mov    $0x11,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <unlink>:
SYSCALL(unlink)
 30b:	b8 12 00 00 00       	mov    $0x12,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <fstat>:
SYSCALL(fstat)
 313:	b8 08 00 00 00       	mov    $0x8,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <link>:
SYSCALL(link)
 31b:	b8 13 00 00 00       	mov    $0x13,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <mkdir>:
SYSCALL(mkdir)
 323:	b8 14 00 00 00       	mov    $0x14,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <chdir>:
SYSCALL(chdir)
 32b:	b8 09 00 00 00       	mov    $0x9,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <dup>:
SYSCALL(dup)
 333:	b8 0a 00 00 00       	mov    $0xa,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <getpid>:
SYSCALL(getpid)
 33b:	b8 0b 00 00 00       	mov    $0xb,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <sbrk>:
SYSCALL(sbrk)
 343:	b8 0c 00 00 00       	mov    $0xc,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <sleep>:
SYSCALL(sleep)
 34b:	b8 0d 00 00 00       	mov    $0xd,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <uptime>:
SYSCALL(uptime)
 353:	b8 0e 00 00 00       	mov    $0xe,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <halt>:
SYSCALL(halt)
 35b:	b8 16 00 00 00       	mov    $0x16,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <date>:
SYSCALL(date)
 363:	b8 17 00 00 00       	mov    $0x17,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	83 ec 1c             	sub    $0x1c,%esp
 371:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 374:	6a 01                	push   $0x1
 376:	8d 55 f4             	lea    -0xc(%ebp),%edx
 379:	52                   	push   %edx
 37a:	50                   	push   %eax
 37b:	e8 5b ff ff ff       	call   2db <write>
}
 380:	83 c4 10             	add    $0x10,%esp
 383:	c9                   	leave  
 384:	c3                   	ret    

00000385 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 385:	55                   	push   %ebp
 386:	89 e5                	mov    %esp,%ebp
 388:	57                   	push   %edi
 389:	56                   	push   %esi
 38a:	53                   	push   %ebx
 38b:	83 ec 2c             	sub    $0x2c,%esp
 38e:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 390:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 394:	0f 95 c3             	setne  %bl
 397:	89 d0                	mov    %edx,%eax
 399:	c1 e8 1f             	shr    $0x1f,%eax
 39c:	84 c3                	test   %al,%bl
 39e:	74 10                	je     3b0 <printint+0x2b>
    neg = 1;
    x = -xx;
 3a0:	f7 da                	neg    %edx
    neg = 1;
 3a2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3a9:	be 00 00 00 00       	mov    $0x0,%esi
 3ae:	eb 0b                	jmp    3bb <printint+0x36>
  neg = 0;
 3b0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3b7:	eb f0                	jmp    3a9 <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 3b9:	89 c6                	mov    %eax,%esi
 3bb:	89 d0                	mov    %edx,%eax
 3bd:	ba 00 00 00 00       	mov    $0x0,%edx
 3c2:	f7 f1                	div    %ecx
 3c4:	89 c3                	mov    %eax,%ebx
 3c6:	8d 46 01             	lea    0x1(%esi),%eax
 3c9:	0f b6 92 dc 06 00 00 	movzbl 0x6dc(%edx),%edx
 3d0:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 3d4:	89 da                	mov    %ebx,%edx
 3d6:	85 db                	test   %ebx,%ebx
 3d8:	75 df                	jne    3b9 <printint+0x34>
 3da:	89 c3                	mov    %eax,%ebx
  if(neg)
 3dc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3e0:	74 16                	je     3f8 <printint+0x73>
    buf[i++] = '-';
 3e2:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 3e7:	8d 5e 02             	lea    0x2(%esi),%ebx
 3ea:	eb 0c                	jmp    3f8 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 3ec:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3f1:	89 f8                	mov    %edi,%eax
 3f3:	e8 73 ff ff ff       	call   36b <putc>
  while(--i >= 0)
 3f8:	83 eb 01             	sub    $0x1,%ebx
 3fb:	79 ef                	jns    3ec <printint+0x67>
}
 3fd:	83 c4 2c             	add    $0x2c,%esp
 400:	5b                   	pop    %ebx
 401:	5e                   	pop    %esi
 402:	5f                   	pop    %edi
 403:	5d                   	pop    %ebp
 404:	c3                   	ret    

00000405 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 405:	55                   	push   %ebp
 406:	89 e5                	mov    %esp,%ebp
 408:	57                   	push   %edi
 409:	56                   	push   %esi
 40a:	53                   	push   %ebx
 40b:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 40e:	8d 45 10             	lea    0x10(%ebp),%eax
 411:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 414:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 419:	bb 00 00 00 00       	mov    $0x0,%ebx
 41e:	eb 14                	jmp    434 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 420:	89 fa                	mov    %edi,%edx
 422:	8b 45 08             	mov    0x8(%ebp),%eax
 425:	e8 41 ff ff ff       	call   36b <putc>
 42a:	eb 05                	jmp    431 <printf+0x2c>
      }
    } else if(state == '%'){
 42c:	83 fe 25             	cmp    $0x25,%esi
 42f:	74 25                	je     456 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 431:	83 c3 01             	add    $0x1,%ebx
 434:	8b 45 0c             	mov    0xc(%ebp),%eax
 437:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 43b:	84 c0                	test   %al,%al
 43d:	0f 84 23 01 00 00    	je     566 <printf+0x161>
    c = fmt[i] & 0xff;
 443:	0f be f8             	movsbl %al,%edi
 446:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 449:	85 f6                	test   %esi,%esi
 44b:	75 df                	jne    42c <printf+0x27>
      if(c == '%'){
 44d:	83 f8 25             	cmp    $0x25,%eax
 450:	75 ce                	jne    420 <printf+0x1b>
        state = '%';
 452:	89 c6                	mov    %eax,%esi
 454:	eb db                	jmp    431 <printf+0x2c>
      if(c == 'd'){
 456:	83 f8 64             	cmp    $0x64,%eax
 459:	74 49                	je     4a4 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 45b:	83 f8 78             	cmp    $0x78,%eax
 45e:	0f 94 c1             	sete   %cl
 461:	83 f8 70             	cmp    $0x70,%eax
 464:	0f 94 c2             	sete   %dl
 467:	08 d1                	or     %dl,%cl
 469:	75 63                	jne    4ce <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 46b:	83 f8 73             	cmp    $0x73,%eax
 46e:	0f 84 84 00 00 00    	je     4f8 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 474:	83 f8 63             	cmp    $0x63,%eax
 477:	0f 84 b7 00 00 00    	je     534 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 47d:	83 f8 25             	cmp    $0x25,%eax
 480:	0f 84 cc 00 00 00    	je     552 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 486:	ba 25 00 00 00       	mov    $0x25,%edx
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	e8 d8 fe ff ff       	call   36b <putc>
        putc(fd, c);
 493:	89 fa                	mov    %edi,%edx
 495:	8b 45 08             	mov    0x8(%ebp),%eax
 498:	e8 ce fe ff ff       	call   36b <putc>
      }
      state = 0;
 49d:	be 00 00 00 00       	mov    $0x0,%esi
 4a2:	eb 8d                	jmp    431 <printf+0x2c>
        printint(fd, *ap, 10, 1);
 4a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4a7:	8b 17                	mov    (%edi),%edx
 4a9:	83 ec 0c             	sub    $0xc,%esp
 4ac:	6a 01                	push   $0x1
 4ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	e8 ca fe ff ff       	call   385 <printint>
        ap++;
 4bb:	83 c7 04             	add    $0x4,%edi
 4be:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4c1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c4:	be 00 00 00 00       	mov    $0x0,%esi
 4c9:	e9 63 ff ff ff       	jmp    431 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4d1:	8b 17                	mov    (%edi),%edx
 4d3:	83 ec 0c             	sub    $0xc,%esp
 4d6:	6a 00                	push   $0x0
 4d8:	b9 10 00 00 00       	mov    $0x10,%ecx
 4dd:	8b 45 08             	mov    0x8(%ebp),%eax
 4e0:	e8 a0 fe ff ff       	call   385 <printint>
        ap++;
 4e5:	83 c7 04             	add    $0x4,%edi
 4e8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4eb:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ee:	be 00 00 00 00       	mov    $0x0,%esi
 4f3:	e9 39 ff ff ff       	jmp    431 <printf+0x2c>
        s = (char*)*ap;
 4f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4fb:	8b 30                	mov    (%eax),%esi
        ap++;
 4fd:	83 c0 04             	add    $0x4,%eax
 500:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 503:	85 f6                	test   %esi,%esi
 505:	75 28                	jne    52f <printf+0x12a>
          s = "(null)";
 507:	be d4 06 00 00       	mov    $0x6d4,%esi
 50c:	8b 7d 08             	mov    0x8(%ebp),%edi
 50f:	eb 0d                	jmp    51e <printf+0x119>
          putc(fd, *s);
 511:	0f be d2             	movsbl %dl,%edx
 514:	89 f8                	mov    %edi,%eax
 516:	e8 50 fe ff ff       	call   36b <putc>
          s++;
 51b:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 51e:	0f b6 16             	movzbl (%esi),%edx
 521:	84 d2                	test   %dl,%dl
 523:	75 ec                	jne    511 <printf+0x10c>
      state = 0;
 525:	be 00 00 00 00       	mov    $0x0,%esi
 52a:	e9 02 ff ff ff       	jmp    431 <printf+0x2c>
 52f:	8b 7d 08             	mov    0x8(%ebp),%edi
 532:	eb ea                	jmp    51e <printf+0x119>
        putc(fd, *ap);
 534:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 537:	0f be 17             	movsbl (%edi),%edx
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	e8 29 fe ff ff       	call   36b <putc>
        ap++;
 542:	83 c7 04             	add    $0x4,%edi
 545:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 548:	be 00 00 00 00       	mov    $0x0,%esi
 54d:	e9 df fe ff ff       	jmp    431 <printf+0x2c>
        putc(fd, c);
 552:	89 fa                	mov    %edi,%edx
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	e8 0f fe ff ff       	call   36b <putc>
      state = 0;
 55c:	be 00 00 00 00       	mov    $0x0,%esi
 561:	e9 cb fe ff ff       	jmp    431 <printf+0x2c>
    }
  }
}
 566:	8d 65 f4             	lea    -0xc(%ebp),%esp
 569:	5b                   	pop    %ebx
 56a:	5e                   	pop    %esi
 56b:	5f                   	pop    %edi
 56c:	5d                   	pop    %ebp
 56d:	c3                   	ret    

0000056e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 56e:	55                   	push   %ebp
 56f:	89 e5                	mov    %esp,%ebp
 571:	57                   	push   %edi
 572:	56                   	push   %esi
 573:	53                   	push   %ebx
 574:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 577:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 57a:	a1 dc 09 00 00       	mov    0x9dc,%eax
 57f:	eb 02                	jmp    583 <free+0x15>
 581:	89 d0                	mov    %edx,%eax
 583:	39 c8                	cmp    %ecx,%eax
 585:	73 04                	jae    58b <free+0x1d>
 587:	39 08                	cmp    %ecx,(%eax)
 589:	77 12                	ja     59d <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 58b:	8b 10                	mov    (%eax),%edx
 58d:	39 c2                	cmp    %eax,%edx
 58f:	77 f0                	ja     581 <free+0x13>
 591:	39 c8                	cmp    %ecx,%eax
 593:	72 08                	jb     59d <free+0x2f>
 595:	39 ca                	cmp    %ecx,%edx
 597:	77 04                	ja     59d <free+0x2f>
 599:	89 d0                	mov    %edx,%eax
 59b:	eb e6                	jmp    583 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 59d:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a0:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5a3:	8b 10                	mov    (%eax),%edx
 5a5:	39 d7                	cmp    %edx,%edi
 5a7:	74 19                	je     5c2 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5a9:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ac:	8b 50 04             	mov    0x4(%eax),%edx
 5af:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5b2:	39 ce                	cmp    %ecx,%esi
 5b4:	74 1b                	je     5d1 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5b6:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5b8:	a3 dc 09 00 00       	mov    %eax,0x9dc
}
 5bd:	5b                   	pop    %ebx
 5be:	5e                   	pop    %esi
 5bf:	5f                   	pop    %edi
 5c0:	5d                   	pop    %ebp
 5c1:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5c2:	03 72 04             	add    0x4(%edx),%esi
 5c5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5c8:	8b 10                	mov    (%eax),%edx
 5ca:	8b 12                	mov    (%edx),%edx
 5cc:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5cf:	eb db                	jmp    5ac <free+0x3e>
    p->s.size += bp->s.size;
 5d1:	03 53 fc             	add    -0x4(%ebx),%edx
 5d4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5d7:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5da:	89 10                	mov    %edx,(%eax)
 5dc:	eb da                	jmp    5b8 <free+0x4a>

000005de <morecore>:

static Header*
morecore(uint nu)
{
 5de:	55                   	push   %ebp
 5df:	89 e5                	mov    %esp,%ebp
 5e1:	53                   	push   %ebx
 5e2:	83 ec 04             	sub    $0x4,%esp
 5e5:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5e7:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5ec:	77 05                	ja     5f3 <morecore+0x15>
    nu = 4096;
 5ee:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5f3:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5fa:	83 ec 0c             	sub    $0xc,%esp
 5fd:	50                   	push   %eax
 5fe:	e8 40 fd ff ff       	call   343 <sbrk>
  if(p == (char*)-1)
 603:	83 c4 10             	add    $0x10,%esp
 606:	83 f8 ff             	cmp    $0xffffffff,%eax
 609:	74 1c                	je     627 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 60b:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 60e:	83 c0 08             	add    $0x8,%eax
 611:	83 ec 0c             	sub    $0xc,%esp
 614:	50                   	push   %eax
 615:	e8 54 ff ff ff       	call   56e <free>
  return freep;
 61a:	a1 dc 09 00 00       	mov    0x9dc,%eax
 61f:	83 c4 10             	add    $0x10,%esp
}
 622:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 625:	c9                   	leave  
 626:	c3                   	ret    
    return 0;
 627:	b8 00 00 00 00       	mov    $0x0,%eax
 62c:	eb f4                	jmp    622 <morecore+0x44>

0000062e <malloc>:

void*
malloc(uint nbytes)
{
 62e:	55                   	push   %ebp
 62f:	89 e5                	mov    %esp,%ebp
 631:	53                   	push   %ebx
 632:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	8d 58 07             	lea    0x7(%eax),%ebx
 63b:	c1 eb 03             	shr    $0x3,%ebx
 63e:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 641:	8b 0d dc 09 00 00    	mov    0x9dc,%ecx
 647:	85 c9                	test   %ecx,%ecx
 649:	74 04                	je     64f <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 64b:	8b 01                	mov    (%ecx),%eax
 64d:	eb 4d                	jmp    69c <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 64f:	c7 05 dc 09 00 00 e0 	movl   $0x9e0,0x9dc
 656:	09 00 00 
 659:	c7 05 e0 09 00 00 e0 	movl   $0x9e0,0x9e0
 660:	09 00 00 
    base.s.size = 0;
 663:	c7 05 e4 09 00 00 00 	movl   $0x0,0x9e4
 66a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 66d:	b9 e0 09 00 00       	mov    $0x9e0,%ecx
 672:	eb d7                	jmp    64b <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 674:	39 da                	cmp    %ebx,%edx
 676:	74 1a                	je     692 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 678:	29 da                	sub    %ebx,%edx
 67a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 67d:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 680:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 683:	89 0d dc 09 00 00    	mov    %ecx,0x9dc
      return (void*)(p + 1);
 689:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 68c:	83 c4 04             	add    $0x4,%esp
 68f:	5b                   	pop    %ebx
 690:	5d                   	pop    %ebp
 691:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 692:	8b 10                	mov    (%eax),%edx
 694:	89 11                	mov    %edx,(%ecx)
 696:	eb eb                	jmp    683 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 698:	89 c1                	mov    %eax,%ecx
 69a:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 69c:	8b 50 04             	mov    0x4(%eax),%edx
 69f:	39 da                	cmp    %ebx,%edx
 6a1:	73 d1                	jae    674 <malloc+0x46>
    if(p == freep)
 6a3:	39 05 dc 09 00 00    	cmp    %eax,0x9dc
 6a9:	75 ed                	jne    698 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 6ab:	89 d8                	mov    %ebx,%eax
 6ad:	e8 2c ff ff ff       	call   5de <morecore>
 6b2:	85 c0                	test   %eax,%eax
 6b4:	75 e2                	jne    698 <malloc+0x6a>
        return 0;
 6b6:	b8 00 00 00 00       	mov    $0x0,%eax
 6bb:	eb cf                	jmp    68c <malloc+0x5e>
