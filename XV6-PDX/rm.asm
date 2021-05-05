
_rm:     file format elf32-i386


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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  19:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  1c:	83 f8 01             	cmp    $0x1,%eax
  1f:	7e 23                	jle    44 <main+0x44>
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  21:	bb 01 00 00 00       	mov    $0x1,%ebx
  26:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  29:	7d 41                	jge    6c <main+0x6c>
    if(unlink(argv[i]) < 0){
  2b:	8d 34 9f             	lea    (%edi,%ebx,4),%esi
  2e:	83 ec 0c             	sub    $0xc,%esp
  31:	ff 36                	pushl  (%esi)
  33:	e8 e9 02 00 00       	call   321 <unlink>
  38:	83 c4 10             	add    $0x10,%esp
  3b:	85 c0                	test   %eax,%eax
  3d:	78 19                	js     58 <main+0x58>
  for(i = 1; i < argc; i++){
  3f:	83 c3 01             	add    $0x1,%ebx
  42:	eb e2                	jmp    26 <main+0x26>
    printf(2, "Usage: rm files...\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 d4 06 00 00       	push   $0x6d4
  4c:	6a 02                	push   $0x2
  4e:	e8 c8 03 00 00       	call   41b <printf>
    exit();
  53:	e8 79 02 00 00       	call   2d1 <exit>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  58:	83 ec 04             	sub    $0x4,%esp
  5b:	ff 36                	pushl  (%esi)
  5d:	68 e8 06 00 00       	push   $0x6e8
  62:	6a 02                	push   $0x2
  64:	e8 b2 03 00 00       	call   41b <printf>
      break;
  69:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  6c:	e8 60 02 00 00       	call   2d1 <exit>

00000071 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  71:	55                   	push   %ebp
  72:	89 e5                	mov    %esp,%ebp
  74:	53                   	push   %ebx
  75:	8b 45 08             	mov    0x8(%ebp),%eax
  78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7b:	89 c2                	mov    %eax,%edx
  7d:	0f b6 19             	movzbl (%ecx),%ebx
  80:	88 1a                	mov    %bl,(%edx)
  82:	8d 52 01             	lea    0x1(%edx),%edx
  85:	8d 49 01             	lea    0x1(%ecx),%ecx
  88:	84 db                	test   %bl,%bl
  8a:	75 f1                	jne    7d <strcpy+0xc>
    ;
  return os;
}
  8c:	5b                   	pop    %ebx
  8d:	5d                   	pop    %ebp
  8e:	c3                   	ret    

0000008f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	8b 4d 08             	mov    0x8(%ebp),%ecx
  95:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  98:	eb 06                	jmp    a0 <strcmp+0x11>
    p++, q++;
  9a:	83 c1 01             	add    $0x1,%ecx
  9d:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  a0:	0f b6 01             	movzbl (%ecx),%eax
  a3:	84 c0                	test   %al,%al
  a5:	74 04                	je     ab <strcmp+0x1c>
  a7:	3a 02                	cmp    (%edx),%al
  a9:	74 ef                	je     9a <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  ab:	0f b6 c0             	movzbl %al,%eax
  ae:	0f b6 12             	movzbl (%edx),%edx
  b1:	29 d0                	sub    %edx,%eax
}
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strlen>:

uint
strlen(char *s)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  bb:	ba 00 00 00 00       	mov    $0x0,%edx
  c0:	eb 03                	jmp    c5 <strlen+0x10>
  c2:	83 c2 01             	add    $0x1,%edx
  c5:	89 d0                	mov    %edx,%eax
  c7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  cb:	75 f5                	jne    c2 <strlen+0xd>
    ;
  return n;
}
  cd:	5d                   	pop    %ebp
  ce:	c3                   	ret    

000000cf <memset>:

