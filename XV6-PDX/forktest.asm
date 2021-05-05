
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 10             	sub    $0x10,%esp
   7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
   a:	53                   	push   %ebx
   b:	e8 2a 01 00 00       	call   13a <strlen>
  10:	83 c4 0c             	add    $0xc,%esp
  13:	50                   	push   %eax
  14:	53                   	push   %ebx
  15:	ff 75 08             	pushl  0x8(%ebp)
  18:	e8 59 03 00 00       	call   376 <write>
}
  1d:	83 c4 10             	add    $0x10,%esp
  20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  23:	c9                   	leave  
  24:	c3                   	ret    

00000025 <forktest>:

void
forktest(void)
{
  25:	55                   	push   %ebp
  26:	89 e5                	mov    %esp,%ebp
  28:	53                   	push   %ebx
  29:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
  2c:	68 08 04 00 00       	push   $0x408
  31:	6a 01                	push   $0x1
  33:	e8 c8 ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  38:	83 c4 10             	add    $0x10,%esp
  3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  40:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  46:	7f 17                	jg     5f <forktest+0x3a>
    pid = fork();
  48:	e8 01 03 00 00       	call   34e <fork>
    if(pid < 0)
  4d:	85 c0                	test   %eax,%eax
  4f:	78 0e                	js     5f <forktest+0x3a>
      break;
    if(pid == 0)
  51:	85 c0                	test   %eax,%eax
  53:	74 05                	je     5a <forktest+0x35>
  for(n=0; n<N; n++){
  55:	83 c3 01             	add    $0x1,%ebx
  58:	eb e6                	jmp    40 <forktest+0x1b>
      exit();
  5a:	e8 f7 02 00 00       	call   356 <exit>
  }

  if(n == N){
  5f:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  65:	74 12                	je     79 <forktest+0x54>
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }

  for(; n > 0; n--){
  67:	85 db                	test   %ebx,%ebx
  69:	7e 3b                	jle    a6 <forktest+0x81>
    if(wait() < 0){
  6b:	e8 ee 02 00 00       	call   35e <wait>
  70:	85 c0                	test   %eax,%eax
  72:	78 1e                	js     92 <forktest+0x6d>
  for(; n > 0; n--){
  74:	83 eb 01             	sub    $0x1,%ebx
  77:	eb ee                	jmp    67 <forktest+0x42>
    printf(1, "fork claimed to work N times!\n", N);
  79:	83 ec 04             	sub    $0x4,%esp
  7c:	68 e8 03 00 00       	push   $0x3e8
  81:	68 48 04 00 00       	push   $0x448
  86:	6a 01                	push   $0x1
  88:	e8 73 ff ff ff       	call   0 <printf>
    exit();
  8d:	e8 c4 02 00 00       	call   356 <exit>
      printf(1, "wait stopped early\n");
  92:	83 ec 08             	sub    $0x8,%esp
  95:	68 13 04 00 00       	push   $0x413
  9a:	6a 01                	push   $0x1
  9c:	e8 5f ff ff ff       	call   0 <printf>
      exit();
  a1:	e8 b0 02 00 00       	call   356 <exit>
    }
  }

  if(wait() != -1){
  a6:	e8 b3 02 00 00       	call   35e <wait>
  ab:	83 f8 ff             	cmp    $0xffffffff,%eax
  ae:	75 17                	jne    c7 <forktest+0xa2>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
  b0:	83 ec 08             	sub    $0x8,%esp
  b3:	68 3a 04 00 00       	push   $0x43a
  b8:	6a 01                	push   $0x1
  ba:	e8 41 ff ff ff       	call   0 <printf>
}
  bf:	83 c4 10             	add    $0x10,%esp
  c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  c5:	c9                   	leave  
  c6:	c3                   	ret    
    printf(1, "wait got too many\n");
  c7:	83 ec 08             	sub    $0x8,%esp
  ca:	68 27 04 00 00       	push   $0x427
  cf:	6a 01                	push   $0x1
  d1:	e8 2a ff ff ff       	call   0 <printf>
    exit();
  d6:	e8 7b 02 00 00       	call   356 <exit>

000000db <main>:

int
main(void)
{
  db:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  df:	83 e4 f0             	and    $0xfffffff0,%esp
  e2:	ff 71 fc             	pushl  -0x4(%ecx)
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  e8:	51                   	push   %ecx
  e9:	83 ec 04             	sub    $0x4,%esp
  forktest();
  ec:	e8 34 ff ff ff       	call   25 <forktest>
  exit();
  f1:	e8 60 02 00 00       	call   356 <exit>

000000f6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  f6:	55                   	push   %ebp
  f7:	89 e5                	mov    %esp,%ebp
  f9:	53                   	push   %ebx
  fa:	8b 45 08             	mov    0x8(%ebp),%eax
  fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 100:	89 c2                	mov    %eax,%edx
 102:	0f b6 19             	movzbl (%ecx),%ebx
 105:	88 1a                	mov    %bl,(%edx)
 107:	8d 52 01             	lea    0x1(%edx),%edx
 10a:	8d 49 01             	lea    0x1(%ecx),%ecx
 10d:	84 db                	test   %bl,%bl
 10f:	75 f1                	jne    102 <strcpy+0xc>
    ;
  return os;
}
 111:	5b                   	pop    %ebx
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    

00000114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 11d:	eb 06                	jmp    125 <strcmp+0x11>
    p++, q++;
 11f:	83 c1 01             	add    $0x1,%ecx
 122:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 125:	0f b6 01             	movzbl (%ecx),%eax
 128:	84 c0                	test   %al,%al
 12a:	74 04                	je     130 <strcmp+0x1c>
 12c:	3a 02                	cmp    (%edx),%al
 12e:	74 ef                	je     11f <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 130:	0f b6 c0             	movzbl %al,%eax
 133:	0f b6 12             	movzbl (%edx),%edx
 136:	29 d0                	sub    %edx,%eax
}
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <strlen>:

uint
strlen(char *s)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 140:	ba 00 00 00 00       	mov    $0x0,%edx
 145:	eb 03                	jmp    14a <strlen+0x10>
 147:	83 c2 01             	add    $0x1,%edx
 14a:	89 d0                	mov    %edx,%eax
 14c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 150:	75 f5                	jne    147 <strlen+0xd>
    ;
  return n;
}
 152:	5d                   	pop    %ebp
 153:	c3                   	ret    

