
target/userinit.out：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
.globl main
main:

execve:
        li a7, 1
    1000:	00100893          	li	a7,1
        ecall
    1004:	00000073          	ecall
        beqz a0, test_execve
    1008:	00050e63          	beqz	a0,1024 <test_execve>

        li a0, -1
    100c:	fff00513          	li	a0,-1
        li a1, 0
    1010:	00000593          	li	a1,0
        li a2, 0
    1014:	00000613          	li	a2,0
        li a7, 260
    1018:	10400893          	li	a7,260
        ecall
    101c:	00000073          	ecall
        j brk
    1020:	01c0006f          	j	103c <brk>

0000000000001024 <test_execve>:

test_execve:
        la a0, execve_proc
    1024:	00000517          	auipc	a0,0x0
    1028:	25250513          	addi	a0,a0,594 # 1276 <execve_proc>
        li a1, 0
    102c:	00000593          	li	a1,0
        li  a2, 0
    1030:	00000613          	li	a2,0
        li a7, 221
    1034:	0dd00893          	li	a7,221
        ecall
    1038:	00000073          	ecall

000000000000103c <brk>:

brk:
        li a7, 1
    103c:	00100893          	li	a7,1
        ecall
    1040:	00000073          	ecall
        beqz a0, test_brk
    1044:	00050e63          	beqz	a0,1060 <test_brk>

        li a0, -1
    1048:	fff00513          	li	a0,-1
        li a1, 0
    104c:	00000593          	li	a1,0
        li a2, 0
    1050:	00000613          	li	a2,0
        li a7, 260
    1054:	10400893          	li	a7,260
        ecall
    1058:	00000073          	ecall
        j fork
    105c:	01c0006f          	j	1078 <fork>

0000000000001060 <test_brk>:

test_brk:
        la a0, brk_proc
    1060:	00000517          	auipc	a0,0x0
    1064:	20850513          	addi	a0,a0,520 # 1268 <brk_proc>
        li a1, 0
    1068:	00000593          	li	a1,0
        li  a2, 0
    106c:	00000613          	li	a2,0
        li a7, 221
    1070:	0dd00893          	li	a7,221
        ecall
    1074:	00000073          	ecall

0000000000001078 <fork>:

fork:    
        li a7, 1
    1078:	00100893          	li	a7,1
        ecall
    107c:	00000073          	ecall
        beqz a0, test_fork
    1080:	00050e63          	beqz	a0,109c <test_fork>

        li a0, -1
    1084:	fff00513          	li	a0,-1
        li a1, 0
    1088:	00000593          	li	a1,0
        li a2, 0
    108c:	00000613          	li	a2,0
        li a7, 260
    1090:	10400893          	li	a7,260
        ecall
    1094:	00000073          	ecall
        j wait0
    1098:	01c0006f          	j	10b4 <wait0>

000000000000109c <test_fork>:

test_fork:
        la a0, fork_proc
    109c:	00000517          	auipc	a0,0x0
    10a0:	1ea50513          	addi	a0,a0,490 # 1286 <fork_proc>
        li a1, 0
    10a4:	00000593          	li	a1,0
        li  a2, 0
    10a8:	00000613          	li	a2,0
        li a7, 221
    10ac:	0dd00893          	li	a7,221
        ecall
    10b0:	00000073          	ecall

00000000000010b4 <wait0>:

wait0:
        li a7, 1
    10b4:	00100893          	li	a7,1
        ecall
    10b8:	00000073          	ecall
        beqz a0, test_wait0
    10bc:	00050e63          	beqz	a0,10d8 <test_wait0>

        li a0, -1
    10c0:	fff00513          	li	a0,-1
        li a1, 0
    10c4:	00000593          	li	a1,0
        li a2, 0
    10c8:	00000613          	li	a2,0
        li a7, 260
    10cc:	10400893          	li	a7,260
        ecall
    10d0:	00000073          	ecall
        j waitpid
    10d4:	01c0006f          	j	10f0 <waitpid>

00000000000010d8 <test_wait0>:

test_wait0:
        la a0, wait0_proc
    10d8:	00000517          	auipc	a0,0x0
    10dc:	1c850513          	addi	a0,a0,456 # 12a0 <wait0_proc>
        li a1, 0
    10e0:	00000593          	li	a1,0
        li  a2, 0
    10e4:	00000613          	li	a2,0
        li a7, 221
    10e8:	0dd00893          	li	a7,221
        ecall
    10ec:	00000073          	ecall

