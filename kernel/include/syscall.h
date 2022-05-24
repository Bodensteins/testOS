#ifndef _SYSCALL_H_
#define _SYSCALL_H_

#include "types.h"

/*
系统调用号
*/

// System call numbers
#define SYS_fork    1
#define SYS_pipe    4
#define SYS_read    5
#define SYS_kill    6
#define SYS_fstat   8
#define SYS_chdir   9
#define SYS_dup    10
#define SYS_sbrk   12
#define SYS_sleep  13
#define SYS_uptime 14
#define SYS_open   15
#define SYS_write  64
#define SYS_mknod  17
#define SYS_unlink 18
#define SYS_link   19
#define SYS_mkdir  20
#define SYS_close  21

#define SYS_simple_read 99
#define SYS_simple_write 100

#define SYS_clone 220
#define SYS_execve 221
#define SYS_wait4 260
#define SYS_exit 93
#define SYS_getppid 173
#define SYS_getpid 172
#define SYS_brk 214
#define SYS_times 153
#define SYS_uname 160
#define SYS_sched_yield 124
#define SYS_gettimeofday 169
#define SYS_nanosleep 101

uint64 syscall();



#endif