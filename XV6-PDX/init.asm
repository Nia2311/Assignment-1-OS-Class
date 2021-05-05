
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 44 07 00 00       	push   $0x744
  19:	e8 61 03 00 00       	call   37f <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	78 1b                	js     40 <main+0x40>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  25:	83 ec 0c             	sub    $0xc,%esp
  28:	6a 00                	push   $0x0
  2a:	e8 88 03 00 00       	call   3b7 <dup>
  dup(0);  // stderr
  2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  36:	e8 7c 03 00 00       	call   3b7 <dup>
  3b:	83 c4 10             	add    $0x10,%esp
  3e:	eb 58                	jmp    98 <main+0x98>
    mknod("console", 1, 1);
  40:	83 ec 04             	sub    $0x4,%esp
  43:	6a 01                	push   $0x1
  45:	6a 01                	push   $0x1
  47:	68 44 07 00 00       	push   $0x744
  4c:	e8 36 03 00 00       	call   387 <mknod>
    open("console", O_RDWR);
  51:	83 c4 08             	add    $0x8,%esp
  54:	6a 02                	push   $0x2
  56:	68 44 07 00 00       	push   $0x744
  5b:	e8 1f 03 00 00       	call   37f <open>
  60:	83 c4 10             	add    $0x10,%esp
  63:	eb c0                	jmp    25 <main+0x25>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  65:	83 ec 08             	sub    $0x8,%esp
  68:	68 5f 07 00 00       	push   $0x75f
  6d:	6a 01                	push   $0x1
  6f:	e8 15 04 00 00       	call   489 <printf>
      exit();
  74:	e8 c6 02 00 00       	call   33f <exit>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  79:	83 ec 08             	sub    $0x8,%esp
  7c:	68 8b 07 00 00       	push   $0x78b
  81:	6a 01                	push   $0x1
  83:	e8 01 04 00 00       	call   489 <printf>
  88:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
  8b:	e8 b7 02 00 00       	call   347 <wait>
  90:	85 c0                	test   %eax,%eax
  92:	78 04                	js     98 <main+0x98>
  94:	39 c3                	cmp    %eax,%ebx
  96:	75 e1                	jne    79 <main+0x79>
    printf(1, "init: starting sh\n");
  98:	83 ec 08             	sub    $0x8,%esp
  9b:	68 4c 07 00 00       	push   $0x74c
  a0:	6a 01                	push   $0x1
  a2:	e8 e2 03 00 00       	call   489 <printf>
    pid = fork();
  a7:	e8 8b 02 00 00       	call   337 <fork>
  ac:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	85 c0                	test   %eax,%eax
  b3:	78 b0                	js     65 <main+0x65>
    if(pid == 0){
  b5:	85 c0                	test   %eax,%eax
  b7:	75 d2                	jne    8b <main+0x8b>
      exec("sh", argv);
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 94 0a 00 00       	push   $0xa94
  c1:	68 72 07 00 00       	push   $0x772
  c6:	e8 ac 02 00 00       	call   377 <exec>
      printf(1, "init: exec sh failed\n");
  cb:	83 c4 08             	add    $0x8,%esp
  ce:	68 75 07 00 00       	push   $0x775
  d3:	6a 01                	push   $0x1
  d5:	e8 af 03 00 00       	call   489 <printf>
      exit();
  da:	e8 60 02 00 00       	call   33f <exit>

000000df <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  df:	55                   	push   %ebp
  e0:	89 e5                	mov    %esp,%ebp
  e2:	53                   	push   %ebx
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e9:	89 c2                	mov    %eax,%edx
  eb:	0f b6 19             	movzbl (%ecx),%ebx
  ee:	88 1a                	mov    %bl,(%edx)
  f0:	8d 52 01             	lea    0x1(%edx),%edx
  f3:	8d 49 01             	lea    0x1(%ecx),%ecx
  f6:	84 db                	test   %bl,%bl
  f8:	75 f1                	jne    eb <strcpy+0xc>
    ;
  return os;
}
  fa:	5b                   	pop    %ebx
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    

