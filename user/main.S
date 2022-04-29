    section .text
    .align 2
    .globl main
main:
    lui a0,%hi(hello)
    addi a0,a0,%lo(hello)
    li a1,14
    li a2,0
    li a3,0
    li a4,0
    li a5,0
    li a6,0
    li a7,16
    ecall
junk:
    j junk

    section .rodata
    .align 2
hello:
    .string "Hello world!\n\0"