
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  16:	c7 45 de 73 74 72 65 	movl   $0x65727473,-0x22(%ebp)
  1d:	c7 45 e2 73 73 66 73 	movl   $0x73667373,-0x1e(%ebp)
  24:	66 c7 45 e6 30 00    	movw   $0x30,-0x1a(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  2a:	68 80 07 00 00       	push   $0x780
  2f:	6a 01                	push   $0x1
  31:	e8 90 04 00 00       	call   4c6 <printf>
  memset(data, 'a', sizeof(data));
  36:	83 c4 0c             	add    $0xc,%esp
  39:	68 00 02 00 00       	push   $0x200
  3e:	6a 61                	push   $0x61
  40:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  46:	50                   	push   %eax
  47:	e8 2e 01 00 00       	call   17a <memset>

  for(i = 0; i < 4; i++)
  4c:	83 c4 10             	add    $0x10,%esp
  4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  54:	83 fb 03             	cmp    $0x3,%ebx
  57:	7f 0e                	jg     67 <main+0x67>
    if(fork() > 0)
  59:	e8 16 03 00 00       	call   374 <fork>
  5e:	85 c0                	test   %eax,%eax
  60:	7f 05                	jg     67 <main+0x67>
  for(i = 0; i < 4; i++)
  62:	83 c3 01             	add    $0x1,%ebx
  65:	eb ed                	jmp    54 <main+0x54>
      break;

  printf(1, "write %d\n", i);
  67:	83 ec 04             	sub    $0x4,%esp
  6a:	53                   	push   %ebx
  6b:	68 93 07 00 00       	push   $0x793
  70:	6a 01                	push   $0x1
  72:	e8 4f 04 00 00       	call   4c6 <printf>

  path[8] += i;
  77:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  7a:	83 c4 08             	add    $0x8,%esp
  7d:	68 02 02 00 00       	push   $0x202
  82:	8d 45 de             	lea    -0x22(%ebp),%eax
  85:	50                   	push   %eax
  86:	e8 31 03 00 00       	call   3bc <open>
  8b:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++)
  8d:	83 c4 10             	add    $0x10,%esp
  90:	bb 00 00 00 00       	mov    $0x0,%ebx
  95:	eb 1b                	jmp    b2 <main+0xb2>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  97:	83 ec 04             	sub    $0x4,%esp
  9a:	68 00 02 00 00       	push   $0x200
  9f:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  a5:	50                   	push   %eax
  a6:	56                   	push   %esi
  a7:	e8 f0 02 00 00       	call   39c <write>
  for(i = 0; i < 20; i++)
  ac:	83 c3 01             	add    $0x1,%ebx
  af:	83 c4 10             	add    $0x10,%esp
  b2:	83 fb 13             	cmp    $0x13,%ebx
  b5:	7e e0                	jle    97 <main+0x97>
  close(fd);
  b7:	83 ec 0c             	sub    $0xc,%esp
  ba:	56                   	push   %esi
  bb:	e8 e4 02 00 00       	call   3a4 <close>

  printf(1, "read\n");
  c0:	83 c4 08             	add    $0x8,%esp
  c3:	68 9d 07 00 00       	push   $0x79d
  c8:	6a 01                	push   $0x1
  ca:	e8 f7 03 00 00       	call   4c6 <printf>

  fd = open(path, O_RDONLY);
  cf:	83 c4 08             	add    $0x8,%esp
  d2:	6a 00                	push   $0x0
  d4:	8d 45 de             	lea    -0x22(%ebp),%eax
  d7:	50                   	push   %eax
  d8:	e8 df 02 00 00       	call   3bc <open>
  dd:	89 c6                	mov    %eax,%esi
  for (i = 0; i < 20; i++)
  df:	83 c4 10             	add    $0x10,%esp
  e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  e7:	eb 1b                	jmp    104 <main+0x104>
    read(fd, data, sizeof(data));
  e9:	83 ec 04             	sub    $0x4,%esp
  ec:	68 00 02 00 00       	push   $0x200
  f1:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  f7:	50                   	push   %eax
  f8:	56                   	push   %esi
  f9:	e8 96 02 00 00       	call   394 <read>
  for (i = 0; i < 20; i++)
  fe:	83 c3 01             	add    $0x1,%ebx
 101:	83 c4 10             	add    $0x10,%esp
 104:	83 fb 13             	cmp    $0x13,%ebx
 107:	7e e0                	jle    e9 <main+0xe9>
  close(fd);
 109:	83 ec 0c             	sub    $0xc,%esp
 10c:	56                   	push   %esi
 10d:	e8 92 02 00 00       	call   3a4 <close>

  wait();
 112:	e8 6d 02 00 00       	call   384 <wait>

  exit();
 117:	e8 60 02 00 00       	call   37c <exit>