000000fd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	8b 4d 08             	mov    0x8(%ebp),%ecx
 103:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 106:	eb 06                	jmp    10e <strcmp+0x11>
    p++, q++;
 108:	83 c1 01             	add    $0x1,%ecx
 10b:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 10e:	0f b6 01             	movzbl (%ecx),%eax
 111:	84 c0                	test   %al,%al
 113:	74 04                	je     119 <strcmp+0x1c>
 115:	3a 02                	cmp    (%edx),%al
 117:	74 ef                	je     108 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 119:	0f b6 c0             	movzbl %al,%eax
 11c:	0f b6 12             	movzbl (%edx),%edx
 11f:	29 d0                	sub    %edx,%eax
}
 121:	5d                   	pop    %ebp
 122:	c3                   	ret    

00000123 <strlen>:

uint
strlen(char *s)
{
 123:	55                   	push   %ebp
 124:	89 e5                	mov    %esp,%ebp
 126:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 129:	ba 00 00 00 00       	mov    $0x0,%edx
 12e:	eb 03                	jmp    133 <strlen+0x10>
 130:	83 c2 01             	add    $0x1,%edx
 133:	89 d0                	mov    %edx,%eax
 135:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 139:	75 f5                	jne    130 <strlen+0xd>
    ;
  return n;
}
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <memset>:

void*
memset(void *dst, int c, uint n)
{
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	57                   	push   %edi
 141:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 144:	89 d7                	mov    %edx,%edi
 146:	8b 4d 10             	mov    0x10(%ebp),%ecx
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	fc                   	cld    
 14d:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 14f:	89 d0                	mov    %edx,%eax
 151:	5f                   	pop    %edi
 152:	5d                   	pop    %ebp
 153:	c3                   	ret    

00000154 <strchr>:

char*
strchr(const char *s, char c)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 15e:	0f b6 10             	movzbl (%eax),%edx
 161:	84 d2                	test   %dl,%dl
 163:	74 09                	je     16e <strchr+0x1a>
    if(*s == c)
 165:	38 ca                	cmp    %cl,%dl
 167:	74 0a                	je     173 <strchr+0x1f>
  for(; *s; s++)
 169:	83 c0 01             	add    $0x1,%eax
 16c:	eb f0                	jmp    15e <strchr+0xa>
      return (char*)s;
  return 0;
 16e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 173:	5d                   	pop    %ebp
 174:	c3                   	ret    

00000175 <gets>:

char*
gets(char *buf, int max)
{
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
 178:	57                   	push   %edi
 179:	56                   	push   %esi
 17a:	53                   	push   %ebx
 17b:	83 ec 1c             	sub    $0x1c,%esp
 17e:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	bb 00 00 00 00       	mov    $0x0,%ebx
 186:	8d 73 01             	lea    0x1(%ebx),%esi
 189:	3b 75 0c             	cmp    0xc(%ebp),%esi
 18c:	7d 2e                	jge    1bc <gets+0x47>
    cc = read(0, &c, 1);
 18e:	83 ec 04             	sub    $0x4,%esp
 191:	6a 01                	push   $0x1
 193:	8d 45 e7             	lea    -0x19(%ebp),%eax
 196:	50                   	push   %eax
 197:	6a 00                	push   $0x0
 199:	e8 b9 01 00 00       	call   357 <read>
    if(cc < 1)
 19e:	83 c4 10             	add    $0x10,%esp
 1a1:	85 c0                	test   %eax,%eax
 1a3:	7e 17                	jle    1bc <gets+0x47>
      break;
    buf[i++] = c;
 1a5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a9:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 1ac:	3c 0a                	cmp    $0xa,%al
 1ae:	0f 94 c2             	sete   %dl
 1b1:	3c 0d                	cmp    $0xd,%al
 1b3:	0f 94 c0             	sete   %al
    buf[i++] = c;
 1b6:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 1b8:	08 c2                	or     %al,%dl
 1ba:	74 ca                	je     186 <gets+0x11>
      break;
  }
  buf[i] = '\0';
 1bc:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 1c0:	89 f8                	mov    %edi,%eax
 1c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c5:	5b                   	pop    %ebx
 1c6:	5e                   	pop    %esi
 1c7:	5f                   	pop    %edi
 1c8:	5d                   	pop    %ebp
 1c9:	c3                   	ret    

000001ca <stat>:

int
stat(char *n, struct stat *st)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	56                   	push   %esi
 1ce:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cf:	83 ec 08             	sub    $0x8,%esp
 1d2:	6a 00                	push   $0x0
 1d4:	ff 75 08             	pushl  0x8(%ebp)
 1d7:	e8 a3 01 00 00       	call   37f <open>
  if(fd < 0)
 1dc:	83 c4 10             	add    $0x10,%esp
 1df:	85 c0                	test   %eax,%eax
 1e1:	78 24                	js     207 <stat+0x3d>
 1e3:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	ff 75 0c             	pushl  0xc(%ebp)
 1eb:	50                   	push   %eax
 1ec:	e8 a6 01 00 00       	call   397 <fstat>
 1f1:	89 c6                	mov    %eax,%esi
  close(fd);
 1f3:	89 1c 24             	mov    %ebx,(%esp)
 1f6:	e8 6c 01 00 00       	call   367 <close>
  return r;
 1fb:	83 c4 10             	add    $0x10,%esp
}
 1fe:	89 f0                	mov    %esi,%eax
 200:	8d 65 f8             	lea    -0x8(%ebp),%esp
 203:	5b                   	pop    %ebx
 204:	5e                   	pop    %esi
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    
    return -1;
 207:	be ff ff ff ff       	mov    $0xffffffff,%esi
 20c:	eb f0                	jmp    1fe <stat+0x34>

