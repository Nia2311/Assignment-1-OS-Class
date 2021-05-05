
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
   9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  10:	be 00 00 00 00       	mov    $0x0,%esi
  15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  23:	83 ec 04             	sub    $0x4,%esp
  26:	68 00 02 00 00       	push   $0x200
  2b:	68 60 0b 00 00       	push   $0xb60
  30:	ff 75 08             	pushl  0x8(%ebp)
  33:	e8 a4 03 00 00       	call   3dc <read>
  38:	89 c7                	mov    %eax,%edi
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	85 c0                	test   %eax,%eax
  3f:	7e 54                	jle    95 <wc+0x95>
    for(i=0; i<n; i++){
  41:	bb 00 00 00 00       	mov    $0x0,%ebx
  46:	eb 22                	jmp    6a <wc+0x6a>
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	0f be c0             	movsbl %al,%eax
  4e:	50                   	push   %eax
  4f:	68 c8 07 00 00       	push   $0x7c8
  54:	e8 80 01 00 00       	call   1d9 <strchr>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	85 c0                	test   %eax,%eax
  5e:	74 22                	je     82 <wc+0x82>
        inword = 0;
  60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(i=0; i<n; i++){
  67:	83 c3 01             	add    $0x1,%ebx
  6a:	39 fb                	cmp    %edi,%ebx
  6c:	7d b5                	jge    23 <wc+0x23>
      c++;
  6e:	83 c6 01             	add    $0x1,%esi
      if(buf[i] == '\n')
  71:	0f b6 83 60 0b 00 00 	movzbl 0xb60(%ebx),%eax
  78:	3c 0a                	cmp    $0xa,%al
  7a:	75 cc                	jne    48 <wc+0x48>
        l++;
  7c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  80:	eb c6                	jmp    48 <wc+0x48>
      else if(!inword){
  82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  86:	75 df                	jne    67 <wc+0x67>
        w++;
  88:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
        inword = 1;
  8c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  93:	eb d2                	jmp    67 <wc+0x67>
      }
    }
  }
  if(n < 0){
  95:	85 c0                	test   %eax,%eax
  97:	78 24                	js     bd <wc+0xbd>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  99:	83 ec 08             	sub    $0x8,%esp
  9c:	ff 75 0c             	pushl  0xc(%ebp)
  9f:	56                   	push   %esi
  a0:	ff 75 dc             	pushl  -0x24(%ebp)
  a3:	ff 75 e0             	pushl  -0x20(%ebp)
  a6:	68 de 07 00 00       	push   $0x7de
  ab:	6a 01                	push   $0x1
  ad:	e8 5c 04 00 00       	call   50e <printf>
}
  b2:	83 c4 20             	add    $0x20,%esp
  b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  b8:	5b                   	pop    %ebx
  b9:	5e                   	pop    %esi
  ba:	5f                   	pop    %edi
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    
    printf(1, "wc: read error\n");
  bd:	83 ec 08             	sub    $0x8,%esp
  c0:	68 ce 07 00 00       	push   $0x7ce
  c5:	6a 01                	push   $0x1
  c7:	e8 42 04 00 00       	call   50e <printf>
    exit();
  cc:	e8 f3 02 00 00       	call   3c4 <exit>

000000d1 <main>:

int
main(int argc, char *argv[])
{
  d1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  d5:	83 e4 f0             	and    $0xfffffff0,%esp
  d8:	ff 71 fc             	pushl  -0x4(%ecx)
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	57                   	push   %edi
  df:	56                   	push   %esi
  e0:	53                   	push   %ebx
  e1:	51                   	push   %ecx
  e2:	83 ec 18             	sub    $0x18,%esp
  e5:	8b 01                	mov    (%ecx),%eax
  e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  ea:	8b 51 04             	mov    0x4(%ecx),%edx
  ed:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  f0:	83 f8 01             	cmp    $0x1,%eax
  f3:	7e 40                	jle    135 <main+0x64>
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  f5:	bb 01 00 00 00       	mov    $0x1,%ebx
  fa:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  fd:	7d 60                	jge    15f <main+0x8e>
    if((fd = open(argv[i], 0)) < 0){
  ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
 102:	8d 3c 98             	lea    (%eax,%ebx,4),%edi
 105:	83 ec 08             	sub    $0x8,%esp
 108:	6a 00                	push   $0x0
 10a:	ff 37                	pushl  (%edi)
 10c:	e8 f3 02 00 00       	call   404 <open>
 111:	89 c6                	mov    %eax,%esi
 113:	83 c4 10             	add    $0x10,%esp
 116:	85 c0                	test   %eax,%eax
 118:	78 2f                	js     149 <main+0x78>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 11a:	83 ec 08             	sub    $0x8,%esp
 11d:	ff 37                	pushl  (%edi)
 11f:	50                   	push   %eax
 120:	e8 db fe ff ff       	call   0 <wc>
    close(fd);
 125:	89 34 24             	mov    %esi,(%esp)
 128:	e8 bf 02 00 00       	call   3ec <close>
  for(i = 1; i < argc; i++){
 12d:	83 c3 01             	add    $0x1,%ebx
 130:	83 c4 10             	add    $0x10,%esp
 133:	eb c5                	jmp    fa <main+0x29>
    wc(0, "");
 135:	83 ec 08             	sub    $0x8,%esp
 138:	68 dd 07 00 00       	push   $0x7dd
 13d:	6a 00                	push   $0x0
 13f:	e8 bc fe ff ff       	call   0 <wc>
    exit();
 144:	e8 7b 02 00 00       	call   3c4 <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
 149:	83 ec 04             	sub    $0x4,%esp
 14c:	ff 37                	pushl  (%edi)
 14e:	68 eb 07 00 00       	push   $0x7eb
 153:	6a 01                	push   $0x1
 155:	e8 b4 03 00 00       	call   50e <printf>
      exit();
 15a:	e8 65 02 00 00       	call   3c4 <exit>
  }
  exit();
 15f:	e8 60 02 00 00       	call   3c4 <exit>

00000164 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	53                   	push   %ebx
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16e:	89 c2                	mov    %eax,%edx
 170:	0f b6 19             	movzbl (%ecx),%ebx
 173:	88 1a                	mov    %bl,(%edx)
 175:	8d 52 01             	lea    0x1(%edx),%edx
 178:	8d 49 01             	lea    0x1(%ecx),%ecx
 17b:	84 db                	test   %bl,%bl
 17d:	75 f1                	jne    170 <strcpy+0xc>
    ;
  return os;
}
 17f:	5b                   	pop    %ebx
 180:	5d                   	pop    %ebp
 181:	c3                   	ret    

00000182 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 182:	55                   	push   %ebp
 183:	89 e5                	mov    %esp,%ebp
 185:	8b 4d 08             	mov    0x8(%ebp),%ecx
 188:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 18b:	eb 06                	jmp    193 <strcmp+0x11>
    p++, q++;
 18d:	83 c1 01             	add    $0x1,%ecx
 190:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 193:	0f b6 01             	movzbl (%ecx),%eax
 196:	84 c0                	test   %al,%al
 198:	74 04                	je     19e <strcmp+0x1c>
 19a:	3a 02                	cmp    (%edx),%al
 19c:	74 ef                	je     18d <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 19e:	0f b6 c0             	movzbl %al,%eax
 1a1:	0f b6 12             	movzbl (%edx),%edx
 1a4:	29 d0                	sub    %edx,%eax
}
 1a6:	5d                   	pop    %ebp
 1a7:	c3                   	ret    

000001a8 <strlen>:

uint
strlen(char *s)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
 1ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1ae:	ba 00 00 00 00       	mov    $0x0,%edx
 1b3:	eb 03                	jmp    1b8 <strlen+0x10>
 1b5:	83 c2 01             	add    $0x1,%edx
 1b8:	89 d0                	mov    %edx,%eax
 1ba:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1be:	75 f5                	jne    1b5 <strlen+0xd>
    ;
  return n;
}
 1c0:	5d                   	pop    %ebp
 1c1:	c3                   	ret    

000001c2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c2:	55                   	push   %ebp
 1c3:	89 e5                	mov    %esp,%ebp
 1c5:	57                   	push   %edi
 1c6:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1c9:	89 d7                	mov    %edx,%edi
 1cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d1:	fc                   	cld    
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d4:	89 d0                	mov    %edx,%eax
 1d6:	5f                   	pop    %edi
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    

000001d9 <strchr>:

char*
strchr(const char *s, char c)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1e3:	0f b6 10             	movzbl (%eax),%edx
 1e6:	84 d2                	test   %dl,%dl
 1e8:	74 09                	je     1f3 <strchr+0x1a>
    if(*s == c)
 1ea:	38 ca                	cmp    %cl,%dl
 1ec:	74 0a                	je     1f8 <strchr+0x1f>
  for(; *s; s++)
 1ee:	83 c0 01             	add    $0x1,%eax
 1f1:	eb f0                	jmp    1e3 <strchr+0xa>
      return (char*)s;
  return 0;
 1f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1f8:	5d                   	pop    %ebp
 1f9:	c3                   	ret    

000001fa <gets>:

