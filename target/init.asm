
target/init：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "user_syscall.h"
#include "stdio.h"

int main(){
    1000:	715d                	addi	sp,sp,-80
    1002:	e486                	sd	ra,72(sp)
    1004:	e0a2                	sd	s0,64(sp)
    1006:	fc26                	sd	s1,56(sp)
    1008:	f84a                	sd	s2,48(sp)
    100a:	0880                	addi	s0,sp,80
    printf("\nsyscall test begin\n");
    100c:	00000517          	auipc	a0,0x0
    1010:	66450513          	addi	a0,a0,1636 # 1670 <printf+0x8a>
    1014:	00000097          	auipc	ra,0x0
    1018:	5d2080e7          	jalr	1490(ra) # 15e6 <printf>
    
    int pid=fork();
    101c:	00000097          	auipc	ra,0x0
    1020:	142080e7          	jalr	322(ra) # 115e <fork>

    if(pid==0){
    1024:	2501                	sext.w	a0,a0
    1026:	ed41                	bnez	a0,10be <main+0xbe>
        char *argv[5]={"wait4 ", "and ","execve ", "test!\n", NULL};
    1028:	00000797          	auipc	a5,0x0
    102c:	62078793          	addi	a5,a5,1568 # 1648 <printf+0x62>
    1030:	638c                	ld	a1,0(a5)
    1032:	6790                	ld	a2,8(a5)
    1034:	6b94                	ld	a3,16(a5)
    1036:	6f98                	ld	a4,24(a5)
    1038:	739c                	ld	a5,32(a5)
    103a:	fab43c23          	sd	a1,-72(s0)
    103e:	fcc43023          	sd	a2,-64(s0)
    1042:	fcd43423          	sd	a3,-56(s0)
    1046:	fce43823          	sd	a4,-48(s0)
    104a:	fcf43c23          	sd	a5,-40(s0)
        for(int i=0;i<4;i++){
    104e:	fb840493          	addi	s1,s0,-72
    1052:	fd840913          	addi	s2,s0,-40
            printf(argv[i]);
    1056:	6088                	ld	a0,0(s1)
    1058:	00000097          	auipc	ra,0x0
    105c:	58e080e7          	jalr	1422(ra) # 15e6 <printf>
    1060:	04a1                	addi	s1,s1,8
        for(int i=0;i<4;i++){
    1062:	ff249ae3          	bne	s1,s2,1056 <main+0x56>
        }
        printf("\n...................................\n\n");
    1066:	00000517          	auipc	a0,0x0
    106a:	62250513          	addi	a0,a0,1570 # 1688 <printf+0xa2>
    106e:	00000097          	auipc	ra,0x0
    1072:	578080e7          	jalr	1400(ra) # 15e6 <printf>
        execve("main",argv, NULL);
    1076:	4601                	li	a2,0
    1078:	fb840593          	addi	a1,s0,-72
    107c:	00000517          	auipc	a0,0x0
    1080:	63450513          	addi	a0,a0,1588 # 16b0 <printf+0xca>
    1084:	00000097          	auipc	ra,0x0
    1088:	16e080e7          	jalr	366(ra) # 11f2 <execve>
        int ret=wait4(-1,&status,0);
        status=status>>8;
        printf("ret=%d, status=%d\n",ret,status);
    }

    pid=fork();
    108c:	00000097          	auipc	ra,0x0
    1090:	0d2080e7          	jalr	210(ra) # 115e <fork>
    if(pid==0){
    1094:	2501                	sext.w	a0,a0
    1096:	e125                	bnez	a0,10f6 <main+0xf6>
        execve("/getpid",NULL,NULL);
    1098:	4601                	li	a2,0
    109a:	4581                	li	a1,0
    109c:	00000517          	auipc	a0,0x0
    10a0:	63450513          	addi	a0,a0,1588 # 16d0 <printf+0xea>
    10a4:	00000097          	auipc	ra,0x0
    10a8:	14e080e7          	jalr	334(ra) # 11f2 <execve>
    }
    else{
        wait4(-1,NULL,0);
    }

    printf("\nsyscall test end\n");
    10ac:	00000517          	auipc	a0,0x0
    10b0:	62c50513          	addi	a0,a0,1580 # 16d8 <printf+0xf2>
    10b4:	00000097          	auipc	ra,0x0
    10b8:	532080e7          	jalr	1330(ra) # 15e6 <printf>

    while(1){
    }
    10bc:	a001                	j	10bc <main+0xbc>
        int status=0;
    10be:	fa042c23          	sw	zero,-72(s0)
        int ret=wait4(-1,&status,0);
    10c2:	4601                	li	a2,0
    10c4:	fb840593          	addi	a1,s0,-72
    10c8:	557d                	li	a0,-1
    10ca:	00000097          	auipc	ra,0x0
    10ce:	1f0080e7          	jalr	496(ra) # 12ba <wait4>
        status=status>>8;
    10d2:	fb842603          	lw	a2,-72(s0)
    10d6:	4086561b          	sraiw	a2,a2,0x8
    10da:	fac42c23          	sw	a2,-72(s0)
        printf("ret=%d, status=%d\n",ret,status);
    10de:	2601                	sext.w	a2,a2
    10e0:	0005059b          	sext.w	a1,a0
    10e4:	00000517          	auipc	a0,0x0
    10e8:	5d450513          	addi	a0,a0,1492 # 16b8 <printf+0xd2>
    10ec:	00000097          	auipc	ra,0x0
    10f0:	4fa080e7          	jalr	1274(ra) # 15e6 <printf>
    10f4:	bf61                	j	108c <main+0x8c>
        wait4(-1,NULL,0);
    10f6:	4601                	li	a2,0
    10f8:	4581                	li	a1,0
    10fa:	557d                	li	a0,-1
    10fc:	00000097          	auipc	ra,0x0
    1100:	1be080e7          	jalr	446(ra) # 12ba <wait4>
    1104:	b765                	j	10ac <main+0xac>

0000000000001106 <user_syscall>:
/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
    1106:	715d                	addi	sp,sp,-80
    1108:	e4a2                	sd	s0,72(sp)
    110a:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
    110c:	fea43423          	sd	a0,-24(s0)
    1110:	feb43023          	sd	a1,-32(s0)
    1114:	fcc43c23          	sd	a2,-40(s0)
    1118:	fcd43823          	sd	a3,-48(s0)
    111c:	fce43423          	sd	a4,-56(s0)
    1120:	fcf43023          	sd	a5,-64(s0)
    1124:	fb043c23          	sd	a6,-72(s0)
    1128:	fb143823          	sd	a7,-80(s0)
        asm volatile(   //将参数写入a0-a7寄存器
    112c:	fe843503          	ld	a0,-24(s0)
    1130:	fe043583          	ld	a1,-32(s0)
    1134:	fd843603          	ld	a2,-40(s0)
    1138:	fd043683          	ld	a3,-48(s0)
    113c:	fc843703          	ld	a4,-56(s0)
    1140:	fc043783          	ld	a5,-64(s0)
    1144:	fb843803          	ld	a6,-72(s0)
    1148:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(   //调用ecall
    114c:	00000073          	ecall
    1150:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
    1154:	fe843503          	ld	a0,-24(s0)
    1158:	6426                	ld	s0,72(sp)
    115a:	6161                	addi	sp,sp,80
    115c:	8082                	ret

000000000000115e <fork>:

//复制一个新进程
uint64 fork(){
    115e:	1141                	addi	sp,sp,-16
    1160:	e406                	sd	ra,8(sp)
    1162:	e022                	sd	s0,0(sp)
    1164:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
    1166:	4885                	li	a7,1
    1168:	4801                	li	a6,0
    116a:	4781                	li	a5,0
    116c:	4701                	li	a4,0
    116e:	4681                	li	a3,0
    1170:	4601                	li	a2,0
    1172:	4581                	li	a1,0
    1174:	4501                	li	a0,0
    1176:	00000097          	auipc	ra,0x0
    117a:	f90080e7          	jalr	-112(ra) # 1106 <user_syscall>
}
    117e:	60a2                	ld	ra,8(sp)
    1180:	6402                	ld	s0,0(sp)
    1182:	0141                	addi	sp,sp,16
    1184:	8082                	ret

0000000000001186 <open>:

//打开文件
uint64 open(char *file_name, int mode){
    1186:	1141                	addi	sp,sp,-16
    1188:	e406                	sd	ra,8(sp)
    118a:	e022                	sd	s0,0(sp)
    118c:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
    118e:	48bd                	li	a7,15
    1190:	4801                	li	a6,0
    1192:	4781                	li	a5,0
    1194:	4701                	li	a4,0
    1196:	4681                	li	a3,0
    1198:	4601                	li	a2,0
    119a:	00000097          	auipc	ra,0x0
    119e:	f6c080e7          	jalr	-148(ra) # 1106 <user_syscall>
}
    11a2:	60a2                	ld	ra,8(sp)
    11a4:	6402                	ld	s0,0(sp)
    11a6:	0141                	addi	sp,sp,16
    11a8:	8082                	ret

00000000000011aa <read>:

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
    11aa:	1141                	addi	sp,sp,-16
    11ac:	e406                	sd	ra,8(sp)
    11ae:	e022                	sd	s0,0(sp)
    11b0:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
    11b2:	4895                	li	a7,5
    11b4:	4801                	li	a6,0
    11b6:	4781                	li	a5,0
    11b8:	4701                	li	a4,0
    11ba:	4681                	li	a3,0
    11bc:	00000097          	auipc	ra,0x0
    11c0:	f4a080e7          	jalr	-182(ra) # 1106 <user_syscall>
}
    11c4:	60a2                	ld	ra,8(sp)
    11c6:	6402                	ld	s0,0(sp)
    11c8:	0141                	addi	sp,sp,16
    11ca:	8082                	ret

00000000000011cc <kill>:

//根据pid杀死进程
uint64 kill(uint64 pid){
    11cc:	1141                	addi	sp,sp,-16
    11ce:	e406                	sd	ra,8(sp)
    11d0:	e022                	sd	s0,0(sp)
    11d2:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
    11d4:	4899                	li	a7,6
    11d6:	4801                	li	a6,0
    11d8:	4781                	li	a5,0
    11da:	4701                	li	a4,0
    11dc:	4681                	li	a3,0
    11de:	4601                	li	a2,0
    11e0:	4581                	li	a1,0
    11e2:	00000097          	auipc	ra,0x0
    11e6:	f24080e7          	jalr	-220(ra) # 1106 <user_syscall>
}
    11ea:	60a2                	ld	ra,8(sp)
    11ec:	6402                	ld	s0,0(sp)
    11ee:	0141                	addi	sp,sp,16
    11f0:	8082                	ret

00000000000011f2 <execve>:

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
    11f2:	1141                	addi	sp,sp,-16
    11f4:	e406                	sd	ra,8(sp)
    11f6:	e022                	sd	s0,0(sp)
    11f8:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
    11fa:	0dd00893          	li	a7,221
    11fe:	4801                	li	a6,0
    1200:	4781                	li	a5,0
    1202:	4701                	li	a4,0
    1204:	4681                	li	a3,0
    1206:	00000097          	auipc	ra,0x0
    120a:	f00080e7          	jalr	-256(ra) # 1106 <user_syscall>
}
    120e:	60a2                	ld	ra,8(sp)
    1210:	6402                	ld	s0,0(sp)
    1212:	0141                	addi	sp,sp,16
    1214:	8082                	ret

0000000000001216 <simple_read>:

//从键盘输入字符串
uint64 simple_read(char *s, size_t n){
    1216:	1141                	addi	sp,sp,-16
    1218:	e406                	sd	ra,8(sp)
    121a:	e022                	sd	s0,0(sp)
    121c:	0800                	addi	s0,sp,16
    return user_syscall(0,(uint64)s,n,0,0,0,0,SYS_simple_read);
    121e:	06300893          	li	a7,99
    1222:	4801                	li	a6,0
    1224:	4781                	li	a5,0
    1226:	4701                	li	a4,0
    1228:	4681                	li	a3,0
    122a:	862e                	mv	a2,a1
    122c:	85aa                	mv	a1,a0
    122e:	4501                	li	a0,0
    1230:	00000097          	auipc	ra,0x0
    1234:	ed6080e7          	jalr	-298(ra) # 1106 <user_syscall>
}
    1238:	60a2                	ld	ra,8(sp)
    123a:	6402                	ld	s0,0(sp)
    123c:	0141                	addi	sp,sp,16
    123e:	8082                	ret

0000000000001240 <simple_write>:

//输出字符串到屏幕
uint64 simple_write(char *s, size_t n){
    1240:	1141                	addi	sp,sp,-16
    1242:	e406                	sd	ra,8(sp)
    1244:	e022                	sd	s0,0(sp)
    1246:	0800                	addi	s0,sp,16
    return user_syscall(1,(uint64)s,n,0,0,0,0,SYS_simple_write);
    1248:	06400893          	li	a7,100
    124c:	4801                	li	a6,0
    124e:	4781                	li	a5,0
    1250:	4701                	li	a4,0
    1252:	4681                	li	a3,0
    1254:	862e                	mv	a2,a1
    1256:	85aa                	mv	a1,a0
    1258:	4505                	li	a0,1
    125a:	00000097          	auipc	ra,0x0
    125e:	eac080e7          	jalr	-340(ra) # 1106 <user_syscall>
}
    1262:	60a2                	ld	ra,8(sp)
    1264:	6402                	ld	s0,0(sp)
    1266:	0141                	addi	sp,sp,16
    1268:	8082                	ret

000000000000126a <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
    126a:	1141                	addi	sp,sp,-16
    126c:	e406                	sd	ra,8(sp)
    126e:	e022                	sd	s0,0(sp)
    1270:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
    1272:	48d5                	li	a7,21
    1274:	4801                	li	a6,0
    1276:	4781                	li	a5,0
    1278:	4701                	li	a4,0
    127a:	4681                	li	a3,0
    127c:	4601                	li	a2,0
    127e:	4581                	li	a1,0
    1280:	00000097          	auipc	ra,0x0
    1284:	e86080e7          	jalr	-378(ra) # 1106 <user_syscall>
}
    1288:	60a2                	ld	ra,8(sp)
    128a:	6402                	ld	s0,0(sp)
    128c:	0141                	addi	sp,sp,16
    128e:	8082                	ret

0000000000001290 <clone>:

uint64 clone(uint64 flag, void *stack, size_t sz){
    1290:	1141                	addi	sp,sp,-16
    1292:	e406                	sd	ra,8(sp)
    1294:	e022                	sd	s0,0(sp)
    1296:	0800                	addi	s0,sp,16
    if(stack!=NULL)
    1298:	c191                	beqz	a1,129c <clone+0xc>
        stack+=sz;
    129a:	95b2                	add	a1,a1,a2
    return user_syscall(flag,(uint64)stack,0,0,0,0,0,SYS_clone);
    129c:	0dc00893          	li	a7,220
    12a0:	4801                	li	a6,0
    12a2:	4781                	li	a5,0
    12a4:	4701                	li	a4,0
    12a6:	4681                	li	a3,0
    12a8:	4601                	li	a2,0
    12aa:	00000097          	auipc	ra,0x0
    12ae:	e5c080e7          	jalr	-420(ra) # 1106 <user_syscall>
}
    12b2:	60a2                	ld	ra,8(sp)
    12b4:	6402                	ld	s0,0(sp)
    12b6:	0141                	addi	sp,sp,16
    12b8:	8082                	ret

00000000000012ba <wait4>:

uint64 wait4(int pid, int *status, uint64 options){
    12ba:	1141                	addi	sp,sp,-16
    12bc:	e406                	sd	ra,8(sp)
    12be:	e022                	sd	s0,0(sp)
    12c0:	0800                	addi	s0,sp,16
    return user_syscall((uint64)pid,(uint64)status,options,0,0,0,0,SYS_wait4);
    12c2:	10400893          	li	a7,260
    12c6:	4801                	li	a6,0
    12c8:	4781                	li	a5,0
    12ca:	4701                	li	a4,0
    12cc:	4681                	li	a3,0
    12ce:	00000097          	auipc	ra,0x0
    12d2:	e38080e7          	jalr	-456(ra) # 1106 <user_syscall>
}
    12d6:	60a2                	ld	ra,8(sp)
    12d8:	6402                	ld	s0,0(sp)
    12da:	0141                	addi	sp,sp,16
    12dc:	8082                	ret

00000000000012de <exit>:

//进程退出
uint64 exit(int code){
    12de:	1141                	addi	sp,sp,-16
    12e0:	e406                	sd	ra,8(sp)
    12e2:	e022                	sd	s0,0(sp)
    12e4:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
    12e6:	05d00893          	li	a7,93
    12ea:	4801                	li	a6,0
    12ec:	4781                	li	a5,0
    12ee:	4701                	li	a4,0
    12f0:	4681                	li	a3,0
    12f2:	4601                	li	a2,0
    12f4:	4581                	li	a1,0
    12f6:	00000097          	auipc	ra,0x0
    12fa:	e10080e7          	jalr	-496(ra) # 1106 <user_syscall>
}
    12fe:	60a2                	ld	ra,8(sp)
    1300:	6402                	ld	s0,0(sp)
    1302:	0141                	addi	sp,sp,16
    1304:	8082                	ret

0000000000001306 <getppid>:

//获取父进程pid
uint64 getppid(){
    1306:	1141                	addi	sp,sp,-16
    1308:	e406                	sd	ra,8(sp)
    130a:	e022                	sd	s0,0(sp)
    130c:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getppid);
    130e:	0ad00893          	li	a7,173
    1312:	4801                	li	a6,0
    1314:	4781                	li	a5,0
    1316:	4701                	li	a4,0
    1318:	4681                	li	a3,0
    131a:	4601                	li	a2,0
    131c:	4581                	li	a1,0
    131e:	4501                	li	a0,0
    1320:	00000097          	auipc	ra,0x0
    1324:	de6080e7          	jalr	-538(ra) # 1106 <user_syscall>
}
    1328:	60a2                	ld	ra,8(sp)
    132a:	6402                	ld	s0,0(sp)
    132c:	0141                	addi	sp,sp,16
    132e:	8082                	ret

