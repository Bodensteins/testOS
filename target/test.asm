
target/test：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user_syscall.h"
#include "stdio.h"

char stack[1024];

int main(){
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	0880                	addi	s0,sp,80
    printf("test\n");
   c:	00000517          	auipc	a0,0x0
  10:	50c50513          	addi	a0,a0,1292 # 518 <printf+0x88>
  14:	00000097          	auipc	ra,0x0
  18:	47c080e7          	jalr	1148(ra) # 490 <printf>
    
    int pid=clone(0,stack,1024);
  1c:	40000613          	li	a2,1024
  20:	00000597          	auipc	a1,0x0
  24:	5b058593          	addi	a1,a1,1456 # 5d0 <__DATA_BEGIN__>
  28:	4501                	li	a0,0
  2a:	00000097          	auipc	ra,0x0
  2e:	204080e7          	jalr	516(ra) # 22e <clone>

    if(pid==0){
  32:	2501                	sext.w	a0,a0
  34:	e525                	bnez	a0,9c <main+0x9c>
        char *argv[5]={"try ", "more ","test!", "\n", NULL};
  36:	00000797          	auipc	a5,0x0
  3a:	4ba78793          	addi	a5,a5,1210 # 4f0 <printf+0x60>
  3e:	638c                	ld	a1,0(a5)
  40:	6790                	ld	a2,8(a5)
  42:	6b94                	ld	a3,16(a5)
  44:	6f98                	ld	a4,24(a5)
  46:	739c                	ld	a5,32(a5)
  48:	fab43c23          	sd	a1,-72(s0)
  4c:	fcc43023          	sd	a2,-64(s0)
  50:	fcd43423          	sd	a3,-56(s0)
  54:	fce43823          	sd	a4,-48(s0)
  58:	fcf43c23          	sd	a5,-40(s0)
        for(int i=0;i<4;i++){
  5c:	fb840493          	addi	s1,s0,-72
  60:	fd840913          	addi	s2,s0,-40
            printf(argv[i]);
  64:	6088                	ld	a0,0(s1)
  66:	00000097          	auipc	ra,0x0
  6a:	42a080e7          	jalr	1066(ra) # 490 <printf>
  6e:	04a1                	addi	s1,s1,8
        for(int i=0;i<4;i++){
  70:	ff249ae3          	bne	s1,s2,64 <main+0x64>
        }
        printf("\n...................................\n");
  74:	00000517          	auipc	a0,0x0
  78:	4ac50513          	addi	a0,a0,1196 # 520 <printf+0x90>
  7c:	00000097          	auipc	ra,0x0
  80:	414080e7          	jalr	1044(ra) # 490 <printf>
        execve("/main",argv, NULL);
  84:	4601                	li	a2,0
  86:	fb840593          	addi	a1,s0,-72
  8a:	00000517          	auipc	a0,0x0
  8e:	4be50513          	addi	a0,a0,1214 # 548 <printf+0xb8>
  92:	00000097          	auipc	ra,0x0
  96:	12e080e7          	jalr	302(ra) # 1c0 <execve>
    else{
        printf("ok!\n");
    }

    while(1){
    }
  9a:	a001                	j	9a <main+0x9a>
        printf("ok!\n");
  9c:	00000517          	auipc	a0,0x0
  a0:	4b450513          	addi	a0,a0,1204 # 550 <printf+0xc0>
  a4:	00000097          	auipc	ra,0x0
  a8:	3ec080e7          	jalr	1004(ra) # 490 <printf>
  ac:	b7fd                	j	9a <main+0x9a>

00000000000000ae <user_syscall>:
/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
  ae:	715d                	addi	sp,sp,-80
  b0:	e4a2                	sd	s0,72(sp)
  b2:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
  b4:	fea43423          	sd	a0,-24(s0)
  b8:	feb43023          	sd	a1,-32(s0)
  bc:	fcc43c23          	sd	a2,-40(s0)
  c0:	fcd43823          	sd	a3,-48(s0)
  c4:	fce43423          	sd	a4,-56(s0)
  c8:	fcf43023          	sd	a5,-64(s0)
  cc:	fb043c23          	sd	a6,-72(s0)
  d0:	fb143823          	sd	a7,-80(s0)
        asm volatile(   //将参数写入a0-a7寄存器
  d4:	fe843503          	ld	a0,-24(s0)
  d8:	fe043583          	ld	a1,-32(s0)
  dc:	fd843603          	ld	a2,-40(s0)
  e0:	fd043683          	ld	a3,-48(s0)
  e4:	fc843703          	ld	a4,-56(s0)
  e8:	fc043783          	ld	a5,-64(s0)
  ec:	fb843803          	ld	a6,-72(s0)
  f0:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(   //调用ecall
  f4:	00000073          	ecall
  f8:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
  fc:	fe843503          	ld	a0,-24(s0)
 100:	6426                	ld	s0,72(sp)
 102:	6161                	addi	sp,sp,80
 104:	8082                	ret

0000000000000106 <fork>:

//复制一个新进程
uint64 fork(){
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
 10e:	4885                	li	a7,1
 110:	4801                	li	a6,0
 112:	4781                	li	a5,0
 114:	4701                	li	a4,0
 116:	4681                	li	a3,0
 118:	4601                	li	a2,0
 11a:	4581                	li	a1,0
 11c:	4501                	li	a0,0
 11e:	00000097          	auipc	ra,0x0
 122:	f90080e7          	jalr	-112(ra) # ae <user_syscall>
}
 126:	60a2                	ld	ra,8(sp)
 128:	6402                	ld	s0,0(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <exit>:

//进程退出
uint64 exit(int code){
 12e:	1141                	addi	sp,sp,-16
 130:	e406                	sd	ra,8(sp)
 132:	e022                	sd	s0,0(sp)
 134:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
 136:	4889                	li	a7,2
 138:	4801                	li	a6,0
 13a:	4781                	li	a5,0
 13c:	4701                	li	a4,0
 13e:	4681                	li	a3,0
 140:	4601                	li	a2,0
 142:	4581                	li	a1,0
 144:	00000097          	auipc	ra,0x0
 148:	f6a080e7          	jalr	-150(ra) # ae <user_syscall>
}
 14c:	60a2                	ld	ra,8(sp)
 14e:	6402                	ld	s0,0(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <open>:

//打开文件
uint64 open(char *file_name, int mode){
 154:	1141                	addi	sp,sp,-16
 156:	e406                	sd	ra,8(sp)
 158:	e022                	sd	s0,0(sp)
 15a:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
 15c:	48bd                	li	a7,15
 15e:	4801                	li	a6,0
 160:	4781                	li	a5,0
 162:	4701                	li	a4,0
 164:	4681                	li	a3,0
 166:	4601                	li	a2,0
 168:	00000097          	auipc	ra,0x0
 16c:	f46080e7          	jalr	-186(ra) # ae <user_syscall>
}
 170:	60a2                	ld	ra,8(sp)
 172:	6402                	ld	s0,0(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret

0000000000000178 <read>:

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
 178:	1141                	addi	sp,sp,-16
 17a:	e406                	sd	ra,8(sp)
 17c:	e022                	sd	s0,0(sp)
 17e:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
 180:	4895                	li	a7,5
 182:	4801                	li	a6,0
 184:	4781                	li	a5,0
 186:	4701                	li	a4,0
 188:	4681                	li	a3,0
 18a:	00000097          	auipc	ra,0x0
 18e:	f24080e7          	jalr	-220(ra) # ae <user_syscall>
}
 192:	60a2                	ld	ra,8(sp)
 194:	6402                	ld	s0,0(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret

000000000000019a <kill>:

//根据pid杀死进程
uint64 kill(uint64 pid){
 19a:	1141                	addi	sp,sp,-16
 19c:	e406                	sd	ra,8(sp)
 19e:	e022                	sd	s0,0(sp)
 1a0:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
 1a2:	4899                	li	a7,6
 1a4:	4801                	li	a6,0
 1a6:	4781                	li	a5,0
 1a8:	4701                	li	a4,0
 1aa:	4681                	li	a3,0
 1ac:	4601                	li	a2,0
 1ae:	4581                	li	a1,0
 1b0:	00000097          	auipc	ra,0x0
 1b4:	efe080e7          	jalr	-258(ra) # ae <user_syscall>
}
 1b8:	60a2                	ld	ra,8(sp)
 1ba:	6402                	ld	s0,0(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret

00000000000001c0 <execve>:

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e406                	sd	ra,8(sp)
 1c4:	e022                	sd	s0,0(sp)
 1c6:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
 1c8:	0dd00893          	li	a7,221
 1cc:	4801                	li	a6,0
 1ce:	4781                	li	a5,0
 1d0:	4701                	li	a4,0
 1d2:	4681                	li	a3,0
 1d4:	00000097          	auipc	ra,0x0
 1d8:	eda080e7          	jalr	-294(ra) # ae <user_syscall>
}
 1dc:	60a2                	ld	ra,8(sp)
 1de:	6402                	ld	s0,0(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret

00000000000001e4 <simple_write>:

//一个简单的输出字符串到屏幕上的系统调用
uint64 simple_write(char *s, size_t n){
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e406                	sd	ra,8(sp)
 1e8:	e022                	sd	s0,0(sp)
 1ea:	0800                	addi	s0,sp,16
    return user_syscall((uint64)s,n,0,0,0,0,0,SYS_write);
 1ec:	48c1                	li	a7,16
 1ee:	4801                	li	a6,0
 1f0:	4781                	li	a5,0
 1f2:	4701                	li	a4,0
 1f4:	4681                	li	a3,0
 1f6:	4601                	li	a2,0
 1f8:	00000097          	auipc	ra,0x0
 1fc:	eb6080e7          	jalr	-330(ra) # ae <user_syscall>
}
 200:	60a2                	ld	ra,8(sp)
 202:	6402                	ld	s0,0(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret

0000000000000208 <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
 208:	1141                	addi	sp,sp,-16
 20a:	e406                	sd	ra,8(sp)
 20c:	e022                	sd	s0,0(sp)
 20e:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
 210:	48d5                	li	a7,21
 212:	4801                	li	a6,0
 214:	4781                	li	a5,0
 216:	4701                	li	a4,0
 218:	4681                	li	a3,0
 21a:	4601                	li	a2,0
 21c:	4581                	li	a1,0
 21e:	00000097          	auipc	ra,0x0
 222:	e90080e7          	jalr	-368(ra) # ae <user_syscall>
}
 226:	60a2                	ld	ra,8(sp)
 228:	6402                	ld	s0,0(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret

000000000000022e <clone>:

uint64 clone(uint64 flag, void *stack, size_t sz){
 22e:	1141                	addi	sp,sp,-16
 230:	e406                	sd	ra,8(sp)
 232:	e022                	sd	s0,0(sp)
 234:	0800                	addi	s0,sp,16
    if(stack!=NULL)
 236:	c191                	beqz	a1,23a <clone+0xc>
        stack+=sz;
 238:	95b2                	add	a1,a1,a2
    return user_syscall(flag,(uint64)stack,0,0,0,0,0,SYS_clone);
 23a:	0dc00893          	li	a7,220
 23e:	4801                	li	a6,0
 240:	4781                	li	a5,0
 242:	4701                	li	a4,0
 244:	4681                	li	a3,0
 246:	4601                	li	a2,0
 248:	00000097          	auipc	ra,0x0
 24c:	e66080e7          	jalr	-410(ra) # ae <user_syscall>
 250:	60a2                	ld	ra,8(sp)
 252:	6402                	ld	s0,0(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret

0000000000000258 <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
 258:	00064783          	lbu	a5,0(a2)
 25c:	20078c63          	beqz	a5,474 <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
 260:	715d                	addi	sp,sp,-80
 262:	e4a2                	sd	s0,72(sp)
 264:	e0a6                	sd	s1,64(sp)
 266:	fc4a                	sd	s2,56(sp)
 268:	f84e                	sd	s3,48(sp)
 26a:	f452                	sd	s4,40(sp)
 26c:	f056                	sd	s5,32(sp)
 26e:	ec5a                	sd	s6,24(sp)
 270:	e85e                	sd	s7,16(sp)
 272:	e462                	sd	s8,8(sp)
 274:	e066                	sd	s9,0(sp)
 276:	0880                	addi	s0,sp,80
  size_t pos = 0;
 278:	4701                	li	a4,0
  int longarg = 0;
 27a:	4b01                	li	s6,0
  int format = 0;
 27c:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 27e:	02500f93          	li	t6,37
      format = 1;
 282:	4285                	li	t0,1
      switch (*s) {
 284:	4f55                	li	t5,21
 286:	00000317          	auipc	t1,0x0
 28a:	2f230313          	addi	t1,t1,754 # 578 <printf+0xe8>
          longarg = 0;
 28e:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 290:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
 292:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 296:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 298:	58fd                	li	a7,-1
 29a:	43bd                	li	t2,15
 29c:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
 29e:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
 2a2:	03000493          	li	s1,48
 2a6:	aabd                	j	424 <vsnprintf+0x1cc>
          longarg = 1;
 2a8:	8b56                	mv	s6,s5
 2aa:	aa8d                	j	41c <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
 2ac:	00170793          	addi	a5,a4,1
 2b0:	00b7f663          	bgeu	a5,a1,2bc <vsnprintf+0x64>
 2b4:	00e50ab3          	add	s5,a0,a4
 2b8:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
 2bc:	0709                	addi	a4,a4,2
 2be:	00b77563          	bgeu	a4,a1,2c8 <vsnprintf+0x70>
 2c2:	97aa                	add	a5,a5,a0
 2c4:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 2c8:	0006bc03          	ld	s8,0(a3)
 2cc:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 2ce:	8c9e                	mv	s9,t2
 2d0:	8b66                	mv	s6,s9
 2d2:	8aba                	mv	s5,a4
 2d4:	a839                	j	2f2 <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 2d6:	fe0b19e3          	bnez	s6,2c8 <vsnprintf+0x70>
 2da:	0006ac03          	lw	s8,0(a3)
 2de:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 2e0:	8cce                	mv	s9,s3
 2e2:	b7fd                	j	2d0 <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 2e4:	015507b3          	add	a5,a0,s5
 2e8:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 2ec:	3b7d                	addiw	s6,s6,-1
 2ee:	031b0163          	beq	s6,a7,310 <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 2f2:	0a85                	addi	s5,s5,1
 2f4:	febafce3          	bgeu	s5,a1,2ec <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
 2f8:	002b179b          	slliw	a5,s6,0x2
 2fc:	40fc57b3          	sra	a5,s8,a5
 300:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 302:	05778b93          	addi	s7,a5,87
 306:	fcfecfe3          	blt	t4,a5,2e4 <vsnprintf+0x8c>
 30a:	03078b93          	addi	s7,a5,48
 30e:	bfd9                	j	2e4 <vsnprintf+0x8c>
 310:	0705                	addi	a4,a4,1
 312:	9766                	add	a4,a4,s9
          longarg = 0;
 314:	8b72                	mv	s6,t3
          format = 0;
 316:	8af2                	mv	s5,t3
 318:	a211                	j	41c <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 31a:	020b0663          	beqz	s6,346 <vsnprintf+0xee>
 31e:	0006ba83          	ld	s5,0(a3)
 322:	06a1                	addi	a3,a3,8
          if (num < 0) {
 324:	020ac563          	bltz	s5,34e <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
 328:	030ac7b3          	div	a5,s5,a6
 32c:	cf95                	beqz	a5,368 <vsnprintf+0x110>
          long digits = 1;
 32e:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 330:	0b05                	addi	s6,s6,1
 332:	0307c7b3          	div	a5,a5,a6
 336:	ffed                	bnez	a5,330 <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 338:	fffb079b          	addiw	a5,s6,-1
 33c:	0407ce63          	bltz	a5,398 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 340:	00170c93          	addi	s9,a4,1
 344:	a825                	j	37c <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 346:	0006aa83          	lw	s5,0(a3)
 34a:	06a1                	addi	a3,a3,8
 34c:	bfe1                	j	324 <vsnprintf+0xcc>
            num = -num;
 34e:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
 352:	00170793          	addi	a5,a4,1
 356:	00b7f763          	bgeu	a5,a1,364 <vsnprintf+0x10c>
 35a:	972a                	add	a4,a4,a0
 35c:	01470023          	sb	s4,0(a4)
 360:	873e                	mv	a4,a5
 362:	b7d9                	j	328 <vsnprintf+0xd0>
 364:	873e                	mv	a4,a5
 366:	b7c9                	j	328 <vsnprintf+0xd0>
          long digits = 1;
 368:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 36a:	87f2                	mv	a5,t3
 36c:	bfd1                	j	340 <vsnprintf+0xe8>
            num /= 10;
 36e:	030acab3          	div	s5,s5,a6
 372:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
 374:	02079b93          	slli	s7,a5,0x20
 378:	020bc063          	bltz	s7,398 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 37c:	00fc8bb3          	add	s7,s9,a5
 380:	febbf7e3          	bgeu	s7,a1,36e <vsnprintf+0x116>
 384:	00f70bb3          	add	s7,a4,a5
 388:	9baa                	add	s7,s7,a0
 38a:	030aec33          	rem	s8,s5,a6
 38e:	030c0c1b          	addiw	s8,s8,48
 392:	018b8023          	sb	s8,0(s7)
 396:	bfe1                	j	36e <vsnprintf+0x116>
          pos += digits;
 398:	975a                	add	a4,a4,s6
          longarg = 0;
 39a:	8b72                	mv	s6,t3
          format = 0;
 39c:	8af2                	mv	s5,t3
          break;
 39e:	a8bd                	j	41c <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 3a0:	00868b93          	addi	s7,a3,8
 3a4:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
 3a8:	000ac683          	lbu	a3,0(s5)
 3ac:	ceb9                	beqz	a3,40a <vsnprintf+0x1b2>
 3ae:	87ba                	mv	a5,a4
 3b0:	a039                	j	3be <vsnprintf+0x166>
 3b2:	40e786b3          	sub	a3,a5,a4
 3b6:	96d6                	add	a3,a3,s5
 3b8:	0006c683          	lbu	a3,0(a3)
 3bc:	ca89                	beqz	a3,3ce <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
 3be:	0785                	addi	a5,a5,1
 3c0:	feb7f9e3          	bgeu	a5,a1,3b2 <vsnprintf+0x15a>
 3c4:	00f50b33          	add	s6,a0,a5
 3c8:	fedb0fa3          	sb	a3,-1(s6)
 3cc:	b7dd                	j	3b2 <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
 3ce:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 3d0:	873e                	mv	a4,a5
          longarg = 0;
 3d2:	8b72                	mv	s6,t3
          format = 0;
 3d4:	8af2                	mv	s5,t3
 3d6:	a099                	j	41c <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 3d8:	00170793          	addi	a5,a4,1
 3dc:	02b7fb63          	bgeu	a5,a1,412 <vsnprintf+0x1ba>
 3e0:	972a                	add	a4,a4,a0
 3e2:	0006aa83          	lw	s5,0(a3)
 3e6:	01570023          	sb	s5,0(a4)
 3ea:	06a1                	addi	a3,a3,8
 3ec:	873e                	mv	a4,a5
          longarg = 0;
 3ee:	8b72                	mv	s6,t3
          format = 0;
 3f0:	8af2                	mv	s5,t3
 3f2:	a02d                	j	41c <vsnprintf+0x1c4>
    } else if (*s == '%')
 3f4:	03f78363          	beq	a5,t6,41a <vsnprintf+0x1c2>
    else if (++pos < n)
 3f8:	00170b93          	addi	s7,a4,1
 3fc:	04bbf263          	bgeu	s7,a1,440 <vsnprintf+0x1e8>
      out[pos - 1] = *s;
 400:	972a                	add	a4,a4,a0
 402:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
 406:	875e                	mv	a4,s7
 408:	a811                	j	41c <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 40a:	86de                	mv	a3,s7
          longarg = 0;
 40c:	8b72                	mv	s6,t3
          format = 0;
 40e:	8af2                	mv	s5,t3
 410:	a031                	j	41c <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 412:	873e                	mv	a4,a5
          longarg = 0;
 414:	8b72                	mv	s6,t3
          format = 0;
 416:	8af2                	mv	s5,t3
 418:	a011                	j	41c <vsnprintf+0x1c4>
      format = 1;
 41a:	8a96                	mv	s5,t0
  for (; *s; s++) {
 41c:	0605                	addi	a2,a2,1
 41e:	00064783          	lbu	a5,0(a2)
 422:	c38d                	beqz	a5,444 <vsnprintf+0x1ec>
    if (format) {
 424:	fc0a88e3          	beqz	s5,3f4 <vsnprintf+0x19c>
      switch (*s) {
 428:	f9d7879b          	addiw	a5,a5,-99
 42c:	0ff7fb93          	andi	s7,a5,255
 430:	ff7f66e3          	bltu	t5,s7,41c <vsnprintf+0x1c4>
 434:	002b9793          	slli	a5,s7,0x2
 438:	979a                	add	a5,a5,t1
 43a:	439c                	lw	a5,0(a5)
 43c:	979a                	add	a5,a5,t1
 43e:	8782                	jr	a5
    else if (++pos < n)
 440:	875e                	mv	a4,s7
 442:	bfe9                	j	41c <vsnprintf+0x1c4>
  }
  if (pos < n)
 444:	02b77363          	bgeu	a4,a1,46a <vsnprintf+0x212>
    out[pos] = 0;
 448:	953a                	add	a0,a0,a4
 44a:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 44e:	0007051b          	sext.w	a0,a4
 452:	6426                	ld	s0,72(sp)
 454:	6486                	ld	s1,64(sp)
 456:	7962                	ld	s2,56(sp)
 458:	79c2                	ld	s3,48(sp)
 45a:	7a22                	ld	s4,40(sp)
 45c:	7a82                	ld	s5,32(sp)
 45e:	6b62                	ld	s6,24(sp)
 460:	6bc2                	ld	s7,16(sp)
 462:	6c22                	ld	s8,8(sp)
 464:	6c82                	ld	s9,0(sp)
 466:	6161                	addi	sp,sp,80
 468:	8082                	ret
  else if (n)
 46a:	d1f5                	beqz	a1,44e <vsnprintf+0x1f6>
    out[n - 1] = 0;
 46c:	95aa                	add	a1,a1,a0
 46e:	fe058fa3          	sb	zero,-1(a1)
 472:	bff1                	j	44e <vsnprintf+0x1f6>
  size_t pos = 0;
 474:	4701                	li	a4,0
  if (pos < n)
 476:	00b77863          	bgeu	a4,a1,486 <vsnprintf+0x22e>
    out[pos] = 0;
 47a:	953a                	add	a0,a0,a4
 47c:	00050023          	sb	zero,0(a0)
}
 480:	0007051b          	sext.w	a0,a4
 484:	8082                	ret
  else if (n)
 486:	dded                	beqz	a1,480 <vsnprintf+0x228>
    out[n - 1] = 0;
 488:	95aa                	add	a1,a1,a0
 48a:	fe058fa3          	sb	zero,-1(a1)
 48e:	bfcd                	j	480 <vsnprintf+0x228>

0000000000000490 <printf>:
int printf(char*s, ...){
 490:	710d                	addi	sp,sp,-352
 492:	ee06                	sd	ra,280(sp)
 494:	ea22                	sd	s0,272(sp)
 496:	1200                	addi	s0,sp,288
 498:	e40c                	sd	a1,8(s0)
 49a:	e810                	sd	a2,16(s0)
 49c:	ec14                	sd	a3,24(s0)
 49e:	f018                	sd	a4,32(s0)
 4a0:	f41c                	sd	a5,40(s0)
 4a2:	03043823          	sd	a6,48(s0)
 4a6:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 4aa:	00840693          	addi	a3,s0,8
 4ae:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 4b2:	862a                	mv	a2,a0
 4b4:	10000593          	li	a1,256
 4b8:	ee840513          	addi	a0,s0,-280
 4bc:	00000097          	auipc	ra,0x0
 4c0:	d9c080e7          	jalr	-612(ra) # 258 <vsnprintf>
 4c4:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 4c6:	0005071b          	sext.w	a4,a0
 4ca:	0ff00793          	li	a5,255
 4ce:	00e7f463          	bgeu	a5,a4,4d6 <printf+0x46>
 4d2:	10000593          	li	a1,256
    return simple_write(buf, n);
 4d6:	ee840513          	addi	a0,s0,-280
 4da:	00000097          	auipc	ra,0x0
 4de:	d0a080e7          	jalr	-758(ra) # 1e4 <simple_write>
}
 4e2:	2501                	sext.w	a0,a0
 4e4:	60f2                	ld	ra,280(sp)
 4e6:	6452                	ld	s0,272(sp)
 4e8:	6135                	addi	sp,sp,352
 4ea:	8082                	ret