char*
gets(char *buf, int max)
{
 1fa:	55                   	push   %ebp
 1fb:	89 e5                	mov    %esp,%ebp
 1fd:	57                   	push   %edi
 1fe:	56                   	push   %esi
 1ff:	53                   	push   %ebx
 200:	83 ec 1c             	sub    $0x1c,%esp
 203:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 206:	bb 00 00 00 00       	mov    $0x0,%ebx
 20b:	8d 73 01             	lea    0x1(%ebx),%esi
 20e:	3b 75 0c             	cmp    0xc(%ebp),%esi
 211:	7d 2e                	jge    241 <gets+0x47>
    cc = read(0, &c, 1);
 213:	83 ec 04             	sub    $0x4,%esp
 216:	6a 01                	push   $0x1
 218:	8d 45 e7             	lea    -0x19(%ebp),%eax
 21b:	50                   	push   %eax
 21c:	6a 00                	push   $0x0
 21e:	e8 b9 01 00 00       	call   3dc <read>
    if(cc < 1)
 223:	83 c4 10             	add    $0x10,%esp
 226:	85 c0                	test   %eax,%eax
 228:	7e 17                	jle    241 <gets+0x47>
      break;
    buf[i++] = c;
 22a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 22e:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 231:	3c 0a                	cmp    $0xa,%al
 233:	0f 94 c2             	sete   %dl
 236:	3c 0d                	cmp    $0xd,%al
 238:	0f 94 c0             	sete   %al
    buf[i++] = c;
 23b:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 23d:	08 c2                	or     %al,%dl
 23f:	74 ca                	je     20b <gets+0x11>
      break;
  }
  buf[i] = '\0';
 241:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 245:	89 f8                	mov    %edi,%eax
 247:	8d 65 f4             	lea    -0xc(%ebp),%esp
 24a:	5b                   	pop    %ebx
 24b:	5e                   	pop    %esi
 24c:	5f                   	pop    %edi
 24d:	5d                   	pop    %ebp
 24e:	c3                   	ret    

0000024f <stat>:

int
stat(char *n, struct stat *st)
{
 24f:	55                   	push   %ebp
 250:	89 e5                	mov    %esp,%ebp
 252:	56                   	push   %esi
 253:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	83 ec 08             	sub    $0x8,%esp
 257:	6a 00                	push   $0x0
 259:	ff 75 08             	pushl  0x8(%ebp)
 25c:	e8 a3 01 00 00       	call   404 <open>
  if(fd < 0)
 261:	83 c4 10             	add    $0x10,%esp
 264:	85 c0                	test   %eax,%eax
 266:	78 24                	js     28c <stat+0x3d>
 268:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 26a:	83 ec 08             	sub    $0x8,%esp
 26d:	ff 75 0c             	pushl  0xc(%ebp)
 270:	50                   	push   %eax
 271:	e8 a6 01 00 00       	call   41c <fstat>
 276:	89 c6                	mov    %eax,%esi
  close(fd);
 278:	89 1c 24             	mov    %ebx,(%esp)
 27b:	e8 6c 01 00 00       	call   3ec <close>
  return r;
 280:	83 c4 10             	add    $0x10,%esp
}
 283:	89 f0                	mov    %esi,%eax
 285:	8d 65 f8             	lea    -0x8(%ebp),%esp
 288:	5b                   	pop    %ebx
 289:	5e                   	pop    %esi
 28a:	5d                   	pop    %ebp
 28b:	c3                   	ret    
    return -1;
 28c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 291:	eb f0                	jmp    283 <stat+0x34>

00000293 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	57                   	push   %edi
 297:	56                   	push   %esi
 298:	53                   	push   %ebx
 299:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 29c:	eb 03                	jmp    2a1 <atoi+0xe>
 29e:	83 c2 01             	add    $0x1,%edx
 2a1:	0f b6 02             	movzbl (%edx),%eax
 2a4:	3c 20                	cmp    $0x20,%al
 2a6:	74 f6                	je     29e <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 2a8:	3c 2d                	cmp    $0x2d,%al
 2aa:	74 1d                	je     2c9 <atoi+0x36>
 2ac:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 2b1:	3c 2b                	cmp    $0x2b,%al
 2b3:	0f 94 c1             	sete   %cl
 2b6:	3c 2d                	cmp    $0x2d,%al
 2b8:	0f 94 c0             	sete   %al
 2bb:	08 c1                	or     %al,%cl
 2bd:	74 03                	je     2c2 <atoi+0x2f>
    s++;
 2bf:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 2c2:	b8 00 00 00 00       	mov    $0x0,%eax
 2c7:	eb 17                	jmp    2e0 <atoi+0x4d>
 2c9:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 2ce:	eb e1                	jmp    2b1 <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 2d0:	8d 34 80             	lea    (%eax,%eax,4),%esi
 2d3:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 2d6:	83 c2 01             	add    $0x1,%edx
 2d9:	0f be c9             	movsbl %cl,%ecx
 2dc:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 2e0:	0f b6 0a             	movzbl (%edx),%ecx
 2e3:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2e6:	80 fb 09             	cmp    $0x9,%bl
 2e9:	76 e5                	jbe    2d0 <atoi+0x3d>
  return sign*n;
 2eb:	0f af c7             	imul   %edi,%eax
}
 2ee:	5b                   	pop    %ebx
 2ef:	5e                   	pop    %esi
 2f0:	5f                   	pop    %edi
 2f1:	5d                   	pop    %ebp
 2f2:	c3                   	ret    