void*
memset(void *dst, int c, uint n)
{
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  d2:	57                   	push   %edi
  d3:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d6:	89 d7                	mov    %edx,%edi
  d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  db:	8b 45 0c             	mov    0xc(%ebp),%eax
  de:	fc                   	cld    
  df:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e1:	89 d0                	mov    %edx,%eax
  e3:	5f                   	pop    %edi
  e4:	5d                   	pop    %ebp
  e5:	c3                   	ret    

000000e6 <strchr>:

char*
strchr(const char *s, char c)
{
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  e9:	8b 45 08             	mov    0x8(%ebp),%eax
  ec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  f0:	0f b6 10             	movzbl (%eax),%edx
  f3:	84 d2                	test   %dl,%dl
  f5:	74 09                	je     100 <strchr+0x1a>
    if(*s == c)
  f7:	38 ca                	cmp    %cl,%dl
  f9:	74 0a                	je     105 <strchr+0x1f>
  for(; *s; s++)
  fb:	83 c0 01             	add    $0x1,%eax
  fe:	eb f0                	jmp    f0 <strchr+0xa>
      return (char*)s;
  return 0;
 100:	b8 00 00 00 00       	mov    $0x0,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <gets>:

char*
gets(char *buf, int max)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	57                   	push   %edi
 10b:	56                   	push   %esi
 10c:	53                   	push   %ebx
 10d:	83 ec 1c             	sub    $0x1c,%esp
 110:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 113:	bb 00 00 00 00       	mov    $0x0,%ebx
 118:	8d 73 01             	lea    0x1(%ebx),%esi
 11b:	3b 75 0c             	cmp    0xc(%ebp),%esi
 11e:	7d 2e                	jge    14e <gets+0x47>
    cc = read(0, &c, 1);
 120:	83 ec 04             	sub    $0x4,%esp
 123:	6a 01                	push   $0x1
 125:	8d 45 e7             	lea    -0x19(%ebp),%eax
 128:	50                   	push   %eax
 129:	6a 00                	push   $0x0
 12b:	e8 b9 01 00 00       	call   2e9 <read>
    if(cc < 1)
 130:	83 c4 10             	add    $0x10,%esp
 133:	85 c0                	test   %eax,%eax
 135:	7e 17                	jle    14e <gets+0x47>
      break;
    buf[i++] = c;
 137:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 13b:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 13e:	3c 0a                	cmp    $0xa,%al
 140:	0f 94 c2             	sete   %dl
 143:	3c 0d                	cmp    $0xd,%al
 145:	0f 94 c0             	sete   %al
    buf[i++] = c;
 148:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 14a:	08 c2                	or     %al,%dl
 14c:	74 ca                	je     118 <gets+0x11>
      break;
  }
  buf[i] = '\0';
 14e:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 152:	89 f8                	mov    %edi,%eax
 154:	8d 65 f4             	lea    -0xc(%ebp),%esp
 157:	5b                   	pop    %ebx
 158:	5e                   	pop    %esi
 159:	5f                   	pop    %edi
 15a:	5d                   	pop    %ebp
 15b:	c3                   	ret    

0000015c <stat>:

int
stat(char *n, struct stat *st)
{
 15c:	55                   	push   %ebp
 15d:	89 e5                	mov    %esp,%ebp
 15f:	56                   	push   %esi
 160:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 161:	83 ec 08             	sub    $0x8,%esp
 164:	6a 00                	push   $0x0
 166:	ff 75 08             	pushl  0x8(%ebp)
 169:	e8 a3 01 00 00       	call   311 <open>
  if(fd < 0)
 16e:	83 c4 10             	add    $0x10,%esp
 171:	85 c0                	test   %eax,%eax
 173:	78 24                	js     199 <stat+0x3d>
 175:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 177:	83 ec 08             	sub    $0x8,%esp
 17a:	ff 75 0c             	pushl  0xc(%ebp)
 17d:	50                   	push   %eax
 17e:	e8 a6 01 00 00       	call   329 <fstat>
 183:	89 c6                	mov    %eax,%esi
  close(fd);
 185:	89 1c 24             	mov    %ebx,(%esp)
 188:	e8 6c 01 00 00       	call   2f9 <close>
  return r;
 18d:	83 c4 10             	add    $0x10,%esp
}
 190:	89 f0                	mov    %esi,%eax
 192:	8d 65 f8             	lea    -0x8(%ebp),%esp
 195:	5b                   	pop    %ebx
 196:	5e                   	pop    %esi
 197:	5d                   	pop    %ebp
 198:	c3                   	ret    
    return -1;
 199:	be ff ff ff ff       	mov    $0xffffffff,%esi
 19e:	eb f0                	jmp    190 <stat+0x34>

000001a0 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	56                   	push   %esi
 1a5:	53                   	push   %ebx
 1a6:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1a9:	eb 03                	jmp    1ae <atoi+0xe>
 1ab:	83 c2 01             	add    $0x1,%edx
 1ae:	0f b6 02             	movzbl (%edx),%eax
 1b1:	3c 20                	cmp    $0x20,%al
 1b3:	74 f6                	je     1ab <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 1b5:	3c 2d                	cmp    $0x2d,%al
 1b7:	74 1d                	je     1d6 <atoi+0x36>
 1b9:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1be:	3c 2b                	cmp    $0x2b,%al
 1c0:	0f 94 c1             	sete   %cl
 1c3:	3c 2d                	cmp    $0x2d,%al
 1c5:	0f 94 c0             	sete   %al
 1c8:	08 c1                	or     %al,%cl
 1ca:	74 03                	je     1cf <atoi+0x2f>
    s++;
 1cc:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 1cf:	b8 00 00 00 00       	mov    $0x0,%eax
 1d4:	eb 17                	jmp    1ed <atoi+0x4d>
 1d6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 1db:	eb e1                	jmp    1be <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 1dd:	8d 34 80             	lea    (%eax,%eax,4),%esi
 1e0:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 1e3:	83 c2 01             	add    $0x1,%edx
 1e6:	0f be c9             	movsbl %cl,%ecx
 1e9:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 1ed:	0f b6 0a             	movzbl (%edx),%ecx
 1f0:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1f3:	80 fb 09             	cmp    $0x9,%bl
 1f6:	76 e5                	jbe    1dd <atoi+0x3d>
  return sign*n;
 1f8:	0f af c7             	imul   %edi,%eax
}
 1fb:	5b                   	pop    %ebx
 1fc:	5e                   	pop    %esi
 1fd:	5f                   	pop    %edi
 1fe:	5d                   	pop    %ebp
 1ff:	c3                   	ret    

