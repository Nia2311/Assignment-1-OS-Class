
_uptime:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#define pad(x, y) if ((x) < 10) printf(1, "0"); printf(1, "%d%s", (x), (y));

int
main(void)
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
  int ticks = uptime();
  14:	e8 33 04 00 00       	call   44c <uptime>
  19:	89 c1                	mov    %eax,%ecx
  int ms = ticks % TPS; // TPS in pdx.h
  1b:	be d3 4d 62 10       	mov    $0x10624dd3,%esi
  20:	f7 ee                	imul   %esi
  22:	89 d6                	mov    %edx,%esi
  24:	c1 fe 06             	sar    $0x6,%esi
  27:	89 cb                	mov    %ecx,%ebx
  29:	c1 fb 1f             	sar    $0x1f,%ebx
  2c:	89 f7                	mov    %esi,%edi
  2e:	29 df                	sub    %ebx,%edi
  30:	69 ff e8 03 00 00    	imul   $0x3e8,%edi,%edi
  36:	89 c8                	mov    %ecx,%eax
  38:	29 f8                	sub    %edi,%eax
  3a:	89 c7                	mov    %eax,%edi
  int s  = ticks / TPS;
  3c:	29 de                	sub    %ebx,%esi
  int hours = (s / SPH);
  3e:	ba 59 be 90 4a       	mov    $0x4a90be59,%edx
  43:	89 c8                	mov    %ecx,%eax
  45:	f7 ea                	imul   %edx
  47:	c1 fa 14             	sar    $0x14,%edx
  4a:	29 da                	sub    %ebx,%edx
  4c:	89 d1                	mov    %edx,%ecx
  4e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  int mins  = (s - (SPH * hours)) / 60;
  51:	69 d2 f0 f1 ff ff    	imul   $0xfffff1f0,%edx,%edx
  57:	01 d6                	add    %edx,%esi
  59:	ba 89 88 88 88       	mov    $0x88888889,%edx
  5e:	89 f0                	mov    %esi,%eax
  60:	f7 ea                	imul   %edx
  62:	8d 1c 32             	lea    (%edx,%esi,1),%ebx
  65:	c1 fb 05             	sar    $0x5,%ebx
  68:	89 f0                	mov    %esi,%eax
  6a:	c1 f8 1f             	sar    $0x1f,%eax
  6d:	29 c3                	sub    %eax,%ebx
  int secs  = (s - (hours * SPH) - (mins * SPM));
  6f:	89 d8                	mov    %ebx,%eax
  71:	c1 e0 04             	shl    $0x4,%eax
  74:	89 da                	mov    %ebx,%edx
  76:	29 c2                	sub    %eax,%edx
  78:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  7f:	01 c6                	add    %eax,%esi

  pad(hours, ":"); // note that hours is not bounded, so may take more than 2 digits
  81:	83 f9 09             	cmp    $0x9,%ecx
  84:	7e 6a                	jle    f0 <main+0xf0>
  86:	68 ba 07 00 00       	push   $0x7ba
  8b:	ff 75 e4             	pushl  -0x1c(%ebp)
  8e:	68 bc 07 00 00       	push   $0x7bc
  93:	6a 01                	push   $0x1
  95:	e8 64 04 00 00       	call   4fe <printf>
  pad(mins,  ":");
  9a:	83 c4 10             	add    $0x10,%esp
  9d:	83 fb 09             	cmp    $0x9,%ebx
  a0:	7e 62                	jle    104 <main+0x104>
  a2:	68 ba 07 00 00       	push   $0x7ba
  a7:	53                   	push   %ebx
  a8:	68 bc 07 00 00       	push   $0x7bc
  ad:	6a 01                	push   $0x1
  af:	e8 4a 04 00 00       	call   4fe <printf>
  pad(secs,  ".");
  b4:	83 c4 10             	add    $0x10,%esp
  b7:	83 fe 09             	cmp    $0x9,%esi
  ba:	7e 5c                	jle    118 <main+0x118>
  bc:	68 c1 07 00 00       	push   $0x7c1
  c1:	56                   	push   %esi
  c2:	68 bc 07 00 00       	push   $0x7bc
  c7:	6a 01                	push   $0x1
  c9:	e8 30 04 00 00       	call   4fe <printf>

  // milliseconds
  if (ms < 10)  printf(1, "0");
  ce:	83 c4 10             	add    $0x10,%esp
  d1:	83 ff 09             	cmp    $0x9,%edi
  d4:	7e 56                	jle    12c <main+0x12c>
  if (ms < 100) printf(1, "0");
  d6:	83 ff 63             	cmp    $0x63,%edi
  d9:	7e 65                	jle    140 <main+0x140>
  printf(1, "%d\n", ms);
  db:	83 ec 04             	sub    $0x4,%esp
  de:	57                   	push   %edi
  df:	68 c3 07 00 00       	push   $0x7c3
  e4:	6a 01                	push   $0x1
  e6:	e8 13 04 00 00       	call   4fe <printf>

  exit();
  eb:	e8 c4 02 00 00       	call   3b4 <exit>
  pad(hours, ":"); // note that hours is not bounded, so may take more than 2 digits
  f0:	83 ec 08             	sub    $0x8,%esp
  f3:	68 b8 07 00 00       	push   $0x7b8
  f8:	6a 01                	push   $0x1
  fa:	e8 ff 03 00 00       	call   4fe <printf>
  ff:	83 c4 10             	add    $0x10,%esp
 102:	eb 82                	jmp    86 <main+0x86>
  pad(mins,  ":");
 104:	83 ec 08             	sub    $0x8,%esp
 107:	68 b8 07 00 00       	push   $0x7b8
 10c:	6a 01                	push   $0x1
 10e:	e8 eb 03 00 00       	call   4fe <printf>
 113:	83 c4 10             	add    $0x10,%esp
 116:	eb 8a                	jmp    a2 <main+0xa2>
  pad(secs,  ".");
 118:	83 ec 08             	sub    $0x8,%esp
 11b:	68 b8 07 00 00       	push   $0x7b8
 120:	6a 01                	push   $0x1
 122:	e8 d7 03 00 00       	call   4fe <printf>
 127:	83 c4 10             	add    $0x10,%esp
 12a:	eb 90                	jmp    bc <main+0xbc>
  if (ms < 10)  printf(1, "0");
 12c:	83 ec 08             	sub    $0x8,%esp
 12f:	68 b8 07 00 00       	push   $0x7b8
 134:	6a 01                	push   $0x1
 136:	e8 c3 03 00 00       	call   4fe <printf>
 13b:	83 c4 10             	add    $0x10,%esp
 13e:	eb 96                	jmp    d6 <main+0xd6>
  if (ms < 100) printf(1, "0");
 140:	83 ec 08             	sub    $0x8,%esp
 143:	68 b8 07 00 00       	push   $0x7b8
 148:	6a 01                	push   $0x1
 14a:	e8 af 03 00 00       	call   4fe <printf>
 14f:	83 c4 10             	add    $0x10,%esp
 152:	eb 87                	jmp    db <main+0xdb>