000002f3 <atoo>:

int
atoo(const char *s)
{
 2f3:	55                   	push   %ebp
 2f4:	89 e5                	mov    %esp,%ebp
 2f6:	57                   	push   %edi
 2f7:	56                   	push   %esi
 2f8:	53                   	push   %ebx
 2f9:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2fc:	eb 03                	jmp    301 <atoo+0xe>
 2fe:	83 c2 01             	add    $0x1,%edx
 301:	0f b6 0a             	movzbl (%edx),%ecx
 304:	80 f9 20             	cmp    $0x20,%cl
 307:	74 f5                	je     2fe <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 309:	80 f9 2d             	cmp    $0x2d,%cl
 30c:	74 23                	je     331 <atoo+0x3e>
 30e:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 313:	80 f9 2b             	cmp    $0x2b,%cl
 316:	0f 94 c0             	sete   %al
 319:	89 c6                	mov    %eax,%esi
 31b:	80 f9 2d             	cmp    $0x2d,%cl
 31e:	0f 94 c0             	sete   %al
 321:	89 f3                	mov    %esi,%ebx
 323:	08 c3                	or     %al,%bl
 325:	74 03                	je     32a <atoo+0x37>
    s++;
 327:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 32a:	b8 00 00 00 00       	mov    $0x0,%eax
 32f:	eb 11                	jmp    342 <atoo+0x4f>
 331:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 336:	eb db                	jmp    313 <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 338:	83 c2 01             	add    $0x1,%edx
 33b:	0f be c9             	movsbl %cl,%ecx
 33e:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 342:	0f b6 0a             	movzbl (%edx),%ecx
 345:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 348:	80 fb 07             	cmp    $0x7,%bl
 34b:	76 eb                	jbe    338 <atoo+0x45>
  return sign*n;
 34d:	0f af c7             	imul   %edi,%eax
}
 350:	5b                   	pop    %ebx
 351:	5e                   	pop    %esi
 352:	5f                   	pop    %edi
 353:	5d                   	pop    %ebp
 354:	c3                   	ret    

00000355 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 355:	55                   	push   %ebp
 356:	89 e5                	mov    %esp,%ebp
 358:	53                   	push   %ebx
 359:	8b 55 08             	mov    0x8(%ebp),%edx
 35c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 35f:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 362:	eb 09                	jmp    36d <strncmp+0x18>
      n--, p++, q++;
 364:	83 e8 01             	sub    $0x1,%eax
 367:	83 c2 01             	add    $0x1,%edx
 36a:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 36d:	85 c0                	test   %eax,%eax
 36f:	74 0b                	je     37c <strncmp+0x27>
 371:	0f b6 1a             	movzbl (%edx),%ebx
 374:	84 db                	test   %bl,%bl
 376:	74 04                	je     37c <strncmp+0x27>
 378:	3a 19                	cmp    (%ecx),%bl
 37a:	74 e8                	je     364 <strncmp+0xf>
    if(n == 0)
 37c:	85 c0                	test   %eax,%eax
 37e:	74 0b                	je     38b <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 380:	0f b6 02             	movzbl (%edx),%eax
 383:	0f b6 11             	movzbl (%ecx),%edx
 386:	29 d0                	sub    %edx,%eax
}
 388:	5b                   	pop    %ebx
 389:	5d                   	pop    %ebp
 38a:	c3                   	ret    
      return 0;
 38b:	b8 00 00 00 00       	mov    $0x0,%eax
 390:	eb f6                	jmp    388 <strncmp+0x33>

00000392 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 392:	55                   	push   %ebp
 393:	89 e5                	mov    %esp,%ebp
 395:	56                   	push   %esi
 396:	53                   	push   %ebx
 397:	8b 45 08             	mov    0x8(%ebp),%eax
 39a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 39d:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 3a0:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 3a2:	eb 0d                	jmp    3b1 <memmove+0x1f>
    *dst++ = *src++;
 3a4:	0f b6 13             	movzbl (%ebx),%edx
 3a7:	88 11                	mov    %dl,(%ecx)
 3a9:	8d 5b 01             	lea    0x1(%ebx),%ebx
 3ac:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 3af:	89 f2                	mov    %esi,%edx
 3b1:	8d 72 ff             	lea    -0x1(%edx),%esi
 3b4:	85 d2                	test   %edx,%edx
 3b6:	7f ec                	jg     3a4 <memmove+0x12>
  return vdst;
}
 3b8:	5b                   	pop    %ebx
 3b9:	5e                   	pop    %esi
 3ba:	5d                   	pop    %ebp
 3bb:	c3                   	ret    