00000200 <atoo>:

int
atoo(const char *s)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	57                   	push   %edi
 204:	56                   	push   %esi
 205:	53                   	push   %ebx
 206:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 209:	eb 03                	jmp    20e <atoo+0xe>
 20b:	83 c2 01             	add    $0x1,%edx
 20e:	0f b6 0a             	movzbl (%edx),%ecx
 211:	80 f9 20             	cmp    $0x20,%cl
 214:	74 f5                	je     20b <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 216:	80 f9 2d             	cmp    $0x2d,%cl
 219:	74 23                	je     23e <atoo+0x3e>
 21b:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 220:	80 f9 2b             	cmp    $0x2b,%cl
 223:	0f 94 c0             	sete   %al
 226:	89 c6                	mov    %eax,%esi
 228:	80 f9 2d             	cmp    $0x2d,%cl
 22b:	0f 94 c0             	sete   %al
 22e:	89 f3                	mov    %esi,%ebx
 230:	08 c3                	or     %al,%bl
 232:	74 03                	je     237 <atoo+0x37>
    s++;
 234:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 237:	b8 00 00 00 00       	mov    $0x0,%eax
 23c:	eb 11                	jmp    24f <atoo+0x4f>
 23e:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 243:	eb db                	jmp    220 <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 245:	83 c2 01             	add    $0x1,%edx
 248:	0f be c9             	movsbl %cl,%ecx
 24b:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 24f:	0f b6 0a             	movzbl (%edx),%ecx
 252:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 255:	80 fb 07             	cmp    $0x7,%bl
 258:	76 eb                	jbe    245 <atoo+0x45>
  return sign*n;
 25a:	0f af c7             	imul   %edi,%eax
}
 25d:	5b                   	pop    %ebx
 25e:	5e                   	pop    %esi
 25f:	5f                   	pop    %edi
 260:	5d                   	pop    %ebp
 261:	c3                   	ret    

