
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
   c:	892a                	mv	s2,a0
   e:	84ae                	mv	s1,a1
    printf("test begin!\n");
  10:	00000517          	auipc	a0,0x0
  14:	46050513          	addi	a0,a0,1120 # 470 <printf+0x5c>
  18:	00000097          	auipc	ra,0x0
  1c:	3fc080e7          	jalr	1020(ra) # 414 <printf>
    printf("argc: %d\n",argc);
  20:	85ca                	mv	a1,s2
  22:	00000517          	auipc	a0,0x0
  26:	45e50513          	addi	a0,a0,1118 # 480 <printf+0x6c>
  2a:	00000097          	auipc	ra,0x0
  2e:	3ea080e7          	jalr	1002(ra) # 414 <printf>
    for(int i=0;i<4;i++){
  32:	8926                	mv	s2,s1
  34:	02048493          	addi	s1,s1,32
        printf(argv[i]);
  38:	00093503          	ld	a0,0(s2)
  3c:	00000097          	auipc	ra,0x0
  40:	3d8080e7          	jalr	984(ra) # 414 <printf>
  44:	0921                	addi	s2,s2,8
    for(int i=0;i<4;i++){
  46:	fe9919e3          	bne	s2,s1,38 <main+0x38>
    }
    printf("test end!\n");    
  4a:	00000517          	auipc	a0,0x0
  4e:	44650513          	addi	a0,a0,1094 # 490 <printf+0x7c>
  52:	00000097          	auipc	ra,0x0
  56:	3c2080e7          	jalr	962(ra) # 414 <printf>
    while(1){}
  5a:	a001                	j	5a <main+0x5a>

000000000000005c <user_syscall>:
/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
  5c:	715d                	addi	sp,sp,-80
  5e:	e4a2                	sd	s0,72(sp)
  60:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
  62:	fea43423          	sd	a0,-24(s0)
  66:	feb43023          	sd	a1,-32(s0)
  6a:	fcc43c23          	sd	a2,-40(s0)
  6e:	fcd43823          	sd	a3,-48(s0)
  72:	fce43423          	sd	a4,-56(s0)
  76:	fcf43023          	sd	a5,-64(s0)
  7a:	fb043c23          	sd	a6,-72(s0)
  7e:	fb143823          	sd	a7,-80(s0)
        asm volatile(   //将参数写入a0-a7寄存器
  82:	fe843503          	ld	a0,-24(s0)
  86:	fe043583          	ld	a1,-32(s0)
  8a:	fd843603          	ld	a2,-40(s0)
  8e:	fd043683          	ld	a3,-48(s0)
  92:	fc843703          	ld	a4,-56(s0)
  96:	fc043783          	ld	a5,-64(s0)
  9a:	fb843803          	ld	a6,-72(s0)
  9e:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(   //调用ecall
  a2:	00000073          	ecall
  a6:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
  aa:	fe843503          	ld	a0,-24(s0)
  ae:	6426                	ld	s0,72(sp)
  b0:	6161                	addi	sp,sp,80
  b2:	8082                	ret

00000000000000b4 <fork>:

//复制一个新进程
uint64 fork(){
  b4:	1141                	addi	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
  bc:	4885                	li	a7,1
  be:	4801                	li	a6,0
  c0:	4781                	li	a5,0
  c2:	4701                	li	a4,0
  c4:	4681                	li	a3,0
  c6:	4601                	li	a2,0
  c8:	4581                	li	a1,0
  ca:	4501                	li	a0,0
  cc:	00000097          	auipc	ra,0x0
  d0:	f90080e7          	jalr	-112(ra) # 5c <user_syscall>
}
  d4:	60a2                	ld	ra,8(sp)
  d6:	6402                	ld	s0,0(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <exit>:

//进程退出
uint64 exit(int code){
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
  e4:	4889                	li	a7,2
  e6:	4801                	li	a6,0
  e8:	4781                	li	a5,0
  ea:	4701                	li	a4,0
  ec:	4681                	li	a3,0
  ee:	4601                	li	a2,0
  f0:	4581                	li	a1,0
  f2:	00000097          	auipc	ra,0x0
  f6:	f6a080e7          	jalr	-150(ra) # 5c <user_syscall>
}
  fa:	60a2                	ld	ra,8(sp)
  fc:	6402                	ld	s0,0(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret

0000000000000102 <open>:

//打开文件
uint64 open(char *file_name, int mode){
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
 10a:	48bd                	li	a7,15
 10c:	4801                	li	a6,0
 10e:	4781                	li	a5,0
 110:	4701                	li	a4,0
 112:	4681                	li	a3,0
 114:	4601                	li	a2,0
 116:	00000097          	auipc	ra,0x0
 11a:	f46080e7          	jalr	-186(ra) # 5c <user_syscall>
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <read>:

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
 12e:	4895                	li	a7,5
 130:	4801                	li	a6,0
 132:	4781                	li	a5,0
 134:	4701                	li	a4,0
 136:	4681                	li	a3,0
 138:	00000097          	auipc	ra,0x0
 13c:	f24080e7          	jalr	-220(ra) # 5c <user_syscall>
}
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <kill>:

//根据pid杀死进程
uint64 kill(uint64 pid){
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
 150:	4899                	li	a7,6
 152:	4801                	li	a6,0
 154:	4781                	li	a5,0
 156:	4701                	li	a4,0
 158:	4681                	li	a3,0
 15a:	4601                	li	a2,0
 15c:	4581                	li	a1,0
 15e:	00000097          	auipc	ra,0x0
 162:	efe080e7          	jalr	-258(ra) # 5c <user_syscall>
}
 166:	60a2                	ld	ra,8(sp)
 168:	6402                	ld	s0,0(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <execve>:

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
 176:	0dd00893          	li	a7,221
 17a:	4801                	li	a6,0
 17c:	4781                	li	a5,0
 17e:	4701                	li	a4,0
 180:	4681                	li	a3,0
 182:	00000097          	auipc	ra,0x0
 186:	eda080e7          	jalr	-294(ra) # 5c <user_syscall>
}
 18a:	60a2                	ld	ra,8(sp)
 18c:	6402                	ld	s0,0(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret

0000000000000192 <simple_write>:

//一个简单的输出字符串到屏幕上的系统调用
uint64 simple_write(char *s, size_t n){
 192:	1141                	addi	sp,sp,-16
 194:	e406                	sd	ra,8(sp)
 196:	e022                	sd	s0,0(sp)
 198:	0800                	addi	s0,sp,16
    return user_syscall((uint64)s,n,0,0,0,0,0,SYS_write);
 19a:	48c1                	li	a7,16
 19c:	4801                	li	a6,0
 19e:	4781                	li	a5,0
 1a0:	4701                	li	a4,0
 1a2:	4681                	li	a3,0
 1a4:	4601                	li	a2,0
 1a6:	00000097          	auipc	ra,0x0
 1aa:	eb6080e7          	jalr	-330(ra) # 5c <user_syscall>
}
 1ae:	60a2                	ld	ra,8(sp)
 1b0:	6402                	ld	s0,0(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e406                	sd	ra,8(sp)
 1ba:	e022                	sd	s0,0(sp)
 1bc:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
 1be:	48d5                	li	a7,21
 1c0:	4801                	li	a6,0
 1c2:	4781                	li	a5,0
 1c4:	4701                	li	a4,0
 1c6:	4681                	li	a3,0
 1c8:	4601                	li	a2,0
 1ca:	4581                	li	a1,0
 1cc:	00000097          	auipc	ra,0x0
 1d0:	e90080e7          	jalr	-368(ra) # 5c <user_syscall>
}
 1d4:	60a2                	ld	ra,8(sp)
 1d6:	6402                	ld	s0,0(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret

00000000000001dc <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
 1dc:	00064783          	lbu	a5,0(a2)
 1e0:	20078c63          	beqz	a5,3f8 <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
 1e4:	715d                	addi	sp,sp,-80
 1e6:	e4a2                	sd	s0,72(sp)
 1e8:	e0a6                	sd	s1,64(sp)
 1ea:	fc4a                	sd	s2,56(sp)
 1ec:	f84e                	sd	s3,48(sp)
 1ee:	f452                	sd	s4,40(sp)
 1f0:	f056                	sd	s5,32(sp)
 1f2:	ec5a                	sd	s6,24(sp)
 1f4:	e85e                	sd	s7,16(sp)
 1f6:	e462                	sd	s8,8(sp)
 1f8:	e066                	sd	s9,0(sp)
 1fa:	0880                	addi	s0,sp,80
  size_t pos = 0;
 1fc:	4701                	li	a4,0
  int longarg = 0;
 1fe:	4b01                	li	s6,0
  int format = 0;
 200:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 202:	02500f93          	li	t6,37
      format = 1;
 206:	4285                	li	t0,1
      switch (*s) {
 208:	4f55                	li	t5,21
 20a:	00000317          	auipc	t1,0x0
 20e:	29630313          	addi	t1,t1,662 # 4a0 <printf+0x8c>
          longarg = 0;
 212:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 214:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
 216:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 21a:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 21c:	58fd                	li	a7,-1
 21e:	43bd                	li	t2,15
 220:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
 222:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
 226:	03000493          	li	s1,48
 22a:	aabd                	j	3a8 <vsnprintf+0x1cc>
          longarg = 1;
 22c:	8b56                	mv	s6,s5
 22e:	aa8d                	j	3a0 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
 230:	00170793          	addi	a5,a4,1
 234:	00b7f663          	bgeu	a5,a1,240 <vsnprintf+0x64>
 238:	00e50ab3          	add	s5,a0,a4
 23c:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
 240:	0709                	addi	a4,a4,2
 242:	00b77563          	bgeu	a4,a1,24c <vsnprintf+0x70>
 246:	97aa                	add	a5,a5,a0
 248:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 24c:	0006bc03          	ld	s8,0(a3)
 250:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 252:	8c9e                	mv	s9,t2
 254:	8b66                	mv	s6,s9
 256:	8aba                	mv	s5,a4
 258:	a839                	j	276 <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 25a:	fe0b19e3          	bnez	s6,24c <vsnprintf+0x70>
 25e:	0006ac03          	lw	s8,0(a3)
 262:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 264:	8cce                	mv	s9,s3
 266:	b7fd                	j	254 <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 268:	015507b3          	add	a5,a0,s5
 26c:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 270:	3b7d                	addiw	s6,s6,-1
 272:	031b0163          	beq	s6,a7,294 <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 276:	0a85                	addi	s5,s5,1
 278:	febafce3          	bgeu	s5,a1,270 <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
 27c:	002b179b          	slliw	a5,s6,0x2
 280:	40fc57b3          	sra	a5,s8,a5
 284:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 286:	05778b93          	addi	s7,a5,87
 28a:	fcfecfe3          	blt	t4,a5,268 <vsnprintf+0x8c>
 28e:	03078b93          	addi	s7,a5,48
 292:	bfd9                	j	268 <vsnprintf+0x8c>
 294:	0705                	addi	a4,a4,1
 296:	9766                	add	a4,a4,s9
          longarg = 0;
 298:	8b72                	mv	s6,t3
          format = 0;
 29a:	8af2                	mv	s5,t3
 29c:	a211                	j	3a0 <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 29e:	020b0663          	beqz	s6,2ca <vsnprintf+0xee>
 2a2:	0006ba83          	ld	s5,0(a3)
 2a6:	06a1                	addi	a3,a3,8
          if (num < 0) {
 2a8:	020ac563          	bltz	s5,2d2 <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
 2ac:	030ac7b3          	div	a5,s5,a6
 2b0:	cf95                	beqz	a5,2ec <vsnprintf+0x110>
          long digits = 1;
 2b2:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 2b4:	0b05                	addi	s6,s6,1
 2b6:	0307c7b3          	div	a5,a5,a6
 2ba:	ffed                	bnez	a5,2b4 <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 2bc:	fffb079b          	addiw	a5,s6,-1
 2c0:	0407ce63          	bltz	a5,31c <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 2c4:	00170c93          	addi	s9,a4,1
 2c8:	a825                	j	300 <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 2ca:	0006aa83          	lw	s5,0(a3)
 2ce:	06a1                	addi	a3,a3,8
 2d0:	bfe1                	j	2a8 <vsnprintf+0xcc>
            num = -num;
 2d2:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
 2d6:	00170793          	addi	a5,a4,1
 2da:	00b7f763          	bgeu	a5,a1,2e8 <vsnprintf+0x10c>
 2de:	972a                	add	a4,a4,a0
 2e0:	01470023          	sb	s4,0(a4)
 2e4:	873e                	mv	a4,a5
 2e6:	b7d9                	j	2ac <vsnprintf+0xd0>
 2e8:	873e                	mv	a4,a5
 2ea:	b7c9                	j	2ac <vsnprintf+0xd0>
          long digits = 1;
 2ec:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 2ee:	87f2                	mv	a5,t3
 2f0:	bfd1                	j	2c4 <vsnprintf+0xe8>
            num /= 10;
 2f2:	030acab3          	div	s5,s5,a6
 2f6:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
 2f8:	02079b93          	slli	s7,a5,0x20
 2fc:	020bc063          	bltz	s7,31c <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 300:	00fc8bb3          	add	s7,s9,a5
 304:	febbf7e3          	bgeu	s7,a1,2f2 <vsnprintf+0x116>
 308:	00f70bb3          	add	s7,a4,a5
 30c:	9baa                	add	s7,s7,a0
 30e:	030aec33          	rem	s8,s5,a6
 312:	030c0c1b          	addiw	s8,s8,48
 316:	018b8023          	sb	s8,0(s7)
 31a:	bfe1                	j	2f2 <vsnprintf+0x116>
          pos += digits;
 31c:	975a                	add	a4,a4,s6
          longarg = 0;
 31e:	8b72                	mv	s6,t3
          format = 0;
 320:	8af2                	mv	s5,t3
          break;
 322:	a8bd                	j	3a0 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 324:	00868b93          	addi	s7,a3,8
 328:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
 32c:	000ac683          	lbu	a3,0(s5)
 330:	ceb9                	beqz	a3,38e <vsnprintf+0x1b2>
 332:	87ba                	mv	a5,a4
 334:	a039                	j	342 <vsnprintf+0x166>
 336:	40e786b3          	sub	a3,a5,a4
 33a:	96d6                	add	a3,a3,s5
 33c:	0006c683          	lbu	a3,0(a3)
 340:	ca89                	beqz	a3,352 <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
 342:	0785                	addi	a5,a5,1
 344:	feb7f9e3          	bgeu	a5,a1,336 <vsnprintf+0x15a>
 348:	00f50b33          	add	s6,a0,a5
 34c:	fedb0fa3          	sb	a3,-1(s6)
 350:	b7dd                	j	336 <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
 352:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 354:	873e                	mv	a4,a5
          longarg = 0;
 356:	8b72                	mv	s6,t3
          format = 0;
 358:	8af2                	mv	s5,t3
 35a:	a099                	j	3a0 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 35c:	00170793          	addi	a5,a4,1
 360:	02b7fb63          	bgeu	a5,a1,396 <vsnprintf+0x1ba>
 364:	972a                	add	a4,a4,a0
 366:	0006aa83          	lw	s5,0(a3)
 36a:	01570023          	sb	s5,0(a4)
 36e:	06a1                	addi	a3,a3,8
 370:	873e                	mv	a4,a5
          longarg = 0;
 372:	8b72                	mv	s6,t3
          format = 0;
 374:	8af2                	mv	s5,t3
 376:	a02d                	j	3a0 <vsnprintf+0x1c4>
    } else if (*s == '%')
 378:	03f78363          	beq	a5,t6,39e <vsnprintf+0x1c2>
    else if (++pos < n)
 37c:	00170b93          	addi	s7,a4,1
 380:	04bbf263          	bgeu	s7,a1,3c4 <vsnprintf+0x1e8>
      out[pos - 1] = *s;
 384:	972a                	add	a4,a4,a0
 386:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
 38a:	875e                	mv	a4,s7
 38c:	a811                	j	3a0 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 38e:	86de                	mv	a3,s7
          longarg = 0;
 390:	8b72                	mv	s6,t3
          format = 0;
 392:	8af2                	mv	s5,t3
 394:	a031                	j	3a0 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 396:	873e                	mv	a4,a5
          longarg = 0;
 398:	8b72                	mv	s6,t3
          format = 0;
 39a:	8af2                	mv	s5,t3
 39c:	a011                	j	3a0 <vsnprintf+0x1c4>
      format = 1;
 39e:	8a96                	mv	s5,t0
  for (; *s; s++) {
 3a0:	0605                	addi	a2,a2,1
 3a2:	00064783          	lbu	a5,0(a2)
 3a6:	c38d                	beqz	a5,3c8 <vsnprintf+0x1ec>
    if (format) {
 3a8:	fc0a88e3          	beqz	s5,378 <vsnprintf+0x19c>
      switch (*s) {
 3ac:	f9d7879b          	addiw	a5,a5,-99
 3b0:	0ff7fb93          	andi	s7,a5,255
 3b4:	ff7f66e3          	bltu	t5,s7,3a0 <vsnprintf+0x1c4>
 3b8:	002b9793          	slli	a5,s7,0x2
 3bc:	979a                	add	a5,a5,t1
 3be:	439c                	lw	a5,0(a5)
 3c0:	979a                	add	a5,a5,t1
 3c2:	8782                	jr	a5
    else if (++pos < n)
 3c4:	875e                	mv	a4,s7
 3c6:	bfe9                	j	3a0 <vsnprintf+0x1c4>
  }
  if (pos < n)
 3c8:	02b77363          	bgeu	a4,a1,3ee <vsnprintf+0x212>
    out[pos] = 0;
 3cc:	953a                	add	a0,a0,a4
 3ce:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 3d2:	0007051b          	sext.w	a0,a4
 3d6:	6426                	ld	s0,72(sp)
 3d8:	6486                	ld	s1,64(sp)
 3da:	7962                	ld	s2,56(sp)
 3dc:	79c2                	ld	s3,48(sp)
 3de:	7a22                	ld	s4,40(sp)
 3e0:	7a82                	ld	s5,32(sp)
 3e2:	6b62                	ld	s6,24(sp)
 3e4:	6bc2                	ld	s7,16(sp)
 3e6:	6c22                	ld	s8,8(sp)
 3e8:	6c82                	ld	s9,0(sp)
 3ea:	6161                	addi	sp,sp,80
 3ec:	8082                	ret
  else if (n)
 3ee:	d1f5                	beqz	a1,3d2 <vsnprintf+0x1f6>
    out[n - 1] = 0;
 3f0:	95aa                	add	a1,a1,a0
 3f2:	fe058fa3          	sb	zero,-1(a1)
 3f6:	bff1                	j	3d2 <vsnprintf+0x1f6>
  size_t pos = 0;
 3f8:	4701                	li	a4,0
  if (pos < n)
 3fa:	00b77863          	bgeu	a4,a1,40a <vsnprintf+0x22e>
    out[pos] = 0;
 3fe:	953a                	add	a0,a0,a4
 400:	00050023          	sb	zero,0(a0)
}
 404:	0007051b          	sext.w	a0,a4
 408:	8082                	ret
  else if (n)
 40a:	dded                	beqz	a1,404 <vsnprintf+0x228>
    out[n - 1] = 0;
 40c:	95aa                	add	a1,a1,a0
 40e:	fe058fa3          	sb	zero,-1(a1)
 412:	bfcd                	j	404 <vsnprintf+0x228>

0000000000000414 <printf>:
int printf(char*s, ...){
 414:	710d                	addi	sp,sp,-352
 416:	ee06                	sd	ra,280(sp)
 418:	ea22                	sd	s0,272(sp)
 41a:	1200                	addi	s0,sp,288
 41c:	e40c                	sd	a1,8(s0)
 41e:	e810                	sd	a2,16(s0)
 420:	ec14                	sd	a3,24(s0)
 422:	f018                	sd	a4,32(s0)
 424:	f41c                	sd	a5,40(s0)
 426:	03043823          	sd	a6,48(s0)
 42a:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 42e:	00840693          	addi	a3,s0,8
 432:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 436:	862a                	mv	a2,a0
 438:	10000593          	li	a1,256
 43c:	ee840513          	addi	a0,s0,-280
 440:	00000097          	auipc	ra,0x0
 444:	d9c080e7          	jalr	-612(ra) # 1dc <vsnprintf>
 448:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 44a:	0005071b          	sext.w	a4,a0
 44e:	0ff00793          	li	a5,255
 452:	00e7f463          	bgeu	a5,a4,45a <printf+0x46>
 456:	10000593          	li	a1,256
    return simple_write(buf, n);
 45a:	ee840513          	addi	a0,s0,-280
 45e:	00000097          	auipc	ra,0x0
 462:	d34080e7          	jalr	-716(ra) # 192 <simple_write>
}
 466:	2501                	sext.w	a0,a0
 468:	60f2                	ld	ra,280(sp)
 46a:	6452                	ld	s0,272(sp)
 46c:	6135                	addi	sp,sp,352
 46e:	8082                	ret