00000154 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	53                   	push   %ebx
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 15e:	89 c2                	mov    %eax,%edx
 160:	0f b6 19             	movzbl (%ecx),%ebx
 163:	88 1a                	mov    %bl,(%edx)
 165:	8d 52 01             	lea    0x1(%edx),%edx
 168:	8d 49 01             	lea    0x1(%ecx),%ecx
 16b:	84 db                	test   %bl,%bl
 16d:	75 f1                	jne    160 <strcpy+0xc>
    ;
  return os;
}
 16f:	5b                   	pop    %ebx
 170:	5d                   	pop    %ebp
 171:	c3                   	ret    

00000172 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
 175:	8b 4d 08             	mov    0x8(%ebp),%ecx
 178:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 17b:	eb 06                	jmp    183 <strcmp+0x11>
    p++, q++;
 17d:	83 c1 01             	add    $0x1,%ecx
 180:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 183:	0f b6 01             	movzbl (%ecx),%eax
 186:	84 c0                	test   %al,%al
 188:	74 04                	je     18e <strcmp+0x1c>
 18a:	3a 02                	cmp    (%edx),%al
 18c:	74 ef                	je     17d <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 18e:	0f b6 c0             	movzbl %al,%eax
 191:	0f b6 12             	movzbl (%edx),%edx
 194:	29 d0                	sub    %edx,%eax
}
 196:	5d                   	pop    %ebp
 197:	c3                   	ret    

00000198 <strlen>:

uint
strlen(char *s)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 19e:	ba 00 00 00 00       	mov    $0x0,%edx
 1a3:	eb 03                	jmp    1a8 <strlen+0x10>
 1a5:	83 c2 01             	add    $0x1,%edx
 1a8:	89 d0                	mov    %edx,%eax
 1aa:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1ae:	75 f5                	jne    1a5 <strlen+0xd>
    ;
  return n;
}
 1b0:	5d                   	pop    %ebp
 1b1:	c3                   	ret    

000001b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	57                   	push   %edi
 1b6:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1b9:	89 d7                	mov    %edx,%edi
 1bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1be:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c1:	fc                   	cld    
 1c2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1c4:	89 d0                	mov    %edx,%eax
 1c6:	5f                   	pop    %edi
 1c7:	5d                   	pop    %ebp
 1c8:	c3                   	ret    

000001c9 <strchr>:

char*
strchr(const char *s, char c)
{
 1c9:	55                   	push   %ebp
 1ca:	89 e5                	mov    %esp,%ebp
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1d3:	0f b6 10             	movzbl (%eax),%edx
 1d6:	84 d2                	test   %dl,%dl
 1d8:	74 09                	je     1e3 <strchr+0x1a>
    if(*s == c)
 1da:	38 ca                	cmp    %cl,%dl
 1dc:	74 0a                	je     1e8 <strchr+0x1f>
  for(; *s; s++)
 1de:	83 c0 01             	add    $0x1,%eax
 1e1:	eb f0                	jmp    1d3 <strchr+0xa>
      return (char*)s;
  return 0;
 1e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1e8:	5d                   	pop    %ebp
 1e9:	c3                   	ret    

000001ea <gets>:

char*
gets(char *buf, int max)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	57                   	push   %edi
 1ee:	56                   	push   %esi
 1ef:	53                   	push   %ebx
 1f0:	83 ec 1c             	sub    $0x1c,%esp
 1f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f6:	bb 00 00 00 00       	mov    $0x0,%ebx
 1fb:	8d 73 01             	lea    0x1(%ebx),%esi
 1fe:	3b 75 0c             	cmp    0xc(%ebp),%esi
 201:	7d 2e                	jge    231 <gets+0x47>
    cc = read(0, &c, 1);
 203:	83 ec 04             	sub    $0x4,%esp
 206:	6a 01                	push   $0x1
 208:	8d 45 e7             	lea    -0x19(%ebp),%eax
 20b:	50                   	push   %eax
 20c:	6a 00                	push   $0x0
 20e:	e8 b9 01 00 00       	call   3cc <read>
    if(cc < 1)
 213:	83 c4 10             	add    $0x10,%esp
 216:	85 c0                	test   %eax,%eax
 218:	7e 17                	jle    231 <gets+0x47>
      break;
    buf[i++] = c;
 21a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 21e:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 221:	3c 0a                	cmp    $0xa,%al
 223:	0f 94 c2             	sete   %dl
 226:	3c 0d                	cmp    $0xd,%al
 228:	0f 94 c0             	sete   %al
    buf[i++] = c;
 22b:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 22d:	08 c2                	or     %al,%dl
 22f:	74 ca                	je     1fb <gets+0x11>
      break;
  }
  buf[i] = '\0';
 231:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 235:	89 f8                	mov    %edi,%eax
 237:	8d 65 f4             	lea    -0xc(%ebp),%esp
 23a:	5b                   	pop    %ebx
 23b:	5e                   	pop    %esi
 23c:	5f                   	pop    %edi
 23d:	5d                   	pop    %ebp
 23e:	c3                   	ret    

0000023f <stat>:

int
stat(char *n, struct stat *st)
{
 23f:	55                   	push   %ebp
 240:	89 e5                	mov    %esp,%ebp
 242:	56                   	push   %esi
 243:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 244:	83 ec 08             	sub    $0x8,%esp
 247:	6a 00                	push   $0x0
 249:	ff 75 08             	pushl  0x8(%ebp)
 24c:	e8 a3 01 00 00       	call   3f4 <open>
  if(fd < 0)
 251:	83 c4 10             	add    $0x10,%esp
 254:	85 c0                	test   %eax,%eax
 256:	78 24                	js     27c <stat+0x3d>
 258:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 25a:	83 ec 08             	sub    $0x8,%esp
 25d:	ff 75 0c             	pushl  0xc(%ebp)
 260:	50                   	push   %eax
 261:	e8 a6 01 00 00       	call   40c <fstat>
 266:	89 c6                	mov    %eax,%esi
  close(fd);
 268:	89 1c 24             	mov    %ebx,(%esp)
 26b:	e8 6c 01 00 00       	call   3dc <close>
  return r;
 270:	83 c4 10             	add    $0x10,%esp
}
 273:	89 f0                	mov    %esi,%eax
 275:	8d 65 f8             	lea    -0x8(%ebp),%esp
 278:	5b                   	pop    %ebx
 279:	5e                   	pop    %esi
 27a:	5d                   	pop    %ebp
 27b:	c3                   	ret    
    return -1;
 27c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 281:	eb f0                	jmp    273 <stat+0x34>