0000020e <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
 211:	57                   	push   %edi
 212:	56                   	push   %esi
 213:	53                   	push   %ebx
 214:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 217:	eb 03                	jmp    21c <atoi+0xe>
 219:	83 c2 01             	add    $0x1,%edx
 21c:	0f b6 02             	movzbl (%edx),%eax
 21f:	3c 20                	cmp    $0x20,%al
 221:	74 f6                	je     219 <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 223:	3c 2d                	cmp    $0x2d,%al
 225:	74 1d                	je     244 <atoi+0x36>
 227:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 22c:	3c 2b                	cmp    $0x2b,%al
 22e:	0f 94 c1             	sete   %cl
 231:	3c 2d                	cmp    $0x2d,%al
 233:	0f 94 c0             	sete   %al
 236:	08 c1                	or     %al,%cl
 238:	74 03                	je     23d <atoi+0x2f>
    s++;
 23a:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 23d:	b8 00 00 00 00       	mov    $0x0,%eax
 242:	eb 17                	jmp    25b <atoi+0x4d>
 244:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 249:	eb e1                	jmp    22c <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 24b:	8d 34 80             	lea    (%eax,%eax,4),%esi
 24e:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 251:	83 c2 01             	add    $0x1,%edx
 254:	0f be c9             	movsbl %cl,%ecx
 257:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 25b:	0f b6 0a             	movzbl (%edx),%ecx
 25e:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 261:	80 fb 09             	cmp    $0x9,%bl
 264:	76 e5                	jbe    24b <atoi+0x3d>
  return sign*n;
 266:	0f af c7             	imul   %edi,%eax
}
 269:	5b                   	pop    %ebx
 26a:	5e                   	pop    %esi
 26b:	5f                   	pop    %edi
 26c:	5d                   	pop    %ebp
 26d:	c3                   	ret    

0000026e <atoo>:

int
atoo(const char *s)
{
 26e:	55                   	push   %ebp
 26f:	89 e5                	mov    %esp,%ebp
 271:	57                   	push   %edi
 272:	56                   	push   %esi
 273:	53                   	push   %ebx
 274:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 277:	eb 03                	jmp    27c <atoo+0xe>
 279:	83 c2 01             	add    $0x1,%edx
 27c:	0f b6 0a             	movzbl (%edx),%ecx
 27f:	80 f9 20             	cmp    $0x20,%cl
 282:	74 f5                	je     279 <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 284:	80 f9 2d             	cmp    $0x2d,%cl
 287:	74 23                	je     2ac <atoo+0x3e>
 289:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 28e:	80 f9 2b             	cmp    $0x2b,%cl
 291:	0f 94 c0             	sete   %al
 294:	89 c6                	mov    %eax,%esi
 296:	80 f9 2d             	cmp    $0x2d,%cl
 299:	0f 94 c0             	sete   %al
 29c:	89 f3                	mov    %esi,%ebx
 29e:	08 c3                	or     %al,%bl
 2a0:	74 03                	je     2a5 <atoo+0x37>
    s++;
 2a2:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 2a5:	b8 00 00 00 00       	mov    $0x0,%eax
 2aa:	eb 11                	jmp    2bd <atoo+0x4f>
 2ac:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 2b1:	eb db                	jmp    28e <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 2b3:	83 c2 01             	add    $0x1,%edx
 2b6:	0f be c9             	movsbl %cl,%ecx
 2b9:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 2bd:	0f b6 0a             	movzbl (%edx),%ecx
 2c0:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2c3:	80 fb 07             	cmp    $0x7,%bl
 2c6:	76 eb                	jbe    2b3 <atoo+0x45>
  return sign*n;
 2c8:	0f af c7             	imul   %edi,%eax
}
 2cb:	5b                   	pop    %ebx
 2cc:	5e                   	pop    %esi
 2cd:	5f                   	pop    %edi
 2ce:	5d                   	pop    %ebp
 2cf:	c3                   	ret    

