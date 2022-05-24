
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
    1010:	65450513          	addi	a0,a0,1620 # 1660 <printf+0x7e>
    1014:	00000097          	auipc	ra,0x0
    1018:	5ce080e7          	jalr	1486(ra) # 15e2 <printf>
    
    int pid=fork();
    101c:	00000097          	auipc	ra,0x0
    1020:	146080e7          	jalr	326(ra) # 1162 <fork>

    if(pid==0){
    1024:	0005079b          	sext.w	a5,a0
    1028:	efc9                	bnez	a5,10c2 <main+0xc2>
        char *argv[5]={"wait4 ", "and ","execve ", "test!\n", NULL};
    102a:	00000797          	auipc	a5,0x0
    102e:	6b678793          	addi	a5,a5,1718 # 16e0 <printf+0xfe>
    1032:	638c                	ld	a1,0(a5)
    1034:	6790                	ld	a2,8(a5)
    1036:	6b94                	ld	a3,16(a5)
    1038:	6f98                	ld	a4,24(a5)
    103a:	739c                	ld	a5,32(a5)
    103c:	fab43c23          	sd	a1,-72(s0)
    1040:	fcc43023          	sd	a2,-64(s0)
    1044:	fcd43423          	sd	a3,-56(s0)
    1048:	fce43823          	sd	a4,-48(s0)
    104c:	fcf43c23          	sd	a5,-40(s0)
        for(int i=0;i<4;i++){
    1050:	fb840493          	addi	s1,s0,-72
    1054:	fd840913          	addi	s2,s0,-40
            printf(argv[i]);
    1058:	6088                	ld	a0,0(s1)
    105a:	00000097          	auipc	ra,0x0
    105e:	588080e7          	jalr	1416(ra) # 15e2 <printf>
        for(int i=0;i<4;i++){
    1062:	04a1                	addi	s1,s1,8
    1064:	ff249ae3          	bne	s1,s2,1058 <main+0x58>
        }
        printf("\n...................................\n\n");
    1068:	00000517          	auipc	a0,0x0
    106c:	61050513          	addi	a0,a0,1552 # 1678 <printf+0x96>
    1070:	00000097          	auipc	ra,0x0
    1074:	572080e7          	jalr	1394(ra) # 15e2 <printf>
        execve("main",argv, NULL);
    1078:	4601                	li	a2,0
    107a:	fb840593          	addi	a1,s0,-72
    107e:	00000517          	auipc	a0,0x0
    1082:	62250513          	addi	a0,a0,1570 # 16a0 <printf+0xbe>
    1086:	00000097          	auipc	ra,0x0
    108a:	170080e7          	jalr	368(ra) # 11f6 <execve>
        int ret=wait4(-1,&status,0);
        status=status>>8;
        printf("ret=%d, status=%d\n",ret,status);
    }

    pid=fork();
    108e:	00000097          	auipc	ra,0x0
    1092:	0d4080e7          	jalr	212(ra) # 1162 <fork>
    if(pid==0){
    1096:	0005079b          	sext.w	a5,a0
    109a:	e3a5                	bnez	a5,10fa <main+0xfa>
        execve("/getpid",NULL,NULL);
    109c:	4601                	li	a2,0
    109e:	4581                	li	a1,0
    10a0:	00000517          	auipc	a0,0x0
    10a4:	62050513          	addi	a0,a0,1568 # 16c0 <printf+0xde>
    10a8:	00000097          	auipc	ra,0x0
    10ac:	14e080e7          	jalr	334(ra) # 11f6 <execve>
    }
    else{
        wait4(-1,NULL,0);
    }

    printf("\nsyscall test end\n");
    10b0:	00000517          	auipc	a0,0x0
    10b4:	61850513          	addi	a0,a0,1560 # 16c8 <printf+0xe6>
    10b8:	00000097          	auipc	ra,0x0
    10bc:	52a080e7          	jalr	1322(ra) # 15e2 <printf>

    while(1){
    10c0:	a001                	j	10c0 <main+0xc0>
        int status=0;
    10c2:	fa042c23          	sw	zero,-72(s0)
        int ret=wait4(-1,&status,0);
    10c6:	4601                	li	a2,0
    10c8:	fb840593          	addi	a1,s0,-72
    10cc:	557d                	li	a0,-1
    10ce:	00000097          	auipc	ra,0x0
    10d2:	1f0080e7          	jalr	496(ra) # 12be <wait4>
        status=status>>8;
    10d6:	fb842603          	lw	a2,-72(s0)
    10da:	4086561b          	sraiw	a2,a2,0x8
    10de:	fac42c23          	sw	a2,-72(s0)
        printf("ret=%d, status=%d\n",ret,status);
    10e2:	2601                	sext.w	a2,a2
    10e4:	0005059b          	sext.w	a1,a0
    10e8:	00000517          	auipc	a0,0x0
    10ec:	5c050513          	addi	a0,a0,1472 # 16a8 <printf+0xc6>
    10f0:	00000097          	auipc	ra,0x0
    10f4:	4f2080e7          	jalr	1266(ra) # 15e2 <printf>
    10f8:	bf59                	j	108e <main+0x8e>
        wait4(-1,NULL,0);
    10fa:	4601                	li	a2,0
    10fc:	4581                	li	a1,0
    10fe:	557d                	li	a0,-1
    1100:	00000097          	auipc	ra,0x0
    1104:	1be080e7          	jalr	446(ra) # 12be <wait4>
    1108:	b765                	j	10b0 <main+0xb0>

000000000000110a <user_syscall>:
/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
    110a:	715d                	addi	sp,sp,-80
    110c:	e4a2                	sd	s0,72(sp)
    110e:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
    1110:	fea43423          	sd	a0,-24(s0)
    1114:	feb43023          	sd	a1,-32(s0)
    1118:	fcc43c23          	sd	a2,-40(s0)
    111c:	fcd43823          	sd	a3,-48(s0)
    1120:	fce43423          	sd	a4,-56(s0)
    1124:	fcf43023          	sd	a5,-64(s0)
    1128:	fb043c23          	sd	a6,-72(s0)
    112c:	fb143823          	sd	a7,-80(s0)
        asm volatile(   //将参数写入a0-a7寄存器
    1130:	fe843503          	ld	a0,-24(s0)
    1134:	fe043583          	ld	a1,-32(s0)
    1138:	fd843603          	ld	a2,-40(s0)
    113c:	fd043683          	ld	a3,-48(s0)
    1140:	fc843703          	ld	a4,-56(s0)
    1144:	fc043783          	ld	a5,-64(s0)
    1148:	fb843803          	ld	a6,-72(s0)
    114c:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(   //调用ecall
    1150:	00000073          	ecall
    1154:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
    1158:	fe843503          	ld	a0,-24(s0)
    115c:	6426                	ld	s0,72(sp)
    115e:	6161                	addi	sp,sp,80
    1160:	8082                	ret

0000000000001162 <fork>:

//复制一个新进程
uint64 fork(){
    1162:	1141                	addi	sp,sp,-16
    1164:	e406                	sd	ra,8(sp)
    1166:	e022                	sd	s0,0(sp)
    1168:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
    116a:	4885                	li	a7,1
    116c:	4801                	li	a6,0
    116e:	4781                	li	a5,0
    1170:	4701                	li	a4,0
    1172:	4681                	li	a3,0
    1174:	4601                	li	a2,0
    1176:	4581                	li	a1,0
    1178:	4501                	li	a0,0
    117a:	00000097          	auipc	ra,0x0
    117e:	f90080e7          	jalr	-112(ra) # 110a <user_syscall>
}
    1182:	60a2                	ld	ra,8(sp)
    1184:	6402                	ld	s0,0(sp)
    1186:	0141                	addi	sp,sp,16
    1188:	8082                	ret

000000000000118a <open>:

//打开文件
uint64 open(char *file_name, int mode){
    118a:	1141                	addi	sp,sp,-16
    118c:	e406                	sd	ra,8(sp)
    118e:	e022                	sd	s0,0(sp)
    1190:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
    1192:	48bd                	li	a7,15
    1194:	4801                	li	a6,0
    1196:	4781                	li	a5,0
    1198:	4701                	li	a4,0
    119a:	4681                	li	a3,0
    119c:	4601                	li	a2,0
    119e:	00000097          	auipc	ra,0x0
    11a2:	f6c080e7          	jalr	-148(ra) # 110a <user_syscall>
}
    11a6:	60a2                	ld	ra,8(sp)
    11a8:	6402                	ld	s0,0(sp)
    11aa:	0141                	addi	sp,sp,16
    11ac:	8082                	ret

00000000000011ae <read>:

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
    11ae:	1141                	addi	sp,sp,-16
    11b0:	e406                	sd	ra,8(sp)
    11b2:	e022                	sd	s0,0(sp)
    11b4:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
    11b6:	4895                	li	a7,5
    11b8:	4801                	li	a6,0
    11ba:	4781                	li	a5,0
    11bc:	4701                	li	a4,0
    11be:	4681                	li	a3,0
    11c0:	00000097          	auipc	ra,0x0
    11c4:	f4a080e7          	jalr	-182(ra) # 110a <user_syscall>
}
    11c8:	60a2                	ld	ra,8(sp)
    11ca:	6402                	ld	s0,0(sp)
    11cc:	0141                	addi	sp,sp,16
    11ce:	8082                	ret

00000000000011d0 <kill>:

//根据pid杀死进程
uint64 kill(uint64 pid){
    11d0:	1141                	addi	sp,sp,-16
    11d2:	e406                	sd	ra,8(sp)
    11d4:	e022                	sd	s0,0(sp)
    11d6:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
    11d8:	4899                	li	a7,6
    11da:	4801                	li	a6,0
    11dc:	4781                	li	a5,0
    11de:	4701                	li	a4,0
    11e0:	4681                	li	a3,0
    11e2:	4601                	li	a2,0
    11e4:	4581                	li	a1,0
    11e6:	00000097          	auipc	ra,0x0
    11ea:	f24080e7          	jalr	-220(ra) # 110a <user_syscall>
}
    11ee:	60a2                	ld	ra,8(sp)
    11f0:	6402                	ld	s0,0(sp)
    11f2:	0141                	addi	sp,sp,16
    11f4:	8082                	ret

00000000000011f6 <execve>:

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
    11f6:	1141                	addi	sp,sp,-16
    11f8:	e406                	sd	ra,8(sp)
    11fa:	e022                	sd	s0,0(sp)
    11fc:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
    11fe:	0dd00893          	li	a7,221
    1202:	4801                	li	a6,0
    1204:	4781                	li	a5,0
    1206:	4701                	li	a4,0
    1208:	4681                	li	a3,0
    120a:	00000097          	auipc	ra,0x0
    120e:	f00080e7          	jalr	-256(ra) # 110a <user_syscall>
}
    1212:	60a2                	ld	ra,8(sp)
    1214:	6402                	ld	s0,0(sp)
    1216:	0141                	addi	sp,sp,16
    1218:	8082                	ret

000000000000121a <simple_read>:

//从键盘输入字符串
uint64 simple_read(char *s, size_t n){
    121a:	1141                	addi	sp,sp,-16
    121c:	e406                	sd	ra,8(sp)
    121e:	e022                	sd	s0,0(sp)
    1220:	0800                	addi	s0,sp,16
    1222:	862e                	mv	a2,a1
    return user_syscall(0,(uint64)s,n,0,0,0,0,SYS_simple_read);
    1224:	06300893          	li	a7,99
    1228:	4801                	li	a6,0
    122a:	4781                	li	a5,0
    122c:	4701                	li	a4,0
    122e:	4681                	li	a3,0
    1230:	85aa                	mv	a1,a0
    1232:	4501                	li	a0,0
    1234:	00000097          	auipc	ra,0x0
    1238:	ed6080e7          	jalr	-298(ra) # 110a <user_syscall>
}
    123c:	60a2                	ld	ra,8(sp)
    123e:	6402                	ld	s0,0(sp)
    1240:	0141                	addi	sp,sp,16
    1242:	8082                	ret

0000000000001244 <simple_write>:

//输出字符串到屏幕
uint64 simple_write(char *s, size_t n){
    1244:	1141                	addi	sp,sp,-16
    1246:	e406                	sd	ra,8(sp)
    1248:	e022                	sd	s0,0(sp)
    124a:	0800                	addi	s0,sp,16
    124c:	862e                	mv	a2,a1
    return user_syscall(1,(uint64)s,n,0,0,0,0,SYS_simple_write);
    124e:	06400893          	li	a7,100
    1252:	4801                	li	a6,0
    1254:	4781                	li	a5,0
    1256:	4701                	li	a4,0
    1258:	4681                	li	a3,0
    125a:	85aa                	mv	a1,a0
    125c:	4505                	li	a0,1
    125e:	00000097          	auipc	ra,0x0
    1262:	eac080e7          	jalr	-340(ra) # 110a <user_syscall>
}
    1266:	60a2                	ld	ra,8(sp)
    1268:	6402                	ld	s0,0(sp)
    126a:	0141                	addi	sp,sp,16
    126c:	8082                	ret

000000000000126e <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
    126e:	1141                	addi	sp,sp,-16
    1270:	e406                	sd	ra,8(sp)
    1272:	e022                	sd	s0,0(sp)
    1274:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
    1276:	48d5                	li	a7,21
    1278:	4801                	li	a6,0
    127a:	4781                	li	a5,0
    127c:	4701                	li	a4,0
    127e:	4681                	li	a3,0
    1280:	4601                	li	a2,0
    1282:	4581                	li	a1,0
    1284:	00000097          	auipc	ra,0x0
    1288:	e86080e7          	jalr	-378(ra) # 110a <user_syscall>
}
    128c:	60a2                	ld	ra,8(sp)
    128e:	6402                	ld	s0,0(sp)
    1290:	0141                	addi	sp,sp,16
    1292:	8082                	ret

0000000000001294 <clone>:

uint64 clone(uint64 flag, void *stack, size_t sz){
    1294:	1141                	addi	sp,sp,-16
    1296:	e406                	sd	ra,8(sp)
    1298:	e022                	sd	s0,0(sp)
    129a:	0800                	addi	s0,sp,16
    if(stack!=NULL)
    129c:	c191                	beqz	a1,12a0 <clone+0xc>
        stack+=sz;
    129e:	95b2                	add	a1,a1,a2
    return user_syscall(flag,(uint64)stack,0,0,0,0,0,SYS_clone);
    12a0:	0dc00893          	li	a7,220
    12a4:	4801                	li	a6,0
    12a6:	4781                	li	a5,0
    12a8:	4701                	li	a4,0
    12aa:	4681                	li	a3,0
    12ac:	4601                	li	a2,0
    12ae:	00000097          	auipc	ra,0x0
    12b2:	e5c080e7          	jalr	-420(ra) # 110a <user_syscall>
}
    12b6:	60a2                	ld	ra,8(sp)
    12b8:	6402                	ld	s0,0(sp)
    12ba:	0141                	addi	sp,sp,16
    12bc:	8082                	ret

00000000000012be <wait4>:

uint64 wait4(int pid, int *status, uint64 options){
    12be:	1141                	addi	sp,sp,-16
    12c0:	e406                	sd	ra,8(sp)
    12c2:	e022                	sd	s0,0(sp)
    12c4:	0800                	addi	s0,sp,16
    return user_syscall((uint64)pid,(uint64)status,options,0,0,0,0,SYS_wait4);
    12c6:	10400893          	li	a7,260
    12ca:	4801                	li	a6,0
    12cc:	4781                	li	a5,0
    12ce:	4701                	li	a4,0
    12d0:	4681                	li	a3,0
    12d2:	00000097          	auipc	ra,0x0
    12d6:	e38080e7          	jalr	-456(ra) # 110a <user_syscall>
}
    12da:	60a2                	ld	ra,8(sp)
    12dc:	6402                	ld	s0,0(sp)
    12de:	0141                	addi	sp,sp,16
    12e0:	8082                	ret

00000000000012e2 <exit>:

//进程退出
uint64 exit(int code){
    12e2:	1141                	addi	sp,sp,-16
    12e4:	e406                	sd	ra,8(sp)
    12e6:	e022                	sd	s0,0(sp)
    12e8:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
    12ea:	05d00893          	li	a7,93
    12ee:	4801                	li	a6,0
    12f0:	4781                	li	a5,0
    12f2:	4701                	li	a4,0
    12f4:	4681                	li	a3,0
    12f6:	4601                	li	a2,0
    12f8:	4581                	li	a1,0
    12fa:	00000097          	auipc	ra,0x0
    12fe:	e10080e7          	jalr	-496(ra) # 110a <user_syscall>
}
    1302:	60a2                	ld	ra,8(sp)
    1304:	6402                	ld	s0,0(sp)
    1306:	0141                	addi	sp,sp,16
    1308:	8082                	ret

000000000000130a <getppid>:

//获取父进程pid
uint64 getppid(){
    130a:	1141                	addi	sp,sp,-16
    130c:	e406                	sd	ra,8(sp)
    130e:	e022                	sd	s0,0(sp)
    1310:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getppid);
    1312:	0ad00893          	li	a7,173
    1316:	4801                	li	a6,0
    1318:	4781                	li	a5,0
    131a:	4701                	li	a4,0
    131c:	4681                	li	a3,0
    131e:	4601                	li	a2,0
    1320:	4581                	li	a1,0
    1322:	4501                	li	a0,0
    1324:	00000097          	auipc	ra,0x0
    1328:	de6080e7          	jalr	-538(ra) # 110a <user_syscall>
}
    132c:	60a2                	ld	ra,8(sp)
    132e:	6402                	ld	s0,0(sp)
    1330:	0141                	addi	sp,sp,16
    1332:	8082                	ret