00000262 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 262:	55                   	push   %ebp
 263:	89 e5                	mov    %esp,%ebp
 265:	53                   	push   %ebx
 266:	8b 55 08             	mov    0x8(%ebp),%edx
 269:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 26c:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 26f:	eb 09                	jmp    27a <strncmp+0x18>
      n--, p++, q++;
 271:	83 e8 01             	sub    $0x1,%eax
 274:	83 c2 01             	add    $0x1,%edx
 277:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 27a:	85 c0                	test   %eax,%eax
 27c:	74 0b                	je     289 <strncmp+0x27>
 27e:	0f b6 1a             	movzbl (%edx),%ebx
 281:	84 db                	test   %bl,%bl
 283:	74 04                	je     289 <strncmp+0x27>
 285:	3a 19                	cmp    (%ecx),%bl
 287:	74 e8                	je     271 <strncmp+0xf>
    if(n == 0)
 289:	85 c0                	test   %eax,%eax
 28b:	74 0b                	je     298 <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 28d:	0f b6 02             	movzbl (%edx),%eax
 290:	0f b6 11             	movzbl (%ecx),%edx
 293:	29 d0                	sub    %edx,%eax
}
 295:	5b                   	pop    %ebx
 296:	5d                   	pop    %ebp
 297:	c3                   	ret    
      return 0;
 298:	b8 00 00 00 00       	mov    $0x0,%eax
 29d:	eb f6                	jmp    295 <strncmp+0x33>

0000029f <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
 2a2:	56                   	push   %esi
 2a3:	53                   	push   %ebx
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2aa:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 2ad:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 2af:	eb 0d                	jmp    2be <memmove+0x1f>
    *dst++ = *src++;
 2b1:	0f b6 13             	movzbl (%ebx),%edx
 2b4:	88 11                	mov    %dl,(%ecx)
 2b6:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2b9:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 2bc:	89 f2                	mov    %esi,%edx
 2be:	8d 72 ff             	lea    -0x1(%edx),%esi
 2c1:	85 d2                	test   %edx,%edx
 2c3:	7f ec                	jg     2b1 <memmove+0x12>
  return vdst;
}
 2c5:	5b                   	pop    %ebx
 2c6:	5e                   	pop    %esi
 2c7:	5d                   	pop    %ebp
 2c8:	c3                   	ret    

000002c9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <exit>:
SYSCALL(exit)
 2d1:	b8 02 00 00 00       	mov    $0x2,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <wait>:
SYSCALL(wait)
 2d9:	b8 03 00 00 00       	mov    $0x3,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <pipe>:
SYSCALL(pipe)
 2e1:	b8 04 00 00 00       	mov    $0x4,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <read>:
SYSCALL(read)
 2e9:	b8 05 00 00 00       	mov    $0x5,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <write>:
SYSCALL(write)
 2f1:	b8 10 00 00 00       	mov    $0x10,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <close>:
SYSCALL(close)
 2f9:	b8 15 00 00 00       	mov    $0x15,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <kill>:
SYSCALL(kill)
 301:	b8 06 00 00 00       	mov    $0x6,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <exec>:
SYSCALL(exec)
 309:	b8 07 00 00 00       	mov    $0x7,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <open>:
SYSCALL(open)
 311:	b8 0f 00 00 00       	mov    $0xf,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <mknod>:
SYSCALL(mknod)
 319:	b8 11 00 00 00       	mov    $0x11,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <unlink>:
SYSCALL(unlink)
 321:	b8 12 00 00 00       	mov    $0x12,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <fstat>:
SYSCALL(fstat)
 329:	b8 08 00 00 00       	mov    $0x8,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <link>:
SYSCALL(link)
 331:	b8 13 00 00 00       	mov    $0x13,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <mkdir>:
SYSCALL(mkdir)
 339:	b8 14 00 00 00       	mov    $0x14,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <chdir>:
SYSCALL(chdir)
 341:	b8 09 00 00 00       	mov    $0x9,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <dup>:
SYSCALL(dup)
 349:	b8 0a 00 00 00       	mov    $0xa,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <getpid>:
SYSCALL(getpid)
 351:	b8 0b 00 00 00       	mov    $0xb,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <sbrk>:
