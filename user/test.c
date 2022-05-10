#include "user_syscall.h"
#include "stdio.h"

int main(){
    printf("test\n");
    char *argv[5]={"try ", "more ","test!", "\n", NULL};
    for(int i=0;i<4;i++){
        printf(argv[i]);
    }
    printf("\n...................................\n");
    execve("/main",argv, NULL);

    while(1){
    }
    return 0;
}