000003bc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3bc:	b8 01 00 00 00       	mov    $0x1,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <exit>:
SYSCALL(exit)
 3c4:	b8 02 00 00 00       	mov    $0x2,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <wait>:
SYSCALL(wait)
 3cc:	b8 03 00 00 00       	mov    $0x3,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <pipe>:
SYSCALL(pipe)
 3d4:	b8 04 00 00 00       	mov    $0x4,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <read>:
SYSCALL(read)
 3dc:	b8 05 00 00 00       	mov    $0x5,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <write>:
SYSCALL(write)
 3e4:	b8 10 00 00 00       	mov    $0x10,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <close>:
SYSCALL(close)
 3ec:	b8 15 00 00 00       	mov    $0x15,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <kill>:
SYSCALL(kill)
 3f4:	b8 06 00 00 00       	mov    $0x6,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <exec>:
SYSCALL(exec)
 3fc:	b8 07 00 00 00       	mov    $0x7,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <open>:
SYSCALL(open)
 404:	b8 0f 00 00 00       	mov    $0xf,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <mknod>:
SYSCALL(mknod)
 40c:	b8 11 00 00 00       	mov    $0x11,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <unlink>:
SYSCALL(unlink)
 414:	b8 12 00 00 00       	mov    $0x12,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <fstat>:
SYSCALL(fstat)
 41c:	b8 08 00 00 00       	mov    $0x8,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <link>:
SYSCALL(link)
 424:	b8 13 00 00 00       	mov    $0x13,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <mkdir>:
SYSCALL(mkdir)
 42c:	b8 14 00 00 00       	mov    $0x14,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <chdir>:
SYSCALL(chdir)
 434:	b8 09 00 00 00       	mov    $0x9,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <dup>:
SYSCALL(dup)
 43c:	b8 0a 00 00 00       	mov    $0xa,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <getpid>:
SYSCALL(getpid)
 444:	b8 0b 00 00 00       	mov    $0xb,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <sbrk>:
SYSCALL(sbrk)
 44c:	b8 0c 00 00 00       	mov    $0xc,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <sleep>:
SYSCALL(sleep)
 454:	b8 0d 00 00 00       	mov    $0xd,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <uptime>:
SYSCALL(uptime)
 45c:	b8 0e 00 00 00       	mov    $0xe,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <halt>:
SYSCALL(halt)
 464:	b8 16 00 00 00       	mov    $0x16,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <date>:
SYSCALL(date)
 46c:	b8 17 00 00 00       	mov    $0x17,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	83 ec 1c             	sub    $0x1c,%esp
 47a:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 47d:	6a 01                	push   $0x1
 47f:	8d 55 f4             	lea    -0xc(%ebp),%edx
 482:	52                   	push   %edx
 483:	50                   	push   %eax
 484:	e8 5b ff ff ff       	call   3e4 <write>
}
 489:	83 c4 10             	add    $0x10,%esp
 48c:	c9                   	leave  
 48d:	c3                   	ret    

0000048e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 48e:	55                   	push   %ebp
 48f:	89 e5                	mov    %esp,%ebp
 491:	57                   	push   %edi
 492:	56                   	push   %esi
 493:	53                   	push   %ebx
 494:	83 ec 2c             	sub    $0x2c,%esp
 497:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 499:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 49d:	0f 95 c3             	setne  %bl
 4a0:	89 d0                	mov    %edx,%eax
 4a2:	c1 e8 1f             	shr    $0x1f,%eax
 4a5:	84 c3                	test   %al,%bl
 4a7:	74 10                	je     4b9 <printint+0x2b>
    neg = 1;
    x = -xx;
 4a9:	f7 da                	neg    %edx
    neg = 1;
 4ab:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 4b2:	be 00 00 00 00       	mov    $0x0,%esi
 4b7:	eb 0b                	jmp    4c4 <printint+0x36>
  neg = 0;
 4b9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 4c0:	eb f0                	jmp    4b2 <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 4c2:	89 c6                	mov    %eax,%esi
 4c4:	89 d0                	mov    %edx,%eax
 4c6:	ba 00 00 00 00       	mov    $0x0,%edx
 4cb:	f7 f1                	div    %ecx
 4cd:	89 c3                	mov    %eax,%ebx
 4cf:	8d 46 01             	lea    0x1(%esi),%eax
 4d2:	0f b6 92 08 08 00 00 	movzbl 0x808(%edx),%edx
 4d9:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 4dd:	89 da                	mov    %ebx,%edx
 4df:	85 db                	test   %ebx,%ebx
 4e1:	75 df                	jne    4c2 <printint+0x34>
 4e3:	89 c3                	mov    %eax,%ebx
  if(neg)
 4e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 4e9:	74 16                	je     501 <printint+0x73>
    buf[i++] = '-';
 4eb:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 4f0:	8d 5e 02             	lea    0x2(%esi),%ebx
 4f3:	eb 0c                	jmp    501 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 4f5:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 4fa:	89 f8                	mov    %edi,%eax
 4fc:	e8 73 ff ff ff       	call   474 <putc>
  while(--i >= 0)
 501:	83 eb 01             	sub    $0x1,%ebx
 504:	79 ef                	jns    4f5 <printint+0x67>
}
 506:	83 c4 2c             	add    $0x2c,%esp
 509:	5b                   	pop    %ebx
 50a:	5e                   	pop    %esi
 50b:	5f                   	pop    %edi
 50c:	5d                   	pop    %ebp
 50d:	c3                   	ret    

