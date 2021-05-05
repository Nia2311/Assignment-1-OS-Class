
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   8:	83 ec 04             	sub    $0x4,%esp
   b:	68 00 02 00 00       	push   $0x200
  10:	68 00 0b 00 00       	push   $0xb00
  15:	56                   	push   %esi
  16:	e8 57 03 00 00       	call   372 <read>
  1b:	89 c3                	mov    %eax,%ebx
  1d:	83 c4 10             	add    $0x10,%esp
  20:	85 c0                	test   %eax,%eax
  22:	7e 2b                	jle    4f <cat+0x4f>
    if (write(1, buf, n) != n) {
  24:	83 ec 04             	sub    $0x4,%esp
  27:	53                   	push   %ebx
  28:	68 00 0b 00 00       	push   $0xb00
  2d:	6a 01                	push   $0x1
  2f:	e8 46 03 00 00       	call   37a <write>
  34:	83 c4 10             	add    $0x10,%esp
  37:	39 d8                	cmp    %ebx,%eax
  39:	74 cd                	je     8 <cat+0x8>
      printf(1, "cat: write error\n");
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	68 5c 07 00 00       	push   $0x75c
  43:	6a 01                	push   $0x1
  45:	e8 5a 04 00 00       	call   4a4 <printf>
      exit();
  4a:	e8 0b 03 00 00       	call   35a <exit>
    }
  }
  if(n < 0){
  4f:	85 c0                	test   %eax,%eax
  51:	78 07                	js     5a <cat+0x5a>
    printf(1, "cat: read error\n");
    exit();
  }
}
  53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  56:	5b                   	pop    %ebx
  57:	5e                   	pop    %esi
  58:	5d                   	pop    %ebp
  59:	c3                   	ret    
    printf(1, "cat: read error\n");
  5a:	83 ec 08             	sub    $0x8,%esp
  5d:	68 6e 07 00 00       	push   $0x76e
  62:	6a 01                	push   $0x1
  64:	e8 3b 04 00 00       	call   4a4 <printf>
    exit();
  69:	e8 ec 02 00 00       	call   35a <exit>

0000006e <main>:

int
main(int argc, char *argv[])
{
  6e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  72:	83 e4 f0             	and    $0xfffffff0,%esp
  75:	ff 71 fc             	pushl  -0x4(%ecx)
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	57                   	push   %edi
  7c:	56                   	push   %esi
  7d:	53                   	push   %ebx
  7e:	51                   	push   %ecx
  7f:	83 ec 18             	sub    $0x18,%esp
  82:	8b 01                	mov    (%ecx),%eax
  84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  87:	8b 51 04             	mov    0x4(%ecx),%edx
  8a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  8d:	83 f8 01             	cmp    $0x1,%eax
  90:	7e 3e                	jle    d0 <main+0x62>
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  92:	bb 01 00 00 00       	mov    $0x1,%ebx
  97:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  9a:	7d 59                	jge    f5 <main+0x87>
    if((fd = open(argv[i], 0)) < 0){
  9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  9f:	8d 3c 98             	lea    (%eax,%ebx,4),%edi
  a2:	83 ec 08             	sub    $0x8,%esp
  a5:	6a 00                	push   $0x0
  a7:	ff 37                	pushl  (%edi)
  a9:	e8 ec 02 00 00       	call   39a <open>
  ae:	89 c6                	mov    %eax,%esi
  b0:	83 c4 10             	add    $0x10,%esp
  b3:	85 c0                	test   %eax,%eax
  b5:	78 28                	js     df <main+0x71>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  b7:	83 ec 0c             	sub    $0xc,%esp
  ba:	50                   	push   %eax
  bb:	e8 40 ff ff ff       	call   0 <cat>
    close(fd);
  c0:	89 34 24             	mov    %esi,(%esp)
  c3:	e8 ba 02 00 00       	call   382 <close>
  for(i = 1; i < argc; i++){
  c8:	83 c3 01             	add    $0x1,%ebx
  cb:	83 c4 10             	add    $0x10,%esp
  ce:	eb c7                	jmp    97 <main+0x29>
    cat(0);
  d0:	83 ec 0c             	sub    $0xc,%esp
  d3:	6a 00                	push   $0x0
  d5:	e8 26 ff ff ff       	call   0 <cat>
    exit();
  da:	e8 7b 02 00 00       	call   35a <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  df:	83 ec 04             	sub    $0x4,%esp
  e2:	ff 37                	pushl  (%edi)
  e4:	68 7f 07 00 00       	push   $0x77f
  e9:	6a 01                	push   $0x1
  eb:	e8 b4 03 00 00       	call   4a4 <printf>
      exit();
  f0:	e8 65 02 00 00       	call   35a <exit>
  }
  exit();
  f5:	e8 60 02 00 00       	call   35a <exit>

000000fa <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	53                   	push   %ebx
  fe:	8b 45 08             	mov    0x8(%ebp),%eax
 101:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 104:	89 c2                	mov    %eax,%edx
 106:	0f b6 19             	movzbl (%ecx),%ebx
 109:	88 1a                	mov    %bl,(%edx)
 10b:	8d 52 01             	lea    0x1(%edx),%edx
 10e:	8d 49 01             	lea    0x1(%ecx),%ecx
 111:	84 db                	test   %bl,%bl
 113:	75 f1                	jne    106 <strcpy+0xc>
    ;
  return os;
}
 115:	5b                   	pop    %ebx
 116:	5d                   	pop    %ebp
 117:	c3                   	ret    

00000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 121:	eb 06                	jmp    129 <strcmp+0x11>
    p++, q++;
 123:	83 c1 01             	add    $0x1,%ecx
 126:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 129:	0f b6 01             	movzbl (%ecx),%eax
 12c:	84 c0                	test   %al,%al
 12e:	74 04                	je     134 <strcmp+0x1c>
 130:	3a 02                	cmp    (%edx),%al
 132:	74 ef                	je     123 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 134:	0f b6 c0             	movzbl %al,%eax
 137:	0f b6 12             	movzbl (%edx),%edx
 13a:	29 d0                	sub    %edx,%eax
}
 13c:	5d                   	pop    %ebp
 13d:	c3                   	ret    

