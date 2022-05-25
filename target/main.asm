
target/main：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "stdio.h"
#include "user_syscall.h"

char str[256];

int main(int argc, char *argv[]){
    1000:	7179                	addi	sp,sp,-48
    1002:	f406                	sd	ra,40(sp)
    1004:	f022                	sd	s0,32(sp)
    1006:	ec26                	sd	s1,24(sp)
    1008:	e84a                	sd	s2,16(sp)
    100a:	e44e                	sd	s3,8(sp)
    100c:	e052                	sd	s4,0(sp)
    100e:	1800                	addi	s0,sp,48
    1010:	892a                	mv	s2,a0
    1012:	8a2e                	mv	s4,a1
    printf("main begin!\n");
    1014:	00000517          	auipc	a0,0x0
    1018:	71450513          	addi	a0,a0,1812 # 1728 <printf+0x5c>
    101c:	00000097          	auipc	ra,0x0
    1020:	6b0080e7          	jalr	1712(ra) # 16cc <printf>
    printf("argc: %d\n",argc);
    1024:	85ca                	mv	a1,s2
    1026:	00000517          	auipc	a0,0x0
    102a:	71250513          	addi	a0,a0,1810 # 1738 <printf+0x6c>
    102e:	00000097          	auipc	ra,0x0
    1032:	69e080e7          	jalr	1694(ra) # 16cc <printf>
    for(int i=0;i<argc;i++){
    1036:	03205263          	blez	s2,105a <main+0x5a>
    103a:	84d2                	mv	s1,s4
    103c:	397d                	addiw	s2,s2,-1
    103e:	1902                	slli	s2,s2,0x20
    1040:	02095913          	srli	s2,s2,0x20
    1044:	090e                	slli	s2,s2,0x3
    1046:	0a21                	addi	s4,s4,8
    1048:	9952                	add	s2,s2,s4
        printf(argv[i]);
    104a:	6088                	ld	a0,0(s1)
    104c:	00000097          	auipc	ra,0x0
    1050:	680080e7          	jalr	1664(ra) # 16cc <printf>
    1054:	04a1                	addi	s1,s1,8
    for(int i=0;i<argc;i++){
    1056:	ff249ae3          	bne	s1,s2,104a <main+0x4a>
    }
    printf("pid: %d\n",getpid());
    105a:	00000097          	auipc	ra,0x0
    105e:	3bc080e7          	jalr	956(ra) # 1416 <getpid>
    1062:	85aa                	mv	a1,a0
    1064:	00000517          	auipc	a0,0x0
    1068:	6e450513          	addi	a0,a0,1764 # 1748 <printf+0x7c>
    106c:	00000097          	auipc	ra,0x0
    1070:	660080e7          	jalr	1632(ra) # 16cc <printf>
    printf("ppid: %d\n",getppid());
    1074:	00000097          	auipc	ra,0x0
    1078:	378080e7          	jalr	888(ra) # 13ec <getppid>
    107c:	85aa                	mv	a1,a0
    107e:	00000517          	auipc	a0,0x0
    1082:	6da50513          	addi	a0,a0,1754 # 1758 <printf+0x8c>
    1086:	00000097          	auipc	ra,0x0
    108a:	646080e7          	jalr	1606(ra) # 16cc <printf>

    printf("\n");
    108e:	00000517          	auipc	a0,0x0
    1092:	6b250513          	addi	a0,a0,1714 # 1740 <printf+0x74>
    1096:	00000097          	auipc	ra,0x0
    109a:	636080e7          	jalr	1590(ra) # 16cc <printf>

    printf("brk test:\n");
    109e:	00000517          	auipc	a0,0x0
    10a2:	6ca50513          	addi	a0,a0,1738 # 1768 <printf+0x9c>
    10a6:	00000097          	auipc	ra,0x0
    10aa:	626080e7          	jalr	1574(ra) # 16cc <printf>
    int cur_pos, alloc_pos, alloc_pos_1;
    cur_pos = brk(0);
    10ae:	4501                	li	a0,0
    10b0:	00000097          	auipc	ra,0x0
    10b4:	390080e7          	jalr	912(ra) # 1440 <brk>
    10b8:	84aa                	mv	s1,a0
    printf("Before alloc,heap pos: %d\n", cur_pos);
    10ba:	85aa                	mv	a1,a0
    10bc:	00000517          	auipc	a0,0x0
    10c0:	6bc50513          	addi	a0,a0,1724 # 1778 <printf+0xac>
    10c4:	00000097          	auipc	ra,0x0
    10c8:	608080e7          	jalr	1544(ra) # 16cc <printf>
    brk(cur_pos + 4096);
    10cc:	6505                	lui	a0,0x1
    10ce:	9d25                	addw	a0,a0,s1
    10d0:	00000097          	auipc	ra,0x0
    10d4:	370080e7          	jalr	880(ra) # 1440 <brk>
    alloc_pos = brk(0);
    10d8:	4501                	li	a0,0
    10da:	00000097          	auipc	ra,0x0
    10de:	366080e7          	jalr	870(ra) # 1440 <brk>
    10e2:	84aa                	mv	s1,a0
    printf("After alloc,heap pos: %d\n",alloc_pos);
    10e4:	85aa                	mv	a1,a0
    10e6:	00000517          	auipc	a0,0x0
    10ea:	6b250513          	addi	a0,a0,1714 # 1798 <printf+0xcc>
    10ee:	00000097          	auipc	ra,0x0
    10f2:	5de080e7          	jalr	1502(ra) # 16cc <printf>

    int *test_ptr=(int*)((alloc_pos-18)-(alloc_pos-18)%16);     //注意，riscv要求任何变量的地址必须16字节对齐！
    10f6:	fee4859b          	addiw	a1,s1,-18
    10fa:	41f5d79b          	sraiw	a5,a1,0x1f
    10fe:	01c7d71b          	srliw	a4,a5,0x1c
    1102:	00e587bb          	addw	a5,a1,a4
    1106:	8bbd                	andi	a5,a5,15
    1108:	9f99                	subw	a5,a5,a4
    110a:	9d9d                	subw	a1,a1,a5
    *test_ptr=2022;
    110c:	7e600793          	li	a5,2022
    1110:	c19c                	sw	a5,0(a1)
    printf("in address %p, store integer %d\n", test_ptr, *test_ptr);
    1112:	7e600613          	li	a2,2022
    1116:	00000517          	auipc	a0,0x0
    111a:	6a250513          	addi	a0,a0,1698 # 17b8 <printf+0xec>
    111e:	00000097          	auipc	ra,0x0
    1122:	5ae080e7          	jalr	1454(ra) # 16cc <printf>

    brk(alloc_pos - 4095);
    1126:	757d                	lui	a0,0xfffff
    1128:	2505                	addiw	a0,a0,1
    112a:	9d25                	addw	a0,a0,s1
    112c:	00000097          	auipc	ra,0x0
    1130:	314080e7          	jalr	788(ra) # 1440 <brk>
    alloc_pos_1 = brk(0);
    1134:	4501                	li	a0,0
    1136:	00000097          	auipc	ra,0x0
    113a:	30a080e7          	jalr	778(ra) # 1440 <brk>
    printf("Dealloc,heap pos: %d\n",alloc_pos_1);
    113e:	85aa                	mv	a1,a0
    1140:	00000517          	auipc	a0,0x0
    1144:	6a050513          	addi	a0,a0,1696 # 17e0 <printf+0x114>
    1148:	00000097          	auipc	ra,0x0
    114c:	584080e7          	jalr	1412(ra) # 16cc <printf>

    printf("\n");
    1150:	00000517          	auipc	a0,0x0
    1154:	5f050513          	addi	a0,a0,1520 # 1740 <printf+0x74>
    1158:	00000097          	auipc	ra,0x0
    115c:	574080e7          	jalr	1396(ra) # 16cc <printf>

    while(1){
        printf("input a string(q to quit): ");
    1160:	00000997          	auipc	s3,0x0
    1164:	69898993          	addi	s3,s3,1688 # 17f8 <printf+0x12c>
        simple_read(str,256);
    1168:	00000497          	auipc	s1,0x0
    116c:	73048493          	addi	s1,s1,1840 # 1898 <__DATA_BEGIN__>
        if(str[0]=='q' && str[1]==0)
    1170:	07100913          	li	s2,113
            break;
        printf("your string is: %s\n",str);
    1174:	00000a17          	auipc	s4,0x0
    1178:	6a4a0a13          	addi	s4,s4,1700 # 1818 <printf+0x14c>
    117c:	a039                	j	118a <main+0x18a>
    117e:	85a6                	mv	a1,s1
    1180:	8552                	mv	a0,s4
    1182:	00000097          	auipc	ra,0x0
    1186:	54a080e7          	jalr	1354(ra) # 16cc <printf>
        printf("input a string(q to quit): ");
    118a:	854e                	mv	a0,s3
    118c:	00000097          	auipc	ra,0x0
    1190:	540080e7          	jalr	1344(ra) # 16cc <printf>
        simple_read(str,256);
    1194:	10000593          	li	a1,256
    1198:	8526                	mv	a0,s1
    119a:	00000097          	auipc	ra,0x0
    119e:	162080e7          	jalr	354(ra) # 12fc <simple_read>
        if(str[0]=='q' && str[1]==0)
    11a2:	0004c783          	lbu	a5,0(s1)
    11a6:	fd279ce3          	bne	a5,s2,117e <main+0x17e>
    11aa:	0014c783          	lbu	a5,1(s1)
    11ae:	fbe1                	bnez	a5,117e <main+0x17e>
    }

    printf("\n");
    11b0:	00000517          	auipc	a0,0x0
    11b4:	59050513          	addi	a0,a0,1424 # 1740 <printf+0x74>
    11b8:	00000097          	auipc	ra,0x0
    11bc:	514080e7          	jalr	1300(ra) # 16cc <printf>

    printf("main end!\n");    
    11c0:	00000517          	auipc	a0,0x0
    11c4:	67050513          	addi	a0,a0,1648 # 1830 <printf+0x164>
    11c8:	00000097          	auipc	ra,0x0
    11cc:	504080e7          	jalr	1284(ra) # 16cc <printf>
    exit(22);
    11d0:	4559                	li	a0,22
    11d2:	00000097          	auipc	ra,0x0
    11d6:	1f2080e7          	jalr	498(ra) # 13c4 <exit>
    return 0;
}
    11da:	4501                	li	a0,0
    11dc:	70a2                	ld	ra,40(sp)
    11de:	7402                	ld	s0,32(sp)
    11e0:	64e2                	ld	s1,24(sp)
    11e2:	6942                	ld	s2,16(sp)
    11e4:	69a2                	ld	s3,8(sp)
    11e6:	6a02                	ld	s4,0(sp)
    11e8:	6145                	addi	sp,sp,48
    11ea:	8082                	ret

00000000000011ec <user_syscall>:
/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
    11ec:	715d                	addi	sp,sp,-80
    11ee:	e4a2                	sd	s0,72(sp)
    11f0:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
    11f2:	fea43423          	sd	a0,-24(s0)
    11f6:	feb43023          	sd	a1,-32(s0)
    11fa:	fcc43c23          	sd	a2,-40(s0)
    11fe:	fcd43823          	sd	a3,-48(s0)
    1202:	fce43423          	sd	a4,-56(s0)
    1206:	fcf43023          	sd	a5,-64(s0)
    120a:	fb043c23          	sd	a6,-72(s0)
    120e:	fb143823          	sd	a7,-80(s0)
        asm volatile(   //将参数写入a0-a7寄存器
    1212:	fe843503          	ld	a0,-24(s0)
    1216:	fe043583          	ld	a1,-32(s0)
    121a:	fd843603          	ld	a2,-40(s0)
    121e:	fd043683          	ld	a3,-48(s0)
    1222:	fc843703          	ld	a4,-56(s0)
    1226:	fc043783          	ld	a5,-64(s0)
    122a:	fb843803          	ld	a6,-72(s0)
    122e:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(   //调用ecall
    1232:	00000073          	ecall
    1236:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
    123a:	fe843503          	ld	a0,-24(s0)
    123e:	6426                	ld	s0,72(sp)
    1240:	6161                	addi	sp,sp,80
    1242:	8082                	ret

0000000000001244 <fork>:

//复制一个新进程
uint64 fork(){
    1244:	1141                	addi	sp,sp,-16
    1246:	e406                	sd	ra,8(sp)
    1248:	e022                	sd	s0,0(sp)
    124a:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
    124c:	4885                	li	a7,1
    124e:	4801                	li	a6,0
    1250:	4781                	li	a5,0
    1252:	4701                	li	a4,0
    1254:	4681                	li	a3,0
    1256:	4601                	li	a2,0
    1258:	4581                	li	a1,0
    125a:	4501                	li	a0,0
    125c:	00000097          	auipc	ra,0x0
    1260:	f90080e7          	jalr	-112(ra) # 11ec <user_syscall>
}
    1264:	60a2                	ld	ra,8(sp)
    1266:	6402                	ld	s0,0(sp)
    1268:	0141                	addi	sp,sp,16
    126a:	8082                	ret

000000000000126c <open>:

//打开文件
uint64 open(char *file_name, int mode){
    126c:	1141                	addi	sp,sp,-16
    126e:	e406                	sd	ra,8(sp)
    1270:	e022                	sd	s0,0(sp)
    1272:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
    1274:	48bd                	li	a7,15
    1276:	4801                	li	a6,0
    1278:	4781                	li	a5,0
    127a:	4701                	li	a4,0
    127c:	4681                	li	a3,0
    127e:	4601                	li	a2,0
    1280:	00000097          	auipc	ra,0x0
    1284:	f6c080e7          	jalr	-148(ra) # 11ec <user_syscall>
}
    1288:	60a2                	ld	ra,8(sp)
    128a:	6402                	ld	s0,0(sp)
    128c:	0141                	addi	sp,sp,16
    128e:	8082                	ret

0000000000001290 <read>:

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
    1290:	1141                	addi	sp,sp,-16
    1292:	e406                	sd	ra,8(sp)
    1294:	e022                	sd	s0,0(sp)
    1296:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
    1298:	4895                	li	a7,5
    129a:	4801                	li	a6,0
    129c:	4781                	li	a5,0
    129e:	4701                	li	a4,0
    12a0:	4681                	li	a3,0
    12a2:	00000097          	auipc	ra,0x0
    12a6:	f4a080e7          	jalr	-182(ra) # 11ec <user_syscall>
}
    12aa:	60a2                	ld	ra,8(sp)
    12ac:	6402                	ld	s0,0(sp)
    12ae:	0141                	addi	sp,sp,16
    12b0:	8082                	ret

00000000000012b2 <kill>:

//根据pid杀死进程
uint64 kill(uint64 pid){
    12b2:	1141                	addi	sp,sp,-16
    12b4:	e406                	sd	ra,8(sp)
    12b6:	e022                	sd	s0,0(sp)
    12b8:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
    12ba:	4899                	li	a7,6
    12bc:	4801                	li	a6,0
    12be:	4781                	li	a5,0
    12c0:	4701                	li	a4,0
    12c2:	4681                	li	a3,0
    12c4:	4601                	li	a2,0
    12c6:	4581                	li	a1,0
    12c8:	00000097          	auipc	ra,0x0
    12cc:	f24080e7          	jalr	-220(ra) # 11ec <user_syscall>
}
    12d0:	60a2                	ld	ra,8(sp)
    12d2:	6402                	ld	s0,0(sp)
    12d4:	0141                	addi	sp,sp,16
    12d6:	8082                	ret

00000000000012d8 <execve>:

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
    12d8:	1141                	addi	sp,sp,-16
    12da:	e406                	sd	ra,8(sp)
    12dc:	e022                	sd	s0,0(sp)
    12de:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
    12e0:	0dd00893          	li	a7,221
    12e4:	4801                	li	a6,0
    12e6:	4781                	li	a5,0
    12e8:	4701                	li	a4,0
    12ea:	4681                	li	a3,0
    12ec:	00000097          	auipc	ra,0x0
    12f0:	f00080e7          	jalr	-256(ra) # 11ec <user_syscall>
}
    12f4:	60a2                	ld	ra,8(sp)
    12f6:	6402                	ld	s0,0(sp)
    12f8:	0141                	addi	sp,sp,16
    12fa:	8082                	ret

00000000000012fc <simple_read>:

//从键盘输入字符串
uint64 simple_read(char *s, size_t n){
    12fc:	1141                	addi	sp,sp,-16
    12fe:	e406                	sd	ra,8(sp)
    1300:	e022                	sd	s0,0(sp)
    1302:	0800                	addi	s0,sp,16
    return user_syscall(0,(uint64)s,n,0,0,0,0,SYS_simple_read);
    1304:	06300893          	li	a7,99
    1308:	4801                	li	a6,0
    130a:	4781                	li	a5,0
    130c:	4701                	li	a4,0
    130e:	4681                	li	a3,0
    1310:	862e                	mv	a2,a1
    1312:	85aa                	mv	a1,a0
    1314:	4501                	li	a0,0
    1316:	00000097          	auipc	ra,0x0
    131a:	ed6080e7          	jalr	-298(ra) # 11ec <user_syscall>
}
    131e:	60a2                	ld	ra,8(sp)
    1320:	6402                	ld	s0,0(sp)
    1322:	0141                	addi	sp,sp,16
    1324:	8082                	ret

0000000000001326 <simple_write>:

//输出字符串到屏幕
uint64 simple_write(char *s, size_t n){
    1326:	1141                	addi	sp,sp,-16
    1328:	e406                	sd	ra,8(sp)
    132a:	e022                	sd	s0,0(sp)
    132c:	0800                	addi	s0,sp,16
    return user_syscall(1,(uint64)s,n,0,0,0,0,SYS_simple_write);
    132e:	06400893          	li	a7,100
    1332:	4801                	li	a6,0
    1334:	4781                	li	a5,0
    1336:	4701                	li	a4,0
    1338:	4681                	li	a3,0
    133a:	862e                	mv	a2,a1
    133c:	85aa                	mv	a1,a0
    133e:	4505                	li	a0,1
    1340:	00000097          	auipc	ra,0x0
    1344:	eac080e7          	jalr	-340(ra) # 11ec <user_syscall>
}
    1348:	60a2                	ld	ra,8(sp)
    134a:	6402                	ld	s0,0(sp)
    134c:	0141                	addi	sp,sp,16
    134e:	8082                	ret

0000000000001350 <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
    1350:	1141                	addi	sp,sp,-16
    1352:	e406                	sd	ra,8(sp)
    1354:	e022                	sd	s0,0(sp)
    1356:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
    1358:	48d5                	li	a7,21
    135a:	4801                	li	a6,0
    135c:	4781                	li	a5,0
    135e:	4701                	li	a4,0
    1360:	4681                	li	a3,0
    1362:	4601                	li	a2,0
    1364:	4581                	li	a1,0
    1366:	00000097          	auipc	ra,0x0
    136a:	e86080e7          	jalr	-378(ra) # 11ec <user_syscall>
}
    136e:	60a2                	ld	ra,8(sp)
    1370:	6402                	ld	s0,0(sp)
    1372:	0141                	addi	sp,sp,16
    1374:	8082                	ret

