#include "kernel/include/syscall.h"
#include "kernel/include/printk.h"

/*
用户态使用系统调用
*/

static uint64 user_syscall
    (uint64 v0,uint64 v1,uint64 v2,uint64 v3,uint64 v4,uint64 v5,uint64 v6,uint64 v7){
        uint64 r0=v0, r1=v1, r2=v2, r3=v3, r4=v4, r5=v5, r6=v6, r7=v7;
        asm volatile(   //将参数写入a0-a7寄存器
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

        asm volatile(   //调用ecall
            "ecall\n"
            "sd a0, %0"  //返回值存于a0寄存器
            : "=m"(r0)
            :   
            : "memory"
        );
        return r0;
}

//复制一个新进程
uint64 fork(){
    return user_syscall(0,0,0,0,0,0,0,SYS_fork);
}

//进程退出
uint64 exit(int code){
    return user_syscall(code,0,0,0,0,0,0,SYS_exit);
}

//打开文件
uint64 open(char *file_name, int mode){
    return user_syscall((uint64)file_name,mode,0,0,0,0,0,SYS_open);
}

//根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 read(int fd, void* buf, size_t rsize){
    return user_syscall(fd,(uint64)buf,rsize,0,0,0,0,SYS_read);
}

//根据pid杀死进程
uint64 kill(uint64 pid){
    return user_syscall(pid,0,0,0,0,0,0,SYS_kill);
}

//从外存中根据文件路径和名字加载可执行文件
uint64 execve(char *file_name, char **argv, char **env){
    return user_syscall((uint64)file_name,(uint64)argv,(uint64)env,0,0,0,0,SYS_execve);
}

//一个简单的输出字符串到屏幕上的系统调用
uint64 simple_write(char *s, size_t n){
    return user_syscall((uint64)s,n,0,0,0,0,0,SYS_write);
}

//根据文件描述符关闭文件
uint64 close(int fd){
    return user_syscall(fd,0,0,0,0,0,0,SYS_close);
}