000002d0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 55 08             	mov    0x8(%ebp),%edx
 2d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2da:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 2dd:	eb 09                	jmp    2e8 <strncmp+0x18>
      n--, p++, q++;
 2df:	83 e8 01             	sub    $0x1,%eax
 2e2:	83 c2 01             	add    $0x1,%edx
 2e5:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 2e8:	85 c0                	test   %eax,%eax
 2ea:	74 0b                	je     2f7 <strncmp+0x27>
 2ec:	0f b6 1a             	movzbl (%edx),%ebx
 2ef:	84 db                	test   %bl,%bl
 2f1:	74 04                	je     2f7 <strncmp+0x27>
 2f3:	3a 19                	cmp    (%ecx),%bl
 2f5:	74 e8                	je     2df <strncmp+0xf>
    if(n == 0)
 2f7:	85 c0                	test   %eax,%eax
 2f9:	74 0b                	je     306 <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 2fb:	0f b6 02             	movzbl (%edx),%eax
 2fe:	0f b6 11             	movzbl (%ecx),%edx
 301:	29 d0                	sub    %edx,%eax
}
 303:	5b                   	pop    %ebx
 304:	5d                   	pop    %ebp
 305:	c3                   	ret    
      return 0;
 306:	b8 00 00 00 00       	mov    $0x0,%eax
 30b:	eb f6                	jmp    303 <strncmp+0x33>

0000030d <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 30d:	55                   	push   %ebp
 30e:	89 e5                	mov    %esp,%ebp
 310:	56                   	push   %esi
 311:	53                   	push   %ebx
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 318:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 31b:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 31d:	eb 0d                	jmp    32c <memmove+0x1f>
    *dst++ = *src++;
 31f:	0f b6 13             	movzbl (%ebx),%edx
 322:	88 11                	mov    %dl,(%ecx)
 324:	8d 5b 01             	lea    0x1(%ebx),%ebx
 327:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 32a:	89 f2                	mov    %esi,%edx
 32c:	8d 72 ff             	lea    -0x1(%edx),%esi
 32f:	85 d2                	test   %edx,%edx
 331:	7f ec                	jg     31f <memmove+0x12>
  return vdst;
}
 333:	5b                   	pop    %ebx
 334:	5e                   	pop    %esi
 335:	5d                   	pop    %ebp
 336:	c3                   	ret    

00000337 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 337:	b8 01 00 00 00       	mov    $0x1,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <exit>:
SYSCALL(exit)
 33f:	b8 02 00 00 00       	mov    $0x2,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <wait>:
SYSCALL(wait)
 347:	b8 03 00 00 00       	mov    $0x3,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <pipe>:
SYSCALL(pipe)
 34f:	b8 04 00 00 00       	mov    $0x4,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <read>:
SYSCALL(read)
 357:	b8 05 00 00 00       	mov    $0x5,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <write>:
SYSCALL(write)
 35f:	b8 10 00 00 00       	mov    $0x10,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <close>:
SYSCALL(close)
 367:	b8 15 00 00 00       	mov    $0x15,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <kill>:
SYSCALL(kill)
 36f:	b8 06 00 00 00       	mov    $0x6,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <exec>:
SYSCALL(exec)
 377:	b8 07 00 00 00       	mov    $0x7,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <open>:
SYSCALL(open)
 37f:	b8 0f 00 00 00       	mov    $0xf,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <mknod>:
SYSCALL(mknod)
 387:	b8 11 00 00 00       	mov    $0x11,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <unlink>:
SYSCALL(unlink)
 38f:	b8 12 00 00 00       	mov    $0x12,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <fstat>:
SYSCALL(fstat)
 397:	b8 08 00 00 00       	mov    $0x8,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <link>:
