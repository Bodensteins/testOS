#include "user_syscall.h"
#include "kernel/printk.h"
#include "kernel/process.h"
#include "kernel/vm.h"

void test(){
    uint64 pid=fork();
    if(pid==0){
        //exit(0);
        simple_write((char*)0x2000);
    }
    else
        simple_write((char*)0x3000);
    while(1){
    }
}