0000000000001376 <clone>:

uint64 clone(uint64 flag, void *stack, size_t sz){
    1376:	1141                	addi	sp,sp,-16
    1378:	e406                	sd	ra,8(sp)
    137a:	e022                	sd	s0,0(sp)
    137c:	0800                	addi	s0,sp,16
    if(stack!=NULL)
    137e:	c191                	beqz	a1,1382 <clone+0xc>
        stack+=sz;
    1380:	95b2                	add	a1,a1,a2
    return user_syscall(flag,(uint64)stack,0,0,0,0,0,SYS_clone);
    1382:	0dc00893          	li	a7,220
    1386:	4801                	li	a6,0
    1388:	4781                	li	a5,0
    138a:	4701                	li	a4,0
    138c:	4681                	li	a3,0
    138e:	4601                	li	a2,0
    1390:	00000097          	auipc	ra,0x0
    1394:	e5c080e7          	jalr	-420(ra) # 11ec <user_syscall>
}
    1398:	60a2                	ld	ra,8(sp)
    139a:	6402                	ld	s0,0(sp)
    139c:	0141                	addi	sp,sp,16
    139e:	8082                	ret

00000000000013a0 <wait4>:

uint64 wait4(int pid, int *status, uint64 options){
    13a0:	1141                	addi	sp,sp,-16
    13a2:	e406                	sd	ra,8(sp)
    13a4:	e022                	sd	s0,0(sp)
    13a6:	0800                	addi	s0,sp,16
    return user_syscall((uint64)pid,(uint64)status,options,0,0,0,0,SYS_wait4);
    13a8:	10400893          	li	a7,260
    13ac:	4801                	li	a6,0
    13ae:	4781                	li	a5,0
    13b0:	4701                	li	a4,0
    13b2:	4681                	li	a3,0
    13b4:	00000097          	auipc	ra,0x0
    13b8:	e38080e7          	jalr	-456(ra) # 11ec <user_syscall>
}
    13bc:	60a2                	ld	ra,8(sp)
    13be:	6402                	ld	s0,0(sp)
    13c0:	0141                	addi	sp,sp,16
    13c2:	8082                	ret

