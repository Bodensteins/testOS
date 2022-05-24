
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
    1018:	70c50513          	addi	a0,a0,1804 # 1720 <printf+0x5c>
    101c:	00000097          	auipc	ra,0x0
    1020:	6a8080e7          	jalr	1704(ra) # 16c4 <printf>
    printf("argc: %d\n",argc);
    1024:	85ca                	mv	a1,s2
    1026:	00000517          	auipc	a0,0x0
    102a:	70a50513          	addi	a0,a0,1802 # 1730 <printf+0x6c>
    102e:	00000097          	auipc	ra,0x0
    1032:	696080e7          	jalr	1686(ra) # 16c4 <printf>
    for(int i=0;i<argc;i++){
    1036:	03205263          	blez	s2,105a <main+0x5a>
    103a:	84d2                	mv	s1,s4
    103c:	397d                	addiw	s2,s2,-1
    103e:	02091793          	slli	a5,s2,0x20
    1042:	01d7d913          	srli	s2,a5,0x1d
    1046:	0a21                	addi	s4,s4,8
    1048:	9952                	add	s2,s2,s4
        printf(argv[i]);
    104a:	6088                	ld	a0,0(s1)
    104c:	00000097          	auipc	ra,0x0
    1050:	678080e7          	jalr	1656(ra) # 16c4 <printf>
    for(int i=0;i<argc;i++){
    1054:	04a1                	addi	s1,s1,8
    1056:	ff249ae3          	bne	s1,s2,104a <main+0x4a>
    }
    printf("pid: %d\n",getpid());
    105a:	00000097          	auipc	ra,0x0
    105e:	3bc080e7          	jalr	956(ra) # 1416 <getpid>
    1062:	85aa                	mv	a1,a0
    1064:	00000517          	auipc	a0,0x0
    1068:	6dc50513          	addi	a0,a0,1756 # 1740 <printf+0x7c>
    106c:	00000097          	auipc	ra,0x0
    1070:	658080e7          	jalr	1624(ra) # 16c4 <printf>
    printf("ppid: %d\n",getppid());
    1074:	00000097          	auipc	ra,0x0
    1078:	378080e7          	jalr	888(ra) # 13ec <getppid>
    107c:	85aa                	mv	a1,a0
    107e:	00000517          	auipc	a0,0x0
    1082:	6d250513          	addi	a0,a0,1746 # 1750 <printf+0x8c>
    1086:	00000097          	auipc	ra,0x0
    108a:	63e080e7          	jalr	1598(ra) # 16c4 <printf>

    printf("\n");
    108e:	00000517          	auipc	a0,0x0
    1092:	6aa50513          	addi	a0,a0,1706 # 1738 <printf+0x74>
    1096:	00000097          	auipc	ra,0x0
    109a:	62e080e7          	jalr	1582(ra) # 16c4 <printf>

    printf("brk test:\n");
    109e:	00000517          	auipc	a0,0x0
    10a2:	6c250513          	addi	a0,a0,1730 # 1760 <printf+0x9c>
    10a6:	00000097          	auipc	ra,0x0
    10aa:	61e080e7          	jalr	1566(ra) # 16c4 <printf>
    int cur_pos, alloc_pos, alloc_pos_1;
    cur_pos = brk(0);
    10ae:	4501                	li	a0,0
    10b0:	00000097          	auipc	ra,0x0
    10b4:	390080e7          	jalr	912(ra) # 1440 <brk>
    10b8:	84aa                	mv	s1,a0
    printf("Before alloc,heap pos: %d\n", cur_pos);
    10ba:	85aa                	mv	a1,a0
    10bc:	00000517          	auipc	a0,0x0
    10c0:	6b450513          	addi	a0,a0,1716 # 1770 <printf+0xac>
    10c4:	00000097          	auipc	ra,0x0
    10c8:	600080e7          	jalr	1536(ra) # 16c4 <printf>
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
    10ea:	6aa50513          	addi	a0,a0,1706 # 1790 <printf+0xcc>
    10ee:	00000097          	auipc	ra,0x0
    10f2:	5d6080e7          	jalr	1494(ra) # 16c4 <printf>

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
    111a:	69a50513          	addi	a0,a0,1690 # 17b0 <printf+0xec>
    111e:	00000097          	auipc	ra,0x0
    1122:	5a6080e7          	jalr	1446(ra) # 16c4 <printf>

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
    113e:	85aa                	mv	a1,a0
    printf("Dealloc,heap pos: %d\n",alloc_pos_1);
    1140:	00000517          	auipc	a0,0x0
    1144:	69850513          	addi	a0,a0,1688 # 17d8 <printf+0x114>
    1148:	00000097          	auipc	ra,0x0
    114c:	57c080e7          	jalr	1404(ra) # 16c4 <printf>

    printf("\n");
    1150:	00000517          	auipc	a0,0x0
    1154:	5e850513          	addi	a0,a0,1512 # 1738 <printf+0x74>
    1158:	00000097          	auipc	ra,0x0
    115c:	56c080e7          	jalr	1388(ra) # 16c4 <printf>

    while(1){
        printf("input a string(q to quit): ");
    1160:	00000997          	auipc	s3,0x0
    1164:	69098993          	addi	s3,s3,1680 # 17f0 <printf+0x12c>
        simple_read(str,256);
    1168:	00000497          	auipc	s1,0x0
    116c:	72848493          	addi	s1,s1,1832 # 1890 <str>
        if(str[0]=='q' && str[1]==0)
    1170:	07100913          	li	s2,113
            break;
        printf("your string is: %s\n",str);
    1174:	00000a17          	auipc	s4,0x0
    1178:	69ca0a13          	addi	s4,s4,1692 # 1810 <printf+0x14c>
    117c:	a039                	j	118a <main+0x18a>
    117e:	85a6                	mv	a1,s1
    1180:	8552                	mv	a0,s4
    1182:	00000097          	auipc	ra,0x0
    1186:	542080e7          	jalr	1346(ra) # 16c4 <printf>
        printf("input a string(q to quit): ");
    118a:	854e                	mv	a0,s3
    118c:	00000097          	auipc	ra,0x0
    1190:	538080e7          	jalr	1336(ra) # 16c4 <printf>
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
    11b4:	58850513          	addi	a0,a0,1416 # 1738 <printf+0x74>
    11b8:	00000097          	auipc	ra,0x0
    11bc:	50c080e7          	jalr	1292(ra) # 16c4 <printf>

    printf("main end!\n");    
    11c0:	00000517          	auipc	a0,0x0
    11c4:	66850513          	addi	a0,a0,1640 # 1828 <printf+0x164>
    11c8:	00000097          	auipc	ra,0x0
    11cc:	4fc080e7          	jalr	1276(ra) # 16c4 <printf>
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
    1304:	862e                	mv	a2,a1
    return user_syscall(0,(uint64)s,n,0,0,0,0,SYS_simple_read);
    1306:	06300893          	li	a7,99
    130a:	4801                	li	a6,0
    130c:	4781                	li	a5,0
    130e:	4701                	li	a4,0
    1310:	4681                	li	a3,0
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
    132e:	862e                	mv	a2,a1
    return user_syscall(1,(uint64)s,n,0,0,0,0,SYS_simple_write);
    1330:	06400893          	li	a7,100
    1334:	4801                	li	a6,0
    1336:	4781                	li	a5,0
    1338:	4701                	li	a4,0
    133a:	4681                	li	a3,0
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
    1498:	20078863          	beqz	a5,16a8 <vsnprintf+0x214>
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
    14b4:	4801                	li	a6,0
  int longarg = 0;
    14b6:	4b01                	li	s6,0
  int format = 0;
    14b8:	4701                	li	a4,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
    14ba:	02500293          	li	t0,37
      format = 1;
    14be:	4385                	li	t2,1
    14c0:	4fd5                	li	t6,21
    14c2:	00000e97          	auipc	t4,0x0
    14c6:	372e8e93          	addi	t4,t4,882 # 1834 <printf+0x170>
          longarg = 0;
    14ca:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
    14cc:	48a9                	li	a7,10
            if (++pos < n) out[pos - 1] = '-';
    14ce:	02d00a93          	li	s5,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    14d2:	4f25                	li	t5,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    14d4:	5371                	li	t1,-4
    14d6:	44bd                	li	s1,15
    14d8:	4a1d                	li	s4,7
          if (++pos < n) out[pos - 1] = 'x';
    14da:	07800993          	li	s3,120
          if (++pos < n) out[pos - 1] = '0';
    14de:	03000913          	li	s2,48
    14e2:	aaa5                	j	165a <vsnprintf+0x1c6>
    if (format) {
    14e4:	8b3a                	mv	s6,a4
    14e6:	a2b5                	j	1652 <vsnprintf+0x1be>
          if (++pos < n) out[pos - 1] = '0';
    14e8:	00180793          	addi	a5,a6,1
    14ec:	00b7f663          	bgeu	a5,a1,14f8 <vsnprintf+0x64>
    14f0:	01050733          	add	a4,a0,a6
    14f4:	01270023          	sb	s2,0(a4)
          if (++pos < n) out[pos - 1] = 'x';
    14f8:	0809                	addi	a6,a6,2
    14fa:	00b87563          	bgeu	a6,a1,1504 <vsnprintf+0x70>
    14fe:	97aa                	add	a5,a5,a0
    1500:	01378023          	sb	s3,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1504:	0006bc03          	ld	s8,0(a3)
    1508:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    150a:	87a6                	mv	a5,s1
    150c:	00078c9b          	sext.w	s9,a5
    1510:	078a                	slli	a5,a5,0x2
    1512:	8742                	mv	a4,a6
    1514:	a839                	j	1532 <vsnprintf+0x9e>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1516:	fe0b17e3          	bnez	s6,1504 <vsnprintf+0x70>
    151a:	0006ac03          	lw	s8,0(a3)
    151e:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    1520:	87d2                	mv	a5,s4
    1522:	b7ed                	j	150c <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    1524:	00e50b33          	add	s6,a0,a4
    1528:	ff7b0fa3          	sb	s7,-1(s6)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    152c:	37f1                	addiw	a5,a5,-4
    152e:	02678063          	beq	a5,t1,154e <vsnprintf+0xba>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    1532:	0705                	addi	a4,a4,1
    1534:	feb77ce3          	bgeu	a4,a1,152c <vsnprintf+0x98>
            int d = (num >> (4 * i)) & 0xF;
    1538:	40fc5b33          	sra	s6,s8,a5
    153c:	00fb7b13          	andi	s6,s6,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    1540:	057b0b93          	addi	s7,s6,87
    1544:	ff6f40e3          	blt	t5,s6,1524 <vsnprintf+0x90>
    1548:	030b0b93          	addi	s7,s6,48
    154c:	bfe1                	j	1524 <vsnprintf+0x90>
    154e:	0805                	addi	a6,a6,1
    1550:	9866                	add	a6,a6,s9
          longarg = 0;
    1552:	8b72                	mv	s6,t3
          format = 0;
    1554:	8772                	mv	a4,t3
    1556:	a8f5                	j	1652 <vsnprintf+0x1be>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1558:	020b0563          	beqz	s6,1582 <vsnprintf+0xee>
    155c:	6298                	ld	a4,0(a3)
    155e:	06a1                	addi	a3,a3,8
          if (num < 0) {
    1560:	02074463          	bltz	a4,1588 <vsnprintf+0xf4>
          for (long nn = num; nn /= 10; digits++)
    1564:	031747b3          	div	a5,a4,a7
    1568:	cf8d                	beqz	a5,15a2 <vsnprintf+0x10e>
          long digits = 1;
    156a:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
    156c:	0b05                	addi	s6,s6,1
    156e:	0317c7b3          	div	a5,a5,a7
    1572:	ffed                	bnez	a5,156c <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
    1574:	fffb079b          	addiw	a5,s6,-1
    1578:	0407cd63          	bltz	a5,15d2 <vsnprintf+0x13e>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
    157c:	00180c13          	addi	s8,a6,1
    1580:	a81d                	j	15b6 <vsnprintf+0x122>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1582:	4298                	lw	a4,0(a3)
    1584:	06a1                	addi	a3,a3,8
    1586:	bfe9                	j	1560 <vsnprintf+0xcc>
            num = -num;
    1588:	40e00733          	neg	a4,a4
            if (++pos < n) out[pos - 1] = '-';
    158c:	00180793          	addi	a5,a6,1
    1590:	00b7f763          	bgeu	a5,a1,159e <vsnprintf+0x10a>
    1594:	982a                	add	a6,a6,a0
    1596:	01580023          	sb	s5,0(a6)
    159a:	883e                	mv	a6,a5
    159c:	b7e1                	j	1564 <vsnprintf+0xd0>
    159e:	883e                	mv	a6,a5
    15a0:	b7d1                	j	1564 <vsnprintf+0xd0>
          long digits = 1;
    15a2:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
    15a4:	87f2                	mv	a5,t3
    15a6:	bfd9                	j	157c <vsnprintf+0xe8>
            num /= 10;
    15a8:	03174733          	div	a4,a4,a7
          for (int i = digits - 1; i >= 0; i--) {
    15ac:	17fd                	addi	a5,a5,-1
    15ae:	00078b9b          	sext.w	s7,a5
    15b2:	020bc063          	bltz	s7,15d2 <vsnprintf+0x13e>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
    15b6:	00fc0bb3          	add	s7,s8,a5
    15ba:	febbf7e3          	bgeu	s7,a1,15a8 <vsnprintf+0x114>
    15be:	00f80bb3          	add	s7,a6,a5
    15c2:	9baa                	add	s7,s7,a0
    15c4:	03176cb3          	rem	s9,a4,a7
    15c8:	030c8c9b          	addiw	s9,s9,48
    15cc:	019b8023          	sb	s9,0(s7)
    15d0:	bfe1                	j	15a8 <vsnprintf+0x114>
          pos += digits;
    15d2:	985a                	add	a6,a6,s6
          longarg = 0;
    15d4:	8b72                	mv	s6,t3
          format = 0;
    15d6:	8772                	mv	a4,t3
          break;
    15d8:	a8ad                	j	1652 <vsnprintf+0x1be>
          const char* s2 = va_arg(vl, const char*);
    15da:	00868b93          	addi	s7,a3,8
    15de:	6294                	ld	a3,0(a3)
          while (*s2) {
    15e0:	0006c703          	lbu	a4,0(a3)
    15e4:	cf31                	beqz	a4,1640 <vsnprintf+0x1ac>
    15e6:	87c2                	mv	a5,a6
    15e8:	a039                	j	15f6 <vsnprintf+0x162>
    15ea:	41078733          	sub	a4,a5,a6
    15ee:	9736                	add	a4,a4,a3
    15f0:	00074703          	lbu	a4,0(a4)
    15f4:	cb09                	beqz	a4,1606 <vsnprintf+0x172>
            if (++pos < n) out[pos - 1] = *s2;
    15f6:	0785                	addi	a5,a5,1
    15f8:	feb7f9e3          	bgeu	a5,a1,15ea <vsnprintf+0x156>
    15fc:	00f50b33          	add	s6,a0,a5
    1600:	feeb0fa3          	sb	a4,-1(s6)
    1604:	b7dd                	j	15ea <vsnprintf+0x156>
          const char* s2 = va_arg(vl, const char*);
    1606:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
    1608:	883e                	mv	a6,a5
          longarg = 0;
    160a:	8b72                	mv	s6,t3
          format = 0;
    160c:	8772                	mv	a4,t3
    160e:	a091                	j	1652 <vsnprintf+0x1be>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
    1610:	00180793          	addi	a5,a6,1
    1614:	02b7fa63          	bgeu	a5,a1,1648 <vsnprintf+0x1b4>
    1618:	982a                	add	a6,a6,a0
    161a:	4298                	lw	a4,0(a3)
    161c:	00e80023          	sb	a4,0(a6)
    1620:	06a1                	addi	a3,a3,8
    1622:	883e                	mv	a6,a5
          longarg = 0;
    1624:	8b72                	mv	s6,t3
          format = 0;
    1626:	8772                	mv	a4,t3
    1628:	a02d                	j	1652 <vsnprintf+0x1be>
    } else if (*s == '%')
    162a:	02578363          	beq	a5,t0,1650 <vsnprintf+0x1bc>
    else if (++pos < n)
    162e:	00180b93          	addi	s7,a6,1
    1632:	04bbf163          	bgeu	s7,a1,1674 <vsnprintf+0x1e0>
      out[pos - 1] = *s;
    1636:	982a                	add	a6,a6,a0
    1638:	00f80023          	sb	a5,0(a6)
    else if (++pos < n)
    163c:	885e                	mv	a6,s7
    163e:	a811                	j	1652 <vsnprintf+0x1be>
          const char* s2 = va_arg(vl, const char*);
    1640:	86de                	mv	a3,s7
          longarg = 0;
    1642:	8b72                	mv	s6,t3
          format = 0;
    1644:	8772                	mv	a4,t3
    1646:	a031                	j	1652 <vsnprintf+0x1be>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
    1648:	883e                	mv	a6,a5
          longarg = 0;
    164a:	8b72                	mv	s6,t3
          format = 0;
    164c:	8772                	mv	a4,t3
    164e:	a011                	j	1652 <vsnprintf+0x1be>
      format = 1;
    1650:	871e                	mv	a4,t2
  for (; *s; s++) {
    1652:	0605                	addi	a2,a2,1
    1654:	00064783          	lbu	a5,0(a2)
    1658:	c385                	beqz	a5,1678 <vsnprintf+0x1e4>
    if (format) {
    165a:	db61                	beqz	a4,162a <vsnprintf+0x196>
      switch (*s) {
    165c:	f9d7879b          	addiw	a5,a5,-99
    1660:	0ff7fb93          	andi	s7,a5,255
    1664:	ff7fe7e3          	bltu	t6,s7,1652 <vsnprintf+0x1be>
    1668:	002b9793          	slli	a5,s7,0x2
    166c:	97f6                	add	a5,a5,t4
    166e:	439c                	lw	a5,0(a5)
    1670:	97f6                	add	a5,a5,t4
    1672:	8782                	jr	a5
    else if (++pos < n)
    1674:	885e                	mv	a6,s7
    1676:	bff1                	j	1652 <vsnprintf+0x1be>
  }
  if (pos < n)
    1678:	02b87363          	bgeu	a6,a1,169e <vsnprintf+0x20a>
    out[pos] = 0;
    167c:	9542                	add	a0,a0,a6
    167e:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
    1682:	0008051b          	sext.w	a0,a6
    1686:	6426                	ld	s0,72(sp)
    1688:	6486                	ld	s1,64(sp)
    168a:	7962                	ld	s2,56(sp)
    168c:	79c2                	ld	s3,48(sp)
    168e:	7a22                	ld	s4,40(sp)
    1690:	7a82                	ld	s5,32(sp)
    1692:	6b62                	ld	s6,24(sp)
    1694:	6bc2                	ld	s7,16(sp)
    1696:	6c22                	ld	s8,8(sp)
    1698:	6c82                	ld	s9,0(sp)
    169a:	6161                	addi	sp,sp,80
    169c:	8082                	ret
  else if (n)
    169e:	d1f5                	beqz	a1,1682 <vsnprintf+0x1ee>
    out[n - 1] = 0;
    16a0:	95aa                	add	a1,a1,a0
    16a2:	fe058fa3          	sb	zero,-1(a1)
    16a6:	bff1                	j	1682 <vsnprintf+0x1ee>
  size_t pos = 0;
    16a8:	4801                	li	a6,0
  if (pos < n)
    16aa:	00b87863          	bgeu	a6,a1,16ba <vsnprintf+0x226>
    out[pos] = 0;
    16ae:	9542                	add	a0,a0,a6
    16b0:	00050023          	sb	zero,0(a0)
}
    16b4:	0008051b          	sext.w	a0,a6
    16b8:	8082                	ret
  else if (n)
    16ba:	dded                	beqz	a1,16b4 <vsnprintf+0x220>
    out[n - 1] = 0;
    16bc:	95aa                	add	a1,a1,a0
    16be:	fe058fa3          	sb	zero,-1(a1)
    16c2:	bfcd                	j	16b4 <vsnprintf+0x220>

00000000000016c4 <printf>:
int printf(char*s, ...){
    16c4:	710d                	addi	sp,sp,-352
    16c6:	ee06                	sd	ra,280(sp)
    16c8:	ea22                	sd	s0,272(sp)
    16ca:	1200                	addi	s0,sp,288
    16cc:	e40c                	sd	a1,8(s0)
    16ce:	e810                	sd	a2,16(s0)
    16d0:	ec14                	sd	a3,24(s0)
    16d2:	f018                	sd	a4,32(s0)
    16d4:	f41c                	sd	a5,40(s0)
    16d6:	03043823          	sd	a6,48(s0)
    16da:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
    16de:	00840693          	addi	a3,s0,8
    16e2:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
    16e6:	862a                	mv	a2,a0
    16e8:	10000593          	li	a1,256
    16ec:	ee840513          	addi	a0,s0,-280
    16f0:	00000097          	auipc	ra,0x0
    16f4:	da4080e7          	jalr	-604(ra) # 1494 <vsnprintf>
    16f8:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
    16fa:	0005071b          	sext.w	a4,a0
    16fe:	0ff00793          	li	a5,255
    1702:	00e7f463          	bgeu	a5,a4,170a <printf+0x46>
    1706:	10000593          	li	a1,256
    return simple_write(buf, n);
    170a:	ee840513          	addi	a0,s0,-280
    170e:	00000097          	auipc	ra,0x0
    1712:	c18080e7          	jalr	-1000(ra) # 1326 <simple_write>
}
    1716:	2501                	sext.w	a0,a0
    1718:	60f2                	ld	ra,280(sp)
    171a:	6452                	ld	s0,272(sp)
    171c:	6135                	addi	sp,sp,352
    171e:	8082                	ret