00000283 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 283:	55                   	push   %ebp
 284:	89 e5                	mov    %esp,%ebp
 286:	57                   	push   %edi
 287:	56                   	push   %esi
 288:	53                   	push   %ebx
 289:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 28c:	eb 03                	jmp    291 <atoi+0xe>
 28e:	83 c2 01             	add    $0x1,%edx
 291:	0f b6 02             	movzbl (%edx),%eax
 294:	3c 20                	cmp    $0x20,%al
 296:	74 f6                	je     28e <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 298:	3c 2d                	cmp    $0x2d,%al
 29a:	74 1d                	je     2b9 <atoi+0x36>
 29c:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 2a1:	3c 2b                	cmp    $0x2b,%al
 2a3:	0f 94 c1             	sete   %cl
 2a6:	3c 2d                	cmp    $0x2d,%al
 2a8:	0f 94 c0             	sete   %al
 2ab:	08 c1                	or     %al,%cl
 2ad:	74 03                	je     2b2 <atoi+0x2f>
    s++;
 2af:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 2b2:	b8 00 00 00 00       	mov    $0x0,%eax
 2b7:	eb 17                	jmp    2d0 <atoi+0x4d>
 2b9:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 2be:	eb e1                	jmp    2a1 <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 2c0:	8d 34 80             	lea    (%eax,%eax,4),%esi
 2c3:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 2c6:	83 c2 01             	add    $0x1,%edx
 2c9:	0f be c9             	movsbl %cl,%ecx
 2cc:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 2d0:	0f b6 0a             	movzbl (%edx),%ecx
 2d3:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2d6:	80 fb 09             	cmp    $0x9,%bl
 2d9:	76 e5                	jbe    2c0 <atoi+0x3d>
  return sign*n;
 2db:	0f af c7             	imul   %edi,%eax
}
 2de:	5b                   	pop    %ebx
 2df:	5e                   	pop    %esi
 2e0:	5f                   	pop    %edi
 2e1:	5d                   	pop    %ebp
 2e2:	c3                   	ret    

000002e3 <atoo>:

int
atoo(const char *s)
{
 2e3:	55                   	push   %ebp
 2e4:	89 e5                	mov    %esp,%ebp
 2e6:	57                   	push   %edi
 2e7:	56                   	push   %esi
 2e8:	53                   	push   %ebx
 2e9:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2ec:	eb 03                	jmp    2f1 <atoo+0xe>
 2ee:	83 c2 01             	add    $0x1,%edx
 2f1:	0f b6 0a             	movzbl (%edx),%ecx
 2f4:	80 f9 20             	cmp    $0x20,%cl
 2f7:	74 f5                	je     2ee <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 2f9:	80 f9 2d             	cmp    $0x2d,%cl
 2fc:	74 23                	je     321 <atoo+0x3e>
 2fe:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 303:	80 f9 2b             	cmp    $0x2b,%cl
 306:	0f 94 c0             	sete   %al
 309:	89 c6                	mov    %eax,%esi
 30b:	80 f9 2d             	cmp    $0x2d,%cl
 30e:	0f 94 c0             	sete   %al
 311:	89 f3                	mov    %esi,%ebx
 313:	08 c3                	or     %al,%bl
 315:	74 03                	je     31a <atoo+0x37>
    s++;
 317:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 31a:	b8 00 00 00 00       	mov    $0x0,%eax
 31f:	eb 11                	jmp    332 <atoo+0x4f>
 321:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 326:	eb db                	jmp    303 <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 328:	83 c2 01             	add    $0x1,%edx
 32b:	0f be c9             	movsbl %cl,%ecx
 32e:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 332:	0f b6 0a             	movzbl (%edx),%ecx
 335:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 338:	80 fb 07             	cmp    $0x7,%bl
 33b:	76 eb                	jbe    328 <atoo+0x45>
  return sign*n;
 33d:	0f af c7             	imul   %edi,%eax
}
 340:	5b                   	pop    %ebx
 341:	5e                   	pop    %esi
 342:	5f                   	pop    %edi
 343:	5d                   	pop    %ebp
 344:	c3                   	ret    

00000345 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 345:	55                   	push   %ebp
 346:	89 e5                	mov    %esp,%ebp
 348:	53                   	push   %ebx
 349:	8b 55 08             	mov    0x8(%ebp),%edx
 34c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 34f:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 352:	eb 09                	jmp    35d <strncmp+0x18>
      n--, p++, q++;
 354:	83 e8 01             	sub    $0x1,%eax
 357:	83 c2 01             	add    $0x1,%edx
 35a:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 35d:	85 c0                	test   %eax,%eax
 35f:	74 0b                	je     36c <strncmp+0x27>
 361:	0f b6 1a             	movzbl (%edx),%ebx
 364:	84 db                	test   %bl,%bl
 366:	74 04                	je     36c <strncmp+0x27>
 368:	3a 19                	cmp    (%ecx),%bl
 36a:	74 e8                	je     354 <strncmp+0xf>
    if(n == 0)
 36c:	85 c0                	test   %eax,%eax
 36e:	74 0b                	je     37b <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 370:	0f b6 02             	movzbl (%edx),%eax
 373:	0f b6 11             	movzbl (%ecx),%edx
 376:	29 d0                	sub    %edx,%eax
}
 378:	5b                   	pop    %ebx
 379:	5d                   	pop    %ebp
 37a:	c3                   	ret    
      return 0;
 37b:	b8 00 00 00 00       	mov    $0x0,%eax
 380:	eb f6                	jmp    378 <strncmp+0x33>

