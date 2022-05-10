#ifndef _PROCESS_H_
#define _PROCESS_H_

#include "riscv.h"
#include "param.h"

#define TIME_SLICE 2

#include "spinlock.h"

#include "file.h"

/*
进程管理相关
*/

typedef enum proc_state { //进程状态 
  UNUSED,   //未使用
  SLEEPING,   //睡眠态
  READY,  //就绪态
  RUNNING,  //运行态
  ZOMBIE    //僵尸态
}proc_state;

//进程段信息
typedef enum segment_type{
  CODE_SEGMENT,    // ELF segment
  DATA_SEGMENT,    // ELF segment
  STACK_SEGMENT,   // runtime segment
  TRAPFRAME_SEGMENT, // trapframe segment
  SYSTEM_SEGMENT,  // system segment
}segment_type;

//管理进程各个段的结构
/*
这个结构是process的一部分
需要给他分配一个页
维护一个数组，其中存储了进程不同的段的信息
包括段的起始虚拟地址，占用的页数，段的类型
这是之前自己加的一个结构，个人感觉这个结构处理起来挺麻烦
xv6没有这个结构
以后也许可以删除
*/
typedef struct segment_map_info{
  uint64 va;
  int page_num;
  int seg_type;
}segment_map_info;

//trapframe，保存程序上下文
//个人觉得xv6中的context和trapframe功能比较重叠
//所以这里就删了context，而用trapframe代替其功能
typedef struct trapframe{
    riscv_regs regs;
  /*   248 */ uint64 kernel_sp;   // kernel page table
  /*   256 */ uint64 kernel_trap;     // top of process's kernel stack
  /*  264 */ uint64 epc;   // pointer to smode_trap_handler
  /*  272 */ uint64 kernel_satp;           // saved user program counter
  /*  280 */ uint64 kernel_hartid; // saved kernel tp
}trapframe;

#define NPROC 64  //最大进程数量
#define N_OPEN_FILE 16  //每个进程最大可打开的文件数量

//进程的pcb，保存进程的各种信息
typedef struct process{
  struct spinlock spinlock; //自旋锁

  uint64 kstack;  //内核栈地址
  pagetable_t pagetable;  //页表指针

  //各个程序段的信息，通过这个结构来维护
  segment_map_info *segment_map_info;
  int segment_num;  //记录进程有几个栈

  proc_state state; //进程状态
  int killed; //是否被杀死(这个似乎有点多余)
  int size; //进程在内存中的大小
  uint64 pid; //进程pid

  fat32_dirent *cwd;  //进程当前工作目录的目录项

  //进程打开的文件列表，通过文件描述符来索引
  //这个列表维护的实际上是指向file.c中的文件列表的指针，打开的文件最终由OS维护
  file *open_files[N_OPEN_FILE];  

  struct process *parent; //进程的父进程
  
  //进程可能会被加入一些队列，如就绪队列、睡眠队列，这个指针指向队列中的下一个进程
  struct process *queue_next; 

  //trapframe，在进入内核态的时候保存进程上下文信息
  trapframe *trapframe;
}process;

extern process proc_list[NPROC];  //进程池
extern process* current;  //当前运行的进程(目前未实现多核机制，因此先用这个全局变量代替)

void proc_list_init();  //进程池初始化函数，OS启动时调用
process *alloc_process(); //从进程池中分配一个未使用(UNUSED)的进程
int free_process(process* proc);  //释放一个进程(将其状态置为ZOMBIE)
uint64 do_fork(process *parent);  //实现fork功能，创建一个一模一样的新进程，与UNIX的fork功能一致
void reparent(process *); //重新设置指定进程的父进程(如果父进程终止的话)
void yield(); //当前进程让出CPU
uint64 do_kill(uint64); //根据pid杀死当前进程
void switch_to(process*); //切换到指定进程
int do_execve(char*, char**, char**); //从磁盘中加载可执行文件到内存中

#endif