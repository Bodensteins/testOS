
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
   c:	43050513          	addi	a0,a0,1072 # 438 <printf+0x5c>
  10:	00000097          	auipc	ra,0x0
  14:	3cc080e7          	jalr	972(ra) # 3dc <printf>
    exec("/main");
  18:	00000517          	auipc	a0,0x0
  1c:	42850513          	addi	a0,a0,1064 # 440 <printf+0x64>
  20:	00000097          	auipc	ra,0x0
  24:	11c080e7          	jalr	284(ra) # 13c <exec>

    while(1){
  28:	a001                	j	28 <main+0x28>

000000000000002a <user_syscall>:
/*
用户态使用系统调用
*/

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
        asm volatile(   //将参数写入a0-a7寄存器
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

        asm volatile(   //调用ecall
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

//复制一个新进程
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

//进程退出
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

//打开文件
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

//根据文件描述符fd，读取文件中rsize个字节到buf中
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

//根据pid杀死进程
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

//从外存中根据文件路径和名字加载可执行文件
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

//一个简单的输出字符串到屏幕上的系统调用
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

//根据文件描述符关闭文件
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
 1b0:	20078863          	beqz	a5,3c0 <vsnprintf+0x214>
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
 1cc:	4801                	li	a6,0
  int longarg = 0;
 1ce:	4b01                	li	s6,0
  int format = 0;
 1d0:	4701                	li	a4,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 1d2:	02500293          	li	t0,37
      format = 1;
 1d6:	4385                	li	t2,1
 1d8:	4fd5                	li	t6,21
 1da:	00000e97          	auipc	t4,0x0
 1de:	26ee8e93          	addi	t4,t4,622 # 448 <printf+0x6c>
          longarg = 0;
 1e2:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 1e4:	48a9                	li	a7,10
            if (++pos < n) out[pos - 1] = '-';
 1e6:	02d00a93          	li	s5,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 1ea:	4f25                	li	t5,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 1ec:	5371                	li	t1,-4
 1ee:	44bd                	li	s1,15
 1f0:	4a1d                	li	s4,7
          if (++pos < n) out[pos - 1] = 'x';
 1f2:	07800993          	li	s3,120
          if (++pos < n) out[pos - 1] = '0';
 1f6:	03000913          	li	s2,48
 1fa:	aaa5                	j	372 <vsnprintf+0x1c6>
    if (format) {
 1fc:	8b3a                	mv	s6,a4
 1fe:	a2b5                	j	36a <vsnprintf+0x1be>
          if (++pos < n) out[pos - 1] = '0';
 200:	00180793          	addi	a5,a6,1
 204:	00b7f663          	bgeu	a5,a1,210 <vsnprintf+0x64>
 208:	01050733          	add	a4,a0,a6
 20c:	01270023          	sb	s2,0(a4)
          if (++pos < n) out[pos - 1] = 'x';
 210:	0809                	addi	a6,a6,2
 212:	00b87563          	bgeu	a6,a1,21c <vsnprintf+0x70>
 216:	97aa                	add	a5,a5,a0
 218:	01378023          	sb	s3,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 21c:	0006bc03          	ld	s8,0(a3)
 220:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 222:	87a6                	mv	a5,s1
 224:	00078c9b          	sext.w	s9,a5
 228:	078a                	slli	a5,a5,0x2
 22a:	8742                	mv	a4,a6
 22c:	a839                	j	24a <vsnprintf+0x9e>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 22e:	fe0b17e3          	bnez	s6,21c <vsnprintf+0x70>
 232:	0006ac03          	lw	s8,0(a3)
 236:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 238:	87d2                	mv	a5,s4
 23a:	b7ed                	j	224 <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 23c:	00e50b33          	add	s6,a0,a4
 240:	ff7b0fa3          	sb	s7,-1(s6)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 244:	37f1                	addiw	a5,a5,-4
 246:	02678063          	beq	a5,t1,266 <vsnprintf+0xba>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 24a:	0705                	addi	a4,a4,1
 24c:	feb77ce3          	bgeu	a4,a1,244 <vsnprintf+0x98>
            int d = (num >> (4 * i)) & 0xF;
 250:	40fc5b33          	sra	s6,s8,a5
 254:	00fb7b13          	andi	s6,s6,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 258:	057b0b93          	addi	s7,s6,87
 25c:	ff6f40e3          	blt	t5,s6,23c <vsnprintf+0x90>
 260:	030b0b93          	addi	s7,s6,48
 264:	bfe1                	j	23c <vsnprintf+0x90>
 266:	0805                	addi	a6,a6,1
 268:	9866                	add	a6,a6,s9
          longarg = 0;
 26a:	8b72                	mv	s6,t3
          format = 0;
 26c:	8772                	mv	a4,t3
 26e:	a8f5                	j	36a <vsnprintf+0x1be>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 270:	020b0563          	beqz	s6,29a <vsnprintf+0xee>
 274:	6298                	ld	a4,0(a3)
 276:	06a1                	addi	a3,a3,8
          if (num < 0) {
 278:	02074463          	bltz	a4,2a0 <vsnprintf+0xf4>
          for (long nn = num; nn /= 10; digits++)
 27c:	031747b3          	div	a5,a4,a7
 280:	cf8d                	beqz	a5,2ba <vsnprintf+0x10e>
          long digits = 1;
 282:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 284:	0b05                	addi	s6,s6,1
 286:	0317c7b3          	div	a5,a5,a7
 28a:	ffed                	bnez	a5,284 <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 28c:	fffb079b          	addiw	a5,s6,-1
 290:	0407cd63          	bltz	a5,2ea <vsnprintf+0x13e>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 294:	00180c13          	addi	s8,a6,1
 298:	a81d                	j	2ce <vsnprintf+0x122>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 29a:	4298                	lw	a4,0(a3)
 29c:	06a1                	addi	a3,a3,8
 29e:	bfe9                	j	278 <vsnprintf+0xcc>
            num = -num;
 2a0:	40e00733          	neg	a4,a4
            if (++pos < n) out[pos - 1] = '-';
 2a4:	00180793          	addi	a5,a6,1
 2a8:	00b7f763          	bgeu	a5,a1,2b6 <vsnprintf+0x10a>
 2ac:	982a                	add	a6,a6,a0
 2ae:	01580023          	sb	s5,0(a6)
 2b2:	883e                	mv	a6,a5
 2b4:	b7e1                	j	27c <vsnprintf+0xd0>
 2b6:	883e                	mv	a6,a5
 2b8:	b7d1                	j	27c <vsnprintf+0xd0>
          long digits = 1;
 2ba:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 2bc:	87f2                	mv	a5,t3
 2be:	bfd9                	j	294 <vsnprintf+0xe8>
            num /= 10;
 2c0:	03174733          	div	a4,a4,a7
          for (int i = digits - 1; i >= 0; i--) {
 2c4:	17fd                	addi	a5,a5,-1
 2c6:	00078b9b          	sext.w	s7,a5
 2ca:	020bc063          	bltz	s7,2ea <vsnprintf+0x13e>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 2ce:	00fc0bb3          	add	s7,s8,a5
 2d2:	febbf7e3          	bgeu	s7,a1,2c0 <vsnprintf+0x114>
 2d6:	00f80bb3          	add	s7,a6,a5
 2da:	9baa                	add	s7,s7,a0
 2dc:	03176cb3          	rem	s9,a4,a7
 2e0:	030c8c9b          	addiw	s9,s9,48
 2e4:	019b8023          	sb	s9,0(s7)
 2e8:	bfe1                	j	2c0 <vsnprintf+0x114>
          pos += digits;
 2ea:	985a                	add	a6,a6,s6
          longarg = 0;
 2ec:	8b72                	mv	s6,t3
          format = 0;
 2ee:	8772                	mv	a4,t3
          break;
 2f0:	a8ad                	j	36a <vsnprintf+0x1be>
          const char* s2 = va_arg(vl, const char*);
 2f2:	00868b93          	addi	s7,a3,8
 2f6:	6294                	ld	a3,0(a3)
          while (*s2) {
 2f8:	0006c703          	lbu	a4,0(a3)
 2fc:	cf31                	beqz	a4,358 <vsnprintf+0x1ac>
 2fe:	87c2                	mv	a5,a6
 300:	a039                	j	30e <vsnprintf+0x162>
 302:	41078733          	sub	a4,a5,a6
 306:	9736                	add	a4,a4,a3
 308:	00074703          	lbu	a4,0(a4)
 30c:	cb09                	beqz	a4,31e <vsnprintf+0x172>
            if (++pos < n) out[pos - 1] = *s2;
 30e:	0785                	addi	a5,a5,1
 310:	feb7f9e3          	bgeu	a5,a1,302 <vsnprintf+0x156>
 314:	00f50b33          	add	s6,a0,a5
 318:	feeb0fa3          	sb	a4,-1(s6)
 31c:	b7dd                	j	302 <vsnprintf+0x156>
          const char* s2 = va_arg(vl, const char*);
 31e:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 320:	883e                	mv	a6,a5
          longarg = 0;
 322:	8b72                	mv	s6,t3
          format = 0;
 324:	8772                	mv	a4,t3
 326:	a091                	j	36a <vsnprintf+0x1be>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 328:	00180793          	addi	a5,a6,1
 32c:	02b7fa63          	bgeu	a5,a1,360 <vsnprintf+0x1b4>
 330:	982a                	add	a6,a6,a0
 332:	4298                	lw	a4,0(a3)
 334:	00e80023          	sb	a4,0(a6)
 338:	06a1                	addi	a3,a3,8
 33a:	883e                	mv	a6,a5
          longarg = 0;
 33c:	8b72                	mv	s6,t3
          format = 0;
 33e:	8772                	mv	a4,t3
 340:	a02d                	j	36a <vsnprintf+0x1be>
    } else if (*s == '%')
 342:	02578363          	beq	a5,t0,368 <vsnprintf+0x1bc>
    else if (++pos < n)
 346:	00180b93          	addi	s7,a6,1
 34a:	04bbf163          	bgeu	s7,a1,38c <vsnprintf+0x1e0>
      out[pos - 1] = *s;
 34e:	982a                	add	a6,a6,a0
 350:	00f80023          	sb	a5,0(a6)
    else if (++pos < n)
 354:	885e                	mv	a6,s7
 356:	a811                	j	36a <vsnprintf+0x1be>
          const char* s2 = va_arg(vl, const char*);
 358:	86de                	mv	a3,s7
          longarg = 0;
 35a:	8b72                	mv	s6,t3
          format = 0;
 35c:	8772                	mv	a4,t3
 35e:	a031                	j	36a <vsnprintf+0x1be>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 360:	883e                	mv	a6,a5
          longarg = 0;
 362:	8b72                	mv	s6,t3
          format = 0;
 364:	8772                	mv	a4,t3
 366:	a011                	j	36a <vsnprintf+0x1be>
      format = 1;
 368:	871e                	mv	a4,t2
  for (; *s; s++) {
 36a:	0605                	addi	a2,a2,1
 36c:	00064783          	lbu	a5,0(a2)
 370:	c385                	beqz	a5,390 <vsnprintf+0x1e4>
    if (format) {
 372:	db61                	beqz	a4,342 <vsnprintf+0x196>
      switch (*s) {
 374:	f9d7879b          	addiw	a5,a5,-99
 378:	0ff7fb93          	andi	s7,a5,255
 37c:	ff7fe7e3          	bltu	t6,s7,36a <vsnprintf+0x1be>
 380:	002b9793          	slli	a5,s7,0x2
 384:	97f6                	add	a5,a5,t4
 386:	439c                	lw	a5,0(a5)
 388:	97f6                	add	a5,a5,t4
 38a:	8782                	jr	a5
    else if (++pos < n)
 38c:	885e                	mv	a6,s7
 38e:	bff1                	j	36a <vsnprintf+0x1be>
  }
  if (pos < n)
 390:	02b87363          	bgeu	a6,a1,3b6 <vsnprintf+0x20a>
    out[pos] = 0;
 394:	9542                	add	a0,a0,a6
 396:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 39a:	0008051b          	sext.w	a0,a6
 39e:	6426                	ld	s0,72(sp)
 3a0:	6486                	ld	s1,64(sp)
 3a2:	7962                	ld	s2,56(sp)
 3a4:	79c2                	ld	s3,48(sp)
 3a6:	7a22                	ld	s4,40(sp)
 3a8:	7a82                	ld	s5,32(sp)
 3aa:	6b62                	ld	s6,24(sp)
 3ac:	6bc2                	ld	s7,16(sp)
 3ae:	6c22                	ld	s8,8(sp)
 3b0:	6c82                	ld	s9,0(sp)
 3b2:	6161                	addi	sp,sp,80
 3b4:	8082                	ret
  else if (n)
 3b6:	d1f5                	beqz	a1,39a <vsnprintf+0x1ee>
    out[n - 1] = 0;
 3b8:	95aa                	add	a1,a1,a0
 3ba:	fe058fa3          	sb	zero,-1(a1)
 3be:	bff1                	j	39a <vsnprintf+0x1ee>
  size_t pos = 0;
 3c0:	4801                	li	a6,0
  if (pos < n)
 3c2:	00b87863          	bgeu	a6,a1,3d2 <vsnprintf+0x226>
    out[pos] = 0;
 3c6:	9542                	add	a0,a0,a6
 3c8:	00050023          	sb	zero,0(a0)
}
 3cc:	0008051b          	sext.w	a0,a6
 3d0:	8082                	ret
  else if (n)
 3d2:	dded                	beqz	a1,3cc <vsnprintf+0x220>
    out[n - 1] = 0;
 3d4:	95aa                	add	a1,a1,a0
 3d6:	fe058fa3          	sb	zero,-1(a1)
 3da:	bfcd                	j	3cc <vsnprintf+0x220>

00000000000003dc <printf>:
int printf(char*s, ...){
 3dc:	710d                	addi	sp,sp,-352
 3de:	ee06                	sd	ra,280(sp)
 3e0:	ea22                	sd	s0,272(sp)
 3e2:	1200                	addi	s0,sp,288
 3e4:	e40c                	sd	a1,8(s0)
 3e6:	e810                	sd	a2,16(s0)
 3e8:	ec14                	sd	a3,24(s0)
 3ea:	f018                	sd	a4,32(s0)
 3ec:	f41c                	sd	a5,40(s0)
 3ee:	03043823          	sd	a6,48(s0)
 3f2:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 3f6:	00840693          	addi	a3,s0,8
 3fa:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 3fe:	862a                	mv	a2,a0
 400:	10000593          	li	a1,256
 404:	ee840513          	addi	a0,s0,-280
 408:	00000097          	auipc	ra,0x0
 40c:	da4080e7          	jalr	-604(ra) # 1ac <vsnprintf>
 410:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 412:	0005071b          	sext.w	a4,a0
 416:	0ff00793          	li	a5,255
 41a:	00e7f463          	bgeu	a5,a4,422 <printf+0x46>
 41e:	10000593          	li	a1,256
    return simple_write(buf, n);
 422:	ee840513          	addi	a0,s0,-280
 426:	00000097          	auipc	ra,0x0
 42a:	d3c080e7          	jalr	-708(ra) # 162 <simple_write>
}
 42e:	2501                	sext.w	a0,a0
 430:	60f2                	ld	ra,280(sp)
 432:	6452                	ld	s0,272(sp)
 434:	6135                	addi	sp,sp,352
 436:	8082                	ret
