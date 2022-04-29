
target/test：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user_syscall.h"
#include "stdio.h"

int main(){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16

    printf("test\n");
   8:	00000517          	auipc	a0,0x0
   c:	43850513          	addi	a0,a0,1080 # 440 <printf+0x5c>
  10:	00000097          	auipc	ra,0x0
  14:	3d4080e7          	jalr	980(ra) # 3e4 <printf>
    exec("/main");
  18:	00000517          	auipc	a0,0x0
  1c:	43050513          	addi	a0,a0,1072 # 448 <printf+0x64>
  20:	00000097          	auipc	ra,0x0
  24:	11c080e7          	jalr	284(ra) # 13c <exec>

    while(1){
    }
  28:	a001                	j	28 <main+0x28>

000000000000002a <user_syscall>:
#include "kernel/include/syscall.h"
#include "kernel/include/printk.h"

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
  2a:	715d                	addi	sp,sp,-80
  2c:	e4a2                	sd	s0,72(sp)
  2e:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
  30:	fea43423          	sd	a0,-24(s0)
  34:	feb43023          	sd	a1,-32(s0)
  38:	fcc43c23          	sd	a2,-40(s0)
  3c:	fcd43823          	sd	a3,-48(s0)
  40:	fce43423          	sd	a4,-56(s0)
  44:	fcf43023          	sd	a5,-64(s0)
  48:	fb043c23          	sd	a6,-72(s0)
  4c:	fb143823          	sd	a7,-80(s0)
        asm volatile(
  50:	fe843503          	ld	a0,-24(s0)
  54:	fe043583          	ld	a1,-32(s0)
  58:	fd843603          	ld	a2,-40(s0)
  5c:	fd043683          	ld	a3,-48(s0)
  60:	fc843703          	ld	a4,-56(s0)
  64:	fc043783          	ld	a5,-64(s0)
  68:	fb843803          	ld	a6,-72(s0)
  6c:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(
  70:	00000073          	ecall
  74:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
  78:	fe843503          	ld	a0,-24(s0)
  7c:	6426                	ld	s0,72(sp)
  7e:	6161                	addi	sp,sp,80
  80:	8082                	ret

0000000000000082 <fork>:

uint64 fork(){
  82:	1141                	addi	sp,sp,-16
  84:	e406                	sd	ra,8(sp)
  86:	e022                	sd	s0,0(sp)
  88:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
  8a:	4885                	li	a7,1
  8c:	4801                	li	a6,0
  8e:	4781                	li	a5,0
  90:	4701                	li	a4,0
  92:	4681                	li	a3,0
  94:	4601                	li	a2,0
  96:	4581                	li	a1,0
  98:	4501                	li	a0,0
  9a:	00000097          	auipc	ra,0x0
  9e:	f90080e7          	jalr	-112(ra) # 2a <user_syscall>
}
  a2:	60a2                	ld	ra,8(sp)
  a4:	6402                	ld	s0,0(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret

00000000000000aa <exit>:

uint64 exit(int code){
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
  b2:	4889                	li	a7,2
  b4:	4801                	li	a6,0
  b6:	4781                	li	a5,0
  b8:	4701                	li	a4,0
  ba:	4681                	li	a3,0
  bc:	4601                	li	a2,0
  be:	4581                	li	a1,0
  c0:	00000097          	auipc	ra,0x0
  c4:	f6a080e7          	jalr	-150(ra) # 2a <user_syscall>
}
  c8:	60a2                	ld	ra,8(sp)
  ca:	6402                	ld	s0,0(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret

00000000000000d0 <open>:

uint64 open(char *file_name, int mode){
  d0:	1141                	addi	sp,sp,-16
  d2:	e406                	sd	ra,8(sp)
  d4:	e022                	sd	s0,0(sp)
  d6:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
  d8:	48bd                	li	a7,15
  da:	4801                	li	a6,0
  dc:	4781                	li	a5,0
  de:	4701                	li	a4,0
  e0:	4681                	li	a3,0
  e2:	4601                	li	a2,0
  e4:	00000097          	auipc	ra,0x0
  e8:	f46080e7          	jalr	-186(ra) # 2a <user_syscall>
}
  ec:	60a2                	ld	ra,8(sp)
  ee:	6402                	ld	s0,0(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret

00000000000000f4 <read>:

uint64 read(int fd, void* buf, size_t rsize){
  f4:	1141                	addi	sp,sp,-16
  f6:	e406                	sd	ra,8(sp)
  f8:	e022                	sd	s0,0(sp)
  fa:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
  fc:	4895                	li	a7,5
  fe:	4801                	li	a6,0
 100:	4781                	li	a5,0
 102:	4701                	li	a4,0
 104:	4681                	li	a3,0
 106:	00000097          	auipc	ra,0x0
 10a:	f24080e7          	jalr	-220(ra) # 2a <user_syscall>
}
 10e:	60a2                	ld	ra,8(sp)
 110:	6402                	ld	s0,0(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <kill>:

uint64 kill(uint64 pid){
 116:	1141                	addi	sp,sp,-16
 118:	e406                	sd	ra,8(sp)
 11a:	e022                	sd	s0,0(sp)
 11c:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
 11e:	4899                	li	a7,6
 120:	4801                	li	a6,0
 122:	4781                	li	a5,0
 124:	4701                	li	a4,0
 126:	4681                	li	a3,0
 128:	4601                	li	a2,0
 12a:	4581                	li	a1,0
 12c:	00000097          	auipc	ra,0x0
 130:	efe080e7          	jalr	-258(ra) # 2a <user_syscall>
}
 134:	60a2                	ld	ra,8(sp)
 136:	6402                	ld	s0,0(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret

000000000000013c <exec>:

uint64 exec(char *file_name){
 13c:	1141                	addi	sp,sp,-16
 13e:	e406                	sd	ra,8(sp)
 140:	e022                	sd	s0,0(sp)
 142:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,0,0,0,0,0,0,SYS_exec);
 144:	489d                	li	a7,7
 146:	4801                	li	a6,0
 148:	4781                	li	a5,0
 14a:	4701                	li	a4,0
 14c:	4681                	li	a3,0
 14e:	4601                	li	a2,0
 150:	4581                	li	a1,0
 152:	00000097          	auipc	ra,0x0
 156:	ed8080e7          	jalr	-296(ra) # 2a <user_syscall>
}
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <simple_write>:

uint64 simple_write(char *s, size_t n){
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
    return user_syscall((uint64)s,n,0,0,0,0,0,SYS_write);
 16a:	48c1                	li	a7,16
 16c:	4801                	li	a6,0
 16e:	4781                	li	a5,0
 170:	4701                	li	a4,0
 172:	4681                	li	a3,0
 174:	4601                	li	a2,0
 176:	00000097          	auipc	ra,0x0
 17a:	eb4080e7          	jalr	-332(ra) # 2a <user_syscall>
}
 17e:	60a2                	ld	ra,8(sp)
 180:	6402                	ld	s0,0(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret

0000000000000186 <close>:

uint64 close(int fd){
 186:	1141                	addi	sp,sp,-16
 188:	e406                	sd	ra,8(sp)
 18a:	e022                	sd	s0,0(sp)
 18c:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
 18e:	48d5                	li	a7,21
 190:	4801                	li	a6,0
 192:	4781                	li	a5,0
 194:	4701                	li	a4,0
 196:	4681                	li	a3,0
 198:	4601                	li	a2,0
 19a:	4581                	li	a1,0
 19c:	00000097          	auipc	ra,0x0
 1a0:	e8e080e7          	jalr	-370(ra) # 2a <user_syscall>
}
 1a4:	60a2                	ld	ra,8(sp)
 1a6:	6402                	ld	s0,0(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret

00000000000001ac <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
 1ac:	00064783          	lbu	a5,0(a2)
 1b0:	20078c63          	beqz	a5,3c8 <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
 1b4:	715d                	addi	sp,sp,-80
 1b6:	e4a2                	sd	s0,72(sp)
 1b8:	e0a6                	sd	s1,64(sp)
 1ba:	fc4a                	sd	s2,56(sp)
 1bc:	f84e                	sd	s3,48(sp)
 1be:	f452                	sd	s4,40(sp)
 1c0:	f056                	sd	s5,32(sp)
 1c2:	ec5a                	sd	s6,24(sp)
 1c4:	e85e                	sd	s7,16(sp)
 1c6:	e462                	sd	s8,8(sp)
 1c8:	e066                	sd	s9,0(sp)
 1ca:	0880                	addi	s0,sp,80
  size_t pos = 0;
 1cc:	4701                	li	a4,0
  int longarg = 0;
 1ce:	4b01                	li	s6,0
  int format = 0;
 1d0:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 1d2:	02500f93          	li	t6,37
      format = 1;
 1d6:	4285                	li	t0,1
      switch (*s) {
 1d8:	4f55                	li	t5,21
 1da:	00000317          	auipc	t1,0x0
 1de:	27630313          	addi	t1,t1,630 # 450 <printf+0x6c>
          longarg = 0;
 1e2:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 1e4:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
 1e6:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 1ea:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 1ec:	58fd                	li	a7,-1
 1ee:	43bd                	li	t2,15
 1f0:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
 1f2:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
 1f6:	03000493          	li	s1,48
 1fa:	aabd                	j	378 <vsnprintf+0x1cc>
          longarg = 1;
 1fc:	8b56                	mv	s6,s5
 1fe:	aa8d                	j	370 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
 200:	00170793          	addi	a5,a4,1
 204:	00b7f663          	bgeu	a5,a1,210 <vsnprintf+0x64>
 208:	00e50ab3          	add	s5,a0,a4
 20c:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
 210:	0709                	addi	a4,a4,2
 212:	00b77563          	bgeu	a4,a1,21c <vsnprintf+0x70>
 216:	97aa                	add	a5,a5,a0
 218:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 21c:	0006bc03          	ld	s8,0(a3)
 220:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 222:	8c9e                	mv	s9,t2
 224:	8b66                	mv	s6,s9
 226:	8aba                	mv	s5,a4
 228:	a839                	j	246 <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 22a:	fe0b19e3          	bnez	s6,21c <vsnprintf+0x70>
 22e:	0006ac03          	lw	s8,0(a3)
 232:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 234:	8cce                	mv	s9,s3
 236:	b7fd                	j	224 <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 238:	015507b3          	add	a5,a0,s5
 23c:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 240:	3b7d                	addiw	s6,s6,-1
 242:	031b0163          	beq	s6,a7,264 <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 246:	0a85                	addi	s5,s5,1
 248:	febafce3          	bgeu	s5,a1,240 <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
 24c:	002b179b          	slliw	a5,s6,0x2
 250:	40fc57b3          	sra	a5,s8,a5
 254:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 256:	05778b93          	addi	s7,a5,87
 25a:	fcfecfe3          	blt	t4,a5,238 <vsnprintf+0x8c>
 25e:	03078b93          	addi	s7,a5,48
 262:	bfd9                	j	238 <vsnprintf+0x8c>
 264:	0705                	addi	a4,a4,1
 266:	9766                	add	a4,a4,s9
          longarg = 0;
 268:	8b72                	mv	s6,t3
          format = 0;
 26a:	8af2                	mv	s5,t3
 26c:	a211                	j	370 <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 26e:	020b0663          	beqz	s6,29a <vsnprintf+0xee>
 272:	0006ba83          	ld	s5,0(a3)
 276:	06a1                	addi	a3,a3,8
          if (num < 0) {
 278:	020ac563          	bltz	s5,2a2 <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
 27c:	030ac7b3          	div	a5,s5,a6
 280:	cf95                	beqz	a5,2bc <vsnprintf+0x110>
          long digits = 1;
 282:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 284:	0b05                	addi	s6,s6,1
 286:	0307c7b3          	div	a5,a5,a6
 28a:	ffed                	bnez	a5,284 <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 28c:	fffb079b          	addiw	a5,s6,-1
 290:	0407ce63          	bltz	a5,2ec <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 294:	00170c93          	addi	s9,a4,1
 298:	a825                	j	2d0 <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 29a:	0006aa83          	lw	s5,0(a3)
 29e:	06a1                	addi	a3,a3,8
 2a0:	bfe1                	j	278 <vsnprintf+0xcc>
            num = -num;
 2a2:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
 2a6:	00170793          	addi	a5,a4,1
 2aa:	00b7f763          	bgeu	a5,a1,2b8 <vsnprintf+0x10c>
 2ae:	972a                	add	a4,a4,a0
 2b0:	01470023          	sb	s4,0(a4)
 2b4:	873e                	mv	a4,a5
 2b6:	b7d9                	j	27c <vsnprintf+0xd0>
 2b8:	873e                	mv	a4,a5
 2ba:	b7c9                	j	27c <vsnprintf+0xd0>
          long digits = 1;
 2bc:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 2be:	87f2                	mv	a5,t3
 2c0:	bfd1                	j	294 <vsnprintf+0xe8>
            num /= 10;
 2c2:	030acab3          	div	s5,s5,a6
 2c6:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
 2c8:	02079b93          	slli	s7,a5,0x20
 2cc:	020bc063          	bltz	s7,2ec <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 2d0:	00fc8bb3          	add	s7,s9,a5
 2d4:	febbf7e3          	bgeu	s7,a1,2c2 <vsnprintf+0x116>
 2d8:	00f70bb3          	add	s7,a4,a5
 2dc:	9baa                	add	s7,s7,a0
 2de:	030aec33          	rem	s8,s5,a6
 2e2:	030c0c1b          	addiw	s8,s8,48
 2e6:	018b8023          	sb	s8,0(s7)
 2ea:	bfe1                	j	2c2 <vsnprintf+0x116>
          pos += digits;
 2ec:	975a                	add	a4,a4,s6
          longarg = 0;
 2ee:	8b72                	mv	s6,t3
          format = 0;
 2f0:	8af2                	mv	s5,t3
          break;
 2f2:	a8bd                	j	370 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 2f4:	00868b93          	addi	s7,a3,8
 2f8:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
 2fc:	000ac683          	lbu	a3,0(s5)
 300:	ceb9                	beqz	a3,35e <vsnprintf+0x1b2>
 302:	87ba                	mv	a5,a4
 304:	a039                	j	312 <vsnprintf+0x166>
 306:	40e786b3          	sub	a3,a5,a4
 30a:	96d6                	add	a3,a3,s5
 30c:	0006c683          	lbu	a3,0(a3)
 310:	ca89                	beqz	a3,322 <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
 312:	0785                	addi	a5,a5,1
 314:	feb7f9e3          	bgeu	a5,a1,306 <vsnprintf+0x15a>
 318:	00f50b33          	add	s6,a0,a5
 31c:	fedb0fa3          	sb	a3,-1(s6)
 320:	b7dd                	j	306 <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
 322:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 324:	873e                	mv	a4,a5
          longarg = 0;
 326:	8b72                	mv	s6,t3
          format = 0;
 328:	8af2                	mv	s5,t3
 32a:	a099                	j	370 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 32c:	00170793          	addi	a5,a4,1
 330:	02b7fb63          	bgeu	a5,a1,366 <vsnprintf+0x1ba>
 334:	972a                	add	a4,a4,a0
 336:	0006aa83          	lw	s5,0(a3)
 33a:	01570023          	sb	s5,0(a4)
 33e:	06a1                	addi	a3,a3,8
 340:	873e                	mv	a4,a5
          longarg = 0;
 342:	8b72                	mv	s6,t3
          format = 0;
 344:	8af2                	mv	s5,t3
 346:	a02d                	j	370 <vsnprintf+0x1c4>
    } else if (*s == '%')
 348:	03f78363          	beq	a5,t6,36e <vsnprintf+0x1c2>
    else if (++pos < n)
 34c:	00170b93          	addi	s7,a4,1
 350:	04bbf263          	bgeu	s7,a1,394 <vsnprintf+0x1e8>
      out[pos - 1] = *s;
 354:	972a                	add	a4,a4,a0
 356:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
 35a:	875e                	mv	a4,s7
 35c:	a811                	j	370 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 35e:	86de                	mv	a3,s7
          longarg = 0;
 360:	8b72                	mv	s6,t3
          format = 0;
 362:	8af2                	mv	s5,t3
 364:	a031                	j	370 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 366:	873e                	mv	a4,a5
          longarg = 0;
 368:	8b72                	mv	s6,t3
          format = 0;
 36a:	8af2                	mv	s5,t3
 36c:	a011                	j	370 <vsnprintf+0x1c4>
      format = 1;
 36e:	8a96                	mv	s5,t0
  for (; *s; s++) {
 370:	0605                	addi	a2,a2,1
 372:	00064783          	lbu	a5,0(a2)
 376:	c38d                	beqz	a5,398 <vsnprintf+0x1ec>
    if (format) {
 378:	fc0a88e3          	beqz	s5,348 <vsnprintf+0x19c>
      switch (*s) {
 37c:	f9d7879b          	addiw	a5,a5,-99
 380:	0ff7fb93          	andi	s7,a5,255
 384:	ff7f66e3          	bltu	t5,s7,370 <vsnprintf+0x1c4>
 388:	002b9793          	slli	a5,s7,0x2
 38c:	979a                	add	a5,a5,t1
 38e:	439c                	lw	a5,0(a5)
 390:	979a                	add	a5,a5,t1
 392:	8782                	jr	a5
    else if (++pos < n)
 394:	875e                	mv	a4,s7
 396:	bfe9                	j	370 <vsnprintf+0x1c4>
  }
  if (pos < n)
 398:	02b77363          	bgeu	a4,a1,3be <vsnprintf+0x212>
    out[pos] = 0;
 39c:	953a                	add	a0,a0,a4
 39e:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 3a2:	0007051b          	sext.w	a0,a4
 3a6:	6426                	ld	s0,72(sp)
 3a8:	6486                	ld	s1,64(sp)
 3aa:	7962                	ld	s2,56(sp)
 3ac:	79c2                	ld	s3,48(sp)
 3ae:	7a22                	ld	s4,40(sp)
 3b0:	7a82                	ld	s5,32(sp)
 3b2:	6b62                	ld	s6,24(sp)
 3b4:	6bc2                	ld	s7,16(sp)
 3b6:	6c22                	ld	s8,8(sp)
 3b8:	6c82                	ld	s9,0(sp)
 3ba:	6161                	addi	sp,sp,80
 3bc:	8082                	ret
  else if (n)
 3be:	d1f5                	beqz	a1,3a2 <vsnprintf+0x1f6>
    out[n - 1] = 0;
 3c0:	95aa                	add	a1,a1,a0
 3c2:	fe058fa3          	sb	zero,-1(a1)
 3c6:	bff1                	j	3a2 <vsnprintf+0x1f6>
  size_t pos = 0;
 3c8:	4701                	li	a4,0
  if (pos < n)
 3ca:	00b77863          	bgeu	a4,a1,3da <vsnprintf+0x22e>
    out[pos] = 0;
 3ce:	953a                	add	a0,a0,a4
 3d0:	00050023          	sb	zero,0(a0)
}
 3d4:	0007051b          	sext.w	a0,a4
 3d8:	8082                	ret
  else if (n)
 3da:	dded                	beqz	a1,3d4 <vsnprintf+0x228>
    out[n - 1] = 0;
 3dc:	95aa                	add	a1,a1,a0
 3de:	fe058fa3          	sb	zero,-1(a1)
 3e2:	bfcd                	j	3d4 <vsnprintf+0x228>

00000000000003e4 <printf>:
int printf(char*s, ...){
 3e4:	710d                	addi	sp,sp,-352
 3e6:	ee06                	sd	ra,280(sp)
 3e8:	ea22                	sd	s0,272(sp)
 3ea:	1200                	addi	s0,sp,288
 3ec:	e40c                	sd	a1,8(s0)
 3ee:	e810                	sd	a2,16(s0)
 3f0:	ec14                	sd	a3,24(s0)
 3f2:	f018                	sd	a4,32(s0)
 3f4:	f41c                	sd	a5,40(s0)
 3f6:	03043823          	sd	a6,48(s0)
 3fa:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 3fe:	00840693          	addi	a3,s0,8
 402:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 406:	862a                	mv	a2,a0
 408:	10000593          	li	a1,256
 40c:	ee840513          	addi	a0,s0,-280
 410:	00000097          	auipc	ra,0x0
 414:	d9c080e7          	jalr	-612(ra) # 1ac <vsnprintf>
 418:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 41a:	0005071b          	sext.w	a4,a0
 41e:	0ff00793          	li	a5,255
 422:	00e7f463          	bgeu	a5,a4,42a <printf+0x46>
 426:	10000593          	li	a1,256
    return simple_write(buf, n);
 42a:	ee840513          	addi	a0,s0,-280
 42e:	00000097          	auipc	ra,0x0
 432:	d34080e7          	jalr	-716(ra) # 162 <simple_write>
}
 436:	2501                	sext.w	a0,a0
 438:	60f2                	ld	ra,280(sp)
 43a:	6452                	ld	s0,272(sp)
 43c:	6135                	addi	sp,sp,352
 43e:	8082                	ret