0000011c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	53                   	push   %ebx
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 126:	89 c2                	mov    %eax,%edx
 128:	0f b6 19             	movzbl (%ecx),%ebx
 12b:	88 1a                	mov    %bl,(%edx)
 12d:	8d 52 01             	lea    0x1(%edx),%edx
 130:	8d 49 01             	lea    0x1(%ecx),%ecx
 133:	84 db                	test   %bl,%bl
 135:	75 f1                	jne    128 <strcpy+0xc>
    ;
  return os;
}
 137:	5b                   	pop    %ebx
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 140:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 143:	eb 06                	jmp    14b <strcmp+0x11>
    p++, q++;
 145:	83 c1 01             	add    $0x1,%ecx
 148:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 14b:	0f b6 01             	movzbl (%ecx),%eax
 14e:	84 c0                	test   %al,%al
 150:	74 04                	je     156 <strcmp+0x1c>
 152:	3a 02                	cmp    (%edx),%al
 154:	74 ef                	je     145 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 156:	0f b6 c0             	movzbl %al,%eax
 159:	0f b6 12             	movzbl (%edx),%edx
 15c:	29 d0                	sub    %edx,%eax
}
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <strlen>:

uint
strlen(char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 166:	ba 00 00 00 00       	mov    $0x0,%edx
 16b:	eb 03                	jmp    170 <strlen+0x10>
 16d:	83 c2 01             	add    $0x1,%edx
 170:	89 d0                	mov    %edx,%eax
 172:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 176:	75 f5                	jne    16d <strlen+0xd>
    ;
  return n;
}
 178:	5d                   	pop    %ebp
 179:	c3                   	ret    

0000017a <memset>:

void*
memset(void *dst, int c, uint n)
{
 17a:	55                   	push   %ebp
 17b:	89 e5                	mov    %esp,%ebp
 17d:	57                   	push   %edi
 17e:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 181:	89 d7                	mov    %edx,%edi
 183:	8b 4d 10             	mov    0x10(%ebp),%ecx
 186:	8b 45 0c             	mov    0xc(%ebp),%eax
 189:	fc                   	cld    
 18a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 18c:	89 d0                	mov    %edx,%eax
 18e:	5f                   	pop    %edi
 18f:	5d                   	pop    %ebp
 190:	c3                   	ret    

00000191 <strchr>:

char*
strchr(const char *s, char c)
{
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 19b:	0f b6 10             	movzbl (%eax),%edx
 19e:	84 d2                	test   %dl,%dl
 1a0:	74 09                	je     1ab <strchr+0x1a>
    if(*s == c)
 1a2:	38 ca                	cmp    %cl,%dl
 1a4:	74 0a                	je     1b0 <strchr+0x1f>
  for(; *s; s++)
 1a6:	83 c0 01             	add    $0x1,%eax
 1a9:	eb f0                	jmp    19b <strchr+0xa>
      return (char*)s;
  return 0;
 1ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b0:	5d                   	pop    %ebp
 1b1:	c3                   	ret    

000001b2 <gets>:

char*
gets(char *buf, int max)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	57                   	push   %edi
 1b6:	56                   	push   %esi
 1b7:	53                   	push   %ebx
 1b8:	83 ec 1c             	sub    $0x1c,%esp
 1bb:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1be:	bb 00 00 00 00       	mov    $0x0,%ebx
 1c3:	8d 73 01             	lea    0x1(%ebx),%esi
 1c6:	3b 75 0c             	cmp    0xc(%ebp),%esi
 1c9:	7d 2e                	jge    1f9 <gets+0x47>
    cc = read(0, &c, 1);
 1cb:	83 ec 04             	sub    $0x4,%esp
 1ce:	6a 01                	push   $0x1
 1d0:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1d3:	50                   	push   %eax
 1d4:	6a 00                	push   $0x0
 1d6:	e8 b9 01 00 00       	call   394 <read>
    if(cc < 1)
 1db:	83 c4 10             	add    $0x10,%esp
 1de:	85 c0                	test   %eax,%eax
 1e0:	7e 17                	jle    1f9 <gets+0x47>
      break;
    buf[i++] = c;
 1e2:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1e6:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 1e9:	3c 0a                	cmp    $0xa,%al
 1eb:	0f 94 c2             	sete   %dl
 1ee:	3c 0d                	cmp    $0xd,%al
 1f0:	0f 94 c0             	sete   %al
    buf[i++] = c;
 1f3:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 1f5:	08 c2                	or     %al,%dl
 1f7:	74 ca                	je     1c3 <gets+0x11>
      break;
  }
  buf[i] = '\0';
 1f9:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 1fd:	89 f8                	mov    %edi,%eax
 1ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
 202:	5b                   	pop    %ebx
 203:	5e                   	pop    %esi
 204:	5f                   	pop    %edi
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    

00000207 <stat>:

int
stat(char *n, struct stat *st)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	56                   	push   %esi
 20b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20c:	83 ec 08             	sub    $0x8,%esp
 20f:	6a 00                	push   $0x0
 211:	ff 75 08             	pushl  0x8(%ebp)
 214:	e8 a3 01 00 00       	call   3bc <open>
  if(fd < 0)
 219:	83 c4 10             	add    $0x10,%esp
 21c:	85 c0                	test   %eax,%eax
 21e:	78 24                	js     244 <stat+0x3d>
 220:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 222:	83 ec 08             	sub    $0x8,%esp
 225:	ff 75 0c             	pushl  0xc(%ebp)
 228:	50                   	push   %eax
 229:	e8 a6 01 00 00       	call   3d4 <fstat>
 22e:	89 c6                	mov    %eax,%esi
  close(fd);
 230:	89 1c 24             	mov    %ebx,(%esp)
 233:	e8 6c 01 00 00       	call   3a4 <close>
  return r;
 238:	83 c4 10             	add    $0x10,%esp
}
 23b:	89 f0                	mov    %esi,%eax
 23d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 240:	5b                   	pop    %ebx
 241:	5e                   	pop    %esi
 242:	5d                   	pop    %ebp
 243:	c3                   	ret    
    return -1;
 244:	be ff ff ff ff       	mov    $0xffffffff,%esi
 249:	eb f0                	jmp    23b <stat+0x34>

