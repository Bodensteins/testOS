#include "types.h"
#include "process.h"
#include "printk.h"
#include "syscall.h"
#include "vm.h"

extern trapframe temp[];

uint64 sys_fork();
uint64 sys_simple_write();
uint64 sys_exit();

static uint64 (*syscalls[])() = {
    [SYS_fork] sys_fork,
    [SYS_exit] sys_exit,
    [SYS_write] sys_simple_write,
};

uint64 syscall(){
    int syscall_num=current->trapframe->regs.a0;
    if(syscall_num==SYS_write)
        return syscalls[syscall_num]();
    else if(syscall_num==SYS_fork)
        return syscalls[syscall_num]();
    else if(syscall_num==SYS_exit)
        return syscalls[syscall_num]();
    else
        return -1;
}

uint64 sys_fork(){
    return do_fork(current);
}

uint64 sys_exit(){
    int code=current->trapframe->regs.a1;
    free_process(current);
    return code;
}

uint64 sys_simple_write(){
    uint64 str=current->trapframe->regs.a1;
    char* pa = (char*)va_to_pa(current->pagetable,(void*)str);
    printk((char*)pa);
    return 0;
}