00000000000013c4 <exit>:

//进程退出
uint64 exit(int code){
    13c4:	1141                	addi	sp,sp,-16
    13c6:	e406                	sd	ra,8(sp)
    13c8:	e022                	sd	s0,0(sp)
    13ca:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
    13cc:	05d00893          	li	a7,93
    13d0:	4801                	li	a6,0
    13d2:	4781                	li	a5,0
    13d4:	4701                	li	a4,0
    13d6:	4681                	li	a3,0
    13d8:	4601                	li	a2,0
    13da:	4581                	li	a1,0
    13dc:	00000097          	auipc	ra,0x0
    13e0:	e10080e7          	jalr	-496(ra) # 11ec <user_syscall>
}
    13e4:	60a2                	ld	ra,8(sp)
    13e6:	6402                	ld	s0,0(sp)
    13e8:	0141                	addi	sp,sp,16
    13ea:	8082                	ret

00000000000013ec <getppid>:

//获取父进程pid
uint64 getppid(){
    13ec:	1141                	addi	sp,sp,-16
    13ee:	e406                	sd	ra,8(sp)
    13f0:	e022                	sd	s0,0(sp)
    13f2:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getppid);
    13f4:	0ad00893          	li	a7,173
    13f8:	4801                	li	a6,0
    13fa:	4781                	li	a5,0
    13fc:	4701                	li	a4,0
    13fe:	4681                	li	a3,0
    1400:	4601                	li	a2,0
    1402:	4581                	li	a1,0
    1404:	4501                	li	a0,0
    1406:	00000097          	auipc	ra,0x0
    140a:	de6080e7          	jalr	-538(ra) # 11ec <user_syscall>
}
    140e:	60a2                	ld	ra,8(sp)
    1410:	6402                	ld	s0,0(sp)
    1412:	0141                	addi	sp,sp,16
    1414:	8082                	ret

