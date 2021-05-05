
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	8b 75 08             	mov    0x8(%ebp),%esi
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
   f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  12:	83 ec 08             	sub    $0x8,%esp
  15:	53                   	push   %ebx
  16:	57                   	push   %edi
  17:	e8 2c 00 00 00       	call   48 <matchhere>
  1c:	83 c4 10             	add    $0x10,%esp
  1f:	85 c0                	test   %eax,%eax
  21:	75 18                	jne    3b <matchstar+0x3b>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  23:	0f b6 13             	movzbl (%ebx),%edx
  26:	84 d2                	test   %dl,%dl
  28:	74 16                	je     40 <matchstar+0x40>
  2a:	83 c3 01             	add    $0x1,%ebx
  2d:	0f be d2             	movsbl %dl,%edx
  30:	39 f2                	cmp    %esi,%edx
  32:	74 de                	je     12 <matchstar+0x12>
  34:	83 fe 2e             	cmp    $0x2e,%esi
  37:	74 d9                	je     12 <matchstar+0x12>
  39:	eb 05                	jmp    40 <matchstar+0x40>
      return 1;
  3b:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
  40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  43:	5b                   	pop    %ebx
  44:	5e                   	pop    %esi
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <matchhere>:
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	83 ec 08             	sub    $0x8,%esp
  4e:	8b 55 08             	mov    0x8(%ebp),%edx
  if(re[0] == '\0')
  51:	0f b6 02             	movzbl (%edx),%eax
  54:	84 c0                	test   %al,%al
  56:	74 68                	je     c0 <matchhere+0x78>
  if(re[1] == '*')
  58:	0f b6 4a 01          	movzbl 0x1(%edx),%ecx
  5c:	80 f9 2a             	cmp    $0x2a,%cl
  5f:	74 1d                	je     7e <matchhere+0x36>
  if(re[0] == '$' && re[1] == '\0')
  61:	3c 24                	cmp    $0x24,%al
  63:	74 31                	je     96 <matchhere+0x4e>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  68:	0f b6 09             	movzbl (%ecx),%ecx
  6b:	84 c9                	test   %cl,%cl
  6d:	74 58                	je     c7 <matchhere+0x7f>
  6f:	3c 2e                	cmp    $0x2e,%al
  71:	74 35                	je     a8 <matchhere+0x60>
  73:	38 c8                	cmp    %cl,%al
  75:	74 31                	je     a8 <matchhere+0x60>
  return 0;
  77:	b8 00 00 00 00       	mov    $0x0,%eax
  7c:	eb 47                	jmp    c5 <matchhere+0x7d>
    return matchstar(re[0], re+2, text);
  7e:	83 ec 04             	sub    $0x4,%esp
  81:	ff 75 0c             	pushl  0xc(%ebp)
  84:	83 c2 02             	add    $0x2,%edx
  87:	52                   	push   %edx
  88:	0f be c0             	movsbl %al,%eax
  8b:	50                   	push   %eax
  8c:	e8 6f ff ff ff       	call   0 <matchstar>
  91:	83 c4 10             	add    $0x10,%esp
  94:	eb 2f                	jmp    c5 <matchhere+0x7d>
  if(re[0] == '$' && re[1] == '\0')
  96:	84 c9                	test   %cl,%cl
  98:	75 cb                	jne    65 <matchhere+0x1d>
    return *text == '\0';
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	80 38 00             	cmpb   $0x0,(%eax)
  a0:	0f 94 c0             	sete   %al
  a3:	0f b6 c0             	movzbl %al,%eax
  a6:	eb 1d                	jmp    c5 <matchhere+0x7d>
    return matchhere(re+1, text+1);
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  ae:	83 c0 01             	add    $0x1,%eax
  b1:	50                   	push   %eax
  b2:	83 c2 01             	add    $0x1,%edx
  b5:	52                   	push   %edx
  b6:	e8 8d ff ff ff       	call   48 <matchhere>
  bb:	83 c4 10             	add    $0x10,%esp
  be:	eb 05                	jmp    c5 <matchhere+0x7d>
    return 1;
  c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  c5:	c9                   	leave  
  c6:	c3                   	ret    
  return 0;
  c7:	b8 00 00 00 00       	mov    $0x0,%eax
  cc:	eb f7                	jmp    c5 <matchhere+0x7d>

000000ce <match>:
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	56                   	push   %esi
  d2:	53                   	push   %ebx
  d3:	8b 75 08             	mov    0x8(%ebp),%esi
  d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
  d9:	80 3e 5e             	cmpb   $0x5e,(%esi)
  dc:	75 14                	jne    f2 <match+0x24>
    return matchhere(re+1, text);
  de:	83 ec 08             	sub    $0x8,%esp
  e1:	53                   	push   %ebx
  e2:	83 c6 01             	add    $0x1,%esi
  e5:	56                   	push   %esi
  e6:	e8 5d ff ff ff       	call   48 <matchhere>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	eb 22                	jmp    112 <match+0x44>
  }while(*text++ != '\0');
  f0:	89 d3                	mov    %edx,%ebx
    if(matchhere(re, text))
  f2:	83 ec 08             	sub    $0x8,%esp
  f5:	53                   	push   %ebx
  f6:	56                   	push   %esi
  f7:	e8 4c ff ff ff       	call   48 <matchhere>
  fc:	83 c4 10             	add    $0x10,%esp
  ff:	85 c0                	test   %eax,%eax
 101:	75 0a                	jne    10d <match+0x3f>
  }while(*text++ != '\0');
 103:	8d 53 01             	lea    0x1(%ebx),%edx
 106:	80 3b 00             	cmpb   $0x0,(%ebx)
 109:	75 e5                	jne    f0 <match+0x22>
 10b:	eb 05                	jmp    112 <match+0x44>
      return 1;
 10d:	b8 01 00 00 00       	mov    $0x1,%eax
}
 112:	8d 65 f8             	lea    -0x8(%ebp),%esp
 115:	5b                   	pop    %ebx
 116:	5e                   	pop    %esi
 117:	5d                   	pop    %ebp
 118:	c3                   	ret    