0000000000001334 <getpid>:

//获取当前进程pid
uint64 getpid(){
    1334:	1141                	addi	sp,sp,-16
    1336:	e406                	sd	ra,8(sp)
    1338:	e022                	sd	s0,0(sp)
    133a:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getpid);
    133c:	0ac00893          	li	a7,172
    1340:	4801                	li	a6,0
    1342:	4781                	li	a5,0
    1344:	4701                	li	a4,0
    1346:	4681                	li	a3,0
    1348:	4601                	li	a2,0
    134a:	4581                	li	a1,0
    134c:	4501                	li	a0,0
    134e:	00000097          	auipc	ra,0x0
    1352:	dbc080e7          	jalr	-580(ra) # 110a <user_syscall>
}
    1356:	60a2                	ld	ra,8(sp)
    1358:	6402                	ld	s0,0(sp)
    135a:	0141                	addi	sp,sp,16
    135c:	8082                	ret

000000000000135e <brk>:

//改变进程堆内存大小，当addr为0时，返回当前进程大小
int brk(uint64 addr){
    135e:	1141                	addi	sp,sp,-16
    1360:	e406                	sd	ra,8(sp)
    1362:	e022                	sd	s0,0(sp)
    1364:	0800                	addi	s0,sp,16
    return (int)user_syscall(addr,0,0,0,0,0,0,SYS_brk);
    1366:	0d600893          	li	a7,214
    136a:	4801                	li	a6,0
    136c:	4781                	li	a5,0
    136e:	4701                	li	a4,0
    1370:	4681                	li	a3,0
    1372:	4601                	li	a2,0
    1374:	4581                	li	a1,0
    1376:	00000097          	auipc	ra,0x0
    137a:	d94080e7          	jalr	-620(ra) # 110a <user_syscall>
}
    137e:	2501                	sext.w	a0,a0
    1380:	60a2                	ld	ra,8(sp)
    1382:	6402                	ld	s0,0(sp)
    1384:	0141                	addi	sp,sp,16
    1386:	8082                	ret