0000013e <strlen>:

uint
strlen(char *s)
{
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 144:	ba 00 00 00 00       	mov    $0x0,%edx
 149:	eb 03                	jmp    14e <strlen+0x10>
 14b:	83 c2 01             	add    $0x1,%edx
 14e:	89 d0                	mov    %edx,%eax
 150:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 154:	75 f5                	jne    14b <strlen+0xd>
    ;
  return n;
}
 156:	5d                   	pop    %ebp
 157:	c3                   	ret    

00000158 <memset>:

void*
memset(void *dst, int c, uint n)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	57                   	push   %edi
 15c:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 15f:	89 d7                	mov    %edx,%edi
 161:	8b 4d 10             	mov    0x10(%ebp),%ecx
 164:	8b 45 0c             	mov    0xc(%ebp),%eax
 167:	fc                   	cld    
 168:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 16a:	89 d0                	mov    %edx,%eax
 16c:	5f                   	pop    %edi
 16d:	5d                   	pop    %ebp
 16e:	c3                   	ret    

0000016f <strchr>:

char*
strchr(const char *s, char c)
{
 16f:	55                   	push   %ebp
 170:	89 e5                	mov    %esp,%ebp
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 179:	0f b6 10             	movzbl (%eax),%edx
 17c:	84 d2                	test   %dl,%dl
 17e:	74 09                	je     189 <strchr+0x1a>
    if(*s == c)
 180:	38 ca                	cmp    %cl,%dl
 182:	74 0a                	je     18e <strchr+0x1f>
  for(; *s; s++)
 184:	83 c0 01             	add    $0x1,%eax
 187:	eb f0                	jmp    179 <strchr+0xa>
      return (char*)s;
  return 0;
 189:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18e:	5d                   	pop    %ebp
 18f:	c3                   	ret    

00000190 <gets>:

char*
gets(char *buf, int max)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	56                   	push   %esi
 195:	53                   	push   %ebx
 196:	83 ec 1c             	sub    $0x1c,%esp
 199:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19c:	bb 00 00 00 00       	mov    $0x0,%ebx
 1a1:	8d 73 01             	lea    0x1(%ebx),%esi
 1a4:	3b 75 0c             	cmp    0xc(%ebp),%esi
 1a7:	7d 2e                	jge    1d7 <gets+0x47>
    cc = read(0, &c, 1);
 1a9:	83 ec 04             	sub    $0x4,%esp
 1ac:	6a 01                	push   $0x1
 1ae:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1b1:	50                   	push   %eax
 1b2:	6a 00                	push   $0x0
 1b4:	e8 b9 01 00 00       	call   372 <read>
    if(cc < 1)
 1b9:	83 c4 10             	add    $0x10,%esp
 1bc:	85 c0                	test   %eax,%eax
 1be:	7e 17                	jle    1d7 <gets+0x47>
      break;
    buf[i++] = c;
 1c0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1c4:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 1c7:	3c 0a                	cmp    $0xa,%al
 1c9:	0f 94 c2             	sete   %dl
 1cc:	3c 0d                	cmp    $0xd,%al
 1ce:	0f 94 c0             	sete   %al
    buf[i++] = c;
 1d1:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 1d3:	08 c2                	or     %al,%dl
 1d5:	74 ca                	je     1a1 <gets+0x11>
      break;
  }
  buf[i] = '\0';
 1d7:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 1db:	89 f8                	mov    %edi,%eax
 1dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1e0:	5b                   	pop    %ebx
 1e1:	5e                   	pop    %esi
 1e2:	5f                   	pop    %edi
 1e3:	5d                   	pop    %ebp
 1e4:	c3                   	ret    

