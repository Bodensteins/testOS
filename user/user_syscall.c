#include "kernel/include/syscall.h"
#include "kernel/include/printk.h"

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
        asm volatile(
            "ld a0, %0 \n"
            "ld a1, %1 \n"
            "ld a2, %2 \n"
            "ld a3, %3 \n"
            "ld a4, %4 \n"
            "ld a5, %5 \n"
            "ld a6, %6 \n"
            "ld a7, %7 \n"
            :
            : "m"(r0), "m"(r1), "m"(r2), "m"(r3), "m"(r4), "m"(r5), "m"(r6), "m"(r7)
            : "memory"
        );

        asm volatile(
            "ecall\n"
            "sd a0, %0"  // returns a 64-bit value
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}

uint64 fork(){
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
}

uint64 exit(int code){
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
}

uint64 open(char *file_name, int mode){
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
}

uint64 read(int fd, void* buf, size_t rsize){
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
}

uint64 kill(uint64 pid){
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
}

uint64 exec(char *file_name){
    return user_syscall((uint64)file_name,0,0,0,0,0,0,SYS_exec);
}

uint64 simple_write(char *s, size_t n){
    return user_syscall((uint64)s,n,0,0,0,0,0,SYS_write);
}

uint64 close(int fd){
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
}

