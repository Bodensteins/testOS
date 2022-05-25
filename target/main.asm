
target/main：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "stdio.h"
#include "user_syscall.h"

char str[256];

int main(int argc, char *argv[]){
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	8a2e                	mv	s4,a1
    printf("main begin!\n");
  14:	00000517          	auipc	a0,0x0
  18:	71450513          	addi	a0,a0,1812 # 728 <printf+0x5c>
  1c:	00000097          	auipc	ra,0x0
  20:	6b0080e7          	jalr	1712(ra) # 6cc <printf>
    printf("argc: %d\n",argc);
  24:	85ca                	mv	a1,s2
  26:	00000517          	auipc	a0,0x0
  2a:	71250513          	addi	a0,a0,1810 # 738 <printf+0x6c>
  2e:	00000097          	auipc	ra,0x0
  32:	69e080e7          	jalr	1694(ra) # 6cc <printf>
    for(int i=0;i<argc;i++){
  36:	03205263          	blez	s2,5a <main+0x5a>
  3a:	84d2                	mv	s1,s4
  3c:	397d                	addiw	s2,s2,-1
  3e:	1902                	slli	s2,s2,0x20
  40:	02095913          	srli	s2,s2,0x20
  44:	090e                	slli	s2,s2,0x3
  46:	0a21                	addi	s4,s4,8
  48:	9952                	add	s2,s2,s4
        printf(argv[i]);
  4a:	6088                	ld	a0,0(s1)
  4c:	00000097          	auipc	ra,0x0
  50:	680080e7          	jalr	1664(ra) # 6cc <printf>
  54:	04a1                	addi	s1,s1,8
    for(int i=0;i<argc;i++){
  56:	ff249ae3          	bne	s1,s2,4a <main+0x4a>
    }
    printf("pid: %d\n",getpid());
  5a:	00000097          	auipc	ra,0x0
  5e:	3bc080e7          	jalr	956(ra) # 416 <getpid>
  62:	85aa                	mv	a1,a0
  64:	00000517          	auipc	a0,0x0
  68:	6e450513          	addi	a0,a0,1764 # 748 <printf+0x7c>
  6c:	00000097          	auipc	ra,0x0
  70:	660080e7          	jalr	1632(ra) # 6cc <printf>
    printf("ppid: %d\n",getppid());
  74:	00000097          	auipc	ra,0x0
  78:	378080e7          	jalr	888(ra) # 3ec <getppid>
  7c:	85aa                	mv	a1,a0
  7e:	00000517          	auipc	a0,0x0
  82:	6da50513          	addi	a0,a0,1754 # 758 <printf+0x8c>
  86:	00000097          	auipc	ra,0x0
  8a:	646080e7          	jalr	1606(ra) # 6cc <printf>

    printf("\n");
  8e:	00000517          	auipc	a0,0x0
  92:	6b250513          	addi	a0,a0,1714 # 740 <printf+0x74>
  96:	00000097          	auipc	ra,0x0
  9a:	636080e7          	jalr	1590(ra) # 6cc <printf>

    printf("brk test:\n");
  9e:	00000517          	auipc	a0,0x0
  a2:	6ca50513          	addi	a0,a0,1738 # 768 <printf+0x9c>
  a6:	00000097          	auipc	ra,0x0
  aa:	626080e7          	jalr	1574(ra) # 6cc <printf>
    int cur_pos, alloc_pos, alloc_pos_1;
    cur_pos = brk(0);
  ae:	4501                	li	a0,0
  b0:	00000097          	auipc	ra,0x0
  b4:	390080e7          	jalr	912(ra) # 440 <brk>
  b8:	84aa                	mv	s1,a0
    printf("Before alloc,heap pos: %d\n", cur_pos);
  ba:	85aa                	mv	a1,a0
  bc:	00000517          	auipc	a0,0x0
  c0:	6bc50513          	addi	a0,a0,1724 # 778 <printf+0xac>
  c4:	00000097          	auipc	ra,0x0
  c8:	608080e7          	jalr	1544(ra) # 6cc <printf>
    brk(cur_pos + 4096);
  cc:	6505                	lui	a0,0x1
  ce:	9d25                	addw	a0,a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	370080e7          	jalr	880(ra) # 440 <brk>
    alloc_pos = brk(0);
  d8:	4501                	li	a0,0
  da:	00000097          	auipc	ra,0x0
  de:	366080e7          	jalr	870(ra) # 440 <brk>
  e2:	84aa                	mv	s1,a0
    printf("After alloc,heap pos: %d\n",alloc_pos);
  e4:	85aa                	mv	a1,a0
  e6:	00000517          	auipc	a0,0x0
  ea:	6b250513          	addi	a0,a0,1714 # 798 <printf+0xcc>
  ee:	00000097          	auipc	ra,0x0
  f2:	5de080e7          	jalr	1502(ra) # 6cc <printf>

    int *test_ptr=(int*)((alloc_pos-18)-(alloc_pos-18)%16);     //注意，riscv要求任何变量的地址必须16字节对齐！
  f6:	fee4859b          	addiw	a1,s1,-18
  fa:	41f5d79b          	sraiw	a5,a1,0x1f
  fe:	01c7d71b          	srliw	a4,a5,0x1c
 102:	00e587bb          	addw	a5,a1,a4
 106:	8bbd                	andi	a5,a5,15
 108:	9f99                	subw	a5,a5,a4
 10a:	9d9d                	subw	a1,a1,a5
    *test_ptr=2022;
 10c:	7e600793          	li	a5,2022
 110:	c19c                	sw	a5,0(a1)
    printf("in address %p, store integer %d\n", test_ptr, *test_ptr);
 112:	7e600613          	li	a2,2022
 116:	00000517          	auipc	a0,0x0
 11a:	6a250513          	addi	a0,a0,1698 # 7b8 <printf+0xec>
 11e:	00000097          	auipc	ra,0x0
 122:	5ae080e7          	jalr	1454(ra) # 6cc <printf>

    brk(alloc_pos - 4095);
 126:	757d                	lui	a0,0xfffff
 128:	2505                	addiw	a0,a0,1
 12a:	9d25                	addw	a0,a0,s1
 12c:	00000097          	auipc	ra,0x0
 130:	314080e7          	jalr	788(ra) # 440 <brk>
    alloc_pos_1 = brk(0);
 134:	4501                	li	a0,0
 136:	00000097          	auipc	ra,0x0
 13a:	30a080e7          	jalr	778(ra) # 440 <brk>
    printf("Dealloc,heap pos: %d\n",alloc_pos_1);
 13e:	85aa                	mv	a1,a0
 140:	00000517          	auipc	a0,0x0
 144:	6a050513          	addi	a0,a0,1696 # 7e0 <printf+0x114>
 148:	00000097          	auipc	ra,0x0
 14c:	584080e7          	jalr	1412(ra) # 6cc <printf>

    printf("\n");
 150:	00000517          	auipc	a0,0x0
 154:	5f050513          	addi	a0,a0,1520 # 740 <printf+0x74>
 158:	00000097          	auipc	ra,0x0
 15c:	574080e7          	jalr	1396(ra) # 6cc <printf>

    while(1){
        printf("input a string(q to quit): ");
 160:	00000997          	auipc	s3,0x0
 164:	69898993          	addi	s3,s3,1688 # 7f8 <printf+0x12c>
        simple_read(str,256);
 168:	00000497          	auipc	s1,0x0
 16c:	73048493          	addi	s1,s1,1840 # 898 <__DATA_BEGIN__>
        if(str[0]=='q' && str[1]==0)
 170:	07100913          	li	s2,113
            break;
        printf("your string is: %s\n",str);
 174:	00000a17          	auipc	s4,0x0
 178:	6a4a0a13          	addi	s4,s4,1700 # 818 <printf+0x14c>
 17c:	a039                	j	18a <main+0x18a>
 17e:	85a6                	mv	a1,s1
 180:	8552                	mv	a0,s4
 182:	00000097          	auipc	ra,0x0
 186:	54a080e7          	jalr	1354(ra) # 6cc <printf>
        printf("input a string(q to quit): ");
 18a:	854e                	mv	a0,s3
 18c:	00000097          	auipc	ra,0x0
 190:	540080e7          	jalr	1344(ra) # 6cc <printf>
        simple_read(str,256);
 194:	10000593          	li	a1,256
 198:	8526                	mv	a0,s1
 19a:	00000097          	auipc	ra,0x0
 19e:	162080e7          	jalr	354(ra) # 2fc <simple_read>
        if(str[0]=='q' && str[1]==0)
 1a2:	0004c783          	lbu	a5,0(s1)
 1a6:	fd279ce3          	bne	a5,s2,17e <main+0x17e>
 1aa:	0014c783          	lbu	a5,1(s1)
 1ae:	fbe1                	bnez	a5,17e <main+0x17e>
    }

    printf("\n");
 1b0:	00000517          	auipc	a0,0x0
 1b4:	59050513          	addi	a0,a0,1424 # 740 <printf+0x74>
 1b8:	00000097          	auipc	ra,0x0
 1bc:	514080e7          	jalr	1300(ra) # 6cc <printf>

    printf("main end!\n");    
 1c0:	00000517          	auipc	a0,0x0
 1c4:	67050513          	addi	a0,a0,1648 # 830 <printf+0x164>
 1c8:	00000097          	auipc	ra,0x0
 1cc:	504080e7          	jalr	1284(ra) # 6cc <printf>
    exit(22);
 1d0:	4559                	li	a0,22
 1d2:	00000097          	auipc	ra,0x0
 1d6:	1f2080e7          	jalr	498(ra) # 3c4 <exit>
    return 0;
}
 1da:	4501                	li	a0,0
 1dc:	70a2                	ld	ra,40(sp)
 1de:	7402                	ld	s0,32(sp)
 1e0:	64e2                	ld	s1,24(sp)
 1e2:	6942                	ld	s2,16(sp)
 1e4:	69a2                	ld	s3,8(sp)
 1e6:	6a02                	ld	s4,0(sp)
 1e8:	6145                	addi	sp,sp,48
 1ea:	8082                	ret

00000000000001ec <user_syscall>:
/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
 1ec:	715d                	addi	sp,sp,-80
 1ee:	e4a2                	sd	s0,72(sp)
 1f0:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
 1f2:	fea43423          	sd	a0,-24(s0)
 1f6:	feb43023          	sd	a1,-32(s0)
 1fa:	fcc43c23          	sd	a2,-40(s0)
 1fe:	fcd43823          	sd	a3,-48(s0)
 202:	fce43423          	sd	a4,-56(s0)
 206:	fcf43023          	sd	a5,-64(s0)
 20a:	fb043c23          	sd	a6,-72(s0)
 20e:	fb143823          	sd	a7,-80(s0)
        asm volatile(   //将参数写入a0-a7寄存器
 212:	fe843503          	ld	a0,-24(s0)
 216:	fe043583          	ld	a1,-32(s0)
 21a:	fd843603          	ld	a2,-40(s0)
 21e:	fd043683          	ld	a3,-48(s0)
 222:	fc843703          	ld	a4,-56(s0)
 226:	fc043783          	ld	a5,-64(s0)
 22a:	fb843803          	ld	a6,-72(s0)
 22e:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(   //调用ecall
 232:	00000073          	ecall
 236:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
 23a:	fe843503          	ld	a0,-24(s0)
 23e:	6426                	ld	s0,72(sp)
 240:	6161                	addi	sp,sp,80
 242:	8082                	ret

0000000000000244 <fork>:

//复制一个新进程
uint64 fork(){
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
 24c:	4885                	li	a7,1
 24e:	4801                	li	a6,0
 250:	4781                	li	a5,0
 252:	4701                	li	a4,0
 254:	4681                	li	a3,0
 256:	4601                	li	a2,0
 258:	4581                	li	a1,0
 25a:	4501                	li	a0,0
 25c:	00000097          	auipc	ra,0x0
 260:	f90080e7          	jalr	-112(ra) # 1ec <user_syscall>
}
 264:	60a2                	ld	ra,8(sp)
 266:	6402                	ld	s0,0(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret

000000000000026c <open>:

//打开文件
uint64 open(char *file_name, int mode){
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
 274:	48bd                	li	a7,15
 276:	4801                	li	a6,0
 278:	4781                	li	a5,0
 27a:	4701                	li	a4,0
 27c:	4681                	li	a3,0
 27e:	4601                	li	a2,0
 280:	00000097          	auipc	ra,0x0
 284:	f6c080e7          	jalr	-148(ra) # 1ec <user_syscall>
}
 288:	60a2                	ld	ra,8(sp)
 28a:	6402                	ld	s0,0(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret

0000000000000290 <read>:

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
 298:	4895                	li	a7,5
 29a:	4801                	li	a6,0
 29c:	4781                	li	a5,0
 29e:	4701                	li	a4,0
 2a0:	4681                	li	a3,0
 2a2:	00000097          	auipc	ra,0x0
 2a6:	f4a080e7          	jalr	-182(ra) # 1ec <user_syscall>
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <kill>:

//根据pid杀死进程
uint64 kill(uint64 pid){
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e406                	sd	ra,8(sp)
 2b6:	e022                	sd	s0,0(sp)
 2b8:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
 2ba:	4899                	li	a7,6
 2bc:	4801                	li	a6,0
 2be:	4781                	li	a5,0
 2c0:	4701                	li	a4,0
 2c2:	4681                	li	a3,0
 2c4:	4601                	li	a2,0
 2c6:	4581                	li	a1,0
 2c8:	00000097          	auipc	ra,0x0
 2cc:	f24080e7          	jalr	-220(ra) # 1ec <user_syscall>
}
 2d0:	60a2                	ld	ra,8(sp)
 2d2:	6402                	ld	s0,0(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret

00000000000002d8 <execve>:

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
 2d8:	1141                	addi	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
 2e0:	0dd00893          	li	a7,221
 2e4:	4801                	li	a6,0
 2e6:	4781                	li	a5,0
 2e8:	4701                	li	a4,0
 2ea:	4681                	li	a3,0
 2ec:	00000097          	auipc	ra,0x0
 2f0:	f00080e7          	jalr	-256(ra) # 1ec <user_syscall>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <simple_read>:

//从键盘输入字符串
uint64 simple_read(char *s, size_t n){
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e406                	sd	ra,8(sp)
 300:	e022                	sd	s0,0(sp)
 302:	0800                	addi	s0,sp,16
    return user_syscall(0,(uint64)s,n,0,0,0,0,SYS_simple_read);
 304:	06300893          	li	a7,99
 308:	4801                	li	a6,0
 30a:	4781                	li	a5,0
 30c:	4701                	li	a4,0
 30e:	4681                	li	a3,0
 310:	862e                	mv	a2,a1
 312:	85aa                	mv	a1,a0
 314:	4501                	li	a0,0
 316:	00000097          	auipc	ra,0x0
 31a:	ed6080e7          	jalr	-298(ra) # 1ec <user_syscall>
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret

0000000000000326 <simple_write>:

//输出字符串到屏幕
uint64 simple_write(char *s, size_t n){
 326:	1141                	addi	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	addi	s0,sp,16
    return user_syscall(1,(uint64)s,n,0,0,0,0,SYS_simple_write);
 32e:	06400893          	li	a7,100
 332:	4801                	li	a6,0
 334:	4781                	li	a5,0
 336:	4701                	li	a4,0
 338:	4681                	li	a3,0
 33a:	862e                	mv	a2,a1
 33c:	85aa                	mv	a1,a0
 33e:	4505                	li	a0,1
 340:	00000097          	auipc	ra,0x0
 344:	eac080e7          	jalr	-340(ra) # 1ec <user_syscall>
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret

0000000000000350 <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
 350:	1141                	addi	sp,sp,-16
 352:	e406                	sd	ra,8(sp)
 354:	e022                	sd	s0,0(sp)
 356:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
 358:	48d5                	li	a7,21
 35a:	4801                	li	a6,0
 35c:	4781                	li	a5,0
 35e:	4701                	li	a4,0
 360:	4681                	li	a3,0
 362:	4601                	li	a2,0
 364:	4581                	li	a1,0
 366:	00000097          	auipc	ra,0x0
 36a:	e86080e7          	jalr	-378(ra) # 1ec <user_syscall>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <clone>:

uint64 clone(uint64 flag, void *stack, size_t sz){
 376:	1141                	addi	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	addi	s0,sp,16
    if(stack!=NULL)
 37e:	c191                	beqz	a1,382 <clone+0xc>
        stack+=sz;
 380:	95b2                	add	a1,a1,a2
    return user_syscall(flag,(uint64)stack,0,0,0,0,0,SYS_clone);
 382:	0dc00893          	li	a7,220
 386:	4801                	li	a6,0
 388:	4781                	li	a5,0
 38a:	4701                	li	a4,0
 38c:	4681                	li	a3,0
 38e:	4601                	li	a2,0
 390:	00000097          	auipc	ra,0x0
 394:	e5c080e7          	jalr	-420(ra) # 1ec <user_syscall>
}
 398:	60a2                	ld	ra,8(sp)
 39a:	6402                	ld	s0,0(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <wait4>:

uint64 wait4(int pid, int *status, uint64 options){
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e406                	sd	ra,8(sp)
 3a4:	e022                	sd	s0,0(sp)
 3a6:	0800                	addi	s0,sp,16
    return user_syscall((uint64)pid,(uint64)status,options,0,0,0,0,SYS_wait4);
 3a8:	10400893          	li	a7,260
 3ac:	4801                	li	a6,0
 3ae:	4781                	li	a5,0
 3b0:	4701                	li	a4,0
 3b2:	4681                	li	a3,0
 3b4:	00000097          	auipc	ra,0x0
 3b8:	e38080e7          	jalr	-456(ra) # 1ec <user_syscall>
}
 3bc:	60a2                	ld	ra,8(sp)
 3be:	6402                	ld	s0,0(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret

00000000000003c4 <exit>:

//进程退出
uint64 exit(int code){
 3c4:	1141                	addi	sp,sp,-16
 3c6:	e406                	sd	ra,8(sp)
 3c8:	e022                	sd	s0,0(sp)
 3ca:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
 3cc:	05d00893          	li	a7,93
 3d0:	4801                	li	a6,0
 3d2:	4781                	li	a5,0
 3d4:	4701                	li	a4,0
 3d6:	4681                	li	a3,0
 3d8:	4601                	li	a2,0
 3da:	4581                	li	a1,0
 3dc:	00000097          	auipc	ra,0x0
 3e0:	e10080e7          	jalr	-496(ra) # 1ec <user_syscall>
}
 3e4:	60a2                	ld	ra,8(sp)
 3e6:	6402                	ld	s0,0(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret

00000000000003ec <getppid>:

//获取父进程pid
uint64 getppid(){
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e406                	sd	ra,8(sp)
 3f0:	e022                	sd	s0,0(sp)
 3f2:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getppid);
 3f4:	0ad00893          	li	a7,173
 3f8:	4801                	li	a6,0
 3fa:	4781                	li	a5,0
 3fc:	4701                	li	a4,0
 3fe:	4681                	li	a3,0
 400:	4601                	li	a2,0
 402:	4581                	li	a1,0
 404:	4501                	li	a0,0
 406:	00000097          	auipc	ra,0x0
 40a:	de6080e7          	jalr	-538(ra) # 1ec <user_syscall>
}
 40e:	60a2                	ld	ra,8(sp)
 410:	6402                	ld	s0,0(sp)
 412:	0141                	addi	sp,sp,16
 414:	8082                	ret

0000000000000416 <getpid>:

//获取当前进程pid
uint64 getpid(){
 416:	1141                	addi	sp,sp,-16
 418:	e406                	sd	ra,8(sp)
 41a:	e022                	sd	s0,0(sp)
 41c:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getpid);
 41e:	0ac00893          	li	a7,172
 422:	4801                	li	a6,0
 424:	4781                	li	a5,0
 426:	4701                	li	a4,0
 428:	4681                	li	a3,0
 42a:	4601                	li	a2,0
 42c:	4581                	li	a1,0
 42e:	4501                	li	a0,0
 430:	00000097          	auipc	ra,0x0
 434:	dbc080e7          	jalr	-580(ra) # 1ec <user_syscall>
}
 438:	60a2                	ld	ra,8(sp)
 43a:	6402                	ld	s0,0(sp)
 43c:	0141                	addi	sp,sp,16
 43e:	8082                	ret

0000000000000440 <brk>:

//改变进程堆内存大小，当addr为0时，返回当前进程大小
int brk(uint64 addr){
 440:	1141                	addi	sp,sp,-16
 442:	e406                	sd	ra,8(sp)
 444:	e022                	sd	s0,0(sp)
 446:	0800                	addi	s0,sp,16
    return (int)user_syscall(addr,0,0,0,0,0,0,SYS_brk);
 448:	0d600893          	li	a7,214
 44c:	4801                	li	a6,0
 44e:	4781                	li	a5,0
 450:	4701                	li	a4,0
 452:	4681                	li	a3,0
 454:	4601                	li	a2,0
 456:	4581                	li	a1,0
 458:	00000097          	auipc	ra,0x0
 45c:	d94080e7          	jalr	-620(ra) # 1ec <user_syscall>
}
 460:	2501                	sext.w	a0,a0
 462:	60a2                	ld	ra,8(sp)
 464:	6402                	ld	s0,0(sp)
 466:	0141                	addi	sp,sp,16
 468:	8082                	ret

000000000000046a <sched_yield>:

//进程放弃cpu
uint64 sched_yield(){
 46a:	1141                	addi	sp,sp,-16
 46c:	e406                	sd	ra,8(sp)
 46e:	e022                	sd	s0,0(sp)
 470:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_sched_yield);
 472:	07c00893          	li	a7,124
 476:	4801                	li	a6,0
 478:	4781                	li	a5,0
 47a:	4701                	li	a4,0
 47c:	4681                	li	a3,0
 47e:	4601                	li	a2,0
 480:	4581                	li	a1,0
 482:	4501                	li	a0,0
 484:	00000097          	auipc	ra,0x0
 488:	d68080e7          	jalr	-664(ra) # 1ec <user_syscall>
 48c:	60a2                	ld	ra,8(sp)
 48e:	6402                	ld	s0,0(sp)
 490:	0141                	addi	sp,sp,16
 492:	8082                	ret

0000000000000494 <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
 494:	00064783          	lbu	a5,0(a2)
 498:	20078c63          	beqz	a5,6b0 <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
 49c:	715d                	addi	sp,sp,-80
 49e:	e4a2                	sd	s0,72(sp)
 4a0:	e0a6                	sd	s1,64(sp)
 4a2:	fc4a                	sd	s2,56(sp)
 4a4:	f84e                	sd	s3,48(sp)
 4a6:	f452                	sd	s4,40(sp)
 4a8:	f056                	sd	s5,32(sp)
 4aa:	ec5a                	sd	s6,24(sp)
 4ac:	e85e                	sd	s7,16(sp)
 4ae:	e462                	sd	s8,8(sp)
 4b0:	e066                	sd	s9,0(sp)
 4b2:	0880                	addi	s0,sp,80
  size_t pos = 0;
 4b4:	4701                	li	a4,0
  int longarg = 0;
 4b6:	4b01                	li	s6,0
  int format = 0;
 4b8:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
 4ba:	02500f93          	li	t6,37
      format = 1;
 4be:	4285                	li	t0,1
      switch (*s) {
 4c0:	4f55                	li	t5,21
 4c2:	00000317          	auipc	t1,0x0
 4c6:	37e30313          	addi	t1,t1,894 # 840 <printf+0x174>
          longarg = 0;
 4ca:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
 4cc:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
 4ce:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 4d2:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 4d4:	58fd                	li	a7,-1
 4d6:	43bd                	li	t2,15
 4d8:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
 4da:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
 4de:	03000493          	li	s1,48
 4e2:	aabd                	j	660 <vsnprintf+0x1cc>
          longarg = 1;
 4e4:	8b56                	mv	s6,s5
 4e6:	aa8d                	j	658 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
 4e8:	00170793          	addi	a5,a4,1
 4ec:	00b7f663          	bgeu	a5,a1,4f8 <vsnprintf+0x64>
 4f0:	00e50ab3          	add	s5,a0,a4
 4f4:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
 4f8:	0709                	addi	a4,a4,2
 4fa:	00b77563          	bgeu	a4,a1,504 <vsnprintf+0x70>
 4fe:	97aa                	add	a5,a5,a0
 500:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 504:	0006bc03          	ld	s8,0(a3)
 508:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 50a:	8c9e                	mv	s9,t2
 50c:	8b66                	mv	s6,s9
 50e:	8aba                	mv	s5,a4
 510:	a839                	j	52e <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 512:	fe0b19e3          	bnez	s6,504 <vsnprintf+0x70>
 516:	0006ac03          	lw	s8,0(a3)
 51a:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 51c:	8cce                	mv	s9,s3
 51e:	b7fd                	j	50c <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 520:	015507b3          	add	a5,a0,s5
 524:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
 528:	3b7d                	addiw	s6,s6,-1
 52a:	031b0163          	beq	s6,a7,54c <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 52e:	0a85                	addi	s5,s5,1
 530:	febafce3          	bgeu	s5,a1,528 <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
 534:	002b179b          	slliw	a5,s6,0x2
 538:	40fc57b3          	sra	a5,s8,a5
 53c:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
 53e:	05778b93          	addi	s7,a5,87
 542:	fcfecfe3          	blt	t4,a5,520 <vsnprintf+0x8c>
 546:	03078b93          	addi	s7,a5,48
 54a:	bfd9                	j	520 <vsnprintf+0x8c>
 54c:	0705                	addi	a4,a4,1
 54e:	9766                	add	a4,a4,s9
          longarg = 0;
 550:	8b72                	mv	s6,t3
          format = 0;
 552:	8af2                	mv	s5,t3
 554:	a211                	j	658 <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 556:	020b0663          	beqz	s6,582 <vsnprintf+0xee>
 55a:	0006ba83          	ld	s5,0(a3)
 55e:	06a1                	addi	a3,a3,8
          if (num < 0) {
 560:	020ac563          	bltz	s5,58a <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
 564:	030ac7b3          	div	a5,s5,a6
 568:	cf95                	beqz	a5,5a4 <vsnprintf+0x110>
          long digits = 1;
 56a:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
 56c:	0b05                	addi	s6,s6,1
 56e:	0307c7b3          	div	a5,a5,a6
 572:	ffed                	bnez	a5,56c <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
 574:	fffb079b          	addiw	a5,s6,-1
 578:	0407ce63          	bltz	a5,5d4 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 57c:	00170c93          	addi	s9,a4,1
 580:	a825                	j	5b8 <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
 582:	0006aa83          	lw	s5,0(a3)
 586:	06a1                	addi	a3,a3,8
 588:	bfe1                	j	560 <vsnprintf+0xcc>
            num = -num;
 58a:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
 58e:	00170793          	addi	a5,a4,1
 592:	00b7f763          	bgeu	a5,a1,5a0 <vsnprintf+0x10c>
 596:	972a                	add	a4,a4,a0
 598:	01470023          	sb	s4,0(a4)
 59c:	873e                	mv	a4,a5
 59e:	b7d9                	j	564 <vsnprintf+0xd0>
 5a0:	873e                	mv	a4,a5
 5a2:	b7c9                	j	564 <vsnprintf+0xd0>
          long digits = 1;
 5a4:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
 5a6:	87f2                	mv	a5,t3
 5a8:	bfd1                	j	57c <vsnprintf+0xe8>
            num /= 10;
 5aa:	030acab3          	div	s5,s5,a6
 5ae:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
 5b0:	02079b93          	slli	s7,a5,0x20
 5b4:	020bc063          	bltz	s7,5d4 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
 5b8:	00fc8bb3          	add	s7,s9,a5
 5bc:	febbf7e3          	bgeu	s7,a1,5aa <vsnprintf+0x116>
 5c0:	00f70bb3          	add	s7,a4,a5
 5c4:	9baa                	add	s7,s7,a0
 5c6:	030aec33          	rem	s8,s5,a6
 5ca:	030c0c1b          	addiw	s8,s8,48
 5ce:	018b8023          	sb	s8,0(s7)
 5d2:	bfe1                	j	5aa <vsnprintf+0x116>
          pos += digits;
 5d4:	975a                	add	a4,a4,s6
          longarg = 0;
 5d6:	8b72                	mv	s6,t3
          format = 0;
 5d8:	8af2                	mv	s5,t3
          break;
 5da:	a8bd                	j	658 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 5dc:	00868b93          	addi	s7,a3,8
 5e0:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
 5e4:	000ac683          	lbu	a3,0(s5)
 5e8:	ceb9                	beqz	a3,646 <vsnprintf+0x1b2>
 5ea:	87ba                	mv	a5,a4
 5ec:	a039                	j	5fa <vsnprintf+0x166>
 5ee:	40e786b3          	sub	a3,a5,a4
 5f2:	96d6                	add	a3,a3,s5
 5f4:	0006c683          	lbu	a3,0(a3)
 5f8:	ca89                	beqz	a3,60a <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
 5fa:	0785                	addi	a5,a5,1
 5fc:	feb7f9e3          	bgeu	a5,a1,5ee <vsnprintf+0x15a>
 600:	00f50b33          	add	s6,a0,a5
 604:	fedb0fa3          	sb	a3,-1(s6)
 608:	b7dd                	j	5ee <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
 60a:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
 60c:	873e                	mv	a4,a5
          longarg = 0;
 60e:	8b72                	mv	s6,t3
          format = 0;
 610:	8af2                	mv	s5,t3
 612:	a099                	j	658 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 614:	00170793          	addi	a5,a4,1
 618:	02b7fb63          	bgeu	a5,a1,64e <vsnprintf+0x1ba>
 61c:	972a                	add	a4,a4,a0
 61e:	0006aa83          	lw	s5,0(a3)
 622:	01570023          	sb	s5,0(a4)
 626:	06a1                	addi	a3,a3,8
 628:	873e                	mv	a4,a5
          longarg = 0;
 62a:	8b72                	mv	s6,t3
          format = 0;
 62c:	8af2                	mv	s5,t3
 62e:	a02d                	j	658 <vsnprintf+0x1c4>
    } else if (*s == '%')
 630:	03f78363          	beq	a5,t6,656 <vsnprintf+0x1c2>
    else if (++pos < n)
 634:	00170b93          	addi	s7,a4,1
 638:	04bbf263          	bgeu	s7,a1,67c <vsnprintf+0x1e8>
      out[pos - 1] = *s;
 63c:	972a                	add	a4,a4,a0
 63e:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
 642:	875e                	mv	a4,s7
 644:	a811                	j	658 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
 646:	86de                	mv	a3,s7
          longarg = 0;
 648:	8b72                	mv	s6,t3
          format = 0;
 64a:	8af2                	mv	s5,t3
 64c:	a031                	j	658 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
 64e:	873e                	mv	a4,a5
          longarg = 0;
 650:	8b72                	mv	s6,t3
          format = 0;
 652:	8af2                	mv	s5,t3
 654:	a011                	j	658 <vsnprintf+0x1c4>
      format = 1;
 656:	8a96                	mv	s5,t0
  for (; *s; s++) {
 658:	0605                	addi	a2,a2,1
 65a:	00064783          	lbu	a5,0(a2)
 65e:	c38d                	beqz	a5,680 <vsnprintf+0x1ec>
    if (format) {
 660:	fc0a88e3          	beqz	s5,630 <vsnprintf+0x19c>
      switch (*s) {
 664:	f9d7879b          	addiw	a5,a5,-99
 668:	0ff7fb93          	andi	s7,a5,255
 66c:	ff7f66e3          	bltu	t5,s7,658 <vsnprintf+0x1c4>
 670:	002b9793          	slli	a5,s7,0x2
 674:	979a                	add	a5,a5,t1
 676:	439c                	lw	a5,0(a5)
 678:	979a                	add	a5,a5,t1
 67a:	8782                	jr	a5
    else if (++pos < n)
 67c:	875e                	mv	a4,s7
 67e:	bfe9                	j	658 <vsnprintf+0x1c4>
  }
  if (pos < n)
 680:	02b77363          	bgeu	a4,a1,6a6 <vsnprintf+0x212>
    out[pos] = 0;
 684:	953a                	add	a0,a0,a4
 686:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
 68a:	0007051b          	sext.w	a0,a4
 68e:	6426                	ld	s0,72(sp)
 690:	6486                	ld	s1,64(sp)
 692:	7962                	ld	s2,56(sp)
 694:	79c2                	ld	s3,48(sp)
 696:	7a22                	ld	s4,40(sp)
 698:	7a82                	ld	s5,32(sp)
 69a:	6b62                	ld	s6,24(sp)
 69c:	6bc2                	ld	s7,16(sp)
 69e:	6c22                	ld	s8,8(sp)
 6a0:	6c82                	ld	s9,0(sp)
 6a2:	6161                	addi	sp,sp,80
 6a4:	8082                	ret
  else if (n)
 6a6:	d1f5                	beqz	a1,68a <vsnprintf+0x1f6>
    out[n - 1] = 0;
 6a8:	95aa                	add	a1,a1,a0
 6aa:	fe058fa3          	sb	zero,-1(a1)
 6ae:	bff1                	j	68a <vsnprintf+0x1f6>
  size_t pos = 0;
 6b0:	4701                	li	a4,0
  if (pos < n)
 6b2:	00b77863          	bgeu	a4,a1,6c2 <vsnprintf+0x22e>
    out[pos] = 0;
 6b6:	953a                	add	a0,a0,a4
 6b8:	00050023          	sb	zero,0(a0)
}
 6bc:	0007051b          	sext.w	a0,a4
 6c0:	8082                	ret
  else if (n)
 6c2:	dded                	beqz	a1,6bc <vsnprintf+0x228>
    out[n - 1] = 0;
 6c4:	95aa                	add	a1,a1,a0
 6c6:	fe058fa3          	sb	zero,-1(a1)
 6ca:	bfcd                	j	6bc <vsnprintf+0x228>

00000000000006cc <printf>:
int printf(char*s, ...){
 6cc:	710d                	addi	sp,sp,-352
 6ce:	ee06                	sd	ra,280(sp)
 6d0:	ea22                	sd	s0,272(sp)
 6d2:	1200                	addi	s0,sp,288
 6d4:	e40c                	sd	a1,8(s0)
 6d6:	e810                	sd	a2,16(s0)
 6d8:	ec14                	sd	a3,24(s0)
 6da:	f018                	sd	a4,32(s0)
 6dc:	f41c                	sd	a5,40(s0)
 6de:	03043823          	sd	a6,48(s0)
 6e2:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
 6e6:	00840693          	addi	a3,s0,8
 6ea:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
 6ee:	862a                	mv	a2,a0
 6f0:	10000593          	li	a1,256
 6f4:	ee840513          	addi	a0,s0,-280
 6f8:	00000097          	auipc	ra,0x0
 6fc:	d9c080e7          	jalr	-612(ra) # 494 <vsnprintf>
 700:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
 702:	0005071b          	sext.w	a4,a0
 706:	0ff00793          	li	a5,255
 70a:	00e7f463          	bgeu	a5,a4,712 <printf+0x46>
 70e:	10000593          	li	a1,256
    return simple_write(buf, n);
 712:	ee840513          	addi	a0,s0,-280
 716:	00000097          	auipc	ra,0x0
 71a:	c10080e7          	jalr	-1008(ra) # 326 <simple_write>
}
 71e:	2501                	sext.w	a0,a0
 720:	60f2                	ld	ra,280(sp)
 722:	6452                	ld	s0,272(sp)
 724:	6135                	addi	sp,sp,352
 726:	8082                	ret
