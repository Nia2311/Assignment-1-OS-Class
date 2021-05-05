
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	56                   	push   %esi
       4:	53                   	push   %ebx
       5:	8b 5d 08             	mov    0x8(%ebp),%ebx
       8:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 5c 10 00 00       	push   $0x105c
      13:	6a 02                	push   $0x2
      15:	e8 8a 0d 00 00       	call   da4 <printf>
  memset(buf, 0, nbuf);
      1a:	83 c4 0c             	add    $0xc,%esp
      1d:	56                   	push   %esi
      1e:	6a 00                	push   $0x0
      20:	53                   	push   %ebx
      21:	e8 32 0a 00 00       	call   a58 <memset>
  gets(buf, nbuf);
      26:	83 c4 08             	add    $0x8,%esp
      29:	56                   	push   %esi
      2a:	53                   	push   %ebx
      2b:	e8 60 0a 00 00       	call   a90 <gets>
  if(buf[0] == 0) // EOF
      30:	83 c4 10             	add    $0x10,%esp
      33:	80 3b 00             	cmpb   $0x0,(%ebx)
      36:	74 0c                	je     44 <getcmd+0x44>
    return -1;
  return 0;
      38:	b8 00 00 00 00       	mov    $0x0,%eax
}
      3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
      40:	5b                   	pop    %ebx
      41:	5e                   	pop    %esi
      42:	5d                   	pop    %ebp
      43:	c3                   	ret    
    return -1;
      44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      49:	eb f2                	jmp    3d <getcmd+0x3d>

0000004b <panic>:
  exit();
}

void
panic(char *s)
{
      4b:	55                   	push   %ebp
      4c:	89 e5                	mov    %esp,%ebp
      4e:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
      51:	ff 75 08             	pushl  0x8(%ebp)
      54:	68 f9 10 00 00       	push   $0x10f9
      59:	6a 02                	push   $0x2
      5b:	e8 44 0d 00 00       	call   da4 <printf>
  exit();
      60:	e8 f5 0b 00 00       	call   c5a <exit>

00000065 <fork1>:
}

int
fork1(void)
{
      65:	55                   	push   %ebp
      66:	89 e5                	mov    %esp,%ebp
      68:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
      6b:	e8 e2 0b 00 00       	call   c52 <fork>
  if(pid == -1)
      70:	83 f8 ff             	cmp    $0xffffffff,%eax
      73:	74 02                	je     77 <fork1+0x12>
    panic("fork");
  return pid;
}
      75:	c9                   	leave  
      76:	c3                   	ret    
    panic("fork");
      77:	83 ec 0c             	sub    $0xc,%esp
      7a:	68 5f 10 00 00       	push   $0x105f
      7f:	e8 c7 ff ff ff       	call   4b <panic>