SYSCALL(link)
 39f:	b8 13 00 00 00       	mov    $0x13,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <mkdir>:
SYSCALL(mkdir)
 3a7:	b8 14 00 00 00       	mov    $0x14,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <chdir>:
SYSCALL(chdir)
 3af:	b8 09 00 00 00       	mov    $0x9,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <dup>:
SYSCALL(dup)
 3b7:	b8 0a 00 00 00       	mov    $0xa,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <getpid>:
SYSCALL(getpid)
 3bf:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <sbrk>:
SYSCALL(sbrk)
 3c7:	b8 0c 00 00 00       	mov    $0xc,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <sleep>:
SYSCALL(sleep)
 3cf:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <uptime>:
SYSCALL(uptime)
 3d7:	b8 0e 00 00 00       	mov    $0xe,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <halt>:
SYSCALL(halt)
 3df:	b8 16 00 00 00       	mov    $0x16,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <date>:
SYSCALL(date)
 3e7:	b8 17 00 00 00       	mov    $0x17,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3ef:	55                   	push   %ebp
 3f0:	89 e5                	mov    %esp,%ebp
 3f2:	83 ec 1c             	sub    $0x1c,%esp
 3f5:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3f8:	6a 01                	push   $0x1
 3fa:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3fd:	52                   	push   %edx
 3fe:	50                   	push   %eax
 3ff:	e8 5b ff ff ff       	call   35f <write>
}
 404:	83 c4 10             	add    $0x10,%esp
 407:	c9                   	leave  
 408:	c3                   	ret    

00000409 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp
 40c:	57                   	push   %edi
 40d:	56                   	push   %esi
 40e:	53                   	push   %ebx
 40f:	83 ec 2c             	sub    $0x2c,%esp
 412:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 414:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 418:	0f 95 c3             	setne  %bl
 41b:	89 d0                	mov    %edx,%eax
 41d:	c1 e8 1f             	shr    $0x1f,%eax
 420:	84 c3                	test   %al,%bl
 422:	74 10                	je     434 <printint+0x2b>
    neg = 1;
    x = -xx;
 424:	f7 da                	neg    %edx
    neg = 1;
 426:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 42d:	be 00 00 00 00       	mov    $0x0,%esi
 432:	eb 0b                	jmp    43f <printint+0x36>
  neg = 0;
 434:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 43b:	eb f0                	jmp    42d <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 43d:	89 c6                	mov    %eax,%esi
 43f:	89 d0                	mov    %edx,%eax
 441:	ba 00 00 00 00       	mov    $0x0,%edx
 446:	f7 f1                	div    %ecx
 448:	89 c3                	mov    %eax,%ebx
 44a:	8d 46 01             	lea    0x1(%esi),%eax
 44d:	0f b6 92 9c 07 00 00 	movzbl 0x79c(%edx),%edx
 454:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 458:	89 da                	mov    %ebx,%edx
 45a:	85 db                	test   %ebx,%ebx
 45c:	75 df                	jne    43d <printint+0x34>
 45e:	89 c3                	mov    %eax,%ebx
  if(neg)
 460:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 464:	74 16                	je     47c <printint+0x73>
    buf[i++] = '-';
 466:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 46b:	8d 5e 02             	lea    0x2(%esi),%ebx
 46e:	eb 0c                	jmp    47c <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 470:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 475:	89 f8                	mov    %edi,%eax
 477:	e8 73 ff ff ff       	call   3ef <putc>
  while(--i >= 0)
 47c:	83 eb 01             	sub    $0x1,%ebx
 47f:	79 ef                	jns    470 <printint+0x67>
}
 481:	83 c4 2c             	add    $0x2c,%esp
 484:	5b                   	pop    %ebx
 485:	5e                   	pop    %esi
 486:	5f                   	pop    %edi
 487:	5d                   	pop    %ebp
 488:	c3                   	ret    

