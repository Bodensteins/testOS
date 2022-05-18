# Initial process that execs /init.
# This code runs in user space.

# execve(init, NULL, NULL)
.globl main
main:
        la a0, init
        la a1, 0
        li  a2, 0
        li a7, 221
        ecall

# exit(0);
exit:
        li a0, 0
        li a7, 93
        ecall
        jal exit

# char init[] = "/init\0";
init:
  .string "/init\0"
