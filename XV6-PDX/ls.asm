
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "fs.h"


char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   8:	83 ec 0c             	sub    $0xc,%esp
   b:	53                   	push   %ebx
   c:	e8 1e 03 00 00       	call   32f <strlen>
  11:	01 d8                	add    %ebx,%eax
  13:	83 c4 10             	add    $0x10,%esp
  16:	eb 03                	jmp    1b <fmtname+0x1b>
  18:	83 e8 01             	sub    $0x1,%eax
  1b:	39 d8                	cmp    %ebx,%eax
  1d:	72 05                	jb     24 <fmtname+0x24>
  1f:	80 38 2f             	cmpb   $0x2f,(%eax)
  22:	75 f4                	jne    18 <fmtname+0x18>
    ;
  p++;
  24:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  27:	83 ec 0c             	sub    $0xc,%esp
  2a:	53                   	push   %ebx
  2b:	e8 ff 02 00 00       	call   32f <strlen>
  30:	83 c4 10             	add    $0x10,%esp
  33:	83 f8 0d             	cmp    $0xd,%eax
  36:	76 09                	jbe    41 <fmtname+0x41>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  38:	89 d8                	mov    %ebx,%eax
  3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  3d:	5b                   	pop    %ebx
  3e:	5e                   	pop    %esi
  3f:	5d                   	pop    %ebp
  40:	c3                   	ret    
  memmove(buf, p, strlen(p));
  41:	83 ec 0c             	sub    $0xc,%esp
  44:	53                   	push   %ebx
  45:	e8 e5 02 00 00       	call   32f <strlen>
  4a:	83 c4 0c             	add    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	53                   	push   %ebx
  4f:	68 00 0d 00 00       	push   $0xd00
  54:	e8 c0 04 00 00       	call   519 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  59:	89 1c 24             	mov    %ebx,(%esp)
  5c:	e8 ce 02 00 00       	call   32f <strlen>
  61:	89 c6                	mov    %eax,%esi
  63:	89 1c 24             	mov    %ebx,(%esp)
  66:	e8 c4 02 00 00       	call   32f <strlen>
  6b:	83 c4 0c             	add    $0xc,%esp
  6e:	ba 0e 00 00 00       	mov    $0xe,%edx
  73:	29 f2                	sub    %esi,%edx
  75:	52                   	push   %edx
  76:	6a 20                	push   $0x20
  78:	05 00 0d 00 00       	add    $0xd00,%eax
  7d:	50                   	push   %eax
  7e:	e8 c6 02 00 00       	call   349 <memset>
  return buf;
  83:	83 c4 10             	add    $0x10,%esp
  86:	bb 00 0d 00 00       	mov    $0xd00,%ebx
  8b:	eb ab                	jmp    38 <fmtname+0x38>

0000008d <ls>:

void
ls(char *path)
{
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	57                   	push   %edi
  91:	56                   	push   %esi
  92:	53                   	push   %ebx
  93:	81 ec 54 02 00 00    	sub    $0x254,%esp
  99:	8b 75 08             	mov    0x8(%ebp),%esi
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  9c:	6a 00                	push   $0x0
  9e:	56                   	push   %esi
  9f:	e8 e7 04 00 00       	call   58b <open>
  a4:	83 c4 10             	add    $0x10,%esp
  a7:	85 c0                	test   %eax,%eax
  a9:	0f 88 92 00 00 00    	js     141 <ls+0xb4>
  af:	89 c3                	mov    %eax,%ebx
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  b1:	83 ec 08             	sub    $0x8,%esp
  b4:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
  ba:	50                   	push   %eax
  bb:	53                   	push   %ebx
  bc:	e8 e2 04 00 00       	call   5a3 <fstat>
  c1:	83 c4 10             	add    $0x10,%esp
  c4:	85 c0                	test   %eax,%eax
  c6:	0f 88 8a 00 00 00    	js     156 <ls+0xc9>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  cc:	0f b7 85 c4 fd ff ff 	movzwl -0x23c(%ebp),%eax
  d3:	0f bf f8             	movswl %ax,%edi
  d6:	66 83 f8 01          	cmp    $0x1,%ax
  da:	0f 84 93 00 00 00    	je     173 <ls+0xe6>
  e0:	66 83 f8 01          	cmp    $0x1,%ax
  e4:	7c 47                	jl     12d <ls+0xa0>
  e6:	66 83 f8 03          	cmp    $0x3,%ax
  ea:	7f 41                	jg     12d <ls+0xa0>
  case T_FILE:
  case T_DEV:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
  ec:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
  f2:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
  f8:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
  fe:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 104:	83 ec 0c             	sub    $0xc,%esp
 107:	56                   	push   %esi
 108:	e8 f3 fe ff ff       	call   0 <fmtname>
 10d:	83 c4 08             	add    $0x8,%esp
 110:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 116:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 11c:	57                   	push   %edi
 11d:	50                   	push   %eax
 11e:	68 78 09 00 00       	push   $0x978
 123:	6a 01                	push   $0x1
 125:	e8 6b 05 00 00       	call   695 <printf>
    break;
 12a:	83 c4 20             	add    $0x20,%esp
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 12d:	83 ec 0c             	sub    $0xc,%esp
 130:	53                   	push   %ebx
 131:	e8 3d 04 00 00       	call   573 <close>
 136:	83 c4 10             	add    $0x10,%esp
}
 139:	8d 65 f4             	lea    -0xc(%ebp),%esp
 13c:	5b                   	pop    %ebx
 13d:	5e                   	pop    %esi
 13e:	5f                   	pop    %edi
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    
    printf(2, "ls: cannot open %s\n", path);
 141:	83 ec 04             	sub    $0x4,%esp
 144:	56                   	push   %esi
 145:	68 50 09 00 00       	push   $0x950
 14a:	6a 02                	push   $0x2
 14c:	e8 44 05 00 00       	call   695 <printf>
    return;
 151:	83 c4 10             	add    $0x10,%esp
 154:	eb e3                	jmp    139 <ls+0xac>
    printf(2, "ls: cannot stat %s\n", path);
 156:	83 ec 04             	sub    $0x4,%esp
 159:	56                   	push   %esi
 15a:	68 64 09 00 00       	push   $0x964
 15f:	6a 02                	push   $0x2
 161:	e8 2f 05 00 00       	call   695 <printf>
    close(fd);
 166:	89 1c 24             	mov    %ebx,(%esp)
 169:	e8 05 04 00 00       	call   573 <close>
    return;
 16e:	83 c4 10             	add    $0x10,%esp
 171:	eb c6                	jmp    139 <ls+0xac>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 173:	83 ec 0c             	sub    $0xc,%esp
 176:	56                   	push   %esi
 177:	e8 b3 01 00 00       	call   32f <strlen>
 17c:	83 c0 10             	add    $0x10,%eax
 17f:	83 c4 10             	add    $0x10,%esp
 182:	3d 00 02 00 00       	cmp    $0x200,%eax
 187:	76 14                	jbe    19d <ls+0x110>
      printf(1, "ls: path too long\n");
 189:	83 ec 08             	sub    $0x8,%esp
 18c:	68 85 09 00 00       	push   $0x985
 191:	6a 01                	push   $0x1
 193:	e8 fd 04 00 00       	call   695 <printf>
      break;
 198:	83 c4 10             	add    $0x10,%esp
 19b:	eb 90                	jmp    12d <ls+0xa0>
    strcpy(buf, path);
 19d:	83 ec 08             	sub    $0x8,%esp
 1a0:	56                   	push   %esi
 1a1:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
 1a7:	56                   	push   %esi
 1a8:	e8 3e 01 00 00       	call   2eb <strcpy>
    p = buf+strlen(buf);
 1ad:	89 34 24             	mov    %esi,(%esp)
 1b0:	e8 7a 01 00 00       	call   32f <strlen>
 1b5:	01 c6                	add    %eax,%esi
    *p++ = '/';
 1b7:	8d 46 01             	lea    0x1(%esi),%eax
 1ba:	89 85 ac fd ff ff    	mov    %eax,-0x254(%ebp)
 1c0:	c6 06 2f             	movb   $0x2f,(%esi)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c3:	83 c4 10             	add    $0x10,%esp
 1c6:	83 ec 04             	sub    $0x4,%esp
 1c9:	6a 10                	push   $0x10
 1cb:	8d 85 d8 fd ff ff    	lea    -0x228(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	53                   	push   %ebx
 1d3:	e8 8b 03 00 00       	call   563 <read>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	83 f8 10             	cmp    $0x10,%eax
 1de:	0f 85 49 ff ff ff    	jne    12d <ls+0xa0>
      if(de.inum == 0)
 1e4:	66 83 bd d8 fd ff ff 	cmpw   $0x0,-0x228(%ebp)
 1eb:	00 
 1ec:	74 d8                	je     1c6 <ls+0x139>
      memmove(p, de.name, DIRSIZ);
 1ee:	83 ec 04             	sub    $0x4,%esp
 1f1:	6a 0e                	push   $0xe
 1f3:	8d 85 da fd ff ff    	lea    -0x226(%ebp),%eax
 1f9:	50                   	push   %eax
 1fa:	ff b5 ac fd ff ff    	pushl  -0x254(%ebp)
 200:	e8 14 03 00 00       	call   519 <memmove>
      p[DIRSIZ] = 0;
 205:	c6 46 0f 00          	movb   $0x0,0xf(%esi)
      if(stat(buf, &st) < 0){
 209:	83 c4 08             	add    $0x8,%esp
 20c:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 212:	50                   	push   %eax
 213:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 219:	50                   	push   %eax
 21a:	e8 b7 01 00 00       	call   3d6 <stat>
 21f:	83 c4 10             	add    $0x10,%esp
 222:	85 c0                	test   %eax,%eax
 224:	78 56                	js     27c <ls+0x1ef>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 226:	8b bd d4 fd ff ff    	mov    -0x22c(%ebp),%edi
 22c:	8b 85 cc fd ff ff    	mov    -0x234(%ebp),%eax
 232:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 238:	0f b7 8d c4 fd ff ff 	movzwl -0x23c(%ebp),%ecx
 23f:	66 89 8d b0 fd ff ff 	mov    %cx,-0x250(%ebp)
 246:	83 ec 0c             	sub    $0xc,%esp
 249:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 24f:	50                   	push   %eax
 250:	e8 ab fd ff ff       	call   0 <fmtname>
 255:	83 c4 08             	add    $0x8,%esp
 258:	57                   	push   %edi
 259:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 25f:	0f bf 95 b0 fd ff ff 	movswl -0x250(%ebp),%edx
 266:	52                   	push   %edx
 267:	50                   	push   %eax
 268:	68 78 09 00 00       	push   $0x978
 26d:	6a 01                	push   $0x1
 26f:	e8 21 04 00 00       	call   695 <printf>
 274:	83 c4 20             	add    $0x20,%esp
 277:	e9 4a ff ff ff       	jmp    1c6 <ls+0x139>
        printf(1, "ls: cannot stat %s\n", buf);
 27c:	83 ec 04             	sub    $0x4,%esp
 27f:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 285:	50                   	push   %eax
 286:	68 64 09 00 00       	push   $0x964
 28b:	6a 01                	push   $0x1
 28d:	e8 03 04 00 00       	call   695 <printf>
        continue;
 292:	83 c4 10             	add    $0x10,%esp
 295:	e9 2c ff ff ff       	jmp    1c6 <ls+0x139>

0000029a <main>:

int
main(int argc, char *argv[])
{
 29a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 29e:	83 e4 f0             	and    $0xfffffff0,%esp
 2a1:	ff 71 fc             	pushl  -0x4(%ecx)
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	57                   	push   %edi
 2a8:	56                   	push   %esi
 2a9:	53                   	push   %ebx
 2aa:	51                   	push   %ecx
 2ab:	83 ec 08             	sub    $0x8,%esp
 2ae:	8b 31                	mov    (%ecx),%esi
 2b0:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
 2b3:	83 fe 01             	cmp    $0x1,%esi
 2b6:	7e 07                	jle    2bf <main+0x25>
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 2b8:	bb 01 00 00 00       	mov    $0x1,%ebx
 2bd:	eb 23                	jmp    2e2 <main+0x48>
    ls(".");
 2bf:	83 ec 0c             	sub    $0xc,%esp
 2c2:	68 98 09 00 00       	push   $0x998
 2c7:	e8 c1 fd ff ff       	call   8d <ls>
    exit();
 2cc:	e8 7a 02 00 00       	call   54b <exit>
    ls(argv[i]);
 2d1:	83 ec 0c             	sub    $0xc,%esp
 2d4:	ff 34 9f             	pushl  (%edi,%ebx,4)
 2d7:	e8 b1 fd ff ff       	call   8d <ls>
  for(i=1; i<argc; i++)
 2dc:	83 c3 01             	add    $0x1,%ebx
 2df:	83 c4 10             	add    $0x10,%esp
 2e2:	39 f3                	cmp    %esi,%ebx
 2e4:	7c eb                	jl     2d1 <main+0x37>
  exit();
 2e6:	e8 60 02 00 00       	call   54b <exit>

000002eb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp
 2ee:	53                   	push   %ebx
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2f5:	89 c2                	mov    %eax,%edx
 2f7:	0f b6 19             	movzbl (%ecx),%ebx
 2fa:	88 1a                	mov    %bl,(%edx)
 2fc:	8d 52 01             	lea    0x1(%edx),%edx
 2ff:	8d 49 01             	lea    0x1(%ecx),%ecx
 302:	84 db                	test   %bl,%bl
 304:	75 f1                	jne    2f7 <strcpy+0xc>
    ;
  return os;
}
 306:	5b                   	pop    %ebx
 307:	5d                   	pop    %ebp
 308:	c3                   	ret    

00000309 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 309:	55                   	push   %ebp
 30a:	89 e5                	mov    %esp,%ebp
 30c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 30f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 312:	eb 06                	jmp    31a <strcmp+0x11>
    p++, q++;
 314:	83 c1 01             	add    $0x1,%ecx
 317:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 31a:	0f b6 01             	movzbl (%ecx),%eax
 31d:	84 c0                	test   %al,%al
 31f:	74 04                	je     325 <strcmp+0x1c>
 321:	3a 02                	cmp    (%edx),%al
 323:	74 ef                	je     314 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 325:	0f b6 c0             	movzbl %al,%eax
 328:	0f b6 12             	movzbl (%edx),%edx
 32b:	29 d0                	sub    %edx,%eax
}
 32d:	5d                   	pop    %ebp
 32e:	c3                   	ret    

0000032f <strlen>:

uint
strlen(char *s)
{
 32f:	55                   	push   %ebp
 330:	89 e5                	mov    %esp,%ebp
 332:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 335:	ba 00 00 00 00       	mov    $0x0,%edx
 33a:	eb 03                	jmp    33f <strlen+0x10>
 33c:	83 c2 01             	add    $0x1,%edx
 33f:	89 d0                	mov    %edx,%eax
 341:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 345:	75 f5                	jne    33c <strlen+0xd>
    ;
  return n;
}
 347:	5d                   	pop    %ebp
 348:	c3                   	ret    

00000349 <memset>:

void*
memset(void *dst, int c, uint n)
{
 349:	55                   	push   %ebp
 34a:	89 e5                	mov    %esp,%ebp
 34c:	57                   	push   %edi
 34d:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 350:	89 d7                	mov    %edx,%edi
 352:	8b 4d 10             	mov    0x10(%ebp),%ecx
 355:	8b 45 0c             	mov    0xc(%ebp),%eax
 358:	fc                   	cld    
 359:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 35b:	89 d0                	mov    %edx,%eax
 35d:	5f                   	pop    %edi
 35e:	5d                   	pop    %ebp
 35f:	c3                   	ret    

00000360 <strchr>:

char*
strchr(const char *s, char c)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 36a:	0f b6 10             	movzbl (%eax),%edx
 36d:	84 d2                	test   %dl,%dl
 36f:	74 09                	je     37a <strchr+0x1a>
    if(*s == c)
 371:	38 ca                	cmp    %cl,%dl
 373:	74 0a                	je     37f <strchr+0x1f>
  for(; *s; s++)
 375:	83 c0 01             	add    $0x1,%eax
 378:	eb f0                	jmp    36a <strchr+0xa>
      return (char*)s;
  return 0;
 37a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    

00000381 <gets>:

char*
gets(char *buf, int max)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
 384:	57                   	push   %edi
 385:	56                   	push   %esi
 386:	53                   	push   %ebx
 387:	83 ec 1c             	sub    $0x1c,%esp
 38a:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 38d:	bb 00 00 00 00       	mov    $0x0,%ebx
 392:	8d 73 01             	lea    0x1(%ebx),%esi
 395:	3b 75 0c             	cmp    0xc(%ebp),%esi
 398:	7d 2e                	jge    3c8 <gets+0x47>
    cc = read(0, &c, 1);
 39a:	83 ec 04             	sub    $0x4,%esp
 39d:	6a 01                	push   $0x1
 39f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3a2:	50                   	push   %eax
 3a3:	6a 00                	push   $0x0
 3a5:	e8 b9 01 00 00       	call   563 <read>
    if(cc < 1)
 3aa:	83 c4 10             	add    $0x10,%esp
 3ad:	85 c0                	test   %eax,%eax
 3af:	7e 17                	jle    3c8 <gets+0x47>
      break;
    buf[i++] = c;
 3b1:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3b5:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 3b8:	3c 0a                	cmp    $0xa,%al
 3ba:	0f 94 c2             	sete   %dl
 3bd:	3c 0d                	cmp    $0xd,%al
 3bf:	0f 94 c0             	sete   %al
    buf[i++] = c;
 3c2:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 3c4:	08 c2                	or     %al,%dl
 3c6:	74 ca                	je     392 <gets+0x11>
      break;
  }
  buf[i] = '\0';
 3c8:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 3cc:	89 f8                	mov    %edi,%eax
 3ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d1:	5b                   	pop    %ebx
 3d2:	5e                   	pop    %esi
 3d3:	5f                   	pop    %edi
 3d4:	5d                   	pop    %ebp
 3d5:	c3                   	ret    

000003d6 <stat>:

int
stat(char *n, struct stat *st)
{
 3d6:	55                   	push   %ebp
 3d7:	89 e5                	mov    %esp,%ebp
 3d9:	56                   	push   %esi
 3da:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3db:	83 ec 08             	sub    $0x8,%esp
 3de:	6a 00                	push   $0x0
 3e0:	ff 75 08             	pushl  0x8(%ebp)
 3e3:	e8 a3 01 00 00       	call   58b <open>
  if(fd < 0)
 3e8:	83 c4 10             	add    $0x10,%esp
 3eb:	85 c0                	test   %eax,%eax
 3ed:	78 24                	js     413 <stat+0x3d>
 3ef:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3f1:	83 ec 08             	sub    $0x8,%esp
 3f4:	ff 75 0c             	pushl  0xc(%ebp)
 3f7:	50                   	push   %eax
 3f8:	e8 a6 01 00 00       	call   5a3 <fstat>
 3fd:	89 c6                	mov    %eax,%esi
  close(fd);
 3ff:	89 1c 24             	mov    %ebx,(%esp)
 402:	e8 6c 01 00 00       	call   573 <close>
  return r;
 407:	83 c4 10             	add    $0x10,%esp
}
 40a:	89 f0                	mov    %esi,%eax
 40c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 40f:	5b                   	pop    %ebx
 410:	5e                   	pop    %esi
 411:	5d                   	pop    %ebp
 412:	c3                   	ret    
    return -1;
 413:	be ff ff ff ff       	mov    $0xffffffff,%esi
 418:	eb f0                	jmp    40a <stat+0x34>

0000041a <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
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
 423:	eb 03                	jmp    428 <atoi+0xe>
 425:	83 c2 01             	add    $0x1,%edx
 428:	0f b6 02             	movzbl (%edx),%eax
 42b:	3c 20                	cmp    $0x20,%al
 42d:	74 f6                	je     425 <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
 42f:	3c 2d                	cmp    $0x2d,%al
 431:	74 1d                	je     450 <atoi+0x36>
 433:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 438:	3c 2b                	cmp    $0x2b,%al
 43a:	0f 94 c1             	sete   %cl
 43d:	3c 2d                	cmp    $0x2d,%al
 43f:	0f 94 c0             	sete   %al
 442:	08 c1                	or     %al,%cl
 444:	74 03                	je     449 <atoi+0x2f>
    s++;
 446:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 449:	b8 00 00 00 00       	mov    $0x0,%eax
 44e:	eb 17                	jmp    467 <atoi+0x4d>
 450:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 455:	eb e1                	jmp    438 <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 457:	8d 34 80             	lea    (%eax,%eax,4),%esi
 45a:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 45d:	83 c2 01             	add    $0x1,%edx
 460:	0f be c9             	movsbl %cl,%ecx
 463:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 467:	0f b6 0a             	movzbl (%edx),%ecx
 46a:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 46d:	80 fb 09             	cmp    $0x9,%bl
 470:	76 e5                	jbe    457 <atoi+0x3d>
  return sign*n;
 472:	0f af c7             	imul   %edi,%eax
}
 475:	5b                   	pop    %ebx
 476:	5e                   	pop    %esi
 477:	5f                   	pop    %edi
 478:	5d                   	pop    %ebp
 479:	c3                   	ret    

