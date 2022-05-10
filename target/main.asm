
target/main：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "stdio.h"
#include "user_syscall.h"

int main(int argc, char *argv[]){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
    printf("test begin!\n");
  10:	00000517          	auipc	a0,0x0
  14:	4a050513          	addi	a0,a0,1184 # 4b0 <printf+0x5e>
  18:	00000097          	auipc	ra,0x0
  1c:	43a080e7          	jalr	1082(ra) # 452 <printf>
    printf("argc: %d\n",argc);
  20:	85a6                	mv	a1,s1
  22:	00000517          	auipc	a0,0x0
  26:	49e50513          	addi	a0,a0,1182 # 4c0 <printf+0x6e>
  2a:	00000097          	auipc	ra,0x0
  2e:	428080e7          	jalr	1064(ra) # 452 <printf>
    for(int i=0;i<4;i++){
  32:	84ca                	mv	s1,s2
  34:	02090913          	addi	s2,s2,32
        printf(argv[i]);
  38:	6088                	ld	a0,0(s1)
  3a:	00000097          	auipc	ra,0x0
  3e:	418080e7          	jalr	1048(ra) # 452 <printf>
  42:	04a1                	addi	s1,s1,8
    for(int i=0;i<4;i++){
  44:	ff249ae3          	bne	s1,s2,38 <main+0x38>
    }
    printf("test end!\n");    
  48:	00000517          	auipc	a0,0x0
  4c:	48850513          	addi	a0,a0,1160 # 4d0 <printf+0x7e>
  50:	00000097          	auipc	ra,0x0
  54:	402080e7          	jalr	1026(ra) # 452 <printf>
    exit(0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	096080e7          	jalr	150(ra) # f0 <exit>
    return 0;
}
  62:	4501                	li	a0,0
  64:	60e2                	ld	ra,24(sp)
  66:	6442                	ld	s0,16(sp)
  68:	64a2                	ld	s1,8(sp)
  6a:	6902                	ld	s2,0(sp)
  6c:	6105                	addi	sp,sp,32
  6e:	8082                	ret

0000000000000070 <user_syscall>:
/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
  70:	715d                	addi	sp,sp,-80
  72:	e4a2                	sd	s0,72(sp)
  74:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
  76:	fea43423          	sd	a0,-24(s0)
  7a:	feb43023          	sd	a1,-32(s0)
  7e:	fcc43c23          	sd	a2,-40(s0)
  82:	fcd43823          	sd	a3,-48(s0)
  86:	fce43423          	sd	a4,-56(s0)
  8a:	fcf43023          	sd	a5,-64(s0)
  8e:	fb043c23          	sd	a6,-72(s0)
  92:	fb143823          	sd	a7,-80(s0)
        asm volatile(   //将参数写入a0-a7寄存器
  96:	fe843503          	ld	a0,-24(s0)
  9a:	fe043583          	ld	a1,-32(s0)
  9e:	fd843603          	ld	a2,-40(s0)
  a2:	fd043683          	ld	a3,-48(s0)
  a6:	fc843703          	ld	a4,-56(s0)
  aa:	fc043783          	ld	a5,-64(s0)
  ae:	fb843803          	ld	a6,-72(s0)
  b2:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(   //调用ecall
  b6:	00000073          	ecall
  ba:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
  be:	fe843503          	ld	a0,-24(s0)
  c2:	6426                	ld	s0,72(sp)
  c4:	6161                	addi	sp,sp,80
  c6:	8082                	ret

00000000000000c8 <fork>:

//复制一个新进程
uint64 fork(){
  c8:	1141                	addi	sp,sp,-16
  ca:	e406                	sd	ra,8(sp)
  cc:	e022                	sd	s0,0(sp)
  ce:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
  d0:	4885                	li	a7,1
  d2:	4801                	li	a6,0
  d4:	4781                	li	a5,0
  d6:	4701                	li	a4,0
  d8:	4681                	li	a3,0
  da:	4601                	li	a2,0
  dc:	4581                	li	a1,0
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	f90080e7          	jalr	-112(ra) # 70 <user_syscall>
}
  e8:	60a2                	ld	ra,8(sp)
  ea:	6402                	ld	s0,0(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret

00000000000000f0 <exit>:

//进程退出
uint64 exit(int code){
  f0:	1141                	addi	sp,sp,-16
  f2:	e406                	sd	ra,8(sp)
  f4:	e022                	sd	s0,0(sp)
  f6:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
  f8:	4889                	li	a7,2
  fa:	4801                	li	a6,0
  fc:	4781                	li	a5,0
  fe:	4701                	li	a4,0
 100:	4681                	li	a3,0
 102:	4601                	li	a2,0
 104:	4581                	li	a1,0
 106:	00000097          	auipc	ra,0x0
 10a:	f6a080e7          	jalr	-150(ra) # 70 <user_syscall>
}
 10e:	60a2                	ld	ra,8(sp)
 110:	6402                	ld	s0,0(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <open>:

//打开文件
uint64 open(char *file_name, int mode){
 116:	1141                	addi	sp,sp,-16
 118:	e406                	sd	ra,8(sp)
 11a:	e022                	sd	s0,0(sp)
 11c:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
 11e:	48bd                	li	a7,15
 120:	4801                	li	a6,0
 122:	4781                	li	a5,0
 124:	4701                	li	a4,0
 126:	4681                	li	a3,0
 128:	4601                	li	a2,0
 12a:	00000097          	auipc	ra,0x0
 12e:	f46080e7          	jalr	-186(ra) # 70 <user_syscall>
}
 132:	60a2                	ld	ra,8(sp)
 134:	6402                	ld	s0,0(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <read>:

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
 13a:	1141                	addi	sp,sp,-16
 13c:	e406                	sd	ra,8(sp)
 13e:	e022                	sd	s0,0(sp)
 140:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
 142:	4895                	li	a7,5
 144:	4801                	li	a6,0
 146:	4781                	li	a5,0
 148:	4701                	li	a4,0
 14a:	4681                	li	a3,0
 14c:	00000097          	auipc	ra,0x0
 150:	f24080e7          	jalr	-220(ra) # 70 <user_syscall>
}
 154:	60a2                	ld	ra,8(sp)
 156:	6402                	ld	s0,0(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret

000000000000015c <kill>:

//根据pid杀死进程
uint64 kill(uint64 pid){
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
 164:	4899                	li	a7,6
 166:	4801                	li	a6,0
 168:	4781                	li	a5,0
 16a:	4701                	li	a4,0
 16c:	4681                	li	a3,0
 16e:	4601                	li	a2,0
 170:	4581                	li	a1,0
 172:	00000097          	auipc	ra,0x0
 176:	efe080e7          	jalr	-258(ra) # 70 <user_syscall>
}
 17a:	60a2                	ld	ra,8(sp)
 17c:	6402                	ld	s0,0(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret

0000000000000182 <execve>:

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
 182:	1141                	addi	sp,sp,-16
 184:	e406                	sd	ra,8(sp)
 186:	e022                	sd	s0,0(sp)
 188:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
 18a:	0dd00893          	li	a7,221
 18e:	4801                	li	a6,0
 190:	4781                	li	a5,0
 192:	4701                	li	a4,0
 194:	4681                	li	a3,0
 196:	00000097          	auipc	ra,0x0
 19a:	eda080e7          	jalr	-294(ra) # 70 <user_syscall>
}
 19e:	60a2                	ld	ra,8(sp)
 1a0:	6402                	ld	s0,0(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <simple_write>:

//一个简单的输出字符串到屏幕上的系统调用
uint64 simple_write(char *s, size_t n){
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e406                	sd	ra,8(sp)
 1aa:	e022                	sd	s0,0(sp)
 1ac:	0800                	addi	s0,sp,16
    return user_syscall((uint64)s,n,0,0,0,0,0,SYS_write);
 1ae:	48c1                	li	a7,16
 1b0:	4801                	li	a6,0
 1b2:	4781                	li	a5,0
 1b4:	4701                	li	a4,0
 1b6:	4681                	li	a3,0
 1b8:	4601                	li	a2,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	eb6080e7          	jalr	-330(ra) # 70 <user_syscall>
}
 1c2:	60a2                	ld	ra,8(sp)
 1c4:	6402                	ld	s0,0(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret

00000000000001ca <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e406                	sd	ra,8(sp)
 1ce:	e022                	sd	s0,0(sp)
 1d0:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
 1d2:	48d5                	li	a7,21
 1d4:	4801                	li	a6,0
 1d6:	4781                	li	a5,0
 1d8:	4701                	li	a4,0
 1da:	4681                	li	a3,0
 1dc:	4601                	li	a2,0
 1de:	4581                	li	a1,0
 1e0:	00000097          	auipc	ra,0x0
 1e4:	e90080e7          	jalr	-368(ra) # 70 <user_syscall>
}
 1e8:	60a2                	ld	ra,8(sp)
 1ea:	6402                	ld	s0,0(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret

00000000000001f0 <clone>:

uint64 clone(uint64 flag, void *stack, size_t sz){
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e406                	sd	ra,8(sp)
 1f4:	e022                	sd	s0,0(sp)
 1f6:	0800                	addi	s0,sp,16
    if(stack!=NULL)
 1f8:	c191                	beqz	a1,1fc <clone+0xc>
        stack+=sz;
 1fa:	95b2                	add	a1,a1,a2
    return user_syscall(flag,(uint64)stack,0,0,0,0,0,SYS_clone);
 1fc:	0dc00893          	li	a7,220
 200:	4801                	li	a6,0
 202:	4781                	li	a5,0
 204:	4701                	li	a4,0
 206:	4681                	li	a3,0
 208:	4601                	li	a2,0
 20a:	00000097          	auipc	ra,0x0
 20e:	e66080e7          	jalr	-410(ra) # 70 <user_syscall>
 212:	60a2                	ld	ra,8(sp)
 214:	6402                	ld	s0,0(sp)
 216:	0141                	addi	sp,sp,16
 218:	8082                	ret

000000000000021a <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
 21a:	00064783          	lbu	a5,0(a2)
 21e:	20078c63          	beqz	a5,436 <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
 222:	715d                	addi	sp,sp,-80
 224:	e4a2                	sd	s0,72(sp)
 226:	e0a6                	sd	s1,64(sp)
 228:	fc4a                	sd	s2,56(sp)
 22a:	f84e                	sd	s3,48(sp)
 22c:	f452                	sd	s4,40(sp)
 22e:	f056                	sd	s5,32(sp)
 230:	ec5a                	sd	s6,24(sp)
 232:	e85e                	sd	s7,16(sp)
 234:	e462                	sd	s8,8(sp)
 236:	e066                	sd	s9,0(sp)
 238:	0880                	addi	s0,sp,80
  size_t pos = 0;
 23a:	4701                	li	a4,0
  int longarg = 0;
 23c:	4b01                	li	s6,0
  int format = 0;
 23e:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 240:	02500f93          	li	t6,37
      format = 1;
 244:	4285                	li	t0,1
      switch (*s) {
 246:	4f55                	li	t5,21
 248:	00000317          	auipc	t1,0x0
 24c:	29830313          	addi	t1,t1,664 # 4e0 <printf+0x8e>
          longarg = 0;
 250:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 252:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
 254:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 258:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 25a:	58fd                	li	a7,-1
 25c:	43bd                	li	t2,15
 25e:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
 260:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
 264:	03000493          	li	s1,48
 268:	aabd                	j	3e6 <vsnprintf+0x1cc>
          longarg = 1;
 26a:	8b56                	mv	s6,s5
 26c:	aa8d                	j	3de <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
 26e:	00170793          	addi	a5,a4,1
 272:	00b7f663          	bgeu	a5,a1,27e <vsnprintf+0x64>
 276:	00e50ab3          	add	s5,a0,a4
 27a:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
 27e:	0709                	addi	a4,a4,2
 280:	00b77563          	bgeu	a4,a1,28a <vsnprintf+0x70>
 284:	97aa                	add	a5,a5,a0
 286:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 28a:	0006bc03          	ld	s8,0(a3)
 28e:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 290:	8c9e                	mv	s9,t2
 292:	8b66                	mv	s6,s9
 294:	8aba                	mv	s5,a4
 296:	a839                	j	2b4 <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 298:	fe0b19e3          	bnez	s6,28a <vsnprintf+0x70>
 29c:	0006ac03          	lw	s8,0(a3)
 2a0:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 2a2:	8cce                	mv	s9,s3
 2a4:	b7fd                	j	292 <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 2a6:	015507b3          	add	a5,a0,s5
 2aa:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 2ae:	3b7d                	addiw	s6,s6,-1
 2b0:	031b0163          	beq	s6,a7,2d2 <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 2b4:	0a85                	addi	s5,s5,1
 2b6:	febafce3          	bgeu	s5,a1,2ae <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
 2ba:	002b179b          	slliw	a5,s6,0x2
 2be:	40fc57b3          	sra	a5,s8,a5
 2c2:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 2c4:	05778b93          	addi	s7,a5,87
 2c8:	fcfecfe3          	blt	t4,a5,2a6 <vsnprintf+0x8c>
 2cc:	03078b93          	addi	s7,a5,48
 2d0:	bfd9                	j	2a6 <vsnprintf+0x8c>
 2d2:	0705                	addi	a4,a4,1
 2d4:	9766                	add	a4,a4,s9
          longarg = 0;
 2d6:	8b72                	mv	s6,t3
          format = 0;
 2d8:	8af2                	mv	s5,t3
 2da:	a211                	j	3de <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 2dc:	020b0663          	beqz	s6,308 <vsnprintf+0xee>
 2e0:	0006ba83          	ld	s5,0(a3)
 2e4:	06a1                	addi	a3,a3,8
          if (num < 0) {
 2e6:	020ac563          	bltz	s5,310 <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
 2ea:	030ac7b3          	div	a5,s5,a6
 2ee:	cf95                	beqz	a5,32a <vsnprintf+0x110>
          long digits = 1;
 2f0:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 2f2:	0b05                	addi	s6,s6,1
 2f4:	0307c7b3          	div	a5,a5,a6
 2f8:	ffed                	bnez	a5,2f2 <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 2fa:	fffb079b          	addiw	a5,s6,-1
 2fe:	0407ce63          	bltz	a5,35a <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 302:	00170c93          	addi	s9,a4,1
 306:	a825                	j	33e <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 308:	0006aa83          	lw	s5,0(a3)
 30c:	06a1                	addi	a3,a3,8
 30e:	bfe1                	j	2e6 <vsnprintf+0xcc>
            num = -num;
 310:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
 314:	00170793          	addi	a5,a4,1
 318:	00b7f763          	bgeu	a5,a1,326 <vsnprintf+0x10c>
 31c:	972a                	add	a4,a4,a0
 31e:	01470023          	sb	s4,0(a4)
 322:	873e                	mv	a4,a5
 324:	b7d9                	j	2ea <vsnprintf+0xd0>
 326:	873e                	mv	a4,a5
 328:	b7c9                	j	2ea <vsnprintf+0xd0>
          long digits = 1;
 32a:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 32c:	87f2                	mv	a5,t3
 32e:	bfd1                	j	302 <vsnprintf+0xe8>
            num /= 10;
 330:	030acab3          	div	s5,s5,a6
 334:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
 336:	02079b93          	slli	s7,a5,0x20
 33a:	020bc063          	bltz	s7,35a <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 33e:	00fc8bb3          	add	s7,s9,a5
 342:	febbf7e3          	bgeu	s7,a1,330 <vsnprintf+0x116>
 346:	00f70bb3          	add	s7,a4,a5
 34a:	9baa                	add	s7,s7,a0
 34c:	030aec33          	rem	s8,s5,a6
 350:	030c0c1b          	addiw	s8,s8,48
 354:	018b8023          	sb	s8,0(s7)
 358:	bfe1                	j	330 <vsnprintf+0x116>
          pos += digits;
 35a:	975a                	add	a4,a4,s6
          longarg = 0;
 35c:	8b72                	mv	s6,t3
          format = 0;
 35e:	8af2                	mv	s5,t3
          break;
 360:	a8bd                	j	3de <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 362:	00868b93          	addi	s7,a3,8
 366:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
 36a:	000ac683          	lbu	a3,0(s5)
 36e:	ceb9                	beqz	a3,3cc <vsnprintf+0x1b2>
 370:	87ba                	mv	a5,a4
 372:	a039                	j	380 <vsnprintf+0x166>
 374:	40e786b3          	sub	a3,a5,a4
 378:	96d6                	add	a3,a3,s5
 37a:	0006c683          	lbu	a3,0(a3)
 37e:	ca89                	beqz	a3,390 <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
 380:	0785                	addi	a5,a5,1
 382:	feb7f9e3          	bgeu	a5,a1,374 <vsnprintf+0x15a>
 386:	00f50b33          	add	s6,a0,a5
 38a:	fedb0fa3          	sb	a3,-1(s6)
 38e:	b7dd                	j	374 <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
 390:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 392:	873e                	mv	a4,a5
          longarg = 0;
 394:	8b72                	mv	s6,t3
          format = 0;
 396:	8af2                	mv	s5,t3
 398:	a099                	j	3de <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 39a:	00170793          	addi	a5,a4,1
 39e:	02b7fb63          	bgeu	a5,a1,3d4 <vsnprintf+0x1ba>
 3a2:	972a                	add	a4,a4,a0
 3a4:	0006aa83          	lw	s5,0(a3)
 3a8:	01570023          	sb	s5,0(a4)
 3ac:	06a1                	addi	a3,a3,8
 3ae:	873e                	mv	a4,a5
          longarg = 0;
 3b0:	8b72                	mv	s6,t3
          format = 0;
 3b2:	8af2                	mv	s5,t3
 3b4:	a02d                	j	3de <vsnprintf+0x1c4>
    } else if (*s == '%')
 3b6:	03f78363          	beq	a5,t6,3dc <vsnprintf+0x1c2>
    else if (++pos < n)
 3ba:	00170b93          	addi	s7,a4,1
 3be:	04bbf263          	bgeu	s7,a1,402 <vsnprintf+0x1e8>
      out[pos - 1] = *s;
 3c2:	972a                	add	a4,a4,a0
 3c4:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
 3c8:	875e                	mv	a4,s7
 3ca:	a811                	j	3de <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 3cc:	86de                	mv	a3,s7
          longarg = 0;
 3ce:	8b72                	mv	s6,t3
          format = 0;
 3d0:	8af2                	mv	s5,t3
 3d2:	a031                	j	3de <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 3d4:	873e                	mv	a4,a5
          longarg = 0;
 3d6:	8b72                	mv	s6,t3
          format = 0;
 3d8:	8af2                	mv	s5,t3
 3da:	a011                	j	3de <vsnprintf+0x1c4>
      format = 1;
 3dc:	8a96                	mv	s5,t0
  for (; *s; s++) {
 3de:	0605                	addi	a2,a2,1
 3e0:	00064783          	lbu	a5,0(a2)
 3e4:	c38d                	beqz	a5,406 <vsnprintf+0x1ec>
    if (format) {
 3e6:	fc0a88e3          	beqz	s5,3b6 <vsnprintf+0x19c>
      switch (*s) {
 3ea:	f9d7879b          	addiw	a5,a5,-99
 3ee:	0ff7fb93          	andi	s7,a5,255
 3f2:	ff7f66e3          	bltu	t5,s7,3de <vsnprintf+0x1c4>
 3f6:	002b9793          	slli	a5,s7,0x2
 3fa:	979a                	add	a5,a5,t1
 3fc:	439c                	lw	a5,0(a5)
 3fe:	979a                	add	a5,a5,t1
 400:	8782                	jr	a5
    else if (++pos < n)
 402:	875e                	mv	a4,s7
 404:	bfe9                	j	3de <vsnprintf+0x1c4>
  }
  if (pos < n)
 406:	02b77363          	bgeu	a4,a1,42c <vsnprintf+0x212>
    out[pos] = 0;
 40a:	953a                	add	a0,a0,a4
 40c:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 410:	0007051b          	sext.w	a0,a4
 414:	6426                	ld	s0,72(sp)
 416:	6486                	ld	s1,64(sp)
 418:	7962                	ld	s2,56(sp)
 41a:	79c2                	ld	s3,48(sp)
 41c:	7a22                	ld	s4,40(sp)
 41e:	7a82                	ld	s5,32(sp)
 420:	6b62                	ld	s6,24(sp)
 422:	6bc2                	ld	s7,16(sp)
 424:	6c22                	ld	s8,8(sp)
 426:	6c82                	ld	s9,0(sp)
 428:	6161                	addi	sp,sp,80
 42a:	8082                	ret
  else if (n)
 42c:	d1f5                	beqz	a1,410 <vsnprintf+0x1f6>
    out[n - 1] = 0;
 42e:	95aa                	add	a1,a1,a0
 430:	fe058fa3          	sb	zero,-1(a1)
 434:	bff1                	j	410 <vsnprintf+0x1f6>
  size_t pos = 0;
 436:	4701                	li	a4,0
  if (pos < n)
 438:	00b77863          	bgeu	a4,a1,448 <vsnprintf+0x22e>
    out[pos] = 0;
 43c:	953a                	add	a0,a0,a4
 43e:	00050023          	sb	zero,0(a0)
}
 442:	0007051b          	sext.w	a0,a4
 446:	8082                	ret
  else if (n)
 448:	dded                	beqz	a1,442 <vsnprintf+0x228>
    out[n - 1] = 0;
 44a:	95aa                	add	a1,a1,a0
 44c:	fe058fa3          	sb	zero,-1(a1)
 450:	bfcd                	j	442 <vsnprintf+0x228>

0000000000000452 <printf>:
int printf(char*s, ...){
 452:	710d                	addi	sp,sp,-352
 454:	ee06                	sd	ra,280(sp)
 456:	ea22                	sd	s0,272(sp)
 458:	1200                	addi	s0,sp,288
 45a:	e40c                	sd	a1,8(s0)
 45c:	e810                	sd	a2,16(s0)
 45e:	ec14                	sd	a3,24(s0)
 460:	f018                	sd	a4,32(s0)
 462:	f41c                	sd	a5,40(s0)
 464:	03043823          	sd	a6,48(s0)
 468:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 46c:	00840693          	addi	a3,s0,8
 470:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 474:	862a                	mv	a2,a0
 476:	10000593          	li	a1,256
 47a:	ee840513          	addi	a0,s0,-280
 47e:	00000097          	auipc	ra,0x0
 482:	d9c080e7          	jalr	-612(ra) # 21a <vsnprintf>
 486:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 488:	0005071b          	sext.w	a4,a0
 48c:	0ff00793          	li	a5,255
 490:	00e7f463          	bgeu	a5,a4,498 <printf+0x46>
 494:	10000593          	li	a1,256
    return simple_write(buf, n);
 498:	ee840513          	addi	a0,s0,-280
 49c:	00000097          	auipc	ra,0x0
 4a0:	d0a080e7          	jalr	-758(ra) # 1a6 <simple_write>
}
 4a4:	2501                	sext.w	a0,a0
 4a6:	60f2                	ld	ra,280(sp)
 4a8:	6452                	ld	s0,272(sp)
 4aa:	6135                	addi	sp,sp,352
 4ac:	8082                	ret