00000154 <memset>:

void*
memset(void *dst, int c, uint n)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	57                   	push   %edi
 158:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 15b:	89 d7                	mov    %edx,%edi
 15d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 160:	8b 45 0c             	mov    0xc(%ebp),%eax
 163:	fc                   	cld    
 164:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 166:	89 d0                	mov    %edx,%eax
 168:	5f                   	pop    %edi
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    

0000016b <strchr>:

char*
strchr(const char *s, char c)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 175:	0f b6 10             	movzbl (%eax),%edx
 178:	84 d2                	test   %dl,%dl
 17a:	74 09                	je     185 <strchr+0x1a>
    if(*s == c)
 17c:	38 ca                	cmp    %cl,%dl
 17e:	74 0a                	je     18a <strchr+0x1f>
  for(; *s; s++)
 180:	83 c0 01             	add    $0x1,%eax
 183:	eb f0                	jmp    175 <strchr+0xa>
      return (char*)s;
  return 0;
 185:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18a:	5d                   	pop    %ebp
 18b:	c3                   	ret    

0000018c <gets>:

char*
gets(char *buf, int max)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	57                   	push   %edi
 190:	56                   	push   %esi
 191:	53                   	push   %ebx
 192:	83 ec 1c             	sub    $0x1c,%esp
 195:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 198:	bb 00 00 00 00       	mov    $0x0,%ebx
 19d:	8d 73 01             	lea    0x1(%ebx),%esi
 1a0:	3b 75 0c             	cmp    0xc(%ebp),%esi
 1a3:	7d 2e                	jge    1d3 <gets+0x47>
    cc = read(0, &c, 1);
 1a5:	83 ec 04             	sub    $0x4,%esp
 1a8:	6a 01                	push   $0x1
 1aa:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1ad:	50                   	push   %eax
 1ae:	6a 00                	push   $0x0
 1b0:	e8 b9 01 00 00       	call   36e <read>
    if(cc < 1)
 1b5:	83 c4 10             	add    $0x10,%esp
 1b8:	85 c0                	test   %eax,%eax
 1ba:	7e 17                	jle    1d3 <gets+0x47>
      break;
    buf[i++] = c;
 1bc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1c0:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 1c3:	3c 0a                	cmp    $0xa,%al
 1c5:	0f 94 c2             	sete   %dl
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	0f 94 c0             	sete   %al
    buf[i++] = c;
 1cd:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 1cf:	08 c2                	or     %al,%dl
 1d1:	74 ca                	je     19d <gets+0x11>
      break;
  }
  buf[i] = '\0';
 1d3:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 1d7:	89 f8                	mov    %edi,%eax
 1d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1dc:	5b                   	pop    %ebx
 1dd:	5e                   	pop    %esi
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    