0000047a <atoo>:

int
atoo(const char *s)
{
 47a:	55                   	push   %ebp
 47b:	89 e5                	mov    %esp,%ebp
 47d:	57                   	push   %edi
 47e:	56                   	push   %esi
 47f:	53                   	push   %ebx
 480:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 483:	eb 03                	jmp    488 <atoo+0xe>
 485:	83 c2 01             	add    $0x1,%edx
 488:	0f b6 0a             	movzbl (%edx),%ecx
 48b:	80 f9 20             	cmp    $0x20,%cl
 48e:	74 f5                	je     485 <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
 490:	80 f9 2d             	cmp    $0x2d,%cl
 493:	74 23                	je     4b8 <atoo+0x3e>
 495:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 49a:	80 f9 2b             	cmp    $0x2b,%cl
 49d:	0f 94 c0             	sete   %al
 4a0:	89 c6                	mov    %eax,%esi
 4a2:	80 f9 2d             	cmp    $0x2d,%cl
 4a5:	0f 94 c0             	sete   %al
 4a8:	89 f3                	mov    %esi,%ebx
 4aa:	08 c3                	or     %al,%bl
 4ac:	74 03                	je     4b1 <atoo+0x37>
    s++;
 4ae:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 4b1:	b8 00 00 00 00       	mov    $0x0,%eax
 4b6:	eb 11                	jmp    4c9 <atoo+0x4f>
 4b8:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 4bd:	eb db                	jmp    49a <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 4bf:	83 c2 01             	add    $0x1,%edx
 4c2:	0f be c9             	movsbl %cl,%ecx
 4c5:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 4c9:	0f b6 0a             	movzbl (%edx),%ecx
 4cc:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 4cf:	80 fb 07             	cmp    $0x7,%bl
 4d2:	76 eb                	jbe    4bf <atoo+0x45>
  return sign*n;
 4d4:	0f af c7             	imul   %edi,%eax
}
 4d7:	5b                   	pop    %ebx
 4d8:	5e                   	pop    %esi
 4d9:	5f                   	pop    %edi
 4da:	5d                   	pop    %ebp
 4db:	c3                   	ret    