00000489 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 489:	55                   	push   %ebp
 48a:	89 e5                	mov    %esp,%ebp
 48c:	57                   	push   %edi
 48d:	56                   	push   %esi
 48e:	53                   	push   %ebx
 48f:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 492:	8d 45 10             	lea    0x10(%ebp),%eax
 495:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 498:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 49d:	bb 00 00 00 00       	mov    $0x0,%ebx
 4a2:	eb 14                	jmp    4b8 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4a4:	89 fa                	mov    %edi,%edx
 4a6:	8b 45 08             	mov    0x8(%ebp),%eax
 4a9:	e8 41 ff ff ff       	call   3ef <putc>
 4ae:	eb 05                	jmp    4b5 <printf+0x2c>
      }
    } else if(state == '%'){
 4b0:	83 fe 25             	cmp    $0x25,%esi
 4b3:	74 25                	je     4da <printf+0x51>
  for(i = 0; fmt[i]; i++){
 4b5:	83 c3 01             	add    $0x1,%ebx
 4b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bb:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4bf:	84 c0                	test   %al,%al
 4c1:	0f 84 23 01 00 00    	je     5ea <printf+0x161>
    c = fmt[i] & 0xff;
 4c7:	0f be f8             	movsbl %al,%edi
 4ca:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4cd:	85 f6                	test   %esi,%esi
 4cf:	75 df                	jne    4b0 <printf+0x27>
      if(c == '%'){
 4d1:	83 f8 25             	cmp    $0x25,%eax
 4d4:	75 ce                	jne    4a4 <printf+0x1b>
        state = '%';
 4d6:	89 c6                	mov    %eax,%esi
 4d8:	eb db                	jmp    4b5 <printf+0x2c>
      if(c == 'd'){
 4da:	83 f8 64             	cmp    $0x64,%eax
 4dd:	74 49                	je     528 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4df:	83 f8 78             	cmp    $0x78,%eax
 4e2:	0f 94 c1             	sete   %cl
 4e5:	83 f8 70             	cmp    $0x70,%eax
 4e8:	0f 94 c2             	sete   %dl
 4eb:	08 d1                	or     %dl,%cl
 4ed:	75 63                	jne    552 <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4ef:	83 f8 73             	cmp    $0x73,%eax
 4f2:	0f 84 84 00 00 00    	je     57c <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4f8:	83 f8 63             	cmp    $0x63,%eax
 4fb:	0f 84 b7 00 00 00    	je     5b8 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 501:	83 f8 25             	cmp    $0x25,%eax
 504:	0f 84 cc 00 00 00    	je     5d6 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 50a:	ba 25 00 00 00       	mov    $0x25,%edx
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	e8 d8 fe ff ff       	call   3ef <putc>
        putc(fd, c);
 517:	89 fa                	mov    %edi,%edx
 519:	8b 45 08             	mov    0x8(%ebp),%eax
 51c:	e8 ce fe ff ff       	call   3ef <putc>
      }
      state = 0;
 521:	be 00 00 00 00       	mov    $0x0,%esi
 526:	eb 8d                	jmp    4b5 <printf+0x2c>
        printint(fd, *ap, 10, 1);
 528:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 52b:	8b 17                	mov    (%edi),%edx
 52d:	83 ec 0c             	sub    $0xc,%esp
 530:	6a 01                	push   $0x1
 532:	b9 0a 00 00 00       	mov    $0xa,%ecx
 537:	8b 45 08             	mov    0x8(%ebp),%eax
 53a:	e8 ca fe ff ff       	call   409 <printint>
        ap++;
 53f:	83 c7 04             	add    $0x4,%edi
 542:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 545:	83 c4 10             	add    $0x10,%esp
      state = 0;
 548:	be 00 00 00 00       	mov    $0x0,%esi
 54d:	e9 63 ff ff ff       	jmp    4b5 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 552:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 555:	8b 17                	mov    (%edi),%edx
 557:	83 ec 0c             	sub    $0xc,%esp
 55a:	6a 00                	push   $0x0
 55c:	b9 10 00 00 00       	mov    $0x10,%ecx
 561:	8b 45 08             	mov    0x8(%ebp),%eax
 564:	e8 a0 fe ff ff       	call   409 <printint>
        ap++;
 569:	83 c7 04             	add    $0x4,%edi
 56c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 56f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 572:	be 00 00 00 00       	mov    $0x0,%esi
 577:	e9 39 ff ff ff       	jmp    4b5 <printf+0x2c>
        s = (char*)*ap;
 57c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 57f:	8b 30                	mov    (%eax),%esi
        ap++;
 581:	83 c0 04             	add    $0x4,%eax
 584:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 587:	85 f6                	test   %esi,%esi
 589:	75 28                	jne    5b3 <printf+0x12a>
          s = "(null)";
 58b:	be 94 07 00 00       	mov    $0x794,%esi
 590:	8b 7d 08             	mov    0x8(%ebp),%edi
 593:	eb 0d                	jmp    5a2 <printf+0x119>
          putc(fd, *s);
 595:	0f be d2             	movsbl %dl,%edx
 598:	89 f8                	mov    %edi,%eax
 59a:	e8 50 fe ff ff       	call   3ef <putc>
          s++;
 59f:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5a2:	0f b6 16             	movzbl (%esi),%edx
 5a5:	84 d2                	test   %dl,%dl
 5a7:	75 ec                	jne    595 <printf+0x10c>
      state = 0;
 5a9:	be 00 00 00 00       	mov    $0x0,%esi
 5ae:	e9 02 ff ff ff       	jmp    4b5 <printf+0x2c>
 5b3:	8b 7d 08             	mov    0x8(%ebp),%edi
 5b6:	eb ea                	jmp    5a2 <printf+0x119>
        putc(fd, *ap);
 5b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5bb:	0f be 17             	movsbl (%edi),%edx
 5be:	8b 45 08             	mov    0x8(%ebp),%eax
 5c1:	e8 29 fe ff ff       	call   3ef <putc>
        ap++;
 5c6:	83 c7 04             	add    $0x4,%edi
 5c9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5cc:	be 00 00 00 00       	mov    $0x0,%esi
 5d1:	e9 df fe ff ff       	jmp    4b5 <printf+0x2c>
        putc(fd, c);
 5d6:	89 fa                	mov    %edi,%edx
 5d8:	8b 45 08             	mov    0x8(%ebp),%eax
 5db:	e8 0f fe ff ff       	call   3ef <putc>
      state = 0;
 5e0:	be 00 00 00 00       	mov    $0x0,%esi
 5e5:	e9 cb fe ff ff       	jmp    4b5 <printf+0x2c>
    }
  }
}
 5ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ed:	5b                   	pop    %ebx
 5ee:	5e                   	pop    %esi
 5ef:	5f                   	pop    %edi
 5f0:	5d                   	pop    %ebp
 5f1:	c3                   	ret    