00000084 <runcmd>:
{
      84:	55                   	push   %ebp
      85:	89 e5                	mov    %esp,%ebp
      87:	53                   	push   %ebx
      88:	83 ec 14             	sub    $0x14,%esp
      8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
      8e:	85 db                	test   %ebx,%ebx
      90:	74 0e                	je     a0 <runcmd+0x1c>
  switch(cmd->type){
      92:	8b 03                	mov    (%ebx),%eax
      94:	83 f8 05             	cmp    $0x5,%eax
      97:	77 0c                	ja     a5 <runcmd+0x21>
      99:	ff 24 85 18 11 00 00 	jmp    *0x1118(,%eax,4)
    exit();
      a0:	e8 b5 0b 00 00       	call   c5a <exit>
    panic("runcmd");
      a5:	83 ec 0c             	sub    $0xc,%esp
      a8:	68 64 10 00 00       	push   $0x1064
      ad:	e8 99 ff ff ff       	call   4b <panic>
    if(ecmd->argv[0] == 0)
      b2:	8b 43 04             	mov    0x4(%ebx),%eax
      b5:	85 c0                	test   %eax,%eax
      b7:	74 27                	je     e0 <runcmd+0x5c>
    exec(ecmd->argv[0], ecmd->argv);
      b9:	8d 53 04             	lea    0x4(%ebx),%edx
      bc:	83 ec 08             	sub    $0x8,%esp
      bf:	52                   	push   %edx
      c0:	50                   	push   %eax
      c1:	e8 cc 0b 00 00       	call   c92 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      c6:	83 c4 0c             	add    $0xc,%esp
      c9:	ff 73 04             	pushl  0x4(%ebx)
      cc:	68 6b 10 00 00       	push   $0x106b
      d1:	6a 02                	push   $0x2
      d3:	e8 cc 0c 00 00       	call   da4 <printf>
    break;
      d8:	83 c4 10             	add    $0x10,%esp
      db:	e9 3a 01 00 00       	jmp    21a <runcmd+0x196>
      exit();
      e0:	e8 75 0b 00 00       	call   c5a <exit>
    close(rcmd->fd);
      e5:	83 ec 0c             	sub    $0xc,%esp
      e8:	ff 73 14             	pushl  0x14(%ebx)
      eb:	e8 92 0b 00 00       	call   c82 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      f0:	83 c4 08             	add    $0x8,%esp
      f3:	ff 73 10             	pushl  0x10(%ebx)
      f6:	ff 73 08             	pushl  0x8(%ebx)
      f9:	e8 9c 0b 00 00       	call   c9a <open>
      fe:	83 c4 10             	add    $0x10,%esp
     101:	85 c0                	test   %eax,%eax
     103:	79 17                	jns    11c <runcmd+0x98>
      printf(2, "open %s failed\n", rcmd->file);
     105:	83 ec 04             	sub    $0x4,%esp
     108:	ff 73 08             	pushl  0x8(%ebx)
     10b:	68 7b 10 00 00       	push   $0x107b
     110:	6a 02                	push   $0x2
     112:	e8 8d 0c 00 00       	call   da4 <printf>
      exit();
     117:	e8 3e 0b 00 00       	call   c5a <exit>
    runcmd(rcmd->cmd);
     11c:	83 ec 0c             	sub    $0xc,%esp
     11f:	ff 73 04             	pushl  0x4(%ebx)
     122:	e8 5d ff ff ff       	call   84 <runcmd>
    if(fork1() == 0)
     127:	e8 39 ff ff ff       	call   65 <fork1>
     12c:	85 c0                	test   %eax,%eax
     12e:	74 10                	je     140 <runcmd+0xbc>
    wait();
     130:	e8 2d 0b 00 00       	call   c62 <wait>
    runcmd(lcmd->right);
     135:	83 ec 0c             	sub    $0xc,%esp
     138:	ff 73 08             	pushl  0x8(%ebx)
     13b:	e8 44 ff ff ff       	call   84 <runcmd>
      runcmd(lcmd->left);
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	ff 73 04             	pushl  0x4(%ebx)
     146:	e8 39 ff ff ff       	call   84 <runcmd>
    if(pipe(p) < 0)
     14b:	83 ec 0c             	sub    $0xc,%esp
     14e:	8d 45 f0             	lea    -0x10(%ebp),%eax
     151:	50                   	push   %eax
     152:	e8 13 0b 00 00       	call   c6a <pipe>
     157:	83 c4 10             	add    $0x10,%esp
     15a:	85 c0                	test   %eax,%eax
     15c:	78 3a                	js     198 <runcmd+0x114>
    if(fork1() == 0){
     15e:	e8 02 ff ff ff       	call   65 <fork1>
     163:	85 c0                	test   %eax,%eax
     165:	74 3e                	je     1a5 <runcmd+0x121>
    if(fork1() == 0){
     167:	e8 f9 fe ff ff       	call   65 <fork1>
     16c:	85 c0                	test   %eax,%eax
     16e:	74 6b                	je     1db <runcmd+0x157>
    close(p[0]);
     170:	83 ec 0c             	sub    $0xc,%esp
     173:	ff 75 f0             	pushl  -0x10(%ebp)
     176:	e8 07 0b 00 00       	call   c82 <close>
    close(p[1]);
     17b:	83 c4 04             	add    $0x4,%esp
     17e:	ff 75 f4             	pushl  -0xc(%ebp)
     181:	e8 fc 0a 00 00       	call   c82 <close>
    wait();
     186:	e8 d7 0a 00 00       	call   c62 <wait>
    wait();
     18b:	e8 d2 0a 00 00       	call   c62 <wait>
    break;
     190:	83 c4 10             	add    $0x10,%esp
     193:	e9 82 00 00 00       	jmp    21a <runcmd+0x196>
      panic("pipe");
     198:	83 ec 0c             	sub    $0xc,%esp
     19b:	68 8b 10 00 00       	push   $0x108b
     1a0:	e8 a6 fe ff ff       	call   4b <panic>
      close(1);
     1a5:	83 ec 0c             	sub    $0xc,%esp
     1a8:	6a 01                	push   $0x1
     1aa:	e8 d3 0a 00 00       	call   c82 <close>
      dup(p[1]);
     1af:	83 c4 04             	add    $0x4,%esp
     1b2:	ff 75 f4             	pushl  -0xc(%ebp)
     1b5:	e8 18 0b 00 00       	call   cd2 <dup>
      close(p[0]);
     1ba:	83 c4 04             	add    $0x4,%esp
     1bd:	ff 75 f0             	pushl  -0x10(%ebp)
     1c0:	e8 bd 0a 00 00       	call   c82 <close>
      close(p[1]);
     1c5:	83 c4 04             	add    $0x4,%esp
     1c8:	ff 75 f4             	pushl  -0xc(%ebp)
     1cb:	e8 b2 0a 00 00       	call   c82 <close>
      runcmd(pcmd->left);
     1d0:	83 c4 04             	add    $0x4,%esp
     1d3:	ff 73 04             	pushl  0x4(%ebx)
     1d6:	e8 a9 fe ff ff       	call   84 <runcmd>
      close(0);
     1db:	83 ec 0c             	sub    $0xc,%esp
     1de:	6a 00                	push   $0x0
     1e0:	e8 9d 0a 00 00       	call   c82 <close>
      dup(p[0]);
     1e5:	83 c4 04             	add    $0x4,%esp
     1e8:	ff 75 f0             	pushl  -0x10(%ebp)
     1eb:	e8 e2 0a 00 00       	call   cd2 <dup>
      close(p[0]);
     1f0:	83 c4 04             	add    $0x4,%esp
     1f3:	ff 75 f0             	pushl  -0x10(%ebp)
     1f6:	e8 87 0a 00 00       	call   c82 <close>
      close(p[1]);
     1fb:	83 c4 04             	add    $0x4,%esp
     1fe:	ff 75 f4             	pushl  -0xc(%ebp)
     201:	e8 7c 0a 00 00       	call   c82 <close>
      runcmd(pcmd->right);
     206:	83 c4 04             	add    $0x4,%esp
     209:	ff 73 08             	pushl  0x8(%ebx)
     20c:	e8 73 fe ff ff       	call   84 <runcmd>
    if(fork1() == 0)
     211:	e8 4f fe ff ff       	call   65 <fork1>
     216:	85 c0                	test   %eax,%eax
     218:	74 05                	je     21f <runcmd+0x19b>
  exit();
     21a:	e8 3b 0a 00 00       	call   c5a <exit>
      runcmd(bcmd->cmd);
     21f:	83 ec 0c             	sub    $0xc,%esp
     222:	ff 73 04             	pushl  0x4(%ebx)
     225:	e8 5a fe ff ff       	call   84 <runcmd>

0000022a <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     22a:	55                   	push   %ebp
     22b:	89 e5                	mov    %esp,%ebp
     22d:	53                   	push   %ebx
     22e:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     231:	6a 54                	push   $0x54
     233:	e8 95 0d 00 00       	call   fcd <malloc>
     238:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     23a:	83 c4 0c             	add    $0xc,%esp
     23d:	6a 54                	push   $0x54
     23f:	6a 00                	push   $0x0
     241:	50                   	push   %eax
     242:	e8 11 08 00 00       	call   a58 <memset>
  cmd->type = EXEC;
     247:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     24d:	89 d8                	mov    %ebx,%eax
     24f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     252:	c9                   	leave  
     253:	c3                   	ret    

00000254 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     254:	55                   	push   %ebp
     255:	89 e5                	mov    %esp,%ebp
     257:	53                   	push   %ebx
     258:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     25b:	6a 18                	push   $0x18
     25d:	e8 6b 0d 00 00       	call   fcd <malloc>
     262:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     264:	83 c4 0c             	add    $0xc,%esp
     267:	6a 18                	push   $0x18
     269:	6a 00                	push   $0x0
     26b:	50                   	push   %eax
     26c:	e8 e7 07 00 00       	call   a58 <memset>
  cmd->type = REDIR;
     271:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     277:	8b 45 08             	mov    0x8(%ebp),%eax
     27a:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     27d:	8b 45 0c             	mov    0xc(%ebp),%eax
     280:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     283:	8b 45 10             	mov    0x10(%ebp),%eax
     286:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     289:	8b 45 14             	mov    0x14(%ebp),%eax
     28c:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     28f:	8b 45 18             	mov    0x18(%ebp),%eax
     292:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     295:	89 d8                	mov    %ebx,%eax
     297:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     29a:	c9                   	leave  
     29b:	c3                   	ret    

0000029c <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     29c:	55                   	push   %ebp
     29d:	89 e5                	mov    %esp,%ebp
     29f:	53                   	push   %ebx
     2a0:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2a3:	6a 0c                	push   $0xc
     2a5:	e8 23 0d 00 00       	call   fcd <malloc>
     2aa:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2ac:	83 c4 0c             	add    $0xc,%esp
     2af:	6a 0c                	push   $0xc
     2b1:	6a 00                	push   $0x0
     2b3:	50                   	push   %eax
     2b4:	e8 9f 07 00 00       	call   a58 <memset>
  cmd->type = PIPE;
     2b9:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     2bf:	8b 45 08             	mov    0x8(%ebp),%eax
     2c2:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     2c5:	8b 45 0c             	mov    0xc(%ebp),%eax
     2c8:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     2cb:	89 d8                	mov    %ebx,%eax
     2cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     2d0:	c9                   	leave  
     2d1:	c3                   	ret    

000002d2 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     2d2:	55                   	push   %ebp
     2d3:	89 e5                	mov    %esp,%ebp
     2d5:	53                   	push   %ebx
     2d6:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2d9:	6a 0c                	push   $0xc
     2db:	e8 ed 0c 00 00       	call   fcd <malloc>
     2e0:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2e2:	83 c4 0c             	add    $0xc,%esp
     2e5:	6a 0c                	push   $0xc
     2e7:	6a 00                	push   $0x0
     2e9:	50                   	push   %eax
     2ea:	e8 69 07 00 00       	call   a58 <memset>
  cmd->type = LIST;
     2ef:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     2f5:	8b 45 08             	mov    0x8(%ebp),%eax
     2f8:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     2fb:	8b 45 0c             	mov    0xc(%ebp),%eax
     2fe:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     301:	89 d8                	mov    %ebx,%eax
     303:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     306:	c9                   	leave  
     307:	c3                   	ret    

00000308 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     308:	55                   	push   %ebp
     309:	89 e5                	mov    %esp,%ebp
     30b:	53                   	push   %ebx
     30c:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     30f:	6a 08                	push   $0x8
     311:	e8 b7 0c 00 00       	call   fcd <malloc>
     316:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     318:	83 c4 0c             	add    $0xc,%esp
     31b:	6a 08                	push   $0x8
     31d:	6a 00                	push   $0x0
     31f:	50                   	push   %eax
     320:	e8 33 07 00 00       	call   a58 <memset>
  cmd->type = BACK;
     325:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     32b:	8b 45 08             	mov    0x8(%ebp),%eax
     32e:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     331:	89 d8                	mov    %ebx,%eax
     333:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     336:	c9                   	leave  
     337:	c3                   	ret    

00000338 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     338:	55                   	push   %ebp
     339:	89 e5                	mov    %esp,%ebp
     33b:	57                   	push   %edi
     33c:	56                   	push   %esi
     33d:	53                   	push   %ebx
     33e:	83 ec 0c             	sub    $0xc,%esp
     341:	8b 75 0c             	mov    0xc(%ebp),%esi
     344:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
     347:	8b 45 08             	mov    0x8(%ebp),%eax
     34a:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
     34c:	eb 03                	jmp    351 <gettoken+0x19>
    s++;
     34e:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     351:	39 f3                	cmp    %esi,%ebx
     353:	73 18                	jae    36d <gettoken+0x35>
     355:	83 ec 08             	sub    $0x8,%esp
     358:	0f be 03             	movsbl (%ebx),%eax
     35b:	50                   	push   %eax
     35c:	68 28 17 00 00       	push   $0x1728
     361:	e8 09 07 00 00       	call   a6f <strchr>
     366:	83 c4 10             	add    $0x10,%esp
     369:	85 c0                	test   %eax,%eax
     36b:	75 e1                	jne    34e <gettoken+0x16>
  if(q)
     36d:	85 ff                	test   %edi,%edi
     36f:	74 02                	je     373 <gettoken+0x3b>
    *q = s;
     371:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
     373:	0f b6 03             	movzbl (%ebx),%eax
     376:	0f be f8             	movsbl %al,%edi
  switch(*s){
     379:	3c 29                	cmp    $0x29,%al
     37b:	7f 25                	jg     3a2 <gettoken+0x6a>
     37d:	3c 28                	cmp    $0x28,%al
     37f:	7d 1c                	jge    39d <gettoken+0x65>
     381:	84 c0                	test   %al,%al
     383:	75 14                	jne    399 <gettoken+0x61>
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     385:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     389:	0f 84 99 00 00 00    	je     428 <gettoken+0xf0>
    *eq = s;
     38f:	8b 45 14             	mov    0x14(%ebp),%eax
     392:	89 18                	mov    %ebx,(%eax)
     394:	e9 8f 00 00 00       	jmp    428 <gettoken+0xf0>
  switch(*s){
     399:	3c 26                	cmp    $0x26,%al
     39b:	75 36                	jne    3d3 <gettoken+0x9b>
    s++;
     39d:	83 c3 01             	add    $0x1,%ebx
    break;
     3a0:	eb e3                	jmp    385 <gettoken+0x4d>
  switch(*s){
     3a2:	3c 3e                	cmp    $0x3e,%al
     3a4:	74 13                	je     3b9 <gettoken+0x81>
     3a6:	3c 3e                	cmp    $0x3e,%al
     3a8:	7f 09                	jg     3b3 <gettoken+0x7b>
     3aa:	83 e8 3b             	sub    $0x3b,%eax
     3ad:	3c 01                	cmp    $0x1,%al
     3af:	77 22                	ja     3d3 <gettoken+0x9b>
     3b1:	eb ea                	jmp    39d <gettoken+0x65>
     3b3:	3c 7c                	cmp    $0x7c,%al
     3b5:	75 1c                	jne    3d3 <gettoken+0x9b>
     3b7:	eb e4                	jmp    39d <gettoken+0x65>
    s++;
     3b9:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '>'){
     3bc:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
     3c0:	74 04                	je     3c6 <gettoken+0x8e>
    s++;
     3c2:	89 c3                	mov    %eax,%ebx
     3c4:	eb bf                	jmp    385 <gettoken+0x4d>
      s++;
     3c6:	83 c3 02             	add    $0x2,%ebx
      ret = '+';
     3c9:	bf 2b 00 00 00       	mov    $0x2b,%edi
     3ce:	eb b5                	jmp    385 <gettoken+0x4d>
      s++;
     3d0:	83 c3 01             	add    $0x1,%ebx
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3d3:	39 f3                	cmp    %esi,%ebx
     3d5:	73 3a                	jae    411 <gettoken+0xd9>
     3d7:	83 ec 08             	sub    $0x8,%esp
     3da:	0f be 03             	movsbl (%ebx),%eax
     3dd:	50                   	push   %eax
     3de:	68 28 17 00 00       	push   $0x1728
     3e3:	e8 87 06 00 00       	call   a6f <strchr>
     3e8:	83 c4 10             	add    $0x10,%esp
     3eb:	85 c0                	test   %eax,%eax
     3ed:	75 2c                	jne    41b <gettoken+0xe3>
     3ef:	83 ec 08             	sub    $0x8,%esp
     3f2:	0f be 03             	movsbl (%ebx),%eax
     3f5:	50                   	push   %eax
     3f6:	68 20 17 00 00       	push   $0x1720
     3fb:	e8 6f 06 00 00       	call   a6f <strchr>
     400:	83 c4 10             	add    $0x10,%esp
     403:	85 c0                	test   %eax,%eax
     405:	74 c9                	je     3d0 <gettoken+0x98>
    ret = 'a';
     407:	bf 61 00 00 00       	mov    $0x61,%edi
     40c:	e9 74 ff ff ff       	jmp    385 <gettoken+0x4d>
     411:	bf 61 00 00 00       	mov    $0x61,%edi
     416:	e9 6a ff ff ff       	jmp    385 <gettoken+0x4d>
     41b:	bf 61 00 00 00       	mov    $0x61,%edi
     420:	e9 60 ff ff ff       	jmp    385 <gettoken+0x4d>

  while(s < es && strchr(whitespace, *s))
    s++;
     425:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     428:	39 f3                	cmp    %esi,%ebx
     42a:	73 18                	jae    444 <gettoken+0x10c>
     42c:	83 ec 08             	sub    $0x8,%esp
     42f:	0f be 03             	movsbl (%ebx),%eax
     432:	50                   	push   %eax
     433:	68 28 17 00 00       	push   $0x1728
     438:	e8 32 06 00 00       	call   a6f <strchr>
     43d:	83 c4 10             	add    $0x10,%esp
     440:	85 c0                	test   %eax,%eax
     442:	75 e1                	jne    425 <gettoken+0xed>
  *ps = s;
     444:	8b 45 08             	mov    0x8(%ebp),%eax
     447:	89 18                	mov    %ebx,(%eax)
  return ret;
}
     449:	89 f8                	mov    %edi,%eax
     44b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     44e:	5b                   	pop    %ebx
     44f:	5e                   	pop    %esi
     450:	5f                   	pop    %edi
     451:	5d                   	pop    %ebp
     452:	c3                   	ret    

00000453 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     453:	55                   	push   %ebp
     454:	89 e5                	mov    %esp,%ebp
     456:	57                   	push   %edi
     457:	56                   	push   %esi
     458:	53                   	push   %ebx
     459:	83 ec 0c             	sub    $0xc,%esp
     45c:	8b 7d 08             	mov    0x8(%ebp),%edi
     45f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     462:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     464:	eb 03                	jmp    469 <peek+0x16>
    s++;
     466:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     469:	39 f3                	cmp    %esi,%ebx
     46b:	73 18                	jae    485 <peek+0x32>
     46d:	83 ec 08             	sub    $0x8,%esp
     470:	0f be 03             	movsbl (%ebx),%eax
     473:	50                   	push   %eax
     474:	68 28 17 00 00       	push   $0x1728
     479:	e8 f1 05 00 00       	call   a6f <strchr>
     47e:	83 c4 10             	add    $0x10,%esp
     481:	85 c0                	test   %eax,%eax
     483:	75 e1                	jne    466 <peek+0x13>
  *ps = s;
     485:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     487:	0f b6 03             	movzbl (%ebx),%eax
     48a:	84 c0                	test   %al,%al
     48c:	75 0d                	jne    49b <peek+0x48>
     48e:	b8 00 00 00 00       	mov    $0x0,%eax
}
     493:	8d 65 f4             	lea    -0xc(%ebp),%esp
     496:	5b                   	pop    %ebx
     497:	5e                   	pop    %esi
     498:	5f                   	pop    %edi
     499:	5d                   	pop    %ebp
     49a:	c3                   	ret    
  return *s && strchr(toks, *s);
     49b:	83 ec 08             	sub    $0x8,%esp
     49e:	0f be c0             	movsbl %al,%eax
     4a1:	50                   	push   %eax
     4a2:	ff 75 10             	pushl  0x10(%ebp)
     4a5:	e8 c5 05 00 00       	call   a6f <strchr>
     4aa:	83 c4 10             	add    $0x10,%esp
     4ad:	85 c0                	test   %eax,%eax
     4af:	74 07                	je     4b8 <peek+0x65>
     4b1:	b8 01 00 00 00       	mov    $0x1,%eax
     4b6:	eb db                	jmp    493 <peek+0x40>
     4b8:	b8 00 00 00 00       	mov    $0x0,%eax
     4bd:	eb d4                	jmp    493 <peek+0x40>

000004bf <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4bf:	55                   	push   %ebp
     4c0:	89 e5                	mov    %esp,%ebp
     4c2:	57                   	push   %edi
     4c3:	56                   	push   %esi
     4c4:	53                   	push   %ebx
     4c5:	83 ec 1c             	sub    $0x1c,%esp
     4c8:	8b 7d 0c             	mov    0xc(%ebp),%edi
     4cb:	8b 75 10             	mov    0x10(%ebp),%esi
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4ce:	eb 28                	jmp    4f8 <parseredirs+0x39>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
     4d0:	83 ec 0c             	sub    $0xc,%esp
     4d3:	68 90 10 00 00       	push   $0x1090
     4d8:	e8 6e fb ff ff       	call   4b <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4dd:	83 ec 0c             	sub    $0xc,%esp
     4e0:	6a 00                	push   $0x0
     4e2:	6a 00                	push   $0x0
     4e4:	ff 75 e0             	pushl  -0x20(%ebp)
     4e7:	ff 75 e4             	pushl  -0x1c(%ebp)
     4ea:	ff 75 08             	pushl  0x8(%ebp)
     4ed:	e8 62 fd ff ff       	call   254 <redircmd>
     4f2:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     4f5:	83 c4 20             	add    $0x20,%esp
  while(peek(ps, es, "<>")){
     4f8:	83 ec 04             	sub    $0x4,%esp
     4fb:	68 ad 10 00 00       	push   $0x10ad
     500:	56                   	push   %esi
     501:	57                   	push   %edi
     502:	e8 4c ff ff ff       	call   453 <peek>
     507:	83 c4 10             	add    $0x10,%esp
     50a:	85 c0                	test   %eax,%eax
     50c:	74 76                	je     584 <parseredirs+0xc5>
    tok = gettoken(ps, es, 0, 0);
     50e:	6a 00                	push   $0x0
     510:	6a 00                	push   $0x0
     512:	56                   	push   %esi
     513:	57                   	push   %edi
     514:	e8 1f fe ff ff       	call   338 <gettoken>
     519:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
     51b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     51e:	50                   	push   %eax
     51f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     522:	50                   	push   %eax
     523:	56                   	push   %esi
     524:	57                   	push   %edi
     525:	e8 0e fe ff ff       	call   338 <gettoken>
     52a:	83 c4 20             	add    $0x20,%esp
     52d:	83 f8 61             	cmp    $0x61,%eax
     530:	75 9e                	jne    4d0 <parseredirs+0x11>
    switch(tok){
     532:	83 fb 3c             	cmp    $0x3c,%ebx
     535:	74 a6                	je     4dd <parseredirs+0x1e>
     537:	83 fb 3e             	cmp    $0x3e,%ebx
     53a:	74 25                	je     561 <parseredirs+0xa2>
     53c:	83 fb 2b             	cmp    $0x2b,%ebx
     53f:	75 b7                	jne    4f8 <parseredirs+0x39>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     541:	83 ec 0c             	sub    $0xc,%esp
     544:	6a 01                	push   $0x1
     546:	68 01 02 00 00       	push   $0x201
     54b:	ff 75 e0             	pushl  -0x20(%ebp)
     54e:	ff 75 e4             	pushl  -0x1c(%ebp)
     551:	ff 75 08             	pushl  0x8(%ebp)
     554:	e8 fb fc ff ff       	call   254 <redircmd>
     559:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     55c:	83 c4 20             	add    $0x20,%esp
     55f:	eb 97                	jmp    4f8 <parseredirs+0x39>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     561:	83 ec 0c             	sub    $0xc,%esp
     564:	6a 01                	push   $0x1
     566:	68 01 02 00 00       	push   $0x201
     56b:	ff 75 e0             	pushl  -0x20(%ebp)
     56e:	ff 75 e4             	pushl  -0x1c(%ebp)
     571:	ff 75 08             	pushl  0x8(%ebp)
     574:	e8 db fc ff ff       	call   254 <redircmd>
     579:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     57c:	83 c4 20             	add    $0x20,%esp
     57f:	e9 74 ff ff ff       	jmp    4f8 <parseredirs+0x39>
    }
  }
  return cmd;
}
     584:	8b 45 08             	mov    0x8(%ebp),%eax
     587:	8d 65 f4             	lea    -0xc(%ebp),%esp
     58a:	5b                   	pop    %ebx
     58b:	5e                   	pop    %esi
     58c:	5f                   	pop    %edi
     58d:	5d                   	pop    %ebp
     58e:	c3                   	ret    

0000058f <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     58f:	55                   	push   %ebp
     590:	89 e5                	mov    %esp,%ebp
     592:	57                   	push   %edi
     593:	56                   	push   %esi
     594:	53                   	push   %ebx
     595:	83 ec 30             	sub    $0x30,%esp
     598:	8b 75 08             	mov    0x8(%ebp),%esi
     59b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     59e:	68 b0 10 00 00       	push   $0x10b0
     5a3:	57                   	push   %edi
     5a4:	56                   	push   %esi
     5a5:	e8 a9 fe ff ff       	call   453 <peek>
     5aa:	83 c4 10             	add    $0x10,%esp
     5ad:	85 c0                	test   %eax,%eax
     5af:	75 7a                	jne    62b <parseexec+0x9c>
     5b1:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     5b3:	e8 72 fc ff ff       	call   22a <execcmd>
     5b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5bb:	83 ec 04             	sub    $0x4,%esp
     5be:	57                   	push   %edi
     5bf:	56                   	push   %esi
     5c0:	50                   	push   %eax
     5c1:	e8 f9 fe ff ff       	call   4bf <parseredirs>
     5c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     5c9:	83 c4 10             	add    $0x10,%esp
     5cc:	83 ec 04             	sub    $0x4,%esp
     5cf:	68 c7 10 00 00       	push   $0x10c7
     5d4:	57                   	push   %edi
     5d5:	56                   	push   %esi
     5d6:	e8 78 fe ff ff       	call   453 <peek>
     5db:	83 c4 10             	add    $0x10,%esp
     5de:	85 c0                	test   %eax,%eax
     5e0:	75 7e                	jne    660 <parseexec+0xd1>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     5e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
     5e5:	50                   	push   %eax
     5e6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     5e9:	50                   	push   %eax
     5ea:	57                   	push   %edi
     5eb:	56                   	push   %esi
     5ec:	e8 47 fd ff ff       	call   338 <gettoken>
     5f1:	83 c4 10             	add    $0x10,%esp
     5f4:	85 c0                	test   %eax,%eax
     5f6:	74 68                	je     660 <parseexec+0xd1>
      break;
    if(tok != 'a')
     5f8:	83 f8 61             	cmp    $0x61,%eax
     5fb:	75 49                	jne    646 <parseexec+0xb7>
      panic("syntax");
    cmd->argv[argc] = q;
     5fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     600:	8b 55 d0             	mov    -0x30(%ebp),%edx
     603:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     607:	8b 45 e0             	mov    -0x20(%ebp),%eax
     60a:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     60e:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     611:	83 fb 09             	cmp    $0x9,%ebx
     614:	7f 3d                	jg     653 <parseexec+0xc4>
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     616:	83 ec 04             	sub    $0x4,%esp
     619:	57                   	push   %edi
     61a:	56                   	push   %esi
     61b:	ff 75 d4             	pushl  -0x2c(%ebp)
     61e:	e8 9c fe ff ff       	call   4bf <parseredirs>
     623:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     626:	83 c4 10             	add    $0x10,%esp
     629:	eb a1                	jmp    5cc <parseexec+0x3d>
    return parseblock(ps, es);
     62b:	83 ec 08             	sub    $0x8,%esp
     62e:	57                   	push   %edi
     62f:	56                   	push   %esi
     630:	e8 2f 01 00 00       	call   764 <parseblock>
     635:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     638:	83 c4 10             	add    $0x10,%esp
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     63b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     63e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     641:	5b                   	pop    %ebx
     642:	5e                   	pop    %esi
     643:	5f                   	pop    %edi
     644:	5d                   	pop    %ebp
     645:	c3                   	ret    
      panic("syntax");
     646:	83 ec 0c             	sub    $0xc,%esp
     649:	68 b2 10 00 00       	push   $0x10b2
     64e:	e8 f8 f9 ff ff       	call   4b <panic>
      panic("too many args");
     653:	83 ec 0c             	sub    $0xc,%esp
     656:	68 b9 10 00 00       	push   $0x10b9
     65b:	e8 eb f9 ff ff       	call   4b <panic>
  cmd->argv[argc] = 0;
     660:	8b 45 d0             	mov    -0x30(%ebp),%eax
     663:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
     66a:	00 
  cmd->eargv[argc] = 0;
     66b:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
     672:	00 
  return ret;
     673:	eb c6                	jmp    63b <parseexec+0xac>

00000675 <parsepipe>:
{
     675:	55                   	push   %ebp
     676:	89 e5                	mov    %esp,%ebp
     678:	57                   	push   %edi
     679:	56                   	push   %esi
     67a:	53                   	push   %ebx
     67b:	83 ec 14             	sub    $0x14,%esp
     67e:	8b 5d 08             	mov    0x8(%ebp),%ebx
     681:	8b 75 0c             	mov    0xc(%ebp),%esi
  cmd = parseexec(ps, es);
     684:	56                   	push   %esi
     685:	53                   	push   %ebx
     686:	e8 04 ff ff ff       	call   58f <parseexec>
     68b:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
     68d:	83 c4 0c             	add    $0xc,%esp
     690:	68 cc 10 00 00       	push   $0x10cc
     695:	56                   	push   %esi
     696:	53                   	push   %ebx
     697:	e8 b7 fd ff ff       	call   453 <peek>
     69c:	83 c4 10             	add    $0x10,%esp
     69f:	85 c0                	test   %eax,%eax
     6a1:	75 0a                	jne    6ad <parsepipe+0x38>
}
     6a3:	89 f8                	mov    %edi,%eax
     6a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6a8:	5b                   	pop    %ebx
     6a9:	5e                   	pop    %esi
     6aa:	5f                   	pop    %edi
     6ab:	5d                   	pop    %ebp
     6ac:	c3                   	ret    
    gettoken(ps, es, 0, 0);
     6ad:	6a 00                	push   $0x0
     6af:	6a 00                	push   $0x0
     6b1:	56                   	push   %esi
     6b2:	53                   	push   %ebx
     6b3:	e8 80 fc ff ff       	call   338 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6b8:	83 c4 08             	add    $0x8,%esp
     6bb:	56                   	push   %esi
     6bc:	53                   	push   %ebx
     6bd:	e8 b3 ff ff ff       	call   675 <parsepipe>
     6c2:	83 c4 08             	add    $0x8,%esp
     6c5:	50                   	push   %eax
     6c6:	57                   	push   %edi
     6c7:	e8 d0 fb ff ff       	call   29c <pipecmd>
     6cc:	89 c7                	mov    %eax,%edi
     6ce:	83 c4 10             	add    $0x10,%esp
  return cmd;
     6d1:	eb d0                	jmp    6a3 <parsepipe+0x2e>

000006d3 <parseline>:
{
     6d3:	55                   	push   %ebp
     6d4:	89 e5                	mov    %esp,%ebp
     6d6:	57                   	push   %edi
     6d7:	56                   	push   %esi
     6d8:	53                   	push   %ebx
     6d9:	83 ec 14             	sub    $0x14,%esp
     6dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6df:	8b 75 0c             	mov    0xc(%ebp),%esi
  cmd = parsepipe(ps, es);
     6e2:	56                   	push   %esi
     6e3:	53                   	push   %ebx
     6e4:	e8 8c ff ff ff       	call   675 <parsepipe>
     6e9:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     6eb:	83 c4 10             	add    $0x10,%esp
     6ee:	eb 18                	jmp    708 <parseline+0x35>
    gettoken(ps, es, 0, 0);
     6f0:	6a 00                	push   $0x0
     6f2:	6a 00                	push   $0x0
     6f4:	56                   	push   %esi
     6f5:	53                   	push   %ebx
     6f6:	e8 3d fc ff ff       	call   338 <gettoken>
    cmd = backcmd(cmd);
     6fb:	89 3c 24             	mov    %edi,(%esp)
     6fe:	e8 05 fc ff ff       	call   308 <backcmd>
     703:	89 c7                	mov    %eax,%edi
     705:	83 c4 10             	add    $0x10,%esp
  while(peek(ps, es, "&")){
     708:	83 ec 04             	sub    $0x4,%esp
     70b:	68 ce 10 00 00       	push   $0x10ce
     710:	56                   	push   %esi
     711:	53                   	push   %ebx
     712:	e8 3c fd ff ff       	call   453 <peek>
     717:	83 c4 10             	add    $0x10,%esp
     71a:	85 c0                	test   %eax,%eax
     71c:	75 d2                	jne    6f0 <parseline+0x1d>
  if(peek(ps, es, ";")){
     71e:	83 ec 04             	sub    $0x4,%esp
     721:	68 ca 10 00 00       	push   $0x10ca
     726:	56                   	push   %esi
     727:	53                   	push   %ebx
     728:	e8 26 fd ff ff       	call   453 <peek>
     72d:	83 c4 10             	add    $0x10,%esp
     730:	85 c0                	test   %eax,%eax
     732:	75 0a                	jne    73e <parseline+0x6b>
}
     734:	89 f8                	mov    %edi,%eax
     736:	8d 65 f4             	lea    -0xc(%ebp),%esp
     739:	5b                   	pop    %ebx
     73a:	5e                   	pop    %esi
     73b:	5f                   	pop    %edi
     73c:	5d                   	pop    %ebp
     73d:	c3                   	ret    
    gettoken(ps, es, 0, 0);
     73e:	6a 00                	push   $0x0
     740:	6a 00                	push   $0x0
     742:	56                   	push   %esi
     743:	53                   	push   %ebx
     744:	e8 ef fb ff ff       	call   338 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     749:	83 c4 08             	add    $0x8,%esp
     74c:	56                   	push   %esi
     74d:	53                   	push   %ebx
     74e:	e8 80 ff ff ff       	call   6d3 <parseline>
     753:	83 c4 08             	add    $0x8,%esp
     756:	50                   	push   %eax
     757:	57                   	push   %edi
     758:	e8 75 fb ff ff       	call   2d2 <listcmd>
     75d:	89 c7                	mov    %eax,%edi
     75f:	83 c4 10             	add    $0x10,%esp
  return cmd;
     762:	eb d0                	jmp    734 <parseline+0x61>

00000764 <parseblock>:
{
     764:	55                   	push   %ebp
     765:	89 e5                	mov    %esp,%ebp
     767:	57                   	push   %edi
     768:	56                   	push   %esi
     769:	53                   	push   %ebx
     76a:	83 ec 10             	sub    $0x10,%esp
     76d:	8b 5d 08             	mov    0x8(%ebp),%ebx
     770:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     773:	68 b0 10 00 00       	push   $0x10b0
     778:	56                   	push   %esi
     779:	53                   	push   %ebx
     77a:	e8 d4 fc ff ff       	call   453 <peek>
     77f:	83 c4 10             	add    $0x10,%esp
     782:	85 c0                	test   %eax,%eax
     784:	74 4b                	je     7d1 <parseblock+0x6d>
  gettoken(ps, es, 0, 0);
     786:	6a 00                	push   $0x0
     788:	6a 00                	push   $0x0
     78a:	56                   	push   %esi
     78b:	53                   	push   %ebx
     78c:	e8 a7 fb ff ff       	call   338 <gettoken>
  cmd = parseline(ps, es);
     791:	83 c4 08             	add    $0x8,%esp
     794:	56                   	push   %esi
     795:	53                   	push   %ebx
     796:	e8 38 ff ff ff       	call   6d3 <parseline>
     79b:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     79d:	83 c4 0c             	add    $0xc,%esp
     7a0:	68 ec 10 00 00       	push   $0x10ec
     7a5:	56                   	push   %esi
     7a6:	53                   	push   %ebx
     7a7:	e8 a7 fc ff ff       	call   453 <peek>
     7ac:	83 c4 10             	add    $0x10,%esp
     7af:	85 c0                	test   %eax,%eax
     7b1:	74 2b                	je     7de <parseblock+0x7a>
  gettoken(ps, es, 0, 0);
     7b3:	6a 00                	push   $0x0
     7b5:	6a 00                	push   $0x0
     7b7:	56                   	push   %esi
     7b8:	53                   	push   %ebx
     7b9:	e8 7a fb ff ff       	call   338 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7be:	83 c4 0c             	add    $0xc,%esp
     7c1:	56                   	push   %esi
     7c2:	53                   	push   %ebx
     7c3:	57                   	push   %edi
     7c4:	e8 f6 fc ff ff       	call   4bf <parseredirs>
}
     7c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7cc:	5b                   	pop    %ebx
     7cd:	5e                   	pop    %esi
     7ce:	5f                   	pop    %edi
     7cf:	5d                   	pop    %ebp
     7d0:	c3                   	ret    
    panic("parseblock");
     7d1:	83 ec 0c             	sub    $0xc,%esp
     7d4:	68 d0 10 00 00       	push   $0x10d0
     7d9:	e8 6d f8 ff ff       	call   4b <panic>
    panic("syntax - missing )");
     7de:	83 ec 0c             	sub    $0xc,%esp
     7e1:	68 db 10 00 00       	push   $0x10db
     7e6:	e8 60 f8 ff ff       	call   4b <panic>

000007eb <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7eb:	55                   	push   %ebp
     7ec:	89 e5                	mov    %esp,%ebp
     7ee:	53                   	push   %ebx
     7ef:	83 ec 04             	sub    $0x4,%esp
     7f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7f5:	85 db                	test   %ebx,%ebx
     7f7:	74 1f                	je     818 <nulterminate+0x2d>
    return 0;

  switch(cmd->type){
     7f9:	8b 03                	mov    (%ebx),%eax
     7fb:	83 f8 05             	cmp    $0x5,%eax
     7fe:	77 18                	ja     818 <nulterminate+0x2d>
     800:	ff 24 85 30 11 00 00 	jmp    *0x1130(,%eax,4)
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      *ecmd->eargv[i] = 0;
     807:	8b 54 83 2c          	mov    0x2c(%ebx,%eax,4),%edx
     80b:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     80e:	83 c0 01             	add    $0x1,%eax
     811:	83 7c 83 04 00       	cmpl   $0x0,0x4(%ebx,%eax,4)
     816:	75 ef                	jne    807 <nulterminate+0x1c>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     818:	89 d8                	mov    %ebx,%eax
     81a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     81d:	c9                   	leave  
     81e:	c3                   	ret    
    for(i=0; ecmd->argv[i]; i++)
     81f:	b8 00 00 00 00       	mov    $0x0,%eax
     824:	eb eb                	jmp    811 <nulterminate+0x26>
    nulterminate(rcmd->cmd);
     826:	83 ec 0c             	sub    $0xc,%esp
     829:	ff 73 04             	pushl  0x4(%ebx)
     82c:	e8 ba ff ff ff       	call   7eb <nulterminate>
    *rcmd->efile = 0;
     831:	8b 43 0c             	mov    0xc(%ebx),%eax
     834:	c6 00 00             	movb   $0x0,(%eax)
    break;
     837:	83 c4 10             	add    $0x10,%esp
     83a:	eb dc                	jmp    818 <nulterminate+0x2d>
    nulterminate(pcmd->left);
     83c:	83 ec 0c             	sub    $0xc,%esp
     83f:	ff 73 04             	pushl  0x4(%ebx)
     842:	e8 a4 ff ff ff       	call   7eb <nulterminate>
    nulterminate(pcmd->right);
     847:	83 c4 04             	add    $0x4,%esp
     84a:	ff 73 08             	pushl  0x8(%ebx)
     84d:	e8 99 ff ff ff       	call   7eb <nulterminate>
    break;
     852:	83 c4 10             	add    $0x10,%esp
     855:	eb c1                	jmp    818 <nulterminate+0x2d>
    nulterminate(lcmd->left);
     857:	83 ec 0c             	sub    $0xc,%esp
     85a:	ff 73 04             	pushl  0x4(%ebx)
     85d:	e8 89 ff ff ff       	call   7eb <nulterminate>
    nulterminate(lcmd->right);
     862:	83 c4 04             	add    $0x4,%esp
     865:	ff 73 08             	pushl  0x8(%ebx)
     868:	e8 7e ff ff ff       	call   7eb <nulterminate>
    break;
     86d:	83 c4 10             	add    $0x10,%esp
     870:	eb a6                	jmp    818 <nulterminate+0x2d>
    nulterminate(bcmd->cmd);
     872:	83 ec 0c             	sub    $0xc,%esp
     875:	ff 73 04             	pushl  0x4(%ebx)
     878:	e8 6e ff ff ff       	call   7eb <nulterminate>
    break;
     87d:	83 c4 10             	add    $0x10,%esp
     880:	eb 96                	jmp    818 <nulterminate+0x2d>

00000882 <parsecmd>:
{
     882:	55                   	push   %ebp
     883:	89 e5                	mov    %esp,%ebp
     885:	56                   	push   %esi
     886:	53                   	push   %ebx
  es = s + strlen(s);
     887:	8b 5d 08             	mov    0x8(%ebp),%ebx
     88a:	83 ec 0c             	sub    $0xc,%esp
     88d:	53                   	push   %ebx
     88e:	e8 ab 01 00 00       	call   a3e <strlen>
     893:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     895:	83 c4 08             	add    $0x8,%esp
     898:	53                   	push   %ebx
     899:	8d 45 08             	lea    0x8(%ebp),%eax
     89c:	50                   	push   %eax
     89d:	e8 31 fe ff ff       	call   6d3 <parseline>
     8a2:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     8a4:	83 c4 0c             	add    $0xc,%esp
     8a7:	68 7a 10 00 00       	push   $0x107a
     8ac:	53                   	push   %ebx
     8ad:	8d 45 08             	lea    0x8(%ebp),%eax
     8b0:	50                   	push   %eax
     8b1:	e8 9d fb ff ff       	call   453 <peek>
  if(s != es){
     8b6:	8b 45 08             	mov    0x8(%ebp),%eax
     8b9:	83 c4 10             	add    $0x10,%esp
     8bc:	39 d8                	cmp    %ebx,%eax
     8be:	75 12                	jne    8d2 <parsecmd+0x50>
  nulterminate(cmd);
     8c0:	83 ec 0c             	sub    $0xc,%esp
     8c3:	56                   	push   %esi
     8c4:	e8 22 ff ff ff       	call   7eb <nulterminate>
}
     8c9:	89 f0                	mov    %esi,%eax
     8cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
     8ce:	5b                   	pop    %ebx
     8cf:	5e                   	pop    %esi
     8d0:	5d                   	pop    %ebp
     8d1:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     8d2:	83 ec 04             	sub    $0x4,%esp
     8d5:	50                   	push   %eax
     8d6:	68 ee 10 00 00       	push   $0x10ee
     8db:	6a 02                	push   $0x2
     8dd:	e8 c2 04 00 00       	call   da4 <printf>
    panic("syntax");
     8e2:	c7 04 24 b2 10 00 00 	movl   $0x10b2,(%esp)
     8e9:	e8 5d f7 ff ff       	call   4b <panic>

000008ee <main>:
{
     8ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     8f2:	83 e4 f0             	and    $0xfffffff0,%esp
     8f5:	ff 71 fc             	pushl  -0x4(%ecx)
     8f8:	55                   	push   %ebp
     8f9:	89 e5                	mov    %esp,%ebp
     8fb:	51                   	push   %ecx
     8fc:	83 ec 04             	sub    $0x4,%esp
  while((fd = open("console", O_RDWR)) >= 0){
     8ff:	83 ec 08             	sub    $0x8,%esp
     902:	6a 02                	push   $0x2
     904:	68 fd 10 00 00       	push   $0x10fd
     909:	e8 8c 03 00 00       	call   c9a <open>
     90e:	83 c4 10             	add    $0x10,%esp
     911:	85 c0                	test   %eax,%eax
     913:	78 73                	js     988 <main+0x9a>
    if(fd >= 3){
     915:	83 f8 02             	cmp    $0x2,%eax
     918:	7e e5                	jle    8ff <main+0x11>
      close(fd);
     91a:	83 ec 0c             	sub    $0xc,%esp
     91d:	50                   	push   %eax
     91e:	e8 5f 03 00 00       	call   c82 <close>
      break;
     923:	83 c4 10             	add    $0x10,%esp
     926:	eb 60                	jmp    988 <main+0x9a>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     928:	80 3d 41 17 00 00 64 	cmpb   $0x64,0x1741
     92f:	75 7c                	jne    9ad <main+0xbf>
     931:	80 3d 42 17 00 00 20 	cmpb   $0x20,0x1742
     938:	75 73                	jne    9ad <main+0xbf>
      buf[strlen(buf)-1] = 0;  // chop \n
     93a:	83 ec 0c             	sub    $0xc,%esp
     93d:	68 40 17 00 00       	push   $0x1740
     942:	e8 f7 00 00 00       	call   a3e <strlen>
     947:	c6 80 3f 17 00 00 00 	movb   $0x0,0x173f(%eax)
      if(chdir(buf+3) < 0)
     94e:	c7 04 24 43 17 00 00 	movl   $0x1743,(%esp)
     955:	e8 70 03 00 00       	call   cca <chdir>
     95a:	83 c4 10             	add    $0x10,%esp
     95d:	85 c0                	test   %eax,%eax
     95f:	79 27                	jns    988 <main+0x9a>
        printf(2, "cannot cd %s\n", buf+3);
     961:	83 ec 04             	sub    $0x4,%esp
     964:	68 43 17 00 00       	push   $0x1743
     969:	68 05 11 00 00       	push   $0x1105
     96e:	6a 02                	push   $0x2
     970:	e8 2f 04 00 00       	call   da4 <printf>
     975:	83 c4 10             	add    $0x10,%esp
      continue;
     978:	eb 0e                	jmp    988 <main+0x9a>
    if(fork1() == 0)
     97a:	e8 e6 f6 ff ff       	call   65 <fork1>
     97f:	85 c0                	test   %eax,%eax
     981:	74 5d                	je     9e0 <main+0xf2>
    wait();
     983:	e8 da 02 00 00       	call   c62 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     988:	83 ec 08             	sub    $0x8,%esp
     98b:	6a 64                	push   $0x64
     98d:	68 40 17 00 00       	push   $0x1740
     992:	e8 69 f6 ff ff       	call   0 <getcmd>
     997:	83 c4 10             	add    $0x10,%esp
     99a:	85 c0                	test   %eax,%eax
     99c:	78 57                	js     9f5 <main+0x107>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     99e:	0f b6 05 40 17 00 00 	movzbl 0x1740,%eax
     9a5:	3c 63                	cmp    $0x63,%al
     9a7:	0f 84 7b ff ff ff    	je     928 <main+0x3a>
    if ((buf[0] != '\n') && (strncmp(buf, "exit", strlen(buf)-1) == 0)) { // ignore '\n'
     9ad:	3c 0a                	cmp    $0xa,%al
     9af:	74 c9                	je     97a <main+0x8c>
     9b1:	83 ec 0c             	sub    $0xc,%esp
     9b4:	68 40 17 00 00       	push   $0x1740
     9b9:	e8 80 00 00 00       	call   a3e <strlen>
     9be:	83 c4 0c             	add    $0xc,%esp
     9c1:	83 e8 01             	sub    $0x1,%eax
     9c4:	50                   	push   %eax
     9c5:	68 13 11 00 00       	push   $0x1113
     9ca:	68 40 17 00 00       	push   $0x1740
     9cf:	e8 17 02 00 00       	call   beb <strncmp>
     9d4:	83 c4 10             	add    $0x10,%esp
     9d7:	85 c0                	test   %eax,%eax
     9d9:	75 9f                	jne    97a <main+0x8c>
      exit();
     9db:	e8 7a 02 00 00       	call   c5a <exit>
      runcmd(parsecmd(buf));
     9e0:	83 ec 0c             	sub    $0xc,%esp
     9e3:	68 40 17 00 00       	push   $0x1740
     9e8:	e8 95 fe ff ff       	call   882 <parsecmd>
     9ed:	89 04 24             	mov    %eax,(%esp)
     9f0:	e8 8f f6 ff ff       	call   84 <runcmd>
  exit();
     9f5:	e8 60 02 00 00       	call   c5a <exit>

000009fa <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     9fa:	55                   	push   %ebp
     9fb:	89 e5                	mov    %esp,%ebp
     9fd:	53                   	push   %ebx
     9fe:	8b 45 08             	mov    0x8(%ebp),%eax
     a01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     a04:	89 c2                	mov    %eax,%edx
     a06:	0f b6 19             	movzbl (%ecx),%ebx
     a09:	88 1a                	mov    %bl,(%edx)
     a0b:	8d 52 01             	lea    0x1(%edx),%edx
     a0e:	8d 49 01             	lea    0x1(%ecx),%ecx
     a11:	84 db                	test   %bl,%bl
     a13:	75 f1                	jne    a06 <strcpy+0xc>
    ;
  return os;
}
     a15:	5b                   	pop    %ebx
     a16:	5d                   	pop    %ebp
     a17:	c3                   	ret    

00000a18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     a18:	55                   	push   %ebp
     a19:	89 e5                	mov    %esp,%ebp
     a1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
     a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     a21:	eb 06                	jmp    a29 <strcmp+0x11>
    p++, q++;
     a23:	83 c1 01             	add    $0x1,%ecx
     a26:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     a29:	0f b6 01             	movzbl (%ecx),%eax
     a2c:	84 c0                	test   %al,%al
     a2e:	74 04                	je     a34 <strcmp+0x1c>
     a30:	3a 02                	cmp    (%edx),%al
     a32:	74 ef                	je     a23 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
     a34:	0f b6 c0             	movzbl %al,%eax
     a37:	0f b6 12             	movzbl (%edx),%edx
     a3a:	29 d0                	sub    %edx,%eax
}
     a3c:	5d                   	pop    %ebp
     a3d:	c3                   	ret    

00000a3e <strlen>:

uint
strlen(char *s)
{
     a3e:	55                   	push   %ebp
     a3f:	89 e5                	mov    %esp,%ebp
     a41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     a44:	ba 00 00 00 00       	mov    $0x0,%edx
     a49:	eb 03                	jmp    a4e <strlen+0x10>
     a4b:	83 c2 01             	add    $0x1,%edx
     a4e:	89 d0                	mov    %edx,%eax
     a50:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     a54:	75 f5                	jne    a4b <strlen+0xd>
    ;
  return n;
}
     a56:	5d                   	pop    %ebp
     a57:	c3                   	ret    

00000a58 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a58:	55                   	push   %ebp
     a59:	89 e5                	mov    %esp,%ebp
     a5b:	57                   	push   %edi
     a5c:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     a5f:	89 d7                	mov    %edx,%edi
     a61:	8b 4d 10             	mov    0x10(%ebp),%ecx
     a64:	8b 45 0c             	mov    0xc(%ebp),%eax
     a67:	fc                   	cld    
     a68:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     a6a:	89 d0                	mov    %edx,%eax
     a6c:	5f                   	pop    %edi
     a6d:	5d                   	pop    %ebp
     a6e:	c3                   	ret    

00000a6f <strchr>:

char*
strchr(const char *s, char c)
{
     a6f:	55                   	push   %ebp
     a70:	89 e5                	mov    %esp,%ebp
     a72:	8b 45 08             	mov    0x8(%ebp),%eax
     a75:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     a79:	0f b6 10             	movzbl (%eax),%edx
     a7c:	84 d2                	test   %dl,%dl
     a7e:	74 09                	je     a89 <strchr+0x1a>
    if(*s == c)
     a80:	38 ca                	cmp    %cl,%dl
     a82:	74 0a                	je     a8e <strchr+0x1f>
  for(; *s; s++)
     a84:	83 c0 01             	add    $0x1,%eax
     a87:	eb f0                	jmp    a79 <strchr+0xa>
      return (char*)s;
  return 0;
     a89:	b8 00 00 00 00       	mov    $0x0,%eax
}
     a8e:	5d                   	pop    %ebp
     a8f:	c3                   	ret    

00000a90 <gets>:

char*
gets(char *buf, int max)
{
     a90:	55                   	push   %ebp
     a91:	89 e5                	mov    %esp,%ebp
     a93:	57                   	push   %edi
     a94:	56                   	push   %esi
     a95:	53                   	push   %ebx
     a96:	83 ec 1c             	sub    $0x1c,%esp
     a99:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a9c:	bb 00 00 00 00       	mov    $0x0,%ebx
     aa1:	8d 73 01             	lea    0x1(%ebx),%esi
     aa4:	3b 75 0c             	cmp    0xc(%ebp),%esi
     aa7:	7d 2e                	jge    ad7 <gets+0x47>
    cc = read(0, &c, 1);
     aa9:	83 ec 04             	sub    $0x4,%esp
     aac:	6a 01                	push   $0x1
     aae:	8d 45 e7             	lea    -0x19(%ebp),%eax
     ab1:	50                   	push   %eax
     ab2:	6a 00                	push   $0x0
     ab4:	e8 b9 01 00 00       	call   c72 <read>
    if(cc < 1)
     ab9:	83 c4 10             	add    $0x10,%esp
     abc:	85 c0                	test   %eax,%eax
     abe:	7e 17                	jle    ad7 <gets+0x47>
      break;
    buf[i++] = c;
     ac0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     ac4:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
     ac7:	3c 0a                	cmp    $0xa,%al
     ac9:	0f 94 c2             	sete   %dl
     acc:	3c 0d                	cmp    $0xd,%al
     ace:	0f 94 c0             	sete   %al
    buf[i++] = c;
     ad1:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
     ad3:	08 c2                	or     %al,%dl
     ad5:	74 ca                	je     aa1 <gets+0x11>
      break;
  }
  buf[i] = '\0';
     ad7:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
     adb:	89 f8                	mov    %edi,%eax
     add:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ae0:	5b                   	pop    %ebx
     ae1:	5e                   	pop    %esi
     ae2:	5f                   	pop    %edi
     ae3:	5d                   	pop    %ebp
     ae4:	c3                   	ret    

00000ae5 <stat>:

int
stat(char *n, struct stat *st)
{
     ae5:	55                   	push   %ebp
     ae6:	89 e5                	mov    %esp,%ebp
     ae8:	56                   	push   %esi
     ae9:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     aea:	83 ec 08             	sub    $0x8,%esp
     aed:	6a 00                	push   $0x0
     aef:	ff 75 08             	pushl  0x8(%ebp)
     af2:	e8 a3 01 00 00       	call   c9a <open>
  if(fd < 0)
     af7:	83 c4 10             	add    $0x10,%esp
     afa:	85 c0                	test   %eax,%eax
     afc:	78 24                	js     b22 <stat+0x3d>
     afe:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
     b00:	83 ec 08             	sub    $0x8,%esp
     b03:	ff 75 0c             	pushl  0xc(%ebp)
     b06:	50                   	push   %eax
     b07:	e8 a6 01 00 00       	call   cb2 <fstat>
     b0c:	89 c6                	mov    %eax,%esi
  close(fd);
     b0e:	89 1c 24             	mov    %ebx,(%esp)
     b11:	e8 6c 01 00 00       	call   c82 <close>
  return r;
     b16:	83 c4 10             	add    $0x10,%esp
}
     b19:	89 f0                	mov    %esi,%eax
     b1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b1e:	5b                   	pop    %ebx
     b1f:	5e                   	pop    %esi
     b20:	5d                   	pop    %ebp
     b21:	c3                   	ret    
    return -1;
     b22:	be ff ff ff ff       	mov    $0xffffffff,%esi
     b27:	eb f0                	jmp    b19 <stat+0x34>

00000b29 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
     b29:	55                   	push   %ebp
     b2a:	89 e5                	mov    %esp,%ebp
     b2c:	57                   	push   %edi
     b2d:	56                   	push   %esi
     b2e:	53                   	push   %ebx
     b2f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
     b32:	eb 03                	jmp    b37 <atoi+0xe>
     b34:	83 c2 01             	add    $0x1,%edx
     b37:	0f b6 02             	movzbl (%edx),%eax
     b3a:	3c 20                	cmp    $0x20,%al
     b3c:	74 f6                	je     b34 <atoi+0xb>
  sign = (*s == '-') ? -1 : 1;
     b3e:	3c 2d                	cmp    $0x2d,%al
     b40:	74 1d                	je     b5f <atoi+0x36>
     b42:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
     b47:	3c 2b                	cmp    $0x2b,%al
     b49:	0f 94 c1             	sete   %cl
     b4c:	3c 2d                	cmp    $0x2d,%al
     b4e:	0f 94 c0             	sete   %al
     b51:	08 c1                	or     %al,%cl
     b53:	74 03                	je     b58 <atoi+0x2f>
    s++;
     b55:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
     b58:	b8 00 00 00 00       	mov    $0x0,%eax
     b5d:	eb 17                	jmp    b76 <atoi+0x4d>
     b5f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
     b64:	eb e1                	jmp    b47 <atoi+0x1e>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
     b66:	8d 34 80             	lea    (%eax,%eax,4),%esi
     b69:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
     b6c:	83 c2 01             	add    $0x1,%edx
     b6f:	0f be c9             	movsbl %cl,%ecx
     b72:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
     b76:	0f b6 0a             	movzbl (%edx),%ecx
     b79:	8d 59 d0             	lea    -0x30(%ecx),%ebx
     b7c:	80 fb 09             	cmp    $0x9,%bl
     b7f:	76 e5                	jbe    b66 <atoi+0x3d>
  return sign*n;
     b81:	0f af c7             	imul   %edi,%eax
}
     b84:	5b                   	pop    %ebx
     b85:	5e                   	pop    %esi
     b86:	5f                   	pop    %edi
     b87:	5d                   	pop    %ebp
     b88:	c3                   	ret    

00000b89 <atoo>:

int
atoo(const char *s)
{
     b89:	55                   	push   %ebp
     b8a:	89 e5                	mov    %esp,%ebp
     b8c:	57                   	push   %edi
     b8d:	56                   	push   %esi
     b8e:	53                   	push   %ebx
     b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
     b92:	eb 03                	jmp    b97 <atoo+0xe>
     b94:	83 c2 01             	add    $0x1,%edx
     b97:	0f b6 0a             	movzbl (%edx),%ecx
     b9a:	80 f9 20             	cmp    $0x20,%cl
     b9d:	74 f5                	je     b94 <atoo+0xb>
  sign = (*s == '-') ? -1 : 1;
     b9f:	80 f9 2d             	cmp    $0x2d,%cl
     ba2:	74 23                	je     bc7 <atoo+0x3e>
     ba4:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
     ba9:	80 f9 2b             	cmp    $0x2b,%cl
     bac:	0f 94 c0             	sete   %al
     baf:	89 c6                	mov    %eax,%esi
     bb1:	80 f9 2d             	cmp    $0x2d,%cl
     bb4:	0f 94 c0             	sete   %al
     bb7:	89 f3                	mov    %esi,%ebx
     bb9:	08 c3                	or     %al,%bl
     bbb:	74 03                	je     bc0 <atoo+0x37>
    s++;
     bbd:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
     bc0:	b8 00 00 00 00       	mov    $0x0,%eax
     bc5:	eb 11                	jmp    bd8 <atoo+0x4f>
     bc7:	bf ff ff ff ff       	mov    $0xffffffff,%edi
     bcc:	eb db                	jmp    ba9 <atoo+0x20>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
     bce:	83 c2 01             	add    $0x1,%edx
     bd1:	0f be c9             	movsbl %cl,%ecx
     bd4:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
     bd8:	0f b6 0a             	movzbl (%edx),%ecx
     bdb:	8d 59 d0             	lea    -0x30(%ecx),%ebx
     bde:	80 fb 07             	cmp    $0x7,%bl
     be1:	76 eb                	jbe    bce <atoo+0x45>
  return sign*n;
     be3:	0f af c7             	imul   %edi,%eax
}
     be6:	5b                   	pop    %ebx
     be7:	5e                   	pop    %esi
     be8:	5f                   	pop    %edi
     be9:	5d                   	pop    %ebp
     bea:	c3                   	ret    

00000beb <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     beb:	55                   	push   %ebp
     bec:	89 e5                	mov    %esp,%ebp
     bee:	53                   	push   %ebx
     bef:	8b 55 08             	mov    0x8(%ebp),%edx
     bf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
     bf5:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
     bf8:	eb 09                	jmp    c03 <strncmp+0x18>
      n--, p++, q++;
     bfa:	83 e8 01             	sub    $0x1,%eax
     bfd:	83 c2 01             	add    $0x1,%edx
     c00:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
     c03:	85 c0                	test   %eax,%eax
     c05:	74 0b                	je     c12 <strncmp+0x27>
     c07:	0f b6 1a             	movzbl (%edx),%ebx
     c0a:	84 db                	test   %bl,%bl
     c0c:	74 04                	je     c12 <strncmp+0x27>
     c0e:	3a 19                	cmp    (%ecx),%bl
     c10:	74 e8                	je     bfa <strncmp+0xf>
    if(n == 0)
     c12:	85 c0                	test   %eax,%eax
     c14:	74 0b                	je     c21 <strncmp+0x36>
      return 0;
    return (uchar)*p - (uchar)*q;
     c16:	0f b6 02             	movzbl (%edx),%eax
     c19:	0f b6 11             	movzbl (%ecx),%edx
     c1c:	29 d0                	sub    %edx,%eax
}
     c1e:	5b                   	pop    %ebx
     c1f:	5d                   	pop    %ebp
     c20:	c3                   	ret    
      return 0;
     c21:	b8 00 00 00 00       	mov    $0x0,%eax
     c26:	eb f6                	jmp    c1e <strncmp+0x33>

00000c28 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
     c28:	55                   	push   %ebp
     c29:	89 e5                	mov    %esp,%ebp
     c2b:	56                   	push   %esi
     c2c:	53                   	push   %ebx
     c2d:	8b 45 08             	mov    0x8(%ebp),%eax
     c30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     c33:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst, *src;

  dst = vdst;
     c36:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
     c38:	eb 0d                	jmp    c47 <memmove+0x1f>
    *dst++ = *src++;
     c3a:	0f b6 13             	movzbl (%ebx),%edx
     c3d:	88 11                	mov    %dl,(%ecx)
     c3f:	8d 5b 01             	lea    0x1(%ebx),%ebx
     c42:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
     c45:	89 f2                	mov    %esi,%edx
     c47:	8d 72 ff             	lea    -0x1(%edx),%esi
     c4a:	85 d2                	test   %edx,%edx
     c4c:	7f ec                	jg     c3a <memmove+0x12>
  return vdst;
}
     c4e:	5b                   	pop    %ebx
     c4f:	5e                   	pop    %esi
     c50:	5d                   	pop    %ebp
     c51:	c3                   	ret    

00000c52 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     c52:	b8 01 00 00 00       	mov    $0x1,%eax
     c57:	cd 40                	int    $0x40
     c59:	c3                   	ret    

00000c5a <exit>:
SYSCALL(exit)
     c5a:	b8 02 00 00 00       	mov    $0x2,%eax
     c5f:	cd 40                	int    $0x40
     c61:	c3                   	ret    

00000c62 <wait>:
SYSCALL(wait)
     c62:	b8 03 00 00 00       	mov    $0x3,%eax
     c67:	cd 40                	int    $0x40
     c69:	c3                   	ret    

00000c6a <pipe>:
SYSCALL(pipe)
     c6a:	b8 04 00 00 00       	mov    $0x4,%eax
     c6f:	cd 40                	int    $0x40
     c71:	c3                   	ret    

00000c72 <read>:
SYSCALL(read)
     c72:	b8 05 00 00 00       	mov    $0x5,%eax
     c77:	cd 40                	int    $0x40
     c79:	c3                   	ret    

00000c7a <write>:
SYSCALL(write)
     c7a:	b8 10 00 00 00       	mov    $0x10,%eax
     c7f:	cd 40                	int    $0x40
     c81:	c3                   	ret    

00000c82 <close>:
SYSCALL(close)
     c82:	b8 15 00 00 00       	mov    $0x15,%eax
     c87:	cd 40                	int    $0x40
     c89:	c3                   	ret    

00000c8a <kill>:
SYSCALL(kill)
     c8a:	b8 06 00 00 00       	mov    $0x6,%eax
     c8f:	cd 40                	int    $0x40
     c91:	c3                   	ret    

00000c92 <exec>:
SYSCALL(exec)
     c92:	b8 07 00 00 00       	mov    $0x7,%eax
     c97:	cd 40                	int    $0x40
     c99:	c3                   	ret    

00000c9a <open>:
SYSCALL(open)
     c9a:	b8 0f 00 00 00       	mov    $0xf,%eax
     c9f:	cd 40                	int    $0x40
     ca1:	c3                   	ret    

00000ca2 <mknod>:
SYSCALL(mknod)
     ca2:	b8 11 00 00 00       	mov    $0x11,%eax
     ca7:	cd 40                	int    $0x40
     ca9:	c3                   	ret    

00000caa <unlink>:
SYSCALL(unlink)
     caa:	b8 12 00 00 00       	mov    $0x12,%eax
     caf:	cd 40                	int    $0x40
     cb1:	c3                   	ret    

00000cb2 <fstat>:
SYSCALL(fstat)
     cb2:	b8 08 00 00 00       	mov    $0x8,%eax
     cb7:	cd 40                	int    $0x40
     cb9:	c3                   	ret    

00000cba <link>:
SYSCALL(link)
     cba:	b8 13 00 00 00       	mov    $0x13,%eax
     cbf:	cd 40                	int    $0x40
     cc1:	c3                   	ret    

00000cc2 <mkdir>:
SYSCALL(mkdir)
     cc2:	b8 14 00 00 00       	mov    $0x14,%eax
     cc7:	cd 40                	int    $0x40
     cc9:	c3                   	ret    

00000cca <chdir>:
SYSCALL(chdir)
     cca:	b8 09 00 00 00       	mov    $0x9,%eax
     ccf:	cd 40                	int    $0x40
     cd1:	c3                   	ret    

00000cd2 <dup>:
SYSCALL(dup)
     cd2:	b8 0a 00 00 00       	mov    $0xa,%eax
     cd7:	cd 40                	int    $0x40
     cd9:	c3                   	ret    

00000cda <getpid>:
SYSCALL(getpid)
     cda:	b8 0b 00 00 00       	mov    $0xb,%eax
     cdf:	cd 40                	int    $0x40
     ce1:	c3                   	ret    

00000ce2 <sbrk>:
SYSCALL(sbrk)
     ce2:	b8 0c 00 00 00       	mov    $0xc,%eax
     ce7:	cd 40                	int    $0x40
     ce9:	c3                   	ret    

00000cea <sleep>:
SYSCALL(sleep)
     cea:	b8 0d 00 00 00       	mov    $0xd,%eax
     cef:	cd 40                	int    $0x40
     cf1:	c3                   	ret    

00000cf2 <uptime>:
SYSCALL(uptime)
     cf2:	b8 0e 00 00 00       	mov    $0xe,%eax
     cf7:	cd 40                	int    $0x40
     cf9:	c3                   	ret    

00000cfa <halt>:
SYSCALL(halt)
     cfa:	b8 16 00 00 00       	mov    $0x16,%eax
     cff:	cd 40                	int    $0x40
     d01:	c3                   	ret    

00000d02 <date>:
SYSCALL(date)
     d02:	b8 17 00 00 00       	mov    $0x17,%eax
     d07:	cd 40                	int    $0x40
     d09:	c3                   	ret    

00000d0a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     d0a:	55                   	push   %ebp
     d0b:	89 e5                	mov    %esp,%ebp
     d0d:	83 ec 1c             	sub    $0x1c,%esp
     d10:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
     d13:	6a 01                	push   $0x1
     d15:	8d 55 f4             	lea    -0xc(%ebp),%edx
     d18:	52                   	push   %edx
     d19:	50                   	push   %eax
     d1a:	e8 5b ff ff ff       	call   c7a <write>
}
     d1f:	83 c4 10             	add    $0x10,%esp
     d22:	c9                   	leave  
     d23:	c3                   	ret    

00000d24 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     d24:	55                   	push   %ebp
     d25:	89 e5                	mov    %esp,%ebp
     d27:	57                   	push   %edi
     d28:	56                   	push   %esi
     d29:	53                   	push   %ebx
     d2a:	83 ec 2c             	sub    $0x2c,%esp
     d2d:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     d33:	0f 95 c3             	setne  %bl
     d36:	89 d0                	mov    %edx,%eax
     d38:	c1 e8 1f             	shr    $0x1f,%eax
     d3b:	84 c3                	test   %al,%bl
     d3d:	74 10                	je     d4f <printint+0x2b>
    neg = 1;
    x = -xx;
     d3f:	f7 da                	neg    %edx
    neg = 1;
     d41:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     d48:	be 00 00 00 00       	mov    $0x0,%esi
     d4d:	eb 0b                	jmp    d5a <printint+0x36>
  neg = 0;
     d4f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     d56:	eb f0                	jmp    d48 <printint+0x24>
  do{
    buf[i++] = digits[x % base];
     d58:	89 c6                	mov    %eax,%esi
     d5a:	89 d0                	mov    %edx,%eax
     d5c:	ba 00 00 00 00       	mov    $0x0,%edx
     d61:	f7 f1                	div    %ecx
     d63:	89 c3                	mov    %eax,%ebx
     d65:	8d 46 01             	lea    0x1(%esi),%eax
     d68:	0f b6 92 50 11 00 00 	movzbl 0x1150(%edx),%edx
     d6f:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
     d73:	89 da                	mov    %ebx,%edx
     d75:	85 db                	test   %ebx,%ebx
     d77:	75 df                	jne    d58 <printint+0x34>
     d79:	89 c3                	mov    %eax,%ebx
  if(neg)
     d7b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
     d7f:	74 16                	je     d97 <printint+0x73>
    buf[i++] = '-';
     d81:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
     d86:	8d 5e 02             	lea    0x2(%esi),%ebx
     d89:	eb 0c                	jmp    d97 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
     d8b:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
     d90:	89 f8                	mov    %edi,%eax
     d92:	e8 73 ff ff ff       	call   d0a <putc>
  while(--i >= 0)
     d97:	83 eb 01             	sub    $0x1,%ebx
     d9a:	79 ef                	jns    d8b <printint+0x67>
}
     d9c:	83 c4 2c             	add    $0x2c,%esp
     d9f:	5b                   	pop    %ebx
     da0:	5e                   	pop    %esi
     da1:	5f                   	pop    %edi
     da2:	5d                   	pop    %ebp
     da3:	c3                   	ret    

00000da4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     da4:	55                   	push   %ebp
     da5:	89 e5                	mov    %esp,%ebp
     da7:	57                   	push   %edi
     da8:	56                   	push   %esi
     da9:	53                   	push   %ebx
     daa:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
     dad:	8d 45 10             	lea    0x10(%ebp),%eax
     db0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
     db3:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
     db8:	bb 00 00 00 00       	mov    $0x0,%ebx
     dbd:	eb 14                	jmp    dd3 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
     dbf:	89 fa                	mov    %edi,%edx
     dc1:	8b 45 08             	mov    0x8(%ebp),%eax
     dc4:	e8 41 ff ff ff       	call   d0a <putc>
     dc9:	eb 05                	jmp    dd0 <printf+0x2c>
      }
    } else if(state == '%'){
     dcb:	83 fe 25             	cmp    $0x25,%esi
     dce:	74 25                	je     df5 <printf+0x51>
  for(i = 0; fmt[i]; i++){
     dd0:	83 c3 01             	add    $0x1,%ebx
     dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
     dd6:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
     dda:	84 c0                	test   %al,%al
     ddc:	0f 84 23 01 00 00    	je     f05 <printf+0x161>
    c = fmt[i] & 0xff;
     de2:	0f be f8             	movsbl %al,%edi
     de5:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
     de8:	85 f6                	test   %esi,%esi
     dea:	75 df                	jne    dcb <printf+0x27>
      if(c == '%'){
     dec:	83 f8 25             	cmp    $0x25,%eax
     def:	75 ce                	jne    dbf <printf+0x1b>
        state = '%';
     df1:	89 c6                	mov    %eax,%esi
     df3:	eb db                	jmp    dd0 <printf+0x2c>
      if(c == 'd'){
     df5:	83 f8 64             	cmp    $0x64,%eax
     df8:	74 49                	je     e43 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     dfa:	83 f8 78             	cmp    $0x78,%eax
     dfd:	0f 94 c1             	sete   %cl
     e00:	83 f8 70             	cmp    $0x70,%eax
     e03:	0f 94 c2             	sete   %dl
     e06:	08 d1                	or     %dl,%cl
     e08:	75 63                	jne    e6d <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     e0a:	83 f8 73             	cmp    $0x73,%eax
     e0d:	0f 84 84 00 00 00    	je     e97 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     e13:	83 f8 63             	cmp    $0x63,%eax
     e16:	0f 84 b7 00 00 00    	je     ed3 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     e1c:	83 f8 25             	cmp    $0x25,%eax
     e1f:	0f 84 cc 00 00 00    	je     ef1 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     e25:	ba 25 00 00 00       	mov    $0x25,%edx
     e2a:	8b 45 08             	mov    0x8(%ebp),%eax
     e2d:	e8 d8 fe ff ff       	call   d0a <putc>
        putc(fd, c);
     e32:	89 fa                	mov    %edi,%edx
     e34:	8b 45 08             	mov    0x8(%ebp),%eax
     e37:	e8 ce fe ff ff       	call   d0a <putc>
      }
      state = 0;
     e3c:	be 00 00 00 00       	mov    $0x0,%esi
     e41:	eb 8d                	jmp    dd0 <printf+0x2c>
        printint(fd, *ap, 10, 1);
     e43:	8b 7d e4             	mov    -0x1c(%ebp),%edi
     e46:	8b 17                	mov    (%edi),%edx
     e48:	83 ec 0c             	sub    $0xc,%esp
     e4b:	6a 01                	push   $0x1
     e4d:	b9 0a 00 00 00       	mov    $0xa,%ecx
     e52:	8b 45 08             	mov    0x8(%ebp),%eax
     e55:	e8 ca fe ff ff       	call   d24 <printint>
        ap++;
     e5a:	83 c7 04             	add    $0x4,%edi
     e5d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
     e60:	83 c4 10             	add    $0x10,%esp
      state = 0;
     e63:	be 00 00 00 00       	mov    $0x0,%esi
     e68:	e9 63 ff ff ff       	jmp    dd0 <printf+0x2c>
        printint(fd, *ap, 16, 0);
     e6d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
     e70:	8b 17                	mov    (%edi),%edx
     e72:	83 ec 0c             	sub    $0xc,%esp
     e75:	6a 00                	push   $0x0
     e77:	b9 10 00 00 00       	mov    $0x10,%ecx
     e7c:	8b 45 08             	mov    0x8(%ebp),%eax
     e7f:	e8 a0 fe ff ff       	call   d24 <printint>
        ap++;
     e84:	83 c7 04             	add    $0x4,%edi
     e87:	89 7d e4             	mov    %edi,-0x1c(%ebp)
     e8a:	83 c4 10             	add    $0x10,%esp
      state = 0;
     e8d:	be 00 00 00 00       	mov    $0x0,%esi
     e92:	e9 39 ff ff ff       	jmp    dd0 <printf+0x2c>
        s = (char*)*ap;
     e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     e9a:	8b 30                	mov    (%eax),%esi
        ap++;
     e9c:	83 c0 04             	add    $0x4,%eax
     e9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
     ea2:	85 f6                	test   %esi,%esi
     ea4:	75 28                	jne    ece <printf+0x12a>
          s = "(null)";
     ea6:	be 48 11 00 00       	mov    $0x1148,%esi
     eab:	8b 7d 08             	mov    0x8(%ebp),%edi
     eae:	eb 0d                	jmp    ebd <printf+0x119>
          putc(fd, *s);
     eb0:	0f be d2             	movsbl %dl,%edx
     eb3:	89 f8                	mov    %edi,%eax
     eb5:	e8 50 fe ff ff       	call   d0a <putc>
          s++;
     eba:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
     ebd:	0f b6 16             	movzbl (%esi),%edx
     ec0:	84 d2                	test   %dl,%dl
     ec2:	75 ec                	jne    eb0 <printf+0x10c>
      state = 0;
     ec4:	be 00 00 00 00       	mov    $0x0,%esi
     ec9:	e9 02 ff ff ff       	jmp    dd0 <printf+0x2c>
     ece:	8b 7d 08             	mov    0x8(%ebp),%edi
     ed1:	eb ea                	jmp    ebd <printf+0x119>
        putc(fd, *ap);
     ed3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
     ed6:	0f be 17             	movsbl (%edi),%edx
     ed9:	8b 45 08             	mov    0x8(%ebp),%eax
     edc:	e8 29 fe ff ff       	call   d0a <putc>
        ap++;
     ee1:	83 c7 04             	add    $0x4,%edi
     ee4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
     ee7:	be 00 00 00 00       	mov    $0x0,%esi
     eec:	e9 df fe ff ff       	jmp    dd0 <printf+0x2c>
        putc(fd, c);
     ef1:	89 fa                	mov    %edi,%edx
     ef3:	8b 45 08             	mov    0x8(%ebp),%eax
     ef6:	e8 0f fe ff ff       	call   d0a <putc>
      state = 0;
     efb:	be 00 00 00 00       	mov    $0x0,%esi
     f00:	e9 cb fe ff ff       	jmp    dd0 <printf+0x2c>
    }
  }
}
     f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f08:	5b                   	pop    %ebx
     f09:	5e                   	pop    %esi
     f0a:	5f                   	pop    %edi
     f0b:	5d                   	pop    %ebp
     f0c:	c3                   	ret    

00000f0d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f0d:	55                   	push   %ebp
     f0e:	89 e5                	mov    %esp,%ebp
     f10:	57                   	push   %edi
     f11:	56                   	push   %esi
     f12:	53                   	push   %ebx
     f13:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f16:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f19:	a1 a4 17 00 00       	mov    0x17a4,%eax
     f1e:	eb 02                	jmp    f22 <free+0x15>
     f20:	89 d0                	mov    %edx,%eax
     f22:	39 c8                	cmp    %ecx,%eax
     f24:	73 04                	jae    f2a <free+0x1d>
     f26:	39 08                	cmp    %ecx,(%eax)
     f28:	77 12                	ja     f3c <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f2a:	8b 10                	mov    (%eax),%edx
     f2c:	39 c2                	cmp    %eax,%edx
     f2e:	77 f0                	ja     f20 <free+0x13>
     f30:	39 c8                	cmp    %ecx,%eax
     f32:	72 08                	jb     f3c <free+0x2f>
     f34:	39 ca                	cmp    %ecx,%edx
     f36:	77 04                	ja     f3c <free+0x2f>
     f38:	89 d0                	mov    %edx,%eax
     f3a:	eb e6                	jmp    f22 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
     f3c:	8b 73 fc             	mov    -0x4(%ebx),%esi
     f3f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
     f42:	8b 10                	mov    (%eax),%edx
     f44:	39 d7                	cmp    %edx,%edi
     f46:	74 19                	je     f61 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
     f48:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     f4b:	8b 50 04             	mov    0x4(%eax),%edx
     f4e:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     f51:	39 ce                	cmp    %ecx,%esi
     f53:	74 1b                	je     f70 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
     f55:	89 08                	mov    %ecx,(%eax)
  freep = p;
     f57:	a3 a4 17 00 00       	mov    %eax,0x17a4
}
     f5c:	5b                   	pop    %ebx
     f5d:	5e                   	pop    %esi
     f5e:	5f                   	pop    %edi
     f5f:	5d                   	pop    %ebp
     f60:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
     f61:	03 72 04             	add    0x4(%edx),%esi
     f64:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
     f67:	8b 10                	mov    (%eax),%edx
     f69:	8b 12                	mov    (%edx),%edx
     f6b:	89 53 f8             	mov    %edx,-0x8(%ebx)
     f6e:	eb db                	jmp    f4b <free+0x3e>
    p->s.size += bp->s.size;
     f70:	03 53 fc             	add    -0x4(%ebx),%edx
     f73:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     f76:	8b 53 f8             	mov    -0x8(%ebx),%edx
     f79:	89 10                	mov    %edx,(%eax)
     f7b:	eb da                	jmp    f57 <free+0x4a>

00000f7d <morecore>:

static Header*
morecore(uint nu)
{
     f7d:	55                   	push   %ebp
     f7e:	89 e5                	mov    %esp,%ebp
     f80:	53                   	push   %ebx
     f81:	83 ec 04             	sub    $0x4,%esp
     f84:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
     f86:	3d ff 0f 00 00       	cmp    $0xfff,%eax
     f8b:	77 05                	ja     f92 <morecore+0x15>
    nu = 4096;
     f8d:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
     f92:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
     f99:	83 ec 0c             	sub    $0xc,%esp
     f9c:	50                   	push   %eax
     f9d:	e8 40 fd ff ff       	call   ce2 <sbrk>
  if(p == (char*)-1)
     fa2:	83 c4 10             	add    $0x10,%esp
     fa5:	83 f8 ff             	cmp    $0xffffffff,%eax
     fa8:	74 1c                	je     fc6 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
     faa:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
     fad:	83 c0 08             	add    $0x8,%eax
     fb0:	83 ec 0c             	sub    $0xc,%esp
     fb3:	50                   	push   %eax
     fb4:	e8 54 ff ff ff       	call   f0d <free>
  return freep;
     fb9:	a1 a4 17 00 00       	mov    0x17a4,%eax
     fbe:	83 c4 10             	add    $0x10,%esp
}
     fc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     fc4:	c9                   	leave  
     fc5:	c3                   	ret    
    return 0;
     fc6:	b8 00 00 00 00       	mov    $0x0,%eax
     fcb:	eb f4                	jmp    fc1 <morecore+0x44>

00000fcd <malloc>:

void*
malloc(uint nbytes)
{
     fcd:	55                   	push   %ebp
     fce:	89 e5                	mov    %esp,%ebp
     fd0:	53                   	push   %ebx
     fd1:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     fd4:	8b 45 08             	mov    0x8(%ebp),%eax
     fd7:	8d 58 07             	lea    0x7(%eax),%ebx
     fda:	c1 eb 03             	shr    $0x3,%ebx
     fdd:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
     fe0:	8b 0d a4 17 00 00    	mov    0x17a4,%ecx
     fe6:	85 c9                	test   %ecx,%ecx
     fe8:	74 04                	je     fee <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fea:	8b 01                	mov    (%ecx),%eax
     fec:	eb 4d                	jmp    103b <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
     fee:	c7 05 a4 17 00 00 a8 	movl   $0x17a8,0x17a4
     ff5:	17 00 00 
     ff8:	c7 05 a8 17 00 00 a8 	movl   $0x17a8,0x17a8
     fff:	17 00 00 
    base.s.size = 0;
    1002:	c7 05 ac 17 00 00 00 	movl   $0x0,0x17ac
    1009:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    100c:	b9 a8 17 00 00       	mov    $0x17a8,%ecx
    1011:	eb d7                	jmp    fea <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    1013:	39 da                	cmp    %ebx,%edx
    1015:	74 1a                	je     1031 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1017:	29 da                	sub    %ebx,%edx
    1019:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    101c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    101f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1022:	89 0d a4 17 00 00    	mov    %ecx,0x17a4
      return (void*)(p + 1);
    1028:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    102b:	83 c4 04             	add    $0x4,%esp
    102e:	5b                   	pop    %ebx
    102f:	5d                   	pop    %ebp
    1030:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1031:	8b 10                	mov    (%eax),%edx
    1033:	89 11                	mov    %edx,(%ecx)
    1035:	eb eb                	jmp    1022 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1037:	89 c1                	mov    %eax,%ecx
    1039:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
    103b:	8b 50 04             	mov    0x4(%eax),%edx
    103e:	39 da                	cmp    %ebx,%edx
    1040:	73 d1                	jae    1013 <malloc+0x46>
    if(p == freep)
    1042:	39 05 a4 17 00 00    	cmp    %eax,0x17a4
    1048:	75 ed                	jne    1037 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
    104a:	89 d8                	mov    %ebx,%eax
    104c:	e8 2c ff ff ff       	call   f7d <morecore>
    1051:	85 c0                	test   %eax,%eax
    1053:	75 e2                	jne    1037 <malloc+0x6a>
        return 0;
    1055:	b8 00 00 00 00       	mov    $0x0,%eax
    105a:	eb cf                	jmp    102b <malloc+0x5e>
