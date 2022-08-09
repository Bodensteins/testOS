#include "user_syscall.h"
#include "stdio.h"

//void main(void) __attribute__((naked));
void main(){
    int fd=openat(-100,"/dev/console",0x4);
	dup(fd);
	dup(fd);

    printf("syscall test begin\n");
    
    int pid=fork();

    if(pid==0){
        char *argv[5]={"yes","comm","no","mm",NULL};
        execve("main",argv,NULL);
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
}