SYSCALL(sbrk)
 359:	b8 0c 00 00 00       	mov    $0xc,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <sleep>:
SYSCALL(sleep)
 361:	b8 0d 00 00 00       	mov    $0xd,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <uptime>:
SYSCALL(uptime)
 369:	b8 0e 00 00 00       	mov    $0xe,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <halt>:
SYSCALL(halt)
 371:	b8 16 00 00 00       	mov    $0x16,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <date>:
SYSCALL(date)
 379:	b8 17 00 00 00       	mov    $0x17,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
 384:	83 ec 1c             	sub    $0x1c,%esp
 387:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 38a:	6a 01                	push   $0x1
 38c:	8d 55 f4             	lea    -0xc(%ebp),%edx
 38f:	52                   	push   %edx
 390:	50                   	push   %eax
 391:	e8 5b ff ff ff       	call   2f1 <write>
}
 396:	83 c4 10             	add    $0x10,%esp
 399:	c9                   	leave  
 39a:	c3                   	ret    

0000039b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39b:	55                   	push   %ebp
 39c:	89 e5                	mov    %esp,%ebp
 39e:	57                   	push   %edi
 39f:	56                   	push   %esi
 3a0:	53                   	push   %ebx
 3a1:	83 ec 2c             	sub    $0x2c,%esp
 3a4:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3aa:	0f 95 c3             	setne  %bl
 3ad:	89 d0                	mov    %edx,%eax
 3af:	c1 e8 1f             	shr    $0x1f,%eax
 3b2:	84 c3                	test   %al,%bl
 3b4:	74 10                	je     3c6 <printint+0x2b>
    neg = 1;
    x = -xx;
 3b6:	f7 da                	neg    %edx
    neg = 1;
 3b8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3bf:	be 00 00 00 00       	mov    $0x0,%esi
 3c4:	eb 0b                	jmp    3d1 <printint+0x36>
  neg = 0;
 3c6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3cd:	eb f0                	jmp    3bf <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 3cf:	89 c6                	mov    %eax,%esi
 3d1:	89 d0                	mov    %edx,%eax
 3d3:	ba 00 00 00 00       	mov    $0x0,%edx
 3d8:	f7 f1                	div    %ecx
 3da:	89 c3                	mov    %eax,%ebx
 3dc:	8d 46 01             	lea    0x1(%esi),%eax
 3df:	0f b6 92 08 07 00 00 	movzbl 0x708(%edx),%edx
 3e6:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 3ea:	89 da                	mov    %ebx,%edx
 3ec:	85 db                	test   %ebx,%ebx
 3ee:	75 df                	jne    3cf <printint+0x34>
 3f0:	89 c3                	mov    %eax,%ebx
  if(neg)
 3f2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3f6:	74 16                	je     40e <printint+0x73>
    buf[i++] = '-';
 3f8:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 3fd:	8d 5e 02             	lea    0x2(%esi),%ebx
 400:	eb 0c                	jmp    40e <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 402:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 407:	89 f8                	mov    %edi,%eax
 409:	e8 73 ff ff ff       	call   381 <putc>
  while(--i >= 0)
 40e:	83 eb 01             	sub    $0x1,%ebx
 411:	79 ef                	jns    402 <printint+0x67>
}
 413:	83 c4 2c             	add    $0x2c,%esp
 416:	5b                   	pop    %ebx
 417:	5e                   	pop    %esi
 418:	5f                   	pop    %edi
 419:	5d                   	pop    %ebp
 41a:	c3                   	ret    