00000119 <grep>:
{
 119:	55                   	push   %ebp
 11a:	89 e5                	mov    %esp,%ebp
 11c:	57                   	push   %edi
 11d:	56                   	push   %esi
 11e:	53                   	push   %ebx
 11f:	83 ec 0c             	sub    $0xc,%esp
  m = 0;
 122:	bf 00 00 00 00       	mov    $0x0,%edi
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 127:	eb 52                	jmp    17b <grep+0x62>
      p = q+1;
 129:	8d 73 01             	lea    0x1(%ebx),%esi
    while((q = strchr(p, '\n')) != 0){
 12c:	83 ec 08             	sub    $0x8,%esp
 12f:	6a 0a                	push   $0xa
 131:	56                   	push   %esi
 132:	e8 c9 01 00 00       	call   300 <strchr>
 137:	89 c3                	mov    %eax,%ebx
 139:	83 c4 10             	add    $0x10,%esp
 13c:	85 c0                	test   %eax,%eax
 13e:	74 2f                	je     16f <grep+0x56>
      *q = 0;
 140:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 143:	83 ec 08             	sub    $0x8,%esp
 146:	56                   	push   %esi
 147:	ff 75 08             	pushl  0x8(%ebp)
 14a:	e8 7f ff ff ff       	call   ce <match>
 14f:	83 c4 10             	add    $0x10,%esp
 152:	85 c0                	test   %eax,%eax
 154:	74 d3                	je     129 <grep+0x10>
        *q = '\n';
 156:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 159:	8d 43 01             	lea    0x1(%ebx),%eax
 15c:	83 ec 04             	sub    $0x4,%esp
 15f:	29 f0                	sub    %esi,%eax
 161:	50                   	push   %eax
 162:	56                   	push   %esi
 163:	6a 01                	push   $0x1
 165:	e8 a1 03 00 00       	call   50b <write>
 16a:	83 c4 10             	add    $0x10,%esp
 16d:	eb ba                	jmp    129 <grep+0x10>
    if(p == buf)
 16f:	81 fe 00 0d 00 00    	cmp    $0xd00,%esi
 175:	74 52                	je     1c9 <grep+0xb0>
    if(m > 0){
 177:	85 ff                	test   %edi,%edi
 179:	7f 31                	jg     1ac <grep+0x93>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 17b:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 180:	29 f8                	sub    %edi,%eax
 182:	8d 97 00 0d 00 00    	lea    0xd00(%edi),%edx
 188:	83 ec 04             	sub    $0x4,%esp
 18b:	50                   	push   %eax
 18c:	52                   	push   %edx
 18d:	ff 75 0c             	pushl  0xc(%ebp)
 190:	e8 6e 03 00 00       	call   503 <read>
 195:	83 c4 10             	add    $0x10,%esp
 198:	85 c0                	test   %eax,%eax
 19a:	7e 34                	jle    1d0 <grep+0xb7>
    m += n;
 19c:	01 c7                	add    %eax,%edi
    buf[m] = '\0';
 19e:	c6 87 00 0d 00 00 00 	movb   $0x0,0xd00(%edi)
    p = buf;
 1a5:	be 00 0d 00 00       	mov    $0xd00,%esi
    while((q = strchr(p, '\n')) != 0){
 1aa:	eb 80                	jmp    12c <grep+0x13>
      m -= p - buf;
 1ac:	89 f0                	mov    %esi,%eax
 1ae:	2d 00 0d 00 00       	sub    $0xd00,%eax
 1b3:	29 c7                	sub    %eax,%edi
      memmove(buf, p, m);
 1b5:	83 ec 04             	sub    $0x4,%esp
 1b8:	57                   	push   %edi
 1b9:	56                   	push   %esi
 1ba:	68 00 0d 00 00       	push   $0xd00
 1bf:	e8 f5 02 00 00       	call   4b9 <memmove>
 1c4:	83 c4 10             	add    $0x10,%esp
 1c7:	eb b2                	jmp    17b <grep+0x62>
      m = 0;
 1c9:	bf 00 00 00 00       	mov    $0x0,%edi
 1ce:	eb ab                	jmp    17b <grep+0x62>
}
 1d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1d3:	5b                   	pop    %ebx
 1d4:	5e                   	pop    %esi
 1d5:	5f                   	pop    %edi
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    

000001d8 <main>:
{
 1d8:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1dc:	83 e4 f0             	and    $0xfffffff0,%esp
 1df:	ff 71 fc             	pushl  -0x4(%ecx)
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	57                   	push   %edi
 1e6:	56                   	push   %esi
 1e7:	53                   	push   %ebx
 1e8:	51                   	push   %ecx
 1e9:	83 ec 18             	sub    $0x18,%esp
 1ec:	8b 01                	mov    (%ecx),%eax
 1ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 1f1:	8b 51 04             	mov    0x4(%ecx),%edx
 1f4:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(argc <= 1){
 1f7:	83 f8 01             	cmp    $0x1,%eax
 1fa:	7e 50                	jle    24c <main+0x74>
  pattern = argv[1];
 1fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1ff:	8b 40 04             	mov    0x4(%eax),%eax
 202:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(argc <= 2){
 205:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
 209:	7e 55                	jle    260 <main+0x88>
  for(i = 2; i < argc; i++){
 20b:	bb 02 00 00 00       	mov    $0x2,%ebx
 210:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
 213:	7d 71                	jge    286 <main+0xae>
    if((fd = open(argv[i], 0)) < 0){
 215:	8b 45 e0             	mov    -0x20(%ebp),%eax
 218:	8d 3c 98             	lea    (%eax,%ebx,4),%edi
 21b:	83 ec 08             	sub    $0x8,%esp
 21e:	6a 00                	push   $0x0
 220:	ff 37                	pushl  (%edi)
 222:	e8 04 03 00 00       	call   52b <open>
 227:	89 c6                	mov    %eax,%esi
 229:	83 c4 10             	add    $0x10,%esp
 22c:	85 c0                	test   %eax,%eax
 22e:	78 40                	js     270 <main+0x98>
    grep(pattern, fd);
 230:	83 ec 08             	sub    $0x8,%esp
 233:	50                   	push   %eax
 234:	ff 75 dc             	pushl  -0x24(%ebp)
 237:	e8 dd fe ff ff       	call   119 <grep>
    close(fd);
 23c:	89 34 24             	mov    %esi,(%esp)
 23f:	e8 cf 02 00 00       	call   513 <close>
  for(i = 2; i < argc; i++){
 244:	83 c3 01             	add    $0x1,%ebx
 247:	83 c4 10             	add    $0x10,%esp
 24a:	eb c4                	jmp    210 <main+0x38>
    printf(2, "usage: grep pattern [file ...]\n");
 24c:	83 ec 08             	sub    $0x8,%esp
 24f:	68 f0 08 00 00       	push   $0x8f0
 254:	6a 02                	push   $0x2
 256:	e8 da 03 00 00       	call   635 <printf>
    exit();
 25b:	e8 8b 02 00 00       	call   4eb <exit>
    grep(pattern, 0);
 260:	83 ec 08             	sub    $0x8,%esp
 263:	6a 00                	push   $0x0
 265:	50                   	push   %eax
 266:	e8 ae fe ff ff       	call   119 <grep>
    exit();
 26b:	e8 7b 02 00 00       	call   4eb <exit>
      printf(1, "grep: cannot open %s\n", argv[i]);
 270:	83 ec 04             	sub    $0x4,%esp
 273:	ff 37                	pushl  (%edi)
 275:	68 10 09 00 00       	push   $0x910
 27a:	6a 01                	push   $0x1
 27c:	e8 b4 03 00 00       	call   635 <printf>
      exit();
 281:	e8 65 02 00 00       	call   4eb <exit>
  exit();
 286:	e8 60 02 00 00       	call   4eb <exit>

0000028b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 28b:	55                   	push   %ebp
 28c:	89 e5                	mov    %esp,%ebp
 28e:	53                   	push   %ebx
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 295:	89 c2                	mov    %eax,%edx
 297:	0f b6 19             	movzbl (%ecx),%ebx
 29a:	88 1a                	mov    %bl,(%edx)
 29c:	8d 52 01             	lea    0x1(%edx),%edx
 29f:	8d 49 01             	lea    0x1(%ecx),%ecx
 2a2:	84 db                	test   %bl,%bl
 2a4:	75 f1                	jne    297 <strcpy+0xc>
    ;
  return os;
}
 2a6:	5b                   	pop    %ebx
 2a7:	5d                   	pop    %ebp
 2a8:	c3                   	ret    

000002a9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a9:	55                   	push   %ebp
 2aa:	89 e5                	mov    %esp,%ebp
 2ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2af:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 2b2:	eb 06                	jmp    2ba <strcmp+0x11>
    p++, q++;
 2b4:	83 c1 01             	add    $0x1,%ecx
 2b7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2ba:	0f b6 01             	movzbl (%ecx),%eax
 2bd:	84 c0                	test   %al,%al
 2bf:	74 04                	je     2c5 <strcmp+0x1c>
 2c1:	3a 02                	cmp    (%edx),%al
 2c3:	74 ef                	je     2b4 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 2c5:	0f b6 c0             	movzbl %al,%eax
 2c8:	0f b6 12             	movzbl (%edx),%edx
 2cb:	29 d0                	sub    %edx,%eax
}
 2cd:	5d                   	pop    %ebp
 2ce:	c3                   	ret    

000002cf <strlen>:

uint
strlen(char *s)
{
 2cf:	55                   	push   %ebp
 2d0:	89 e5                	mov    %esp,%ebp
 2d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2d5:	ba 00 00 00 00       	mov    $0x0,%edx
 2da:	eb 03                	jmp    2df <strlen+0x10>
 2dc:	83 c2 01             	add    $0x1,%edx
 2df:	89 d0                	mov    %edx,%eax
 2e1:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2e5:	75 f5                	jne    2dc <strlen+0xd>
    ;
  return n;
}
 2e7:	5d                   	pop    %ebp
 2e8:	c3                   	ret    

000002e9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e9:	55                   	push   %ebp
 2ea:	89 e5                	mov    %esp,%ebp
 2ec:	57                   	push   %edi
 2ed:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2f0:	89 d7                	mov    %edx,%edi
 2f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f8:	fc                   	cld    
 2f9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2fb:	89 d0                	mov    %edx,%eax
 2fd:	5f                   	pop    %edi
 2fe:	5d                   	pop    %ebp
 2ff:	c3                   	ret    

00000300 <strchr>:

char*
strchr(const char *s, char c)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 30a:	0f b6 10             	movzbl (%eax),%edx
 30d:	84 d2                	test   %dl,%dl
 30f:	74 09                	je     31a <strchr+0x1a>
    if(*s == c)
 311:	38 ca                	cmp    %cl,%dl
 313:	74 0a                	je     31f <strchr+0x1f>
  for(; *s; s++)
 315:	83 c0 01             	add    $0x1,%eax
 318:	eb f0                	jmp    30a <strchr+0xa>
      return (char*)s;
  return 0;
 31a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 31f:	5d                   	pop    %ebp
 320:	c3                   	ret    

00000321 <gets>:

char*
gets(char *buf, int max)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	57                   	push   %edi
 325:	56                   	push   %esi
 326:	53                   	push   %ebx
 327:	83 ec 1c             	sub    $0x1c,%esp
 32a:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32d:	bb 00 00 00 00       	mov    $0x0,%ebx
 332:	8d 73 01             	lea    0x1(%ebx),%esi
 335:	3b 75 0c             	cmp    0xc(%ebp),%esi
 338:	7d 2e                	jge    368 <gets+0x47>
    cc = read(0, &c, 1);
 33a:	83 ec 04             	sub    $0x4,%esp
 33d:	6a 01                	push   $0x1
 33f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 342:	50                   	push   %eax
 343:	6a 00                	push   $0x0
 345:	e8 b9 01 00 00       	call   503 <read>
    if(cc < 1)
 34a:	83 c4 10             	add    $0x10,%esp
 34d:	85 c0                	test   %eax,%eax
 34f:	7e 17                	jle    368 <gets+0x47>
      break;
    buf[i++] = c;
 351:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 355:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 358:	3c 0a                	cmp    $0xa,%al
 35a:	0f 94 c2             	sete   %dl
 35d:	3c 0d                	cmp    $0xd,%al
 35f:	0f 94 c0             	sete   %al
    buf[i++] = c;
 362:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 364:	08 c2                	or     %al,%dl
 366:	74 ca                	je     332 <gets+0x11>
      break;
  }
  buf[i] = '\0';
 368:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 36c:	89 f8                	mov    %edi,%eax
 36e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 371:	5b                   	pop    %ebx
 372:	5e                   	pop    %esi
 373:	5f                   	pop    %edi
 374:	5d                   	pop    %ebp
 375:	c3                   	ret    

00000376 <stat>:

int
stat(char *n, struct stat *st)
{
 376:	55                   	push   %ebp
 377:	89 e5                	mov    %esp,%ebp
 379:	56                   	push   %esi
 37a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 37b:	83 ec 08             	sub    $0x8,%esp
 37e:	6a 00                	push   $0x0
 380:	ff 75 08             	pushl  0x8(%ebp)
 383:	e8 a3 01 00 00       	call   52b <open>
  if(fd < 0)
 388:	83 c4 10             	add    $0x10,%esp
 38b:	85 c0                	test   %eax,%eax
 38d:	78 24                	js     3b3 <stat+0x3d>
 38f:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 391:	83 ec 08             	sub    $0x8,%esp
 394:	ff 75 0c             	pushl  0xc(%ebp)
 397:	50                   	push   %eax
 398:	e8 a6 01 00 00       	call   543 <fstat>
 39d:	89 c6                	mov    %eax,%esi
  close(fd);
 39f:	89 1c 24             	mov    %ebx,(%esp)
 3a2:	e8 6c 01 00 00       	call   513 <close>
  return r;
 3a7:	83 c4 10             	add    $0x10,%esp
}
 3aa:	89 f0                	mov    %esi,%eax
 3ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3af:	5b                   	pop    %ebx
 3b0:	5e                   	pop    %esi
 3b1:	5d                   	pop    %ebp
 3b2:	c3                   	ret    
    return -1;
 3b3:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3b8:	eb f0                	jmp    3aa <stat+0x34>

000003ba <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 3ba:	55                   	push   %ebp
 3bb:	89 e5                	mov    %esp,%ebp
 3bd:	57                   	push   %edi
 3be:	56                   	push   %esi
 3bf:	53                   	push   %ebx
 3c0:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 3c3:	eb 03                	jmp    3c8 <atoi+0xe>
 3c5:	83 c2 01             	add    $0x1,%edx
 3c8:	0f b6 02             	movzbl (%edx),%eax
 3cb:	3c 20                	cmp    $0x20,%al
 3cd:	74 f6                	je     3c5 <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 3cf:	3c 2d                	cmp    $0x2d,%al
 3d1:	74 1d                	je     3f0 <atoi+0x36>
 3d3:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 3d8:	3c 2b                	cmp    $0x2b,%al
 3da:	0f 94 c1             	sete   %cl
 3dd:	3c 2d                	cmp    $0x2d,%al
 3df:	0f 94 c0             	sete   %al
 3e2:	08 c1                	or     %al,%cl
 3e4:	74 03                	je     3e9 <atoi+0x2f>
    s++;
 3e6:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 3e9:	b8 00 00 00 00       	mov    $0x0,%eax
 3ee:	eb 17                	jmp    407 <atoi+0x4d>
 3f0:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 3f5:	eb e1                	jmp    3d8 <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 3f7:	8d 34 80             	lea    (%eax,%eax,4),%esi
 3fa:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 3fd:	83 c2 01             	add    $0x1,%edx
 400:	0f be c9             	movsbl %cl,%ecx
 403:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 407:	0f b6 0a             	movzbl (%edx),%ecx
 40a:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 40d:	80 fb 09             	cmp    $0x9,%bl
 410:	76 e5                	jbe    3f7 <atoi+0x3d>
  return sign*n;
 412:	0f af c7             	imul   %edi,%eax
}
 415:	5b                   	pop    %ebx
 416:	5e                   	pop    %esi
 417:	5f                   	pop    %edi
 418:	5d                   	pop    %ebp
 419:	c3                   	ret    

0000041a <atoo>:

int
atoo(const char *s)
{
 41a:	55                   	push   %ebp
 41b:	89 e5                	mov    %esp,%ebp
 41d:	57                   	push   %edi
 41e:	56                   	push   %esi
 41f:	53                   	push   %ebx
 420:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 423:	eb 03                	jmp    428 <atoo+0xe>
 425:	83 c2 01             	add    $0x1,%edx
 428:	0f b6 0a             	movzbl (%edx),%ecx
 42b:	80 f9 20             	cmp    $0x20,%cl
 42e:	74 f5                	je     425 <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 430:	80 f9 2d             	cmp    $0x2d,%cl
 433:	74 23                	je     458 <atoo+0x3e>
 435:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 43a:	80 f9 2b             	cmp    $0x2b,%cl
 43d:	0f 94 c0             	sete   %al
 440:	89 c6                	mov    %eax,%esi
 442:	80 f9 2d             	cmp    $0x2d,%cl
 445:	0f 94 c0             	sete   %al
 448:	89 f3                	mov    %esi,%ebx
 44a:	08 c3                	or     %al,%bl
 44c:	74 03                	je     451 <atoo+0x37>
    s++;
 44e:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 451:	b8 00 00 00 00       	mov    $0x0,%eax
 456:	eb 11                	jmp    469 <atoo+0x4f>
 458:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 45d:	eb db                	jmp    43a <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 45f:	83 c2 01             	add    $0x1,%edx
 462:	0f be c9             	movsbl %cl,%ecx
 465:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 469:	0f b6 0a             	movzbl (%edx),%ecx
 46c:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 46f:	80 fb 07             	cmp    $0x7,%bl
 472:	76 eb                	jbe    45f <atoo+0x45>
  return sign*n;
 474:	0f af c7             	imul   %edi,%eax
}
 477:	5b                   	pop    %ebx
 478:	5e                   	pop    %esi
 479:	5f                   	pop    %edi
 47a:	5d                   	pop    %ebp
 47b:	c3                   	ret    

0000047c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 47c:	55                   	push   %ebp
 47d:	89 e5                	mov    %esp,%ebp
 47f:	53                   	push   %ebx
 480:	8b 55 08             	mov    0x8(%ebp),%edx
 483:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 486:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 489:	eb 09                	jmp    494 <strncmp+0x18>
      n--, p++, q++;
 48b:	83 e8 01             	sub    $0x1,%eax
 48e:	83 c2 01             	add    $0x1,%edx
 491:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 494:	85 c0                	test   %eax,%eax
 496:	74 0b                	je     4a3 <strncmp+0x27>
 498:	0f b6 1a             	movzbl (%edx),%ebx
 49b:	84 db                	test   %bl,%bl
 49d:	74 04                	je     4a3 <strncmp+0x27>
 49f:	3a 19                	cmp    (%ecx),%bl
 4a1:	74 e8                	je     48b <strncmp+0xf>
    if(n == 0)
 4a3:	85 c0                	test   %eax,%eax
 4a5:	74 0b                	je     4b2 <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 4a7:	0f b6 02             	movzbl (%edx),%eax
 4aa:	0f b6 11             	movzbl (%ecx),%edx
 4ad:	29 d0                	sub    %edx,%eax
}
 4af:	5b                   	pop    %ebx
 4b0:	5d                   	pop    %ebp
 4b1:	c3                   	ret    
      return 0;
 4b2:	b8 00 00 00 00       	mov    $0x0,%eax
 4b7:	eb f6                	jmp    4af <strncmp+0x33>

000004b9 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 4b9:	55                   	push   %ebp
 4ba:	89 e5                	mov    %esp,%ebp
 4bc:	56                   	push   %esi
 4bd:	53                   	push   %ebx
 4be:	8b 45 08             	mov    0x8(%ebp),%eax
 4c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 4c4:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 4c7:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 4c9:	eb 0d                	jmp    4d8 <memmove+0x1f>
    *dst++ = *src++;
 4cb:	0f b6 13             	movzbl (%ebx),%edx
 4ce:	88 11                	mov    %dl,(%ecx)
 4d0:	8d 5b 01             	lea    0x1(%ebx),%ebx
 4d3:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 4d6:	89 f2                	mov    %esi,%edx
 4d8:	8d 72 ff             	lea    -0x1(%edx),%esi
 4db:	85 d2                	test   %edx,%edx
 4dd:	7f ec                	jg     4cb <memmove+0x12>
  return vdst;
}
 4df:	5b                   	pop    %ebx
 4e0:	5e                   	pop    %esi
 4e1:	5d                   	pop    %ebp
 4e2:	c3                   	ret    

000004e3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4e3:	b8 01 00 00 00       	mov    $0x1,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <exit>:
SYSCALL(exit)
 4eb:	b8 02 00 00 00       	mov    $0x2,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <wait>:
SYSCALL(wait)
 4f3:	b8 03 00 00 00       	mov    $0x3,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <pipe>:
SYSCALL(pipe)
 4fb:	b8 04 00 00 00       	mov    $0x4,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <read>:
SYSCALL(read)
 503:	b8 05 00 00 00       	mov    $0x5,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <write>:
SYSCALL(write)
 50b:	b8 10 00 00 00       	mov    $0x10,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <close>:
SYSCALL(close)
 513:	b8 15 00 00 00       	mov    $0x15,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <kill>:
SYSCALL(kill)
 51b:	b8 06 00 00 00       	mov    $0x6,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <exec>:
SYSCALL(exec)
 523:	b8 07 00 00 00       	mov    $0x7,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <open>:
SYSCALL(open)
 52b:	b8 0f 00 00 00       	mov    $0xf,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <mknod>:
SYSCALL(mknod)
 533:	b8 11 00 00 00       	mov    $0x11,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <unlink>:
SYSCALL(unlink)
 53b:	b8 12 00 00 00       	mov    $0x12,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <fstat>:
SYSCALL(fstat)
 543:	b8 08 00 00 00       	mov    $0x8,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <link>:
SYSCALL(link)
 54b:	b8 13 00 00 00       	mov    $0x13,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <mkdir>:
SYSCALL(mkdir)
 553:	b8 14 00 00 00       	mov    $0x14,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <chdir>:
SYSCALL(chdir)
 55b:	b8 09 00 00 00       	mov    $0x9,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <dup>:
SYSCALL(dup)
 563:	b8 0a 00 00 00       	mov    $0xa,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <getpid>:
SYSCALL(getpid)
 56b:	b8 0b 00 00 00       	mov    $0xb,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <sbrk>:
SYSCALL(sbrk)
 573:	b8 0c 00 00 00       	mov    $0xc,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <sleep>:
SYSCALL(sleep)
 57b:	b8 0d 00 00 00       	mov    $0xd,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <uptime>:
SYSCALL(uptime)
 583:	b8 0e 00 00 00       	mov    $0xe,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <halt>:
SYSCALL(halt)
 58b:	b8 16 00 00 00       	mov    $0x16,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <date>:
SYSCALL(date)
 593:	b8 17 00 00 00       	mov    $0x17,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 59b:	55                   	push   %ebp
 59c:	89 e5                	mov    %esp,%ebp
 59e:	83 ec 1c             	sub    $0x1c,%esp
 5a1:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 5a4:	6a 01                	push   $0x1
 5a6:	8d 55 f4             	lea    -0xc(%ebp),%edx
 5a9:	52                   	push   %edx
 5aa:	50                   	push   %eax
 5ab:	e8 5b ff ff ff       	call   50b <write>
}
 5b0:	83 c4 10             	add    $0x10,%esp
 5b3:	c9                   	leave  
 5b4:	c3                   	ret    

000005b5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5b5:	55                   	push   %ebp
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	57                   	push   %edi
 5b9:	56                   	push   %esi
 5ba:	53                   	push   %ebx
 5bb:	83 ec 2c             	sub    $0x2c,%esp
 5be:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 5c4:	0f 95 c3             	setne  %bl
 5c7:	89 d0                	mov    %edx,%eax
 5c9:	c1 e8 1f             	shr    $0x1f,%eax
 5cc:	84 c3                	test   %al,%bl
 5ce:	74 10                	je     5e0 <printint+0x2b>
    neg = 1;
    x = -xx;
 5d0:	f7 da                	neg    %edx
    neg = 1;
 5d2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 5d9:	be 00 00 00 00       	mov    $0x0,%esi
 5de:	eb 0b                	jmp    5eb <printint+0x36>
  neg = 0;
 5e0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 5e7:	eb f0                	jmp    5d9 <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 5e9:	89 c6                	mov    %eax,%esi
 5eb:	89 d0                	mov    %edx,%eax
 5ed:	ba 00 00 00 00       	mov    $0x0,%edx
 5f2:	f7 f1                	div    %ecx
 5f4:	89 c3                	mov    %eax,%ebx
 5f6:	8d 46 01             	lea    0x1(%esi),%eax
 5f9:	0f b6 92 30 09 00 00 	movzbl 0x930(%edx),%edx
 600:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 604:	89 da                	mov    %ebx,%edx
 606:	85 db                	test   %ebx,%ebx
 608:	75 df                	jne    5e9 <printint+0x34>
 60a:	89 c3                	mov    %eax,%ebx
  if(neg)
 60c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 610:	74 16                	je     628 <printint+0x73>
    buf[i++] = '-';
 612:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 617:	8d 5e 02             	lea    0x2(%esi),%ebx
 61a:	eb 0c                	jmp    628 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 61c:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 621:	89 f8                	mov    %edi,%eax
 623:	e8 73 ff ff ff       	call   59b <putc>
  while(--i >= 0)
 628:	83 eb 01             	sub    $0x1,%ebx
 62b:	79 ef                	jns    61c <printint+0x67>
}
 62d:	83 c4 2c             	add    $0x2c,%esp
 630:	5b                   	pop    %ebx
 631:	5e                   	pop    %esi
 632:	5f                   	pop    %edi
 633:	5d                   	pop    %ebp
 634:	c3                   	ret    

00000635 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 635:	55                   	push   %ebp
 636:	89 e5                	mov    %esp,%ebp
 638:	57                   	push   %edi
 639:	56                   	push   %esi
 63a:	53                   	push   %ebx
 63b:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 63e:	8d 45 10             	lea    0x10(%ebp),%eax
 641:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 644:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 649:	bb 00 00 00 00       	mov    $0x0,%ebx
 64e:	eb 14                	jmp    664 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 650:	89 fa                	mov    %edi,%edx
 652:	8b 45 08             	mov    0x8(%ebp),%eax
 655:	e8 41 ff ff ff       	call   59b <putc>
 65a:	eb 05                	jmp    661 <printf+0x2c>
      }
    } else if(state == '%'){
 65c:	83 fe 25             	cmp    $0x25,%esi
 65f:	74 25                	je     686 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 661:	83 c3 01             	add    $0x1,%ebx
 664:	8b 45 0c             	mov    0xc(%ebp),%eax
 667:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 66b:	84 c0                	test   %al,%al
 66d:	0f 84 23 01 00 00    	je     796 <printf+0x161>
    c = fmt[i] & 0xff;
 673:	0f be f8             	movsbl %al,%edi
 676:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 679:	85 f6                	test   %esi,%esi
 67b:	75 df                	jne    65c <printf+0x27>
      if(c == '%'){
 67d:	83 f8 25             	cmp    $0x25,%eax
 680:	75 ce                	jne    650 <printf+0x1b>
        state = '%';
 682:	89 c6                	mov    %eax,%esi
 684:	eb db                	jmp    661 <printf+0x2c>
      if(c == 'd'){
 686:	83 f8 64             	cmp    $0x64,%eax
 689:	74 49                	je     6d4 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 68b:	83 f8 78             	cmp    $0x78,%eax
 68e:	0f 94 c1             	sete   %cl
 691:	83 f8 70             	cmp    $0x70,%eax
 694:	0f 94 c2             	sete   %dl
 697:	08 d1                	or     %dl,%cl
 699:	75 63                	jne    6fe <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 69b:	83 f8 73             	cmp    $0x73,%eax
 69e:	0f 84 84 00 00 00    	je     728 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6a4:	83 f8 63             	cmp    $0x63,%eax
 6a7:	0f 84 b7 00 00 00    	je     764 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6ad:	83 f8 25             	cmp    $0x25,%eax
 6b0:	0f 84 cc 00 00 00    	je     782 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6b6:	ba 25 00 00 00       	mov    $0x25,%edx
 6bb:	8b 45 08             	mov    0x8(%ebp),%eax
 6be:	e8 d8 fe ff ff       	call   59b <putc>
        putc(fd, c);
 6c3:	89 fa                	mov    %edi,%edx
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	e8 ce fe ff ff       	call   59b <putc>
      }
      state = 0;
 6cd:	be 00 00 00 00       	mov    $0x0,%esi
 6d2:	eb 8d                	jmp    661 <printf+0x2c>
        printint(fd, *ap, 10, 1);
 6d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6d7:	8b 17                	mov    (%edi),%edx
 6d9:	83 ec 0c             	sub    $0xc,%esp
 6dc:	6a 01                	push   $0x1
 6de:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
 6e6:	e8 ca fe ff ff       	call   5b5 <printint>
        ap++;
 6eb:	83 c7 04             	add    $0x4,%edi
 6ee:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 6f1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6f4:	be 00 00 00 00       	mov    $0x0,%esi
 6f9:	e9 63 ff ff ff       	jmp    661 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 6fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 701:	8b 17                	mov    (%edi),%edx
 703:	83 ec 0c             	sub    $0xc,%esp
 706:	6a 00                	push   $0x0
 708:	b9 10 00 00 00       	mov    $0x10,%ecx
 70d:	8b 45 08             	mov    0x8(%ebp),%eax
 710:	e8 a0 fe ff ff       	call   5b5 <printint>
        ap++;
 715:	83 c7 04             	add    $0x4,%edi
 718:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 71b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 71e:	be 00 00 00 00       	mov    $0x0,%esi
 723:	e9 39 ff ff ff       	jmp    661 <printf+0x2c>
        s = (char*)*ap;
 728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72b:	8b 30                	mov    (%eax),%esi
        ap++;
 72d:	83 c0 04             	add    $0x4,%eax
 730:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 733:	85 f6                	test   %esi,%esi
 735:	75 28                	jne    75f <printf+0x12a>
          s = "(null)";
 737:	be 26 09 00 00       	mov    $0x926,%esi
 73c:	8b 7d 08             	mov    0x8(%ebp),%edi
 73f:	eb 0d                	jmp    74e <printf+0x119>
          putc(fd, *s);
 741:	0f be d2             	movsbl %dl,%edx
 744:	89 f8                	mov    %edi,%eax
 746:	e8 50 fe ff ff       	call   59b <putc>
          s++;
 74b:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 74e:	0f b6 16             	movzbl (%esi),%edx
 751:	84 d2                	test   %dl,%dl
 753:	75 ec                	jne    741 <printf+0x10c>
      state = 0;
 755:	be 00 00 00 00       	mov    $0x0,%esi
 75a:	e9 02 ff ff ff       	jmp    661 <printf+0x2c>
 75f:	8b 7d 08             	mov    0x8(%ebp),%edi
 762:	eb ea                	jmp    74e <printf+0x119>
        putc(fd, *ap);
 764:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 767:	0f be 17             	movsbl (%edi),%edx
 76a:	8b 45 08             	mov    0x8(%ebp),%eax
 76d:	e8 29 fe ff ff       	call   59b <putc>
        ap++;
 772:	83 c7 04             	add    $0x4,%edi
 775:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 778:	be 00 00 00 00       	mov    $0x0,%esi
 77d:	e9 df fe ff ff       	jmp    661 <printf+0x2c>
        putc(fd, c);
 782:	89 fa                	mov    %edi,%edx
 784:	8b 45 08             	mov    0x8(%ebp),%eax
 787:	e8 0f fe ff ff       	call   59b <putc>
      state = 0;
 78c:	be 00 00 00 00       	mov    $0x0,%esi
 791:	e9 cb fe ff ff       	jmp    661 <printf+0x2c>
    }
  }
}
 796:	8d 65 f4             	lea    -0xc(%ebp),%esp
 799:	5b                   	pop    %ebx
 79a:	5e                   	pop    %esi
 79b:	5f                   	pop    %edi
 79c:	5d                   	pop    %ebp
 79d:	c3                   	ret    