0000000000001388 <sched_yield>:

//进程放弃cpu
uint64 sched_yield(){
    1388:	1141                	addi	sp,sp,-16
    138a:	e406                	sd	ra,8(sp)
    138c:	e022                	sd	s0,0(sp)
    138e:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_sched_yield);
    1390:	07c00893          	li	a7,124
    1394:	4801                	li	a6,0
    1396:	4781                	li	a5,0
    1398:	4701                	li	a4,0
    139a:	4681                	li	a3,0
    139c:	4601                	li	a2,0
    139e:	4581                	li	a1,0
    13a0:	4501                	li	a0,0
    13a2:	00000097          	auipc	ra,0x0
    13a6:	d68080e7          	jalr	-664(ra) # 110a <user_syscall>
    13aa:	60a2                	ld	ra,8(sp)
    13ac:	6402                	ld	s0,0(sp)
    13ae:	0141                	addi	sp,sp,16
    13b0:	8082                	ret

00000000000013b2 <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
    13b2:	00064783          	lbu	a5,0(a2)
    13b6:	20078863          	beqz	a5,15c6 <vsnprintf+0x214>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
    13ba:	715d                	addi	sp,sp,-80
    13bc:	e4a2                	sd	s0,72(sp)
    13be:	e0a6                	sd	s1,64(sp)
    13c0:	fc4a                	sd	s2,56(sp)
    13c2:	f84e                	sd	s3,48(sp)
    13c4:	f452                	sd	s4,40(sp)
    13c6:	f056                	sd	s5,32(sp)
    13c8:	ec5a                	sd	s6,24(sp)
    13ca:	e85e                	sd	s7,16(sp)
    13cc:	e462                	sd	s8,8(sp)
    13ce:	e066                	sd	s9,0(sp)
    13d0:	0880                	addi	s0,sp,80
  size_t pos = 0;
    13d2:	4801                	li	a6,0
  int longarg = 0;
    13d4:	4b01                	li	s6,0
  int format = 0;
    13d6:	4701                	li	a4,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
    13d8:	02500293          	li	t0,37
      format = 1;
    13dc:	4385                	li	t2,1
    13de:	4fd5                	li	t6,21
    13e0:	00000e97          	auipc	t4,0x0
    13e4:	328e8e93          	addi	t4,t4,808 # 1708 <printf+0x126>
          longarg = 0;
    13e8:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
    13ea:	48a9                	li	a7,10
            if (++pos < n) out[pos - 1] = '-';
    13ec:	02d00a93          	li	s5,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    13f0:	4f25                	li	t5,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    13f2:	5371                	li	t1,-4
    13f4:	44bd                	li	s1,15
    13f6:	4a1d                	li	s4,7
          if (++pos < n) out[pos - 1] = 'x';
    13f8:	07800993          	li	s3,120
          if (++pos < n) out[pos - 1] = '0';
    13fc:	03000913          	li	s2,48
    1400:	aaa5                	j	1578 <vsnprintf+0x1c6>
    if (format) {
    1402:	8b3a                	mv	s6,a4
    1404:	a2b5                	j	1570 <vsnprintf+0x1be>
          if (++pos < n) out[pos - 1] = '0';
    1406:	00180793          	addi	a5,a6,1
    140a:	00b7f663          	bgeu	a5,a1,1416 <vsnprintf+0x64>
    140e:	01050733          	add	a4,a0,a6
    1412:	01270023          	sb	s2,0(a4)
          if (++pos < n) out[pos - 1] = 'x';
    1416:	0809                	addi	a6,a6,2
    1418:	00b87563          	bgeu	a6,a1,1422 <vsnprintf+0x70>
    141c:	97aa                	add	a5,a5,a0
    141e:	01378023          	sb	s3,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1422:	0006bc03          	ld	s8,0(a3)
    1426:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    1428:	87a6                	mv	a5,s1
    142a:	00078c9b          	sext.w	s9,a5
    142e:	078a                	slli	a5,a5,0x2
    1430:	8742                	mv	a4,a6
    1432:	a839                	j	1450 <vsnprintf+0x9e>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1434:	fe0b17e3          	bnez	s6,1422 <vsnprintf+0x70>
    1438:	0006ac03          	lw	s8,0(a3)
    143c:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    143e:	87d2                	mv	a5,s4
    1440:	b7ed                	j	142a <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    1442:	00e50b33          	add	s6,a0,a4
    1446:	ff7b0fa3          	sb	s7,-1(s6)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    144a:	37f1                	addiw	a5,a5,-4
    144c:	02678063          	beq	a5,t1,146c <vsnprintf+0xba>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    1450:	0705                	addi	a4,a4,1
    1452:	feb77ce3          	bgeu	a4,a1,144a <vsnprintf+0x98>
            int d = (num >> (4 * i)) & 0xF;
    1456:	40fc5b33          	sra	s6,s8,a5
    145a:	00fb7b13          	andi	s6,s6,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    145e:	057b0b93          	addi	s7,s6,87
    1462:	ff6f40e3          	blt	t5,s6,1442 <vsnprintf+0x90>
    1466:	030b0b93          	addi	s7,s6,48
    146a:	bfe1                	j	1442 <vsnprintf+0x90>
    146c:	0805                	addi	a6,a6,1
    146e:	9866                	add	a6,a6,s9
          longarg = 0;
    1470:	8b72                	mv	s6,t3
          format = 0;
    1472:	8772                	mv	a4,t3
    1474:	a8f5                	j	1570 <vsnprintf+0x1be>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1476:	020b0563          	beqz	s6,14a0 <vsnprintf+0xee>
    147a:	6298                	ld	a4,0(a3)
    147c:	06a1                	addi	a3,a3,8
          if (num < 0) {
    147e:	02074463          	bltz	a4,14a6 <vsnprintf+0xf4>
          for (long nn = num; nn /= 10; digits++)
    1482:	031747b3          	div	a5,a4,a7
    1486:	cf8d                	beqz	a5,14c0 <vsnprintf+0x10e>
          long digits = 1;
    1488:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
    148a:	0b05                	addi	s6,s6,1
    148c:	0317c7b3          	div	a5,a5,a7
    1490:	ffed                	bnez	a5,148a <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
    1492:	fffb079b          	addiw	a5,s6,-1
    1496:	0407cd63          	bltz	a5,14f0 <vsnprintf+0x13e>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
    149a:	00180c13          	addi	s8,a6,1
    149e:	a81d                	j	14d4 <vsnprintf+0x122>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    14a0:	4298                	lw	a4,0(a3)
    14a2:	06a1                	addi	a3,a3,8
    14a4:	bfe9                	j	147e <vsnprintf+0xcc>
            num = -num;
    14a6:	40e00733          	neg	a4,a4
            if (++pos < n) out[pos - 1] = '-';
    14aa:	00180793          	addi	a5,a6,1
    14ae:	00b7f763          	bgeu	a5,a1,14bc <vsnprintf+0x10a>
    14b2:	982a                	add	a6,a6,a0
    14b4:	01580023          	sb	s5,0(a6)
    14b8:	883e                	mv	a6,a5
    14ba:	b7e1                	j	1482 <vsnprintf+0xd0>
    14bc:	883e                	mv	a6,a5
    14be:	b7d1                	j	1482 <vsnprintf+0xd0>
          long digits = 1;
    14c0:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
    14c2:	87f2                	mv	a5,t3
    14c4:	bfd9                	j	149a <vsnprintf+0xe8>
            num /= 10;
    14c6:	03174733          	div	a4,a4,a7
          for (int i = digits - 1; i >= 0; i--) {
    14ca:	17fd                	addi	a5,a5,-1
    14cc:	00078b9b          	sext.w	s7,a5
    14d0:	020bc063          	bltz	s7,14f0 <vsnprintf+0x13e>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
    14d4:	00fc0bb3          	add	s7,s8,a5
    14d8:	febbf7e3          	bgeu	s7,a1,14c6 <vsnprintf+0x114>
    14dc:	00f80bb3          	add	s7,a6,a5
    14e0:	9baa                	add	s7,s7,a0
    14e2:	03176cb3          	rem	s9,a4,a7
    14e6:	030c8c9b          	addiw	s9,s9,48
    14ea:	019b8023          	sb	s9,0(s7)
    14ee:	bfe1                	j	14c6 <vsnprintf+0x114>
          pos += digits;
    14f0:	985a                	add	a6,a6,s6
          longarg = 0;
    14f2:	8b72                	mv	s6,t3
          format = 0;
    14f4:	8772                	mv	a4,t3
          break;
    14f6:	a8ad                	j	1570 <vsnprintf+0x1be>
          const char* s2 = va_arg(vl, const char*);
    14f8:	00868b93          	addi	s7,a3,8
    14fc:	6294                	ld	a3,0(a3)
          while (*s2) {
    14fe:	0006c703          	lbu	a4,0(a3)
    1502:	cf31                	beqz	a4,155e <vsnprintf+0x1ac>
    1504:	87c2                	mv	a5,a6
    1506:	a039                	j	1514 <vsnprintf+0x162>
    1508:	41078733          	sub	a4,a5,a6
    150c:	9736                	add	a4,a4,a3
    150e:	00074703          	lbu	a4,0(a4)
    1512:	cb09                	beqz	a4,1524 <vsnprintf+0x172>
            if (++pos < n) out[pos - 1] = *s2;
    1514:	0785                	addi	a5,a5,1
    1516:	feb7f9e3          	bgeu	a5,a1,1508 <vsnprintf+0x156>
    151a:	00f50b33          	add	s6,a0,a5
    151e:	feeb0fa3          	sb	a4,-1(s6)
    1522:	b7dd                	j	1508 <vsnprintf+0x156>
          const char* s2 = va_arg(vl, const char*);
    1524:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
    1526:	883e                	mv	a6,a5
          longarg = 0;
    1528:	8b72                	mv	s6,t3
          format = 0;
    152a:	8772                	mv	a4,t3
    152c:	a091                	j	1570 <vsnprintf+0x1be>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
    152e:	00180793          	addi	a5,a6,1
    1532:	02b7fa63          	bgeu	a5,a1,1566 <vsnprintf+0x1b4>
    1536:	982a                	add	a6,a6,a0
    1538:	4298                	lw	a4,0(a3)
    153a:	00e80023          	sb	a4,0(a6)
    153e:	06a1                	addi	a3,a3,8
    1540:	883e                	mv	a6,a5
          longarg = 0;
    1542:	8b72                	mv	s6,t3
          format = 0;
    1544:	8772                	mv	a4,t3
    1546:	a02d                	j	1570 <vsnprintf+0x1be>
    } else if (*s == '%')
    1548:	02578363          	beq	a5,t0,156e <vsnprintf+0x1bc>
    else if (++pos < n)
    154c:	00180b93          	addi	s7,a6,1
    1550:	04bbf163          	bgeu	s7,a1,1592 <vsnprintf+0x1e0>
      out[pos - 1] = *s;
    1554:	982a                	add	a6,a6,a0
    1556:	00f80023          	sb	a5,0(a6)
    else if (++pos < n)
    155a:	885e                	mv	a6,s7
    155c:	a811                	j	1570 <vsnprintf+0x1be>
          const char* s2 = va_arg(vl, const char*);
    155e:	86de                	mv	a3,s7
          longarg = 0;
    1560:	8b72                	mv	s6,t3
          format = 0;
    1562:	8772                	mv	a4,t3
    1564:	a031                	j	1570 <vsnprintf+0x1be>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
    1566:	883e                	mv	a6,a5
          longarg = 0;
    1568:	8b72                	mv	s6,t3
          format = 0;
    156a:	8772                	mv	a4,t3
    156c:	a011                	j	1570 <vsnprintf+0x1be>
      format = 1;
    156e:	871e                	mv	a4,t2
  for (; *s; s++) {
    1570:	0605                	addi	a2,a2,1
    1572:	00064783          	lbu	a5,0(a2)
    1576:	c385                	beqz	a5,1596 <vsnprintf+0x1e4>
    if (format) {
    1578:	db61                	beqz	a4,1548 <vsnprintf+0x196>
      switch (*s) {
    157a:	f9d7879b          	addiw	a5,a5,-99
    157e:	0ff7fb93          	andi	s7,a5,255
    1582:	ff7fe7e3          	bltu	t6,s7,1570 <vsnprintf+0x1be>
    1586:	002b9793          	slli	a5,s7,0x2
    158a:	97f6                	add	a5,a5,t4
    158c:	439c                	lw	a5,0(a5)
    158e:	97f6                	add	a5,a5,t4
    1590:	8782                	jr	a5
    else if (++pos < n)
    1592:	885e                	mv	a6,s7
    1594:	bff1                	j	1570 <vsnprintf+0x1be>
  }
  if (pos < n)
    1596:	02b87363          	bgeu	a6,a1,15bc <vsnprintf+0x20a>
    out[pos] = 0;
    159a:	9542                	add	a0,a0,a6
    159c:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
    15a0:	0008051b          	sext.w	a0,a6
    15a4:	6426                	ld	s0,72(sp)
    15a6:	6486                	ld	s1,64(sp)
    15a8:	7962                	ld	s2,56(sp)
    15aa:	79c2                	ld	s3,48(sp)
    15ac:	7a22                	ld	s4,40(sp)
    15ae:	7a82                	ld	s5,32(sp)
    15b0:	6b62                	ld	s6,24(sp)
    15b2:	6bc2                	ld	s7,16(sp)
    15b4:	6c22                	ld	s8,8(sp)
    15b6:	6c82                	ld	s9,0(sp)
    15b8:	6161                	addi	sp,sp,80
    15ba:	8082                	ret
  else if (n)
    15bc:	d1f5                	beqz	a1,15a0 <vsnprintf+0x1ee>
    out[n - 1] = 0;
    15be:	95aa                	add	a1,a1,a0
    15c0:	fe058fa3          	sb	zero,-1(a1)
    15c4:	bff1                	j	15a0 <vsnprintf+0x1ee>
  size_t pos = 0;
    15c6:	4801                	li	a6,0
  if (pos < n)
    15c8:	00b87863          	bgeu	a6,a1,15d8 <vsnprintf+0x226>
    out[pos] = 0;
    15cc:	9542                	add	a0,a0,a6
    15ce:	00050023          	sb	zero,0(a0)
}
    15d2:	0008051b          	sext.w	a0,a6
    15d6:	8082                	ret
  else if (n)
    15d8:	dded                	beqz	a1,15d2 <vsnprintf+0x220>
    out[n - 1] = 0;
    15da:	95aa                	add	a1,a1,a0
    15dc:	fe058fa3          	sb	zero,-1(a1)
    15e0:	bfcd                	j	15d2 <vsnprintf+0x220>

00000000000015e2 <printf>:
int printf(char*s, ...){
    15e2:	710d                	addi	sp,sp,-352
    15e4:	ee06                	sd	ra,280(sp)
    15e6:	ea22                	sd	s0,272(sp)
    15e8:	1200                	addi	s0,sp,288
    15ea:	e40c                	sd	a1,8(s0)
    15ec:	e810                	sd	a2,16(s0)
    15ee:	ec14                	sd	a3,24(s0)
    15f0:	f018                	sd	a4,32(s0)
    15f2:	f41c                	sd	a5,40(s0)
    15f4:	03043823          	sd	a6,48(s0)
    15f8:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
    15fc:	00840693          	addi	a3,s0,8
    1600:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
    1604:	862a                	mv	a2,a0
    1606:	10000593          	li	a1,256
    160a:	ee840513          	addi	a0,s0,-280
    160e:	00000097          	auipc	ra,0x0
    1612:	da4080e7          	jalr	-604(ra) # 13b2 <vsnprintf>
    1616:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
    1618:	0005071b          	sext.w	a4,a0
    161c:	0ff00793          	li	a5,255
    1620:	00e7f463          	bgeu	a5,a4,1628 <printf+0x46>
    1624:	10000593          	li	a1,256
    return simple_write(buf, n);
    1628:	ee840513          	addi	a0,s0,-280
    162c:	00000097          	auipc	ra,0x0
    1630:	c18080e7          	jalr	-1000(ra) # 1244 <simple_write>
}
    1634:	2501                	sext.w	a0,a0
    1636:	60f2                	ld	ra,280(sp)
    1638:	6452                	ld	s0,272(sp)
    163a:	6135                	addi	sp,sp,352
    163c:	8082                	ret