0000050e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 50e:	55                   	push   %ebp
 50f:	89 e5                	mov    %esp,%ebp
 511:	57                   	push   %edi
 512:	56                   	push   %esi
 513:	53                   	push   %ebx
 514:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 517:	8d 45 10             	lea    0x10(%ebp),%eax
 51a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 51d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 522:	bb 00 00 00 00       	mov    $0x0,%ebx
 527:	eb 14                	jmp    53d <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 529:	89 fa                	mov    %edi,%edx
 52b:	8b 45 08             	mov    0x8(%ebp),%eax
 52e:	e8 41 ff ff ff       	call   474 <putc>
 533:	eb 05                	jmp    53a <printf+0x2c>
      }
    } else if(state == '%'){
 535:	83 fe 25             	cmp    $0x25,%esi
 538:	74 25                	je     55f <printf+0x51>
  for(i = 0; fmt[i]; i++){
 53a:	83 c3 01             	add    $0x1,%ebx
 53d:	8b 45 0c             	mov    0xc(%ebp),%eax
 540:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 544:	84 c0                	test   %al,%al
 546:	0f 84 23 01 00 00    	je     66f <printf+0x161>
    c = fmt[i] & 0xff;
 54c:	0f be f8             	movsbl %al,%edi
 54f:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 552:	85 f6                	test   %esi,%esi
 554:	75 df                	jne    535 <printf+0x27>
      if(c == '%'){
 556:	83 f8 25             	cmp    $0x25,%eax
 559:	75 ce                	jne    529 <printf+0x1b>
        state = '%';
 55b:	89 c6                	mov    %eax,%esi
 55d:	eb db                	jmp    53a <printf+0x2c>
      if(c == 'd'){
 55f:	83 f8 64             	cmp    $0x64,%eax
 562:	74 49                	je     5ad <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 564:	83 f8 78             	cmp    $0x78,%eax
 567:	0f 94 c1             	sete   %cl
 56a:	83 f8 70             	cmp    $0x70,%eax
 56d:	0f 94 c2             	sete   %dl
 570:	08 d1                	or     %dl,%cl
 572:	75 63                	jne    5d7 <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 574:	83 f8 73             	cmp    $0x73,%eax
 577:	0f 84 84 00 00 00    	je     601 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57d:	83 f8 63             	cmp    $0x63,%eax
 580:	0f 84 b7 00 00 00    	je     63d <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 586:	83 f8 25             	cmp    $0x25,%eax
 589:	0f 84 cc 00 00 00    	je     65b <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 58f:	ba 25 00 00 00       	mov    $0x25,%edx
 594:	8b 45 08             	mov    0x8(%ebp),%eax
 597:	e8 d8 fe ff ff       	call   474 <putc>
        putc(fd, c);
 59c:	89 fa                	mov    %edi,%edx
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	e8 ce fe ff ff       	call   474 <putc>
      }
      state = 0;
 5a6:	be 00 00 00 00       	mov    $0x0,%esi
 5ab:	eb 8d                	jmp    53a <printf+0x2c>
        printint(fd, *ap, 10, 1);
 5ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5b0:	8b 17                	mov    (%edi),%edx
 5b2:	83 ec 0c             	sub    $0xc,%esp
 5b5:	6a 01                	push   $0x1
 5b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
 5bf:	e8 ca fe ff ff       	call   48e <printint>
        ap++;
 5c4:	83 c7 04             	add    $0x4,%edi
 5c7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5ca:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5cd:	be 00 00 00 00       	mov    $0x0,%esi
 5d2:	e9 63 ff ff ff       	jmp    53a <printf+0x2c>
        printint(fd, *ap, 16, 0);
 5d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5da:	8b 17                	mov    (%edi),%edx
 5dc:	83 ec 0c             	sub    $0xc,%esp
 5df:	6a 00                	push   $0x0
 5e1:	b9 10 00 00 00       	mov    $0x10,%ecx
 5e6:	8b 45 08             	mov    0x8(%ebp),%eax
 5e9:	e8 a0 fe ff ff       	call   48e <printint>
        ap++;
 5ee:	83 c7 04             	add    $0x4,%edi
 5f1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5f4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5f7:	be 00 00 00 00       	mov    $0x0,%esi
 5fc:	e9 39 ff ff ff       	jmp    53a <printf+0x2c>
        s = (char*)*ap;
 601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 604:	8b 30                	mov    (%eax),%esi
        ap++;
 606:	83 c0 04             	add    $0x4,%eax
 609:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 60c:	85 f6                	test   %esi,%esi
 60e:	75 28                	jne    638 <printf+0x12a>
          s = "(null)";
 610:	be ff 07 00 00       	mov    $0x7ff,%esi
 615:	8b 7d 08             	mov    0x8(%ebp),%edi
 618:	eb 0d                	jmp    627 <printf+0x119>
          putc(fd, *s);
 61a:	0f be d2             	movsbl %dl,%edx
 61d:	89 f8                	mov    %edi,%eax
 61f:	e8 50 fe ff ff       	call   474 <putc>
          s++;
 624:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 627:	0f b6 16             	movzbl (%esi),%edx
 62a:	84 d2                	test   %dl,%dl
 62c:	75 ec                	jne    61a <printf+0x10c>
      state = 0;
 62e:	be 00 00 00 00       	mov    $0x0,%esi
 633:	e9 02 ff ff ff       	jmp    53a <printf+0x2c>
 638:	8b 7d 08             	mov    0x8(%ebp),%edi
 63b:	eb ea                	jmp    627 <printf+0x119>
        putc(fd, *ap);
 63d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 640:	0f be 17             	movsbl (%edi),%edx
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	e8 29 fe ff ff       	call   474 <putc>
        ap++;
 64b:	83 c7 04             	add    $0x4,%edi
 64e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 651:	be 00 00 00 00       	mov    $0x0,%esi
 656:	e9 df fe ff ff       	jmp    53a <printf+0x2c>
        putc(fd, c);
 65b:	89 fa                	mov    %edi,%edx
 65d:	8b 45 08             	mov    0x8(%ebp),%eax
 660:	e8 0f fe ff ff       	call   474 <putc>
      state = 0;
 665:	be 00 00 00 00       	mov    $0x0,%esi
 66a:	e9 cb fe ff ff       	jmp    53a <printf+0x2c>
    }
  }
}
 66f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 672:	5b                   	pop    %ebx
 673:	5e                   	pop    %esi
 674:	5f                   	pop    %edi
 675:	5d                   	pop    %ebp
 676:	c3                   	ret    