0000079e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79e:	55                   	push   %ebp
 79f:	89 e5                	mov    %esp,%ebp
 7a1:	57                   	push   %edi
 7a2:	56                   	push   %esi
 7a3:	53                   	push   %ebx
 7a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a7:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	a1 e0 0c 00 00       	mov    0xce0,%eax
 7af:	eb 02                	jmp    7b3 <free+0x15>
 7b1:	89 d0                	mov    %edx,%eax
 7b3:	39 c8                	cmp    %ecx,%eax
 7b5:	73 04                	jae    7bb <free+0x1d>
 7b7:	39 08                	cmp    %ecx,(%eax)
 7b9:	77 12                	ja     7cd <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7bb:	8b 10                	mov    (%eax),%edx
 7bd:	39 c2                	cmp    %eax,%edx
 7bf:	77 f0                	ja     7b1 <free+0x13>
 7c1:	39 c8                	cmp    %ecx,%eax
 7c3:	72 08                	jb     7cd <free+0x2f>
 7c5:	39 ca                	cmp    %ecx,%edx
 7c7:	77 04                	ja     7cd <free+0x2f>
 7c9:	89 d0                	mov    %edx,%eax
 7cb:	eb e6                	jmp    7b3 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7cd:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7d0:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7d3:	8b 10                	mov    (%eax),%edx
 7d5:	39 d7                	cmp    %edx,%edi
 7d7:	74 19                	je     7f2 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7d9:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7dc:	8b 50 04             	mov    0x4(%eax),%edx
 7df:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7e2:	39 ce                	cmp    %ecx,%esi
 7e4:	74 1b                	je     801 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7e6:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7e8:	a3 e0 0c 00 00       	mov    %eax,0xce0
}
 7ed:	5b                   	pop    %ebx
 7ee:	5e                   	pop    %esi
 7ef:	5f                   	pop    %edi
 7f0:	5d                   	pop    %ebp
 7f1:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 7f2:	03 72 04             	add    0x4(%edx),%esi
 7f5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f8:	8b 10                	mov    (%eax),%edx
 7fa:	8b 12                	mov    (%edx),%edx
 7fc:	89 53 f8             	mov    %edx,-0x8(%ebx)
 7ff:	eb db                	jmp    7dc <free+0x3e>
    p->s.size += bp->s.size;
 801:	03 53 fc             	add    -0x4(%ebx),%edx
 804:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 807:	8b 53 f8             	mov    -0x8(%ebx),%edx
 80a:	89 10                	mov    %edx,(%eax)
 80c:	eb da                	jmp    7e8 <free+0x4a>