000004dc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 4dc:	55                   	push   %ebp
 4dd:	89 e5                	mov    %esp,%ebp
 4df:	53                   	push   %ebx
 4e0:	8b 55 08             	mov    0x8(%ebp),%edx
 4e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 4e6:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 4e9:	eb 09                	jmp    4f4 <strncmp+0x18>
      n--, p++, q++;
 4eb:	83 e8 01             	sub    $0x1,%eax
 4ee:	83 c2 01             	add    $0x1,%edx
 4f1:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 4f4:	85 c0                	test   %eax,%eax
 4f6:	74 0b                	je     503 <strncmp+0x27>
 4f8:	0f b6 1a             	movzbl (%edx),%ebx
 4fb:	84 db                	test   %bl,%bl
 4fd:	74 04                	je     503 <strncmp+0x27>
 4ff:	3a 19                	cmp    (%ecx),%bl
 501:	74 e8                	je     4eb <strncmp+0xf>
    if(n == 0)
 503:	85 c0                	test   %eax,%eax
 505:	74 0b                	je     512 <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
 507:	0f b6 02             	movzbl (%edx),%eax
 50a:	0f b6 11             	movzbl (%ecx),%edx
 50d:	29 d0                	sub    %edx,%eax
}
 50f:	5b                   	pop    %ebx
 510:	5d                   	pop    %ebp
 511:	c3                   	ret    
      return 0;
 512:	b8 00 00 00 00       	mov    $0x0,%eax
 517:	eb f6                	jmp    50f <strncmp+0x33>

