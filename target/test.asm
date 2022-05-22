
target/test.out：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
int const test_file_num = sizeof(test_files) / sizeof(char const*);

void main(void) __attribute__((naked));
void main(void) {

	for (int i = 0; i < test_file_num; i ++) {
    1000:	00000497          	auipc	s1,0x0
    1004:	63848493          	addi	s1,s1,1592 # 1638 <test_files>
    1008:	00000917          	auipc	s2,0x0
    100c:	68890913          	addi	s2,s2,1672 # 1690 <test_file_num>
    1010:	a819                	j	1026 <main+0x26>
		if (fork() == 0) {
			execve(test_files[i],NULL , NULL);
		}
		else {
			wait4(-1,NULL,0);
    1012:	4601                	li	a2,0
    1014:	4581                	li	a1,0
    1016:	557d                	li	a0,-1
    1018:	00000097          	auipc	ra,0x0
    101c:	1e6080e7          	jalr	486(ra) # 11fe <wait4>
    1020:	04a1                	addi	s1,s1,8
	for (int i = 0; i < test_file_num; i ++) {
    1022:	01248f63          	beq	s1,s2,1040 <main+0x40>
		if (fork() == 0) {
    1026:	00000097          	auipc	ra,0x0
    102a:	07c080e7          	jalr	124(ra) # 10a2 <fork>
    102e:	f175                	bnez	a0,1012 <main+0x12>
			execve(test_files[i],NULL , NULL);
    1030:	4601                	li	a2,0
    1032:	4581                	li	a1,0
    1034:	6088                	ld	a0,0(s1)
    1036:	00000097          	auipc	ra,0x0
    103a:	100080e7          	jalr	256(ra) # 1136 <execve>
    103e:	b7cd                	j	1020 <main+0x20>
		}
	}
	
	exit(0);
    1040:	4501                	li	a0,0
    1042:	00000097          	auipc	ra,0x0
    1046:	1e0080e7          	jalr	480(ra) # 1222 <exit>

000000000000104a <user_syscall>:
/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
    104a:	715d                	addi	sp,sp,-80
    104c:	e4a2                	sd	s0,72(sp)
    104e:	0880                	addi	s0,sp,80
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
    1050:	fea43423          	sd	a0,-24(s0)
    1054:	feb43023          	sd	a1,-32(s0)
    1058:	fcc43c23          	sd	a2,-40(s0)
    105c:	fcd43823          	sd	a3,-48(s0)
    1060:	fce43423          	sd	a4,-56(s0)
    1064:	fcf43023          	sd	a5,-64(s0)
    1068:	fb043c23          	sd	a6,-72(s0)
    106c:	fb143823          	sd	a7,-80(s0)
        asm volatile(   //将参数写入a0-a7寄存器
    1070:	fe843503          	ld	a0,-24(s0)
    1074:	fe043583          	ld	a1,-32(s0)
    1078:	fd843603          	ld	a2,-40(s0)
    107c:	fd043683          	ld	a3,-48(s0)
    1080:	fc843703          	ld	a4,-56(s0)
    1084:	fc043783          	ld	a5,-64(s0)
    1088:	fb843803          	ld	a6,-72(s0)
    108c:	fb043883          	ld	a7,-80(s0)
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(   //调用ecall
    1090:	00000073          	ecall
    1094:	fea43423          	sd	a0,-24(s0)
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}
    1098:	fe843503          	ld	a0,-24(s0)
    109c:	6426                	ld	s0,72(sp)
    109e:	6161                	addi	sp,sp,80
    10a0:	8082                	ret

00000000000010a2 <fork>:

//复制一个新进程
uint64 fork(){
    10a2:	1141                	addi	sp,sp,-16
    10a4:	e406                	sd	ra,8(sp)
    10a6:	e022                	sd	s0,0(sp)
    10a8:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
    10aa:	4885                	li	a7,1
    10ac:	4801                	li	a6,0
    10ae:	4781                	li	a5,0
    10b0:	4701                	li	a4,0
    10b2:	4681                	li	a3,0
    10b4:	4601                	li	a2,0
    10b6:	4581                	li	a1,0
    10b8:	4501                	li	a0,0
    10ba:	00000097          	auipc	ra,0x0
    10be:	f90080e7          	jalr	-112(ra) # 104a <user_syscall>
}
    10c2:	60a2                	ld	ra,8(sp)
    10c4:	6402                	ld	s0,0(sp)
    10c6:	0141                	addi	sp,sp,16
    10c8:	8082                	ret

00000000000010ca <open>:

//打开文件
uint64 open(char *file_name, int mode){
    10ca:	1141                	addi	sp,sp,-16
    10cc:	e406                	sd	ra,8(sp)
    10ce:	e022                	sd	s0,0(sp)
    10d0:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
    10d2:	48bd                	li	a7,15
    10d4:	4801                	li	a6,0
    10d6:	4781                	li	a5,0
    10d8:	4701                	li	a4,0
    10da:	4681                	li	a3,0
    10dc:	4601                	li	a2,0
    10de:	00000097          	auipc	ra,0x0
    10e2:	f6c080e7          	jalr	-148(ra) # 104a <user_syscall>
}
    10e6:	60a2                	ld	ra,8(sp)
    10e8:	6402                	ld	s0,0(sp)
    10ea:	0141                	addi	sp,sp,16
    10ec:	8082                	ret

00000000000010ee <read>:

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
    10ee:	1141                	addi	sp,sp,-16
    10f0:	e406                	sd	ra,8(sp)
    10f2:	e022                	sd	s0,0(sp)
    10f4:	0800                	addi	s0,sp,16
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
    10f6:	4895                	li	a7,5
    10f8:	4801                	li	a6,0
    10fa:	4781                	li	a5,0
    10fc:	4701                	li	a4,0
    10fe:	4681                	li	a3,0
    1100:	00000097          	auipc	ra,0x0
    1104:	f4a080e7          	jalr	-182(ra) # 104a <user_syscall>
}
    1108:	60a2                	ld	ra,8(sp)
    110a:	6402                	ld	s0,0(sp)
    110c:	0141                	addi	sp,sp,16
    110e:	8082                	ret

0000000000001110 <kill>:

//根据pid杀死进程
uint64 kill(uint64 pid){
    1110:	1141                	addi	sp,sp,-16
    1112:	e406                	sd	ra,8(sp)
    1114:	e022                	sd	s0,0(sp)
    1116:	0800                	addi	s0,sp,16
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
    1118:	4899                	li	a7,6
    111a:	4801                	li	a6,0
    111c:	4781                	li	a5,0
    111e:	4701                	li	a4,0
    1120:	4681                	li	a3,0
    1122:	4601                	li	a2,0
    1124:	4581                	li	a1,0
    1126:	00000097          	auipc	ra,0x0
    112a:	f24080e7          	jalr	-220(ra) # 104a <user_syscall>
}
    112e:	60a2                	ld	ra,8(sp)
    1130:	6402                	ld	s0,0(sp)
    1132:	0141                	addi	sp,sp,16
    1134:	8082                	ret

0000000000001136 <execve>:

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
    1136:	1141                	addi	sp,sp,-16
    1138:	e406                	sd	ra,8(sp)
    113a:	e022                	sd	s0,0(sp)
    113c:	0800                	addi	s0,sp,16
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
    113e:	0dd00893          	li	a7,221
    1142:	4801                	li	a6,0
    1144:	4781                	li	a5,0
    1146:	4701                	li	a4,0
    1148:	4681                	li	a3,0
    114a:	00000097          	auipc	ra,0x0
    114e:	f00080e7          	jalr	-256(ra) # 104a <user_syscall>
}
    1152:	60a2                	ld	ra,8(sp)
    1154:	6402                	ld	s0,0(sp)
    1156:	0141                	addi	sp,sp,16
    1158:	8082                	ret

000000000000115a <simple_read>:

//从键盘输入字符串
uint64 simple_read(char *s, size_t n){
    115a:	1141                	addi	sp,sp,-16
    115c:	e406                	sd	ra,8(sp)
    115e:	e022                	sd	s0,0(sp)
    1160:	0800                	addi	s0,sp,16
    return user_syscall(0,(uint64)s,n,0,0,0,0,SYS_simple_read);
    1162:	06300893          	li	a7,99
    1166:	4801                	li	a6,0
    1168:	4781                	li	a5,0
    116a:	4701                	li	a4,0
    116c:	4681                	li	a3,0
    116e:	862e                	mv	a2,a1
    1170:	85aa                	mv	a1,a0
    1172:	4501                	li	a0,0
    1174:	00000097          	auipc	ra,0x0
    1178:	ed6080e7          	jalr	-298(ra) # 104a <user_syscall>
}
    117c:	60a2                	ld	ra,8(sp)
    117e:	6402                	ld	s0,0(sp)
    1180:	0141                	addi	sp,sp,16
    1182:	8082                	ret

0000000000001184 <simple_write>:

//输出字符串到屏幕
uint64 simple_write(char *s, size_t n){
    1184:	1141                	addi	sp,sp,-16
    1186:	e406                	sd	ra,8(sp)
    1188:	e022                	sd	s0,0(sp)
    118a:	0800                	addi	s0,sp,16
    return user_syscall(1,(uint64)s,n,0,0,0,0,SYS_simple_write);
    118c:	06400893          	li	a7,100
    1190:	4801                	li	a6,0
    1192:	4781                	li	a5,0
    1194:	4701                	li	a4,0
    1196:	4681                	li	a3,0
    1198:	862e                	mv	a2,a1
    119a:	85aa                	mv	a1,a0
    119c:	4505                	li	a0,1
    119e:	00000097          	auipc	ra,0x0
    11a2:	eac080e7          	jalr	-340(ra) # 104a <user_syscall>
}
    11a6:	60a2                	ld	ra,8(sp)
    11a8:	6402                	ld	s0,0(sp)
    11aa:	0141                	addi	sp,sp,16
    11ac:	8082                	ret

00000000000011ae <close>:

//根据文件描述符关闭文件
uint64 close(int fd){
    11ae:	1141                	addi	sp,sp,-16
    11b0:	e406                	sd	ra,8(sp)
    11b2:	e022                	sd	s0,0(sp)
    11b4:	0800                	addi	s0,sp,16
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
    11b6:	48d5                	li	a7,21
    11b8:	4801                	li	a6,0
    11ba:	4781                	li	a5,0
    11bc:	4701                	li	a4,0
    11be:	4681                	li	a3,0
    11c0:	4601                	li	a2,0
    11c2:	4581                	li	a1,0
    11c4:	00000097          	auipc	ra,0x0
    11c8:	e86080e7          	jalr	-378(ra) # 104a <user_syscall>
}
    11cc:	60a2                	ld	ra,8(sp)
    11ce:	6402                	ld	s0,0(sp)
    11d0:	0141                	addi	sp,sp,16
    11d2:	8082                	ret

00000000000011d4 <clone>:

uint64 clone(uint64 flag, void *stack, size_t sz){
    11d4:	1141                	addi	sp,sp,-16
    11d6:	e406                	sd	ra,8(sp)
    11d8:	e022                	sd	s0,0(sp)
    11da:	0800                	addi	s0,sp,16
    if(stack!=NULL)
    11dc:	c191                	beqz	a1,11e0 <clone+0xc>
        stack+=sz;
    11de:	95b2                	add	a1,a1,a2
    return user_syscall(flag,(uint64)stack,0,0,0,0,0,SYS_clone);
    11e0:	0dc00893          	li	a7,220
    11e4:	4801                	li	a6,0
    11e6:	4781                	li	a5,0
    11e8:	4701                	li	a4,0
    11ea:	4681                	li	a3,0
    11ec:	4601                	li	a2,0
    11ee:	00000097          	auipc	ra,0x0
    11f2:	e5c080e7          	jalr	-420(ra) # 104a <user_syscall>
}
    11f6:	60a2                	ld	ra,8(sp)
    11f8:	6402                	ld	s0,0(sp)
    11fa:	0141                	addi	sp,sp,16
    11fc:	8082                	ret

00000000000011fe <wait4>:

uint64 wait4(int pid, int *status, uint64 options){
    11fe:	1141                	addi	sp,sp,-16
    1200:	e406                	sd	ra,8(sp)
    1202:	e022                	sd	s0,0(sp)
    1204:	0800                	addi	s0,sp,16
    return user_syscall((uint64)pid,(uint64)status,options,0,0,0,0,SYS_wait4);
    1206:	10400893          	li	a7,260
    120a:	4801                	li	a6,0
    120c:	4781                	li	a5,0
    120e:	4701                	li	a4,0
    1210:	4681                	li	a3,0
    1212:	00000097          	auipc	ra,0x0
    1216:	e38080e7          	jalr	-456(ra) # 104a <user_syscall>
}
    121a:	60a2                	ld	ra,8(sp)
    121c:	6402                	ld	s0,0(sp)
    121e:	0141                	addi	sp,sp,16
    1220:	8082                	ret

0000000000001222 <exit>:

//进程退出
uint64 exit(int code){
    1222:	1141                	addi	sp,sp,-16
    1224:	e406                	sd	ra,8(sp)
    1226:	e022                	sd	s0,0(sp)
    1228:	0800                	addi	s0,sp,16
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
    122a:	05d00893          	li	a7,93
    122e:	4801                	li	a6,0
    1230:	4781                	li	a5,0
    1232:	4701                	li	a4,0
    1234:	4681                	li	a3,0
    1236:	4601                	li	a2,0
    1238:	4581                	li	a1,0
    123a:	00000097          	auipc	ra,0x0
    123e:	e10080e7          	jalr	-496(ra) # 104a <user_syscall>
}
    1242:	60a2                	ld	ra,8(sp)
    1244:	6402                	ld	s0,0(sp)
    1246:	0141                	addi	sp,sp,16
    1248:	8082                	ret

000000000000124a <getppid>:

//获取父进程pid
uint64 getppid(){
    124a:	1141                	addi	sp,sp,-16
    124c:	e406                	sd	ra,8(sp)
    124e:	e022                	sd	s0,0(sp)
    1250:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getppid);
    1252:	0ad00893          	li	a7,173
    1256:	4801                	li	a6,0
    1258:	4781                	li	a5,0
    125a:	4701                	li	a4,0
    125c:	4681                	li	a3,0
    125e:	4601                	li	a2,0
    1260:	4581                	li	a1,0
    1262:	4501                	li	a0,0
    1264:	00000097          	auipc	ra,0x0
    1268:	de6080e7          	jalr	-538(ra) # 104a <user_syscall>
}
    126c:	60a2                	ld	ra,8(sp)
    126e:	6402                	ld	s0,0(sp)
    1270:	0141                	addi	sp,sp,16
    1272:	8082                	ret

0000000000001274 <getpid>:

//获取当前进程pid
uint64 getpid(){
    1274:	1141                	addi	sp,sp,-16
    1276:	e406                	sd	ra,8(sp)
    1278:	e022                	sd	s0,0(sp)
    127a:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_getpid);
    127c:	0ac00893          	li	a7,172
    1280:	4801                	li	a6,0
    1282:	4781                	li	a5,0
    1284:	4701                	li	a4,0
    1286:	4681                	li	a3,0
    1288:	4601                	li	a2,0
    128a:	4581                	li	a1,0
    128c:	4501                	li	a0,0
    128e:	00000097          	auipc	ra,0x0
    1292:	dbc080e7          	jalr	-580(ra) # 104a <user_syscall>
}
    1296:	60a2                	ld	ra,8(sp)
    1298:	6402                	ld	s0,0(sp)
    129a:	0141                	addi	sp,sp,16
    129c:	8082                	ret