0000080e <morecore>:

static Header*
morecore(uint nu)
{
 80e:	55                   	push   %ebp
 80f:	89 e5                	mov    %esp,%ebp
 811:	53                   	push   %ebx
 812:	83 ec 04             	sub    $0x4,%esp
 815:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 817:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 81c:	77 05                	ja     823 <morecore+0x15>
    nu = 4096;
 81e:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 823:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 82a:	83 ec 0c             	sub    $0xc,%esp
 82d:	50                   	push   %eax
 82e:	e8 40 fd ff ff       	call   573 <sbrk>
  if(p == (char*)-1)
 833:	83 c4 10             	add    $0x10,%esp
 836:	83 f8 ff             	cmp    $0xffffffff,%eax
 839:	74 1c                	je     857 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 83b:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 83e:	83 c0 08             	add    $0x8,%eax
 841:	83 ec 0c             	sub    $0xc,%esp
 844:	50                   	push   %eax
 845:	e8 54 ff ff ff       	call   79e <free>
  return freep;
 84a:	a1 e0 0c 00 00       	mov    0xce0,%eax
 84f:	83 c4 10             	add    $0x10,%esp
}
 852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 855:	c9                   	leave  
 856:	c3                   	ret    
    return 0;
 857:	b8 00 00 00 00       	mov    $0x0,%eax
 85c:	eb f4                	jmp    852 <morecore+0x44>