00000519 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 519:	55                   	push   %ebp
 51a:	89 e5                	mov    %esp,%ebp
 51c:	56                   	push   %esi
 51d:	53                   	push   %ebx
 51e:	8b 45 08             	mov    0x8(%ebp),%eax
 521:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 524:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
 527:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 529:	eb 0d                	jmp    538 <memmove+0x1f>
    *dst++ = *src++;
 52b:	0f b6 13             	movzbl (%ebx),%edx
 52e:	88 11                	mov    %dl,(%ecx)
 530:	8d 5b 01             	lea    0x1(%ebx),%ebx
 533:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 536:	89 f2                	mov    %esi,%edx
 538:	8d 72 ff             	lea    -0x1(%edx),%esi
 53b:	85 d2                	test   %edx,%edx
 53d:	7f ec                	jg     52b <memmove+0x12>
  return vdst;
}
 53f:	5b                   	pop    %ebx
 540:	5e                   	pop    %esi
 541:	5d                   	pop    %ebp
 542:	c3                   	ret    

00000543 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 543:	b8 01 00 00 00       	mov    $0x1,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <exit>:
SYSCALL(exit)
 54b:	b8 02 00 00 00       	mov    $0x2,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <wait>:
SYSCALL(wait)
 553:	b8 03 00 00 00       	mov    $0x3,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <pipe>:
SYSCALL(pipe)
 55b:	b8 04 00 00 00       	mov    $0x4,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <read>:
SYSCALL(read)
 563:	b8 05 00 00 00       	mov    $0x5,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <write>:
SYSCALL(write)
 56b:	b8 10 00 00 00       	mov    $0x10,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <close>:
SYSCALL(close)
 573:	b8 15 00 00 00       	mov    $0x15,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <kill>:
SYSCALL(kill)
 57b:	b8 06 00 00 00       	mov    $0x6,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <exec>:
SYSCALL(exec)
 583:	b8 07 00 00 00       	mov    $0x7,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <open>:
SYSCALL(open)
 58b:	b8 0f 00 00 00       	mov    $0xf,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <mknod>:
SYSCALL(mknod)
 593:	b8 11 00 00 00       	mov    $0x11,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <unlink>:
SYSCALL(unlink)
 59b:	b8 12 00 00 00       	mov    $0x12,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <fstat>:
SYSCALL(fstat)
 5a3:	b8 08 00 00 00       	mov    $0x8,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <link>:
SYSCALL(link)
 5ab:	b8 13 00 00 00       	mov    $0x13,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <mkdir>:
SYSCALL(mkdir)
 5b3:	b8 14 00 00 00       	mov    $0x14,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <chdir>:
SYSCALL(chdir)
 5bb:	b8 09 00 00 00       	mov    $0x9,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <dup>:
SYSCALL(dup)
 5c3:	b8 0a 00 00 00       	mov    $0xa,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <getpid>:
SYSCALL(getpid)
 5cb:	b8 0b 00 00 00       	mov    $0xb,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <sbrk>:
SYSCALL(sbrk)
 5d3:	b8 0c 00 00 00       	mov    $0xc,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <sleep>:
SYSCALL(sleep)
 5db:	b8 0d 00 00 00       	mov    $0xd,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <uptime>:
SYSCALL(uptime)
 5e3:	b8 0e 00 00 00       	mov    $0xe,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <halt>:
SYSCALL(halt)
 5eb:	b8 16 00 00 00       	mov    $0x16,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <date>:
SYSCALL(date)
 5f3:	b8 17 00 00 00       	mov    $0x17,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5fb:	55                   	push   %ebp
 5fc:	89 e5                	mov    %esp,%ebp
 5fe:	83 ec 1c             	sub    $0x1c,%esp
 601:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 604:	6a 01                	push   $0x1
 606:	8d 55 f4             	lea    -0xc(%ebp),%edx
 609:	52                   	push   %edx
 60a:	50                   	push   %eax
 60b:	e8 5b ff ff ff       	call   56b <write>
}
 610:	83 c4 10             	add    $0x10,%esp
 613:	c9                   	leave  
 614:	c3                   	ret    

00000615 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 615:	55                   	push   %ebp
 616:	89 e5                	mov    %esp,%ebp
 618:	57                   	push   %edi
 619:	56                   	push   %esi
 61a:	53                   	push   %ebx
 61b:	83 ec 2c             	sub    $0x2c,%esp
 61e:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 620:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 624:	0f 95 c3             	setne  %bl
 627:	89 d0                	mov    %edx,%eax
 629:	c1 e8 1f             	shr    $0x1f,%eax
 62c:	84 c3                	test   %al,%bl
 62e:	74 10                	je     640 <printint+0x2b>
    neg = 1;
    x = -xx;
 630:	f7 da                	neg    %edx
    neg = 1;
 632:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 639:	be 00 00 00 00       	mov    $0x0,%esi
 63e:	eb 0b                	jmp    64b <printint+0x36>
  neg = 0;
 640:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 647:	eb f0                	jmp    639 <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 649:	89 c6                	mov    %eax,%esi
 64b:	89 d0                	mov    %edx,%eax
 64d:	ba 00 00 00 00       	mov    $0x0,%edx
 652:	f7 f1                	div    %ecx
 654:	89 c3                	mov    %eax,%ebx
 656:	8d 46 01             	lea    0x1(%esi),%eax
 659:	0f b6 92 a4 09 00 00 	movzbl 0x9a4(%edx),%edx
 660:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 664:	89 da                	mov    %ebx,%edx
 666:	85 db                	test   %ebx,%ebx
 668:	75 df                	jne    649 <printint+0x34>
 66a:	89 c3                	mov    %eax,%ebx
  if(neg)
 66c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 670:	74 16                	je     688 <printint+0x73>
    buf[i++] = '-';
 672:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 677:	8d 5e 02             	lea    0x2(%esi),%ebx
 67a:	eb 0c                	jmp    688 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 67c:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 681:	89 f8                	mov    %edi,%eax
 683:	e8 73 ff ff ff       	call   5fb <putc>
  while(--i >= 0)
 688:	83 eb 01             	sub    $0x1,%ebx
 68b:	79 ef                	jns    67c <printint+0x67>
}
 68d:	83 c4 2c             	add    $0x2c,%esp
 690:	5b                   	pop    %ebx
 691:	5e                   	pop    %esi
 692:	5f                   	pop    %edi
 693:	5d                   	pop    %ebp
 694:	c3                   	ret    