00000382 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	56                   	push   %esi
 386:	53                   	push   %ebx
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 38d:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 390:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 392:	eb 0d                	jmp    3a1 <memmove+0x1f>
    *dst++ = *src++;
 394:	0f b6 13             	movzbl (%ebx),%edx
 397:	88 11                	mov    %dl,(%ecx)
 399:	8d 5b 01             	lea    0x1(%ebx),%ebx
 39c:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 39f:	89 f2                	mov    %esi,%edx
 3a1:	8d 72 ff             	lea    -0x1(%edx),%esi
 3a4:	85 d2                	test   %edx,%edx
 3a6:	7f ec                	jg     394 <memmove+0x12>
  return vdst;
}
 3a8:	5b                   	pop    %ebx
 3a9:	5e                   	pop    %esi
 3aa:	5d                   	pop    %ebp
 3ab:	c3                   	ret    

000003ac <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ac:	b8 01 00 00 00       	mov    $0x1,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <exit>:
SYSCALL(exit)
 3b4:	b8 02 00 00 00       	mov    $0x2,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <wait>:
SYSCALL(wait)
 3bc:	b8 03 00 00 00       	mov    $0x3,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <pipe>:
SYSCALL(pipe)
 3c4:	b8 04 00 00 00       	mov    $0x4,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <read>:
SYSCALL(read)
 3cc:	b8 05 00 00 00       	mov    $0x5,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <write>:
SYSCALL(write)
 3d4:	b8 10 00 00 00       	mov    $0x10,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <close>:
SYSCALL(close)
 3dc:	b8 15 00 00 00       	mov    $0x15,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <kill>:
SYSCALL(kill)
 3e4:	b8 06 00 00 00       	mov    $0x6,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <exec>:
SYSCALL(exec)
 3ec:	b8 07 00 00 00       	mov    $0x7,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <open>:
SYSCALL(open)
 3f4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <mknod>:
SYSCALL(mknod)
 3fc:	b8 11 00 00 00       	mov    $0x11,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <unlink>:
SYSCALL(unlink)
 404:	b8 12 00 00 00       	mov    $0x12,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <fstat>:
SYSCALL(fstat)
 40c:	b8 08 00 00 00       	mov    $0x8,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <link>:
SYSCALL(link)
 414:	b8 13 00 00 00       	mov    $0x13,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <mkdir>:
SYSCALL(mkdir)
 41c:	b8 14 00 00 00       	mov    $0x14,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <chdir>:
SYSCALL(chdir)
 424:	b8 09 00 00 00       	mov    $0x9,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <dup>:
SYSCALL(dup)
 42c:	b8 0a 00 00 00       	mov    $0xa,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <getpid>:
SYSCALL(getpid)
 434:	b8 0b 00 00 00       	mov    $0xb,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <sbrk>:
SYSCALL(sbrk)
 43c:	b8 0c 00 00 00       	mov    $0xc,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <sleep>:
SYSCALL(sleep)
 444:	b8 0d 00 00 00       	mov    $0xd,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <uptime>:
SYSCALL(uptime)
 44c:	b8 0e 00 00 00       	mov    $0xe,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <halt>:
SYSCALL(halt)
 454:	b8 16 00 00 00       	mov    $0x16,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <date>:
SYSCALL(date)
 45c:	b8 17 00 00 00       	mov    $0x17,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	83 ec 1c             	sub    $0x1c,%esp
 46a:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 46d:	6a 01                	push   $0x1
 46f:	8d 55 f4             	lea    -0xc(%ebp),%edx
 472:	52                   	push   %edx
 473:	50                   	push   %eax
 474:	e8 5b ff ff ff       	call   3d4 <write>
}
 479:	83 c4 10             	add    $0x10,%esp
 47c:	c9                   	leave  
 47d:	c3                   	ret    

