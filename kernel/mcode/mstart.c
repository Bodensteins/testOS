#include "include/riscv.h"
#include "include/types.h"
#include "include/param.h"
#include "include/pmlayout.h"
#include "include/printk.h"

// entry.S needs one stack per CPU.
__attribute__ ((aligned (16))) char stack0[4096 * NCPU];

riscv_regs save_regs[NCPU];

void s_start();
void time_init();

extern void timevec();

void m_start(){
  printk("kernel loading...\n");
      // set M Previous Privilege mode to Supervisor, for mret.
  unsigned long x = r_mstatus();
  x &= ~MSTATUS_MPP_MASK;
  x |= MSTATUS_MPP_S;
  w_mstatus(x);

  // set M Exception Program Counter to main, for mret.
  // requires gcc -mcmodel=medany
  w_mepc((uint64)s_start);

  // disable paging for now.
  w_satp(0);

  // delegate all interrupts and exceptions to supervisor mode.
  w_medeleg(0xffff);
  w_mideleg(0xffff);

  w_tp(r_mhartid());  

  time_init();

  asm volatile("mret");
}

void time_init(){
  uint64 id=r_mhartid();
  //*(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + TIMER_INTERVAL;

  w_mscratch((uint64)(save_regs+id));

  // set the machine-mode trap handler.
  w_mtvec((uint64)timevec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
}