00000695 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 695:	55                   	push   %ebp
 696:	89 e5                	mov    %esp,%ebp
 698:	57                   	push   %edi
 699:	56                   	push   %esi
 69a:	53                   	push   %ebx
 69b:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 69e:	8d 45 10             	lea    0x10(%ebp),%eax
 6a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 6a4:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 6a9:	bb 00 00 00 00       	mov    $0x0,%ebx
 6ae:	eb 14                	jmp    6c4 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 6b0:	89 fa                	mov    %edi,%edx
 6b2:	8b 45 08             	mov    0x8(%ebp),%eax
 6b5:	e8 41 ff ff ff       	call   5fb <putc>
 6ba:	eb 05                	jmp    6c1 <printf+0x2c>
      }
    } else if(state == '%'){
 6bc:	83 fe 25             	cmp    $0x25,%esi
 6bf:	74 25                	je     6e6 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 6c1:	83 c3 01             	add    $0x1,%ebx
 6c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c7:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 6cb:	84 c0                	test   %al,%al
 6cd:	0f 84 23 01 00 00    	je     7f6 <printf+0x161>
    c = fmt[i] & 0xff;
 6d3:	0f be f8             	movsbl %al,%edi
 6d6:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 6d9:	85 f6                	test   %esi,%esi
 6db:	75 df                	jne    6bc <printf+0x27>
      if(c == '%'){
 6dd:	83 f8 25             	cmp    $0x25,%eax
 6e0:	75 ce                	jne    6b0 <printf+0x1b>
        state = '%';
 6e2:	89 c6                	mov    %eax,%esi
 6e4:	eb db                	jmp    6c1 <printf+0x2c>
      if(c == 'd'){
 6e6:	83 f8 64             	cmp    $0x64,%eax
 6e9:	74 49                	je     734 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6eb:	83 f8 78             	cmp    $0x78,%eax
 6ee:	0f 94 c1             	sete   %cl
 6f1:	83 f8 70             	cmp    $0x70,%eax
 6f4:	0f 94 c2             	sete   %dl
 6f7:	08 d1                	or     %dl,%cl
 6f9:	75 63                	jne    75e <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6fb:	83 f8 73             	cmp    $0x73,%eax
 6fe:	0f 84 84 00 00 00    	je     788 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 704:	83 f8 63             	cmp    $0x63,%eax
 707:	0f 84 b7 00 00 00    	je     7c4 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 70d:	83 f8 25             	cmp    $0x25,%eax
 710:	0f 84 cc 00 00 00    	je     7e2 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 716:	ba 25 00 00 00       	mov    $0x25,%edx
 71b:	8b 45 08             	mov    0x8(%ebp),%eax
 71e:	e8 d8 fe ff ff       	call   5fb <putc>
        putc(fd, c);
 723:	89 fa                	mov    %edi,%edx
 725:	8b 45 08             	mov    0x8(%ebp),%eax
 728:	e8 ce fe ff ff       	call   5fb <putc>
      }
      state = 0;
 72d:	be 00 00 00 00       	mov    $0x0,%esi
 732:	eb 8d                	jmp    6c1 <printf+0x2c>
        printint(fd, *ap, 10, 1);
 734:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 737:	8b 17                	mov    (%edi),%edx
 739:	83 ec 0c             	sub    $0xc,%esp
 73c:	6a 01                	push   $0x1
 73e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 743:	8b 45 08             	mov    0x8(%ebp),%eax
 746:	e8 ca fe ff ff       	call   615 <printint>
        ap++;
 74b:	83 c7 04             	add    $0x4,%edi
 74e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 751:	83 c4 10             	add    $0x10,%esp
      state = 0;
 754:	be 00 00 00 00       	mov    $0x0,%esi
 759:	e9 63 ff ff ff       	jmp    6c1 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 75e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 761:	8b 17                	mov    (%edi),%edx
 763:	83 ec 0c             	sub    $0xc,%esp
 766:	6a 00                	push   $0x0
 768:	b9 10 00 00 00       	mov    $0x10,%ecx
 76d:	8b 45 08             	mov    0x8(%ebp),%eax
 770:	e8 a0 fe ff ff       	call   615 <printint>
        ap++;
 775:	83 c7 04             	add    $0x4,%edi
 778:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 77b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 77e:	be 00 00 00 00       	mov    $0x0,%esi
 783:	e9 39 ff ff ff       	jmp    6c1 <printf+0x2c>
        s = (char*)*ap;
 788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 78b:	8b 30                	mov    (%eax),%esi
        ap++;
 78d:	83 c0 04             	add    $0x4,%eax
 790:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 793:	85 f6                	test   %esi,%esi
 795:	75 28                	jne    7bf <printf+0x12a>
          s = "(null)";
 797:	be 9a 09 00 00       	mov    $0x99a,%esi
 79c:	8b 7d 08             	mov    0x8(%ebp),%edi
 79f:	eb 0d                	jmp    7ae <printf+0x119>
          putc(fd, *s);
 7a1:	0f be d2             	movsbl %dl,%edx
 7a4:	89 f8                	mov    %edi,%eax
 7a6:	e8 50 fe ff ff       	call   5fb <putc>
          s++;
 7ab:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 7ae:	0f b6 16             	movzbl (%esi),%edx
 7b1:	84 d2                	test   %dl,%dl
 7b3:	75 ec                	jne    7a1 <printf+0x10c>
      state = 0;
 7b5:	be 00 00 00 00       	mov    $0x0,%esi
 7ba:	e9 02 ff ff ff       	jmp    6c1 <printf+0x2c>
 7bf:	8b 7d 08             	mov    0x8(%ebp),%edi
 7c2:	eb ea                	jmp    7ae <printf+0x119>
        putc(fd, *ap);
 7c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 7c7:	0f be 17             	movsbl (%edi),%edx
 7ca:	8b 45 08             	mov    0x8(%ebp),%eax
 7cd:	e8 29 fe ff ff       	call   5fb <putc>
        ap++;
 7d2:	83 c7 04             	add    $0x4,%edi
 7d5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 7d8:	be 00 00 00 00       	mov    $0x0,%esi
 7dd:	e9 df fe ff ff       	jmp    6c1 <printf+0x2c>
        putc(fd, c);
 7e2:	89 fa                	mov    %edi,%edx
 7e4:	8b 45 08             	mov    0x8(%ebp),%eax
 7e7:	e8 0f fe ff ff       	call   5fb <putc>
      state = 0;
 7ec:	be 00 00 00 00       	mov    $0x0,%esi
 7f1:	e9 cb fe ff ff       	jmp    6c1 <printf+0x2c>
    }
  }
}
 7f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7f9:	5b                   	pop    %ebx
 7fa:	5e                   	pop    %esi
 7fb:	5f                   	pop    %edi
 7fc:	5d                   	pop    %ebp
 7fd:	c3                   	ret    

