
target/test：     文件格式 elf64-littleriscv


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
    printf("\nwait4 test begin\n");
   c:	00000517          	auipc	a0,0x0
  10:	60450513          	addi	a0,a0,1540 # 610 <printf+0x84>
  14:	00000097          	auipc	ra,0x0
  18:	578080e7          	jalr	1400(ra) # 58c <printf>
    
    int pid=fork();
  1c:	00000097          	auipc	ra,0x0
  20:	112080e7          	jalr	274(ra) # 12e <fork>

    if(pid==0){
  24:	2501                	sext.w	a0,a0
  26:	ed25                	bnez	a0,9e <main+0x9e>
        char *argv[5]={"wait4 ", "and ","execve ", "test!\n", NULL};
  28:	00000797          	auipc	a5,0x0
  2c:	5c078793          	addi	a5,a5,1472 # 5e8 <printf+0x5c>
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
  5c:	534080e7          	jalr	1332(ra) # 58c <printf>
  60:	04a1                	addi	s1,s1,8
        for(int i=0;i<4;i++){
  62:	ff249ae3          	bne	s1,s2,56 <main+0x56>
        }
        printf("\n...................................\n\n");
  66:	00000517          	auipc	a0,0x0
  6a:	5c250513          	addi	a0,a0,1474 # 628 <printf+0x9c>
  6e:	00000097          	auipc	ra,0x0
  72:	51e080e7          	jalr	1310(ra) # 58c <printf>
        execve("main",argv, NULL);
  76:	4601                	li	a2,0
  78:	fb840593          	addi	a1,s0,-72
  7c:	00000517          	auipc	a0,0x0
  80:	5d450513          	addi	a0,a0,1492 # 650 <printf+0xc4>
  84:	00000097          	auipc	ra,0x0
  88:	13e080e7          	jalr	318(ra) # 1c2 <execve>
        int ret=wait4(-1,&status,0);
        status=status>>8;
        printf("ret=%d, status=%d\n",ret,status);
    }

    printf("\nwait4 test end\n");
  8c:	00000517          	auipc	a0,0x0
  90:	5e450513          	addi	a0,a0,1508 # 670 <printf+0xe4>
  94:	00000097          	auipc	ra,0x0
  98:	4f8080e7          	jalr	1272(ra) # 58c <printf>

    while(1){
    }
  9c:	a001                	j	9c <main+0x9c>
        int status=0;
  9e:	fa042c23          	sw	zero,-72(s0)
        int ret=wait4(-1,&status,0);
  a2:	4601                	li	a2,0
  a4:	fb840593          	addi	a1,s0,-72
  a8:	557d                	li	a0,-1
  aa:	00000097          	auipc	ra,0x0
  ae:	1e0080e7          	jalr	480(ra) # 28a <wait4>
        status=status>>8;
  b2:	fb842603          	lw	a2,-72(s0)
  b6:	4086561b          	sraiw	a2,a2,0x8
  ba:	fac42c23          	sw	a2,-72(s0)
        printf("ret=%d, status=%d\n",ret,status);
  be:	2601                	sext.w	a2,a2
  c0:	0005059b          	sext.w	a1,a0
  c4:	00000517          	auipc	a0,0x0
  c8:	59450513          	addi	a0,a0,1428 # 658 <printf+0xcc>
  cc:	00000097          	auipc	ra,0x0
  d0:	4c0080e7          	jalr	1216(ra) # 58c <printf>
  d4:	bf65                	j	8c <main+0x8c>