0000041b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 41b:	55                   	push   %ebp
 41c:	89 e5                	mov    %esp,%ebp
 41e:	57                   	push   %edi
 41f:	56                   	push   %esi
 420:	53                   	push   %ebx
 421:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 424:	8d 45 10             	lea    0x10(%ebp),%eax
 427:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 42a:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 42f:	bb 00 00 00 00       	mov    $0x0,%ebx
 434:	eb 14                	jmp    44a <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 436:	89 fa                	mov    %edi,%edx
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	e8 41 ff ff ff       	call   381 <putc>
 440:	eb 05                	jmp    447 <printf+0x2c>
      }
    } else if(state == '%'){
 442:	83 fe 25             	cmp    $0x25,%esi
 445:	74 25                	je     46c <printf+0x51>
  for(i = 0; fmt[i]; i++){
 447:	83 c3 01             	add    $0x1,%ebx
 44a:	8b 45 0c             	mov    0xc(%ebp),%eax
 44d:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 451:	84 c0                	test   %al,%al
 453:	0f 84 23 01 00 00    	je     57c <printf+0x161>
    c = fmt[i] & 0xff;
 459:	0f be f8             	movsbl %al,%edi
 45c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 45f:	85 f6                	test   %esi,%esi
 461:	75 df                	jne    442 <printf+0x27>
      if(c == '%'){
 463:	83 f8 25             	cmp    $0x25,%eax
 466:	75 ce                	jne    436 <printf+0x1b>
        state = '%';
 468:	89 c6                	mov    %eax,%esi
 46a:	eb db                	jmp    447 <printf+0x2c>
      if(c == 'd'){
 46c:	83 f8 64             	cmp    $0x64,%eax
 46f:	74 49                	je     4ba <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 471:	83 f8 78             	cmp    $0x78,%eax
 474:	0f 94 c1             	sete   %cl
 477:	83 f8 70             	cmp    $0x70,%eax
 47a:	0f 94 c2             	sete   %dl
 47d:	08 d1                	or     %dl,%cl
 47f:	75 63                	jne    4e4 <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 481:	83 f8 73             	cmp    $0x73,%eax
 484:	0f 84 84 00 00 00    	je     50e <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 48a:	83 f8 63             	cmp    $0x63,%eax
 48d:	0f 84 b7 00 00 00    	je     54a <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 493:	83 f8 25             	cmp    $0x25,%eax
 496:	0f 84 cc 00 00 00    	je     568 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 49c:	ba 25 00 00 00       	mov    $0x25,%edx
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	e8 d8 fe ff ff       	call   381 <putc>
        putc(fd, c);
 4a9:	89 fa                	mov    %edi,%edx
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	e8 ce fe ff ff       	call   381 <putc>
      }
      state = 0;
 4b3:	be 00 00 00 00       	mov    $0x0,%esi
 4b8:	eb 8d                	jmp    447 <printf+0x2c>
        printint(fd, *ap, 10, 1);
 4ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4bd:	8b 17                	mov    (%edi),%edx
 4bf:	83 ec 0c             	sub    $0xc,%esp
 4c2:	6a 01                	push   $0x1
 4c4:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4c9:	8b 45 08             	mov    0x8(%ebp),%eax
 4cc:	e8 ca fe ff ff       	call   39b <printint>
        ap++;
 4d1:	83 c7 04             	add    $0x4,%edi
 4d4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4d7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4da:	be 00 00 00 00       	mov    $0x0,%esi
 4df:	e9 63 ff ff ff       	jmp    447 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4e7:	8b 17                	mov    (%edi),%edx
 4e9:	83 ec 0c             	sub    $0xc,%esp
 4ec:	6a 00                	push   $0x0
 4ee:	b9 10 00 00 00       	mov    $0x10,%ecx
 4f3:	8b 45 08             	mov    0x8(%ebp),%eax
 4f6:	e8 a0 fe ff ff       	call   39b <printint>
        ap++;
 4fb:	83 c7 04             	add    $0x4,%edi
 4fe:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 501:	83 c4 10             	add    $0x10,%esp
      state = 0;
 504:	be 00 00 00 00       	mov    $0x0,%esi
 509:	e9 39 ff ff ff       	jmp    447 <printf+0x2c>
        s = (char*)*ap;
 50e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 511:	8b 30                	mov    (%eax),%esi
        ap++;
 513:	83 c0 04             	add    $0x4,%eax
 516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 519:	85 f6                	test   %esi,%esi
 51b:	75 28                	jne    545 <printf+0x12a>
          s = "(null)";
 51d:	be 01 07 00 00       	mov    $0x701,%esi
 522:	8b 7d 08             	mov    0x8(%ebp),%edi
 525:	eb 0d                	jmp    534 <printf+0x119>
          putc(fd, *s);
 527:	0f be d2             	movsbl %dl,%edx
 52a:	89 f8                	mov    %edi,%eax
 52c:	e8 50 fe ff ff       	call   381 <putc>
          s++;
 531:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 534:	0f b6 16             	movzbl (%esi),%edx
 537:	84 d2                	test   %dl,%dl
 539:	75 ec                	jne    527 <printf+0x10c>
      state = 0;
 53b:	be 00 00 00 00       	mov    $0x0,%esi
 540:	e9 02 ff ff ff       	jmp    447 <printf+0x2c>
 545:	8b 7d 08             	mov    0x8(%ebp),%edi
 548:	eb ea                	jmp    534 <printf+0x119>
        putc(fd, *ap);
 54a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 54d:	0f be 17             	movsbl (%edi),%edx
 550:	8b 45 08             	mov    0x8(%ebp),%eax
 553:	e8 29 fe ff ff       	call   381 <putc>
        ap++;
 558:	83 c7 04             	add    $0x4,%edi
 55b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 55e:	be 00 00 00 00       	mov    $0x0,%esi
 563:	e9 df fe ff ff       	jmp    447 <printf+0x2c>
        putc(fd, c);
 568:	89 fa                	mov    %edi,%edx
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
 56d:	e8 0f fe ff ff       	call   381 <putc>
      state = 0;
 572:	be 00 00 00 00       	mov    $0x0,%esi
 577:	e9 cb fe ff ff       	jmp    447 <printf+0x2c>
    }
  }
}
 57c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 57f:	5b                   	pop    %ebx
 580:	5e                   	pop    %esi
 581:	5f                   	pop    %edi
 582:	5d                   	pop    %ebp
 583:	c3                   	ret    

