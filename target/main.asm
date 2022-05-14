
target/main：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "stdio.h"
#include "user_syscall.h"

char str[256];

int main(int argc, char *argv[]){
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	8a2e                	mv	s4,a1
    printf("main begin!\n");
  14:	00000517          	auipc	a0,0x0
  18:	62c50513          	addi	a0,a0,1580 # 640 <printf+0x60>
  1c:	00000097          	auipc	ra,0x0
  20:	5c4080e7          	jalr	1476(ra) # 5e0 <printf>
    printf("argc: %d\n",argc);
  24:	85ca                	mv	a1,s2
  26:	00000517          	auipc	a0,0x0
  2a:	62a50513          	addi	a0,a0,1578 # 650 <printf+0x70>
  2e:	00000097          	auipc	ra,0x0
  32:	5b2080e7          	jalr	1458(ra) # 5e0 <printf>
    for(int i=0;i<argc;i++){
  36:	03205263          	blez	s2,5a <main+0x5a>
  3a:	84d2                	mv	s1,s4
  3c:	397d                	addiw	s2,s2,-1
  3e:	1902                	slli	s2,s2,0x20
  40:	02095913          	srli	s2,s2,0x20
  44:	090e                	slli	s2,s2,0x3
  46:	0a21                	addi	s4,s4,8
  48:	9952                	add	s2,s2,s4
        printf(argv[i]);
  4a:	6088                	ld	a0,0(s1)
  4c:	00000097          	auipc	ra,0x0
  50:	594080e7          	jalr	1428(ra) # 5e0 <printf>
  54:	04a1                	addi	s1,s1,8
    for(int i=0;i<argc;i++){
  56:	ff249ae3          	bne	s1,s2,4a <main+0x4a>
    }
    printf("pid: %d\n",getpid());
  5a:	00000097          	auipc	ra,0x0
  5e:	2fa080e7          	jalr	762(ra) # 354 <getpid>
  62:	85aa                	mv	a1,a0
  64:	00000517          	auipc	a0,0x0
  68:	5fc50513          	addi	a0,a0,1532 # 660 <printf+0x80>
  6c:	00000097          	auipc	ra,0x0
  70:	574080e7          	jalr	1396(ra) # 5e0 <printf>
    printf("ppid: %d\n",getppid());
  74:	00000097          	auipc	ra,0x0
  78:	2b6080e7          	jalr	694(ra) # 32a <getppid>
  7c:	85aa                	mv	a1,a0
  7e:	00000517          	auipc	a0,0x0
  82:	5f250513          	addi	a0,a0,1522 # 670 <printf+0x90>
  86:	00000097          	auipc	ra,0x0
  8a:	55a080e7          	jalr	1370(ra) # 5e0 <printf>

    printf("\n");
  8e:	00000517          	auipc	a0,0x0
  92:	5ca50513          	addi	a0,a0,1482 # 658 <printf+0x78>
  96:	00000097          	auipc	ra,0x0
  9a:	54a080e7          	jalr	1354(ra) # 5e0 <printf>

    while(1){
        printf("input a string(q to quit): ");
  9e:	00000997          	auipc	s3,0x0
  a2:	5e298993          	addi	s3,s3,1506 # 680 <printf+0xa0>
        simple_read(str,256);
  a6:	00000497          	auipc	s1,0x0
  aa:	67a48493          	addi	s1,s1,1658 # 720 <__DATA_BEGIN__>
        if(str[0]=='q' && str[1]==0)
  ae:	07100913          	li	s2,113
            break;
        printf("your string is: %s\n",str);
  b2:	00000a17          	auipc	s4,0x0
  b6:	5eea0a13          	addi	s4,s4,1518 # 6a0 <printf+0xc0>
  ba:	a039                	j	c8 <main+0xc8>
  bc:	85a6                	mv	a1,s1
  be:	8552                	mv	a0,s4
  c0:	00000097          	auipc	ra,0x0
  c4:	520080e7          	jalr	1312(ra) # 5e0 <printf>
        printf("input a string(q to quit): ");
  c8:	854e                	mv	a0,s3
  ca:	00000097          	auipc	ra,0x0
  ce:	516080e7          	jalr	1302(ra) # 5e0 <printf>
        simple_read(str,256);
  d2:	10000593          	li	a1,256
  d6:	8526                	mv	a0,s1
  d8:	00000097          	auipc	ra,0x0
  dc:	162080e7          	jalr	354(ra) # 23a <simple_read>
        if(str[0]=='q' && str[1]==0)
  e0:	0004c783          	lbu	a5,0(s1)
  e4:	fd279ce3          	bne	a5,s2,bc <main+0xbc>
  e8:	0014c783          	lbu	a5,1(s1)
  ec:	fbe1                	bnez	a5,bc <main+0xbc>
    }

    printf("\n");
  ee:	00000517          	auipc	a0,0x0
  f2:	56a50513          	addi	a0,a0,1386 # 658 <printf+0x78>
  f6:	00000097          	auipc	ra,0x0
  fa:	4ea080e7          	jalr	1258(ra) # 5e0 <printf>

    printf("main end!\n");    
  fe:	00000517          	auipc	a0,0x0
 102:	5ba50513          	addi	a0,a0,1466 # 6b8 <printf+0xd8>
 106:	00000097          	auipc	ra,0x0
 10a:	4da080e7          	jalr	1242(ra) # 5e0 <printf>
    exit(22);
 10e:	4559                	li	a0,22
 110:	00000097          	auipc	ra,0x0
 114:	1f2080e7          	jalr	498(ra) # 302 <exit>
    return 0;
}
 118:	4501                	li	a0,0
 11a:	70a2                	ld	ra,40(sp)
 11c:	7402                	ld	s0,32(sp)
 11e:	64e2                	ld	s1,24(sp)
 120:	6942                	ld	s2,16(sp)
 122:	69a2                	ld	s3,8(sp)
 124:	6a02                	ld	s4,0(sp)
 126:	6145                	addi	sp,sp,48
 128:	8082                	ret

000000000000012a <user_syscall>:
/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
 12a:	715d                	addi	sp,sp,-80
 12c:	e4a2                	sd	s0,72(sp)
 12e:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
 130:	fea43423          	sd	a0,-24(s0)
 134:	feb43023          	sd	a1,-32(s0)
 138:	fcc43c23          	sd	a2,-40(s0)
 13c:	fcd43823          	sd	a3,-48(s0)
 140:	fce43423          	sd	a4,-56(s0)
 144:	fcf43023          	sd	a5,-64(s0)
 148:	fb043c23          	sd	a6,-72(s0)
 14c:	fb143823          	sd	a7,-80(s0)
        asm volatile(   //将参数写入a0-a7寄存器
 150:	fe843503          	ld	a0,-24(s0)
 154:	fe043583          	ld	a1,-32(s0)
 158:	fd843603          	ld	a2,-40(s0)
 15c:	fd043683          	ld	a3,-48(s0)
 160:	fc843703          	ld	a4,-56(s0)
 164:	fc043783          	ld	a5,-64(s0)
 168:	fb843803          	ld	a6,-72(s0)
 16c:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(   //调用ecall
 170:	00000073          	ecall
 174:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
 178:	fe843503          	ld	a0,-24(s0)
 17c:	6426                	ld	s0,72(sp)
 17e:	6161                	addi	sp,sp,80
 180:	8082                	ret

0000000000000182 <fork>:

//复制一个新进程
uint64 fork(){
 182:	1141                	addi	sp,sp,-16
 184:	e406                	sd	ra,8(sp)
 186:	e022                	sd	s0,0(sp)
 188:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
 18a:	4885                	li	a7,1
 18c:	4801                	li	a6,0
 18e:	4781                	li	a5,0
 190:	4701                	li	a4,0
 192:	4681                	li	a3,0
 194:	4601                	li	a2,0
 196:	4581                	li	a1,0
 198:	4501                	li	a0,0
 19a:	00000097          	auipc	ra,0x0
 19e:	f90080e7          	jalr	-112(ra) # 12a <user_syscall>
}
 1a2:	60a2                	ld	ra,8(sp)
 1a4:	6402                	ld	s0,0(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <open>:

//打开文件
uint64 open(char *file_name, int mode){
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
 1b2:	48bd                	li	a7,15
 1b4:	4801                	li	a6,0
 1b6:	4781                	li	a5,0
 1b8:	4701                	li	a4,0
 1ba:	4681                	li	a3,0
 1bc:	4601                	li	a2,0
 1be:	00000097          	auipc	ra,0x0
 1c2:	f6c080e7          	jalr	-148(ra) # 12a <user_syscall>
}
 1c6:	60a2                	ld	ra,8(sp)
 1c8:	6402                	ld	s0,0(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret

00000000000001ce <read>:

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e406                	sd	ra,8(sp)
 1d2:	e022                	sd	s0,0(sp)
 1d4:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
 1d6:	4895                	li	a7,5
 1d8:	4801                	li	a6,0
 1da:	4781                	li	a5,0
 1dc:	4701                	li	a4,0
 1de:	4681                	li	a3,0
 1e0:	00000097          	auipc	ra,0x0
 1e4:	f4a080e7          	jalr	-182(ra) # 12a <user_syscall>
}
 1e8:	60a2                	ld	ra,8(sp)
 1ea:	6402                	ld	s0,0(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret

00000000000001f0 <kill>:

//根据pid杀死进程
uint64 kill(uint64 pid){
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e406                	sd	ra,8(sp)
 1f4:	e022                	sd	s0,0(sp)
 1f6:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
 1f8:	4899                	li	a7,6
 1fa:	4801                	li	a6,0
 1fc:	4781                	li	a5,0
 1fe:	4701                	li	a4,0
 200:	4681                	li	a3,0
 202:	4601                	li	a2,0
 204:	4581                	li	a1,0
 206:	00000097          	auipc	ra,0x0
 20a:	f24080e7          	jalr	-220(ra) # 12a <user_syscall>
}
 20e:	60a2                	ld	ra,8(sp)
 210:	6402                	ld	s0,0(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret

0000000000000216 <execve>:

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
 216:	1141                	addi	sp,sp,-16
 218:	e406                	sd	ra,8(sp)
 21a:	e022                	sd	s0,0(sp)
 21c:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
 21e:	0dd00893          	li	a7,221
 222:	4801                	li	a6,0
 224:	4781                	li	a5,0
 226:	4701                	li	a4,0
 228:	4681                	li	a3,0
 22a:	00000097          	auipc	ra,0x0
 22e:	f00080e7          	jalr	-256(ra) # 12a <user_syscall>
}
 232:	60a2                	ld	ra,8(sp)
 234:	6402                	ld	s0,0(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret

000000000000023a <simple_read>:

//从键盘输入字符串
uint64 simple_read(char *s, size_t n){
 23a:	1141                	addi	sp,sp,-16
 23c:	e406                	sd	ra,8(sp)
 23e:	e022                	sd	s0,0(sp)
 240:	0800                	addi	s0,sp,16
    return user_syscall(0,(uint64)s,n,0,0,0,0,SYS_simple_read);
 242:	06300893          	li	a7,99
 246:	4801                	li	a6,0
 248:	4781                	li	a5,0
 24a:	4701                	li	a4,0
 24c:	4681                	li	a3,0
 24e:	862e                	mv	a2,a1
 250:	85aa                	mv	a1,a0
 252:	4501                	li	a0,0
 254:	00000097          	auipc	ra,0x0
 258:	ed6080e7          	jalr	-298(ra) # 12a <user_syscall>
}
 25c:	60a2                	ld	ra,8(sp)
 25e:	6402                	ld	s0,0(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret

0000000000000264 <simple_write>:

//输出字符串到屏幕
uint64 simple_write(char *s, size_t n){
 264:	1141                	addi	sp,sp,-16
 266:	e406                	sd	ra,8(sp)
 268:	e022                	sd	s0,0(sp)
 26a:	0800                	addi	s0,sp,16
    return user_syscall(1,(uint64)s,n,0,0,0,0,SYS_simple_write);
 26c:	06400893          	li	a7,100
 270:	4801                	li	a6,0
 272:	4781                	li	a5,0
 274:	4701                	li	a4,0
 276:	4681                	li	a3,0
 278:	862e                	mv	a2,a1
 27a:	85aa                	mv	a1,a0
 27c:	4505                	li	a0,1
 27e:	00000097          	auipc	ra,0x0
 282:	eac080e7          	jalr	-340(ra) # 12a <user_syscall>
}
 286:	60a2                	ld	ra,8(sp)
 288:	6402                	ld	s0,0(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret

000000000000028e <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
 296:	48d5                	li	a7,21
 298:	4801                	li	a6,0
 29a:	4781                	li	a5,0
 29c:	4701                	li	a4,0
 29e:	4681                	li	a3,0
 2a0:	4601                	li	a2,0
 2a2:	4581                	li	a1,0
 2a4:	00000097          	auipc	ra,0x0
 2a8:	e86080e7          	jalr	-378(ra) # 12a <user_syscall>
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <clone>:

uint64 clone(uint64 flag, void *stack, size_t sz){
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
    if(stack!=NULL)
 2bc:	c191                	beqz	a1,2c0 <clone+0xc>
        stack+=sz;
 2be:	95b2                	add	a1,a1,a2
    return user_syscall(flag,(uint64)stack,0,0,0,0,0,SYS_clone);
 2c0:	0dc00893          	li	a7,220
 2c4:	4801                	li	a6,0
 2c6:	4781                	li	a5,0
 2c8:	4701                	li	a4,0
 2ca:	4681                	li	a3,0
 2cc:	4601                	li	a2,0
 2ce:	00000097          	auipc	ra,0x0
 2d2:	e5c080e7          	jalr	-420(ra) # 12a <user_syscall>
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <wait4>:

uint64 wait4(int pid, int *status, uint64 options){
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
    return user_syscall((uint64)pid,(uint64)status,options,0,0,0,0,SYS_wait4);
 2e6:	10400893          	li	a7,260
 2ea:	4801                	li	a6,0
 2ec:	4781                	li	a5,0
 2ee:	4701                	li	a4,0
 2f0:	4681                	li	a3,0
 2f2:	00000097          	auipc	ra,0x0
 2f6:	e38080e7          	jalr	-456(ra) # 12a <user_syscall>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <exit>:

//进程退出
uint64 exit(int code){
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
 30a:	05d00893          	li	a7,93
 30e:	4801                	li	a6,0
 310:	4781                	li	a5,0
 312:	4701                	li	a4,0
 314:	4681                	li	a3,0
 316:	4601                	li	a2,0
 318:	4581                	li	a1,0
 31a:	00000097          	auipc	ra,0x0
 31e:	e10080e7          	jalr	-496(ra) # 12a <user_syscall>
}
 322:	60a2                	ld	ra,8(sp)
 324:	6402                	ld	s0,0(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret

000000000000032a <getppid>:

//获取父进程pid
uint64 getppid(){
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getppid);
 332:	0ad00893          	li	a7,173
 336:	4801                	li	a6,0
 338:	4781                	li	a5,0
 33a:	4701                	li	a4,0
 33c:	4681                	li	a3,0
 33e:	4601                	li	a2,0
 340:	4581                	li	a1,0
 342:	4501                	li	a0,0
 344:	00000097          	auipc	ra,0x0
 348:	de6080e7          	jalr	-538(ra) # 12a <user_syscall>
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <getpid>:

//获取当前进程pid
uint64 getpid(){
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getpid);
 35c:	0ac00893          	li	a7,172
 360:	4801                	li	a6,0
 362:	4781                	li	a5,0
 364:	4701                	li	a4,0
 366:	4681                	li	a3,0
 368:	4601                	li	a2,0
 36a:	4581                	li	a1,0
 36c:	4501                	li	a0,0
 36e:	00000097          	auipc	ra,0x0
 372:	dbc080e7          	jalr	-580(ra) # 12a <user_syscall>
}
 376:	60a2                	ld	ra,8(sp)
 378:	6402                	ld	s0,0(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret

000000000000037e <sched_yield>:

uint64 sched_yield(){
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_sched_yield);
 386:	07c00893          	li	a7,124
 38a:	4801                	li	a6,0
 38c:	4781                	li	a5,0
 38e:	4701                	li	a4,0
 390:	4681                	li	a3,0
 392:	4601                	li	a2,0
 394:	4581                	li	a1,0
 396:	4501                	li	a0,0
 398:	00000097          	auipc	ra,0x0
 39c:	d92080e7          	jalr	-622(ra) # 12a <user_syscall>
 3a0:	60a2                	ld	ra,8(sp)
 3a2:	6402                	ld	s0,0(sp)
 3a4:	0141                	addi	sp,sp,16
 3a6:	8082                	ret

00000000000003a8 <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
 3a8:	00064783          	lbu	a5,0(a2)
 3ac:	20078c63          	beqz	a5,5c4 <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
 3b0:	715d                	addi	sp,sp,-80
 3b2:	e4a2                	sd	s0,72(sp)
 3b4:	e0a6                	sd	s1,64(sp)
 3b6:	fc4a                	sd	s2,56(sp)
 3b8:	f84e                	sd	s3,48(sp)
 3ba:	f452                	sd	s4,40(sp)
 3bc:	f056                	sd	s5,32(sp)
 3be:	ec5a                	sd	s6,24(sp)
 3c0:	e85e                	sd	s7,16(sp)
 3c2:	e462                	sd	s8,8(sp)
 3c4:	e066                	sd	s9,0(sp)
 3c6:	0880                	addi	s0,sp,80
  size_t pos = 0;
 3c8:	4701                	li	a4,0
  int longarg = 0;
 3ca:	4b01                	li	s6,0
  int format = 0;
 3cc:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 3ce:	02500f93          	li	t6,37
      format = 1;
 3d2:	4285                	li	t0,1
      switch (*s) {
 3d4:	4f55                	li	t5,21
 3d6:	00000317          	auipc	t1,0x0
 3da:	2f230313          	addi	t1,t1,754 # 6c8 <printf+0xe8>
          longarg = 0;
 3de:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 3e0:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
 3e2:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 3e6:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 3e8:	58fd                	li	a7,-1
 3ea:	43bd                	li	t2,15
 3ec:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
 3ee:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
 3f2:	03000493          	li	s1,48
 3f6:	aabd                	j	574 <vsnprintf+0x1cc>
          longarg = 1;
 3f8:	8b56                	mv	s6,s5
 3fa:	aa8d                	j	56c <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
 3fc:	00170793          	addi	a5,a4,1
 400:	00b7f663          	bgeu	a5,a1,40c <vsnprintf+0x64>
 404:	00e50ab3          	add	s5,a0,a4
 408:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
 40c:	0709                	addi	a4,a4,2
 40e:	00b77563          	bgeu	a4,a1,418 <vsnprintf+0x70>
 412:	97aa                	add	a5,a5,a0
 414:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 418:	0006bc03          	ld	s8,0(a3)
 41c:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 41e:	8c9e                	mv	s9,t2
 420:	8b66                	mv	s6,s9
 422:	8aba                	mv	s5,a4
 424:	a839                	j	442 <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 426:	fe0b19e3          	bnez	s6,418 <vsnprintf+0x70>
 42a:	0006ac03          	lw	s8,0(a3)
 42e:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 430:	8cce                	mv	s9,s3
 432:	b7fd                	j	420 <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 434:	015507b3          	add	a5,a0,s5
 438:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 43c:	3b7d                	addiw	s6,s6,-1
 43e:	031b0163          	beq	s6,a7,460 <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 442:	0a85                	addi	s5,s5,1
 444:	febafce3          	bgeu	s5,a1,43c <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
 448:	002b179b          	slliw	a5,s6,0x2
 44c:	40fc57b3          	sra	a5,s8,a5
 450:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 452:	05778b93          	addi	s7,a5,87
 456:	fcfecfe3          	blt	t4,a5,434 <vsnprintf+0x8c>
 45a:	03078b93          	addi	s7,a5,48
 45e:	bfd9                	j	434 <vsnprintf+0x8c>
 460:	0705                	addi	a4,a4,1
 462:	9766                	add	a4,a4,s9
          longarg = 0;
 464:	8b72                	mv	s6,t3
          format = 0;
 466:	8af2                	mv	s5,t3
 468:	a211                	j	56c <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 46a:	020b0663          	beqz	s6,496 <vsnprintf+0xee>
 46e:	0006ba83          	ld	s5,0(a3)
 472:	06a1                	addi	a3,a3,8
          if (num < 0) {
 474:	020ac563          	bltz	s5,49e <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
 478:	030ac7b3          	div	a5,s5,a6
 47c:	cf95                	beqz	a5,4b8 <vsnprintf+0x110>
          long digits = 1;
 47e:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 480:	0b05                	addi	s6,s6,1
 482:	0307c7b3          	div	a5,a5,a6
 486:	ffed                	bnez	a5,480 <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 488:	fffb079b          	addiw	a5,s6,-1
 48c:	0407ce63          	bltz	a5,4e8 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 490:	00170c93          	addi	s9,a4,1
 494:	a825                	j	4cc <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 496:	0006aa83          	lw	s5,0(a3)
 49a:	06a1                	addi	a3,a3,8
 49c:	bfe1                	j	474 <vsnprintf+0xcc>
            num = -num;
 49e:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
 4a2:	00170793          	addi	a5,a4,1
 4a6:	00b7f763          	bgeu	a5,a1,4b4 <vsnprintf+0x10c>
 4aa:	972a                	add	a4,a4,a0
 4ac:	01470023          	sb	s4,0(a4)
 4b0:	873e                	mv	a4,a5
 4b2:	b7d9                	j	478 <vsnprintf+0xd0>
 4b4:	873e                	mv	a4,a5
 4b6:	b7c9                	j	478 <vsnprintf+0xd0>
          long digits = 1;
 4b8:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 4ba:	87f2                	mv	a5,t3
 4bc:	bfd1                	j	490 <vsnprintf+0xe8>
            num /= 10;
 4be:	030acab3          	div	s5,s5,a6
 4c2:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
 4c4:	02079b93          	slli	s7,a5,0x20
 4c8:	020bc063          	bltz	s7,4e8 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 4cc:	00fc8bb3          	add	s7,s9,a5
 4d0:	febbf7e3          	bgeu	s7,a1,4be <vsnprintf+0x116>
 4d4:	00f70bb3          	add	s7,a4,a5
 4d8:	9baa                	add	s7,s7,a0
 4da:	030aec33          	rem	s8,s5,a6
 4de:	030c0c1b          	addiw	s8,s8,48
 4e2:	018b8023          	sb	s8,0(s7)
 4e6:	bfe1                	j	4be <vsnprintf+0x116>
          pos += digits;
 4e8:	975a                	add	a4,a4,s6
          longarg = 0;
 4ea:	8b72                	mv	s6,t3
          format = 0;
 4ec:	8af2                	mv	s5,t3
          break;
 4ee:	a8bd                	j	56c <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 4f0:	00868b93          	addi	s7,a3,8
 4f4:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
 4f8:	000ac683          	lbu	a3,0(s5)
 4fc:	ceb9                	beqz	a3,55a <vsnprintf+0x1b2>
 4fe:	87ba                	mv	a5,a4
 500:	a039                	j	50e <vsnprintf+0x166>
 502:	40e786b3          	sub	a3,a5,a4
 506:	96d6                	add	a3,a3,s5
 508:	0006c683          	lbu	a3,0(a3)
 50c:	ca89                	beqz	a3,51e <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
 50e:	0785                	addi	a5,a5,1
 510:	feb7f9e3          	bgeu	a5,a1,502 <vsnprintf+0x15a>
 514:	00f50b33          	add	s6,a0,a5
 518:	fedb0fa3          	sb	a3,-1(s6)
 51c:	b7dd                	j	502 <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
 51e:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 520:	873e                	mv	a4,a5
          longarg = 0;
 522:	8b72                	mv	s6,t3
          format = 0;
 524:	8af2                	mv	s5,t3
 526:	a099                	j	56c <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 528:	00170793          	addi	a5,a4,1
 52c:	02b7fb63          	bgeu	a5,a1,562 <vsnprintf+0x1ba>
 530:	972a                	add	a4,a4,a0
 532:	0006aa83          	lw	s5,0(a3)
 536:	01570023          	sb	s5,0(a4)
 53a:	06a1                	addi	a3,a3,8
 53c:	873e                	mv	a4,a5
          longarg = 0;
 53e:	8b72                	mv	s6,t3
          format = 0;
 540:	8af2                	mv	s5,t3
 542:	a02d                	j	56c <vsnprintf+0x1c4>
    } else if (*s == '%')
 544:	03f78363          	beq	a5,t6,56a <vsnprintf+0x1c2>
    else if (++pos < n)
 548:	00170b93          	addi	s7,a4,1
 54c:	04bbf263          	bgeu	s7,a1,590 <vsnprintf+0x1e8>
      out[pos - 1] = *s;
 550:	972a                	add	a4,a4,a0
 552:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
 556:	875e                	mv	a4,s7
 558:	a811                	j	56c <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 55a:	86de                	mv	a3,s7
          longarg = 0;
 55c:	8b72                	mv	s6,t3
          format = 0;
 55e:	8af2                	mv	s5,t3
 560:	a031                	j	56c <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 562:	873e                	mv	a4,a5
          longarg = 0;
 564:	8b72                	mv	s6,t3
          format = 0;
 566:	8af2                	mv	s5,t3
 568:	a011                	j	56c <vsnprintf+0x1c4>
      format = 1;
 56a:	8a96                	mv	s5,t0
  for (; *s; s++) {
 56c:	0605                	addi	a2,a2,1
 56e:	00064783          	lbu	a5,0(a2)
 572:	c38d                	beqz	a5,594 <vsnprintf+0x1ec>
    if (format) {
 574:	fc0a88e3          	beqz	s5,544 <vsnprintf+0x19c>
      switch (*s) {
 578:	f9d7879b          	addiw	a5,a5,-99
 57c:	0ff7fb93          	andi	s7,a5,255
 580:	ff7f66e3          	bltu	t5,s7,56c <vsnprintf+0x1c4>
 584:	002b9793          	slli	a5,s7,0x2
 588:	979a                	add	a5,a5,t1
 58a:	439c                	lw	a5,0(a5)
 58c:	979a                	add	a5,a5,t1
 58e:	8782                	jr	a5
    else if (++pos < n)
 590:	875e                	mv	a4,s7
 592:	bfe9                	j	56c <vsnprintf+0x1c4>
  }
  if (pos < n)
 594:	02b77363          	bgeu	a4,a1,5ba <vsnprintf+0x212>
    out[pos] = 0;
 598:	953a                	add	a0,a0,a4
 59a:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 59e:	0007051b          	sext.w	a0,a4
 5a2:	6426                	ld	s0,72(sp)
 5a4:	6486                	ld	s1,64(sp)
 5a6:	7962                	ld	s2,56(sp)
 5a8:	79c2                	ld	s3,48(sp)
 5aa:	7a22                	ld	s4,40(sp)
 5ac:	7a82                	ld	s5,32(sp)
 5ae:	6b62                	ld	s6,24(sp)
 5b0:	6bc2                	ld	s7,16(sp)
 5b2:	6c22                	ld	s8,8(sp)
 5b4:	6c82                	ld	s9,0(sp)
 5b6:	6161                	addi	sp,sp,80
 5b8:	8082                	ret
  else if (n)
 5ba:	d1f5                	beqz	a1,59e <vsnprintf+0x1f6>
    out[n - 1] = 0;
 5bc:	95aa                	add	a1,a1,a0
 5be:	fe058fa3          	sb	zero,-1(a1)
 5c2:	bff1                	j	59e <vsnprintf+0x1f6>
  size_t pos = 0;
 5c4:	4701                	li	a4,0
  if (pos < n)
 5c6:	00b77863          	bgeu	a4,a1,5d6 <vsnprintf+0x22e>
    out[pos] = 0;
 5ca:	953a                	add	a0,a0,a4
 5cc:	00050023          	sb	zero,0(a0)
}
 5d0:	0007051b          	sext.w	a0,a4
 5d4:	8082                	ret
  else if (n)
 5d6:	dded                	beqz	a1,5d0 <vsnprintf+0x228>
    out[n - 1] = 0;
 5d8:	95aa                	add	a1,a1,a0
 5da:	fe058fa3          	sb	zero,-1(a1)
 5de:	bfcd                	j	5d0 <vsnprintf+0x228>

00000000000005e0 <printf>:
int printf(char*s, ...){
 5e0:	710d                	addi	sp,sp,-352
 5e2:	ee06                	sd	ra,280(sp)
 5e4:	ea22                	sd	s0,272(sp)
 5e6:	1200                	addi	s0,sp,288
 5e8:	e40c                	sd	a1,8(s0)
 5ea:	e810                	sd	a2,16(s0)
 5ec:	ec14                	sd	a3,24(s0)
 5ee:	f018                	sd	a4,32(s0)
 5f0:	f41c                	sd	a5,40(s0)
 5f2:	03043823          	sd	a6,48(s0)
 5f6:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 5fa:	00840693          	addi	a3,s0,8
 5fe:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 602:	862a                	mv	a2,a0
 604:	10000593          	li	a1,256
 608:	ee840513          	addi	a0,s0,-280
 60c:	00000097          	auipc	ra,0x0
 610:	d9c080e7          	jalr	-612(ra) # 3a8 <vsnprintf>
 614:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 616:	0005071b          	sext.w	a4,a0
 61a:	0ff00793          	li	a5,255
 61e:	00e7f463          	bgeu	a5,a4,626 <printf+0x46>
 622:	10000593          	li	a1,256
    return simple_write(buf, n);
 626:	ee840513          	addi	a0,s0,-280
 62a:	00000097          	auipc	ra,0x0
 62e:	c3a080e7          	jalr	-966(ra) # 264 <simple_write>
}
 632:	2501                	sext.w	a0,a0
 634:	60f2                	ld	ra,280(sp)
 636:	6452                	ld	s0,272(sp)
 638:	6135                	addi	sp,sp,352
 63a:	8082                	ret
