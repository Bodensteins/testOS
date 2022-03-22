    .section .text
    .globl entry
entry:
    la sp,boot_stack
    li a0,4096*4
    add sp, sp, a0
    call s_start
junk:
    j junk

    .section .bss.stack
    .align 12
    .globl boot_stack
    .globl boot_stack_top
boot_stack:
    .space 4096*4*2
boot_stack_top:
