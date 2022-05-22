.globl main
main:

execve:
        li a7, 1
        ecall
        beqz a0, test_execve

        li a0, -1
        li a1, 0
        li a2, 0
        li a7, 260
        ecall
        j brk

test_execve:
        la a0, execve_proc
        li a1, 0
        li  a2, 0
        li a7, 221
        ecall

brk:
        li a7, 1
        ecall
        beqz a0, test_brk

        li a0, -1
        li a1, 0
        li a2, 0
        li a7, 260
        ecall
        j fork

test_brk:
        la a0, brk_proc
        li a1, 0
        li  a2, 0
        li a7, 221
        ecall

fork:    
        li a7, 1
        ecall
        beqz a0, test_fork

        li a0, -1
        li a1, 0
        li a2, 0
        li a7, 260
        ecall
        j wait0

test_fork:
        la a0, fork_proc
        li a1, 0
        li  a2, 0
        li a7, 221
        ecall

wait0:
        li a7, 1
        ecall
        beqz a0, test_wait0

        li a0, -1
        li a1, 0
        li a2, 0
        li a7, 260
        ecall
        j waitpid

test_wait0:
        la a0, wait0_proc
        li a1, 0
        li  a2, 0
        li a7, 221
        ecall

waitpid:
        li a7, 1
        ecall
        beqz a0, test_waitpid

        li a0, -1
        li a1, 0
        li a2, 0
        li a7, 260
        ecall
        j clone

test_waitpid:
        la a0, waitpid_proc
        li a1, 0
        li  a2, 0
        li a7, 221
        ecall

clone:
        li a7, 1
        ecall
        beqz a0, test_clone

        li a0, -1
        li a1, 0
        li a2, 0
        li a7, 260
        ecall
        j getpid

test_clone:
        la a0, clone_proc
        li a1, 0
        li  a2, 0
        li a7, 221
        ecall

getpid:
        li a7, 1
        ecall
        beqz a0, test_getpid

        li a0, -1
        li a1, 0
        li a2, 0
        li a7, 260
        ecall
        j exit

test_getpid:
        la a0, getpid_proc
        li a1, 0
        li  a2, 0
        li a7, 221
        ecall

exit:
        li a7, 1
        ecall
        beqz a0, test_exit

        li a0, -1
        li a1, 0
        li a2, 0
        li a7, 260
        ecall
        j yield

test_exit:
        la a0, exit_proc
        li a1, 0
        li  a2, 0
        li a7, 221
        ecall

yield:
        li a7, 1
        ecall
        beqz a0, test_yield

        li a0, -1
        li a1, 0
        li a2, 0
        li a7, 260
        ecall
        j getppid

test_yield:
        la a0, yield_proc
        li a1, 0
        li  a2, 0
        li a7, 221
        ecall

getppid:
        li a7, 1
        ecall
        beqz a0, test_getppid

        li a0, -1
        li a1, 0
        li a2, 0
        li a7, 260
        ecall
        j quit

test_getppid:
        la a0, getppid_proc
        li a1, 0
        li  a2, 0
        li a7, 221
        ecall

quit:
        li a0, 0
        li a7, 93
        ecall
        jal quit

brk_proc:
        .string "/brk\0"
clone_proc:
        .string "/clone\0"
execve_proc:
        .string "/execve\0"
exit_proc:
        .string "/exit\0"
fork_proc:
        .string "/fork\0"
getpid_proc:
        .string "/getpid\0"
getppid_proc:
        .string "/getppid\0"
wait0_proc:
        .string "/wait\0"
waitpid_proc:
        .string "/waitpid\0"
yield_proc:
        .string "/yield\0"

status:
        .space 4