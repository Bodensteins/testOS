#include "stdio.h"
#include "user_syscall.h"

int main(int argc, char *argv[]){
    printf("main begin!\n");
    printf("argc: %d\n",argc);
    for(int i=0;i<argc;i++){
        printf(argv[i]);
    }
    printf("pid: %d\n",getpid());
    printf("ppid: %d\n",getppid());
    printf("main end!\n");    
    exit(22);
    return 0;
}