000005f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f2:	55                   	push   %ebp
 5f3:	89 e5                	mov    %esp,%ebp
 5f5:	57                   	push   %edi
 5f6:	56                   	push   %esi
 5f7:	53                   	push   %ebx
 5f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5fb:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fe:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 603:	eb 02                	jmp    607 <free+0x15>
 605:	89 d0                	mov    %edx,%eax
 607:	39 c8                	cmp    %ecx,%eax
 609:	73 04                	jae    60f <free+0x1d>
 60b:	39 08                	cmp    %ecx,(%eax)
 60d:	77 12                	ja     621 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60f:	8b 10                	mov    (%eax),%edx
 611:	39 c2                	cmp    %eax,%edx
 613:	77 f0                	ja     605 <free+0x13>
 615:	39 c8                	cmp    %ecx,%eax
 617:	72 08                	jb     621 <free+0x2f>
 619:	39 ca                	cmp    %ecx,%edx
 61b:	77 04                	ja     621 <free+0x2f>
 61d:	89 d0                	mov    %edx,%eax
 61f:	eb e6                	jmp    607 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 621:	8b 73 fc             	mov    -0x4(%ebx),%esi
 624:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 627:	8b 10                	mov    (%eax),%edx
 629:	39 d7                	cmp    %edx,%edi
 62b:	74 19                	je     646 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 62d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 630:	8b 50 04             	mov    0x4(%eax),%edx
 633:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 636:	39 ce                	cmp    %ecx,%esi
 638:	74 1b                	je     655 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 63a:	89 08                	mov    %ecx,(%eax)
  freep = p;
 63c:	a3 9c 0a 00 00       	mov    %eax,0xa9c
}
 641:	5b                   	pop    %ebx
 642:	5e                   	pop    %esi
 643:	5f                   	pop    %edi
 644:	5d                   	pop    %ebp
 645:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 646:	03 72 04             	add    0x4(%edx),%esi
 649:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 64c:	8b 10                	mov    (%eax),%edx
 64e:	8b 12                	mov    (%edx),%edx
 650:	89 53 f8             	mov    %edx,-0x8(%ebx)
 653:	eb db                	jmp    630 <free+0x3e>
    p->s.size += bp->s.size;
 655:	03 53 fc             	add    -0x4(%ebx),%edx
 658:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 65b:	8b 53 f8             	mov    -0x8(%ebx),%edx
 65e:	89 10                	mov    %edx,(%eax)
 660:	eb da                	jmp    63c <free+0x4a>

