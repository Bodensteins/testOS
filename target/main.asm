
target/main：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "stdio.h"
#include "user_syscall.h"

int main(){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16

    printf("hello world\n");    
   8:	00000517          	auipc	a0,0x0
   c:	42050513          	addi	a0,a0,1056 # 428 <printf+0x5c>
  10:	00000097          	auipc	ra,0x0
  14:	3bc080e7          	jalr	956(ra) # 3cc <printf>
    while(1){}
  18:	a001                	j	18 <main+0x18>

000000000000001a <user_syscall>:
/*
用户态使用系统调用
*/

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
        asm volatile(   //将参数写入a0-a7寄存器
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

        asm volatile(   //调用ecall
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

//复制一个新进程
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

//进程退出
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

//打开文件
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

//根据文件描述符fd，读取文件中rsize个字节到buf中
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

//根据pid杀死进程
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

//从外存中根据文件路径和名字加载可执行文件
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

//一个简单的输出字符串到屏幕上的系统调用
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

//根据文件描述符关闭文件
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
 1a0:	20078863          	beqz	a5,3b0 <vsnprintf+0x214>
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
 1bc:	4801                	li	a6,0
  int longarg = 0;
 1be:	4b01                	li	s6,0
  int format = 0;
 1c0:	4701                	li	a4,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 1c2:	02500293          	li	t0,37
      format = 1;
 1c6:	4385                	li	t2,1
 1c8:	4fd5                	li	t6,21
 1ca:	00000e97          	auipc	t4,0x0
 1ce:	26ee8e93          	addi	t4,t4,622 # 438 <printf+0x6c>
          longarg = 0;
 1d2:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 1d4:	48a9                	li	a7,10
            if (++pos < n) out[pos - 1] = '-';
 1d6:	02d00a93          	li	s5,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 1da:	4f25                	li	t5,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 1dc:	5371                	li	t1,-4
 1de:	44bd                	li	s1,15
 1e0:	4a1d                	li	s4,7
          if (++pos < n) out[pos - 1] = 'x';
 1e2:	07800993          	li	s3,120
          if (++pos < n) out[pos - 1] = '0';
 1e6:	03000913          	li	s2,48
 1ea:	aaa5                	j	362 <vsnprintf+0x1c6>
    if (format) {
 1ec:	8b3a                	mv	s6,a4
 1ee:	a2b5                	j	35a <vsnprintf+0x1be>
          if (++pos < n) out[pos - 1] = '0';
 1f0:	00180793          	addi	a5,a6,1
 1f4:	00b7f663          	bgeu	a5,a1,200 <vsnprintf+0x64>
 1f8:	01050733          	add	a4,a0,a6
 1fc:	01270023          	sb	s2,0(a4)
          if (++pos < n) out[pos - 1] = 'x';
 200:	0809                	addi	a6,a6,2
 202:	00b87563          	bgeu	a6,a1,20c <vsnprintf+0x70>
 206:	97aa                	add	a5,a5,a0
 208:	01378023          	sb	s3,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 20c:	0006bc03          	ld	s8,0(a3)
 210:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 212:	87a6                	mv	a5,s1
 214:	00078c9b          	sext.w	s9,a5
 218:	078a                	slli	a5,a5,0x2
 21a:	8742                	mv	a4,a6
 21c:	a839                	j	23a <vsnprintf+0x9e>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 21e:	fe0b17e3          	bnez	s6,20c <vsnprintf+0x70>
 222:	0006ac03          	lw	s8,0(a3)
 226:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 228:	87d2                	mv	a5,s4
 22a:	b7ed                	j	214 <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 22c:	00e50b33          	add	s6,a0,a4
 230:	ff7b0fa3          	sb	s7,-1(s6)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 234:	37f1                	addiw	a5,a5,-4
 236:	02678063          	beq	a5,t1,256 <vsnprintf+0xba>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 23a:	0705                	addi	a4,a4,1
 23c:	feb77ce3          	bgeu	a4,a1,234 <vsnprintf+0x98>
            int d = (num >> (4 * i)) & 0xF;
 240:	40fc5b33          	sra	s6,s8,a5
 244:	00fb7b13          	andi	s6,s6,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 248:	057b0b93          	addi	s7,s6,87
 24c:	ff6f40e3          	blt	t5,s6,22c <vsnprintf+0x90>
 250:	030b0b93          	addi	s7,s6,48
 254:	bfe1                	j	22c <vsnprintf+0x90>
 256:	0805                	addi	a6,a6,1
 258:	9866                	add	a6,a6,s9
          longarg = 0;
 25a:	8b72                	mv	s6,t3
          format = 0;
 25c:	8772                	mv	a4,t3
 25e:	a8f5                	j	35a <vsnprintf+0x1be>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 260:	020b0563          	beqz	s6,28a <vsnprintf+0xee>
 264:	6298                	ld	a4,0(a3)
 266:	06a1                	addi	a3,a3,8
          if (num < 0) {
 268:	02074463          	bltz	a4,290 <vsnprintf+0xf4>
          for (long nn = num; nn /= 10; digits++)
 26c:	031747b3          	div	a5,a4,a7
 270:	cf8d                	beqz	a5,2aa <vsnprintf+0x10e>
          long digits = 1;
 272:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 274:	0b05                	addi	s6,s6,1
 276:	0317c7b3          	div	a5,a5,a7
 27a:	ffed                	bnez	a5,274 <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 27c:	fffb079b          	addiw	a5,s6,-1
 280:	0407cd63          	bltz	a5,2da <vsnprintf+0x13e>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 284:	00180c13          	addi	s8,a6,1
 288:	a81d                	j	2be <vsnprintf+0x122>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 28a:	4298                	lw	a4,0(a3)
 28c:	06a1                	addi	a3,a3,8
 28e:	bfe9                	j	268 <vsnprintf+0xcc>
            num = -num;
 290:	40e00733          	neg	a4,a4
            if (++pos < n) out[pos - 1] = '-';
 294:	00180793          	addi	a5,a6,1
 298:	00b7f763          	bgeu	a5,a1,2a6 <vsnprintf+0x10a>
 29c:	982a                	add	a6,a6,a0
 29e:	01580023          	sb	s5,0(a6)
 2a2:	883e                	mv	a6,a5
 2a4:	b7e1                	j	26c <vsnprintf+0xd0>
 2a6:	883e                	mv	a6,a5
 2a8:	b7d1                	j	26c <vsnprintf+0xd0>
          long digits = 1;
 2aa:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 2ac:	87f2                	mv	a5,t3
 2ae:	bfd9                	j	284 <vsnprintf+0xe8>
            num /= 10;
 2b0:	03174733          	div	a4,a4,a7
          for (int i = digits - 1; i >= 0; i--) {
 2b4:	17fd                	addi	a5,a5,-1
 2b6:	00078b9b          	sext.w	s7,a5
 2ba:	020bc063          	bltz	s7,2da <vsnprintf+0x13e>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 2be:	00fc0bb3          	add	s7,s8,a5
 2c2:	febbf7e3          	bgeu	s7,a1,2b0 <vsnprintf+0x114>
 2c6:	00f80bb3          	add	s7,a6,a5
 2ca:	9baa                	add	s7,s7,a0
 2cc:	03176cb3          	rem	s9,a4,a7
 2d0:	030c8c9b          	addiw	s9,s9,48
 2d4:	019b8023          	sb	s9,0(s7)
 2d8:	bfe1                	j	2b0 <vsnprintf+0x114>
          pos += digits;
 2da:	985a                	add	a6,a6,s6
          longarg = 0;
 2dc:	8b72                	mv	s6,t3
          format = 0;
 2de:	8772                	mv	a4,t3
          break;
 2e0:	a8ad                	j	35a <vsnprintf+0x1be>
          const char* s2 = va_arg(vl, const char*);
 2e2:	00868b93          	addi	s7,a3,8
 2e6:	6294                	ld	a3,0(a3)
          while (*s2) {
 2e8:	0006c703          	lbu	a4,0(a3)
 2ec:	cf31                	beqz	a4,348 <vsnprintf+0x1ac>
 2ee:	87c2                	mv	a5,a6
 2f0:	a039                	j	2fe <vsnprintf+0x162>
 2f2:	41078733          	sub	a4,a5,a6
 2f6:	9736                	add	a4,a4,a3
 2f8:	00074703          	lbu	a4,0(a4)
 2fc:	cb09                	beqz	a4,30e <vsnprintf+0x172>
            if (++pos < n) out[pos - 1] = *s2;
 2fe:	0785                	addi	a5,a5,1
 300:	feb7f9e3          	bgeu	a5,a1,2f2 <vsnprintf+0x156>
 304:	00f50b33          	add	s6,a0,a5
 308:	feeb0fa3          	sb	a4,-1(s6)
 30c:	b7dd                	j	2f2 <vsnprintf+0x156>
          const char* s2 = va_arg(vl, const char*);
 30e:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 310:	883e                	mv	a6,a5
          longarg = 0;
 312:	8b72                	mv	s6,t3
          format = 0;
 314:	8772                	mv	a4,t3
 316:	a091                	j	35a <vsnprintf+0x1be>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 318:	00180793          	addi	a5,a6,1
 31c:	02b7fa63          	bgeu	a5,a1,350 <vsnprintf+0x1b4>
 320:	982a                	add	a6,a6,a0
 322:	4298                	lw	a4,0(a3)
 324:	00e80023          	sb	a4,0(a6)
 328:	06a1                	addi	a3,a3,8
 32a:	883e                	mv	a6,a5
          longarg = 0;
 32c:	8b72                	mv	s6,t3
          format = 0;
 32e:	8772                	mv	a4,t3
 330:	a02d                	j	35a <vsnprintf+0x1be>
    } else if (*s == '%')
 332:	02578363          	beq	a5,t0,358 <vsnprintf+0x1bc>
    else if (++pos < n)
 336:	00180b93          	addi	s7,a6,1
 33a:	04bbf163          	bgeu	s7,a1,37c <vsnprintf+0x1e0>
      out[pos - 1] = *s;
 33e:	982a                	add	a6,a6,a0
 340:	00f80023          	sb	a5,0(a6)
    else if (++pos < n)
 344:	885e                	mv	a6,s7
 346:	a811                	j	35a <vsnprintf+0x1be>
          const char* s2 = va_arg(vl, const char*);
 348:	86de                	mv	a3,s7
          longarg = 0;
 34a:	8b72                	mv	s6,t3
          format = 0;
 34c:	8772                	mv	a4,t3
 34e:	a031                	j	35a <vsnprintf+0x1be>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 350:	883e                	mv	a6,a5
          longarg = 0;
 352:	8b72                	mv	s6,t3
          format = 0;
 354:	8772                	mv	a4,t3
 356:	a011                	j	35a <vsnprintf+0x1be>
      format = 1;
 358:	871e                	mv	a4,t2
  for (; *s; s++) {
 35a:	0605                	addi	a2,a2,1
 35c:	00064783          	lbu	a5,0(a2)
 360:	c385                	beqz	a5,380 <vsnprintf+0x1e4>
    if (format) {
 362:	db61                	beqz	a4,332 <vsnprintf+0x196>
      switch (*s) {
 364:	f9d7879b          	addiw	a5,a5,-99
 368:	0ff7fb93          	andi	s7,a5,255
 36c:	ff7fe7e3          	bltu	t6,s7,35a <vsnprintf+0x1be>
 370:	002b9793          	slli	a5,s7,0x2
 374:	97f6                	add	a5,a5,t4
 376:	439c                	lw	a5,0(a5)
 378:	97f6                	add	a5,a5,t4
 37a:	8782                	jr	a5
    else if (++pos < n)
 37c:	885e                	mv	a6,s7
 37e:	bff1                	j	35a <vsnprintf+0x1be>
  }
  if (pos < n)
 380:	02b87363          	bgeu	a6,a1,3a6 <vsnprintf+0x20a>
    out[pos] = 0;
 384:	9542                	add	a0,a0,a6
 386:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 38a:	0008051b          	sext.w	a0,a6
 38e:	6426                	ld	s0,72(sp)
 390:	6486                	ld	s1,64(sp)
 392:	7962                	ld	s2,56(sp)
 394:	79c2                	ld	s3,48(sp)
 396:	7a22                	ld	s4,40(sp)
 398:	7a82                	ld	s5,32(sp)
 39a:	6b62                	ld	s6,24(sp)
 39c:	6bc2                	ld	s7,16(sp)
 39e:	6c22                	ld	s8,8(sp)
 3a0:	6c82                	ld	s9,0(sp)
 3a2:	6161                	addi	sp,sp,80
 3a4:	8082                	ret
  else if (n)
 3a6:	d1f5                	beqz	a1,38a <vsnprintf+0x1ee>
    out[n - 1] = 0;
 3a8:	95aa                	add	a1,a1,a0
 3aa:	fe058fa3          	sb	zero,-1(a1)
 3ae:	bff1                	j	38a <vsnprintf+0x1ee>
  size_t pos = 0;
 3b0:	4801                	li	a6,0
  if (pos < n)
 3b2:	00b87863          	bgeu	a6,a1,3c2 <vsnprintf+0x226>
    out[pos] = 0;
 3b6:	9542                	add	a0,a0,a6
 3b8:	00050023          	sb	zero,0(a0)
}
 3bc:	0008051b          	sext.w	a0,a6
 3c0:	8082                	ret
  else if (n)
 3c2:	dded                	beqz	a1,3bc <vsnprintf+0x220>
    out[n - 1] = 0;
 3c4:	95aa                	add	a1,a1,a0
 3c6:	fe058fa3          	sb	zero,-1(a1)
 3ca:	bfcd                	j	3bc <vsnprintf+0x220>

00000000000003cc <printf>:
int printf(char*s, ...){
 3cc:	710d                	addi	sp,sp,-352
 3ce:	ee06                	sd	ra,280(sp)
 3d0:	ea22                	sd	s0,272(sp)
 3d2:	1200                	addi	s0,sp,288
 3d4:	e40c                	sd	a1,8(s0)
 3d6:	e810                	sd	a2,16(s0)
 3d8:	ec14                	sd	a3,24(s0)
 3da:	f018                	sd	a4,32(s0)
 3dc:	f41c                	sd	a5,40(s0)
 3de:	03043823          	sd	a6,48(s0)
 3e2:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 3e6:	00840693          	addi	a3,s0,8
 3ea:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 3ee:	862a                	mv	a2,a0
 3f0:	10000593          	li	a1,256
 3f4:	ee840513          	addi	a0,s0,-280
 3f8:	00000097          	auipc	ra,0x0
 3fc:	da4080e7          	jalr	-604(ra) # 19c <vsnprintf>
 400:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 402:	0005071b          	sext.w	a4,a0
 406:	0ff00793          	li	a5,255
 40a:	00e7f463          	bgeu	a5,a4,412 <printf+0x46>
 40e:	10000593          	li	a1,256
    return simple_write(buf, n);
 412:	ee840513          	addi	a0,s0,-280
 416:	00000097          	auipc	ra,0x0
 41a:	d3c080e7          	jalr	-708(ra) # 152 <simple_write>
}
 41e:	2501                	sext.w	a0,a0
 420:	60f2                	ld	ra,280(sp)
 422:	6452                	ld	s0,272(sp)
 424:	6135                	addi	sp,sp,352
 426:	8082                	ret