0000024b <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 24b:	55                   	push   %ebp
 24c:	89 e5                	mov    %esp,%ebp
 24e:	57                   	push   %edi
 24f:	56                   	push   %esi
 250:	53                   	push   %ebx
 251:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 254:	eb 03                	jmp    259 <atoi+0xe>
 256:	83 c2 01             	add    $0x1,%edx
 259:	0f b6 02             	movzbl (%edx),%eax
 25c:	3c 20                	cmp    $0x20,%al
 25e:	74 f6                	je     256 <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 260:	3c 2d                	cmp    $0x2d,%al
 262:	74 1d                	je     281 <atoi+0x36>
 264:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 269:	3c 2b                	cmp    $0x2b,%al
 26b:	0f 94 c1             	sete   %cl
 26e:	3c 2d                	cmp    $0x2d,%al
 270:	0f 94 c0             	sete   %al
 273:	08 c1                	or     %al,%cl
 275:	74 03                	je     27a <atoi+0x2f>
    s++;
 277:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 27a:	b8 00 00 00 00       	mov    $0x0,%eax
 27f:	eb 17                	jmp    298 <atoi+0x4d>
 281:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 286:	eb e1                	jmp    269 <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 288:	8d 34 80             	lea    (%eax,%eax,4),%esi
 28b:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 28e:	83 c2 01             	add    $0x1,%edx
 291:	0f be c9             	movsbl %cl,%ecx
 294:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 298:	0f b6 0a             	movzbl (%edx),%ecx
 29b:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 29e:	80 fb 09             	cmp    $0x9,%bl
 2a1:	76 e5                	jbe    288 <atoi+0x3d>
  return sign*n;
 2a3:	0f af c7             	imul   %edi,%eax
}
 2a6:	5b                   	pop    %ebx
 2a7:	5e                   	pop    %esi
 2a8:	5f                   	pop    %edi
 2a9:	5d                   	pop    %ebp
 2aa:	c3                   	ret    

000002ab <atoo>:

int
atoo(const char *s)
{
 2ab:	55                   	push   %ebp
 2ac:	89 e5                	mov    %esp,%ebp
 2ae:	57                   	push   %edi
 2af:	56                   	push   %esi
 2b0:	53                   	push   %ebx
 2b1:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2b4:	eb 03                	jmp    2b9 <atoo+0xe>
 2b6:	83 c2 01             	add    $0x1,%edx
 2b9:	0f b6 0a             	movzbl (%edx),%ecx
 2bc:	80 f9 20             	cmp    $0x20,%cl
 2bf:	74 f5                	je     2b6 <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 2c1:	80 f9 2d             	cmp    $0x2d,%cl
 2c4:	74 23                	je     2e9 <atoo+0x3e>
 2c6:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 2cb:	80 f9 2b             	cmp    $0x2b,%cl
 2ce:	0f 94 c0             	sete   %al
 2d1:	89 c6                	mov    %eax,%esi
 2d3:	80 f9 2d             	cmp    $0x2d,%cl
 2d6:	0f 94 c0             	sete   %al
 2d9:	89 f3                	mov    %esi,%ebx
 2db:	08 c3                	or     %al,%bl
 2dd:	74 03                	je     2e2 <atoo+0x37>
    s++;
 2df:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 2e2:	b8 00 00 00 00       	mov    $0x0,%eax
 2e7:	eb 11                	jmp    2fa <atoo+0x4f>
 2e9:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 2ee:	eb db                	jmp    2cb <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 2f0:	83 c2 01             	add    $0x1,%edx
 2f3:	0f be c9             	movsbl %cl,%ecx
 2f6:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 2fa:	0f b6 0a             	movzbl (%edx),%ecx
 2fd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 300:	80 fb 07             	cmp    $0x7,%bl
 303:	76 eb                	jbe    2f0 <atoo+0x45>
  return sign*n;
 305:	0f af c7             	imul   %edi,%eax
}
 308:	5b                   	pop    %ebx
 309:	5e                   	pop    %esi
 30a:	5f                   	pop    %edi
 30b:	5d                   	pop    %ebp
 30c:	c3                   	ret    

0000030d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 30d:	55                   	push   %ebp
 30e:	89 e5                	mov    %esp,%ebp
 310:	53                   	push   %ebx
 311:	8b 55 08             	mov    0x8(%ebp),%edx
 314:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 317:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 31a:	eb 09                	jmp    325 <strncmp+0x18>
      n--, p++, q++;
 31c:	83 e8 01             	sub    $0x1,%eax
 31f:	83 c2 01             	add    $0x1,%edx
 322:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 325:	85 c0                	test   %eax,%eax
 327:	74 0b                	je     334 <strncmp+0x27>
 329:	0f b6 1a             	movzbl (%edx),%ebx
 32c:	84 db                	test   %bl,%bl
 32e:	74 04                	je     334 <strncmp+0x27>
 330:	3a 19                	cmp    (%ecx),%bl
 332:	74 e8                	je     31c <strncmp+0xf>
    if(n == 0)
 334:	85 c0                	test   %eax,%eax
 336:	74 0b                	je     343 <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 338:	0f b6 02             	movzbl (%edx),%eax
 33b:	0f b6 11             	movzbl (%ecx),%edx
 33e:	29 d0                	sub    %edx,%eax
}
 340:	5b                   	pop    %ebx
 341:	5d                   	pop    %ebp
 342:	c3                   	ret    
      return 0;
 343:	b8 00 00 00 00       	mov    $0x0,%eax
 348:	eb f6                	jmp    340 <strncmp+0x33>

0000034a <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 34a:	55                   	push   %ebp
 34b:	89 e5                	mov    %esp,%ebp
 34d:	56                   	push   %esi
 34e:	53                   	push   %ebx
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 355:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 358:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 35a:	eb 0d                	jmp    369 <memmove+0x1f>
    *dst++ = *src++;
 35c:	0f b6 13             	movzbl (%ebx),%edx
 35f:	88 11                	mov    %dl,(%ecx)
 361:	8d 5b 01             	lea    0x1(%ebx),%ebx
 364:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 367:	89 f2                	mov    %esi,%edx
 369:	8d 72 ff             	lea    -0x1(%edx),%esi
 36c:	85 d2                	test   %edx,%edx
 36e:	7f ec                	jg     35c <memmove+0x12>
  return vdst;
}
 370:	5b                   	pop    %ebx
 371:	5e                   	pop    %esi
 372:	5d                   	pop    %ebp
 373:	c3                   	ret    

00000374 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 374:	b8 01 00 00 00       	mov    $0x1,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exit>:
SYSCALL(exit)
 37c:	b8 02 00 00 00       	mov    $0x2,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <wait>:
SYSCALL(wait)
 384:	b8 03 00 00 00       	mov    $0x3,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <pipe>:
SYSCALL(pipe)
 38c:	b8 04 00 00 00       	mov    $0x4,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <read>:
SYSCALL(read)
 394:	b8 05 00 00 00       	mov    $0x5,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <write>:
SYSCALL(write)
 39c:	b8 10 00 00 00       	mov    $0x10,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <close>:
SYSCALL(close)
 3a4:	b8 15 00 00 00       	mov    $0x15,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <kill>:
SYSCALL(kill)
 3ac:	b8 06 00 00 00       	mov    $0x6,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <exec>:
SYSCALL(exec)
 3b4:	b8 07 00 00 00       	mov    $0x7,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <open>:
SYSCALL(open)
 3bc:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <mknod>:
SYSCALL(mknod)
 3c4:	b8 11 00 00 00       	mov    $0x11,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <unlink>:
SYSCALL(unlink)
 3cc:	b8 12 00 00 00       	mov    $0x12,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <fstat>:
SYSCALL(fstat)
 3d4:	b8 08 00 00 00       	mov    $0x8,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <link>:
SYSCALL(link)
 3dc:	b8 13 00 00 00       	mov    $0x13,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <mkdir>:
SYSCALL(mkdir)
 3e4:	b8 14 00 00 00       	mov    $0x14,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <chdir>:
SYSCALL(chdir)
 3ec:	b8 09 00 00 00       	mov    $0x9,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <dup>:
SYSCALL(dup)
 3f4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <getpid>:
SYSCALL(getpid)
 3fc:	b8 0b 00 00 00       	mov    $0xb,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <sbrk>:
SYSCALL(sbrk)
 404:	b8 0c 00 00 00       	mov    $0xc,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <sleep>:
SYSCALL(sleep)
 40c:	b8 0d 00 00 00       	mov    $0xd,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <uptime>:
SYSCALL(uptime)
 414:	b8 0e 00 00 00       	mov    $0xe,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <halt>:
SYSCALL(halt)
 41c:	b8 16 00 00 00       	mov    $0x16,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <date>:
SYSCALL(date)
 424:	b8 17 00 00 00       	mov    $0x17,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	83 ec 1c             	sub    $0x1c,%esp
 432:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 435:	6a 01                	push   $0x1
 437:	8d 55 f4             	lea    -0xc(%ebp),%edx
 43a:	52                   	push   %edx
 43b:	50                   	push   %eax
 43c:	e8 5b ff ff ff       	call   39c <write>
}
 441:	83 c4 10             	add    $0x10,%esp
 444:	c9                   	leave  
 445:	c3                   	ret    

00000446 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 446:	55                   	push   %ebp
 447:	89 e5                	mov    %esp,%ebp
 449:	57                   	push   %edi
 44a:	56                   	push   %esi
 44b:	53                   	push   %ebx
 44c:	83 ec 2c             	sub    $0x2c,%esp
 44f:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 451:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 455:	0f 95 c3             	setne  %bl
 458:	89 d0                	mov    %edx,%eax
 45a:	c1 e8 1f             	shr    $0x1f,%eax
 45d:	84 c3                	test   %al,%bl
 45f:	74 10                	je     471 <printint+0x2b>
    neg = 1;
    x = -xx;
 461:	f7 da                	neg    %edx
    neg = 1;
 463:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 46a:	be 00 00 00 00       	mov    $0x0,%esi
 46f:	eb 0b                	jmp    47c <printint+0x36>
  neg = 0;
 471:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 478:	eb f0                	jmp    46a <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 47a:	89 c6                	mov    %eax,%esi
 47c:	89 d0                	mov    %edx,%eax
 47e:	ba 00 00 00 00       	mov    $0x0,%edx
 483:	f7 f1                	div    %ecx
 485:	89 c3                	mov    %eax,%ebx
 487:	8d 46 01             	lea    0x1(%esi),%eax
 48a:	0f b6 92 ac 07 00 00 	movzbl 0x7ac(%edx),%edx
 491:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 495:	89 da                	mov    %ebx,%edx
 497:	85 db                	test   %ebx,%ebx
 499:	75 df                	jne    47a <printint+0x34>
 49b:	89 c3                	mov    %eax,%ebx
  if(neg)
 49d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 4a1:	74 16                	je     4b9 <printint+0x73>
    buf[i++] = '-';
 4a3:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 4a8:	8d 5e 02             	lea    0x2(%esi),%ebx
 4ab:	eb 0c                	jmp    4b9 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 4ad:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 4b2:	89 f8                	mov    %edi,%eax
 4b4:	e8 73 ff ff ff       	call   42c <putc>
  while(--i >= 0)
 4b9:	83 eb 01             	sub    $0x1,%ebx
 4bc:	79 ef                	jns    4ad <printint+0x67>
}
 4be:	83 c4 2c             	add    $0x2c,%esp
 4c1:	5b                   	pop    %ebx
 4c2:	5e                   	pop    %esi
 4c3:	5f                   	pop    %edi
 4c4:	5d                   	pop    %ebp
 4c5:	c3                   	ret    