0000047e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47e:	55                   	push   %ebp
 47f:	89 e5                	mov    %esp,%ebp
 481:	57                   	push   %edi
 482:	56                   	push   %esi
 483:	53                   	push   %ebx
 484:	83 ec 2c             	sub    $0x2c,%esp
 487:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 489:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 48d:	0f 95 c3             	setne  %bl
 490:	89 d0                	mov    %edx,%eax
 492:	c1 e8 1f             	shr    $0x1f,%eax
 495:	84 c3                	test   %al,%bl
 497:	74 10                	je     4a9 <printint+0x2b>
    neg = 1;
    x = -xx;
 499:	f7 da                	neg    %edx
    neg = 1;
 49b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 4a2:	be 00 00 00 00       	mov    $0x0,%esi
 4a7:	eb 0b                	jmp    4b4 <printint+0x36>
  neg = 0;
 4a9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 4b0:	eb f0                	jmp    4a2 <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 4b2:	89 c6                	mov    %eax,%esi
 4b4:	89 d0                	mov    %edx,%eax
 4b6:	ba 00 00 00 00       	mov    $0x0,%edx
 4bb:	f7 f1                	div    %ecx
 4bd:	89 c3                	mov    %eax,%ebx
 4bf:	8d 46 01             	lea    0x1(%esi),%eax
 4c2:	0f b6 92 d0 07 00 00 	movzbl 0x7d0(%edx),%edx
 4c9:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 4cd:	89 da                	mov    %ebx,%edx
 4cf:	85 db                	test   %ebx,%ebx
 4d1:	75 df                	jne    4b2 <printint+0x34>
 4d3:	89 c3                	mov    %eax,%ebx
  if(neg)
 4d5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 4d9:	74 16                	je     4f1 <printint+0x73>
    buf[i++] = '-';
 4db:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 4e0:	8d 5e 02             	lea    0x2(%esi),%ebx
 4e3:	eb 0c                	jmp    4f1 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 4e5:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 4ea:	89 f8                	mov    %edi,%eax
 4ec:	e8 73 ff ff ff       	call   464 <putc>
  while(--i >= 0)
 4f1:	83 eb 01             	sub    $0x1,%ebx
 4f4:	79 ef                	jns    4e5 <printint+0x67>
}
 4f6:	83 c4 2c             	add    $0x2c,%esp
 4f9:	5b                   	pop    %ebx
 4fa:	5e                   	pop    %esi
 4fb:	5f                   	pop    %edi
 4fc:	5d                   	pop    %ebp
 4fd:	c3                   	ret    

000004fe <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4fe:	55                   	push   %ebp
 4ff:	89 e5                	mov    %esp,%ebp
 501:	57                   	push   %edi
 502:	56                   	push   %esi
 503:	53                   	push   %ebx
 504:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 507:	8d 45 10             	lea    0x10(%ebp),%eax
 50a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 50d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 512:	bb 00 00 00 00       	mov    $0x0,%ebx
 517:	eb 14                	jmp    52d <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 519:	89 fa                	mov    %edi,%edx
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	e8 41 ff ff ff       	call   464 <putc>
 523:	eb 05                	jmp    52a <printf+0x2c>
      }
    } else if(state == '%'){
 525:	83 fe 25             	cmp    $0x25,%esi
 528:	74 25                	je     54f <printf+0x51>
  for(i = 0; fmt[i]; i++){
 52a:	83 c3 01             	add    $0x1,%ebx
 52d:	8b 45 0c             	mov    0xc(%ebp),%eax
 530:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 534:	84 c0                	test   %al,%al
 536:	0f 84 23 01 00 00    	je     65f <printf+0x161>
    c = fmt[i] & 0xff;
 53c:	0f be f8             	movsbl %al,%edi
 53f:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 542:	85 f6                	test   %esi,%esi
 544:	75 df                	jne    525 <printf+0x27>
      if(c == '%'){
 546:	83 f8 25             	cmp    $0x25,%eax
 549:	75 ce                	jne    519 <printf+0x1b>
        state = '%';
 54b:	89 c6                	mov    %eax,%esi
 54d:	eb db                	jmp    52a <printf+0x2c>
      if(c == 'd'){
 54f:	83 f8 64             	cmp    $0x64,%eax
 552:	74 49                	je     59d <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 554:	83 f8 78             	cmp    $0x78,%eax
 557:	0f 94 c1             	sete   %cl
 55a:	83 f8 70             	cmp    $0x70,%eax
 55d:	0f 94 c2             	sete   %dl
 560:	08 d1                	or     %dl,%cl
 562:	75 63                	jne    5c7 <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 564:	83 f8 73             	cmp    $0x73,%eax
 567:	0f 84 84 00 00 00    	je     5f1 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 56d:	83 f8 63             	cmp    $0x63,%eax
 570:	0f 84 b7 00 00 00    	je     62d <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 576:	83 f8 25             	cmp    $0x25,%eax
 579:	0f 84 cc 00 00 00    	je     64b <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 57f:	ba 25 00 00 00       	mov    $0x25,%edx
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	e8 d8 fe ff ff       	call   464 <putc>
        putc(fd, c);
 58c:	89 fa                	mov    %edi,%edx
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
 591:	e8 ce fe ff ff       	call   464 <putc>
      }
      state = 0;
 596:	be 00 00 00 00       	mov    $0x0,%esi
 59b:	eb 8d                	jmp    52a <printf+0x2c>
        printint(fd, *ap, 10, 1);
 59d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5a0:	8b 17                	mov    (%edi),%edx
 5a2:	83 ec 0c             	sub    $0xc,%esp
 5a5:	6a 01                	push   $0x1
 5a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5ac:	8b 45 08             	mov    0x8(%ebp),%eax
 5af:	e8 ca fe ff ff       	call   47e <printint>
        ap++;
 5b4:	83 c7 04             	add    $0x4,%edi
 5b7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5ba:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5bd:	be 00 00 00 00       	mov    $0x0,%esi
 5c2:	e9 63 ff ff ff       	jmp    52a <printf+0x2c>
        printint(fd, *ap, 16, 0);
 5c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5ca:	8b 17                	mov    (%edi),%edx
 5cc:	83 ec 0c             	sub    $0xc,%esp
 5cf:	6a 00                	push   $0x0
 5d1:	b9 10 00 00 00       	mov    $0x10,%ecx
 5d6:	8b 45 08             	mov    0x8(%ebp),%eax
 5d9:	e8 a0 fe ff ff       	call   47e <printint>
        ap++;
 5de:	83 c7 04             	add    $0x4,%edi
 5e1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5e4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5e7:	be 00 00 00 00       	mov    $0x0,%esi
 5ec:	e9 39 ff ff ff       	jmp    52a <printf+0x2c>
        s = (char*)*ap;
 5f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f4:	8b 30                	mov    (%eax),%esi
        ap++;
 5f6:	83 c0 04             	add    $0x4,%eax
 5f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5fc:	85 f6                	test   %esi,%esi
 5fe:	75 28                	jne    628 <printf+0x12a>
          s = "(null)";
 600:	be c7 07 00 00       	mov    $0x7c7,%esi
 605:	8b 7d 08             	mov    0x8(%ebp),%edi
 608:	eb 0d                	jmp    617 <printf+0x119>
          putc(fd, *s);
 60a:	0f be d2             	movsbl %dl,%edx
 60d:	89 f8                	mov    %edi,%eax
 60f:	e8 50 fe ff ff       	call   464 <putc>
          s++;
 614:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 617:	0f b6 16             	movzbl (%esi),%edx
 61a:	84 d2                	test   %dl,%dl
 61c:	75 ec                	jne    60a <printf+0x10c>
      state = 0;
 61e:	be 00 00 00 00       	mov    $0x0,%esi
 623:	e9 02 ff ff ff       	jmp    52a <printf+0x2c>
 628:	8b 7d 08             	mov    0x8(%ebp),%edi
 62b:	eb ea                	jmp    617 <printf+0x119>
        putc(fd, *ap);
 62d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 630:	0f be 17             	movsbl (%edi),%edx
 633:	8b 45 08             	mov    0x8(%ebp),%eax
 636:	e8 29 fe ff ff       	call   464 <putc>
        ap++;
 63b:	83 c7 04             	add    $0x4,%edi
 63e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 641:	be 00 00 00 00       	mov    $0x0,%esi
 646:	e9 df fe ff ff       	jmp    52a <printf+0x2c>
        putc(fd, c);
 64b:	89 fa                	mov    %edi,%edx
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
 650:	e8 0f fe ff ff       	call   464 <putc>
      state = 0;
 655:	be 00 00 00 00       	mov    $0x0,%esi
 65a:	e9 cb fe ff ff       	jmp    52a <printf+0x2c>
    }
  }
}
 65f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 662:	5b                   	pop    %ebx
 663:	5e                   	pop    %esi
 664:	5f                   	pop    %edi
 665:	5d                   	pop    %ebp
 666:	c3                   	ret    

