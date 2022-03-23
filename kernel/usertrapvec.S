#include "load_store.S"

.section trampsec
.globl trampoline
trampoline:
.align 4

.globl user_trap_vec
.globl return_to_user

user_trap_vec:
    csrrw a0,sscratch,a0
    addi t6,a0,0
    store_all_registers
    csrr t0,sscratch
    sd t0,72(a0)
    
    ld sp,248(a0)

    ld t0,256(a0)

    ld t1,272(a0)
    csrw satp,t1
    sfence.vma zero, zero

    csrw sscratch,a0

    jr t0

return_to_user:
    sfence.vma zero, zero
    csrr t6,sscratch
    load_all_registers
    sret