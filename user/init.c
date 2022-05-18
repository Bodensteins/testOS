#include "user_syscall.h"
#include "stdio.h"

int main(){
    printf("\nsyscall test begin\n");
    
    int pid=fork();

    if(pid==0){
        char *argv[5]={"wait4 ", "and ","execve ", "test!\n", NULL};
        for(int i=0;i<4;i++){
            printf(argv[i]);
        }
        printf("\n...................................\n\n");
        execve("main",argv, NULL);
    }

    else{
        int status=0;
        int ret=wait4(-1,&status,0);
        status=status>>8;
        printf("ret=%d, status=%d\n",ret,status);
    }

    printf("\nsyscall test end\n");

    while(1){
    }
    return 0;
}