00000584 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp
 587:	57                   	push   %edi
 588:	56                   	push   %esi
 589:	53                   	push   %ebx
 58a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 58d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 590:	a1 08 0a 00 00       	mov    0xa08,%eax
 595:	eb 02                	jmp    599 <free+0x15>
 597:	89 d0                	mov    %edx,%eax
 599:	39 c8                	cmp    %ecx,%eax
 59b:	73 04                	jae    5a1 <free+0x1d>
 59d:	39 08                	cmp    %ecx,(%eax)
 59f:	77 12                	ja     5b3 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a1:	8b 10                	mov    (%eax),%edx
 5a3:	39 c2                	cmp    %eax,%edx
 5a5:	77 f0                	ja     597 <free+0x13>
 5a7:	39 c8                	cmp    %ecx,%eax
 5a9:	72 08                	jb     5b3 <free+0x2f>
 5ab:	39 ca                	cmp    %ecx,%edx
 5ad:	77 04                	ja     5b3 <free+0x2f>
 5af:	89 d0                	mov    %edx,%eax
 5b1:	eb e6                	jmp    599 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5b3:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5b6:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5b9:	8b 10                	mov    (%eax),%edx
 5bb:	39 d7                	cmp    %edx,%edi
 5bd:	74 19                	je     5d8 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5bf:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5c2:	8b 50 04             	mov    0x4(%eax),%edx
 5c5:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5c8:	39 ce                	cmp    %ecx,%esi
 5ca:	74 1b                	je     5e7 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5cc:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5ce:	a3 08 0a 00 00       	mov    %eax,0xa08
}
 5d3:	5b                   	pop    %ebx
 5d4:	5e                   	pop    %esi
 5d5:	5f                   	pop    %edi
 5d6:	5d                   	pop    %ebp
 5d7:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5d8:	03 72 04             	add    0x4(%edx),%esi
 5db:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5de:	8b 10                	mov    (%eax),%edx
 5e0:	8b 12                	mov    (%edx),%edx
 5e2:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5e5:	eb db                	jmp    5c2 <free+0x3e>
    p->s.size += bp->s.size;
 5e7:	03 53 fc             	add    -0x4(%ebx),%edx
 5ea:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5ed:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5f0:	89 10                	mov    %edx,(%eax)
 5f2:	eb da                	jmp    5ce <free+0x4a>

000005f4 <morecore>:

