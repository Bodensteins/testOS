#include "user_syscall.h"
#include "stdio.h"

void test(){
    //(*(int*)0x200c)=25;
    //if(*((int*)0x200c)==25)
    //    printf((char*)0x3000);
    uint64 pid=fork();
    
    if(pid==0){
        
        printf((char*)0x2000);
        exit(0);
    }
    else{
        printf((char*)0x3000);
        //kill(pid);
    }
     while(1){
    }
}
