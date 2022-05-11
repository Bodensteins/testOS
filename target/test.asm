
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
  10:	5d450513          	addi	a0,a0,1492 # 5e0 <printf+0x84>
  14:	00000097          	auipc	ra,0x0
  18:	548080e7          	jalr	1352(ra) # 55c <printf>
    
    int pid=fork();
  1c:	00000097          	auipc	ra,0x0
  20:	112080e7          	jalr	274(ra) # 12e <fork>

    if(pid==0){
  24:	2501                	sext.w	a0,a0
  26:	ed25                	bnez	a0,9e <main+0x9e>
        char *argv[5]={"wait4 ", "and ","execve ", "test!\n", NULL};
  28:	00000797          	auipc	a5,0x0
  2c:	59078793          	addi	a5,a5,1424 # 5b8 <printf+0x5c>
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
  5c:	504080e7          	jalr	1284(ra) # 55c <printf>
  60:	04a1                	addi	s1,s1,8
        for(int i=0;i<4;i++){
  62:	ff249ae3          	bne	s1,s2,56 <main+0x56>
        }
        printf("\n...................................\n\n");
  66:	00000517          	auipc	a0,0x0
  6a:	59250513          	addi	a0,a0,1426 # 5f8 <printf+0x9c>
  6e:	00000097          	auipc	ra,0x0
  72:	4ee080e7          	jalr	1262(ra) # 55c <printf>
        execve("main",argv, NULL);
  76:	4601                	li	a2,0
  78:	fb840593          	addi	a1,s0,-72
  7c:	00000517          	auipc	a0,0x0
  80:	5a450513          	addi	a0,a0,1444 # 620 <printf+0xc4>
  84:	00000097          	auipc	ra,0x0
  88:	13e080e7          	jalr	318(ra) # 1c2 <execve>
        int ret=wait4(-1,&status,0);
        status=status>>8;
        printf("ret=%d, status=%d\n",ret,status);
    }

    printf("\nwait4 test end\n");
  8c:	00000517          	auipc	a0,0x0
  90:	5b450513          	addi	a0,a0,1460 # 640 <printf+0xe4>
  94:	00000097          	auipc	ra,0x0
  98:	4c8080e7          	jalr	1224(ra) # 55c <printf>

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
  ae:	1b0080e7          	jalr	432(ra) # 25a <wait4>
        status=status>>8;
  b2:	fb842603          	lw	a2,-72(s0)
  b6:	4086561b          	sraiw	a2,a2,0x8
  ba:	fac42c23          	sw	a2,-72(s0)
        printf("ret=%d, status=%d\n",ret,status);
  be:	2601                	sext.w	a2,a2
  c0:	0005059b          	sext.w	a1,a0
  c4:	00000517          	auipc	a0,0x0
  c8:	56450513          	addi	a0,a0,1380 # 628 <printf+0xcc>
  cc:	00000097          	auipc	ra,0x0
  d0:	490080e7          	jalr	1168(ra) # 55c <printf>
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

00000000000001e6 <simple_write>:

//一个简单的输出字符串到屏幕上的系统调用
uint64 simple_write(char *s, size_t n){
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e406                	sd	ra,8(sp)
 1ea:	e022                	sd	s0,0(sp)
 1ec:	0800                	addi	s0,sp,16
    return user_syscall((uint64)s,n,0,0,0,0,0,SYS_write);
 1ee:	48c1                	li	a7,16
 1f0:	4801                	li	a6,0
 1f2:	4781                	li	a5,0
 1f4:	4701                	li	a4,0
 1f6:	4681                	li	a3,0
 1f8:	4601                	li	a2,0
 1fa:	00000097          	auipc	ra,0x0
 1fe:	edc080e7          	jalr	-292(ra) # d6 <user_syscall>
}
 202:	60a2                	ld	ra,8(sp)
 204:	6402                	ld	s0,0(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret

000000000000020a <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
 20a:	1141                	addi	sp,sp,-16
 20c:	e406                	sd	ra,8(sp)
 20e:	e022                	sd	s0,0(sp)
 210:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
 212:	48d5                	li	a7,21
 214:	4801                	li	a6,0
 216:	4781                	li	a5,0
 218:	4701                	li	a4,0
 21a:	4681                	li	a3,0
 21c:	4601                	li	a2,0
 21e:	4581                	li	a1,0
 220:	00000097          	auipc	ra,0x0
 224:	eb6080e7          	jalr	-330(ra) # d6 <user_syscall>
}
 228:	60a2                	ld	ra,8(sp)
 22a:	6402                	ld	s0,0(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret

0000000000000230 <clone>:

uint64 clone(uint64 flag, void *stack, size_t sz){
 230:	1141                	addi	sp,sp,-16
 232:	e406                	sd	ra,8(sp)
 234:	e022                	sd	s0,0(sp)
 236:	0800                	addi	s0,sp,16
    if(stack!=NULL)
 238:	c191                	beqz	a1,23c <clone+0xc>
        stack+=sz;
 23a:	95b2                	add	a1,a1,a2
    return user_syscall(flag,(uint64)stack,0,0,0,0,0,SYS_clone);
 23c:	0dc00893          	li	a7,220
 240:	4801                	li	a6,0
 242:	4781                	li	a5,0
 244:	4701                	li	a4,0
 246:	4681                	li	a3,0
 248:	4601                	li	a2,0
 24a:	00000097          	auipc	ra,0x0
 24e:	e8c080e7          	jalr	-372(ra) # d6 <user_syscall>
}
 252:	60a2                	ld	ra,8(sp)
 254:	6402                	ld	s0,0(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret

000000000000025a <wait4>:

uint64 wait4(int pid, int *status, uint64 options){
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
    return user_syscall((uint64)pid,(uint64)status,options,0,0,0,0,SYS_wait4);
 262:	10400893          	li	a7,260
 266:	4801                	li	a6,0
 268:	4781                	li	a5,0
 26a:	4701                	li	a4,0
 26c:	4681                	li	a3,0
 26e:	00000097          	auipc	ra,0x0
 272:	e68080e7          	jalr	-408(ra) # d6 <user_syscall>
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret

000000000000027e <exit>:

//进程退出
uint64 exit(int code){
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
 286:	05d00893          	li	a7,93
 28a:	4801                	li	a6,0
 28c:	4781                	li	a5,0
 28e:	4701                	li	a4,0
 290:	4681                	li	a3,0
 292:	4601                	li	a2,0
 294:	4581                	li	a1,0
 296:	00000097          	auipc	ra,0x0
 29a:	e40080e7          	jalr	-448(ra) # d6 <user_syscall>
}
 29e:	60a2                	ld	ra,8(sp)
 2a0:	6402                	ld	s0,0(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret

00000000000002a6 <getppid>:

//获取父进程pid
uint64 getppid(){
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e406                	sd	ra,8(sp)
 2aa:	e022                	sd	s0,0(sp)
 2ac:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getppid);
 2ae:	0ad00893          	li	a7,173
 2b2:	4801                	li	a6,0
 2b4:	4781                	li	a5,0
 2b6:	4701                	li	a4,0
 2b8:	4681                	li	a3,0
 2ba:	4601                	li	a2,0
 2bc:	4581                	li	a1,0
 2be:	4501                	li	a0,0
 2c0:	00000097          	auipc	ra,0x0
 2c4:	e16080e7          	jalr	-490(ra) # d6 <user_syscall>
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <getpid>:

//获取当前进程pid
uint64 getpid(){
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getpid);
 2d8:	0ac00893          	li	a7,172
 2dc:	4801                	li	a6,0
 2de:	4781                	li	a5,0
 2e0:	4701                	li	a4,0
 2e2:	4681                	li	a3,0
 2e4:	4601                	li	a2,0
 2e6:	4581                	li	a1,0
 2e8:	4501                	li	a0,0
 2ea:	00000097          	auipc	ra,0x0
 2ee:	dec080e7          	jalr	-532(ra) # d6 <user_syscall>
}
 2f2:	60a2                	ld	ra,8(sp)
 2f4:	6402                	ld	s0,0(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret

00000000000002fa <sched_yield>:

uint64 sched_yield(){
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e406                	sd	ra,8(sp)
 2fe:	e022                	sd	s0,0(sp)
 300:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_sched_yield);
 302:	07c00893          	li	a7,124
 306:	4801                	li	a6,0
 308:	4781                	li	a5,0
 30a:	4701                	li	a4,0
 30c:	4681                	li	a3,0
 30e:	4601                	li	a2,0
 310:	4581                	li	a1,0
 312:	4501                	li	a0,0
 314:	00000097          	auipc	ra,0x0
 318:	dc2080e7          	jalr	-574(ra) # d6 <user_syscall>
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret

0000000000000324 <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
 324:	00064783          	lbu	a5,0(a2)
 328:	20078c63          	beqz	a5,540 <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
 32c:	715d                	addi	sp,sp,-80
 32e:	e4a2                	sd	s0,72(sp)
 330:	e0a6                	sd	s1,64(sp)
 332:	fc4a                	sd	s2,56(sp)
 334:	f84e                	sd	s3,48(sp)
 336:	f452                	sd	s4,40(sp)
 338:	f056                	sd	s5,32(sp)
 33a:	ec5a                	sd	s6,24(sp)
 33c:	e85e                	sd	s7,16(sp)
 33e:	e462                	sd	s8,8(sp)
 340:	e066                	sd	s9,0(sp)
 342:	0880                	addi	s0,sp,80
  size_t pos = 0;
 344:	4701                	li	a4,0
  int longarg = 0;
 346:	4b01                	li	s6,0
  int format = 0;
 348:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 34a:	02500f93          	li	t6,37
      format = 1;
 34e:	4285                	li	t0,1
      switch (*s) {
 350:	4f55                	li	t5,21
 352:	00000317          	auipc	t1,0x0
 356:	32630313          	addi	t1,t1,806 # 678 <printf+0x11c>
          longarg = 0;
 35a:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 35c:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
 35e:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 362:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 364:	58fd                	li	a7,-1
 366:	43bd                	li	t2,15
 368:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
 36a:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
 36e:	03000493          	li	s1,48
 372:	aabd                	j	4f0 <vsnprintf+0x1cc>
          longarg = 1;
 374:	8b56                	mv	s6,s5
 376:	aa8d                	j	4e8 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
 378:	00170793          	addi	a5,a4,1
 37c:	00b7f663          	bgeu	a5,a1,388 <vsnprintf+0x64>
 380:	00e50ab3          	add	s5,a0,a4
 384:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
 388:	0709                	addi	a4,a4,2
 38a:	00b77563          	bgeu	a4,a1,394 <vsnprintf+0x70>
 38e:	97aa                	add	a5,a5,a0
 390:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 394:	0006bc03          	ld	s8,0(a3)
 398:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 39a:	8c9e                	mv	s9,t2
 39c:	8b66                	mv	s6,s9
 39e:	8aba                	mv	s5,a4
 3a0:	a839                	j	3be <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 3a2:	fe0b19e3          	bnez	s6,394 <vsnprintf+0x70>
 3a6:	0006ac03          	lw	s8,0(a3)
 3aa:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 3ac:	8cce                	mv	s9,s3
 3ae:	b7fd                	j	39c <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 3b0:	015507b3          	add	a5,a0,s5
 3b4:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 3b8:	3b7d                	addiw	s6,s6,-1
 3ba:	031b0163          	beq	s6,a7,3dc <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 3be:	0a85                	addi	s5,s5,1
 3c0:	febafce3          	bgeu	s5,a1,3b8 <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
 3c4:	002b179b          	slliw	a5,s6,0x2
 3c8:	40fc57b3          	sra	a5,s8,a5
 3cc:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 3ce:	05778b93          	addi	s7,a5,87
 3d2:	fcfecfe3          	blt	t4,a5,3b0 <vsnprintf+0x8c>
 3d6:	03078b93          	addi	s7,a5,48
 3da:	bfd9                	j	3b0 <vsnprintf+0x8c>
 3dc:	0705                	addi	a4,a4,1
 3de:	9766                	add	a4,a4,s9
          longarg = 0;
 3e0:	8b72                	mv	s6,t3
          format = 0;
 3e2:	8af2                	mv	s5,t3
 3e4:	a211                	j	4e8 <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 3e6:	020b0663          	beqz	s6,412 <vsnprintf+0xee>
 3ea:	0006ba83          	ld	s5,0(a3)
 3ee:	06a1                	addi	a3,a3,8
          if (num < 0) {
 3f0:	020ac563          	bltz	s5,41a <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
 3f4:	030ac7b3          	div	a5,s5,a6
 3f8:	cf95                	beqz	a5,434 <vsnprintf+0x110>
          long digits = 1;
 3fa:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 3fc:	0b05                	addi	s6,s6,1
 3fe:	0307c7b3          	div	a5,a5,a6
 402:	ffed                	bnez	a5,3fc <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 404:	fffb079b          	addiw	a5,s6,-1
 408:	0407ce63          	bltz	a5,464 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 40c:	00170c93          	addi	s9,a4,1
 410:	a825                	j	448 <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 412:	0006aa83          	lw	s5,0(a3)
 416:	06a1                	addi	a3,a3,8
 418:	bfe1                	j	3f0 <vsnprintf+0xcc>
            num = -num;
 41a:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
 41e:	00170793          	addi	a5,a4,1
 422:	00b7f763          	bgeu	a5,a1,430 <vsnprintf+0x10c>
 426:	972a                	add	a4,a4,a0
 428:	01470023          	sb	s4,0(a4)
 42c:	873e                	mv	a4,a5
 42e:	b7d9                	j	3f4 <vsnprintf+0xd0>
 430:	873e                	mv	a4,a5
 432:	b7c9                	j	3f4 <vsnprintf+0xd0>
          long digits = 1;
 434:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 436:	87f2                	mv	a5,t3
 438:	bfd1                	j	40c <vsnprintf+0xe8>
            num /= 10;
 43a:	030acab3          	div	s5,s5,a6
 43e:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
 440:	02079b93          	slli	s7,a5,0x20
 444:	020bc063          	bltz	s7,464 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 448:	00fc8bb3          	add	s7,s9,a5
 44c:	febbf7e3          	bgeu	s7,a1,43a <vsnprintf+0x116>
 450:	00f70bb3          	add	s7,a4,a5
 454:	9baa                	add	s7,s7,a0
 456:	030aec33          	rem	s8,s5,a6
 45a:	030c0c1b          	addiw	s8,s8,48
 45e:	018b8023          	sb	s8,0(s7)
 462:	bfe1                	j	43a <vsnprintf+0x116>
          pos += digits;
 464:	975a                	add	a4,a4,s6
          longarg = 0;
 466:	8b72                	mv	s6,t3
          format = 0;
 468:	8af2                	mv	s5,t3
          break;
 46a:	a8bd                	j	4e8 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 46c:	00868b93          	addi	s7,a3,8
 470:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
 474:	000ac683          	lbu	a3,0(s5)
 478:	ceb9                	beqz	a3,4d6 <vsnprintf+0x1b2>
 47a:	87ba                	mv	a5,a4
 47c:	a039                	j	48a <vsnprintf+0x166>
 47e:	40e786b3          	sub	a3,a5,a4
 482:	96d6                	add	a3,a3,s5
 484:	0006c683          	lbu	a3,0(a3)
 488:	ca89                	beqz	a3,49a <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
 48a:	0785                	addi	a5,a5,1
 48c:	feb7f9e3          	bgeu	a5,a1,47e <vsnprintf+0x15a>
 490:	00f50b33          	add	s6,a0,a5
 494:	fedb0fa3          	sb	a3,-1(s6)
 498:	b7dd                	j	47e <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
 49a:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 49c:	873e                	mv	a4,a5
          longarg = 0;
 49e:	8b72                	mv	s6,t3
          format = 0;
 4a0:	8af2                	mv	s5,t3
 4a2:	a099                	j	4e8 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 4a4:	00170793          	addi	a5,a4,1
 4a8:	02b7fb63          	bgeu	a5,a1,4de <vsnprintf+0x1ba>
 4ac:	972a                	add	a4,a4,a0
 4ae:	0006aa83          	lw	s5,0(a3)
 4b2:	01570023          	sb	s5,0(a4)
 4b6:	06a1                	addi	a3,a3,8
 4b8:	873e                	mv	a4,a5
          longarg = 0;
 4ba:	8b72                	mv	s6,t3
          format = 0;
 4bc:	8af2                	mv	s5,t3
 4be:	a02d                	j	4e8 <vsnprintf+0x1c4>
    } else if (*s == '%')
 4c0:	03f78363          	beq	a5,t6,4e6 <vsnprintf+0x1c2>
    else if (++pos < n)
 4c4:	00170b93          	addi	s7,a4,1
 4c8:	04bbf263          	bgeu	s7,a1,50c <vsnprintf+0x1e8>
      out[pos - 1] = *s;
 4cc:	972a                	add	a4,a4,a0
 4ce:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
 4d2:	875e                	mv	a4,s7
 4d4:	a811                	j	4e8 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 4d6:	86de                	mv	a3,s7
          longarg = 0;
 4d8:	8b72                	mv	s6,t3
          format = 0;
 4da:	8af2                	mv	s5,t3
 4dc:	a031                	j	4e8 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 4de:	873e                	mv	a4,a5
          longarg = 0;
 4e0:	8b72                	mv	s6,t3
          format = 0;
 4e2:	8af2                	mv	s5,t3
 4e4:	a011                	j	4e8 <vsnprintf+0x1c4>
      format = 1;
 4e6:	8a96                	mv	s5,t0
  for (; *s; s++) {
 4e8:	0605                	addi	a2,a2,1
 4ea:	00064783          	lbu	a5,0(a2)
 4ee:	c38d                	beqz	a5,510 <vsnprintf+0x1ec>
    if (format) {
 4f0:	fc0a88e3          	beqz	s5,4c0 <vsnprintf+0x19c>
      switch (*s) {
 4f4:	f9d7879b          	addiw	a5,a5,-99
 4f8:	0ff7fb93          	andi	s7,a5,255
 4fc:	ff7f66e3          	bltu	t5,s7,4e8 <vsnprintf+0x1c4>
 500:	002b9793          	slli	a5,s7,0x2
 504:	979a                	add	a5,a5,t1
 506:	439c                	lw	a5,0(a5)
 508:	979a                	add	a5,a5,t1
 50a:	8782                	jr	a5
    else if (++pos < n)
 50c:	875e                	mv	a4,s7
 50e:	bfe9                	j	4e8 <vsnprintf+0x1c4>
  }
  if (pos < n)
 510:	02b77363          	bgeu	a4,a1,536 <vsnprintf+0x212>
    out[pos] = 0;
 514:	953a                	add	a0,a0,a4
 516:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 51a:	0007051b          	sext.w	a0,a4
 51e:	6426                	ld	s0,72(sp)
 520:	6486                	ld	s1,64(sp)
 522:	7962                	ld	s2,56(sp)
 524:	79c2                	ld	s3,48(sp)
 526:	7a22                	ld	s4,40(sp)
 528:	7a82                	ld	s5,32(sp)
 52a:	6b62                	ld	s6,24(sp)
 52c:	6bc2                	ld	s7,16(sp)
 52e:	6c22                	ld	s8,8(sp)
 530:	6c82                	ld	s9,0(sp)
 532:	6161                	addi	sp,sp,80
 534:	8082                	ret
  else if (n)
 536:	d1f5                	beqz	a1,51a <vsnprintf+0x1f6>
    out[n - 1] = 0;
 538:	95aa                	add	a1,a1,a0
 53a:	fe058fa3          	sb	zero,-1(a1)
 53e:	bff1                	j	51a <vsnprintf+0x1f6>
  size_t pos = 0;
 540:	4701                	li	a4,0
  if (pos < n)
 542:	00b77863          	bgeu	a4,a1,552 <vsnprintf+0x22e>
    out[pos] = 0;
 546:	953a                	add	a0,a0,a4
 548:	00050023          	sb	zero,0(a0)
}
 54c:	0007051b          	sext.w	a0,a4
 550:	8082                	ret
  else if (n)
 552:	dded                	beqz	a1,54c <vsnprintf+0x228>
    out[n - 1] = 0;
 554:	95aa                	add	a1,a1,a0
 556:	fe058fa3          	sb	zero,-1(a1)
 55a:	bfcd                	j	54c <vsnprintf+0x228>

000000000000055c <printf>:
int printf(char*s, ...){
 55c:	710d                	addi	sp,sp,-352
 55e:	ee06                	sd	ra,280(sp)
 560:	ea22                	sd	s0,272(sp)
 562:	1200                	addi	s0,sp,288
 564:	e40c                	sd	a1,8(s0)
 566:	e810                	sd	a2,16(s0)
 568:	ec14                	sd	a3,24(s0)
 56a:	f018                	sd	a4,32(s0)
 56c:	f41c                	sd	a5,40(s0)
 56e:	03043823          	sd	a6,48(s0)
 572:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 576:	00840693          	addi	a3,s0,8
 57a:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 57e:	862a                	mv	a2,a0
 580:	10000593          	li	a1,256
 584:	ee840513          	addi	a0,s0,-280
 588:	00000097          	auipc	ra,0x0
 58c:	d9c080e7          	jalr	-612(ra) # 324 <vsnprintf>
 590:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 592:	0005071b          	sext.w	a4,a0
 596:	0ff00793          	li	a5,255
 59a:	00e7f463          	bgeu	a5,a4,5a2 <printf+0x46>
 59e:	10000593          	li	a1,256
    return simple_write(buf, n);
 5a2:	ee840513          	addi	a0,s0,-280
 5a6:	00000097          	auipc	ra,0x0
 5aa:	c40080e7          	jalr	-960(ra) # 1e6 <simple_write>
}
 5ae:	2501                	sext.w	a0,a0
 5b0:	60f2                	ld	ra,280(sp)
 5b2:	6452                	ld	s0,272(sp)
 5b4:	6135                	addi	sp,sp,352
 5b6:	8082                	ret