000001e5 <stat>:

int
stat(char *n, struct stat *st)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	56                   	push   %esi
 1e9:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ea:	83 ec 08             	sub    $0x8,%esp
 1ed:	6a 00                	push   $0x0
 1ef:	ff 75 08             	pushl  0x8(%ebp)
 1f2:	e8 a3 01 00 00       	call   39a <open>
  if(fd < 0)
 1f7:	83 c4 10             	add    $0x10,%esp
 1fa:	85 c0                	test   %eax,%eax
 1fc:	78 24                	js     222 <stat+0x3d>
 1fe:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 200:	83 ec 08             	sub    $0x8,%esp
 203:	ff 75 0c             	pushl  0xc(%ebp)
 206:	50                   	push   %eax
 207:	e8 a6 01 00 00       	call   3b2 <fstat>
 20c:	89 c6                	mov    %eax,%esi
  close(fd);
 20e:	89 1c 24             	mov    %ebx,(%esp)
 211:	e8 6c 01 00 00       	call   382 <close>
  return r;
 216:	83 c4 10             	add    $0x10,%esp
}
 219:	89 f0                	mov    %esi,%eax
 21b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 21e:	5b                   	pop    %ebx
 21f:	5e                   	pop    %esi
 220:	5d                   	pop    %ebp
 221:	c3                   	ret    
    return -1;
 222:	be ff ff ff ff       	mov    $0xffffffff,%esi
 227:	eb f0                	jmp    219 <stat+0x34>

00000229 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
 22c:	57                   	push   %edi
 22d:	56                   	push   %esi
 22e:	53                   	push   %ebx
 22f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 232:	eb 03                	jmp    237 <atoi+0xe>
 234:	83 c2 01             	add    $0x1,%edx
 237:	0f b6 02             	movzbl (%edx),%eax
 23a:	3c 20                	cmp    $0x20,%al
 23c:	74 f6                	je     234 <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 23e:	3c 2d                	cmp    $0x2d,%al
 240:	74 1d                	je     25f <atoi+0x36>
 242:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 247:	3c 2b                	cmp    $0x2b,%al
 249:	0f 94 c1             	sete   %cl
 24c:	3c 2d                	cmp    $0x2d,%al
 24e:	0f 94 c0             	sete   %al
 251:	08 c1                	or     %al,%cl
 253:	74 03                	je     258 <atoi+0x2f>
    s++;
 255:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 258:	b8 00 00 00 00       	mov    $0x0,%eax
 25d:	eb 17                	jmp    276 <atoi+0x4d>
 25f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 264:	eb e1                	jmp    247 <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 266:	8d 34 80             	lea    (%eax,%eax,4),%esi
 269:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 26c:	83 c2 01             	add    $0x1,%edx
 26f:	0f be c9             	movsbl %cl,%ecx
 272:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 276:	0f b6 0a             	movzbl (%edx),%ecx
 279:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 27c:	80 fb 09             	cmp    $0x9,%bl
 27f:	76 e5                	jbe    266 <atoi+0x3d>
  return sign*n;
 281:	0f af c7             	imul   %edi,%eax
}
 284:	5b                   	pop    %ebx
 285:	5e                   	pop    %esi
 286:	5f                   	pop    %edi
 287:	5d                   	pop    %ebp
 288:	c3                   	ret    

00000289 <atoo>:

int
atoo(const char *s)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	57                   	push   %edi
 28d:	56                   	push   %esi
 28e:	53                   	push   %ebx
 28f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 292:	eb 03                	jmp    297 <atoo+0xe>
 294:	83 c2 01             	add    $0x1,%edx
 297:	0f b6 0a             	movzbl (%edx),%ecx
 29a:	80 f9 20             	cmp    $0x20,%cl
 29d:	74 f5                	je     294 <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 29f:	80 f9 2d             	cmp    $0x2d,%cl
 2a2:	74 23                	je     2c7 <atoo+0x3e>
 2a4:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 2a9:	80 f9 2b             	cmp    $0x2b,%cl
 2ac:	0f 94 c0             	sete   %al
 2af:	89 c6                	mov    %eax,%esi
 2b1:	80 f9 2d             	cmp    $0x2d,%cl
 2b4:	0f 94 c0             	sete   %al
 2b7:	89 f3                	mov    %esi,%ebx
 2b9:	08 c3                	or     %al,%bl
 2bb:	74 03                	je     2c0 <atoo+0x37>
    s++;
 2bd:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 2c0:	b8 00 00 00 00       	mov    $0x0,%eax
 2c5:	eb 11                	jmp    2d8 <atoo+0x4f>
 2c7:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 2cc:	eb db                	jmp    2a9 <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 2ce:	83 c2 01             	add    $0x1,%edx
 2d1:	0f be c9             	movsbl %cl,%ecx
 2d4:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 2d8:	0f b6 0a             	movzbl (%edx),%ecx
 2db:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2de:	80 fb 07             	cmp    $0x7,%bl
 2e1:	76 eb                	jbe    2ce <atoo+0x45>
  return sign*n;
 2e3:	0f af c7             	imul   %edi,%eax
}
 2e6:	5b                   	pop    %ebx
 2e7:	5e                   	pop    %esi
 2e8:	5f                   	pop    %edi
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    

000002eb <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp
 2ee:	53                   	push   %ebx
 2ef:	8b 55 08             	mov    0x8(%ebp),%edx
 2f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2f5:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 2f8:	eb 09                	jmp    303 <strncmp+0x18>
      n--, p++, q++;
 2fa:	83 e8 01             	sub    $0x1,%eax
 2fd:	83 c2 01             	add    $0x1,%edx
 300:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 303:	85 c0                	test   %eax,%eax
 305:	74 0b                	je     312 <strncmp+0x27>
 307:	0f b6 1a             	movzbl (%edx),%ebx
 30a:	84 db                	test   %bl,%bl
 30c:	74 04                	je     312 <strncmp+0x27>
 30e:	3a 19                	cmp    (%ecx),%bl
 310:	74 e8                	je     2fa <strncmp+0xf>
    if(n == 0)
 312:	85 c0                	test   %eax,%eax
 314:	74 0b                	je     321 <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 316:	0f b6 02             	movzbl (%edx),%eax
 319:	0f b6 11             	movzbl (%ecx),%edx
 31c:	29 d0                	sub    %edx,%eax
}
 31e:	5b                   	pop    %ebx
 31f:	5d                   	pop    %ebp
 320:	c3                   	ret    
      return 0;
 321:	b8 00 00 00 00       	mov    $0x0,%eax
 326:	eb f6                	jmp    31e <strncmp+0x33>

00000328 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 328:	55                   	push   %ebp
 329:	89 e5                	mov    %esp,%ebp
 32b:	56                   	push   %esi
 32c:	53                   	push   %ebx
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 333:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 336:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 338:	eb 0d                	jmp    347 <memmove+0x1f>
    *dst++ = *src++;
 33a:	0f b6 13             	movzbl (%ebx),%edx
 33d:	88 11                	mov    %dl,(%ecx)
 33f:	8d 5b 01             	lea    0x1(%ebx),%ebx
 342:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 345:	89 f2                	mov    %esi,%edx
 347:	8d 72 ff             	lea    -0x1(%edx),%esi
 34a:	85 d2                	test   %edx,%edx
 34c:	7f ec                	jg     33a <memmove+0x12>
  return vdst;
}
 34e:	5b                   	pop    %ebx
 34f:	5e                   	pop    %esi
 350:	5d                   	pop    %ebp
 351:	c3                   	ret    

00000352 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 352:	b8 01 00 00 00       	mov    $0x1,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <exit>:
SYSCALL(exit)
 35a:	b8 02 00 00 00       	mov    $0x2,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <wait>:
SYSCALL(wait)
 362:	b8 03 00 00 00       	mov    $0x3,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <pipe>:
SYSCALL(pipe)
 36a:	b8 04 00 00 00       	mov    $0x4,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <read>:
SYSCALL(read)
 372:	b8 05 00 00 00       	mov    $0x5,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <write>:
SYSCALL(write)
 37a:	b8 10 00 00 00       	mov    $0x10,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <close>:
SYSCALL(close)
 382:	b8 15 00 00 00       	mov    $0x15,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <kill>:
SYSCALL(kill)
 38a:	b8 06 00 00 00       	mov    $0x6,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <exec>:
SYSCALL(exec)
 392:	b8 07 00 00 00       	mov    $0x7,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <open>:
SYSCALL(open)
 39a:	b8 0f 00 00 00       	mov    $0xf,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <mknod>:
SYSCALL(mknod)
 3a2:	b8 11 00 00 00       	mov    $0x11,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <unlink>:
SYSCALL(unlink)
 3aa:	b8 12 00 00 00       	mov    $0x12,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <fstat>:
SYSCALL(fstat)
 3b2:	b8 08 00 00 00       	mov    $0x8,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <link>:
SYSCALL(link)
 3ba:	b8 13 00 00 00       	mov    $0x13,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <mkdir>:
SYSCALL(mkdir)
 3c2:	b8 14 00 00 00       	mov    $0x14,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <chdir>:
SYSCALL(chdir)
 3ca:	b8 09 00 00 00       	mov    $0x9,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <dup>:
SYSCALL(dup)
 3d2:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <getpid>:
SYSCALL(getpid)
 3da:	b8 0b 00 00 00       	mov    $0xb,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <sbrk>:
SYSCALL(sbrk)
 3e2:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <sleep>:
SYSCALL(sleep)
 3ea:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <uptime>:
SYSCALL(uptime)
 3f2:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <halt>:
SYSCALL(halt)
 3fa:	b8 16 00 00 00       	mov    $0x16,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <date>:
SYSCALL(date)
 402:	b8 17 00 00 00       	mov    $0x17,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 40a:	55                   	push   %ebp
 40b:	89 e5                	mov    %esp,%ebp
 40d:	83 ec 1c             	sub    $0x1c,%esp
 410:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 413:	6a 01                	push   $0x1
 415:	8d 55 f4             	lea    -0xc(%ebp),%edx
 418:	52                   	push   %edx
 419:	50                   	push   %eax
 41a:	e8 5b ff ff ff       	call   37a <write>
}
 41f:	83 c4 10             	add    $0x10,%esp
 422:	c9                   	leave  
 423:	c3                   	ret    

00000424 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	57                   	push   %edi
 428:	56                   	push   %esi
 429:	53                   	push   %ebx
 42a:	83 ec 2c             	sub    $0x2c,%esp
 42d:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 42f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 433:	0f 95 c3             	setne  %bl
 436:	89 d0                	mov    %edx,%eax
 438:	c1 e8 1f             	shr    $0x1f,%eax
 43b:	84 c3                	test   %al,%bl
 43d:	74 10                	je     44f <printint+0x2b>
    neg = 1;
    x = -xx;
 43f:	f7 da                	neg    %edx
    neg = 1;
 441:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 448:	be 00 00 00 00       	mov    $0x0,%esi
 44d:	eb 0b                	jmp    45a <printint+0x36>
  neg = 0;
 44f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 456:	eb f0                	jmp    448 <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 458:	89 c6                	mov    %eax,%esi
 45a:	89 d0                	mov    %edx,%eax
 45c:	ba 00 00 00 00       	mov    $0x0,%edx
 461:	f7 f1                	div    %ecx
 463:	89 c3                	mov    %eax,%ebx
 465:	8d 46 01             	lea    0x1(%esi),%eax
 468:	0f b6 92 9c 07 00 00 	movzbl 0x79c(%edx),%edx
 46f:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 473:	89 da                	mov    %ebx,%edx
 475:	85 db                	test   %ebx,%ebx
 477:	75 df                	jne    458 <printint+0x34>
 479:	89 c3                	mov    %eax,%ebx
  if(neg)
 47b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 47f:	74 16                	je     497 <printint+0x73>
    buf[i++] = '-';
 481:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 486:	8d 5e 02             	lea    0x2(%esi),%ebx
 489:	eb 0c                	jmp    497 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 48b:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 490:	89 f8                	mov    %edi,%eax
 492:	e8 73 ff ff ff       	call   40a <putc>
  while(--i >= 0)
 497:	83 eb 01             	sub    $0x1,%ebx
 49a:	79 ef                	jns    48b <printint+0x67>
}
 49c:	83 c4 2c             	add    $0x2c,%esp
 49f:	5b                   	pop    %ebx
 4a0:	5e                   	pop    %esi
 4a1:	5f                   	pop    %edi
 4a2:	5d                   	pop    %ebp
 4a3:	c3                   	ret    