0000000000001330 <getpid>:

//获取当前进程pid
uint64 getpid(){
    1330:	1141                	addi	sp,sp,-16
    1332:	e406                	sd	ra,8(sp)
    1334:	e022                	sd	s0,0(sp)
    1336:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getpid);
    1338:	0ac00893          	li	a7,172
    133c:	4801                	li	a6,0
    133e:	4781                	li	a5,0
    1340:	4701                	li	a4,0
    1342:	4681                	li	a3,0
    1344:	4601                	li	a2,0
    1346:	4581                	li	a1,0
    1348:	4501                	li	a0,0
    134a:	00000097          	auipc	ra,0x0
    134e:	dbc080e7          	jalr	-580(ra) # 1106 <user_syscall>
}
    1352:	60a2                	ld	ra,8(sp)
    1354:	6402                	ld	s0,0(sp)
    1356:	0141                	addi	sp,sp,16
    1358:	8082                	ret

000000000000135a <brk>:

//改变进程堆内存大小，当addr为0时，返回当前进程大小
int brk(uint64 addr){
    135a:	1141                	addi	sp,sp,-16
    135c:	e406                	sd	ra,8(sp)
    135e:	e022                	sd	s0,0(sp)
    1360:	0800                	addi	s0,sp,16
    return (int)user_syscall(addr,0,0,0,0,0,0,SYS_brk);
    1362:	0d600893          	li	a7,214
    1366:	4801                	li	a6,0
    1368:	4781                	li	a5,0
    136a:	4701                	li	a4,0
    136c:	4681                	li	a3,0
    136e:	4601                	li	a2,0
    1370:	4581                	li	a1,0
    1372:	00000097          	auipc	ra,0x0
    1376:	d94080e7          	jalr	-620(ra) # 1106 <user_syscall>
}
    137a:	2501                	sext.w	a0,a0
    137c:	60a2                	ld	ra,8(sp)
    137e:	6402                	ld	s0,0(sp)
    1380:	0141                	addi	sp,sp,16
    1382:	8082                	ret