0000000000001416 <getpid>:

//获取当前进程pid
uint64 getpid(){
    1416:	1141                	addi	sp,sp,-16
    1418:	e406                	sd	ra,8(sp)
    141a:	e022                	sd	s0,0(sp)
    141c:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getpid);
    141e:	0ac00893          	li	a7,172
    1422:	4801                	li	a6,0
    1424:	4781                	li	a5,0
    1426:	4701                	li	a4,0
    1428:	4681                	li	a3,0
    142a:	4601                	li	a2,0
    142c:	4581                	li	a1,0
    142e:	4501                	li	a0,0
    1430:	00000097          	auipc	ra,0x0
    1434:	dbc080e7          	jalr	-580(ra) # 11ec <user_syscall>
}
    1438:	60a2                	ld	ra,8(sp)
    143a:	6402                	ld	s0,0(sp)
    143c:	0141                	addi	sp,sp,16
    143e:	8082                	ret

0000000000001440 <brk>:

//改变进程堆内存大小，当addr为0时，返回当前进程大小
int brk(uint64 addr){
    1440:	1141                	addi	sp,sp,-16
    1442:	e406                	sd	ra,8(sp)
    1444:	e022                	sd	s0,0(sp)
    1446:	0800                	addi	s0,sp,16
    return (int)user_syscall(addr,0,0,0,0,0,0,SYS_brk);
    1448:	0d600893          	li	a7,214
    144c:	4801                	li	a6,0
    144e:	4781                	li	a5,0
    1450:	4701                	li	a4,0
    1452:	4681                	li	a3,0
    1454:	4601                	li	a2,0
    1456:	4581                	li	a1,0
    1458:	00000097          	auipc	ra,0x0
    145c:	d94080e7          	jalr	-620(ra) # 11ec <user_syscall>
}
    1460:	2501                	sext.w	a0,a0
    1462:	60a2                	ld	ra,8(sp)
    1464:	6402                	ld	s0,0(sp)
    1466:	0141                	addi	sp,sp,16
    1468:	8082                	ret