00000000000010f0 <waitpid>:

waitpid:
        li a7, 1
    10f0:	00100893          	li	a7,1
        ecall
    10f4:	00000073          	ecall
        beqz a0, test_waitpid
    10f8:	00050e63          	beqz	a0,1114 <test_waitpid>

        li a0, -1
    10fc:	fff00513          	li	a0,-1
        li a1, 0
    1100:	00000593          	li	a1,0
        li a2, 0
    1104:	00000613          	li	a2,0
        li a7, 260
    1108:	10400893          	li	a7,260
        ecall
    110c:	00000073          	ecall
        j clone
    1110:	01c0006f          	j	112c <clone>

0000000000001114 <test_waitpid>:

test_waitpid:
        la a0, waitpid_proc
    1114:	00000517          	auipc	a0,0x0
    1118:	19350513          	addi	a0,a0,403 # 12a7 <waitpid_proc>
        li a1, 0
    111c:	00000593          	li	a1,0
        li  a2, 0
    1120:	00000613          	li	a2,0
        li a7, 221
    1124:	0dd00893          	li	a7,221
        ecall
    1128:	00000073          	ecall

000000000000112c <clone>:

clone:
        li a7, 1
    112c:	00100893          	li	a7,1
        ecall
    1130:	00000073          	ecall
        beqz a0, test_clone
    1134:	00050e63          	beqz	a0,1150 <test_clone>

        li a0, -1
    1138:	fff00513          	li	a0,-1
        li a1, 0
    113c:	00000593          	li	a1,0
        li a2, 0
    1140:	00000613          	li	a2,0
        li a7, 260
    1144:	10400893          	li	a7,260
        ecall
    1148:	00000073          	ecall
        j getpid
    114c:	01c0006f          	j	1168 <getpid>

0000000000001150 <test_clone>:

test_clone:
        la a0, clone_proc
    1150:	00000517          	auipc	a0,0x0
    1154:	11e50513          	addi	a0,a0,286 # 126e <clone_proc>
        li a1, 0
    1158:	00000593          	li	a1,0
        li  a2, 0
    115c:	00000613          	li	a2,0
        li a7, 221
    1160:	0dd00893          	li	a7,221
        ecall
    1164:	00000073          	ecall

0000000000001168 <getpid>:

getpid:
        li a7, 1
    1168:	00100893          	li	a7,1
        ecall
    116c:	00000073          	ecall
        beqz a0, test_getpid
    1170:	00050e63          	beqz	a0,118c <test_getpid>

        li a0, -1
    1174:	fff00513          	li	a0,-1
        li a1, 0
    1178:	00000593          	li	a1,0
        li a2, 0
    117c:	00000613          	li	a2,0
        li a7, 260
    1180:	10400893          	li	a7,260
        ecall
    1184:	00000073          	ecall
        j exit
    1188:	01c0006f          	j	11a4 <exit>

000000000000118c <test_getpid>:

test_getpid:
        la a0, getpid_proc
    118c:	00000517          	auipc	a0,0x0
    1190:	10150513          	addi	a0,a0,257 # 128d <getpid_proc>
        li a1, 0
    1194:	00000593          	li	a1,0
        li  a2, 0
    1198:	00000613          	li	a2,0
        li a7, 221
    119c:	0dd00893          	li	a7,221
        ecall
    11a0:	00000073          	ecall

00000000000011a4 <exit>:

exit:
        li a7, 1
    11a4:	00100893          	li	a7,1
        ecall
    11a8:	00000073          	ecall
        beqz a0, test_exit
    11ac:	00050e63          	beqz	a0,11c8 <test_exit>

        li a0, -1
    11b0:	fff00513          	li	a0,-1
        li a1, 0
    11b4:	00000593          	li	a1,0
        li a2, 0
    11b8:	00000613          	li	a2,0
        li a7, 260
    11bc:	10400893          	li	a7,260
        ecall
    11c0:	00000073          	ecall
        j yield
    11c4:	01c0006f          	j	11e0 <yield>

00000000000011c8 <test_exit>:

test_exit:
        la a0, exit_proc
    11c8:	00000517          	auipc	a0,0x0
    11cc:	0b750513          	addi	a0,a0,183 # 127f <exit_proc>
        li a1, 0
    11d0:	00000593          	li	a1,0
        li  a2, 0
    11d4:	00000613          	li	a2,0
        li a7, 221
    11d8:	0dd00893          	li	a7,221
        ecall
    11dc:	00000073          	ecall