00000662 <morecore>:

static Header*
morecore(uint nu)
{
 662:	55                   	push   %ebp
 663:	89 e5                	mov    %esp,%ebp
 665:	53                   	push   %ebx
 666:	83 ec 04             	sub    $0x4,%esp
 669:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 66b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 670:	77 05                	ja     677 <morecore+0x15>
    nu = 4096;
 672:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 677:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 67e:	83 ec 0c             	sub    $0xc,%esp
 681:	50                   	push   %eax
 682:	e8 40 fd ff ff       	call   3c7 <sbrk>
  if(p == (char*)-1)
 687:	83 c4 10             	add    $0x10,%esp
 68a:	83 f8 ff             	cmp    $0xffffffff,%eax
 68d:	74 1c                	je     6ab <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 68f:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 692:	83 c0 08             	add    $0x8,%eax
 695:	83 ec 0c             	sub    $0xc,%esp
 698:	50                   	push   %eax
 699:	e8 54 ff ff ff       	call   5f2 <free>
  return freep;
 69e:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 6a3:	83 c4 10             	add    $0x10,%esp
}
 6a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6a9:	c9                   	leave  
 6aa:	c3                   	ret    
    return 0;
 6ab:	b8 00 00 00 00       	mov    $0x0,%eax
 6b0:	eb f4                	jmp    6a6 <morecore+0x44>

000006b2 <malloc>:

void*
malloc(uint nbytes)
{
 6b2:	55                   	push   %ebp
 6b3:	89 e5                	mov    %esp,%ebp
 6b5:	53                   	push   %ebx
 6b6:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
 6bc:	8d 58 07             	lea    0x7(%eax),%ebx
 6bf:	c1 eb 03             	shr    $0x3,%ebx
 6c2:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6c5:	8b 0d 9c 0a 00 00    	mov    0xa9c,%ecx
 6cb:	85 c9                	test   %ecx,%ecx
 6cd:	74 04                	je     6d3 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6cf:	8b 01                	mov    (%ecx),%eax
 6d1:	eb 4d                	jmp    720 <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 6d3:	c7 05 9c 0a 00 00 a0 	movl   $0xaa0,0xa9c
 6da:	0a 00 00 
 6dd:	c7 05 a0 0a 00 00 a0 	movl   $0xaa0,0xaa0
 6e4:	0a 00 00 
    base.s.size = 0;
 6e7:	c7 05 a4 0a 00 00 00 	movl   $0x0,0xaa4
 6ee:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6f1:	b9 a0 0a 00 00       	mov    $0xaa0,%ecx
 6f6:	eb d7                	jmp    6cf <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6f8:	39 da                	cmp    %ebx,%edx
 6fa:	74 1a                	je     716 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6fc:	29 da                	sub    %ebx,%edx
 6fe:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 701:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 704:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 707:	89 0d 9c 0a 00 00    	mov    %ecx,0xa9c
      return (void*)(p + 1);
 70d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 710:	83 c4 04             	add    $0x4,%esp
 713:	5b                   	pop    %ebx
 714:	5d                   	pop    %ebp
 715:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 716:	8b 10                	mov    (%eax),%edx
 718:	89 11                	mov    %edx,(%ecx)
 71a:	eb eb                	jmp    707 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 71c:	89 c1                	mov    %eax,%ecx
 71e:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 720:	8b 50 04             	mov    0x4(%eax),%edx
 723:	39 da                	cmp    %ebx,%edx
 725:	73 d1                	jae    6f8 <malloc+0x46>
    if(p == freep)
 727:	39 05 9c 0a 00 00    	cmp    %eax,0xa9c
 72d:	75 ed                	jne    71c <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 72f:	89 d8                	mov    %ebx,%eax
 731:	e8 2c ff ff ff       	call   662 <morecore>
 736:	85 c0                	test   %eax,%eax
 738:	75 e2                	jne    71c <malloc+0x6a>
        return 0;
 73a:	b8 00 00 00 00       	mov    $0x0,%eax
 73f:	eb cf                	jmp    710 <malloc+0x5e>