000004a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	57                   	push   %edi
 4a8:	56                   	push   %esi
 4a9:	53                   	push   %ebx
 4aa:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4ad:	8d 45 10             	lea    0x10(%ebp),%eax
 4b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4b3:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4b8:	bb 00 00 00 00       	mov    $0x0,%ebx
 4bd:	eb 14                	jmp    4d3 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4bf:	89 fa                	mov    %edi,%edx
 4c1:	8b 45 08             	mov    0x8(%ebp),%eax
 4c4:	e8 41 ff ff ff       	call   40a <putc>
 4c9:	eb 05                	jmp    4d0 <printf+0x2c>
      }
    } else if(state == '%'){
 4cb:	83 fe 25             	cmp    $0x25,%esi
 4ce:	74 25                	je     4f5 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 4d0:	83 c3 01             	add    $0x1,%ebx
 4d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d6:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4da:	84 c0                	test   %al,%al
 4dc:	0f 84 23 01 00 00    	je     605 <printf+0x161>
    c = fmt[i] & 0xff;
 4e2:	0f be f8             	movsbl %al,%edi
 4e5:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4e8:	85 f6                	test   %esi,%esi
 4ea:	75 df                	jne    4cb <printf+0x27>
      if(c == '%'){
 4ec:	83 f8 25             	cmp    $0x25,%eax
 4ef:	75 ce                	jne    4bf <printf+0x1b>
        state = '%';
 4f1:	89 c6                	mov    %eax,%esi
 4f3:	eb db                	jmp    4d0 <printf+0x2c>
      if(c == 'd'){
 4f5:	83 f8 64             	cmp    $0x64,%eax
 4f8:	74 49                	je     543 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4fa:	83 f8 78             	cmp    $0x78,%eax
 4fd:	0f 94 c1             	sete   %cl
 500:	83 f8 70             	cmp    $0x70,%eax
 503:	0f 94 c2             	sete   %dl
 506:	08 d1                	or     %dl,%cl
 508:	75 63                	jne    56d <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 50a:	83 f8 73             	cmp    $0x73,%eax
 50d:	0f 84 84 00 00 00    	je     597 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 513:	83 f8 63             	cmp    $0x63,%eax
 516:	0f 84 b7 00 00 00    	je     5d3 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 51c:	83 f8 25             	cmp    $0x25,%eax
 51f:	0f 84 cc 00 00 00    	je     5f1 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 525:	ba 25 00 00 00       	mov    $0x25,%edx
 52a:	8b 45 08             	mov    0x8(%ebp),%eax
 52d:	e8 d8 fe ff ff       	call   40a <putc>
        putc(fd, c);
 532:	89 fa                	mov    %edi,%edx
 534:	8b 45 08             	mov    0x8(%ebp),%eax
 537:	e8 ce fe ff ff       	call   40a <putc>
      }
      state = 0;
 53c:	be 00 00 00 00       	mov    $0x0,%esi
 541:	eb 8d                	jmp    4d0 <printf+0x2c>
        printint(fd, *ap, 10, 1);
 543:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 546:	8b 17                	mov    (%edi),%edx
 548:	83 ec 0c             	sub    $0xc,%esp
 54b:	6a 01                	push   $0x1
 54d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 552:	8b 45 08             	mov    0x8(%ebp),%eax
 555:	e8 ca fe ff ff       	call   424 <printint>
        ap++;
 55a:	83 c7 04             	add    $0x4,%edi
 55d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 560:	83 c4 10             	add    $0x10,%esp
      state = 0;
 563:	be 00 00 00 00       	mov    $0x0,%esi
 568:	e9 63 ff ff ff       	jmp    4d0 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 56d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 570:	8b 17                	mov    (%edi),%edx
 572:	83 ec 0c             	sub    $0xc,%esp
 575:	6a 00                	push   $0x0
 577:	b9 10 00 00 00       	mov    $0x10,%ecx
 57c:	8b 45 08             	mov    0x8(%ebp),%eax
 57f:	e8 a0 fe ff ff       	call   424 <printint>
        ap++;
 584:	83 c7 04             	add    $0x4,%edi
 587:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 58a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58d:	be 00 00 00 00       	mov    $0x0,%esi
 592:	e9 39 ff ff ff       	jmp    4d0 <printf+0x2c>
        s = (char*)*ap;
 597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59a:	8b 30                	mov    (%eax),%esi
        ap++;
 59c:	83 c0 04             	add    $0x4,%eax
 59f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5a2:	85 f6                	test   %esi,%esi
 5a4:	75 28                	jne    5ce <printf+0x12a>
          s = "(null)";
 5a6:	be 94 07 00 00       	mov    $0x794,%esi
 5ab:	8b 7d 08             	mov    0x8(%ebp),%edi
 5ae:	eb 0d                	jmp    5bd <printf+0x119>
          putc(fd, *s);
 5b0:	0f be d2             	movsbl %dl,%edx
 5b3:	89 f8                	mov    %edi,%eax
 5b5:	e8 50 fe ff ff       	call   40a <putc>
          s++;
 5ba:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5bd:	0f b6 16             	movzbl (%esi),%edx
 5c0:	84 d2                	test   %dl,%dl
 5c2:	75 ec                	jne    5b0 <printf+0x10c>
      state = 0;
 5c4:	be 00 00 00 00       	mov    $0x0,%esi
 5c9:	e9 02 ff ff ff       	jmp    4d0 <printf+0x2c>
 5ce:	8b 7d 08             	mov    0x8(%ebp),%edi
 5d1:	eb ea                	jmp    5bd <printf+0x119>
        putc(fd, *ap);
 5d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5d6:	0f be 17             	movsbl (%edi),%edx
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	e8 29 fe ff ff       	call   40a <putc>
        ap++;
 5e1:	83 c7 04             	add    $0x4,%edi
 5e4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5e7:	be 00 00 00 00       	mov    $0x0,%esi
 5ec:	e9 df fe ff ff       	jmp    4d0 <printf+0x2c>
        putc(fd, c);
 5f1:	89 fa                	mov    %edi,%edx
 5f3:	8b 45 08             	mov    0x8(%ebp),%eax
 5f6:	e8 0f fe ff ff       	call   40a <putc>
      state = 0;
 5fb:	be 00 00 00 00       	mov    $0x0,%esi
 600:	e9 cb fe ff ff       	jmp    4d0 <printf+0x2c>
    }
  }
}
 605:	8d 65 f4             	lea    -0xc(%ebp),%esp
 608:	5b                   	pop    %ebx
 609:	5e                   	pop    %esi
 60a:	5f                   	pop    %edi
 60b:	5d                   	pop    %ebp
 60c:	c3                   	ret    