00000667 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 667:	55                   	push   %ebp
 668:	89 e5                	mov    %esp,%ebp
 66a:	57                   	push   %edi
 66b:	56                   	push   %esi
 66c:	53                   	push   %ebx
 66d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 670:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 673:	a1 d0 0a 00 00       	mov    0xad0,%eax
 678:	eb 02                	jmp    67c <free+0x15>
 67a:	89 d0                	mov    %edx,%eax
 67c:	39 c8                	cmp    %ecx,%eax
 67e:	73 04                	jae    684 <free+0x1d>
 680:	39 08                	cmp    %ecx,(%eax)
 682:	77 12                	ja     696 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 684:	8b 10                	mov    (%eax),%edx
 686:	39 c2                	cmp    %eax,%edx
 688:	77 f0                	ja     67a <free+0x13>
 68a:	39 c8                	cmp    %ecx,%eax
 68c:	72 08                	jb     696 <free+0x2f>
 68e:	39 ca                	cmp    %ecx,%edx
 690:	77 04                	ja     696 <free+0x2f>
 692:	89 d0                	mov    %edx,%eax
 694:	eb e6                	jmp    67c <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 696:	8b 73 fc             	mov    -0x4(%ebx),%esi
 699:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 69c:	8b 10                	mov    (%eax),%edx
 69e:	39 d7                	cmp    %edx,%edi
 6a0:	74 19                	je     6bb <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6a2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6a5:	8b 50 04             	mov    0x4(%eax),%edx
 6a8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6ab:	39 ce                	cmp    %ecx,%esi
 6ad:	74 1b                	je     6ca <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6af:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6b1:	a3 d0 0a 00 00       	mov    %eax,0xad0
}
 6b6:	5b                   	pop    %ebx
 6b7:	5e                   	pop    %esi
 6b8:	5f                   	pop    %edi
 6b9:	5d                   	pop    %ebp
 6ba:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 6bb:	03 72 04             	add    0x4(%edx),%esi
 6be:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c1:	8b 10                	mov    (%eax),%edx
 6c3:	8b 12                	mov    (%edx),%edx
 6c5:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6c8:	eb db                	jmp    6a5 <free+0x3e>
    p->s.size += bp->s.size;
 6ca:	03 53 fc             	add    -0x4(%ebx),%edx
 6cd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d0:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6d3:	89 10                	mov    %edx,(%eax)
 6d5:	eb da                	jmp    6b1 <free+0x4a>

