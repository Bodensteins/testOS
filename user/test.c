#include "user_syscall.h"
#include "stdio.h"

char stack[1024];

int main(){
    printf("test\n");
    
    int pid=clone(0,stack,1024);

    if(pid==0){
        char *argv[5]={"try ", "more ","test!", "\n", NULL};
        for(int i=0;i<4;i++){
            printf(argv[i]);
        }
        printf("\n...................................\n");
        execve("/main",argv, NULL);
    }

    else{
        printf("ok!\n");
    }

    while(1){
    }
    return 0;
}