00000677 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 677:	55                   	push   %ebp
 678:	89 e5                	mov    %esp,%ebp
 67a:	57                   	push   %edi
 67b:	56                   	push   %esi
 67c:	53                   	push   %ebx
 67d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 680:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 683:	a1 40 0b 00 00       	mov    0xb40,%eax
 688:	eb 02                	jmp    68c <free+0x15>
 68a:	89 d0                	mov    %edx,%eax
 68c:	39 c8                	cmp    %ecx,%eax
 68e:	73 04                	jae    694 <free+0x1d>
 690:	39 08                	cmp    %ecx,(%eax)
 692:	77 12                	ja     6a6 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 694:	8b 10                	mov    (%eax),%edx
 696:	39 c2                	cmp    %eax,%edx
 698:	77 f0                	ja     68a <free+0x13>
 69a:	39 c8                	cmp    %ecx,%eax
 69c:	72 08                	jb     6a6 <free+0x2f>
 69e:	39 ca                	cmp    %ecx,%edx
 6a0:	77 04                	ja     6a6 <free+0x2f>
 6a2:	89 d0                	mov    %edx,%eax
 6a4:	eb e6                	jmp    68c <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6a9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ac:	8b 10                	mov    (%eax),%edx
 6ae:	39 d7                	cmp    %edx,%edi
 6b0:	74 19                	je     6cb <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6b2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6b5:	8b 50 04             	mov    0x4(%eax),%edx
 6b8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6bb:	39 ce                	cmp    %ecx,%esi
 6bd:	74 1b                	je     6da <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6bf:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6c1:	a3 40 0b 00 00       	mov    %eax,0xb40
}
 6c6:	5b                   	pop    %ebx
 6c7:	5e                   	pop    %esi
 6c8:	5f                   	pop    %edi
 6c9:	5d                   	pop    %ebp
 6ca:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 6cb:	03 72 04             	add    0x4(%edx),%esi
 6ce:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d1:	8b 10                	mov    (%eax),%edx
 6d3:	8b 12                	mov    (%edx),%edx
 6d5:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6d8:	eb db                	jmp    6b5 <free+0x3e>
    p->s.size += bp->s.size;
 6da:	03 53 fc             	add    -0x4(%ebx),%edx
 6dd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e0:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6e3:	89 10                	mov    %edx,(%eax)
 6e5:	eb da                	jmp    6c1 <free+0x4a>