0000085e <malloc>:

void*
malloc(uint nbytes)
{
 85e:	55                   	push   %ebp
 85f:	89 e5                	mov    %esp,%ebp
 861:	53                   	push   %ebx
 862:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 865:	8b 45 08             	mov    0x8(%ebp),%eax
 868:	8d 58 07             	lea    0x7(%eax),%ebx
 86b:	c1 eb 03             	shr    $0x3,%ebx
 86e:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 871:	8b 0d e0 0c 00 00    	mov    0xce0,%ecx
 877:	85 c9                	test   %ecx,%ecx
 879:	74 04                	je     87f <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87b:	8b 01                	mov    (%ecx),%eax
 87d:	eb 4d                	jmp    8cc <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 87f:	c7 05 e0 0c 00 00 e4 	movl   $0xce4,0xce0
 886:	0c 00 00 
 889:	c7 05 e4 0c 00 00 e4 	movl   $0xce4,0xce4
 890:	0c 00 00 
    base.s.size = 0;
 893:	c7 05 e8 0c 00 00 00 	movl   $0x0,0xce8
 89a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 89d:	b9 e4 0c 00 00       	mov    $0xce4,%ecx
 8a2:	eb d7                	jmp    87b <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 8a4:	39 da                	cmp    %ebx,%edx
 8a6:	74 1a                	je     8c2 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 8a8:	29 da                	sub    %ebx,%edx
 8aa:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8ad:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 8b0:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 8b3:	89 0d e0 0c 00 00    	mov    %ecx,0xce0
      return (void*)(p + 1);
 8b9:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8bc:	83 c4 04             	add    $0x4,%esp
 8bf:	5b                   	pop    %ebx
 8c0:	5d                   	pop    %ebp
 8c1:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 8c2:	8b 10                	mov    (%eax),%edx
 8c4:	89 11                	mov    %edx,(%ecx)
 8c6:	eb eb                	jmp    8b3 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c8:	89 c1                	mov    %eax,%ecx
 8ca:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 8cc:	8b 50 04             	mov    0x4(%eax),%edx
 8cf:	39 da                	cmp    %ebx,%edx
 8d1:	73 d1                	jae    8a4 <malloc+0x46>
    if(p == freep)
 8d3:	39 05 e0 0c 00 00    	cmp    %eax,0xce0
 8d9:	75 ed                	jne    8c8 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 8db:	89 d8                	mov    %ebx,%eax
 8dd:	e8 2c ff ff ff       	call   80e <morecore>
 8e2:	85 c0                	test   %eax,%eax
 8e4:	75 e2                	jne    8c8 <malloc+0x6a>
        return 0;
 8e6:	b8 00 00 00 00       	mov    $0x0,%eax
 8eb:	eb cf                	jmp    8bc <malloc+0x5e>
