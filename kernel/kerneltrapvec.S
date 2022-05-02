#include "load_store.S"
        
        # 内核trap入口

.globl kernel_trap
.globl kernel_trap_vec
.align 4
kernel_trap_vec:
        # make room to save registers.
        addi sp, sp, -256
        # save the registers.
        addi t6,sp,0
        store_all_registers

	    # call the C trap handler in trap.c
        call kernel_trap

        # restore registers.
        addi t6,sp,0
        load_all_registers

        addi sp, sp, 256

        # return to whatever we were doing in the kernel.
        sret