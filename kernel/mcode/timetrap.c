#include "include/riscv.h"
#include "include/pmlayout.h"
//#include "uart.h"

void time_trap(){
  //*(uint64*)CLINT_MTIMECMP(r_mhartid()) = *(uint64*)CLINT_MTIME + TIMER_INTERVAL;
    w_sip(SIP_SSIP);
}