000001e1 <stat>:

int
stat(char *n, struct stat *st)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	56                   	push   %esi
 1e5:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e6:	83 ec 08             	sub    $0x8,%esp
 1e9:	6a 00                	push   $0x0
 1eb:	ff 75 08             	pushl  0x8(%ebp)
 1ee:	e8 a3 01 00 00       	call   396 <open>
  if(fd < 0)
 1f3:	83 c4 10             	add    $0x10,%esp
 1f6:	85 c0                	test   %eax,%eax
 1f8:	78 24                	js     21e <stat+0x3d>
 1fa:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1fc:	83 ec 08             	sub    $0x8,%esp
 1ff:	ff 75 0c             	pushl  0xc(%ebp)
 202:	50                   	push   %eax
 203:	e8 a6 01 00 00       	call   3ae <fstat>
 208:	89 c6                	mov    %eax,%esi
  close(fd);
 20a:	89 1c 24             	mov    %ebx,(%esp)
 20d:	e8 6c 01 00 00       	call   37e <close>
  return r;
 212:	83 c4 10             	add    $0x10,%esp
}
 215:	89 f0                	mov    %esi,%eax
 217:	8d 65 f8             	lea    -0x8(%ebp),%esp
 21a:	5b                   	pop    %ebx
 21b:	5e                   	pop    %esi
 21c:	5d                   	pop    %ebp
 21d:	c3                   	ret    
    return -1;
 21e:	be ff ff ff ff       	mov    $0xffffffff,%esi
 223:	eb f0                	jmp    215 <stat+0x34>