000000000000146a <sched_yield>:

//进程放弃cpu
uint64 sched_yield(){
    146a:	1141                	addi	sp,sp,-16
    146c:	e406                	sd	ra,8(sp)
    146e:	e022                	sd	s0,0(sp)
    1470:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_sched_yield);
    1472:	07c00893          	li	a7,124
    1476:	4801                	li	a6,0
    1478:	4781                	li	a5,0
    147a:	4701                	li	a4,0
    147c:	4681                	li	a3,0
    147e:	4601                	li	a2,0
    1480:	4581                	li	a1,0
    1482:	4501                	li	a0,0
    1484:	00000097          	auipc	ra,0x0
    1488:	d68080e7          	jalr	-664(ra) # 11ec <user_syscall>
    148c:	60a2                	ld	ra,8(sp)
    148e:	6402                	ld	s0,0(sp)
    1490:	0141                	addi	sp,sp,16
    1492:	8082                	ret

0000000000001494 <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
    1494:	00064783          	lbu	a5,0(a2)
    1498:	20078c63          	beqz	a5,16b0 <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
    149c:	715d                	addi	sp,sp,-80
    149e:	e4a2                	sd	s0,72(sp)
    14a0:	e0a6                	sd	s1,64(sp)
    14a2:	fc4a                	sd	s2,56(sp)
    14a4:	f84e                	sd	s3,48(sp)
    14a6:	f452                	sd	s4,40(sp)
    14a8:	f056                	sd	s5,32(sp)
    14aa:	ec5a                	sd	s6,24(sp)
    14ac:	e85e                	sd	s7,16(sp)
    14ae:	e462                	sd	s8,8(sp)
    14b0:	e066                	sd	s9,0(sp)
    14b2:	0880                	addi	s0,sp,80
  size_t pos = 0;
    14b4:	4701                	li	a4,0
  int longarg = 0;
    14b6:	4b01                	li	s6,0
  int format = 0;
    14b8:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
    14ba:	02500f93          	li	t6,37
      format = 1;
    14be:	4285                	li	t0,1
      switch (*s) {
    14c0:	4f55                	li	t5,21
    14c2:	00000317          	auipc	t1,0x0
    14c6:	37e30313          	addi	t1,t1,894 # 1840 <printf+0x174>
          longarg = 0;
    14ca:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
    14cc:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
    14ce:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    14d2:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    14d4:	58fd                	li	a7,-1
    14d6:	43bd                	li	t2,15
    14d8:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
    14da:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
    14de:	03000493          	li	s1,48
    14e2:	aabd                	j	1660 <vsnprintf+0x1cc>
          longarg = 1;
    14e4:	8b56                	mv	s6,s5
    14e6:	aa8d                	j	1658 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
    14e8:	00170793          	addi	a5,a4,1
    14ec:	00b7f663          	bgeu	a5,a1,14f8 <vsnprintf+0x64>
    14f0:	00e50ab3          	add	s5,a0,a4
    14f4:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
    14f8:	0709                	addi	a4,a4,2
    14fa:	00b77563          	bgeu	a4,a1,1504 <vsnprintf+0x70>
    14fe:	97aa                	add	a5,a5,a0
    1500:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1504:	0006bc03          	ld	s8,0(a3)
    1508:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    150a:	8c9e                	mv	s9,t2
    150c:	8b66                	mv	s6,s9
    150e:	8aba                	mv	s5,a4
    1510:	a839                	j	152e <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1512:	fe0b19e3          	bnez	s6,1504 <vsnprintf+0x70>
    1516:	0006ac03          	lw	s8,0(a3)
    151a:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    151c:	8cce                	mv	s9,s3
    151e:	b7fd                	j	150c <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    1520:	015507b3          	add	a5,a0,s5
    1524:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    1528:	3b7d                	addiw	s6,s6,-1
    152a:	031b0163          	beq	s6,a7,154c <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    152e:	0a85                	addi	s5,s5,1
    1530:	febafce3          	bgeu	s5,a1,1528 <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
    1534:	002b179b          	slliw	a5,s6,0x2
    1538:	40fc57b3          	sra	a5,s8,a5
    153c:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    153e:	05778b93          	addi	s7,a5,87
    1542:	fcfecfe3          	blt	t4,a5,1520 <vsnprintf+0x8c>
    1546:	03078b93          	addi	s7,a5,48
    154a:	bfd9                	j	1520 <vsnprintf+0x8c>
    154c:	0705                	addi	a4,a4,1
    154e:	9766                	add	a4,a4,s9
          longarg = 0;
    1550:	8b72                	mv	s6,t3
          format = 0;
    1552:	8af2                	mv	s5,t3
    1554:	a211                	j	1658 <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1556:	020b0663          	beqz	s6,1582 <vsnprintf+0xee>
    155a:	0006ba83          	ld	s5,0(a3)
    155e:	06a1                	addi	a3,a3,8
          if (num < 0) {
    1560:	020ac563          	bltz	s5,158a <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
    1564:	030ac7b3          	div	a5,s5,a6
    1568:	cf95                	beqz	a5,15a4 <vsnprintf+0x110>
          long digits = 1;
    156a:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
    156c:	0b05                	addi	s6,s6,1
    156e:	0307c7b3          	div	a5,a5,a6
    1572:	ffed                	bnez	a5,156c <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
    1574:	fffb079b          	addiw	a5,s6,-1
    1578:	0407ce63          	bltz	a5,15d4 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
    157c:	00170c93          	addi	s9,a4,1
    1580:	a825                	j	15b8 <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1582:	0006aa83          	lw	s5,0(a3)
    1586:	06a1                	addi	a3,a3,8
    1588:	bfe1                	j	1560 <vsnprintf+0xcc>
            num = -num;
    158a:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
    158e:	00170793          	addi	a5,a4,1
    1592:	00b7f763          	bgeu	a5,a1,15a0 <vsnprintf+0x10c>
    1596:	972a                	add	a4,a4,a0
    1598:	01470023          	sb	s4,0(a4)
    159c:	873e                	mv	a4,a5
    159e:	b7d9                	j	1564 <vsnprintf+0xd0>
    15a0:	873e                	mv	a4,a5
    15a2:	b7c9                	j	1564 <vsnprintf+0xd0>
          long digits = 1;
    15a4:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
    15a6:	87f2                	mv	a5,t3
    15a8:	bfd1                	j	157c <vsnprintf+0xe8>
            num /= 10;
    15aa:	030acab3          	div	s5,s5,a6
    15ae:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
    15b0:	02079b93          	slli	s7,a5,0x20
    15b4:	020bc063          	bltz	s7,15d4 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
    15b8:	00fc8bb3          	add	s7,s9,a5
    15bc:	febbf7e3          	bgeu	s7,a1,15aa <vsnprintf+0x116>
    15c0:	00f70bb3          	add	s7,a4,a5
    15c4:	9baa                	add	s7,s7,a0
    15c6:	030aec33          	rem	s8,s5,a6
    15ca:	030c0c1b          	addiw	s8,s8,48
    15ce:	018b8023          	sb	s8,0(s7)
    15d2:	bfe1                	j	15aa <vsnprintf+0x116>
          pos += digits;
    15d4:	975a                	add	a4,a4,s6
          longarg = 0;
    15d6:	8b72                	mv	s6,t3
          format = 0;
    15d8:	8af2                	mv	s5,t3
          break;
    15da:	a8bd                	j	1658 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
    15dc:	00868b93          	addi	s7,a3,8
    15e0:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
    15e4:	000ac683          	lbu	a3,0(s5)
    15e8:	ceb9                	beqz	a3,1646 <vsnprintf+0x1b2>
    15ea:	87ba                	mv	a5,a4
    15ec:	a039                	j	15fa <vsnprintf+0x166>
    15ee:	40e786b3          	sub	a3,a5,a4
    15f2:	96d6                	add	a3,a3,s5
    15f4:	0006c683          	lbu	a3,0(a3)
    15f8:	ca89                	beqz	a3,160a <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
    15fa:	0785                	addi	a5,a5,1
    15fc:	feb7f9e3          	bgeu	a5,a1,15ee <vsnprintf+0x15a>
    1600:	00f50b33          	add	s6,a0,a5
    1604:	fedb0fa3          	sb	a3,-1(s6)
    1608:	b7dd                	j	15ee <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
    160a:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
    160c:	873e                	mv	a4,a5
          longarg = 0;
    160e:	8b72                	mv	s6,t3
          format = 0;
    1610:	8af2                	mv	s5,t3
    1612:	a099                	j	1658 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
    1614:	00170793          	addi	a5,a4,1
    1618:	02b7fb63          	bgeu	a5,a1,164e <vsnprintf+0x1ba>
    161c:	972a                	add	a4,a4,a0
    161e:	0006aa83          	lw	s5,0(a3)
    1622:	01570023          	sb	s5,0(a4)
    1626:	06a1                	addi	a3,a3,8
    1628:	873e                	mv	a4,a5
          longarg = 0;
    162a:	8b72                	mv	s6,t3
          format = 0;
    162c:	8af2                	mv	s5,t3
    162e:	a02d                	j	1658 <vsnprintf+0x1c4>
    } else if (*s == '%')
    1630:	03f78363          	beq	a5,t6,1656 <vsnprintf+0x1c2>
    else if (++pos < n)
    1634:	00170b93          	addi	s7,a4,1
    1638:	04bbf263          	bgeu	s7,a1,167c <vsnprintf+0x1e8>
      out[pos - 1] = *s;
    163c:	972a                	add	a4,a4,a0
    163e:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
    1642:	875e                	mv	a4,s7
    1644:	a811                	j	1658 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
    1646:	86de                	mv	a3,s7
          longarg = 0;
    1648:	8b72                	mv	s6,t3
          format = 0;
    164a:	8af2                	mv	s5,t3
    164c:	a031                	j	1658 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
    164e:	873e                	mv	a4,a5
          longarg = 0;
    1650:	8b72                	mv	s6,t3
          format = 0;
    1652:	8af2                	mv	s5,t3
    1654:	a011                	j	1658 <vsnprintf+0x1c4>
      format = 1;
    1656:	8a96                	mv	s5,t0
  for (; *s; s++) {
    1658:	0605                	addi	a2,a2,1
    165a:	00064783          	lbu	a5,0(a2)
    165e:	c38d                	beqz	a5,1680 <vsnprintf+0x1ec>
    if (format) {
    1660:	fc0a88e3          	beqz	s5,1630 <vsnprintf+0x19c>
      switch (*s) {
    1664:	f9d7879b          	addiw	a5,a5,-99
    1668:	0ff7fb93          	andi	s7,a5,255
    166c:	ff7f66e3          	bltu	t5,s7,1658 <vsnprintf+0x1c4>
    1670:	002b9793          	slli	a5,s7,0x2
    1674:	979a                	add	a5,a5,t1
    1676:	439c                	lw	a5,0(a5)
    1678:	979a                	add	a5,a5,t1
    167a:	8782                	jr	a5
    else if (++pos < n)
    167c:	875e                	mv	a4,s7
    167e:	bfe9                	j	1658 <vsnprintf+0x1c4>
  }
  if (pos < n)
    1680:	02b77363          	bgeu	a4,a1,16a6 <vsnprintf+0x212>
    out[pos] = 0;
    1684:	953a                	add	a0,a0,a4
    1686:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
    168a:	0007051b          	sext.w	a0,a4
    168e:	6426                	ld	s0,72(sp)
    1690:	6486                	ld	s1,64(sp)
    1692:	7962                	ld	s2,56(sp)
    1694:	79c2                	ld	s3,48(sp)
    1696:	7a22                	ld	s4,40(sp)
    1698:	7a82                	ld	s5,32(sp)
    169a:	6b62                	ld	s6,24(sp)
    169c:	6bc2                	ld	s7,16(sp)
    169e:	6c22                	ld	s8,8(sp)
    16a0:	6c82                	ld	s9,0(sp)
    16a2:	6161                	addi	sp,sp,80
    16a4:	8082                	ret
  else if (n)
    16a6:	d1f5                	beqz	a1,168a <vsnprintf+0x1f6>
    out[n - 1] = 0;
    16a8:	95aa                	add	a1,a1,a0
    16aa:	fe058fa3          	sb	zero,-1(a1)
    16ae:	bff1                	j	168a <vsnprintf+0x1f6>
  size_t pos = 0;
    16b0:	4701                	li	a4,0
  if (pos < n)
    16b2:	00b77863          	bgeu	a4,a1,16c2 <vsnprintf+0x22e>
    out[pos] = 0;
    16b6:	953a                	add	a0,a0,a4
    16b8:	00050023          	sb	zero,0(a0)
}
    16bc:	0007051b          	sext.w	a0,a4
    16c0:	8082                	ret
  else if (n)
    16c2:	dded                	beqz	a1,16bc <vsnprintf+0x228>
    out[n - 1] = 0;
    16c4:	95aa                	add	a1,a1,a0
    16c6:	fe058fa3          	sb	zero,-1(a1)
    16ca:	bfcd                	j	16bc <vsnprintf+0x228>

00000000000016cc <printf>:
int printf(char*s, ...){
    16cc:	710d                	addi	sp,sp,-352
    16ce:	ee06                	sd	ra,280(sp)
    16d0:	ea22                	sd	s0,272(sp)
    16d2:	1200                	addi	s0,sp,288
    16d4:	e40c                	sd	a1,8(s0)
    16d6:	e810                	sd	a2,16(s0)
    16d8:	ec14                	sd	a3,24(s0)
    16da:	f018                	sd	a4,32(s0)
    16dc:	f41c                	sd	a5,40(s0)
    16de:	03043823          	sd	a6,48(s0)
    16e2:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
    16e6:	00840693          	addi	a3,s0,8
    16ea:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
    16ee:	862a                	mv	a2,a0
    16f0:	10000593          	li	a1,256
    16f4:	ee840513          	addi	a0,s0,-280
    16f8:	00000097          	auipc	ra,0x0
    16fc:	d9c080e7          	jalr	-612(ra) # 1494 <vsnprintf>
    1700:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
    1702:	0005071b          	sext.w	a4,a0
    1706:	0ff00793          	li	a5,255
    170a:	00e7f463          	bgeu	a5,a4,1712 <printf+0x46>
    170e:	10000593          	li	a1,256
    return simple_write(buf, n);
    1712:	ee840513          	addi	a0,s0,-280
    1716:	00000097          	auipc	ra,0x0
    171a:	c10080e7          	jalr	-1008(ra) # 1326 <simple_write>
}
    171e:	2501                	sext.w	a0,a0
    1720:	60f2                	ld	ra,280(sp)
    1722:	6452                	ld	s0,272(sp)
    1724:	6135                	addi	sp,sp,352
    1726:	8082                	ret