0000060d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60d:	55                   	push   %ebp
 60e:	89 e5                	mov    %esp,%ebp
 610:	57                   	push   %edi
 611:	56                   	push   %esi
 612:	53                   	push   %ebx
 613:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 616:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 619:	a1 e0 0a 00 00       	mov    0xae0,%eax
 61e:	eb 02                	jmp    622 <free+0x15>
 620:	89 d0                	mov    %edx,%eax
 622:	39 c8                	cmp    %ecx,%eax
 624:	73 04                	jae    62a <free+0x1d>
 626:	39 08                	cmp    %ecx,(%eax)
 628:	77 12                	ja     63c <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62a:	8b 10                	mov    (%eax),%edx
 62c:	39 c2                	cmp    %eax,%edx
 62e:	77 f0                	ja     620 <free+0x13>
 630:	39 c8                	cmp    %ecx,%eax
 632:	72 08                	jb     63c <free+0x2f>
 634:	39 ca                	cmp    %ecx,%edx
 636:	77 04                	ja     63c <free+0x2f>
 638:	89 d0                	mov    %edx,%eax
 63a:	eb e6                	jmp    622 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 63c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 63f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 642:	8b 10                	mov    (%eax),%edx
 644:	39 d7                	cmp    %edx,%edi
 646:	74 19                	je     661 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 648:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 64b:	8b 50 04             	mov    0x4(%eax),%edx
 64e:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 651:	39 ce                	cmp    %ecx,%esi
 653:	74 1b                	je     670 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 655:	89 08                	mov    %ecx,(%eax)
  freep = p;
 657:	a3 e0 0a 00 00       	mov    %eax,0xae0
}
 65c:	5b                   	pop    %ebx
 65d:	5e                   	pop    %esi
 65e:	5f                   	pop    %edi
 65f:	5d                   	pop    %ebp
 660:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 661:	03 72 04             	add    0x4(%edx),%esi
 664:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 667:	8b 10                	mov    (%eax),%edx
 669:	8b 12                	mov    (%edx),%edx
 66b:	89 53 f8             	mov    %edx,-0x8(%ebx)
 66e:	eb db                	jmp    64b <free+0x3e>
    p->s.size += bp->s.size;
 670:	03 53 fc             	add    -0x4(%ebx),%edx
 673:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 676:	8b 53 f8             	mov    -0x8(%ebx),%edx
 679:	89 10                	mov    %edx,(%eax)
 67b:	eb da                	jmp    657 <free+0x4a>

