#include "stdio.h"
#include "user_syscall.h"

int main(int argc, char *argv[]){
    printf("test begin!\n");
    printf("argc: %d\n",argc);
    for(int i=0;i<4;i++){
        printf(argv[i]);
    }
    printf("test end!\n");    
    while(1){}
    return 0;
}