000004c6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4c6:	55                   	push   %ebp
 4c7:	89 e5                	mov    %esp,%ebp
 4c9:	57                   	push   %edi
 4ca:	56                   	push   %esi
 4cb:	53                   	push   %ebx
 4cc:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4cf:	8d 45 10             	lea    0x10(%ebp),%eax
 4d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4d5:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4da:	bb 00 00 00 00       	mov    $0x0,%ebx
 4df:	eb 14                	jmp    4f5 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4e1:	89 fa                	mov    %edi,%edx
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	e8 41 ff ff ff       	call   42c <putc>
 4eb:	eb 05                	jmp    4f2 <printf+0x2c>
      }
    } else if(state == '%'){
 4ed:	83 fe 25             	cmp    $0x25,%esi
 4f0:	74 25                	je     517 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 4f2:	83 c3 01             	add    $0x1,%ebx
 4f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f8:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4fc:	84 c0                	test   %al,%al
 4fe:	0f 84 23 01 00 00    	je     627 <printf+0x161>
    c = fmt[i] & 0xff;
 504:	0f be f8             	movsbl %al,%edi
 507:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 50a:	85 f6                	test   %esi,%esi
 50c:	75 df                	jne    4ed <printf+0x27>
      if(c == '%'){
 50e:	83 f8 25             	cmp    $0x25,%eax
 511:	75 ce                	jne    4e1 <printf+0x1b>
        state = '%';
 513:	89 c6                	mov    %eax,%esi
 515:	eb db                	jmp    4f2 <printf+0x2c>
      if(c == 'd'){
 517:	83 f8 64             	cmp    $0x64,%eax
 51a:	74 49                	je     565 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 51c:	83 f8 78             	cmp    $0x78,%eax
 51f:	0f 94 c1             	sete   %cl
 522:	83 f8 70             	cmp    $0x70,%eax
 525:	0f 94 c2             	sete   %dl
 528:	08 d1                	or     %dl,%cl
 52a:	75 63                	jne    58f <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 52c:	83 f8 73             	cmp    $0x73,%eax
 52f:	0f 84 84 00 00 00    	je     5b9 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 535:	83 f8 63             	cmp    $0x63,%eax
 538:	0f 84 b7 00 00 00    	je     5f5 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 53e:	83 f8 25             	cmp    $0x25,%eax
 541:	0f 84 cc 00 00 00    	je     613 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 547:	ba 25 00 00 00       	mov    $0x25,%edx
 54c:	8b 45 08             	mov    0x8(%ebp),%eax
 54f:	e8 d8 fe ff ff       	call   42c <putc>
        putc(fd, c);
 554:	89 fa                	mov    %edi,%edx
 556:	8b 45 08             	mov    0x8(%ebp),%eax
 559:	e8 ce fe ff ff       	call   42c <putc>
      }
      state = 0;
 55e:	be 00 00 00 00       	mov    $0x0,%esi
 563:	eb 8d                	jmp    4f2 <printf+0x2c>
        printint(fd, *ap, 10, 1);
 565:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 568:	8b 17                	mov    (%edi),%edx
 56a:	83 ec 0c             	sub    $0xc,%esp
 56d:	6a 01                	push   $0x1
 56f:	b9 0a 00 00 00       	mov    $0xa,%ecx
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	e8 ca fe ff ff       	call   446 <printint>
        ap++;
 57c:	83 c7 04             	add    $0x4,%edi
 57f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 582:	83 c4 10             	add    $0x10,%esp
      state = 0;
 585:	be 00 00 00 00       	mov    $0x0,%esi
 58a:	e9 63 ff ff ff       	jmp    4f2 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 58f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 592:	8b 17                	mov    (%edi),%edx
 594:	83 ec 0c             	sub    $0xc,%esp
 597:	6a 00                	push   $0x0
 599:	b9 10 00 00 00       	mov    $0x10,%ecx
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	e8 a0 fe ff ff       	call   446 <printint>
        ap++;
 5a6:	83 c7 04             	add    $0x4,%edi
 5a9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5ac:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5af:	be 00 00 00 00       	mov    $0x0,%esi
 5b4:	e9 39 ff ff ff       	jmp    4f2 <printf+0x2c>
        s = (char*)*ap;
 5b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bc:	8b 30                	mov    (%eax),%esi
        ap++;
 5be:	83 c0 04             	add    $0x4,%eax
 5c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5c4:	85 f6                	test   %esi,%esi
 5c6:	75 28                	jne    5f0 <printf+0x12a>
          s = "(null)";
 5c8:	be a3 07 00 00       	mov    $0x7a3,%esi
 5cd:	8b 7d 08             	mov    0x8(%ebp),%edi
 5d0:	eb 0d                	jmp    5df <printf+0x119>
          putc(fd, *s);
 5d2:	0f be d2             	movsbl %dl,%edx
 5d5:	89 f8                	mov    %edi,%eax
 5d7:	e8 50 fe ff ff       	call   42c <putc>
          s++;
 5dc:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5df:	0f b6 16             	movzbl (%esi),%edx
 5e2:	84 d2                	test   %dl,%dl
 5e4:	75 ec                	jne    5d2 <printf+0x10c>
      state = 0;
 5e6:	be 00 00 00 00       	mov    $0x0,%esi
 5eb:	e9 02 ff ff ff       	jmp    4f2 <printf+0x2c>
 5f0:	8b 7d 08             	mov    0x8(%ebp),%edi
 5f3:	eb ea                	jmp    5df <printf+0x119>
        putc(fd, *ap);
 5f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5f8:	0f be 17             	movsbl (%edi),%edx
 5fb:	8b 45 08             	mov    0x8(%ebp),%eax
 5fe:	e8 29 fe ff ff       	call   42c <putc>
        ap++;
 603:	83 c7 04             	add    $0x4,%edi
 606:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 609:	be 00 00 00 00       	mov    $0x0,%esi
 60e:	e9 df fe ff ff       	jmp    4f2 <printf+0x2c>
        putc(fd, c);
 613:	89 fa                	mov    %edi,%edx
 615:	8b 45 08             	mov    0x8(%ebp),%eax
 618:	e8 0f fe ff ff       	call   42c <putc>
      state = 0;
 61d:	be 00 00 00 00       	mov    $0x0,%esi
 622:	e9 cb fe ff ff       	jmp    4f2 <printf+0x2c>
    }
  }
}
 627:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62a:	5b                   	pop    %ebx
 62b:	5e                   	pop    %esi
 62c:	5f                   	pop    %edi
 62d:	5d                   	pop    %ebp
 62e:	c3                   	ret    