0000067d <morecore>:

static Header*
morecore(uint nu)
{
 67d:	55                   	push   %ebp
 67e:	89 e5                	mov    %esp,%ebp
 680:	53                   	push   %ebx
 681:	83 ec 04             	sub    $0x4,%esp
 684:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 686:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 68b:	77 05                	ja     692 <morecore+0x15>
    nu = 4096;
 68d:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 692:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 699:	83 ec 0c             	sub    $0xc,%esp
 69c:	50                   	push   %eax
 69d:	e8 40 fd ff ff       	call   3e2 <sbrk>
  if(p == (char*)-1)
 6a2:	83 c4 10             	add    $0x10,%esp
 6a5:	83 f8 ff             	cmp    $0xffffffff,%eax
 6a8:	74 1c                	je     6c6 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6aa:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6ad:	83 c0 08             	add    $0x8,%eax
 6b0:	83 ec 0c             	sub    $0xc,%esp
 6b3:	50                   	push   %eax
 6b4:	e8 54 ff ff ff       	call   60d <free>
  return freep;
 6b9:	a1 e0 0a 00 00       	mov    0xae0,%eax
 6be:	83 c4 10             	add    $0x10,%esp
}
 6c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6c4:	c9                   	leave  
 6c5:	c3                   	ret    
    return 0;
 6c6:	b8 00 00 00 00       	mov    $0x0,%eax
 6cb:	eb f4                	jmp    6c1 <morecore+0x44>

000006cd <malloc>:

void*
malloc(uint nbytes)
{
 6cd:	55                   	push   %ebp
 6ce:	89 e5                	mov    %esp,%ebp
 6d0:	53                   	push   %ebx
 6d1:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d4:	8b 45 08             	mov    0x8(%ebp),%eax
 6d7:	8d 58 07             	lea    0x7(%eax),%ebx
 6da:	c1 eb 03             	shr    $0x3,%ebx
 6dd:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6e0:	8b 0d e0 0a 00 00    	mov    0xae0,%ecx
 6e6:	85 c9                	test   %ecx,%ecx
 6e8:	74 04                	je     6ee <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ea:	8b 01                	mov    (%ecx),%eax
 6ec:	eb 4d                	jmp    73b <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 6ee:	c7 05 e0 0a 00 00 e4 	movl   $0xae4,0xae0
 6f5:	0a 00 00 
 6f8:	c7 05 e4 0a 00 00 e4 	movl   $0xae4,0xae4
 6ff:	0a 00 00 
    base.s.size = 0;
 702:	c7 05 e8 0a 00 00 00 	movl   $0x0,0xae8
 709:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 70c:	b9 e4 0a 00 00       	mov    $0xae4,%ecx
 711:	eb d7                	jmp    6ea <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 713:	39 da                	cmp    %ebx,%edx
 715:	74 1a                	je     731 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 717:	29 da                	sub    %ebx,%edx
 719:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 71c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 71f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 722:	89 0d e0 0a 00 00    	mov    %ecx,0xae0
      return (void*)(p + 1);
 728:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 72b:	83 c4 04             	add    $0x4,%esp
 72e:	5b                   	pop    %ebx
 72f:	5d                   	pop    %ebp
 730:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 731:	8b 10                	mov    (%eax),%edx
 733:	89 11                	mov    %edx,(%ecx)
 735:	eb eb                	jmp    722 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 737:	89 c1                	mov    %eax,%ecx
 739:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 73b:	8b 50 04             	mov    0x4(%eax),%edx
 73e:	39 da                	cmp    %ebx,%edx
 740:	73 d1                	jae    713 <malloc+0x46>
    if(p == freep)
 742:	39 05 e0 0a 00 00    	cmp    %eax,0xae0
 748:	75 ed                	jne    737 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 74a:	89 d8                	mov    %ebx,%eax
 74c:	e8 2c ff ff ff       	call   67d <morecore>
 751:	85 c0                	test   %eax,%eax
 753:	75 e2                	jne    737 <malloc+0x6a>
        return 0;
 755:	b8 00 00 00 00       	mov    $0x0,%eax
 75a:	eb cf                	jmp    72b <malloc+0x5e>