static Header*
morecore(uint nu)
{
 5f4:	55                   	push   %ebp
 5f5:	89 e5                	mov    %esp,%ebp
 5f7:	53                   	push   %ebx
 5f8:	83 ec 04             	sub    $0x4,%esp
 5fb:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5fd:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 602:	77 05                	ja     609 <morecore+0x15>
    nu = 4096;
 604:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 609:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 610:	83 ec 0c             	sub    $0xc,%esp
 613:	50                   	push   %eax
 614:	e8 40 fd ff ff       	call   359 <sbrk>
  if(p == (char*)-1)
 619:	83 c4 10             	add    $0x10,%esp
 61c:	83 f8 ff             	cmp    $0xffffffff,%eax
 61f:	74 1c                	je     63d <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 621:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 624:	83 c0 08             	add    $0x8,%eax
 627:	83 ec 0c             	sub    $0xc,%esp
 62a:	50                   	push   %eax
 62b:	e8 54 ff ff ff       	call   584 <free>
  return freep;
 630:	a1 08 0a 00 00       	mov    0xa08,%eax
 635:	83 c4 10             	add    $0x10,%esp
}
 638:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 63b:	c9                   	leave  
 63c:	c3                   	ret    
    return 0;
 63d:	b8 00 00 00 00       	mov    $0x0,%eax
 642:	eb f4                	jmp    638 <morecore+0x44>

00000644 <malloc>:

void*
malloc(uint nbytes)
{
 644:	55                   	push   %ebp
 645:	89 e5                	mov    %esp,%ebp
 647:	53                   	push   %ebx
 648:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 64b:	8b 45 08             	mov    0x8(%ebp),%eax
 64e:	8d 58 07             	lea    0x7(%eax),%ebx
 651:	c1 eb 03             	shr    $0x3,%ebx
 654:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 657:	8b 0d 08 0a 00 00    	mov    0xa08,%ecx
 65d:	85 c9                	test   %ecx,%ecx
 65f:	74 04                	je     665 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 661:	8b 01                	mov    (%ecx),%eax
 663:	eb 4d                	jmp    6b2 <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 665:	c7 05 08 0a 00 00 0c 	movl   $0xa0c,0xa08
 66c:	0a 00 00 
 66f:	c7 05 0c 0a 00 00 0c 	movl   $0xa0c,0xa0c
 676:	0a 00 00 
    base.s.size = 0;
 679:	c7 05 10 0a 00 00 00 	movl   $0x0,0xa10
 680:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 683:	b9 0c 0a 00 00       	mov    $0xa0c,%ecx
 688:	eb d7                	jmp    661 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 68a:	39 da                	cmp    %ebx,%edx
 68c:	74 1a                	je     6a8 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 68e:	29 da                	sub    %ebx,%edx
 690:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 693:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 696:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 699:	89 0d 08 0a 00 00    	mov    %ecx,0xa08
      return (void*)(p + 1);
 69f:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6a2:	83 c4 04             	add    $0x4,%esp
 6a5:	5b                   	pop    %ebx
 6a6:	5d                   	pop    %ebp
 6a7:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6a8:	8b 10                	mov    (%eax),%edx
 6aa:	89 11                	mov    %edx,(%ecx)
 6ac:	eb eb                	jmp    699 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ae:	89 c1                	mov    %eax,%ecx
 6b0:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6b2:	8b 50 04             	mov    0x4(%eax),%edx
 6b5:	39 da                	cmp    %ebx,%edx
 6b7:	73 d1                	jae    68a <malloc+0x46>
    if(p == freep)
 6b9:	39 05 08 0a 00 00    	cmp    %eax,0xa08
 6bf:	75 ed                	jne    6ae <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 6c1:	89 d8                	mov    %ebx,%eax
 6c3:	e8 2c ff ff ff       	call   5f4 <morecore>
 6c8:	85 c0                	test   %eax,%eax
 6ca:	75 e2                	jne    6ae <malloc+0x6a>
        return 0;
 6cc:	b8 00 00 00 00       	mov    $0x0,%eax
 6d1:	eb cf                	jmp    6a2 <malloc+0x5e>