0000000000001384 <sched_yield>:

//进程放弃cpu
uint64 sched_yield(){
    1384:	1141                	addi	sp,sp,-16
    1386:	e406                	sd	ra,8(sp)
    1388:	e022                	sd	s0,0(sp)
    138a:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_sched_yield);
    138c:	07c00893          	li	a7,124
    1390:	4801                	li	a6,0
    1392:	4781                	li	a5,0
    1394:	4701                	li	a4,0
    1396:	4681                	li	a3,0
    1398:	4601                	li	a2,0
    139a:	4581                	li	a1,0
    139c:	4501                	li	a0,0
    139e:	00000097          	auipc	ra,0x0
    13a2:	d68080e7          	jalr	-664(ra) # 1106 <user_syscall>
    13a6:	60a2                	ld	ra,8(sp)
    13a8:	6402                	ld	s0,0(sp)
    13aa:	0141                	addi	sp,sp,16
    13ac:	8082                	ret

00000000000013ae <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
    13ae:	00064783          	lbu	a5,0(a2)
    13b2:	20078c63          	beqz	a5,15ca <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
    13b6:	715d                	addi	sp,sp,-80
    13b8:	e4a2                	sd	s0,72(sp)
    13ba:	e0a6                	sd	s1,64(sp)
    13bc:	fc4a                	sd	s2,56(sp)
    13be:	f84e                	sd	s3,48(sp)
    13c0:	f452                	sd	s4,40(sp)
    13c2:	f056                	sd	s5,32(sp)
    13c4:	ec5a                	sd	s6,24(sp)
    13c6:	e85e                	sd	s7,16(sp)
    13c8:	e462                	sd	s8,8(sp)
    13ca:	e066                	sd	s9,0(sp)
    13cc:	0880                	addi	s0,sp,80
  size_t pos = 0;
    13ce:	4701                	li	a4,0
  int longarg = 0;
    13d0:	4b01                	li	s6,0
  int format = 0;
    13d2:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
    13d4:	02500f93          	li	t6,37
      format = 1;
    13d8:	4285                	li	t0,1
      switch (*s) {
    13da:	4f55                	li	t5,21
    13dc:	00000317          	auipc	t1,0x0
    13e0:	33430313          	addi	t1,t1,820 # 1710 <printf+0x12a>
          longarg = 0;
    13e4:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
    13e6:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
    13e8:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    13ec:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    13ee:	58fd                	li	a7,-1
    13f0:	43bd                	li	t2,15
    13f2:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
    13f4:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
    13f8:	03000493          	li	s1,48
    13fc:	aabd                	j	157a <vsnprintf+0x1cc>
          longarg = 1;
    13fe:	8b56                	mv	s6,s5
    1400:	aa8d                	j	1572 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
    1402:	00170793          	addi	a5,a4,1
    1406:	00b7f663          	bgeu	a5,a1,1412 <vsnprintf+0x64>
    140a:	00e50ab3          	add	s5,a0,a4
    140e:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
    1412:	0709                	addi	a4,a4,2
    1414:	00b77563          	bgeu	a4,a1,141e <vsnprintf+0x70>
    1418:	97aa                	add	a5,a5,a0
    141a:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    141e:	0006bc03          	ld	s8,0(a3)
    1422:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    1424:	8c9e                	mv	s9,t2
    1426:	8b66                	mv	s6,s9
    1428:	8aba                	mv	s5,a4
    142a:	a839                	j	1448 <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    142c:	fe0b19e3          	bnez	s6,141e <vsnprintf+0x70>
    1430:	0006ac03          	lw	s8,0(a3)
    1434:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    1436:	8cce                	mv	s9,s3
    1438:	b7fd                	j	1426 <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    143a:	015507b3          	add	a5,a0,s5
    143e:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    1442:	3b7d                	addiw	s6,s6,-1
    1444:	031b0163          	beq	s6,a7,1466 <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    1448:	0a85                	addi	s5,s5,1
    144a:	febafce3          	bgeu	s5,a1,1442 <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
    144e:	002b179b          	slliw	a5,s6,0x2
    1452:	40fc57b3          	sra	a5,s8,a5
    1456:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    1458:	05778b93          	addi	s7,a5,87
    145c:	fcfecfe3          	blt	t4,a5,143a <vsnprintf+0x8c>
    1460:	03078b93          	addi	s7,a5,48
    1464:	bfd9                	j	143a <vsnprintf+0x8c>
    1466:	0705                	addi	a4,a4,1
    1468:	9766                	add	a4,a4,s9
          longarg = 0;
    146a:	8b72                	mv	s6,t3
          format = 0;
    146c:	8af2                	mv	s5,t3
    146e:	a211                	j	1572 <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1470:	020b0663          	beqz	s6,149c <vsnprintf+0xee>
    1474:	0006ba83          	ld	s5,0(a3)
    1478:	06a1                	addi	a3,a3,8
          if (num < 0) {
    147a:	020ac563          	bltz	s5,14a4 <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
    147e:	030ac7b3          	div	a5,s5,a6
    1482:	cf95                	beqz	a5,14be <vsnprintf+0x110>
          long digits = 1;
    1484:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
    1486:	0b05                	addi	s6,s6,1
    1488:	0307c7b3          	div	a5,a5,a6
    148c:	ffed                	bnez	a5,1486 <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
    148e:	fffb079b          	addiw	a5,s6,-1
    1492:	0407ce63          	bltz	a5,14ee <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
    1496:	00170c93          	addi	s9,a4,1
    149a:	a825                	j	14d2 <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    149c:	0006aa83          	lw	s5,0(a3)
    14a0:	06a1                	addi	a3,a3,8
    14a2:	bfe1                	j	147a <vsnprintf+0xcc>
            num = -num;
    14a4:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
    14a8:	00170793          	addi	a5,a4,1
    14ac:	00b7f763          	bgeu	a5,a1,14ba <vsnprintf+0x10c>
    14b0:	972a                	add	a4,a4,a0
    14b2:	01470023          	sb	s4,0(a4)
    14b6:	873e                	mv	a4,a5
    14b8:	b7d9                	j	147e <vsnprintf+0xd0>
    14ba:	873e                	mv	a4,a5
    14bc:	b7c9                	j	147e <vsnprintf+0xd0>
          long digits = 1;
    14be:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
    14c0:	87f2                	mv	a5,t3
    14c2:	bfd1                	j	1496 <vsnprintf+0xe8>
            num /= 10;
    14c4:	030acab3          	div	s5,s5,a6
    14c8:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
    14ca:	02079b93          	slli	s7,a5,0x20
    14ce:	020bc063          	bltz	s7,14ee <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
    14d2:	00fc8bb3          	add	s7,s9,a5
    14d6:	febbf7e3          	bgeu	s7,a1,14c4 <vsnprintf+0x116>
    14da:	00f70bb3          	add	s7,a4,a5
    14de:	9baa                	add	s7,s7,a0
    14e0:	030aec33          	rem	s8,s5,a6
    14e4:	030c0c1b          	addiw	s8,s8,48
    14e8:	018b8023          	sb	s8,0(s7)
    14ec:	bfe1                	j	14c4 <vsnprintf+0x116>
          pos += digits;
    14ee:	975a                	add	a4,a4,s6
          longarg = 0;
    14f0:	8b72                	mv	s6,t3
          format = 0;
    14f2:	8af2                	mv	s5,t3
          break;
    14f4:	a8bd                	j	1572 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
    14f6:	00868b93          	addi	s7,a3,8
    14fa:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
    14fe:	000ac683          	lbu	a3,0(s5)
    1502:	ceb9                	beqz	a3,1560 <vsnprintf+0x1b2>
    1504:	87ba                	mv	a5,a4
    1506:	a039                	j	1514 <vsnprintf+0x166>
    1508:	40e786b3          	sub	a3,a5,a4
    150c:	96d6                	add	a3,a3,s5
    150e:	0006c683          	lbu	a3,0(a3)
    1512:	ca89                	beqz	a3,1524 <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
    1514:	0785                	addi	a5,a5,1
    1516:	feb7f9e3          	bgeu	a5,a1,1508 <vsnprintf+0x15a>
    151a:	00f50b33          	add	s6,a0,a5
    151e:	fedb0fa3          	sb	a3,-1(s6)
    1522:	b7dd                	j	1508 <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
    1524:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
    1526:	873e                	mv	a4,a5
          longarg = 0;
    1528:	8b72                	mv	s6,t3
          format = 0;
    152a:	8af2                	mv	s5,t3
    152c:	a099                	j	1572 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
    152e:	00170793          	addi	a5,a4,1
    1532:	02b7fb63          	bgeu	a5,a1,1568 <vsnprintf+0x1ba>
    1536:	972a                	add	a4,a4,a0
    1538:	0006aa83          	lw	s5,0(a3)
    153c:	01570023          	sb	s5,0(a4)
    1540:	06a1                	addi	a3,a3,8
    1542:	873e                	mv	a4,a5
          longarg = 0;
    1544:	8b72                	mv	s6,t3
          format = 0;
    1546:	8af2                	mv	s5,t3
    1548:	a02d                	j	1572 <vsnprintf+0x1c4>
    } else if (*s == '%')
    154a:	03f78363          	beq	a5,t6,1570 <vsnprintf+0x1c2>
    else if (++pos < n)
    154e:	00170b93          	addi	s7,a4,1
    1552:	04bbf263          	bgeu	s7,a1,1596 <vsnprintf+0x1e8>
      out[pos - 1] = *s;
    1556:	972a                	add	a4,a4,a0
    1558:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
    155c:	875e                	mv	a4,s7
    155e:	a811                	j	1572 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
    1560:	86de                	mv	a3,s7
          longarg = 0;
    1562:	8b72                	mv	s6,t3
          format = 0;
    1564:	8af2                	mv	s5,t3
    1566:	a031                	j	1572 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
    1568:	873e                	mv	a4,a5
          longarg = 0;
    156a:	8b72                	mv	s6,t3
          format = 0;
    156c:	8af2                	mv	s5,t3
    156e:	a011                	j	1572 <vsnprintf+0x1c4>
      format = 1;
    1570:	8a96                	mv	s5,t0
  for (; *s; s++) {
    1572:	0605                	addi	a2,a2,1
    1574:	00064783          	lbu	a5,0(a2)
    1578:	c38d                	beqz	a5,159a <vsnprintf+0x1ec>
    if (format) {
    157a:	fc0a88e3          	beqz	s5,154a <vsnprintf+0x19c>
      switch (*s) {
    157e:	f9d7879b          	addiw	a5,a5,-99
    1582:	0ff7fb93          	andi	s7,a5,255
    1586:	ff7f66e3          	bltu	t5,s7,1572 <vsnprintf+0x1c4>
    158a:	002b9793          	slli	a5,s7,0x2
    158e:	979a                	add	a5,a5,t1
    1590:	439c                	lw	a5,0(a5)
    1592:	979a                	add	a5,a5,t1
    1594:	8782                	jr	a5
    else if (++pos < n)
    1596:	875e                	mv	a4,s7
    1598:	bfe9                	j	1572 <vsnprintf+0x1c4>
  }
  if (pos < n)
    159a:	02b77363          	bgeu	a4,a1,15c0 <vsnprintf+0x212>
    out[pos] = 0;
    159e:	953a                	add	a0,a0,a4
    15a0:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
    15a4:	0007051b          	sext.w	a0,a4
    15a8:	6426                	ld	s0,72(sp)
    15aa:	6486                	ld	s1,64(sp)
    15ac:	7962                	ld	s2,56(sp)
    15ae:	79c2                	ld	s3,48(sp)
    15b0:	7a22                	ld	s4,40(sp)
    15b2:	7a82                	ld	s5,32(sp)
    15b4:	6b62                	ld	s6,24(sp)
    15b6:	6bc2                	ld	s7,16(sp)
    15b8:	6c22                	ld	s8,8(sp)
    15ba:	6c82                	ld	s9,0(sp)
    15bc:	6161                	addi	sp,sp,80
    15be:	8082                	ret
  else if (n)
    15c0:	d1f5                	beqz	a1,15a4 <vsnprintf+0x1f6>
    out[n - 1] = 0;
    15c2:	95aa                	add	a1,a1,a0
    15c4:	fe058fa3          	sb	zero,-1(a1)
    15c8:	bff1                	j	15a4 <vsnprintf+0x1f6>
  size_t pos = 0;
    15ca:	4701                	li	a4,0
  if (pos < n)
    15cc:	00b77863          	bgeu	a4,a1,15dc <vsnprintf+0x22e>
    out[pos] = 0;
    15d0:	953a                	add	a0,a0,a4
    15d2:	00050023          	sb	zero,0(a0)
}
    15d6:	0007051b          	sext.w	a0,a4
    15da:	8082                	ret
  else if (n)
    15dc:	dded                	beqz	a1,15d6 <vsnprintf+0x228>
    out[n - 1] = 0;
    15de:	95aa                	add	a1,a1,a0
    15e0:	fe058fa3          	sb	zero,-1(a1)
    15e4:	bfcd                	j	15d6 <vsnprintf+0x228>

00000000000015e6 <printf>:
int printf(char*s, ...){
    15e6:	710d                	addi	sp,sp,-352
    15e8:	ee06                	sd	ra,280(sp)
    15ea:	ea22                	sd	s0,272(sp)
    15ec:	1200                	addi	s0,sp,288
    15ee:	e40c                	sd	a1,8(s0)
    15f0:	e810                	sd	a2,16(s0)
    15f2:	ec14                	sd	a3,24(s0)
    15f4:	f018                	sd	a4,32(s0)
    15f6:	f41c                	sd	a5,40(s0)
    15f8:	03043823          	sd	a6,48(s0)
    15fc:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
    1600:	00840693          	addi	a3,s0,8
    1604:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
    1608:	862a                	mv	a2,a0
    160a:	10000593          	li	a1,256
    160e:	ee840513          	addi	a0,s0,-280
    1612:	00000097          	auipc	ra,0x0
    1616:	d9c080e7          	jalr	-612(ra) # 13ae <vsnprintf>
    161a:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
    161c:	0005071b          	sext.w	a4,a0
    1620:	0ff00793          	li	a5,255
    1624:	00e7f463          	bgeu	a5,a4,162c <printf+0x46>
    1628:	10000593          	li	a1,256
    return simple_write(buf, n);
    162c:	ee840513          	addi	a0,s0,-280
    1630:	00000097          	auipc	ra,0x0
    1634:	c10080e7          	jalr	-1008(ra) # 1240 <simple_write>
}
    1638:	2501                	sext.w	a0,a0
    163a:	60f2                	ld	ra,280(sp)
    163c:	6452                	ld	s0,272(sp)
    163e:	6135                	addi	sp,sp,352
    1640:	8082                	ret