0000062f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62f:	55                   	push   %ebp
 630:	89 e5                	mov    %esp,%ebp
 632:	57                   	push   %edi
 633:	56                   	push   %esi
 634:	53                   	push   %ebx
 635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 638:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63b:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 640:	eb 02                	jmp    644 <free+0x15>
 642:	89 d0                	mov    %edx,%eax
 644:	39 c8                	cmp    %ecx,%eax
 646:	73 04                	jae    64c <free+0x1d>
 648:	39 08                	cmp    %ecx,(%eax)
 64a:	77 12                	ja     65e <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64c:	8b 10                	mov    (%eax),%edx
 64e:	39 c2                	cmp    %eax,%edx
 650:	77 f0                	ja     642 <free+0x13>
 652:	39 c8                	cmp    %ecx,%eax
 654:	72 08                	jb     65e <free+0x2f>
 656:	39 ca                	cmp    %ecx,%edx
 658:	77 04                	ja     65e <free+0x2f>
 65a:	89 d0                	mov    %edx,%eax
 65c:	eb e6                	jmp    644 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 65e:	8b 73 fc             	mov    -0x4(%ebx),%esi
 661:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 664:	8b 10                	mov    (%eax),%edx
 666:	39 d7                	cmp    %edx,%edi
 668:	74 19                	je     683 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 66a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 66d:	8b 50 04             	mov    0x4(%eax),%edx
 670:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 673:	39 ce                	cmp    %ecx,%esi
 675:	74 1b                	je     692 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 677:	89 08                	mov    %ecx,(%eax)
  freep = p;
 679:	a3 a8 0a 00 00       	mov    %eax,0xaa8
}
 67e:	5b                   	pop    %ebx
 67f:	5e                   	pop    %esi
 680:	5f                   	pop    %edi
 681:	5d                   	pop    %ebp
 682:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 683:	03 72 04             	add    0x4(%edx),%esi
 686:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 12                	mov    (%edx),%edx
 68d:	89 53 f8             	mov    %edx,-0x8(%ebx)
 690:	eb db                	jmp    66d <free+0x3e>
    p->s.size += bp->s.size;
 692:	03 53 fc             	add    -0x4(%ebx),%edx
 695:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 698:	8b 53 f8             	mov    -0x8(%ebx),%edx
 69b:	89 10                	mov    %edx,(%eax)
 69d:	eb da                	jmp    679 <free+0x4a>

