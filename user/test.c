#include "user_syscall.h"
#include "stdio.h"

int main(){

    printf("test\n");
    exec("/main");

    while(1){
    }
    return 0;
}
