#include "stdio.h"
#include "user_syscall.h"

char str[256];

//void main(int argc, char *argv[]) __attribute__((naked));
void main(int argc, char *argv[]){
    printf("main begin!\n");
    printf("argc: %d\n",argc);
    for(int i=0;i<argc;i++){
        printf(argv[i]);
    }
    printf("pid: %d\n",getpid());
    printf("ppid: %d\n",getppid());

    printf("\n");

    printf("brk test:\n");
    int cur_pos, alloc_pos, alloc_pos_1;
    cur_pos = brk(0);
    printf("Before alloc,heap pos: %d\n", cur_pos);
    brk(cur_pos + 4096);
    alloc_pos = brk(0);
    printf("After alloc,heap pos: %d\n",alloc_pos);

    int *test_ptr=(int*)((alloc_pos-18)-(alloc_pos-18)%16);     //注意，riscv要求任何变量的地址必须16字节对齐！
    *test_ptr=2022;
    printf("in address %p, store integer %d\n", test_ptr, *test_ptr);

    brk(alloc_pos - 4095);
    alloc_pos_1 = brk(0);
    printf("Dealloc,heap pos: %d\n",alloc_pos_1);

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
}
