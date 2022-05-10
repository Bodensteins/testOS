
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
    printf("test\n");
   c:	00000517          	auipc	a0,0x0
  10:	4b450513          	addi	a0,a0,1204 # 4c0 <printf+0x86>
  14:	00000097          	auipc	ra,0x0
  18:	426080e7          	jalr	1062(ra) # 43a <printf>
    char *argv[5]={"try ", "more ","test!", "\n", NULL};
  1c:	00000797          	auipc	a5,0x0
  20:	47c78793          	addi	a5,a5,1148 # 498 <printf+0x5e>
  24:	638c                	ld	a1,0(a5)
  26:	6790                	ld	a2,8(a5)
  28:	6b94                	ld	a3,16(a5)
  2a:	6f98                	ld	a4,24(a5)
  2c:	739c                	ld	a5,32(a5)
  2e:	fab43c23          	sd	a1,-72(s0)
  32:	fcc43023          	sd	a2,-64(s0)
  36:	fcd43423          	sd	a3,-56(s0)
  3a:	fce43823          	sd	a4,-48(s0)
  3e:	fcf43c23          	sd	a5,-40(s0)
    for(int i=0;i<4;i++){
  42:	fb840493          	addi	s1,s0,-72
  46:	fd840913          	addi	s2,s0,-40
        printf(argv[i]);
  4a:	6088                	ld	a0,0(s1)
  4c:	00000097          	auipc	ra,0x0
  50:	3ee080e7          	jalr	1006(ra) # 43a <printf>
  54:	04a1                	addi	s1,s1,8
    for(int i=0;i<4;i++){
  56:	ff249ae3          	bne	s1,s2,4a <main+0x4a>
    }
    printf("\n...................................\n");
  5a:	00000517          	auipc	a0,0x0
  5e:	46e50513          	addi	a0,a0,1134 # 4c8 <printf+0x8e>
  62:	00000097          	auipc	ra,0x0
  66:	3d8080e7          	jalr	984(ra) # 43a <printf>
    execve("/main",argv, NULL);
  6a:	4601                	li	a2,0
  6c:	fb840593          	addi	a1,s0,-72
  70:	00000517          	auipc	a0,0x0
  74:	48050513          	addi	a0,a0,1152 # 4f0 <printf+0xb6>
  78:	00000097          	auipc	ra,0x0
  7c:	11c080e7          	jalr	284(ra) # 194 <execve>

    while(1){
    }
  80:	a001                	j	80 <main+0x80>

0000000000000082 <user_syscall>:
/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
  82:	715d                	addi	sp,sp,-80
  84:	e4a2                	sd	s0,72(sp)
  86:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
  88:	fea43423          	sd	a0,-24(s0)
  8c:	feb43023          	sd	a1,-32(s0)
  90:	fcc43c23          	sd	a2,-40(s0)
  94:	fcd43823          	sd	a3,-48(s0)
  98:	fce43423          	sd	a4,-56(s0)
  9c:	fcf43023          	sd	a5,-64(s0)
  a0:	fb043c23          	sd	a6,-72(s0)
  a4:	fb143823          	sd	a7,-80(s0)
        asm volatile(   //将参数写入a0-a7寄存器
  a8:	fe843503          	ld	a0,-24(s0)
  ac:	fe043583          	ld	a1,-32(s0)
  b0:	fd843603          	ld	a2,-40(s0)
  b4:	fd043683          	ld	a3,-48(s0)
  b8:	fc843703          	ld	a4,-56(s0)
  bc:	fc043783          	ld	a5,-64(s0)
  c0:	fb843803          	ld	a6,-72(s0)
  c4:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(   //调用ecall
  c8:	00000073          	ecall
  cc:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
  d0:	fe843503          	ld	a0,-24(s0)
  d4:	6426                	ld	s0,72(sp)
  d6:	6161                	addi	sp,sp,80
  d8:	8082                	ret

00000000000000da <fork>:

//复制一个新进程
uint64 fork(){
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
  e2:	4885                	li	a7,1
  e4:	4801                	li	a6,0
  e6:	4781                	li	a5,0
  e8:	4701                	li	a4,0
  ea:	4681                	li	a3,0
  ec:	4601                	li	a2,0
  ee:	4581                	li	a1,0
  f0:	4501                	li	a0,0
  f2:	00000097          	auipc	ra,0x0
  f6:	f90080e7          	jalr	-112(ra) # 82 <user_syscall>
}
  fa:	60a2                	ld	ra,8(sp)
  fc:	6402                	ld	s0,0(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret

0000000000000102 <exit>:

//进程退出
uint64 exit(int code){
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
 10a:	4889                	li	a7,2
 10c:	4801                	li	a6,0
 10e:	4781                	li	a5,0
 110:	4701                	li	a4,0
 112:	4681                	li	a3,0
 114:	4601                	li	a2,0
 116:	4581                	li	a1,0
 118:	00000097          	auipc	ra,0x0
 11c:	f6a080e7          	jalr	-150(ra) # 82 <user_syscall>
}
 120:	60a2                	ld	ra,8(sp)
 122:	6402                	ld	s0,0(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <open>:

//打开文件
uint64 open(char *file_name, int mode){
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
 130:	48bd                	li	a7,15
 132:	4801                	li	a6,0
 134:	4781                	li	a5,0
 136:	4701                	li	a4,0
 138:	4681                	li	a3,0
 13a:	4601                	li	a2,0
 13c:	00000097          	auipc	ra,0x0
 140:	f46080e7          	jalr	-186(ra) # 82 <user_syscall>
}
 144:	60a2                	ld	ra,8(sp)
 146:	6402                	ld	s0,0(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret

000000000000014c <read>:

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
 14c:	1141                	addi	sp,sp,-16
 14e:	e406                	sd	ra,8(sp)
 150:	e022                	sd	s0,0(sp)
 152:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
 154:	4895                	li	a7,5
 156:	4801                	li	a6,0
 158:	4781                	li	a5,0
 15a:	4701                	li	a4,0
 15c:	4681                	li	a3,0
 15e:	00000097          	auipc	ra,0x0
 162:	f24080e7          	jalr	-220(ra) # 82 <user_syscall>
}
 166:	60a2                	ld	ra,8(sp)
 168:	6402                	ld	s0,0(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <kill>:

//根据pid杀死进程
uint64 kill(uint64 pid){
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
 176:	4899                	li	a7,6
 178:	4801                	li	a6,0
 17a:	4781                	li	a5,0
 17c:	4701                	li	a4,0
 17e:	4681                	li	a3,0
 180:	4601                	li	a2,0
 182:	4581                	li	a1,0
 184:	00000097          	auipc	ra,0x0
 188:	efe080e7          	jalr	-258(ra) # 82 <user_syscall>
}
 18c:	60a2                	ld	ra,8(sp)
 18e:	6402                	ld	s0,0(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret

0000000000000194 <execve>:

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
 194:	1141                	addi	sp,sp,-16
 196:	e406                	sd	ra,8(sp)
 198:	e022                	sd	s0,0(sp)
 19a:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
 19c:	0dd00893          	li	a7,221
 1a0:	4801                	li	a6,0
 1a2:	4781                	li	a5,0
 1a4:	4701                	li	a4,0
 1a6:	4681                	li	a3,0
 1a8:	00000097          	auipc	ra,0x0
 1ac:	eda080e7          	jalr	-294(ra) # 82 <user_syscall>
}
 1b0:	60a2                	ld	ra,8(sp)
 1b2:	6402                	ld	s0,0(sp)
 1b4:	0141                	addi	sp,sp,16
 1b6:	8082                	ret

00000000000001b8 <simple_write>:

//一个简单的输出字符串到屏幕上的系统调用
uint64 simple_write(char *s, size_t n){
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e406                	sd	ra,8(sp)
 1bc:	e022                	sd	s0,0(sp)
 1be:	0800                	addi	s0,sp,16
    return user_syscall((uint64)s,n,0,0,0,0,0,SYS_write);
 1c0:	48c1                	li	a7,16
 1c2:	4801                	li	a6,0
 1c4:	4781                	li	a5,0
 1c6:	4701                	li	a4,0
 1c8:	4681                	li	a3,0
 1ca:	4601                	li	a2,0
 1cc:	00000097          	auipc	ra,0x0
 1d0:	eb6080e7          	jalr	-330(ra) # 82 <user_syscall>
}
 1d4:	60a2                	ld	ra,8(sp)
 1d6:	6402                	ld	s0,0(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret

00000000000001dc <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
 1dc:	1141                	addi	sp,sp,-16
 1de:	e406                	sd	ra,8(sp)
 1e0:	e022                	sd	s0,0(sp)
 1e2:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
 1e4:	48d5                	li	a7,21
 1e6:	4801                	li	a6,0
 1e8:	4781                	li	a5,0
 1ea:	4701                	li	a4,0
 1ec:	4681                	li	a3,0
 1ee:	4601                	li	a2,0
 1f0:	4581                	li	a1,0
 1f2:	00000097          	auipc	ra,0x0
 1f6:	e90080e7          	jalr	-368(ra) # 82 <user_syscall>
}
 1fa:	60a2                	ld	ra,8(sp)
 1fc:	6402                	ld	s0,0(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret

0000000000000202 <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
 202:	00064783          	lbu	a5,0(a2)
 206:	20078c63          	beqz	a5,41e <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
 20a:	715d                	addi	sp,sp,-80
 20c:	e4a2                	sd	s0,72(sp)
 20e:	e0a6                	sd	s1,64(sp)
 210:	fc4a                	sd	s2,56(sp)
 212:	f84e                	sd	s3,48(sp)
 214:	f452                	sd	s4,40(sp)
 216:	f056                	sd	s5,32(sp)
 218:	ec5a                	sd	s6,24(sp)
 21a:	e85e                	sd	s7,16(sp)
 21c:	e462                	sd	s8,8(sp)
 21e:	e066                	sd	s9,0(sp)
 220:	0880                	addi	s0,sp,80
  size_t pos = 0;
 222:	4701                	li	a4,0
  int longarg = 0;
 224:	4b01                	li	s6,0
  int format = 0;
 226:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 228:	02500f93          	li	t6,37
      format = 1;
 22c:	4285                	li	t0,1
      switch (*s) {
 22e:	4f55                	li	t5,21
 230:	00000317          	auipc	t1,0x0
 234:	2e830313          	addi	t1,t1,744 # 518 <printf+0xde>
          longarg = 0;
 238:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 23a:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
 23c:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 240:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 242:	58fd                	li	a7,-1
 244:	43bd                	li	t2,15
 246:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
 248:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
 24c:	03000493          	li	s1,48
 250:	aabd                	j	3ce <vsnprintf+0x1cc>
          longarg = 1;
 252:	8b56                	mv	s6,s5
 254:	aa8d                	j	3c6 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
 256:	00170793          	addi	a5,a4,1
 25a:	00b7f663          	bgeu	a5,a1,266 <vsnprintf+0x64>
 25e:	00e50ab3          	add	s5,a0,a4
 262:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
 266:	0709                	addi	a4,a4,2
 268:	00b77563          	bgeu	a4,a1,272 <vsnprintf+0x70>
 26c:	97aa                	add	a5,a5,a0
 26e:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 272:	0006bc03          	ld	s8,0(a3)
 276:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 278:	8c9e                	mv	s9,t2
 27a:	8b66                	mv	s6,s9
 27c:	8aba                	mv	s5,a4
 27e:	a839                	j	29c <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 280:	fe0b19e3          	bnez	s6,272 <vsnprintf+0x70>
 284:	0006ac03          	lw	s8,0(a3)
 288:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 28a:	8cce                	mv	s9,s3
 28c:	b7fd                	j	27a <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 28e:	015507b3          	add	a5,a0,s5
 292:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 296:	3b7d                	addiw	s6,s6,-1
 298:	031b0163          	beq	s6,a7,2ba <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 29c:	0a85                	addi	s5,s5,1
 29e:	febafce3          	bgeu	s5,a1,296 <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
 2a2:	002b179b          	slliw	a5,s6,0x2
 2a6:	40fc57b3          	sra	a5,s8,a5
 2aa:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 2ac:	05778b93          	addi	s7,a5,87
 2b0:	fcfecfe3          	blt	t4,a5,28e <vsnprintf+0x8c>
 2b4:	03078b93          	addi	s7,a5,48
 2b8:	bfd9                	j	28e <vsnprintf+0x8c>
 2ba:	0705                	addi	a4,a4,1
 2bc:	9766                	add	a4,a4,s9
          longarg = 0;
 2be:	8b72                	mv	s6,t3
          format = 0;
 2c0:	8af2                	mv	s5,t3
 2c2:	a211                	j	3c6 <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 2c4:	020b0663          	beqz	s6,2f0 <vsnprintf+0xee>
 2c8:	0006ba83          	ld	s5,0(a3)
 2cc:	06a1                	addi	a3,a3,8
          if (num < 0) {
 2ce:	020ac563          	bltz	s5,2f8 <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
 2d2:	030ac7b3          	div	a5,s5,a6
 2d6:	cf95                	beqz	a5,312 <vsnprintf+0x110>
          long digits = 1;
 2d8:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 2da:	0b05                	addi	s6,s6,1
 2dc:	0307c7b3          	div	a5,a5,a6
 2e0:	ffed                	bnez	a5,2da <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 2e2:	fffb079b          	addiw	a5,s6,-1
 2e6:	0407ce63          	bltz	a5,342 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 2ea:	00170c93          	addi	s9,a4,1
 2ee:	a825                	j	326 <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 2f0:	0006aa83          	lw	s5,0(a3)
 2f4:	06a1                	addi	a3,a3,8
 2f6:	bfe1                	j	2ce <vsnprintf+0xcc>
            num = -num;
 2f8:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
 2fc:	00170793          	addi	a5,a4,1
 300:	00b7f763          	bgeu	a5,a1,30e <vsnprintf+0x10c>
 304:	972a                	add	a4,a4,a0
 306:	01470023          	sb	s4,0(a4)
 30a:	873e                	mv	a4,a5
 30c:	b7d9                	j	2d2 <vsnprintf+0xd0>
 30e:	873e                	mv	a4,a5
 310:	b7c9                	j	2d2 <vsnprintf+0xd0>
          long digits = 1;
 312:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 314:	87f2                	mv	a5,t3
 316:	bfd1                	j	2ea <vsnprintf+0xe8>
            num /= 10;
 318:	030acab3          	div	s5,s5,a6
 31c:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
 31e:	02079b93          	slli	s7,a5,0x20
 322:	020bc063          	bltz	s7,342 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 326:	00fc8bb3          	add	s7,s9,a5
 32a:	febbf7e3          	bgeu	s7,a1,318 <vsnprintf+0x116>
 32e:	00f70bb3          	add	s7,a4,a5
 332:	9baa                	add	s7,s7,a0
 334:	030aec33          	rem	s8,s5,a6
 338:	030c0c1b          	addiw	s8,s8,48
 33c:	018b8023          	sb	s8,0(s7)
 340:	bfe1                	j	318 <vsnprintf+0x116>
          pos += digits;
 342:	975a                	add	a4,a4,s6
          longarg = 0;
 344:	8b72                	mv	s6,t3
          format = 0;
 346:	8af2                	mv	s5,t3
          break;
 348:	a8bd                	j	3c6 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 34a:	00868b93          	addi	s7,a3,8
 34e:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
 352:	000ac683          	lbu	a3,0(s5)
 356:	ceb9                	beqz	a3,3b4 <vsnprintf+0x1b2>
 358:	87ba                	mv	a5,a4
 35a:	a039                	j	368 <vsnprintf+0x166>
 35c:	40e786b3          	sub	a3,a5,a4
 360:	96d6                	add	a3,a3,s5
 362:	0006c683          	lbu	a3,0(a3)
 366:	ca89                	beqz	a3,378 <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
 368:	0785                	addi	a5,a5,1
 36a:	feb7f9e3          	bgeu	a5,a1,35c <vsnprintf+0x15a>
 36e:	00f50b33          	add	s6,a0,a5
 372:	fedb0fa3          	sb	a3,-1(s6)
 376:	b7dd                	j	35c <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
 378:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 37a:	873e                	mv	a4,a5
          longarg = 0;
 37c:	8b72                	mv	s6,t3
          format = 0;
 37e:	8af2                	mv	s5,t3
 380:	a099                	j	3c6 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 382:	00170793          	addi	a5,a4,1
 386:	02b7fb63          	bgeu	a5,a1,3bc <vsnprintf+0x1ba>
 38a:	972a                	add	a4,a4,a0
 38c:	0006aa83          	lw	s5,0(a3)
 390:	01570023          	sb	s5,0(a4)
 394:	06a1                	addi	a3,a3,8
 396:	873e                	mv	a4,a5
          longarg = 0;
 398:	8b72                	mv	s6,t3
          format = 0;
 39a:	8af2                	mv	s5,t3
 39c:	a02d                	j	3c6 <vsnprintf+0x1c4>
    } else if (*s == '%')
 39e:	03f78363          	beq	a5,t6,3c4 <vsnprintf+0x1c2>
    else if (++pos < n)
 3a2:	00170b93          	addi	s7,a4,1
 3a6:	04bbf263          	bgeu	s7,a1,3ea <vsnprintf+0x1e8>
      out[pos - 1] = *s;
 3aa:	972a                	add	a4,a4,a0
 3ac:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
 3b0:	875e                	mv	a4,s7
 3b2:	a811                	j	3c6 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 3b4:	86de                	mv	a3,s7
          longarg = 0;
 3b6:	8b72                	mv	s6,t3
          format = 0;
 3b8:	8af2                	mv	s5,t3
 3ba:	a031                	j	3c6 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 3bc:	873e                	mv	a4,a5
          longarg = 0;
 3be:	8b72                	mv	s6,t3
          format = 0;
 3c0:	8af2                	mv	s5,t3
 3c2:	a011                	j	3c6 <vsnprintf+0x1c4>
      format = 1;
 3c4:	8a96                	mv	s5,t0
  for (; *s; s++) {
 3c6:	0605                	addi	a2,a2,1
 3c8:	00064783          	lbu	a5,0(a2)
 3cc:	c38d                	beqz	a5,3ee <vsnprintf+0x1ec>
    if (format) {
 3ce:	fc0a88e3          	beqz	s5,39e <vsnprintf+0x19c>
      switch (*s) {
 3d2:	f9d7879b          	addiw	a5,a5,-99
 3d6:	0ff7fb93          	andi	s7,a5,255
 3da:	ff7f66e3          	bltu	t5,s7,3c6 <vsnprintf+0x1c4>
 3de:	002b9793          	slli	a5,s7,0x2
 3e2:	979a                	add	a5,a5,t1
 3e4:	439c                	lw	a5,0(a5)
 3e6:	979a                	add	a5,a5,t1
 3e8:	8782                	jr	a5
    else if (++pos < n)
 3ea:	875e                	mv	a4,s7
 3ec:	bfe9                	j	3c6 <vsnprintf+0x1c4>
  }
  if (pos < n)
 3ee:	02b77363          	bgeu	a4,a1,414 <vsnprintf+0x212>
    out[pos] = 0;
 3f2:	953a                	add	a0,a0,a4
 3f4:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 3f8:	0007051b          	sext.w	a0,a4
 3fc:	6426                	ld	s0,72(sp)
 3fe:	6486                	ld	s1,64(sp)
 400:	7962                	ld	s2,56(sp)
 402:	79c2                	ld	s3,48(sp)
 404:	7a22                	ld	s4,40(sp)
 406:	7a82                	ld	s5,32(sp)
 408:	6b62                	ld	s6,24(sp)
 40a:	6bc2                	ld	s7,16(sp)
 40c:	6c22                	ld	s8,8(sp)
 40e:	6c82                	ld	s9,0(sp)
 410:	6161                	addi	sp,sp,80
 412:	8082                	ret
  else if (n)
 414:	d1f5                	beqz	a1,3f8 <vsnprintf+0x1f6>
    out[n - 1] = 0;
 416:	95aa                	add	a1,a1,a0
 418:	fe058fa3          	sb	zero,-1(a1)
 41c:	bff1                	j	3f8 <vsnprintf+0x1f6>
  size_t pos = 0;
 41e:	4701                	li	a4,0
  if (pos < n)
 420:	00b77863          	bgeu	a4,a1,430 <vsnprintf+0x22e>
    out[pos] = 0;
 424:	953a                	add	a0,a0,a4
 426:	00050023          	sb	zero,0(a0)
}
 42a:	0007051b          	sext.w	a0,a4
 42e:	8082                	ret
  else if (n)
 430:	dded                	beqz	a1,42a <vsnprintf+0x228>
    out[n - 1] = 0;
 432:	95aa                	add	a1,a1,a0
 434:	fe058fa3          	sb	zero,-1(a1)
 438:	bfcd                	j	42a <vsnprintf+0x228>

000000000000043a <printf>:
int printf(char*s, ...){
 43a:	710d                	addi	sp,sp,-352
 43c:	ee06                	sd	ra,280(sp)
 43e:	ea22                	sd	s0,272(sp)
 440:	1200                	addi	s0,sp,288
 442:	e40c                	sd	a1,8(s0)
 444:	e810                	sd	a2,16(s0)
 446:	ec14                	sd	a3,24(s0)
 448:	f018                	sd	a4,32(s0)
 44a:	f41c                	sd	a5,40(s0)
 44c:	03043823          	sd	a6,48(s0)
 450:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 454:	00840693          	addi	a3,s0,8
 458:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 45c:	862a                	mv	a2,a0
 45e:	10000593          	li	a1,256
 462:	ee840513          	addi	a0,s0,-280
 466:	00000097          	auipc	ra,0x0
 46a:	d9c080e7          	jalr	-612(ra) # 202 <vsnprintf>
 46e:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 470:	0005071b          	sext.w	a4,a0
 474:	0ff00793          	li	a5,255
 478:	00e7f463          	bgeu	a5,a4,480 <printf+0x46>
 47c:	10000593          	li	a1,256
    return simple_write(buf, n);
 480:	ee840513          	addi	a0,s0,-280
 484:	00000097          	auipc	ra,0x0
 488:	d34080e7          	jalr	-716(ra) # 1b8 <simple_write>
}
 48c:	2501                	sext.w	a0,a0
 48e:	60f2                	ld	ra,280(sp)
 490:	6452                	ld	s0,272(sp)
 492:	6135                	addi	sp,sp,352
 494:	8082                	ret
