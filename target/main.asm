
target/main：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "stdio.h"
#include "user_syscall.h"

int main(int argc, char *argv[]){
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	892a                	mv	s2,a0
  10:	89ae                	mv	s3,a1
    printf("main begin!\n");
  12:	00000517          	auipc	a0,0x0
  16:	58650513          	addi	a0,a0,1414 # 598 <printf+0x5c>
  1a:	00000097          	auipc	ra,0x0
  1e:	522080e7          	jalr	1314(ra) # 53c <printf>
    printf("argc: %d\n",argc);
  22:	85ca                	mv	a1,s2
  24:	00000517          	auipc	a0,0x0
  28:	58450513          	addi	a0,a0,1412 # 5a8 <printf+0x6c>
  2c:	00000097          	auipc	ra,0x0
  30:	510080e7          	jalr	1296(ra) # 53c <printf>
    for(int i=0;i<argc;i++){
  34:	03205263          	blez	s2,58 <main+0x58>
  38:	84ce                	mv	s1,s3
  3a:	397d                	addiw	s2,s2,-1
  3c:	1902                	slli	s2,s2,0x20
  3e:	02095913          	srli	s2,s2,0x20
  42:	090e                	slli	s2,s2,0x3
  44:	09a1                	addi	s3,s3,8
  46:	994e                	add	s2,s2,s3
        printf(argv[i]);
  48:	6088                	ld	a0,0(s1)
  4a:	00000097          	auipc	ra,0x0
  4e:	4f2080e7          	jalr	1266(ra) # 53c <printf>
  52:	04a1                	addi	s1,s1,8
    for(int i=0;i<argc;i++){
  54:	ff249ae3          	bne	s1,s2,48 <main+0x48>
    }
    printf("pid: %d\n",getpid());
  58:	00000097          	auipc	ra,0x0
  5c:	258080e7          	jalr	600(ra) # 2b0 <getpid>
  60:	85aa                	mv	a1,a0
  62:	00000517          	auipc	a0,0x0
  66:	55650513          	addi	a0,a0,1366 # 5b8 <printf+0x7c>
  6a:	00000097          	auipc	ra,0x0
  6e:	4d2080e7          	jalr	1234(ra) # 53c <printf>
    printf("ppid: %d\n",getppid());
  72:	00000097          	auipc	ra,0x0
  76:	214080e7          	jalr	532(ra) # 286 <getppid>
  7a:	85aa                	mv	a1,a0
  7c:	00000517          	auipc	a0,0x0
  80:	54c50513          	addi	a0,a0,1356 # 5c8 <printf+0x8c>
  84:	00000097          	auipc	ra,0x0
  88:	4b8080e7          	jalr	1208(ra) # 53c <printf>
    printf("main end!\n");    
  8c:	00000517          	auipc	a0,0x0
  90:	54c50513          	addi	a0,a0,1356 # 5d8 <printf+0x9c>
  94:	00000097          	auipc	ra,0x0
  98:	4a8080e7          	jalr	1192(ra) # 53c <printf>
    exit(22);
  9c:	4559                	li	a0,22
  9e:	00000097          	auipc	ra,0x0
  a2:	1c0080e7          	jalr	448(ra) # 25e <exit>
    return 0;
}
  a6:	4501                	li	a0,0
  a8:	70a2                	ld	ra,40(sp)
  aa:	7402                	ld	s0,32(sp)
  ac:	64e2                	ld	s1,24(sp)
  ae:	6942                	ld	s2,16(sp)
  b0:	69a2                	ld	s3,8(sp)
  b2:	6145                	addi	sp,sp,48
  b4:	8082                	ret

00000000000000b6 <user_syscall>:
/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
  b6:	715d                	addi	sp,sp,-80
  b8:	e4a2                	sd	s0,72(sp)
  ba:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
  bc:	fea43423          	sd	a0,-24(s0)
  c0:	feb43023          	sd	a1,-32(s0)
  c4:	fcc43c23          	sd	a2,-40(s0)
  c8:	fcd43823          	sd	a3,-48(s0)
  cc:	fce43423          	sd	a4,-56(s0)
  d0:	fcf43023          	sd	a5,-64(s0)
  d4:	fb043c23          	sd	a6,-72(s0)
  d8:	fb143823          	sd	a7,-80(s0)
        asm volatile(   //将参数写入a0-a7寄存器
  dc:	fe843503          	ld	a0,-24(s0)
  e0:	fe043583          	ld	a1,-32(s0)
  e4:	fd843603          	ld	a2,-40(s0)
  e8:	fd043683          	ld	a3,-48(s0)
  ec:	fc843703          	ld	a4,-56(s0)
  f0:	fc043783          	ld	a5,-64(s0)
  f4:	fb843803          	ld	a6,-72(s0)
  f8:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(   //调用ecall
  fc:	00000073          	ecall
 100:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
 104:	fe843503          	ld	a0,-24(s0)
 108:	6426                	ld	s0,72(sp)
 10a:	6161                	addi	sp,sp,80
 10c:	8082                	ret

000000000000010e <fork>:

//复制一个新进程
uint64 fork(){
 10e:	1141                	addi	sp,sp,-16
 110:	e406                	sd	ra,8(sp)
 112:	e022                	sd	s0,0(sp)
 114:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
 116:	4885                	li	a7,1
 118:	4801                	li	a6,0
 11a:	4781                	li	a5,0
 11c:	4701                	li	a4,0
 11e:	4681                	li	a3,0
 120:	4601                	li	a2,0
 122:	4581                	li	a1,0
 124:	4501                	li	a0,0
 126:	00000097          	auipc	ra,0x0
 12a:	f90080e7          	jalr	-112(ra) # b6 <user_syscall>
}
 12e:	60a2                	ld	ra,8(sp)
 130:	6402                	ld	s0,0(sp)
 132:	0141                	addi	sp,sp,16
 134:	8082                	ret

0000000000000136 <open>:

//打开文件
uint64 open(char *file_name, int mode){
 136:	1141                	addi	sp,sp,-16
 138:	e406                	sd	ra,8(sp)
 13a:	e022                	sd	s0,0(sp)
 13c:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
 13e:	48bd                	li	a7,15
 140:	4801                	li	a6,0
 142:	4781                	li	a5,0
 144:	4701                	li	a4,0
 146:	4681                	li	a3,0
 148:	4601                	li	a2,0
 14a:	00000097          	auipc	ra,0x0
 14e:	f6c080e7          	jalr	-148(ra) # b6 <user_syscall>
}
 152:	60a2                	ld	ra,8(sp)
 154:	6402                	ld	s0,0(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret

000000000000015a <read>:

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
 15a:	1141                	addi	sp,sp,-16
 15c:	e406                	sd	ra,8(sp)
 15e:	e022                	sd	s0,0(sp)
 160:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
 162:	4895                	li	a7,5
 164:	4801                	li	a6,0
 166:	4781                	li	a5,0
 168:	4701                	li	a4,0
 16a:	4681                	li	a3,0
 16c:	00000097          	auipc	ra,0x0
 170:	f4a080e7          	jalr	-182(ra) # b6 <user_syscall>
}
 174:	60a2                	ld	ra,8(sp)
 176:	6402                	ld	s0,0(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <kill>:

//根据pid杀死进程
uint64 kill(uint64 pid){
 17c:	1141                	addi	sp,sp,-16
 17e:	e406                	sd	ra,8(sp)
 180:	e022                	sd	s0,0(sp)
 182:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
 184:	4899                	li	a7,6
 186:	4801                	li	a6,0
 188:	4781                	li	a5,0
 18a:	4701                	li	a4,0
 18c:	4681                	li	a3,0
 18e:	4601                	li	a2,0
 190:	4581                	li	a1,0
 192:	00000097          	auipc	ra,0x0
 196:	f24080e7          	jalr	-220(ra) # b6 <user_syscall>
}
 19a:	60a2                	ld	ra,8(sp)
 19c:	6402                	ld	s0,0(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret

00000000000001a2 <execve>:

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e406                	sd	ra,8(sp)
 1a6:	e022                	sd	s0,0(sp)
 1a8:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
 1aa:	0dd00893          	li	a7,221
 1ae:	4801                	li	a6,0
 1b0:	4781                	li	a5,0
 1b2:	4701                	li	a4,0
 1b4:	4681                	li	a3,0
 1b6:	00000097          	auipc	ra,0x0
 1ba:	f00080e7          	jalr	-256(ra) # b6 <user_syscall>
}
 1be:	60a2                	ld	ra,8(sp)
 1c0:	6402                	ld	s0,0(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <simple_write>:

//一个简单的输出字符串到屏幕上的系统调用
uint64 simple_write(char *s, size_t n){
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e406                	sd	ra,8(sp)
 1ca:	e022                	sd	s0,0(sp)
 1cc:	0800                	addi	s0,sp,16
    return user_syscall((uint64)s,n,0,0,0,0,0,SYS_write);
 1ce:	48c1                	li	a7,16
 1d0:	4801                	li	a6,0
 1d2:	4781                	li	a5,0
 1d4:	4701                	li	a4,0
 1d6:	4681                	li	a3,0
 1d8:	4601                	li	a2,0
 1da:	00000097          	auipc	ra,0x0
 1de:	edc080e7          	jalr	-292(ra) # b6 <user_syscall>
}
 1e2:	60a2                	ld	ra,8(sp)
 1e4:	6402                	ld	s0,0(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret

00000000000001ea <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
 1f2:	48d5                	li	a7,21
 1f4:	4801                	li	a6,0
 1f6:	4781                	li	a5,0
 1f8:	4701                	li	a4,0
 1fa:	4681                	li	a3,0
 1fc:	4601                	li	a2,0
 1fe:	4581                	li	a1,0
 200:	00000097          	auipc	ra,0x0
 204:	eb6080e7          	jalr	-330(ra) # b6 <user_syscall>
}
 208:	60a2                	ld	ra,8(sp)
 20a:	6402                	ld	s0,0(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret

0000000000000210 <clone>:

uint64 clone(uint64 flag, void *stack, size_t sz){
 210:	1141                	addi	sp,sp,-16
 212:	e406                	sd	ra,8(sp)
 214:	e022                	sd	s0,0(sp)
 216:	0800                	addi	s0,sp,16
    if(stack!=NULL)
 218:	c191                	beqz	a1,21c <clone+0xc>
        stack+=sz;
 21a:	95b2                	add	a1,a1,a2
    return user_syscall(flag,(uint64)stack,0,0,0,0,0,SYS_clone);
 21c:	0dc00893          	li	a7,220
 220:	4801                	li	a6,0
 222:	4781                	li	a5,0
 224:	4701                	li	a4,0
 226:	4681                	li	a3,0
 228:	4601                	li	a2,0
 22a:	00000097          	auipc	ra,0x0
 22e:	e8c080e7          	jalr	-372(ra) # b6 <user_syscall>
}
 232:	60a2                	ld	ra,8(sp)
 234:	6402                	ld	s0,0(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret

000000000000023a <wait4>:

uint64 wait4(int pid, int *status, uint64 options){
 23a:	1141                	addi	sp,sp,-16
 23c:	e406                	sd	ra,8(sp)
 23e:	e022                	sd	s0,0(sp)
 240:	0800                	addi	s0,sp,16
    return user_syscall((uint64)pid,(uint64)status,options,0,0,0,0,SYS_wait4);
 242:	10400893          	li	a7,260
 246:	4801                	li	a6,0
 248:	4781                	li	a5,0
 24a:	4701                	li	a4,0
 24c:	4681                	li	a3,0
 24e:	00000097          	auipc	ra,0x0
 252:	e68080e7          	jalr	-408(ra) # b6 <user_syscall>
}
 256:	60a2                	ld	ra,8(sp)
 258:	6402                	ld	s0,0(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret

000000000000025e <exit>:

//进程退出
uint64 exit(int code){
 25e:	1141                	addi	sp,sp,-16
 260:	e406                	sd	ra,8(sp)
 262:	e022                	sd	s0,0(sp)
 264:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
 266:	05d00893          	li	a7,93
 26a:	4801                	li	a6,0
 26c:	4781                	li	a5,0
 26e:	4701                	li	a4,0
 270:	4681                	li	a3,0
 272:	4601                	li	a2,0
 274:	4581                	li	a1,0
 276:	00000097          	auipc	ra,0x0
 27a:	e40080e7          	jalr	-448(ra) # b6 <user_syscall>
}
 27e:	60a2                	ld	ra,8(sp)
 280:	6402                	ld	s0,0(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret

0000000000000286 <getppid>:

//获取父进程pid
uint64 getppid(){
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getppid);
 28e:	0ad00893          	li	a7,173
 292:	4801                	li	a6,0
 294:	4781                	li	a5,0
 296:	4701                	li	a4,0
 298:	4681                	li	a3,0
 29a:	4601                	li	a2,0
 29c:	4581                	li	a1,0
 29e:	4501                	li	a0,0
 2a0:	00000097          	auipc	ra,0x0
 2a4:	e16080e7          	jalr	-490(ra) # b6 <user_syscall>
}
 2a8:	60a2                	ld	ra,8(sp)
 2aa:	6402                	ld	s0,0(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret

00000000000002b0 <getpid>:

//获取当前进程pid
uint64 getpid(){
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getpid);
 2b8:	0ac00893          	li	a7,172
 2bc:	4801                	li	a6,0
 2be:	4781                	li	a5,0
 2c0:	4701                	li	a4,0
 2c2:	4681                	li	a3,0
 2c4:	4601                	li	a2,0
 2c6:	4581                	li	a1,0
 2c8:	4501                	li	a0,0
 2ca:	00000097          	auipc	ra,0x0
 2ce:	dec080e7          	jalr	-532(ra) # b6 <user_syscall>
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret

00000000000002da <sched_yield>:

uint64 sched_yield(){
 2da:	1141                	addi	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_sched_yield);
 2e2:	07c00893          	li	a7,124
 2e6:	4801                	li	a6,0
 2e8:	4781                	li	a5,0
 2ea:	4701                	li	a4,0
 2ec:	4681                	li	a3,0
 2ee:	4601                	li	a2,0
 2f0:	4581                	li	a1,0
 2f2:	4501                	li	a0,0
 2f4:	00000097          	auipc	ra,0x0
 2f8:	dc2080e7          	jalr	-574(ra) # b6 <user_syscall>
 2fc:	60a2                	ld	ra,8(sp)
 2fe:	6402                	ld	s0,0(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret

0000000000000304 <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
 304:	00064783          	lbu	a5,0(a2)
 308:	20078c63          	beqz	a5,520 <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
 30c:	715d                	addi	sp,sp,-80
 30e:	e4a2                	sd	s0,72(sp)
 310:	e0a6                	sd	s1,64(sp)
 312:	fc4a                	sd	s2,56(sp)
 314:	f84e                	sd	s3,48(sp)
 316:	f452                	sd	s4,40(sp)
 318:	f056                	sd	s5,32(sp)
 31a:	ec5a                	sd	s6,24(sp)
 31c:	e85e                	sd	s7,16(sp)
 31e:	e462                	sd	s8,8(sp)
 320:	e066                	sd	s9,0(sp)
 322:	0880                	addi	s0,sp,80
  size_t pos = 0;
 324:	4701                	li	a4,0
  int longarg = 0;
 326:	4b01                	li	s6,0
  int format = 0;
 328:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 32a:	02500f93          	li	t6,37
      format = 1;
 32e:	4285                	li	t0,1
      switch (*s) {
 330:	4f55                	li	t5,21
 332:	00000317          	auipc	t1,0x0
 336:	2b630313          	addi	t1,t1,694 # 5e8 <printf+0xac>
          longarg = 0;
 33a:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 33c:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
 33e:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 342:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 344:	58fd                	li	a7,-1
 346:	43bd                	li	t2,15
 348:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
 34a:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
 34e:	03000493          	li	s1,48
 352:	aabd                	j	4d0 <vsnprintf+0x1cc>
          longarg = 1;
 354:	8b56                	mv	s6,s5
 356:	aa8d                	j	4c8 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
 358:	00170793          	addi	a5,a4,1
 35c:	00b7f663          	bgeu	a5,a1,368 <vsnprintf+0x64>
 360:	00e50ab3          	add	s5,a0,a4
 364:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
 368:	0709                	addi	a4,a4,2
 36a:	00b77563          	bgeu	a4,a1,374 <vsnprintf+0x70>
 36e:	97aa                	add	a5,a5,a0
 370:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 374:	0006bc03          	ld	s8,0(a3)
 378:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 37a:	8c9e                	mv	s9,t2
 37c:	8b66                	mv	s6,s9
 37e:	8aba                	mv	s5,a4
 380:	a839                	j	39e <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 382:	fe0b19e3          	bnez	s6,374 <vsnprintf+0x70>
 386:	0006ac03          	lw	s8,0(a3)
 38a:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 38c:	8cce                	mv	s9,s3
 38e:	b7fd                	j	37c <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 390:	015507b3          	add	a5,a0,s5
 394:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 398:	3b7d                	addiw	s6,s6,-1
 39a:	031b0163          	beq	s6,a7,3bc <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 39e:	0a85                	addi	s5,s5,1
 3a0:	febafce3          	bgeu	s5,a1,398 <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
 3a4:	002b179b          	slliw	a5,s6,0x2
 3a8:	40fc57b3          	sra	a5,s8,a5
 3ac:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 3ae:	05778b93          	addi	s7,a5,87
 3b2:	fcfecfe3          	blt	t4,a5,390 <vsnprintf+0x8c>
 3b6:	03078b93          	addi	s7,a5,48
 3ba:	bfd9                	j	390 <vsnprintf+0x8c>
 3bc:	0705                	addi	a4,a4,1
 3be:	9766                	add	a4,a4,s9
          longarg = 0;
 3c0:	8b72                	mv	s6,t3
          format = 0;
 3c2:	8af2                	mv	s5,t3
 3c4:	a211                	j	4c8 <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 3c6:	020b0663          	beqz	s6,3f2 <vsnprintf+0xee>
 3ca:	0006ba83          	ld	s5,0(a3)
 3ce:	06a1                	addi	a3,a3,8
          if (num < 0) {
 3d0:	020ac563          	bltz	s5,3fa <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
 3d4:	030ac7b3          	div	a5,s5,a6
 3d8:	cf95                	beqz	a5,414 <vsnprintf+0x110>
          long digits = 1;
 3da:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 3dc:	0b05                	addi	s6,s6,1
 3de:	0307c7b3          	div	a5,a5,a6
 3e2:	ffed                	bnez	a5,3dc <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 3e4:	fffb079b          	addiw	a5,s6,-1
 3e8:	0407ce63          	bltz	a5,444 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 3ec:	00170c93          	addi	s9,a4,1
 3f0:	a825                	j	428 <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 3f2:	0006aa83          	lw	s5,0(a3)
 3f6:	06a1                	addi	a3,a3,8
 3f8:	bfe1                	j	3d0 <vsnprintf+0xcc>
            num = -num;
 3fa:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
 3fe:	00170793          	addi	a5,a4,1
 402:	00b7f763          	bgeu	a5,a1,410 <vsnprintf+0x10c>
 406:	972a                	add	a4,a4,a0
 408:	01470023          	sb	s4,0(a4)
 40c:	873e                	mv	a4,a5
 40e:	b7d9                	j	3d4 <vsnprintf+0xd0>
 410:	873e                	mv	a4,a5
 412:	b7c9                	j	3d4 <vsnprintf+0xd0>
          long digits = 1;
 414:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 416:	87f2                	mv	a5,t3
 418:	bfd1                	j	3ec <vsnprintf+0xe8>
            num /= 10;
 41a:	030acab3          	div	s5,s5,a6
 41e:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
 420:	02079b93          	slli	s7,a5,0x20
 424:	020bc063          	bltz	s7,444 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 428:	00fc8bb3          	add	s7,s9,a5
 42c:	febbf7e3          	bgeu	s7,a1,41a <vsnprintf+0x116>
 430:	00f70bb3          	add	s7,a4,a5
 434:	9baa                	add	s7,s7,a0
 436:	030aec33          	rem	s8,s5,a6
 43a:	030c0c1b          	addiw	s8,s8,48
 43e:	018b8023          	sb	s8,0(s7)
 442:	bfe1                	j	41a <vsnprintf+0x116>
          pos += digits;
 444:	975a                	add	a4,a4,s6
          longarg = 0;
 446:	8b72                	mv	s6,t3
          format = 0;
 448:	8af2                	mv	s5,t3
          break;
 44a:	a8bd                	j	4c8 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 44c:	00868b93          	addi	s7,a3,8
 450:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
 454:	000ac683          	lbu	a3,0(s5)
 458:	ceb9                	beqz	a3,4b6 <vsnprintf+0x1b2>
 45a:	87ba                	mv	a5,a4
 45c:	a039                	j	46a <vsnprintf+0x166>
 45e:	40e786b3          	sub	a3,a5,a4
 462:	96d6                	add	a3,a3,s5
 464:	0006c683          	lbu	a3,0(a3)
 468:	ca89                	beqz	a3,47a <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
 46a:	0785                	addi	a5,a5,1
 46c:	feb7f9e3          	bgeu	a5,a1,45e <vsnprintf+0x15a>
 470:	00f50b33          	add	s6,a0,a5
 474:	fedb0fa3          	sb	a3,-1(s6)
 478:	b7dd                	j	45e <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
 47a:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 47c:	873e                	mv	a4,a5
          longarg = 0;
 47e:	8b72                	mv	s6,t3
          format = 0;
 480:	8af2                	mv	s5,t3
 482:	a099                	j	4c8 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 484:	00170793          	addi	a5,a4,1
 488:	02b7fb63          	bgeu	a5,a1,4be <vsnprintf+0x1ba>
 48c:	972a                	add	a4,a4,a0
 48e:	0006aa83          	lw	s5,0(a3)
 492:	01570023          	sb	s5,0(a4)
 496:	06a1                	addi	a3,a3,8
 498:	873e                	mv	a4,a5
          longarg = 0;
 49a:	8b72                	mv	s6,t3
          format = 0;
 49c:	8af2                	mv	s5,t3
 49e:	a02d                	j	4c8 <vsnprintf+0x1c4>
    } else if (*s == '%')
 4a0:	03f78363          	beq	a5,t6,4c6 <vsnprintf+0x1c2>
    else if (++pos < n)
 4a4:	00170b93          	addi	s7,a4,1
 4a8:	04bbf263          	bgeu	s7,a1,4ec <vsnprintf+0x1e8>
      out[pos - 1] = *s;
 4ac:	972a                	add	a4,a4,a0
 4ae:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
 4b2:	875e                	mv	a4,s7
 4b4:	a811                	j	4c8 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 4b6:	86de                	mv	a3,s7
          longarg = 0;
 4b8:	8b72                	mv	s6,t3
          format = 0;
 4ba:	8af2                	mv	s5,t3
 4bc:	a031                	j	4c8 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 4be:	873e                	mv	a4,a5
          longarg = 0;
 4c0:	8b72                	mv	s6,t3
          format = 0;
 4c2:	8af2                	mv	s5,t3
 4c4:	a011                	j	4c8 <vsnprintf+0x1c4>
      format = 1;
 4c6:	8a96                	mv	s5,t0
  for (; *s; s++) {
 4c8:	0605                	addi	a2,a2,1
 4ca:	00064783          	lbu	a5,0(a2)
 4ce:	c38d                	beqz	a5,4f0 <vsnprintf+0x1ec>
    if (format) {
 4d0:	fc0a88e3          	beqz	s5,4a0 <vsnprintf+0x19c>
      switch (*s) {
 4d4:	f9d7879b          	addiw	a5,a5,-99
 4d8:	0ff7fb93          	andi	s7,a5,255
 4dc:	ff7f66e3          	bltu	t5,s7,4c8 <vsnprintf+0x1c4>
 4e0:	002b9793          	slli	a5,s7,0x2
 4e4:	979a                	add	a5,a5,t1
 4e6:	439c                	lw	a5,0(a5)
 4e8:	979a                	add	a5,a5,t1
 4ea:	8782                	jr	a5
    else if (++pos < n)
 4ec:	875e                	mv	a4,s7
 4ee:	bfe9                	j	4c8 <vsnprintf+0x1c4>
  }
  if (pos < n)
 4f0:	02b77363          	bgeu	a4,a1,516 <vsnprintf+0x212>
    out[pos] = 0;
 4f4:	953a                	add	a0,a0,a4
 4f6:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 4fa:	0007051b          	sext.w	a0,a4
 4fe:	6426                	ld	s0,72(sp)
 500:	6486                	ld	s1,64(sp)
 502:	7962                	ld	s2,56(sp)
 504:	79c2                	ld	s3,48(sp)
 506:	7a22                	ld	s4,40(sp)
 508:	7a82                	ld	s5,32(sp)
 50a:	6b62                	ld	s6,24(sp)
 50c:	6bc2                	ld	s7,16(sp)
 50e:	6c22                	ld	s8,8(sp)
 510:	6c82                	ld	s9,0(sp)
 512:	6161                	addi	sp,sp,80
 514:	8082                	ret
  else if (n)
 516:	d1f5                	beqz	a1,4fa <vsnprintf+0x1f6>
    out[n - 1] = 0;
 518:	95aa                	add	a1,a1,a0
 51a:	fe058fa3          	sb	zero,-1(a1)
 51e:	bff1                	j	4fa <vsnprintf+0x1f6>
  size_t pos = 0;
 520:	4701                	li	a4,0
  if (pos < n)
 522:	00b77863          	bgeu	a4,a1,532 <vsnprintf+0x22e>
    out[pos] = 0;
 526:	953a                	add	a0,a0,a4
 528:	00050023          	sb	zero,0(a0)
}
 52c:	0007051b          	sext.w	a0,a4
 530:	8082                	ret
  else if (n)
 532:	dded                	beqz	a1,52c <vsnprintf+0x228>
    out[n - 1] = 0;
 534:	95aa                	add	a1,a1,a0
 536:	fe058fa3          	sb	zero,-1(a1)
 53a:	bfcd                	j	52c <vsnprintf+0x228>

000000000000053c <printf>:
int printf(char*s, ...){
 53c:	710d                	addi	sp,sp,-352
 53e:	ee06                	sd	ra,280(sp)
 540:	ea22                	sd	s0,272(sp)
 542:	1200                	addi	s0,sp,288
 544:	e40c                	sd	a1,8(s0)
 546:	e810                	sd	a2,16(s0)
 548:	ec14                	sd	a3,24(s0)
 54a:	f018                	sd	a4,32(s0)
 54c:	f41c                	sd	a5,40(s0)
 54e:	03043823          	sd	a6,48(s0)
 552:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 556:	00840693          	addi	a3,s0,8
 55a:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 55e:	862a                	mv	a2,a0
 560:	10000593          	li	a1,256
 564:	ee840513          	addi	a0,s0,-280
 568:	00000097          	auipc	ra,0x0
 56c:	d9c080e7          	jalr	-612(ra) # 304 <vsnprintf>
 570:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 572:	0005071b          	sext.w	a4,a0
 576:	0ff00793          	li	a5,255
 57a:	00e7f463          	bgeu	a5,a4,582 <printf+0x46>
 57e:	10000593          	li	a1,256
    return simple_write(buf, n);
 582:	ee840513          	addi	a0,s0,-280
 586:	00000097          	auipc	ra,0x0
 58a:	c40080e7          	jalr	-960(ra) # 1c6 <simple_write>
}
 58e:	2501                	sext.w	a0,a0
 590:	60f2                	ld	ra,280(sp)
 592:	6452                	ld	s0,272(sp)
 594:	6135                	addi	sp,sp,352
 596:	8082                	ret