000006e7 <morecore>:

static Header*
morecore(uint nu)
{
 6e7:	55                   	push   %ebp
 6e8:	89 e5                	mov    %esp,%ebp
 6ea:	53                   	push   %ebx
 6eb:	83 ec 04             	sub    $0x4,%esp
 6ee:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 6f0:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 6f5:	77 05                	ja     6fc <morecore+0x15>
    nu = 4096;
 6f7:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 6fc:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 703:	83 ec 0c             	sub    $0xc,%esp
 706:	50                   	push   %eax
 707:	e8 40 fd ff ff       	call   44c <sbrk>
  if(p == (char*)-1)
 70c:	83 c4 10             	add    $0x10,%esp
 70f:	83 f8 ff             	cmp    $0xffffffff,%eax
 712:	74 1c                	je     730 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 714:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 717:	83 c0 08             	add    $0x8,%eax
 71a:	83 ec 0c             	sub    $0xc,%esp
 71d:	50                   	push   %eax
 71e:	e8 54 ff ff ff       	call   677 <free>
  return freep;
 723:	a1 40 0b 00 00       	mov    0xb40,%eax
 728:	83 c4 10             	add    $0x10,%esp
}
 72b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 72e:	c9                   	leave  
 72f:	c3                   	ret    
    return 0;
 730:	b8 00 00 00 00       	mov    $0x0,%eax
 735:	eb f4                	jmp    72b <morecore+0x44>

00000737 <malloc>:

void*
malloc(uint nbytes)
{
 737:	55                   	push   %ebp
 738:	89 e5                	mov    %esp,%ebp
 73a:	53                   	push   %ebx
 73b:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 73e:	8b 45 08             	mov    0x8(%ebp),%eax
 741:	8d 58 07             	lea    0x7(%eax),%ebx
 744:	c1 eb 03             	shr    $0x3,%ebx
 747:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 74a:	8b 0d 40 0b 00 00    	mov    0xb40,%ecx
 750:	85 c9                	test   %ecx,%ecx
 752:	74 04                	je     758 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 754:	8b 01                	mov    (%ecx),%eax
 756:	eb 4d                	jmp    7a5 <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 758:	c7 05 40 0b 00 00 44 	movl   $0xb44,0xb40
 75f:	0b 00 00 
 762:	c7 05 44 0b 00 00 44 	movl   $0xb44,0xb44
 769:	0b 00 00 
    base.s.size = 0;
 76c:	c7 05 48 0b 00 00 00 	movl   $0x0,0xb48
 773:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 776:	b9 44 0b 00 00       	mov    $0xb44,%ecx
 77b:	eb d7                	jmp    754 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 77d:	39 da                	cmp    %ebx,%edx
 77f:	74 1a                	je     79b <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 781:	29 da                	sub    %ebx,%edx
 783:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 786:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 789:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 78c:	89 0d 40 0b 00 00    	mov    %ecx,0xb40
      return (void*)(p + 1);
 792:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 795:	83 c4 04             	add    $0x4,%esp
 798:	5b                   	pop    %ebx
 799:	5d                   	pop    %ebp
 79a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 79b:	8b 10                	mov    (%eax),%edx
 79d:	89 11                	mov    %edx,(%ecx)
 79f:	eb eb                	jmp    78c <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a1:	89 c1                	mov    %eax,%ecx
 7a3:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 7a5:	8b 50 04             	mov    0x4(%eax),%edx
 7a8:	39 da                	cmp    %ebx,%edx
 7aa:	73 d1                	jae    77d <malloc+0x46>
    if(p == freep)
 7ac:	39 05 40 0b 00 00    	cmp    %eax,0xb40
 7b2:	75 ed                	jne    7a1 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 7b4:	89 d8                	mov    %ebx,%eax
 7b6:	e8 2c ff ff ff       	call   6e7 <morecore>
 7bb:	85 c0                	test   %eax,%eax
 7bd:	75 e2                	jne    7a1 <malloc+0x6a>
        return 0;
 7bf:	b8 00 00 00 00       	mov    $0x0,%eax
 7c4:	eb cf                	jmp    795 <malloc+0x5e>