000007fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fe:	55                   	push   %ebp
 7ff:	89 e5                	mov    %esp,%ebp
 801:	57                   	push   %edi
 802:	56                   	push   %esi
 803:	53                   	push   %ebx
 804:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 807:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80a:	a1 10 0d 00 00       	mov    0xd10,%eax
 80f:	eb 02                	jmp    813 <free+0x15>
 811:	89 d0                	mov    %edx,%eax
 813:	39 c8                	cmp    %ecx,%eax
 815:	73 04                	jae    81b <free+0x1d>
 817:	39 08                	cmp    %ecx,(%eax)
 819:	77 12                	ja     82d <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81b:	8b 10                	mov    (%eax),%edx
 81d:	39 c2                	cmp    %eax,%edx
 81f:	77 f0                	ja     811 <free+0x13>
 821:	39 c8                	cmp    %ecx,%eax
 823:	72 08                	jb     82d <free+0x2f>
 825:	39 ca                	cmp    %ecx,%edx
 827:	77 04                	ja     82d <free+0x2f>
 829:	89 d0                	mov    %edx,%eax
 82b:	eb e6                	jmp    813 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 82d:	8b 73 fc             	mov    -0x4(%ebx),%esi
 830:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 833:	8b 10                	mov    (%eax),%edx
 835:	39 d7                	cmp    %edx,%edi
 837:	74 19                	je     852 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 839:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 83c:	8b 50 04             	mov    0x4(%eax),%edx
 83f:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 842:	39 ce                	cmp    %ecx,%esi
 844:	74 1b                	je     861 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 846:	89 08                	mov    %ecx,(%eax)
  freep = p;
 848:	a3 10 0d 00 00       	mov    %eax,0xd10
}
 84d:	5b                   	pop    %ebx
 84e:	5e                   	pop    %esi
 84f:	5f                   	pop    %edi
 850:	5d                   	pop    %ebp
 851:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 852:	03 72 04             	add    0x4(%edx),%esi
 855:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 858:	8b 10                	mov    (%eax),%edx
 85a:	8b 12                	mov    (%edx),%edx
 85c:	89 53 f8             	mov    %edx,-0x8(%ebx)
 85f:	eb db                	jmp    83c <free+0x3e>
    p->s.size += bp->s.size;
 861:	03 53 fc             	add    -0x4(%ebx),%edx
 864:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 867:	8b 53 f8             	mov    -0x8(%ebx),%edx
 86a:	89 10                	mov    %edx,(%eax)
 86c:	eb da                	jmp    848 <free+0x4a>

0000086e <morecore>:

static Header*
morecore(uint nu)
{
 86e:	55                   	push   %ebp
 86f:	89 e5                	mov    %esp,%ebp
 871:	53                   	push   %ebx
 872:	83 ec 04             	sub    $0x4,%esp
 875:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 877:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 87c:	77 05                	ja     883 <morecore+0x15>
    nu = 4096;
 87e:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 883:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 88a:	83 ec 0c             	sub    $0xc,%esp
 88d:	50                   	push   %eax
 88e:	e8 40 fd ff ff       	call   5d3 <sbrk>
  if(p == (char*)-1)
 893:	83 c4 10             	add    $0x10,%esp
 896:	83 f8 ff             	cmp    $0xffffffff,%eax
 899:	74 1c                	je     8b7 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 89b:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 89e:	83 c0 08             	add    $0x8,%eax
 8a1:	83 ec 0c             	sub    $0xc,%esp
 8a4:	50                   	push   %eax
 8a5:	e8 54 ff ff ff       	call   7fe <free>
  return freep;
 8aa:	a1 10 0d 00 00       	mov    0xd10,%eax
 8af:	83 c4 10             	add    $0x10,%esp
}
 8b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8b5:	c9                   	leave  
 8b6:	c3                   	ret    
    return 0;
 8b7:	b8 00 00 00 00       	mov    $0x0,%eax
 8bc:	eb f4                	jmp    8b2 <morecore+0x44>

000008be <malloc>:

void*
malloc(uint nbytes)
{
 8be:	55                   	push   %ebp
 8bf:	89 e5                	mov    %esp,%ebp
 8c1:	53                   	push   %ebx
 8c2:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c5:	8b 45 08             	mov    0x8(%ebp),%eax
 8c8:	8d 58 07             	lea    0x7(%eax),%ebx
 8cb:	c1 eb 03             	shr    $0x3,%ebx
 8ce:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 8d1:	8b 0d 10 0d 00 00    	mov    0xd10,%ecx
 8d7:	85 c9                	test   %ecx,%ecx
 8d9:	74 04                	je     8df <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8db:	8b 01                	mov    (%ecx),%eax
 8dd:	eb 4d                	jmp    92c <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 8df:	c7 05 10 0d 00 00 14 	movl   $0xd14,0xd10
 8e6:	0d 00 00 
 8e9:	c7 05 14 0d 00 00 14 	movl   $0xd14,0xd14
 8f0:	0d 00 00 
    base.s.size = 0;
 8f3:	c7 05 18 0d 00 00 00 	movl   $0x0,0xd18
 8fa:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 8fd:	b9 14 0d 00 00       	mov    $0xd14,%ecx
 902:	eb d7                	jmp    8db <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 904:	39 da                	cmp    %ebx,%edx
 906:	74 1a                	je     922 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 908:	29 da                	sub    %ebx,%edx
 90a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 90d:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 910:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 913:	89 0d 10 0d 00 00    	mov    %ecx,0xd10
      return (void*)(p + 1);
 919:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 91c:	83 c4 04             	add    $0x4,%esp
 91f:	5b                   	pop    %ebx
 920:	5d                   	pop    %ebp
 921:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 922:	8b 10                	mov    (%eax),%edx
 924:	89 11                	mov    %edx,(%ecx)
 926:	eb eb                	jmp    913 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 928:	89 c1                	mov    %eax,%ecx
 92a:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 92c:	8b 50 04             	mov    0x4(%eax),%edx
 92f:	39 da                	cmp    %ebx,%edx
 931:	73 d1                	jae    904 <malloc+0x46>
    if(p == freep)
 933:	39 05 10 0d 00 00    	cmp    %eax,0xd10
 939:	75 ed                	jne    928 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 93b:	89 d8                	mov    %ebx,%eax
 93d:	e8 2c ff ff ff       	call   86e <morecore>
 942:	85 c0                	test   %eax,%eax
 944:	75 e2                	jne    928 <malloc+0x6a>
        return 0;
 946:	b8 00 00 00 00       	mov    $0x0,%eax
 94b:	eb cf                	jmp    91c <malloc+0x5e>