000006d7 <morecore>:

static Header*
morecore(uint nu)
{
 6d7:	55                   	push   %ebp
 6d8:	89 e5                	mov    %esp,%ebp
 6da:	53                   	push   %ebx
 6db:	83 ec 04             	sub    $0x4,%esp
 6de:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 6e0:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 6e5:	77 05                	ja     6ec <morecore+0x15>
    nu = 4096;
 6e7:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 6ec:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6f3:	83 ec 0c             	sub    $0xc,%esp
 6f6:	50                   	push   %eax
 6f7:	e8 40 fd ff ff       	call   43c <sbrk>
  if(p == (char*)-1)
 6fc:	83 c4 10             	add    $0x10,%esp
 6ff:	83 f8 ff             	cmp    $0xffffffff,%eax
 702:	74 1c                	je     720 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 704:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 707:	83 c0 08             	add    $0x8,%eax
 70a:	83 ec 0c             	sub    $0xc,%esp
 70d:	50                   	push   %eax
 70e:	e8 54 ff ff ff       	call   667 <free>
  return freep;
 713:	a1 d0 0a 00 00       	mov    0xad0,%eax
 718:	83 c4 10             	add    $0x10,%esp
}
 71b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 71e:	c9                   	leave  
 71f:	c3                   	ret    
    return 0;
 720:	b8 00 00 00 00       	mov    $0x0,%eax
 725:	eb f4                	jmp    71b <morecore+0x44>

00000727 <malloc>:

void*
malloc(uint nbytes)
{
 727:	55                   	push   %ebp
 728:	89 e5                	mov    %esp,%ebp
 72a:	53                   	push   %ebx
 72b:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 72e:	8b 45 08             	mov    0x8(%ebp),%eax
 731:	8d 58 07             	lea    0x7(%eax),%ebx
 734:	c1 eb 03             	shr    $0x3,%ebx
 737:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 73a:	8b 0d d0 0a 00 00    	mov    0xad0,%ecx
 740:	85 c9                	test   %ecx,%ecx
 742:	74 04                	je     748 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 744:	8b 01                	mov    (%ecx),%eax
 746:	eb 4d                	jmp    795 <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 748:	c7 05 d0 0a 00 00 d4 	movl   $0xad4,0xad0
 74f:	0a 00 00 
 752:	c7 05 d4 0a 00 00 d4 	movl   $0xad4,0xad4
 759:	0a 00 00 
    base.s.size = 0;
 75c:	c7 05 d8 0a 00 00 00 	movl   $0x0,0xad8
 763:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 766:	b9 d4 0a 00 00       	mov    $0xad4,%ecx
 76b:	eb d7                	jmp    744 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 76d:	39 da                	cmp    %ebx,%edx
 76f:	74 1a                	je     78b <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 771:	29 da                	sub    %ebx,%edx
 773:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 776:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 779:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 77c:	89 0d d0 0a 00 00    	mov    %ecx,0xad0
      return (void*)(p + 1);
 782:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 785:	83 c4 04             	add    $0x4,%esp
 788:	5b                   	pop    %ebx
 789:	5d                   	pop    %ebp
 78a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 78b:	8b 10                	mov    (%eax),%edx
 78d:	89 11                	mov    %edx,(%ecx)
 78f:	eb eb                	jmp    77c <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 791:	89 c1                	mov    %eax,%ecx
 793:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 795:	8b 50 04             	mov    0x4(%eax),%edx
 798:	39 da                	cmp    %ebx,%edx
 79a:	73 d1                	jae    76d <malloc+0x46>
    if(p == freep)
 79c:	39 05 d0 0a 00 00    	cmp    %eax,0xad0
 7a2:	75 ed                	jne    791 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 7a4:	89 d8                	mov    %ebx,%eax
 7a6:	e8 2c ff ff ff       	call   6d7 <morecore>
 7ab:	85 c0                	test   %eax,%eax
 7ad:	75 e2                	jne    791 <malloc+0x6a>
        return 0;
 7af:	b8 00 00 00 00       	mov    $0x0,%eax
 7b4:	eb cf                	jmp    785 <malloc+0x5e>