00000225 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 225:	55                   	push   %ebp
 226:	89 e5                	mov    %esp,%ebp
 228:	57                   	push   %edi
 229:	56                   	push   %esi
 22a:	53                   	push   %ebx
 22b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 22e:	eb 03                	jmp    233 <atoi+0xe>
 230:	83 c2 01             	add    $0x1,%edx
 233:	0f b6 02             	movzbl (%edx),%eax
 236:	3c 20                	cmp    $0x20,%al
 238:	74 f6                	je     230 <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 23a:	3c 2d                	cmp    $0x2d,%al
 23c:	74 1d                	je     25b <atoi+0x36>
 23e:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 243:	3c 2b                	cmp    $0x2b,%al
 245:	0f 94 c1             	sete   %cl
 248:	3c 2d                	cmp    $0x2d,%al
 24a:	0f 94 c0             	sete   %al
 24d:	08 c1                	or     %al,%cl
 24f:	74 03                	je     254 <atoi+0x2f>
    s++;
 251:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
 259:	eb 17                	jmp    272 <atoi+0x4d>
 25b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 260:	eb e1                	jmp    243 <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 262:	8d 34 80             	lea    (%eax,%eax,4),%esi
 265:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 268:	83 c2 01             	add    $0x1,%edx
 26b:	0f be c9             	movsbl %cl,%ecx
 26e:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 272:	0f b6 0a             	movzbl (%edx),%ecx
 275:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 278:	80 fb 09             	cmp    $0x9,%bl
 27b:	76 e5                	jbe    262 <atoi+0x3d>
  return sign*n;
 27d:	0f af c7             	imul   %edi,%eax
}
 280:	5b                   	pop    %ebx
 281:	5e                   	pop    %esi
 282:	5f                   	pop    %edi
 283:	5d                   	pop    %ebp
 284:	c3                   	ret    

00000285 <atoo>:

int
atoo(const char *s)
{
 285:	55                   	push   %ebp
 286:	89 e5                	mov    %esp,%ebp
 288:	57                   	push   %edi
 289:	56                   	push   %esi
 28a:	53                   	push   %ebx
 28b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 28e:	eb 03                	jmp    293 <atoo+0xe>
 290:	83 c2 01             	add    $0x1,%edx
 293:	0f b6 0a             	movzbl (%edx),%ecx
 296:	80 f9 20             	cmp    $0x20,%cl
 299:	74 f5                	je     290 <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 29b:	80 f9 2d             	cmp    $0x2d,%cl
 29e:	74 23                	je     2c3 <atoo+0x3e>
 2a0:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 2a5:	80 f9 2b             	cmp    $0x2b,%cl
 2a8:	0f 94 c0             	sete   %al
 2ab:	89 c6                	mov    %eax,%esi
 2ad:	80 f9 2d             	cmp    $0x2d,%cl
 2b0:	0f 94 c0             	sete   %al
 2b3:	89 f3                	mov    %esi,%ebx
 2b5:	08 c3                	or     %al,%bl
 2b7:	74 03                	je     2bc <atoo+0x37>
    s++;
 2b9:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 2bc:	b8 00 00 00 00       	mov    $0x0,%eax
 2c1:	eb 11                	jmp    2d4 <atoo+0x4f>
 2c3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 2c8:	eb db                	jmp    2a5 <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 2ca:	83 c2 01             	add    $0x1,%edx
 2cd:	0f be c9             	movsbl %cl,%ecx
 2d0:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 2d4:	0f b6 0a             	movzbl (%edx),%ecx
 2d7:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2da:	80 fb 07             	cmp    $0x7,%bl
 2dd:	76 eb                	jbe    2ca <atoo+0x45>
  return sign*n;
 2df:	0f af c7             	imul   %edi,%eax
}
 2e2:	5b                   	pop    %ebx
 2e3:	5e                   	pop    %esi
 2e4:	5f                   	pop    %edi
 2e5:	5d                   	pop    %ebp
 2e6:	c3                   	ret    

000002e7 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2e7:	55                   	push   %ebp
 2e8:	89 e5                	mov    %esp,%ebp
 2ea:	53                   	push   %ebx
 2eb:	8b 55 08             	mov    0x8(%ebp),%edx
 2ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2f1:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 2f4:	eb 09                	jmp    2ff <strncmp+0x18>
      n--, p++, q++;
 2f6:	83 e8 01             	sub    $0x1,%eax
 2f9:	83 c2 01             	add    $0x1,%edx
 2fc:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 2ff:	85 c0                	test   %eax,%eax
 301:	74 0b                	je     30e <strncmp+0x27>
 303:	0f b6 1a             	movzbl (%edx),%ebx
 306:	84 db                	test   %bl,%bl
 308:	74 04                	je     30e <strncmp+0x27>
 30a:	3a 19                	cmp    (%ecx),%bl
 30c:	74 e8                	je     2f6 <strncmp+0xf>
    if(n == 0)
 30e:	85 c0                	test   %eax,%eax
 310:	74 0b                	je     31d <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 312:	0f b6 02             	movzbl (%edx),%eax
 315:	0f b6 11             	movzbl (%ecx),%edx
 318:	29 d0                	sub    %edx,%eax
}
 31a:	5b                   	pop    %ebx
 31b:	5d                   	pop    %ebp
 31c:	c3                   	ret    
      return 0;
 31d:	b8 00 00 00 00       	mov    $0x0,%eax
 322:	eb f6                	jmp    31a <strncmp+0x33>

00000324 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	56                   	push   %esi
 328:	53                   	push   %ebx
 329:	8b 45 08             	mov    0x8(%ebp),%eax
 32c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 32f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 332:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 334:	eb 0d                	jmp    343 <memmove+0x1f>
    *dst++ = *src++;
 336:	0f b6 13             	movzbl (%ebx),%edx
 339:	88 11                	mov    %dl,(%ecx)
 33b:	8d 5b 01             	lea    0x1(%ebx),%ebx
 33e:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 341:	89 f2                	mov    %esi,%edx
 343:	8d 72 ff             	lea    -0x1(%edx),%esi
 346:	85 d2                	test   %edx,%edx
 348:	7f ec                	jg     336 <memmove+0x12>
  return vdst;
}
 34a:	5b                   	pop    %ebx
 34b:	5e                   	pop    %esi
 34c:	5d                   	pop    %ebp
 34d:	c3                   	ret    

0000034e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34e:	b8 01 00 00 00       	mov    $0x1,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <exit>:
SYSCALL(exit)
 356:	b8 02 00 00 00       	mov    $0x2,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <wait>:
SYSCALL(wait)
 35e:	b8 03 00 00 00       	mov    $0x3,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <pipe>:
SYSCALL(pipe)
 366:	b8 04 00 00 00       	mov    $0x4,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <read>:
SYSCALL(read)
 36e:	b8 05 00 00 00       	mov    $0x5,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <write>:
SYSCALL(write)
 376:	b8 10 00 00 00       	mov    $0x10,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <close>:
SYSCALL(close)
 37e:	b8 15 00 00 00       	mov    $0x15,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <kill>:
SYSCALL(kill)
 386:	b8 06 00 00 00       	mov    $0x6,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <exec>:
SYSCALL(exec)
 38e:	b8 07 00 00 00       	mov    $0x7,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <open>:
SYSCALL(open)
 396:	b8 0f 00 00 00       	mov    $0xf,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <mknod>:
SYSCALL(mknod)
 39e:	b8 11 00 00 00       	mov    $0x11,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <unlink>:
SYSCALL(unlink)
 3a6:	b8 12 00 00 00       	mov    $0x12,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <fstat>:
SYSCALL(fstat)
 3ae:	b8 08 00 00 00       	mov    $0x8,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <link>:
SYSCALL(link)
 3b6:	b8 13 00 00 00       	mov    $0x13,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <mkdir>:
SYSCALL(mkdir)
 3be:	b8 14 00 00 00       	mov    $0x14,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <chdir>:
SYSCALL(chdir)
 3c6:	b8 09 00 00 00       	mov    $0x9,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <dup>:
SYSCALL(dup)
 3ce:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <getpid>:
SYSCALL(getpid)
 3d6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <sbrk>:
SYSCALL(sbrk)
 3de:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <sleep>:
SYSCALL(sleep)
 3e6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <uptime>:
SYSCALL(uptime)
 3ee:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <halt>:
SYSCALL(halt)
 3f6:	b8 16 00 00 00       	mov    $0x16,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <date>:
SYSCALL(date)
 3fe:	b8 17 00 00 00       	mov    $0x17,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    