000000000000129e <brk>:

//改变进程堆内存大小，当addr为0时，返回当前进程大小
int brk(uint64 addr){
    129e:	1141                	addi	sp,sp,-16
    12a0:	e406                	sd	ra,8(sp)
    12a2:	e022                	sd	s0,0(sp)
    12a4:	0800                	addi	s0,sp,16
    return (int)user_syscall(addr,0,0,0,0,0,0,SYS_brk);
    12a6:	0d600893          	li	a7,214
    12aa:	4801                	li	a6,0
    12ac:	4781                	li	a5,0
    12ae:	4701                	li	a4,0
    12b0:	4681                	li	a3,0
    12b2:	4601                	li	a2,0
    12b4:	4581                	li	a1,0
    12b6:	00000097          	auipc	ra,0x0
    12ba:	d94080e7          	jalr	-620(ra) # 104a <user_syscall>
}
    12be:	2501                	sext.w	a0,a0
    12c0:	60a2                	ld	ra,8(sp)
    12c2:	6402                	ld	s0,0(sp)
    12c4:	0141                	addi	sp,sp,16
    12c6:	8082                	ret

00000000000012c8 <sched_yield>:

//进程放弃cpu
uint64 sched_yield(){
    12c8:	1141                	addi	sp,sp,-16
    12ca:	e406                	sd	ra,8(sp)
    12cc:	e022                	sd	s0,0(sp)
    12ce:	0800                	addi	s0,sp,16
    return user_syscall(0,0,0,0,0,0,0,SYS_sched_yield);
    12d0:	07c00893          	li	a7,124
    12d4:	4801                	li	a6,0
    12d6:	4781                	li	a5,0
    12d8:	4701                	li	a4,0
    12da:	4681                	li	a3,0
    12dc:	4601                	li	a2,0
    12de:	4581                	li	a1,0
    12e0:	4501                	li	a0,0
    12e2:	00000097          	auipc	ra,0x0
    12e6:	d68080e7          	jalr	-664(ra) # 104a <user_syscall>
    12ea:	60a2                	ld	ra,8(sp)
    12ec:	6402                	ld	s0,0(sp)
    12ee:	0141                	addi	sp,sp,16
    12f0:	8082                	ret

00000000000012f2 <vsnprintf>:
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
  int format = 0;
  int longarg = 0;
  size_t pos = 0;

  for (; *s; s++) {
    12f2:	00064783          	lbu	a5,0(a2)
    12f6:	20078c63          	beqz	a5,150e <vsnprintf+0x21c>
int vsnprintf(char* out, size_t n, const char* s, va_list vl) {
    12fa:	715d                	addi	sp,sp,-80
    12fc:	e4a2                	sd	s0,72(sp)
    12fe:	e0a6                	sd	s1,64(sp)
    1300:	fc4a                	sd	s2,56(sp)
    1302:	f84e                	sd	s3,48(sp)
    1304:	f452                	sd	s4,40(sp)
    1306:	f056                	sd	s5,32(sp)
    1308:	ec5a                	sd	s6,24(sp)
    130a:	e85e                	sd	s7,16(sp)
    130c:	e462                	sd	s8,8(sp)
    130e:	e066                	sd	s9,0(sp)
    1310:	0880                	addi	s0,sp,80
  size_t pos = 0;
    1312:	4701                	li	a4,0
  int longarg = 0;
    1314:	4b01                	li	s6,0
  int format = 0;
    1316:	4a81                	li	s5,0
          break;
        }
        default:
          break;
      }
    } else if (*s == '%')
    1318:	02500f93          	li	t6,37
      format = 1;
    131c:	4285                	li	t0,1
      switch (*s) {
    131e:	4f55                	li	t5,21
    1320:	00000317          	auipc	t1,0x0
    1324:	2c030313          	addi	t1,t1,704 # 15e0 <printf+0xb6>
          longarg = 0;
    1328:	4e01                	li	t3,0
          for (long nn = num; nn /= 10; digits++)
    132a:	4829                	li	a6,10
            if (++pos < n) out[pos - 1] = '-';
    132c:	02d00a13          	li	s4,45
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    1330:	4ea5                	li	t4,9
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    1332:	58fd                	li	a7,-1
    1334:	43bd                	li	t2,15
    1336:	499d                	li	s3,7
          if (++pos < n) out[pos - 1] = 'x';
    1338:	07800913          	li	s2,120
          if (++pos < n) out[pos - 1] = '0';
    133c:	03000493          	li	s1,48
    1340:	aabd                	j	14be <vsnprintf+0x1cc>
          longarg = 1;
    1342:	8b56                	mv	s6,s5
    1344:	aa8d                	j	14b6 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = '0';
    1346:	00170793          	addi	a5,a4,1
    134a:	00b7f663          	bgeu	a5,a1,1356 <vsnprintf+0x64>
    134e:	00e50ab3          	add	s5,a0,a4
    1352:	009a8023          	sb	s1,0(s5)
          if (++pos < n) out[pos - 1] = 'x';
    1356:	0709                	addi	a4,a4,2
    1358:	00b77563          	bgeu	a4,a1,1362 <vsnprintf+0x70>
    135c:	97aa                	add	a5,a5,a0
    135e:	01278023          	sb	s2,0(a5)
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1362:	0006bc03          	ld	s8,0(a3)
    1366:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    1368:	8c9e                	mv	s9,t2
    136a:	8b66                	mv	s6,s9
    136c:	8aba                	mv	s5,a4
    136e:	a839                	j	138c <vsnprintf+0x9a>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    1370:	fe0b19e3          	bnez	s6,1362 <vsnprintf+0x70>
    1374:	0006ac03          	lw	s8,0(a3)
    1378:	06a1                	addi	a3,a3,8
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    137a:	8cce                	mv	s9,s3
    137c:	b7fd                	j	136a <vsnprintf+0x78>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    137e:	015507b3          	add	a5,a0,s5
    1382:	ff778fa3          	sb	s7,-1(a5)
          for (int i = 2 * (longarg ? sizeof(long) : sizeof(int)) - 1; i >= 0; i--) {
    1386:	3b7d                	addiw	s6,s6,-1
    1388:	031b0163          	beq	s6,a7,13aa <vsnprintf+0xb8>
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    138c:	0a85                	addi	s5,s5,1
    138e:	febafce3          	bgeu	s5,a1,1386 <vsnprintf+0x94>
            int d = (num >> (4 * i)) & 0xF;
    1392:	002b179b          	slliw	a5,s6,0x2
    1396:	40fc57b3          	sra	a5,s8,a5
    139a:	8bbd                	andi	a5,a5,15
            if (++pos < n) out[pos - 1] = (d < 10 ? '0' + d : 'a' + d - 10);
    139c:	05778b93          	addi	s7,a5,87
    13a0:	fcfecfe3          	blt	t4,a5,137e <vsnprintf+0x8c>
    13a4:	03078b93          	addi	s7,a5,48
    13a8:	bfd9                	j	137e <vsnprintf+0x8c>
    13aa:	0705                	addi	a4,a4,1
    13ac:	9766                	add	a4,a4,s9
          longarg = 0;
    13ae:	8b72                	mv	s6,t3
          format = 0;
    13b0:	8af2                	mv	s5,t3
    13b2:	a211                	j	14b6 <vsnprintf+0x1c4>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    13b4:	020b0663          	beqz	s6,13e0 <vsnprintf+0xee>
    13b8:	0006ba83          	ld	s5,0(a3)
    13bc:	06a1                	addi	a3,a3,8
          if (num < 0) {
    13be:	020ac563          	bltz	s5,13e8 <vsnprintf+0xf6>
          for (long nn = num; nn /= 10; digits++)
    13c2:	030ac7b3          	div	a5,s5,a6
    13c6:	cf95                	beqz	a5,1402 <vsnprintf+0x110>
          long digits = 1;
    13c8:	4b05                	li	s6,1
          for (long nn = num; nn /= 10; digits++)
    13ca:	0b05                	addi	s6,s6,1
    13cc:	0307c7b3          	div	a5,a5,a6
    13d0:	ffed                	bnez	a5,13ca <vsnprintf+0xd8>
          for (int i = digits - 1; i >= 0; i--) {
    13d2:	fffb079b          	addiw	a5,s6,-1
    13d6:	0407ce63          	bltz	a5,1432 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
    13da:	00170c93          	addi	s9,a4,1
    13de:	a825                	j	1416 <vsnprintf+0x124>
          long num = longarg ? va_arg(vl, long) : va_arg(vl, int);
    13e0:	0006aa83          	lw	s5,0(a3)
    13e4:	06a1                	addi	a3,a3,8
    13e6:	bfe1                	j	13be <vsnprintf+0xcc>
            num = -num;
    13e8:	41500ab3          	neg	s5,s5
            if (++pos < n) out[pos - 1] = '-';
    13ec:	00170793          	addi	a5,a4,1
    13f0:	00b7f763          	bgeu	a5,a1,13fe <vsnprintf+0x10c>
    13f4:	972a                	add	a4,a4,a0
    13f6:	01470023          	sb	s4,0(a4)
    13fa:	873e                	mv	a4,a5
    13fc:	b7d9                	j	13c2 <vsnprintf+0xd0>
    13fe:	873e                	mv	a4,a5
    1400:	b7c9                	j	13c2 <vsnprintf+0xd0>
          long digits = 1;
    1402:	4b05                	li	s6,1
          for (int i = digits - 1; i >= 0; i--) {
    1404:	87f2                	mv	a5,t3
    1406:	bfd1                	j	13da <vsnprintf+0xe8>
            num /= 10;
    1408:	030acab3          	div	s5,s5,a6
    140c:	17fd                	addi	a5,a5,-1
          for (int i = digits - 1; i >= 0; i--) {
    140e:	02079b93          	slli	s7,a5,0x20
    1412:	020bc063          	bltz	s7,1432 <vsnprintf+0x140>
            if (pos + i + 1 < n) out[pos + i] = '0' + (num % 10);
    1416:	00fc8bb3          	add	s7,s9,a5
    141a:	febbf7e3          	bgeu	s7,a1,1408 <vsnprintf+0x116>
    141e:	00f70bb3          	add	s7,a4,a5
    1422:	9baa                	add	s7,s7,a0
    1424:	030aec33          	rem	s8,s5,a6
    1428:	030c0c1b          	addiw	s8,s8,48
    142c:	018b8023          	sb	s8,0(s7)
    1430:	bfe1                	j	1408 <vsnprintf+0x116>
          pos += digits;
    1432:	975a                	add	a4,a4,s6
          longarg = 0;
    1434:	8b72                	mv	s6,t3
          format = 0;
    1436:	8af2                	mv	s5,t3
          break;
    1438:	a8bd                	j	14b6 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
    143a:	00868b93          	addi	s7,a3,8
    143e:	0006ba83          	ld	s5,0(a3)
          while (*s2) {
    1442:	000ac683          	lbu	a3,0(s5)
    1446:	ceb9                	beqz	a3,14a4 <vsnprintf+0x1b2>
    1448:	87ba                	mv	a5,a4
    144a:	a039                	j	1458 <vsnprintf+0x166>
    144c:	40e786b3          	sub	a3,a5,a4
    1450:	96d6                	add	a3,a3,s5
    1452:	0006c683          	lbu	a3,0(a3)
    1456:	ca89                	beqz	a3,1468 <vsnprintf+0x176>
            if (++pos < n) out[pos - 1] = *s2;
    1458:	0785                	addi	a5,a5,1
    145a:	feb7f9e3          	bgeu	a5,a1,144c <vsnprintf+0x15a>
    145e:	00f50b33          	add	s6,a0,a5
    1462:	fedb0fa3          	sb	a3,-1(s6)
    1466:	b7dd                	j	144c <vsnprintf+0x15a>
          const char* s2 = va_arg(vl, const char*);
    1468:	86de                	mv	a3,s7
            if (++pos < n) out[pos - 1] = *s2;
    146a:	873e                	mv	a4,a5
          longarg = 0;
    146c:	8b72                	mv	s6,t3
          format = 0;
    146e:	8af2                	mv	s5,t3
    1470:	a099                	j	14b6 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
    1472:	00170793          	addi	a5,a4,1
    1476:	02b7fb63          	bgeu	a5,a1,14ac <vsnprintf+0x1ba>
    147a:	972a                	add	a4,a4,a0
    147c:	0006aa83          	lw	s5,0(a3)
    1480:	01570023          	sb	s5,0(a4)
    1484:	06a1                	addi	a3,a3,8
    1486:	873e                	mv	a4,a5
          longarg = 0;
    1488:	8b72                	mv	s6,t3
          format = 0;
    148a:	8af2                	mv	s5,t3
    148c:	a02d                	j	14b6 <vsnprintf+0x1c4>
    } else if (*s == '%')
    148e:	03f78363          	beq	a5,t6,14b4 <vsnprintf+0x1c2>
    else if (++pos < n)
    1492:	00170b93          	addi	s7,a4,1
    1496:	04bbf263          	bgeu	s7,a1,14da <vsnprintf+0x1e8>
      out[pos - 1] = *s;
    149a:	972a                	add	a4,a4,a0
    149c:	00f70023          	sb	a5,0(a4)
    else if (++pos < n)
    14a0:	875e                	mv	a4,s7
    14a2:	a811                	j	14b6 <vsnprintf+0x1c4>
          const char* s2 = va_arg(vl, const char*);
    14a4:	86de                	mv	a3,s7
          longarg = 0;
    14a6:	8b72                	mv	s6,t3
          format = 0;
    14a8:	8af2                	mv	s5,t3
    14aa:	a031                	j	14b6 <vsnprintf+0x1c4>
          if (++pos < n) out[pos - 1] = (char)va_arg(vl, int);
    14ac:	873e                	mv	a4,a5
          longarg = 0;
    14ae:	8b72                	mv	s6,t3
          format = 0;
    14b0:	8af2                	mv	s5,t3
    14b2:	a011                	j	14b6 <vsnprintf+0x1c4>
      format = 1;
    14b4:	8a96                	mv	s5,t0
  for (; *s; s++) {
    14b6:	0605                	addi	a2,a2,1
    14b8:	00064783          	lbu	a5,0(a2)
    14bc:	c38d                	beqz	a5,14de <vsnprintf+0x1ec>
    if (format) {
    14be:	fc0a88e3          	beqz	s5,148e <vsnprintf+0x19c>
      switch (*s) {
    14c2:	f9d7879b          	addiw	a5,a5,-99
    14c6:	0ff7fb93          	andi	s7,a5,255
    14ca:	ff7f66e3          	bltu	t5,s7,14b6 <vsnprintf+0x1c4>
    14ce:	002b9793          	slli	a5,s7,0x2
    14d2:	979a                	add	a5,a5,t1
    14d4:	439c                	lw	a5,0(a5)
    14d6:	979a                	add	a5,a5,t1
    14d8:	8782                	jr	a5
    else if (++pos < n)
    14da:	875e                	mv	a4,s7
    14dc:	bfe9                	j	14b6 <vsnprintf+0x1c4>
  }
  if (pos < n)
    14de:	02b77363          	bgeu	a4,a1,1504 <vsnprintf+0x212>
    out[pos] = 0;
    14e2:	953a                	add	a0,a0,a4
    14e4:	00050023          	sb	zero,0(a0)
  else if (n)
    out[n - 1] = 0;
  return pos;
}
    14e8:	0007051b          	sext.w	a0,a4
    14ec:	6426                	ld	s0,72(sp)
    14ee:	6486                	ld	s1,64(sp)
    14f0:	7962                	ld	s2,56(sp)
    14f2:	79c2                	ld	s3,48(sp)
    14f4:	7a22                	ld	s4,40(sp)
    14f6:	7a82                	ld	s5,32(sp)
    14f8:	6b62                	ld	s6,24(sp)
    14fa:	6bc2                	ld	s7,16(sp)
    14fc:	6c22                	ld	s8,8(sp)
    14fe:	6c82                	ld	s9,0(sp)
    1500:	6161                	addi	sp,sp,80
    1502:	8082                	ret
  else if (n)
    1504:	d1f5                	beqz	a1,14e8 <vsnprintf+0x1f6>
    out[n - 1] = 0;
    1506:	95aa                	add	a1,a1,a0
    1508:	fe058fa3          	sb	zero,-1(a1)
    150c:	bff1                	j	14e8 <vsnprintf+0x1f6>
  size_t pos = 0;
    150e:	4701                	li	a4,0
  if (pos < n)
    1510:	00b77863          	bgeu	a4,a1,1520 <vsnprintf+0x22e>
    out[pos] = 0;
    1514:	953a                	add	a0,a0,a4
    1516:	00050023          	sb	zero,0(a0)
}
    151a:	0007051b          	sext.w	a0,a4
    151e:	8082                	ret
  else if (n)
    1520:	dded                	beqz	a1,151a <vsnprintf+0x228>
    out[n - 1] = 0;
    1522:	95aa                	add	a1,a1,a0
    1524:	fe058fa3          	sb	zero,-1(a1)
    1528:	bfcd                	j	151a <vsnprintf+0x228>

000000000000152a <printf>:
int printf(char*s, ...){
    152a:	710d                	addi	sp,sp,-352
    152c:	ee06                	sd	ra,280(sp)
    152e:	ea22                	sd	s0,272(sp)
    1530:	1200                	addi	s0,sp,288
    1532:	e40c                	sd	a1,8(s0)
    1534:	e810                	sd	a2,16(s0)
    1536:	ec14                	sd	a3,24(s0)
    1538:	f018                	sd	a4,32(s0)
    153a:	f41c                	sd	a5,40(s0)
    153c:	03043823          	sd	a6,48(s0)
    1540:	03143c23          	sd	a7,56(s0)
    va_start(vl, s);
    1544:	00840693          	addi	a3,s0,8
    1548:	fed43423          	sd	a3,-24(s0)
    int res = vsnprintf(out, sizeof(out), s, vl);
    154c:	862a                	mv	a2,a0
    154e:	10000593          	li	a1,256
    1552:	ee840513          	addi	a0,s0,-280
    1556:	00000097          	auipc	ra,0x0
    155a:	d9c080e7          	jalr	-612(ra) # 12f2 <vsnprintf>
    155e:	85aa                	mv	a1,a0
    size_t n = res < sizeof(out) ? res : sizeof(out);
    1560:	0005071b          	sext.w	a4,a0
    1564:	0ff00793          	li	a5,255
    1568:	00e7f463          	bgeu	a5,a4,1570 <printf+0x46>
    156c:	10000593          	li	a1,256
    return simple_write(buf, n);
    1570:	ee840513          	addi	a0,s0,-280
    1574:	00000097          	auipc	ra,0x0
    1578:	c10080e7          	jalr	-1008(ra) # 1184 <simple_write>
}
    157c:	2501                	sext.w	a0,a0
    157e:	60f2                	ld	ra,280(sp)
    1580:	6452                	ld	s0,272(sp)
    1582:	6135                	addi	sp,sp,352
    1584:	8082                	ret
