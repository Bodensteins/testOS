#include "types.h"
//#include "uart.h"
#include "sbi.h"
#include "riscv.h"
#include "param.h"
#include "printk.h"
#include "syscall.h"
#include "process.h"
#include "trap.h"
#include "vm.h"
#include "schedule.h"

static int ticks=0;

void handle_syscall(){
    current->trapframe->epc+=4;
    intr_on();
    current->trapframe->regs.a0=syscall();
}

void handle_timer_trap(){
    ticks++;
    sbi_set_timer(r_time()+TIMER_INTERVAL);
    w_sip(r_sip()&(~SIP_SSIP));
    
    if(ticks==TIME_SLICE){
        ticks=0;
        if(current->state==RUNNING){
            current->state=RUNNABLE;
            insert_to_runnable_queue(current);
        }
        schedule();
  }
}

void trap_init(){
    uint64 x = r_sstatus();
    x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    x |= SSTATUS_SIE;       //enable supervisor-mode interrupts.
    x |= SSTATUS_SPIE;  // enable interrupts in user mode
    w_sstatus(x);
    w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    w_stvec((uint64)kernel_trap_vec);
    sbi_set_timer(r_time()+TIMER_INTERVAL);
}

void user_trap(){
    if((r_sstatus() & SSTATUS_SPP) != 0)
        panic("usertrap: not from user mode");

    current->trapframe->epc=r_sepc();
    uint64 cause=r_scause();
    w_stvec((uint64)kernel_trap_vec);
    switch (cause){
        case CAUSE_TIMER_S_TRAP:
            handle_timer_trap();
            break;
        case CAUSE_USER_ECALL:
            handle_syscall();
            break;
        default:
            break;
    }
    user_trap_ret();
}

void user_trap_ret(){
    intr_off();
    // set S Previous Privilege mode to User.
    switch_to(current);
}

void kernel_trap(){
    uint64 sepc=r_sepc();
    uint64 status = r_sstatus();
    uint64 cause = r_scause();
  
    if((status & SSTATUS_SPP) == 0)
        panic("kerneltrap: not from supervisor mode");
    if(intr_get() != 0)
        panic("kerneltrap: interrupts enabled");
    switch (cause){
        case CAUSE_TIMER_S_TRAP:
            handle_timer_trap();
            break;
        default:
            break;
    }
    w_sepc(sepc);
    w_sstatus(status);
}
