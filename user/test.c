#include "user_syscall.h"
#include "stdio.h"

void test(){
    //(*(int*)0x200c)=25;
    //if(*((int*)0x200c)==25)
        //printf((char*)0x3000);
    
    uint64 pid1=fork();
    uint64 pid2=fork();
    if(pid1==0){
        printf((char*)0x2000);
        exit(0);
    }
    if(pid2==0){
        printf((char*)0x3000);
    }
    else{
        uint64 pid3=fork();
        if(pid3==0){
            printf((char*)0x2000);
        }
        else {
            printf((char*)0x3000);
        }
        //kill(pid2);
    }

    while(1){
    }
}
