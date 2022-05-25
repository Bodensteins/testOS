
target/init：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user_syscall.h"
#include "stdio.h"

int main(){
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	0880                	addi	s0,sp,80
    printf("\nsyscall test begin\n");
   c:	00000517          	auipc	a0,0x0
  10:	66450513          	addi	a0,a0,1636 # 670 <printf+0x8a>
  14:	00000097          	auipc	ra,0x0
  18:	5d2080e7          	jalr	1490(ra) # 5e6 <printf>
    
    int pid=fork();
  1c:	00000097          	auipc	ra,0x0
  20:	142080e7          	jalr	322(ra) # 15e <fork>

    if(pid==0){
  24:	2501                	sext.w	a0,a0
  26:	ed41                	bnez	a0,be <main+0xbe>
        char *argv[5]={"wait4 ", "and ","execve ", "test!\n", NULL};
  28:	00000797          	auipc	a5,0x0
  2c:	62078793          	addi	a5,a5,1568 # 648 <printf+0x62>
  30:	638c                	ld	a1,0(a5)
  32:	6790                	ld	a2,8(a5)
  34:	6b94                	ld	a3,16(a5)
  36:	6f98                	ld	a4,24(a5)
  38:	739c                	ld	a5,32(a5)
  3a:	fab43c23          	sd	a1,-72(s0)
  3e:	fcc43023          	sd	a2,-64(s0)
  42:	fcd43423          	sd	a3,-56(s0)
  46:	fce43823          	sd	a4,-48(s0)
  4a:	fcf43c23          	sd	a5,-40(s0)
        for(int i=0;i<4;i++){
  4e:	fb840493          	addi	s1,s0,-72
  52:	fd840913          	addi	s2,s0,-40
            printf(argv[i]);
  56:	6088                	ld	a0,0(s1)
  58:	00000097          	auipc	ra,0x0
  5c:	58e080e7          	jalr	1422(ra) # 5e6 <printf>
  60:	04a1                	addi	s1,s1,8
        for(int i=0;i<4;i++){
  62:	ff249ae3          	bne	s1,s2,56 <main+0x56>
        }
        printf("\n...................................\n\n");
  66:	00000517          	auipc	a0,0x0
  6a:	62250513          	addi	a0,a0,1570 # 688 <printf+0xa2>
  6e:	00000097          	auipc	ra,0x0
  72:	578080e7          	jalr	1400(ra) # 5e6 <printf>
        execve("main",argv, NULL);
  76:	4601                	li	a2,0
  78:	fb840593          	addi	a1,s0,-72
  7c:	00000517          	auipc	a0,0x0
  80:	63450513          	addi	a0,a0,1588 # 6b0 <printf+0xca>
  84:	00000097          	auipc	ra,0x0
  88:	16e080e7          	jalr	366(ra) # 1f2 <execve>
        int ret=wait4(-1,&status,0);
        status=status>>8;
        printf("ret=%d, status=%d\n",ret,status);
    }

    pid=fork();
  8c:	00000097          	auipc	ra,0x0
  90:	0d2080e7          	jalr	210(ra) # 15e <fork>
    if(pid==0){
  94:	2501                	sext.w	a0,a0
  96:	e125                	bnez	a0,f6 <main+0xf6>
        execve("/getpid",NULL,NULL);
  98:	4601                	li	a2,0
  9a:	4581                	li	a1,0
  9c:	00000517          	auipc	a0,0x0
  a0:	63450513          	addi	a0,a0,1588 # 6d0 <printf+0xea>
  a4:	00000097          	auipc	ra,0x0
  a8:	14e080e7          	jalr	334(ra) # 1f2 <execve>
    }
    else{
        wait4(-1,NULL,0);
    }

    printf("\nsyscall test end\n");
  ac:	00000517          	auipc	a0,0x0
  b0:	62c50513          	addi	a0,a0,1580 # 6d8 <printf+0xf2>
  b4:	00000097          	auipc	ra,0x0
  b8:	532080e7          	jalr	1330(ra) # 5e6 <printf>

    while(1){
    }
  bc:	a001                	j	bc <main+0xbc>
        int status=0;
  be:	fa042c23          	sw	zero,-72(s0)
        int ret=wait4(-1,&status,0);
  c2:	4601                	li	a2,0
  c4:	fb840593          	addi	a1,s0,-72
  c8:	557d                	li	a0,-1
  ca:	00000097          	auipc	ra,0x0
  ce:	1f0080e7          	jalr	496(ra) # 2ba <wait4>
        status=status>>8;
  d2:	fb842603          	lw	a2,-72(s0)
  d6:	4086561b          	sraiw	a2,a2,0x8
  da:	fac42c23          	sw	a2,-72(s0)
        printf("ret=%d, status=%d\n",ret,status);
  de:	2601                	sext.w	a2,a2
  e0:	0005059b          	sext.w	a1,a0
  e4:	00000517          	auipc	a0,0x0
  e8:	5d450513          	addi	a0,a0,1492 # 6b8 <printf+0xd2>
  ec:	00000097          	auipc	ra,0x0
  f0:	4fa080e7          	jalr	1274(ra) # 5e6 <printf>
  f4:	bf61                	j	8c <main+0x8c>
        wait4(-1,NULL,0);
  f6:	4601                	li	a2,0
  f8:	4581                	li	a1,0
  fa:	557d                	li	a0,-1
  fc:	00000097          	auipc	ra,0x0
 100:	1be080e7          	jalr	446(ra) # 2ba <wait4>
 104:	b765                	j	ac <main+0xac>

0000000000000106 <user_syscall>:
/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
 106:	715d                	addi	sp,sp,-80
 108:	e4a2                	sd	s0,72(sp)
 10a:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
 10c:	fea43423          	sd	a0,-24(s0)
 110:	feb43023          	sd	a1,-32(s0)
 114:	fcc43c23          	sd	a2,-40(s0)
 118:	fcd43823          	sd	a3,-48(s0)
 11c:	fce43423          	sd	a4,-56(s0)
 120:	fcf43023          	sd	a5,-64(s0)
 124:	fb043c23          	sd	a6,-72(s0)
 128:	fb143823          	sd	a7,-80(s0)
        asm volatile(   //将参数写入a0-a7寄存器
 12c:	fe843503          	ld	a0,-24(s0)
 130:	fe043583          	ld	a1,-32(s0)
 134:	fd843603          	ld	a2,-40(s0)
 138:	fd043683          	ld	a3,-48(s0)
 13c:	fc843703          	ld	a4,-56(s0)
 140:	fc043783          	ld	a5,-64(s0)
 144:	fb843803          	ld	a6,-72(s0)
 148:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(   //调用ecall
 14c:	00000073          	ecall
 150:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
 154:	fe843503          	ld	a0,-24(s0)
 158:	6426                	ld	s0,72(sp)
 15a:	6161                	addi	sp,sp,80
 15c:	8082                	ret

000000000000015e <fork>:

//复制一个新进程
uint64 fork(){
 15e:	1141                	addi	sp,sp,-16
 160:	e406                	sd	ra,8(sp)
 162:	e022                	sd	s0,0(sp)
 164:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
 166:	4885                	li	a7,1
 168:	4801                	li	a6,0
 16a:	4781                	li	a5,0
 16c:	4701                	li	a4,0
 16e:	4681                	li	a3,0
 170:	4601                	li	a2,0
 172:	4581                	li	a1,0
 174:	4501                	li	a0,0
 176:	00000097          	auipc	ra,0x0
 17a:	f90080e7          	jalr	-112(ra) # 106 <user_syscall>
}
 17e:	60a2                	ld	ra,8(sp)
 180:	6402                	ld	s0,0(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret

0000000000000186 <open>:

//打开文件
uint64 open(char *file_name, int mode){
 186:	1141                	addi	sp,sp,-16
 188:	e406                	sd	ra,8(sp)
 18a:	e022                	sd	s0,0(sp)
 18c:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
 18e:	48bd                	li	a7,15
 190:	4801                	li	a6,0
 192:	4781                	li	a5,0
 194:	4701                	li	a4,0
 196:	4681                	li	a3,0
 198:	4601                	li	a2,0
 19a:	00000097          	auipc	ra,0x0
 19e:	f6c080e7          	jalr	-148(ra) # 106 <user_syscall>
}
 1a2:	60a2                	ld	ra,8(sp)
 1a4:	6402                	ld	s0,0(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <read>:

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
 1b2:	4895                	li	a7,5
 1b4:	4801                	li	a6,0
 1b6:	4781                	li	a5,0
 1b8:	4701                	li	a4,0
 1ba:	4681                	li	a3,0
 1bc:	00000097          	auipc	ra,0x0
 1c0:	f4a080e7          	jalr	-182(ra) # 106 <user_syscall>
}
 1c4:	60a2                	ld	ra,8(sp)
 1c6:	6402                	ld	s0,0(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <kill>:

//根据pid杀死进程
uint64 kill(uint64 pid){
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e406                	sd	ra,8(sp)
 1d0:	e022                	sd	s0,0(sp)
 1d2:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
 1d4:	4899                	li	a7,6
 1d6:	4801                	li	a6,0
 1d8:	4781                	li	a5,0
 1da:	4701                	li	a4,0
 1dc:	4681                	li	a3,0
 1de:	4601                	li	a2,0
 1e0:	4581                	li	a1,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	f24080e7          	jalr	-220(ra) # 106 <user_syscall>
}
 1ea:	60a2                	ld	ra,8(sp)
 1ec:	6402                	ld	s0,0(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret

00000000000001f2 <execve>:

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e406                	sd	ra,8(sp)
 1f6:	e022                	sd	s0,0(sp)
 1f8:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
 1fa:	0dd00893          	li	a7,221
 1fe:	4801                	li	a6,0
 200:	4781                	li	a5,0
 202:	4701                	li	a4,0
 204:	4681                	li	a3,0
 206:	00000097          	auipc	ra,0x0
 20a:	f00080e7          	jalr	-256(ra) # 106 <user_syscall>
}
 20e:	60a2                	ld	ra,8(sp)
 210:	6402                	ld	s0,0(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret

0000000000000216 <simple_read>:

//从键盘输入字符串
uint64 simple_read(char *s, size_t n){
 216:	1141                	addi	sp,sp,-16
 218:	e406                	sd	ra,8(sp)
 21a:	e022                	sd	s0,0(sp)
 21c:	0800                	addi	s0,sp,16
    return user_syscall(0,(uint64)s,n,0,0,0,0,SYS_simple_read);
 21e:	06300893          	li	a7,99
 222:	4801                	li	a6,0
 224:	4781                	li	a5,0
 226:	4701                	li	a4,0
 228:	4681                	li	a3,0
 22a:	862e                	mv	a2,a1
 22c:	85aa                	mv	a1,a0
 22e:	4501                	li	a0,0
 230:	00000097          	auipc	ra,0x0
 234:	ed6080e7          	jalr	-298(ra) # 106 <user_syscall>
}
 238:	60a2                	ld	ra,8(sp)
 23a:	6402                	ld	s0,0(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret

0000000000000240 <simple_write>:

//输出字符串到屏幕
uint64 simple_write(char *s, size_t n){
 240:	1141                	addi	sp,sp,-16
 242:	e406                	sd	ra,8(sp)
 244:	e022                	sd	s0,0(sp)
 246:	0800                	addi	s0,sp,16
    return user_syscall(1,(uint64)s,n,0,0,0,0,SYS_simple_write);
 248:	06400893          	li	a7,100
 24c:	4801                	li	a6,0
 24e:	4781                	li	a5,0
 250:	4701                	li	a4,0
 252:	4681                	li	a3,0
 254:	862e                	mv	a2,a1
 256:	85aa                	mv	a1,a0
 258:	4505                	li	a0,1
 25a:	00000097          	auipc	ra,0x0
 25e:	eac080e7          	jalr	-340(ra) # 106 <user_syscall>
}
 262:	60a2                	ld	ra,8(sp)
 264:	6402                	ld	s0,0(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret

000000000000026a <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
 26a:	1141                	addi	sp,sp,-16
 26c:	e406                	sd	ra,8(sp)
 26e:	e022                	sd	s0,0(sp)
 270:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
 272:	48d5                	li	a7,21
 274:	4801                	li	a6,0
 276:	4781                	li	a5,0
 278:	4701                	li	a4,0
 27a:	4681                	li	a3,0
 27c:	4601                	li	a2,0
 27e:	4581                	li	a1,0
 280:	00000097          	auipc	ra,0x0
 284:	e86080e7          	jalr	-378(ra) # 106 <user_syscall>
}
 288:	60a2                	ld	ra,8(sp)
 28a:	6402                	ld	s0,0(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret

0000000000000290 <clone>:

uint64 clone(uint64 flag, void *stack, size_t sz){
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
    if(stack!=NULL)
 298:	c191                	beqz	a1,29c <clone+0xc>
        stack+=sz;
 29a:	95b2                	add	a1,a1,a2
    return user_syscall(flag,(uint64)stack,0,0,0,0,0,SYS_clone);
 29c:	0dc00893          	li	a7,220
 2a0:	4801                	li	a6,0
 2a2:	4781                	li	a5,0
 2a4:	4701                	li	a4,0
 2a6:	4681                	li	a3,0
 2a8:	4601                	li	a2,0
 2aa:	00000097          	auipc	ra,0x0
 2ae:	e5c080e7          	jalr	-420(ra) # 106 <user_syscall>
}
 2b2:	60a2                	ld	ra,8(sp)
 2b4:	6402                	ld	s0,0(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <wait4>:

uint64 wait4(int pid, int *status, uint64 options){
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e406                	sd	ra,8(sp)
 2be:	e022                	sd	s0,0(sp)
 2c0:	0800                	addi	s0,sp,16
    return user_syscall((uint64)pid,(uint64)status,options,0,0,0,0,SYS_wait4);
 2c2:	10400893          	li	a7,260
 2c6:	4801                	li	a6,0
 2c8:	4781                	li	a5,0
 2ca:	4701                	li	a4,0
 2cc:	4681                	li	a3,0
 2ce:	00000097          	auipc	ra,0x0
 2d2:	e38080e7          	jalr	-456(ra) # 106 <user_syscall>
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <exit>:

//进程退出
uint64 exit(int code){
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
 2e6:	05d00893          	li	a7,93
 2ea:	4801                	li	a6,0
 2ec:	4781                	li	a5,0
 2ee:	4701                	li	a4,0
 2f0:	4681                	li	a3,0
 2f2:	4601                	li	a2,0
 2f4:	4581                	li	a1,0
 2f6:	00000097          	auipc	ra,0x0
 2fa:	e10080e7          	jalr	-496(ra) # 106 <user_syscall>
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <getppid>:

//获取父进程pid
uint64 getppid(){
 306:	1141                	addi	sp,sp,-16
 308:	e406                	sd	ra,8(sp)
 30a:	e022                	sd	s0,0(sp)
 30c:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getppid);
 30e:	0ad00893          	li	a7,173
 312:	4801                	li	a6,0
 314:	4781                	li	a5,0
 316:	4701                	li	a4,0
 318:	4681                	li	a3,0
 31a:	4601                	li	a2,0
 31c:	4581                	li	a1,0
 31e:	4501                	li	a0,0
 320:	00000097          	auipc	ra,0x0
 324:	de6080e7          	jalr	-538(ra) # 106 <user_syscall>
}
 328:	60a2                	ld	ra,8(sp)
 32a:	6402                	ld	s0,0(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret

0000000000000330 <getpid>:

//获取当前进程pid
uint64 getpid(){
 330:	1141                	addi	sp,sp,-16
 332:	e406                	sd	ra,8(sp)
 334:	e022                	sd	s0,0(sp)
 336:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getpid);
 338:	0ac00893          	li	a7,172
 33c:	4801                	li	a6,0
 33e:	4781                	li	a5,0
 340:	4701                	li	a4,0
 342:	4681                	li	a3,0
 344:	4601                	li	a2,0
 346:	4581                	li	a1,0
 348:	4501                	li	a0,0
 34a:	00000097          	auipc	ra,0x0
 34e:	dbc080e7          	jalr	-580(ra) # 106 <user_syscall>
}
 352:	60a2                	ld	ra,8(sp)
 354:	6402                	ld	s0,0(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret

000000000000035a <brk>:

//改变进程堆内存大小，当addr为0时，返回当前进程大小
int brk(uint64 addr){
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
    return (int)user_syscall(addr,0,0,0,0,0,0,SYS_brk);
 362:	0d600893          	li	a7,214
 366:	4801                	li	a6,0
 368:	4781                	li	a5,0
 36a:	4701                	li	a4,0
 36c:	4681                	li	a3,0
 36e:	4601                	li	a2,0
 370:	4581                	li	a1,0
 372:	00000097          	auipc	ra,0x0
 376:	d94080e7          	jalr	-620(ra) # 106 <user_syscall>
}
 37a:	2501                	sext.w	a0,a0
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <sched_yield>:

//进程放弃cpu
uint64 sched_yield(){
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_sched_yield);
 38c:	07c00893          	li	a7,124
 390:	4801                	li	a6,0
 392:	4781                	li	a5,0
 394:	4701                	li	a4,0
 396:	4681                	li	a3,0
 398:	4601                	li	a2,0
 39a:	4581                	li	a1,0
 39c:	4501                	li	a0,0
 39e:	00000097          	auipc	ra,0x0
 3a2:	d68080e7          	jalr	-664(ra) # 106 <user_syscall>
 3a6:	60a2                	ld	ra,8(sp)
 3a8:	6402                	ld	s0,0(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret

00000000000003ae <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
 3ae:	00064783          	lbu	a5,0(a2)
 3b2:	20078c63          	beqz	a5,5ca <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
 3b6:	715d                	addi	sp,sp,-80
 3b8:	e4a2                	sd	s0,72(sp)
 3ba:	e0a6                	sd	s1,64(sp)
 3bc:	fc4a                	sd	s2,56(sp)
 3be:	f84e                	sd	s3,48(sp)
 3c0:	f452                	sd	s4,40(sp)
 3c2:	f056                	sd	s5,32(sp)
 3c4:	ec5a                	sd	s6,24(sp)
 3c6:	e85e                	sd	s7,16(sp)
 3c8:	e462                	sd	s8,8(sp)
 3ca:	e066                	sd	s9,0(sp)
 3cc:	0880                	addi	s0,sp,80
  size_t pos = 0;
 3ce:	4701                	li	a4,0
  int longarg = 0;
 3d0:	4b01                	li	s6,0
  int format = 0;
 3d2:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 3d4:	02500f93          	li	t6,37
      format = 1;
 3d8:	4285                	li	t0,1
      switch (*s) {
 3da:	4f55                	li	t5,21
 3dc:	00000317          	auipc	t1,0x0
 3e0:	33430313          	addi	t1,t1,820 # 710 <printf+0x12a>
          longarg = 0;
 3e4:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 3e6:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
 3e8:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 3ec:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 3ee:	58fd                	li	a7,-1
 3f0:	43bd                	li	t2,15
 3f2:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
 3f4:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
 3f8:	03000493          	li	s1,48
 3fc:	aabd                	j	57a <vsnprintf+0x1cc>
          longarg = 1;
 3fe:	8b56                	mv	s6,s5
 400:	aa8d                	j	572 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
 402:	00170793          	addi	a5,a4,1
 406:	00b7f663          	bgeu	a5,a1,412 <vsnprintf+0x64>
 40a:	00e50ab3          	add	s5,a0,a4
 40e:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
 412:	0709                	addi	a4,a4,2
 414:	00b77563          	bgeu	a4,a1,41e <vsnprintf+0x70>
 418:	97aa                	add	a5,a5,a0
 41a:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 41e:	0006bc03          	ld	s8,0(a3)
 422:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 424:	8c9e                	mv	s9,t2
 426:	8b66                	mv	s6,s9
 428:	8aba                	mv	s5,a4
 42a:	a839                	j	448 <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 42c:	fe0b19e3          	bnez	s6,41e <vsnprintf+0x70>
 430:	0006ac03          	lw	s8,0(a3)
 434:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 436:	8cce                	mv	s9,s3
 438:	b7fd                	j	426 <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 43a:	015507b3          	add	a5,a0,s5
 43e:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 442:	3b7d                	addiw	s6,s6,-1
 444:	031b0163          	beq	s6,a7,466 <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 448:	0a85                	addi	s5,s5,1
 44a:	febafce3          	bgeu	s5,a1,442 <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
 44e:	002b179b          	slliw	a5,s6,0x2
 452:	40fc57b3          	sra	a5,s8,a5
 456:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 458:	05778b93          	addi	s7,a5,87
 45c:	fcfecfe3          	blt	t4,a5,43a <vsnprintf+0x8c>
 460:	03078b93          	addi	s7,a5,48
 464:	bfd9                	j	43a <vsnprintf+0x8c>
 466:	0705                	addi	a4,a4,1
 468:	9766                	add	a4,a4,s9
          longarg = 0;
 46a:	8b72                	mv	s6,t3
          format = 0;
 46c:	8af2                	mv	s5,t3
 46e:	a211                	j	572 <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 470:	020b0663          	beqz	s6,49c <vsnprintf+0xee>
 474:	0006ba83          	ld	s5,0(a3)
 478:	06a1                	addi	a3,a3,8
          if (num < 0) {
 47a:	020ac563          	bltz	s5,4a4 <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
 47e:	030ac7b3          	div	a5,s5,a6
 482:	cf95                	beqz	a5,4be <vsnprintf+0x110>
          long digits = 1;
 484:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 486:	0b05                	addi	s6,s6,1
 488:	0307c7b3          	div	a5,a5,a6
 48c:	ffed                	bnez	a5,486 <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 48e:	fffb079b          	addiw	a5,s6,-1
 492:	0407ce63          	bltz	a5,4ee <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 496:	00170c93          	addi	s9,a4,1
 49a:	a825                	j	4d2 <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 49c:	0006aa83          	lw	s5,0(a3)
 4a0:	06a1                	addi	a3,a3,8
 4a2:	bfe1                	j	47a <vsnprintf+0xcc>
            num = -num;
 4a4:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
 4a8:	00170793          	addi	a5,a4,1
 4ac:	00b7f763          	bgeu	a5,a1,4ba <vsnprintf+0x10c>
 4b0:	972a                	add	a4,a4,a0
 4b2:	01470023          	sb	s4,0(a4)
 4b6:	873e                	mv	a4,a5
 4b8:	b7d9                	j	47e <vsnprintf+0xd0>
 4ba:	873e                	mv	a4,a5
 4bc:	b7c9                	j	47e <vsnprintf+0xd0>
          long digits = 1;
 4be:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 4c0:	87f2                	mv	a5,t3
 4c2:	bfd1                	j	496 <vsnprintf+0xe8>
            num /= 10;
 4c4:	030acab3          	div	s5,s5,a6
 4c8:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
 4ca:	02079b93          	slli	s7,a5,0x20
 4ce:	020bc063          	bltz	s7,4ee <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 4d2:	00fc8bb3          	add	s7,s9,a5
 4d6:	febbf7e3          	bgeu	s7,a1,4c4 <vsnprintf+0x116>
 4da:	00f70bb3          	add	s7,a4,a5
 4de:	9baa                	add	s7,s7,a0
 4e0:	030aec33          	rem	s8,s5,a6
 4e4:	030c0c1b          	addiw	s8,s8,48
 4e8:	018b8023          	sb	s8,0(s7)
 4ec:	bfe1                	j	4c4 <vsnprintf+0x116>
          pos += digits;
 4ee:	975a                	add	a4,a4,s6
          longarg = 0;
 4f0:	8b72                	mv	s6,t3
          format = 0;
 4f2:	8af2                	mv	s5,t3
          break;
 4f4:	a8bd                	j	572 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 4f6:	00868b93          	addi	s7,a3,8
 4fa:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
 4fe:	000ac683          	lbu	a3,0(s5)
 502:	ceb9                	beqz	a3,560 <vsnprintf+0x1b2>
 504:	87ba                	mv	a5,a4
 506:	a039                	j	514 <vsnprintf+0x166>
 508:	40e786b3          	sub	a3,a5,a4
 50c:	96d6                	add	a3,a3,s5
 50e:	0006c683          	lbu	a3,0(a3)
 512:	ca89                	beqz	a3,524 <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
 514:	0785                	addi	a5,a5,1
 516:	feb7f9e3          	bgeu	a5,a1,508 <vsnprintf+0x15a>
 51a:	00f50b33          	add	s6,a0,a5
 51e:	fedb0fa3          	sb	a3,-1(s6)
 522:	b7dd                	j	508 <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
 524:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 526:	873e                	mv	a4,a5
          longarg = 0;
 528:	8b72                	mv	s6,t3
          format = 0;
 52a:	8af2                	mv	s5,t3
 52c:	a099                	j	572 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 52e:	00170793          	addi	a5,a4,1
 532:	02b7fb63          	bgeu	a5,a1,568 <vsnprintf+0x1ba>
 536:	972a                	add	a4,a4,a0
 538:	0006aa83          	lw	s5,0(a3)
 53c:	01570023          	sb	s5,0(a4)
 540:	06a1                	addi	a3,a3,8
 542:	873e                	mv	a4,a5
          longarg = 0;
 544:	8b72                	mv	s6,t3
          format = 0;
 546:	8af2                	mv	s5,t3
 548:	a02d                	j	572 <vsnprintf+0x1c4>
    } else if (*s == '%')
 54a:	03f78363          	beq	a5,t6,570 <vsnprintf+0x1c2>
    else if (++pos < n)
 54e:	00170b93          	addi	s7,a4,1
 552:	04bbf263          	bgeu	s7,a1,596 <vsnprintf+0x1e8>
      out[pos - 1] = *s;
 556:	972a                	add	a4,a4,a0
 558:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
 55c:	875e                	mv	a4,s7
 55e:	a811                	j	572 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 560:	86de                	mv	a3,s7
          longarg = 0;
 562:	8b72                	mv	s6,t3
          format = 0;
 564:	8af2                	mv	s5,t3
 566:	a031                	j	572 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 568:	873e                	mv	a4,a5
          longarg = 0;
 56a:	8b72                	mv	s6,t3
          format = 0;
 56c:	8af2                	mv	s5,t3
 56e:	a011                	j	572 <vsnprintf+0x1c4>
      format = 1;
 570:	8a96                	mv	s5,t0
  for (; *s; s++) {
 572:	0605                	addi	a2,a2,1
 574:	00064783          	lbu	a5,0(a2)
 578:	c38d                	beqz	a5,59a <vsnprintf+0x1ec>
    if (format) {
 57a:	fc0a88e3          	beqz	s5,54a <vsnprintf+0x19c>
      switch (*s) {
 57e:	f9d7879b          	addiw	a5,a5,-99
 582:	0ff7fb93          	andi	s7,a5,255
 586:	ff7f66e3          	bltu	t5,s7,572 <vsnprintf+0x1c4>
 58a:	002b9793          	slli	a5,s7,0x2
 58e:	979a                	add	a5,a5,t1
 590:	439c                	lw	a5,0(a5)
 592:	979a                	add	a5,a5,t1
 594:	8782                	jr	a5
    else if (++pos < n)
 596:	875e                	mv	a4,s7
 598:	bfe9                	j	572 <vsnprintf+0x1c4>
  }
  if (pos < n)
 59a:	02b77363          	bgeu	a4,a1,5c0 <vsnprintf+0x212>
    out[pos] = 0;
 59e:	953a                	add	a0,a0,a4
 5a0:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 5a4:	0007051b          	sext.w	a0,a4
 5a8:	6426                	ld	s0,72(sp)
 5aa:	6486                	ld	s1,64(sp)
 5ac:	7962                	ld	s2,56(sp)
 5ae:	79c2                	ld	s3,48(sp)
 5b0:	7a22                	ld	s4,40(sp)
 5b2:	7a82                	ld	s5,32(sp)
 5b4:	6b62                	ld	s6,24(sp)
 5b6:	6bc2                	ld	s7,16(sp)
 5b8:	6c22                	ld	s8,8(sp)
 5ba:	6c82                	ld	s9,0(sp)
 5bc:	6161                	addi	sp,sp,80
 5be:	8082                	ret
  else if (n)
 5c0:	d1f5                	beqz	a1,5a4 <vsnprintf+0x1f6>
    out[n - 1] = 0;
 5c2:	95aa                	add	a1,a1,a0
 5c4:	fe058fa3          	sb	zero,-1(a1)
 5c8:	bff1                	j	5a4 <vsnprintf+0x1f6>
  size_t pos = 0;
 5ca:	4701                	li	a4,0
  if (pos < n)
 5cc:	00b77863          	bgeu	a4,a1,5dc <vsnprintf+0x22e>
    out[pos] = 0;
 5d0:	953a                	add	a0,a0,a4
 5d2:	00050023          	sb	zero,0(a0)
}
 5d6:	0007051b          	sext.w	a0,a4
 5da:	8082                	ret
  else if (n)
 5dc:	dded                	beqz	a1,5d6 <vsnprintf+0x228>
    out[n - 1] = 0;
 5de:	95aa                	add	a1,a1,a0
 5e0:	fe058fa3          	sb	zero,-1(a1)
 5e4:	bfcd                	j	5d6 <vsnprintf+0x228>

00000000000005e6 <printf>:
int printf(char*s, ...){
 5e6:	710d                	addi	sp,sp,-352
 5e8:	ee06                	sd	ra,280(sp)
 5ea:	ea22                	sd	s0,272(sp)
 5ec:	1200                	addi	s0,sp,288
 5ee:	e40c                	sd	a1,8(s0)
 5f0:	e810                	sd	a2,16(s0)
 5f2:	ec14                	sd	a3,24(s0)
 5f4:	f018                	sd	a4,32(s0)
 5f6:	f41c                	sd	a5,40(s0)
 5f8:	03043823          	sd	a6,48(s0)
 5fc:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 600:	00840693          	addi	a3,s0,8
 604:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 608:	862a                	mv	a2,a0
 60a:	10000593          	li	a1,256
 60e:	ee840513          	addi	a0,s0,-280
 612:	00000097          	auipc	ra,0x0
 616:	d9c080e7          	jalr	-612(ra) # 3ae <vsnprintf>
 61a:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 61c:	0005071b          	sext.w	a4,a0
 620:	0ff00793          	li	a5,255
 624:	00e7f463          	bgeu	a5,a4,62c <printf+0x46>
 628:	10000593          	li	a1,256
    return simple_write(buf, n);
 62c:	ee840513          	addi	a0,s0,-280
 630:	00000097          	auipc	ra,0x0
 634:	c10080e7          	jalr	-1008(ra) # 240 <simple_write>
}
 638:	2501                	sext.w	a0,a0
 63a:	60f2                	ld	ra,280(sp)
 63c:	6452                	ld	s0,272(sp)
 63e:	6135                	addi	sp,sp,352
 640:	8082                	ret
