#ifndef _PROCESS_H_
#define _PROCESS_H_

#include "riscv.h"
#include "param.h"

#define TIME_SLICE 2

typedef enum proc_state { 
  UNUSED, 
  SLEEPING, 
  RUNNABLE, 
  RUNNING, 
  ZOMBIE 
}proc_state;

typedef enum segment_type{
  CODE_SEGMENT,    // ELF segment
  DATA_SEGMENT,    // ELF segment
  STACK_SEGMENT,   // runtime segment
  TRAPFRAME_SEGMENT, // trapframe segment
  SYSTEM_SEGMENT,  // system segment
}segment_type;

typedef struct segment_map_info{
  uint64 va;
  int page_num;
  int seg_type;
}segment_map_info;

typedef struct context{
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

typedef struct trapframe{
    riscv_regs regs;
  /*   248 */ uint64 kernel_sp;   // kernel page table
  /*   256 */ uint64 kernel_trap;     // top of process's kernel stack
  /*  264 */ uint64 epc;   // pointer to smode_trap_handler
  /*  272 */ uint64 kernel_satp;           // saved user program counter
  /*  280 */ uint64 kernel_hartid; // saved kernel tp
}trapframe;

typedef struct process{
    uint64 kstack;
    pagetable_t pagetable;

    segment_map_info *segment_map_info;
    int segment_num;
    //context context;

    int state;
    int killed;
    uint64 pid;

    struct process *parent;
    struct process *queue_next;
    trapframe *trapframe;
}process;


extern process proc_list[NPROC];
extern process* current;

void init_proc_list();
process *alloc_process();
int free_process( process* proc );
uint64 do_fork(process *parent);
void reparent(process *);
void yield();
uint64 do_kill(uint64);
void switch_to(process*);

#endif