00000000000011e0 <yield>:

yield:
        li a7, 1
    11e0:	00100893          	li	a7,1
        ecall
    11e4:	00000073          	ecall
        beqz a0, test_yield
    11e8:	00050e63          	beqz	a0,1204 <test_yield>

        li a0, -1
    11ec:	fff00513          	li	a0,-1
        li a1, 0
    11f0:	00000593          	li	a1,0
        li a2, 0
    11f4:	00000613          	li	a2,0
        li a7, 260
    11f8:	10400893          	li	a7,260
        ecall
    11fc:	00000073          	ecall
        j getppid
    1200:	01c0006f          	j	121c <getppid>

0000000000001204 <test_yield>:

test_yield:
        la a0, yield_proc
    1204:	00000517          	auipc	a0,0x0
    1208:	0ad50513          	addi	a0,a0,173 # 12b1 <yield_proc>
        li a1, 0
    120c:	00000593          	li	a1,0
        li  a2, 0
    1210:	00000613          	li	a2,0
        li a7, 221
    1214:	0dd00893          	li	a7,221
        ecall
    1218:	00000073          	ecall

000000000000121c <getppid>:

getppid:
        li a7, 1
    121c:	00100893          	li	a7,1
        ecall
    1220:	00000073          	ecall
        beqz a0, test_getppid
    1224:	00050e63          	beqz	a0,1240 <test_getppid>

        li a0, -1
    1228:	fff00513          	li	a0,-1
        li a1, 0
    122c:	00000593          	li	a1,0
        li a2, 0
    1230:	00000613          	li	a2,0
        li a7, 260
    1234:	10400893          	li	a7,260
        ecall
    1238:	00000073          	ecall
        j quit
    123c:	01c0006f          	j	1258 <quit>

0000000000001240 <test_getppid>:

test_getppid:
        la a0, getppid_proc
    1240:	00000517          	auipc	a0,0x0
    1244:	05650513          	addi	a0,a0,86 # 1296 <getppid_proc>
        li a1, 0
    1248:	00000593          	li	a1,0
        li  a2, 0
    124c:	00000613          	li	a2,0
        li a7, 221
    1250:	0dd00893          	li	a7,221
        ecall
    1254:	00000073          	ecall

0000000000001258 <quit>:

quit:
        li a0, 0
    1258:	00000513          	li	a0,0
        li a7, 93
    125c:	05d00893          	li	a7,93
        ecall
    1260:	00000073          	ecall
        jal quit
    1264:	ff5ff0ef          	jal	ra,1258 <quit>

0000000000001268 <brk_proc>:
    1268:	6b72622f          	0x6b72622f
	...

000000000000126e <clone_proc>:
    126e:	6f6c632f          	0x6f6c632f
    1272:	656e                	ld	a0,216(sp)
	...

0000000000001276 <execve_proc>:
    1276:	6578652f          	0x6578652f
    127a:	00657663          	bgeu	a0,t1,1286 <fork_proc>
	...

000000000000127f <exit_proc>:
    127f:	6978652f          	0x6978652f
    1283:	0074                	addi	a3,sp,12
	...

0000000000001286 <fork_proc>:
    1286:	726f662f          	0x726f662f
    128a:	          	0x6b

000000000000128d <getpid_proc>:
    128d:	7465672f          	0x7465672f
    1291:	6970                	ld	a2,208(a0)
    1293:	0064                	addi	s1,sp,12
	...

0000000000001296 <getppid_proc>:
    1296:	7465672f          	0x7465672f
    129a:	7070                	ld	a2,224(s0)
    129c:	6469                	lui	s0,0x1a
	...

00000000000012a0 <wait0_proc>:
    12a0:	6961772f          	0x6961772f
    12a4:	0074                	addi	a3,sp,12
	...

00000000000012a7 <waitpid_proc>:
    12a7:	6961772f          	0x6961772f
    12ab:	7074                	ld	a3,224(s0)
    12ad:	6469                	lui	s0,0x1a
	...

00000000000012b1 <yield_proc>:
    12b1:	6569792f          	0x6569792f
    12b5:	646c                	ld	a1,200(s0)
	...

00000000000012b9 <status>:
    12b9:	0000                	unimp
    12bb:	0000                	unimp
    12bd:	0000                	unimp
	...
