#ifndef _PROCESS_H_
#define _PROCESS_H_

#include "riscv.h"
#include "param.h"

#define TIME_SLICE 2

#include "spinlock.h"
#include "systime.h"
#include "file.h"
#include "sysmmap.h"
/*
进程管理相关
*/

typedef enum proc_state { //进程状态 
  UNUSED,   //未使用
  SLEEPING,   //睡眠态
  READY,  //就绪态
  RUNNING,  //运行态
  ZOMBIE,    //僵尸态
}proc_state;

//进程段信息
typedef enum segment_type{
  CODE_SEGMENT,    // ELF segment
  HEAP_SEGMENT,    // heap segment
  STACK_SEGMENT,   // runtime segment
  TRAPFRAME_SEGMENT, // trapframe segment
  SYSTEM_SEGMENT,  // system segment
  MMAP_SEGMENT, // user mmap segment 
}segment_type;

//管理进程各个段的结构
/*
这个结构是process的一部分
需要给他分配一个页
维护一个数组，其中存储了进程不同的段的信息
包括段的起始虚拟地址，占用的页数，段的类型
*/
typedef struct segment_map_info{
  uint64 va;
  int page_num;
  int seg_type;
}segment_map_info;

//trapframe，保存程序上下文
typedef struct trapframe{
    riscv_regs regs;
  /*   248 */ uint64 kernel_sp;   // kernel page table
  /*   256 */ uint64 kernel_trap;     // top of process's kernel stack
  /*  264 */ uint64 epc;   // pointer to smode_trap_handler
  /*  272 */ uint64 kernel_satp;           // saved user program counter
  /*  280 */ uint64 kernel_hartid; // saved kernel tp
}trapframe;

// Saved registers for kernel context switches.
typedef struct context {
	uint64 ra;
	uint64 sp;

	// callee-saved
	uint64 s0;
	uint64 s1;
	uint64 s2;
	uint64 s3;
	uint64 s4;
	uint64 s5;
	uint64 s6;
	uint64 s7;
	uint64 s8;
	uint64 s9;
	uint64 s10;
	uint64 s11;
}context;

#define NPROC 64  //最大进程数量
#define N_OPEN_FILE 128  //每个进程最大可打开的文件数量
#define MMAP_NUM 3
//进程的pcb，保存进程的各种信息
typedef struct process{
  struct spinlock spinlock; //自旋锁

  context context;  //进程上下文 

  uint64 kstack;  //内核栈地址
  pagetable_t pagetable;  //页表指针

  //各个程序段的信息，通过这个结构来维护
  segment_map_info *segment_map_info;
  int segment_num;  //记录进程有几个段

  proc_state state; //进程状态
  int exit_state; //进程退出状态
  int killed; //是否被杀死
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

  //进程时间相关
  tms times;  //进程运行时间
  uint64 enter_ktimes;  //上一次进入内核的时间
  uint64 leave_ktimes;  //上一次离开内核的时间

  uint64 sleep_expire;  //睡眠预期唤醒时间

  char name[50];

  mmap_infos mmap_areas[MMAP_NUM];
  uint64 mmap_va_available; //从此地址往后都可以映射

  
}process;


#define WAIT_OPTIONS_WNOHANG 		1
#define WAIT_OPTIONS_WUNTRACED 		2
#define WAIT_OPTIONS_WCONTINUED 	8


extern process proc_list[NPROC];  //进程池
extern process* current;  //当前运行的进程(目前未实现多核机制，因此先用这个全局变量代替)

// swtch.S
void swtch(struct context *old, struct context *new);

void proc_list_init();  //进程池初始化函数，OS启动时调用
process *alloc_process(); //从进程池中分配一个未使用(UNUSED)的进程
void load_user_proc(); //载入init进程
int process_zombie(process* proc);  //释放一个进程(将其状态置为ZOMBIE)
uint64 do_fork(process *parent);  //实现fork功能，创建一个一模一样的新进程，与UNIX的fork功能一致
uint64 do_clone(process *parent, uint64 flag, uint64 stack); //实现clone系统调用
void reparent(process *); //重新设置指定进程的父进程(如果父进程终止的话)
void do_yield(); //当前进程让出CPU
uint64 do_exit(int xstate); //实际执行进程结束的函数
uint64 do_kill(uint64); //根据pid杀死当前进程
void switch_to(process*); //切换到指定进程
int do_execve(char*, char**, char**); //从磁盘中加载可执行文件到内存中
uint64 do_wait4(int pid, int* status, uint64 options);  //实际执行wait4的函数

void process_sleep(process **queue);
void process_wakeup(process **queue, process *proc);
void process_wakeup1(process **queue);

extern void fork_ret();

#endif