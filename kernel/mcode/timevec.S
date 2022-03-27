#include "load_store.S"

.globl timevec
timevec:

    csrrw a0,mscratch,a0
    addi t6,a0,0
    store_all_registers
    csrr t0, mscratch
    sd t0, 72(a0)
    csrw mscratch, a0

    la sp, stack0
    li a0,4096
    add sp, sp, a0

    call time_trap

    csrr t6,mscratch
    load_all_registers
    
    mret