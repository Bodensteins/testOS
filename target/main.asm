
target/main：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
*/

#include "stdio.h"
#include "user_syscall.h"

int main(){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16

    printf("hello world\n");    
   8:	00000517          	auipc	a0,0x0
   c:	42850513          	addi	a0,a0,1064 # 430 <printf+0x5c>
  10:	00000097          	auipc	ra,0x0
  14:	3c4080e7          	jalr	964(ra) # 3d4 <printf>
    while(1){}
  18:	a001                	j	18 <main+0x18>

000000000000001a <user_syscall>:
#include "kernel/include/syscall.h"
#include "kernel/include/printk.h"

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
  1a:	715d                	addi	sp,sp,-80
  1c:	e4a2                	sd	s0,72(sp)
  1e:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
  20:	fea43423          	sd	a0,-24(s0)
  24:	feb43023          	sd	a1,-32(s0)
  28:	fcc43c23          	sd	a2,-40(s0)
  2c:	fcd43823          	sd	a3,-48(s0)
  30:	fce43423          	sd	a4,-56(s0)
  34:	fcf43023          	sd	a5,-64(s0)
  38:	fb043c23          	sd	a6,-72(s0)
  3c:	fb143823          	sd	a7,-80(s0)
        asm volatile(
  40:	fe843503          	ld	a0,-24(s0)
  44:	fe043583          	ld	a1,-32(s0)
  48:	fd843603          	ld	a2,-40(s0)
  4c:	fd043683          	ld	a3,-48(s0)
  50:	fc843703          	ld	a4,-56(s0)
  54:	fc043783          	ld	a5,-64(s0)
  58:	fb843803          	ld	a6,-72(s0)
  5c:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(
  60:	00000073          	ecall
  64:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
  68:	fe843503          	ld	a0,-24(s0)
  6c:	6426                	ld	s0,72(sp)
  6e:	6161                	addi	sp,sp,80
  70:	8082                	ret

0000000000000072 <fork>:

uint64 fork(){
  72:	1141                	addi	sp,sp,-16
  74:	e406                	sd	ra,8(sp)
  76:	e022                	sd	s0,0(sp)
  78:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
  7a:	4885                	li	a7,1
  7c:	4801                	li	a6,0
  7e:	4781                	li	a5,0
  80:	4701                	li	a4,0
  82:	4681                	li	a3,0
  84:	4601                	li	a2,0
  86:	4581                	li	a1,0
  88:	4501                	li	a0,0
  8a:	00000097          	auipc	ra,0x0
  8e:	f90080e7          	jalr	-112(ra) # 1a <user_syscall>
}
  92:	60a2                	ld	ra,8(sp)
  94:	6402                	ld	s0,0(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret

000000000000009a <exit>:

uint64 exit(int code){
  9a:	1141                	addi	sp,sp,-16
  9c:	e406                	sd	ra,8(sp)
  9e:	e022                	sd	s0,0(sp)
  a0:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
  a2:	4889                	li	a7,2
  a4:	4801                	li	a6,0
  a6:	4781                	li	a5,0
  a8:	4701                	li	a4,0
  aa:	4681                	li	a3,0
  ac:	4601                	li	a2,0
  ae:	4581                	li	a1,0
  b0:	00000097          	auipc	ra,0x0
  b4:	f6a080e7          	jalr	-150(ra) # 1a <user_syscall>
}
  b8:	60a2                	ld	ra,8(sp)
  ba:	6402                	ld	s0,0(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <open>:

uint64 open(char *file_name, int mode){
  c0:	1141                	addi	sp,sp,-16
  c2:	e406                	sd	ra,8(sp)
  c4:	e022                	sd	s0,0(sp)
  c6:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
  c8:	48bd                	li	a7,15
  ca:	4801                	li	a6,0
  cc:	4781                	li	a5,0
  ce:	4701                	li	a4,0
  d0:	4681                	li	a3,0
  d2:	4601                	li	a2,0
  d4:	00000097          	auipc	ra,0x0
  d8:	f46080e7          	jalr	-186(ra) # 1a <user_syscall>
}
  dc:	60a2                	ld	ra,8(sp)
  de:	6402                	ld	s0,0(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret

00000000000000e4 <read>:

uint64 read(int fd, void* buf, size_t rsize){
  e4:	1141                	addi	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
  ec:	4895                	li	a7,5
  ee:	4801                	li	a6,0
  f0:	4781                	li	a5,0
  f2:	4701                	li	a4,0
  f4:	4681                	li	a3,0
  f6:	00000097          	auipc	ra,0x0
  fa:	f24080e7          	jalr	-220(ra) # 1a <user_syscall>
}
  fe:	60a2                	ld	ra,8(sp)
 100:	6402                	ld	s0,0(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <kill>:

uint64 kill(uint64 pid){
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
 10e:	4899                	li	a7,6
 110:	4801                	li	a6,0
 112:	4781                	li	a5,0
 114:	4701                	li	a4,0
 116:	4681                	li	a3,0
 118:	4601                	li	a2,0
 11a:	4581                	li	a1,0
 11c:	00000097          	auipc	ra,0x0
 120:	efe080e7          	jalr	-258(ra) # 1a <user_syscall>
}
 124:	60a2                	ld	ra,8(sp)
 126:	6402                	ld	s0,0(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <exec>:

uint64 exec(char *file_name){
 12c:	1141                	addi	sp,sp,-16
 12e:	e406                	sd	ra,8(sp)
 130:	e022                	sd	s0,0(sp)
 132:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,0,0,0,0,0,0,SYS_exec);
 134:	489d                	li	a7,7
 136:	4801                	li	a6,0
 138:	4781                	li	a5,0
 13a:	4701                	li	a4,0
 13c:	4681                	li	a3,0
 13e:	4601                	li	a2,0
 140:	4581                	li	a1,0
 142:	00000097          	auipc	ra,0x0
 146:	ed8080e7          	jalr	-296(ra) # 1a <user_syscall>
}
 14a:	60a2                	ld	ra,8(sp)
 14c:	6402                	ld	s0,0(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret

0000000000000152 <simple_write>:

uint64 simple_write(char *s, size_t n){
 152:	1141                	addi	sp,sp,-16
 154:	e406                	sd	ra,8(sp)
 156:	e022                	sd	s0,0(sp)
 158:	0800                	addi	s0,sp,16
    return user_syscall((uint64)s,n,0,0,0,0,0,SYS_write);
 15a:	48c1                	li	a7,16
 15c:	4801                	li	a6,0
 15e:	4781                	li	a5,0
 160:	4701                	li	a4,0
 162:	4681                	li	a3,0
 164:	4601                	li	a2,0
 166:	00000097          	auipc	ra,0x0
 16a:	eb4080e7          	jalr	-332(ra) # 1a <user_syscall>
}
 16e:	60a2                	ld	ra,8(sp)
 170:	6402                	ld	s0,0(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret

0000000000000176 <close>:

uint64 close(int fd){
 176:	1141                	addi	sp,sp,-16
 178:	e406                	sd	ra,8(sp)
 17a:	e022                	sd	s0,0(sp)
 17c:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
 17e:	48d5                	li	a7,21
 180:	4801                	li	a6,0
 182:	4781                	li	a5,0
 184:	4701                	li	a4,0
 186:	4681                	li	a3,0
 188:	4601                	li	a2,0
 18a:	4581                	li	a1,0
 18c:	00000097          	auipc	ra,0x0
 190:	e8e080e7          	jalr	-370(ra) # 1a <user_syscall>
}
 194:	60a2                	ld	ra,8(sp)
 196:	6402                	ld	s0,0(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
 19c:	00064783          	lbu	a5,0(a2)
 1a0:	20078c63          	beqz	a5,3b8 <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
 1a4:	715d                	addi	sp,sp,-80
 1a6:	e4a2                	sd	s0,72(sp)
 1a8:	e0a6                	sd	s1,64(sp)
 1aa:	fc4a                	sd	s2,56(sp)
 1ac:	f84e                	sd	s3,48(sp)
 1ae:	f452                	sd	s4,40(sp)
 1b0:	f056                	sd	s5,32(sp)
 1b2:	ec5a                	sd	s6,24(sp)
 1b4:	e85e                	sd	s7,16(sp)
 1b6:	e462                	sd	s8,8(sp)
 1b8:	e066                	sd	s9,0(sp)
 1ba:	0880                	addi	s0,sp,80
  size_t pos = 0;
 1bc:	4701                	li	a4,0
  int longarg = 0;
 1be:	4b01                	li	s6,0
  int format = 0;
 1c0:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 1c2:	02500f93          	li	t6,37
      format = 1;
 1c6:	4285                	li	t0,1
      switch (*s) {
 1c8:	4f55                	li	t5,21
 1ca:	00000317          	auipc	t1,0x0
 1ce:	27630313          	addi	t1,t1,630 # 440 <printf+0x6c>
          longarg = 0;
 1d2:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 1d4:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
 1d6:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 1da:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 1dc:	58fd                	li	a7,-1
 1de:	43bd                	li	t2,15
 1e0:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
 1e2:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
 1e6:	03000493          	li	s1,48
 1ea:	aabd                	j	368 <vsnprintf+0x1cc>
          longarg = 1;
 1ec:	8b56                	mv	s6,s5
 1ee:	aa8d                	j	360 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
 1f0:	00170793          	addi	a5,a4,1
 1f4:	00b7f663          	bgeu	a5,a1,200 <vsnprintf+0x64>
 1f8:	00e50ab3          	add	s5,a0,a4
 1fc:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
 200:	0709                	addi	a4,a4,2
 202:	00b77563          	bgeu	a4,a1,20c <vsnprintf+0x70>
 206:	97aa                	add	a5,a5,a0
 208:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 20c:	0006bc03          	ld	s8,0(a3)
 210:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 212:	8c9e                	mv	s9,t2
 214:	8b66                	mv	s6,s9
 216:	8aba                	mv	s5,a4
 218:	a839                	j	236 <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 21a:	fe0b19e3          	bnez	s6,20c <vsnprintf+0x70>
 21e:	0006ac03          	lw	s8,0(a3)
 222:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 224:	8cce                	mv	s9,s3
 226:	b7fd                	j	214 <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 228:	015507b3          	add	a5,a0,s5
 22c:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 230:	3b7d                	addiw	s6,s6,-1
 232:	031b0163          	beq	s6,a7,254 <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 236:	0a85                	addi	s5,s5,1
 238:	febafce3          	bgeu	s5,a1,230 <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
 23c:	002b179b          	slliw	a5,s6,0x2
 240:	40fc57b3          	sra	a5,s8,a5
 244:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 246:	05778b93          	addi	s7,a5,87
 24a:	fcfecfe3          	blt	t4,a5,228 <vsnprintf+0x8c>
 24e:	03078b93          	addi	s7,a5,48
 252:	bfd9                	j	228 <vsnprintf+0x8c>
 254:	0705                	addi	a4,a4,1
 256:	9766                	add	a4,a4,s9
          longarg = 0;
 258:	8b72                	mv	s6,t3
          format = 0;
 25a:	8af2                	mv	s5,t3
 25c:	a211                	j	360 <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 25e:	020b0663          	beqz	s6,28a <vsnprintf+0xee>
 262:	0006ba83          	ld	s5,0(a3)
 266:	06a1                	addi	a3,a3,8
          if (num < 0) {
 268:	020ac563          	bltz	s5,292 <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
 26c:	030ac7b3          	div	a5,s5,a6
 270:	cf95                	beqz	a5,2ac <vsnprintf+0x110>
          long digits = 1;
 272:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 274:	0b05                	addi	s6,s6,1
 276:	0307c7b3          	div	a5,a5,a6
 27a:	ffed                	bnez	a5,274 <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 27c:	fffb079b          	addiw	a5,s6,-1
 280:	0407ce63          	bltz	a5,2dc <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 284:	00170c93          	addi	s9,a4,1
 288:	a825                	j	2c0 <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 28a:	0006aa83          	lw	s5,0(a3)
 28e:	06a1                	addi	a3,a3,8
 290:	bfe1                	j	268 <vsnprintf+0xcc>
            num = -num;
 292:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
 296:	00170793          	addi	a5,a4,1
 29a:	00b7f763          	bgeu	a5,a1,2a8 <vsnprintf+0x10c>
 29e:	972a                	add	a4,a4,a0
 2a0:	01470023          	sb	s4,0(a4)
 2a4:	873e                	mv	a4,a5
 2a6:	b7d9                	j	26c <vsnprintf+0xd0>
 2a8:	873e                	mv	a4,a5
 2aa:	b7c9                	j	26c <vsnprintf+0xd0>
          long digits = 1;
 2ac:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 2ae:	87f2                	mv	a5,t3
 2b0:	bfd1                	j	284 <vsnprintf+0xe8>
            num /= 10;
 2b2:	030acab3          	div	s5,s5,a6
 2b6:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
 2b8:	02079b93          	slli	s7,a5,0x20
 2bc:	020bc063          	bltz	s7,2dc <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 2c0:	00fc8bb3          	add	s7,s9,a5
 2c4:	febbf7e3          	bgeu	s7,a1,2b2 <vsnprintf+0x116>
 2c8:	00f70bb3          	add	s7,a4,a5
 2cc:	9baa                	add	s7,s7,a0
 2ce:	030aec33          	rem	s8,s5,a6
 2d2:	030c0c1b          	addiw	s8,s8,48
 2d6:	018b8023          	sb	s8,0(s7)
 2da:	bfe1                	j	2b2 <vsnprintf+0x116>
          pos += digits;
 2dc:	975a                	add	a4,a4,s6
          longarg = 0;
 2de:	8b72                	mv	s6,t3
          format = 0;
 2e0:	8af2                	mv	s5,t3
          break;
 2e2:	a8bd                	j	360 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 2e4:	00868b93          	addi	s7,a3,8
 2e8:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
 2ec:	000ac683          	lbu	a3,0(s5)
 2f0:	ceb9                	beqz	a3,34e <vsnprintf+0x1b2>
 2f2:	87ba                	mv	a5,a4
 2f4:	a039                	j	302 <vsnprintf+0x166>
 2f6:	40e786b3          	sub	a3,a5,a4
 2fa:	96d6                	add	a3,a3,s5
 2fc:	0006c683          	lbu	a3,0(a3)
 300:	ca89                	beqz	a3,312 <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
 302:	0785                	addi	a5,a5,1
 304:	feb7f9e3          	bgeu	a5,a1,2f6 <vsnprintf+0x15a>
 308:	00f50b33          	add	s6,a0,a5
 30c:	fedb0fa3          	sb	a3,-1(s6)
 310:	b7dd                	j	2f6 <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
 312:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 314:	873e                	mv	a4,a5
          longarg = 0;
 316:	8b72                	mv	s6,t3
          format = 0;
 318:	8af2                	mv	s5,t3
 31a:	a099                	j	360 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 31c:	00170793          	addi	a5,a4,1
 320:	02b7fb63          	bgeu	a5,a1,356 <vsnprintf+0x1ba>
 324:	972a                	add	a4,a4,a0
 326:	0006aa83          	lw	s5,0(a3)
 32a:	01570023          	sb	s5,0(a4)
 32e:	06a1                	addi	a3,a3,8
 330:	873e                	mv	a4,a5
          longarg = 0;
 332:	8b72                	mv	s6,t3
          format = 0;
 334:	8af2                	mv	s5,t3
 336:	a02d                	j	360 <vsnprintf+0x1c4>
    } else if (*s == '%')
 338:	03f78363          	beq	a5,t6,35e <vsnprintf+0x1c2>
    else if (++pos < n)
 33c:	00170b93          	addi	s7,a4,1
 340:	04bbf263          	bgeu	s7,a1,384 <vsnprintf+0x1e8>
      out[pos - 1] = *s;
 344:	972a                	add	a4,a4,a0
 346:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
 34a:	875e                	mv	a4,s7
 34c:	a811                	j	360 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 34e:	86de                	mv	a3,s7
          longarg = 0;
 350:	8b72                	mv	s6,t3
          format = 0;
 352:	8af2                	mv	s5,t3
 354:	a031                	j	360 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 356:	873e                	mv	a4,a5
          longarg = 0;
 358:	8b72                	mv	s6,t3
          format = 0;
 35a:	8af2                	mv	s5,t3
 35c:	a011                	j	360 <vsnprintf+0x1c4>
      format = 1;
 35e:	8a96                	mv	s5,t0
  for (; *s; s++) {
 360:	0605                	addi	a2,a2,1
 362:	00064783          	lbu	a5,0(a2)
 366:	c38d                	beqz	a5,388 <vsnprintf+0x1ec>
    if (format) {
 368:	fc0a88e3          	beqz	s5,338 <vsnprintf+0x19c>
      switch (*s) {
 36c:	f9d7879b          	addiw	a5,a5,-99
 370:	0ff7fb93          	andi	s7,a5,255
 374:	ff7f66e3          	bltu	t5,s7,360 <vsnprintf+0x1c4>
 378:	002b9793          	slli	a5,s7,0x2
 37c:	979a                	add	a5,a5,t1
 37e:	439c                	lw	a5,0(a5)
 380:	979a                	add	a5,a5,t1
 382:	8782                	jr	a5
    else if (++pos < n)
 384:	875e                	mv	a4,s7
 386:	bfe9                	j	360 <vsnprintf+0x1c4>
  }
  if (pos < n)
 388:	02b77363          	bgeu	a4,a1,3ae <vsnprintf+0x212>
    out[pos] = 0;
 38c:	953a                	add	a0,a0,a4
 38e:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 392:	0007051b          	sext.w	a0,a4
 396:	6426                	ld	s0,72(sp)
 398:	6486                	ld	s1,64(sp)
 39a:	7962                	ld	s2,56(sp)
 39c:	79c2                	ld	s3,48(sp)
 39e:	7a22                	ld	s4,40(sp)
 3a0:	7a82                	ld	s5,32(sp)
 3a2:	6b62                	ld	s6,24(sp)
 3a4:	6bc2                	ld	s7,16(sp)
 3a6:	6c22                	ld	s8,8(sp)
 3a8:	6c82                	ld	s9,0(sp)
 3aa:	6161                	addi	sp,sp,80
 3ac:	8082                	ret
  else if (n)
 3ae:	d1f5                	beqz	a1,392 <vsnprintf+0x1f6>
    out[n - 1] = 0;
 3b0:	95aa                	add	a1,a1,a0
 3b2:	fe058fa3          	sb	zero,-1(a1)
 3b6:	bff1                	j	392 <vsnprintf+0x1f6>
  size_t pos = 0;
 3b8:	4701                	li	a4,0
  if (pos < n)
 3ba:	00b77863          	bgeu	a4,a1,3ca <vsnprintf+0x22e>
    out[pos] = 0;
 3be:	953a                	add	a0,a0,a4
 3c0:	00050023          	sb	zero,0(a0)
}
 3c4:	0007051b          	sext.w	a0,a4
 3c8:	8082                	ret
  else if (n)
 3ca:	dded                	beqz	a1,3c4 <vsnprintf+0x228>
    out[n - 1] = 0;
 3cc:	95aa                	add	a1,a1,a0
 3ce:	fe058fa3          	sb	zero,-1(a1)
 3d2:	bfcd                	j	3c4 <vsnprintf+0x228>

00000000000003d4 <printf>:
int printf(char*s, ...){
 3d4:	710d                	addi	sp,sp,-352
 3d6:	ee06                	sd	ra,280(sp)
 3d8:	ea22                	sd	s0,272(sp)
 3da:	1200                	addi	s0,sp,288
 3dc:	e40c                	sd	a1,8(s0)
 3de:	e810                	sd	a2,16(s0)
 3e0:	ec14                	sd	a3,24(s0)
 3e2:	f018                	sd	a4,32(s0)
 3e4:	f41c                	sd	a5,40(s0)
 3e6:	03043823          	sd	a6,48(s0)
 3ea:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 3ee:	00840693          	addi	a3,s0,8
 3f2:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 3f6:	862a                	mv	a2,a0
 3f8:	10000593          	li	a1,256
 3fc:	ee840513          	addi	a0,s0,-280
 400:	00000097          	auipc	ra,0x0
 404:	d9c080e7          	jalr	-612(ra) # 19c <vsnprintf>
 408:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 40a:	0005071b          	sext.w	a4,a0
 40e:	0ff00793          	li	a5,255
 412:	00e7f463          	bgeu	a5,a4,41a <printf+0x46>
 416:	10000593          	li	a1,256
    return simple_write(buf, n);
 41a:	ee840513          	addi	a0,s0,-280
 41e:	00000097          	auipc	ra,0x0
 422:	d34080e7          	jalr	-716(ra) # 152 <simple_write>
}
 426:	2501                	sext.w	a0,a0
 428:	60f2                	ld	ra,280(sp)
 42a:	6452                	ld	s0,272(sp)
 42c:	6135                	addi	sp,sp,352
 42e:	8082                	ret
