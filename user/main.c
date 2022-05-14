#include "stdio.h"
#include "user_syscall.h"

char str[256];

int main(int argc, char *argv[]){
    printf("main begin!\n");
    printf("argc: %d\n",argc);
    for(int i=0;i<argc;i++){
        printf(argv[i]);
    }
    printf("pid: %d\n",getpid());
    printf("ppid: %d\n",getppid());

    printf("\n");

    while(1){
        printf("input a string(q to quit): ");
        simple_read(str,256);
        if(str[0]=='q' && str[1]==0)
            break;
        printf("your string is: %s\n",str);
    }

    printf("\n");

    printf("main end!\n");    
    exit(22);
    return 0;
}