0000069f <morecore>:

static Header*
morecore(uint nu)
{
 69f:	55                   	push   %ebp
 6a0:	89 e5                	mov    %esp,%ebp
 6a2:	53                   	push   %ebx
 6a3:	83 ec 04             	sub    $0x4,%esp
 6a6:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 6a8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 6ad:	77 05                	ja     6b4 <morecore+0x15>
    nu = 4096;
 6af:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 6b4:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6bb:	83 ec 0c             	sub    $0xc,%esp
 6be:	50                   	push   %eax
 6bf:	e8 40 fd ff ff       	call   404 <sbrk>
  if(p == (char*)-1)
 6c4:	83 c4 10             	add    $0x10,%esp
 6c7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6ca:	74 1c                	je     6e8 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6cc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6cf:	83 c0 08             	add    $0x8,%eax
 6d2:	83 ec 0c             	sub    $0xc,%esp
 6d5:	50                   	push   %eax
 6d6:	e8 54 ff ff ff       	call   62f <free>
  return freep;
 6db:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 6e0:	83 c4 10             	add    $0x10,%esp
}
 6e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6e6:	c9                   	leave  
 6e7:	c3                   	ret    
    return 0;
 6e8:	b8 00 00 00 00       	mov    $0x0,%eax
 6ed:	eb f4                	jmp    6e3 <morecore+0x44>

000006ef <malloc>:

void*
malloc(uint nbytes)
{
 6ef:	55                   	push   %ebp
 6f0:	89 e5                	mov    %esp,%ebp
 6f2:	53                   	push   %ebx
 6f3:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f6:	8b 45 08             	mov    0x8(%ebp),%eax
 6f9:	8d 58 07             	lea    0x7(%eax),%ebx
 6fc:	c1 eb 03             	shr    $0x3,%ebx
 6ff:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 702:	8b 0d a8 0a 00 00    	mov    0xaa8,%ecx
 708:	85 c9                	test   %ecx,%ecx
 70a:	74 04                	je     710 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 70c:	8b 01                	mov    (%ecx),%eax
 70e:	eb 4d                	jmp    75d <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 710:	c7 05 a8 0a 00 00 ac 	movl   $0xaac,0xaa8
 717:	0a 00 00 
 71a:	c7 05 ac 0a 00 00 ac 	movl   $0xaac,0xaac
 721:	0a 00 00 
    base.s.size = 0;
 724:	c7 05 b0 0a 00 00 00 	movl   $0x0,0xab0
 72b:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 72e:	b9 ac 0a 00 00       	mov    $0xaac,%ecx
 733:	eb d7                	jmp    70c <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 735:	39 da                	cmp    %ebx,%edx
 737:	74 1a                	je     753 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 739:	29 da                	sub    %ebx,%edx
 73b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 73e:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 741:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 744:	89 0d a8 0a 00 00    	mov    %ecx,0xaa8
      return (void*)(p + 1);
 74a:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 74d:	83 c4 04             	add    $0x4,%esp
 750:	5b                   	pop    %ebx
 751:	5d                   	pop    %ebp
 752:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 753:	8b 10                	mov    (%eax),%edx
 755:	89 11                	mov    %edx,(%ecx)
 757:	eb eb                	jmp    744 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 759:	89 c1                	mov    %eax,%ecx
 75b:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 75d:	8b 50 04             	mov    0x4(%eax),%edx
 760:	39 da                	cmp    %ebx,%edx
 762:	73 d1                	jae    735 <malloc+0x46>
    if(p == freep)
 764:	39 05 a8 0a 00 00    	cmp    %eax,0xaa8
 76a:	75 ed                	jne    759 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 76c:	89 d8                	mov    %ebx,%eax
 76e:	e8 2c ff ff ff       	call   69f <morecore>
 773:	85 c0                	test   %eax,%eax
 775:	75 e2                	jne    759 <malloc+0x6a>
        return 0;
 777:	b8 00 00 00 00       	mov    $0x0,%eax
 77c:	eb cf                	jmp    74d <malloc+0x5e>