00000000000000d6 <user_syscall>:
/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
  d6:	715d                	addi	sp,sp,-80
  d8:	e4a2                	sd	s0,72(sp)
  da:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
  dc:	fea43423          	sd	a0,-24(s0)
  e0:	feb43023          	sd	a1,-32(s0)
  e4:	fcc43c23          	sd	a2,-40(s0)
  e8:	fcd43823          	sd	a3,-48(s0)
  ec:	fce43423          	sd	a4,-56(s0)
  f0:	fcf43023          	sd	a5,-64(s0)
  f4:	fb043c23          	sd	a6,-72(s0)
  f8:	fb143823          	sd	a7,-80(s0)
        asm volatile(   //将参数写入a0-a7寄存器
  fc:	fe843503          	ld	a0,-24(s0)
 100:	fe043583          	ld	a1,-32(s0)
 104:	fd843603          	ld	a2,-40(s0)
 108:	fd043683          	ld	a3,-48(s0)
 10c:	fc843703          	ld	a4,-56(s0)
 110:	fc043783          	ld	a5,-64(s0)
 114:	fb843803          	ld	a6,-72(s0)
 118:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(   //调用ecall
 11c:	00000073          	ecall
 120:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
 124:	fe843503          	ld	a0,-24(s0)
 128:	6426                	ld	s0,72(sp)
 12a:	6161                	addi	sp,sp,80
 12c:	8082                	ret

000000000000012e <fork>:

//复制一个新进程
uint64 fork(){
 12e:	1141                	addi	sp,sp,-16
 130:	e406                	sd	ra,8(sp)
 132:	e022                	sd	s0,0(sp)
 134:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
 136:	4885                	li	a7,1
 138:	4801                	li	a6,0
 13a:	4781                	li	a5,0
 13c:	4701                	li	a4,0
 13e:	4681                	li	a3,0
 140:	4601                	li	a2,0
 142:	4581                	li	a1,0
 144:	4501                	li	a0,0
 146:	00000097          	auipc	ra,0x0
 14a:	f90080e7          	jalr	-112(ra) # d6 <user_syscall>
}
 14e:	60a2                	ld	ra,8(sp)
 150:	6402                	ld	s0,0(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <open>:

//打开文件
uint64 open(char *file_name, int mode){
 156:	1141                	addi	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
 15e:	48bd                	li	a7,15
 160:	4801                	li	a6,0
 162:	4781                	li	a5,0
 164:	4701                	li	a4,0
 166:	4681                	li	a3,0
 168:	4601                	li	a2,0
 16a:	00000097          	auipc	ra,0x0
 16e:	f6c080e7          	jalr	-148(ra) # d6 <user_syscall>
}
 172:	60a2                	ld	ra,8(sp)
 174:	6402                	ld	s0,0(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret

000000000000017a <read>:

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
 17a:	1141                	addi	sp,sp,-16
 17c:	e406                	sd	ra,8(sp)
 17e:	e022                	sd	s0,0(sp)
 180:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
 182:	4895                	li	a7,5
 184:	4801                	li	a6,0
 186:	4781                	li	a5,0
 188:	4701                	li	a4,0
 18a:	4681                	li	a3,0
 18c:	00000097          	auipc	ra,0x0
 190:	f4a080e7          	jalr	-182(ra) # d6 <user_syscall>
}
 194:	60a2                	ld	ra,8(sp)
 196:	6402                	ld	s0,0(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <kill>:

//根据pid杀死进程
uint64 kill(uint64 pid){
 19c:	1141                	addi	sp,sp,-16
 19e:	e406                	sd	ra,8(sp)
 1a0:	e022                	sd	s0,0(sp)
 1a2:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
 1a4:	4899                	li	a7,6
 1a6:	4801                	li	a6,0
 1a8:	4781                	li	a5,0
 1aa:	4701                	li	a4,0
 1ac:	4681                	li	a3,0
 1ae:	4601                	li	a2,0
 1b0:	4581                	li	a1,0
 1b2:	00000097          	auipc	ra,0x0
 1b6:	f24080e7          	jalr	-220(ra) # d6 <user_syscall>
}
 1ba:	60a2                	ld	ra,8(sp)
 1bc:	6402                	ld	s0,0(sp)
 1be:	0141                	addi	sp,sp,16
 1c0:	8082                	ret

00000000000001c2 <execve>:

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
 1c2:	1141                	addi	sp,sp,-16
 1c4:	e406                	sd	ra,8(sp)
 1c6:	e022                	sd	s0,0(sp)
 1c8:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
 1ca:	0dd00893          	li	a7,221
 1ce:	4801                	li	a6,0
 1d0:	4781                	li	a5,0
 1d2:	4701                	li	a4,0
 1d4:	4681                	li	a3,0
 1d6:	00000097          	auipc	ra,0x0
 1da:	f00080e7          	jalr	-256(ra) # d6 <user_syscall>
}
 1de:	60a2                	ld	ra,8(sp)
 1e0:	6402                	ld	s0,0(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret

00000000000001e6 <simple_read>:

//从键盘输入字符串
uint64 simple_read(char *s, size_t n){
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e406                	sd	ra,8(sp)
 1ea:	e022                	sd	s0,0(sp)
 1ec:	0800                	addi	s0,sp,16
    return user_syscall(0,(uint64)s,n,0,0,0,0,SYS_simple_read);
 1ee:	06300893          	li	a7,99
 1f2:	4801                	li	a6,0
 1f4:	4781                	li	a5,0
 1f6:	4701                	li	a4,0
 1f8:	4681                	li	a3,0
 1fa:	862e                	mv	a2,a1
 1fc:	85aa                	mv	a1,a0
 1fe:	4501                	li	a0,0
 200:	00000097          	auipc	ra,0x0
 204:	ed6080e7          	jalr	-298(ra) # d6 <user_syscall>
}
 208:	60a2                	ld	ra,8(sp)
 20a:	6402                	ld	s0,0(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret

0000000000000210 <simple_write>:

//输出字符串到屏幕
uint64 simple_write(char *s, size_t n){
 210:	1141                	addi	sp,sp,-16
 212:	e406                	sd	ra,8(sp)
 214:	e022                	sd	s0,0(sp)
 216:	0800                	addi	s0,sp,16
    return user_syscall(1,(uint64)s,n,0,0,0,0,SYS_simple_write);
 218:	06400893          	li	a7,100
 21c:	4801                	li	a6,0
 21e:	4781                	li	a5,0
 220:	4701                	li	a4,0
 222:	4681                	li	a3,0
 224:	862e                	mv	a2,a1
 226:	85aa                	mv	a1,a0
 228:	4505                	li	a0,1
 22a:	00000097          	auipc	ra,0x0
 22e:	eac080e7          	jalr	-340(ra) # d6 <user_syscall>
}
 232:	60a2                	ld	ra,8(sp)
 234:	6402                	ld	s0,0(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret

000000000000023a <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
 23a:	1141                	addi	sp,sp,-16
 23c:	e406                	sd	ra,8(sp)
 23e:	e022                	sd	s0,0(sp)
 240:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
 242:	48d5                	li	a7,21
 244:	4801                	li	a6,0
 246:	4781                	li	a5,0
 248:	4701                	li	a4,0
 24a:	4681                	li	a3,0
 24c:	4601                	li	a2,0
 24e:	4581                	li	a1,0
 250:	00000097          	auipc	ra,0x0
 254:	e86080e7          	jalr	-378(ra) # d6 <user_syscall>
}
 258:	60a2                	ld	ra,8(sp)
 25a:	6402                	ld	s0,0(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret

0000000000000260 <clone>:

uint64 clone(uint64 flag, void *stack, size_t sz){
 260:	1141                	addi	sp,sp,-16
 262:	e406                	sd	ra,8(sp)
 264:	e022                	sd	s0,0(sp)
 266:	0800                	addi	s0,sp,16
    if(stack!=NULL)
 268:	c191                	beqz	a1,26c <clone+0xc>
        stack+=sz;
 26a:	95b2                	add	a1,a1,a2
    return user_syscall(flag,(uint64)stack,0,0,0,0,0,SYS_clone);
 26c:	0dc00893          	li	a7,220
 270:	4801                	li	a6,0
 272:	4781                	li	a5,0
 274:	4701                	li	a4,0
 276:	4681                	li	a3,0
 278:	4601                	li	a2,0
 27a:	00000097          	auipc	ra,0x0
 27e:	e5c080e7          	jalr	-420(ra) # d6 <user_syscall>
}
 282:	60a2                	ld	ra,8(sp)
 284:	6402                	ld	s0,0(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <wait4>:

uint64 wait4(int pid, int *status, uint64 options){
 28a:	1141                	addi	sp,sp,-16
 28c:	e406                	sd	ra,8(sp)
 28e:	e022                	sd	s0,0(sp)
 290:	0800                	addi	s0,sp,16
    return user_syscall((uint64)pid,(uint64)status,options,0,0,0,0,SYS_wait4);
 292:	10400893          	li	a7,260
 296:	4801                	li	a6,0
 298:	4781                	li	a5,0
 29a:	4701                	li	a4,0
 29c:	4681                	li	a3,0
 29e:	00000097          	auipc	ra,0x0
 2a2:	e38080e7          	jalr	-456(ra) # d6 <user_syscall>
}
 2a6:	60a2                	ld	ra,8(sp)
 2a8:	6402                	ld	s0,0(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret

00000000000002ae <exit>:

//进程退出
uint64 exit(int code){
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e406                	sd	ra,8(sp)
 2b2:	e022                	sd	s0,0(sp)
 2b4:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
 2b6:	05d00893          	li	a7,93
 2ba:	4801                	li	a6,0
 2bc:	4781                	li	a5,0
 2be:	4701                	li	a4,0
 2c0:	4681                	li	a3,0
 2c2:	4601                	li	a2,0
 2c4:	4581                	li	a1,0
 2c6:	00000097          	auipc	ra,0x0
 2ca:	e10080e7          	jalr	-496(ra) # d6 <user_syscall>
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret

00000000000002d6 <getppid>:

//获取父进程pid
uint64 getppid(){
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getppid);
 2de:	0ad00893          	li	a7,173
 2e2:	4801                	li	a6,0
 2e4:	4781                	li	a5,0
 2e6:	4701                	li	a4,0
 2e8:	4681                	li	a3,0
 2ea:	4601                	li	a2,0
 2ec:	4581                	li	a1,0
 2ee:	4501                	li	a0,0
 2f0:	00000097          	auipc	ra,0x0
 2f4:	de6080e7          	jalr	-538(ra) # d6 <user_syscall>
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <getpid>:

//获取当前进程pid
uint64 getpid(){
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getpid);
 308:	0ac00893          	li	a7,172
 30c:	4801                	li	a6,0
 30e:	4781                	li	a5,0
 310:	4701                	li	a4,0
 312:	4681                	li	a3,0
 314:	4601                	li	a2,0
 316:	4581                	li	a1,0
 318:	4501                	li	a0,0
 31a:	00000097          	auipc	ra,0x0
 31e:	dbc080e7          	jalr	-580(ra) # d6 <user_syscall>
}
 322:	60a2                	ld	ra,8(sp)
 324:	6402                	ld	s0,0(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret

000000000000032a <sched_yield>:

uint64 sched_yield(){
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_sched_yield);
 332:	07c00893          	li	a7,124
 336:	4801                	li	a6,0
 338:	4781                	li	a5,0
 33a:	4701                	li	a4,0
 33c:	4681                	li	a3,0
 33e:	4601                	li	a2,0
 340:	4581                	li	a1,0
 342:	4501                	li	a0,0
 344:	00000097          	auipc	ra,0x0
 348:	d92080e7          	jalr	-622(ra) # d6 <user_syscall>
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
 354:	00064783          	lbu	a5,0(a2)
 358:	20078c63          	beqz	a5,570 <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
 35c:	715d                	addi	sp,sp,-80
 35e:	e4a2                	sd	s0,72(sp)
 360:	e0a6                	sd	s1,64(sp)
 362:	fc4a                	sd	s2,56(sp)
 364:	f84e                	sd	s3,48(sp)
 366:	f452                	sd	s4,40(sp)
 368:	f056                	sd	s5,32(sp)
 36a:	ec5a                	sd	s6,24(sp)
 36c:	e85e                	sd	s7,16(sp)
 36e:	e462                	sd	s8,8(sp)
 370:	e066                	sd	s9,0(sp)
 372:	0880                	addi	s0,sp,80
  size_t pos = 0;
 374:	4701                	li	a4,0
  int longarg = 0;
 376:	4b01                	li	s6,0
  int format = 0;
 378:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 37a:	02500f93          	li	t6,37
      format = 1;
 37e:	4285                	li	t0,1
      switch (*s) {
 380:	4f55                	li	t5,21
 382:	00000317          	auipc	t1,0x0
 386:	32630313          	addi	t1,t1,806 # 6a8 <printf+0x11c>
          longarg = 0;
 38a:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 38c:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
 38e:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 392:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 394:	58fd                	li	a7,-1
 396:	43bd                	li	t2,15
 398:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
 39a:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
 39e:	03000493          	li	s1,48
 3a2:	aabd                	j	520 <vsnprintf+0x1cc>
          longarg = 1;
 3a4:	8b56                	mv	s6,s5
 3a6:	aa8d                	j	518 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
 3a8:	00170793          	addi	a5,a4,1
 3ac:	00b7f663          	bgeu	a5,a1,3b8 <vsnprintf+0x64>
 3b0:	00e50ab3          	add	s5,a0,a4
 3b4:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
 3b8:	0709                	addi	a4,a4,2
 3ba:	00b77563          	bgeu	a4,a1,3c4 <vsnprintf+0x70>
 3be:	97aa                	add	a5,a5,a0
 3c0:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 3c4:	0006bc03          	ld	s8,0(a3)
 3c8:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 3ca:	8c9e                	mv	s9,t2
 3cc:	8b66                	mv	s6,s9
 3ce:	8aba                	mv	s5,a4
 3d0:	a839                	j	3ee <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 3d2:	fe0b19e3          	bnez	s6,3c4 <vsnprintf+0x70>
 3d6:	0006ac03          	lw	s8,0(a3)
 3da:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 3dc:	8cce                	mv	s9,s3
 3de:	b7fd                	j	3cc <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 3e0:	015507b3          	add	a5,a0,s5
 3e4:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 3e8:	3b7d                	addiw	s6,s6,-1
 3ea:	031b0163          	beq	s6,a7,40c <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 3ee:	0a85                	addi	s5,s5,1
 3f0:	febafce3          	bgeu	s5,a1,3e8 <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
 3f4:	002b179b          	slliw	a5,s6,0x2
 3f8:	40fc57b3          	sra	a5,s8,a5
 3fc:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 3fe:	05778b93          	addi	s7,a5,87
 402:	fcfecfe3          	blt	t4,a5,3e0 <vsnprintf+0x8c>
 406:	03078b93          	addi	s7,a5,48
 40a:	bfd9                	j	3e0 <vsnprintf+0x8c>
 40c:	0705                	addi	a4,a4,1
 40e:	9766                	add	a4,a4,s9
          longarg = 0;
 410:	8b72                	mv	s6,t3
          format = 0;
 412:	8af2                	mv	s5,t3
 414:	a211                	j	518 <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 416:	020b0663          	beqz	s6,442 <vsnprintf+0xee>
 41a:	0006ba83          	ld	s5,0(a3)
 41e:	06a1                	addi	a3,a3,8
          if (num < 0) {
 420:	020ac563          	bltz	s5,44a <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
 424:	030ac7b3          	div	a5,s5,a6
 428:	cf95                	beqz	a5,464 <vsnprintf+0x110>
          long digits = 1;
 42a:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 42c:	0b05                	addi	s6,s6,1
 42e:	0307c7b3          	div	a5,a5,a6
 432:	ffed                	bnez	a5,42c <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 434:	fffb079b          	addiw	a5,s6,-1
 438:	0407ce63          	bltz	a5,494 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 43c:	00170c93          	addi	s9,a4,1
 440:	a825                	j	478 <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 442:	0006aa83          	lw	s5,0(a3)
 446:	06a1                	addi	a3,a3,8
 448:	bfe1                	j	420 <vsnprintf+0xcc>
            num = -num;
 44a:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
 44e:	00170793          	addi	a5,a4,1
 452:	00b7f763          	bgeu	a5,a1,460 <vsnprintf+0x10c>
 456:	972a                	add	a4,a4,a0
 458:	01470023          	sb	s4,0(a4)
 45c:	873e                	mv	a4,a5
 45e:	b7d9                	j	424 <vsnprintf+0xd0>
 460:	873e                	mv	a4,a5
 462:	b7c9                	j	424 <vsnprintf+0xd0>
          long digits = 1;
 464:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 466:	87f2                	mv	a5,t3
 468:	bfd1                	j	43c <vsnprintf+0xe8>
            num /= 10;
 46a:	030acab3          	div	s5,s5,a6
 46e:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
 470:	02079b93          	slli	s7,a5,0x20
 474:	020bc063          	bltz	s7,494 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 478:	00fc8bb3          	add	s7,s9,a5
 47c:	febbf7e3          	bgeu	s7,a1,46a <vsnprintf+0x116>
 480:	00f70bb3          	add	s7,a4,a5
 484:	9baa                	add	s7,s7,a0
 486:	030aec33          	rem	s8,s5,a6
 48a:	030c0c1b          	addiw	s8,s8,48
 48e:	018b8023          	sb	s8,0(s7)
 492:	bfe1                	j	46a <vsnprintf+0x116>
          pos += digits;
 494:	975a                	add	a4,a4,s6
          longarg = 0;
 496:	8b72                	mv	s6,t3
          format = 0;
 498:	8af2                	mv	s5,t3
          break;
 49a:	a8bd                	j	518 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 49c:	00868b93          	addi	s7,a3,8
 4a0:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
 4a4:	000ac683          	lbu	a3,0(s5)
 4a8:	ceb9                	beqz	a3,506 <vsnprintf+0x1b2>
 4aa:	87ba                	mv	a5,a4
 4ac:	a039                	j	4ba <vsnprintf+0x166>
 4ae:	40e786b3          	sub	a3,a5,a4
 4b2:	96d6                	add	a3,a3,s5
 4b4:	0006c683          	lbu	a3,0(a3)
 4b8:	ca89                	beqz	a3,4ca <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
 4ba:	0785                	addi	a5,a5,1
 4bc:	feb7f9e3          	bgeu	a5,a1,4ae <vsnprintf+0x15a>
 4c0:	00f50b33          	add	s6,a0,a5
 4c4:	fedb0fa3          	sb	a3,-1(s6)
 4c8:	b7dd                	j	4ae <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
 4ca:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 4cc:	873e                	mv	a4,a5
          longarg = 0;
 4ce:	8b72                	mv	s6,t3
          format = 0;
 4d0:	8af2                	mv	s5,t3
 4d2:	a099                	j	518 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 4d4:	00170793          	addi	a5,a4,1
 4d8:	02b7fb63          	bgeu	a5,a1,50e <vsnprintf+0x1ba>
 4dc:	972a                	add	a4,a4,a0
 4de:	0006aa83          	lw	s5,0(a3)
 4e2:	01570023          	sb	s5,0(a4)
 4e6:	06a1                	addi	a3,a3,8
 4e8:	873e                	mv	a4,a5
          longarg = 0;
 4ea:	8b72                	mv	s6,t3
          format = 0;
 4ec:	8af2                	mv	s5,t3
 4ee:	a02d                	j	518 <vsnprintf+0x1c4>
    } else if (*s == '%')
 4f0:	03f78363          	beq	a5,t6,516 <vsnprintf+0x1c2>
    else if (++pos < n)
 4f4:	00170b93          	addi	s7,a4,1
 4f8:	04bbf263          	bgeu	s7,a1,53c <vsnprintf+0x1e8>
      out[pos - 1] = *s;
 4fc:	972a                	add	a4,a4,a0
 4fe:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
 502:	875e                	mv	a4,s7
 504:	a811                	j	518 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 506:	86de                	mv	a3,s7
          longarg = 0;
 508:	8b72                	mv	s6,t3
          format = 0;
 50a:	8af2                	mv	s5,t3
 50c:	a031                	j	518 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 50e:	873e                	mv	a4,a5
          longarg = 0;
 510:	8b72                	mv	s6,t3
          format = 0;
 512:	8af2                	mv	s5,t3
 514:	a011                	j	518 <vsnprintf+0x1c4>
      format = 1;
 516:	8a96                	mv	s5,t0
  for (; *s; s++) {
 518:	0605                	addi	a2,a2,1
 51a:	00064783          	lbu	a5,0(a2)
 51e:	c38d                	beqz	a5,540 <vsnprintf+0x1ec>
    if (format) {
 520:	fc0a88e3          	beqz	s5,4f0 <vsnprintf+0x19c>
      switch (*s) {
 524:	f9d7879b          	addiw	a5,a5,-99
 528:	0ff7fb93          	andi	s7,a5,255
 52c:	ff7f66e3          	bltu	t5,s7,518 <vsnprintf+0x1c4>
 530:	002b9793          	slli	a5,s7,0x2
 534:	979a                	add	a5,a5,t1
 536:	439c                	lw	a5,0(a5)
 538:	979a                	add	a5,a5,t1
 53a:	8782                	jr	a5
    else if (++pos < n)
 53c:	875e                	mv	a4,s7
 53e:	bfe9                	j	518 <vsnprintf+0x1c4>
  }
  if (pos < n)
 540:	02b77363          	bgeu	a4,a1,566 <vsnprintf+0x212>
    out[pos] = 0;
 544:	953a                	add	a0,a0,a4
 546:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 54a:	0007051b          	sext.w	a0,a4
 54e:	6426                	ld	s0,72(sp)
 550:	6486                	ld	s1,64(sp)
 552:	7962                	ld	s2,56(sp)
 554:	79c2                	ld	s3,48(sp)
 556:	7a22                	ld	s4,40(sp)
 558:	7a82                	ld	s5,32(sp)
 55a:	6b62                	ld	s6,24(sp)
 55c:	6bc2                	ld	s7,16(sp)
 55e:	6c22                	ld	s8,8(sp)
 560:	6c82                	ld	s9,0(sp)
 562:	6161                	addi	sp,sp,80
 564:	8082                	ret
  else if (n)
 566:	d1f5                	beqz	a1,54a <vsnprintf+0x1f6>
    out[n - 1] = 0;
 568:	95aa                	add	a1,a1,a0
 56a:	fe058fa3          	sb	zero,-1(a1)
 56e:	bff1                	j	54a <vsnprintf+0x1f6>
  size_t pos = 0;
 570:	4701                	li	a4,0
  if (pos < n)
 572:	00b77863          	bgeu	a4,a1,582 <vsnprintf+0x22e>
    out[pos] = 0;
 576:	953a                	add	a0,a0,a4
 578:	00050023          	sb	zero,0(a0)
}
 57c:	0007051b          	sext.w	a0,a4
 580:	8082                	ret
  else if (n)
 582:	dded                	beqz	a1,57c <vsnprintf+0x228>
    out[n - 1] = 0;
 584:	95aa                	add	a1,a1,a0
 586:	fe058fa3          	sb	zero,-1(a1)
 58a:	bfcd                	j	57c <vsnprintf+0x228>

000000000000058c <printf>:
int printf(char*s, ...){
 58c:	710d                	addi	sp,sp,-352
 58e:	ee06                	sd	ra,280(sp)
 590:	ea22                	sd	s0,272(sp)
 592:	1200                	addi	s0,sp,288
 594:	e40c                	sd	a1,8(s0)
 596:	e810                	sd	a2,16(s0)
 598:	ec14                	sd	a3,24(s0)
 59a:	f018                	sd	a4,32(s0)
 59c:	f41c                	sd	a5,40(s0)
 59e:	03043823          	sd	a6,48(s0)
 5a2:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 5a6:	00840693          	addi	a3,s0,8
 5aa:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 5ae:	862a                	mv	a2,a0
 5b0:	10000593          	li	a1,256
 5b4:	ee840513          	addi	a0,s0,-280
 5b8:	00000097          	auipc	ra,0x0
 5bc:	d9c080e7          	jalr	-612(ra) # 354 <vsnprintf>
 5c0:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 5c2:	0005071b          	sext.w	a4,a0
 5c6:	0ff00793          	li	a5,255
 5ca:	00e7f463          	bgeu	a5,a4,5d2 <printf+0x46>
 5ce:	10000593          	li	a1,256
    return simple_write(buf, n);
 5d2:	ee840513          	addi	a0,s0,-280
 5d6:	00000097          	auipc	ra,0x0
 5da:	c3a080e7          	jalr	-966(ra) # 210 <simple_write>
}
 5de:	2501                	sext.w	a0,a0
 5e0:	60f2                	ld	ra,280(sp)
 5e2:	6452                	ld	s0,272(sp)
 5e4:	6135                	addi	sp,sp,352
 5e6:	8082                	ret
