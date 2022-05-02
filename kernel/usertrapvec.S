#include "load_store.S"

    # trampoline程序,作为用户态和内核态之间过渡的跳板

.section trampsec   # 声明为trampsec节,用于链接脚本
.globl trampoline   # 将trampoline声明为全局可见
trampoline:
.align 4

    # 将这两个标志声明为全局可见,方便调用
.globl user_trap_vec
.globl return_to_user

    # user_trap_vec函数,其虚拟地址为用户态中stvec的值
    # 所以用户态中调用ecal进入内核态后就会跳转到这里
user_trap_vec:
    csrrw a0,sscratch,a0    # sscratch保存的是trapframe的虚拟地址,交换a0和sscratch的值
    addi t6,a0,0
    store_all_registers     # 将进程的上下文信息(即通用寄存器的值)保存在trapframe中 
    csrr t0,sscratch
    sd t0,72(a0)
    
    ld sp,248(a0)   # 切换到内核栈

    ld t0,256(a0)   # 将user_trap函数的地址读入t0

    ld t1,272(a0)   # 切换到内核页表
    csrw satp,t1
    sfence.vma zero, zero   # 更新高速缓存cache

    csrw sscratch,a0   # 将trapframe的地址写回sscratch

    jr t0   # 跳转至user_trap

    # switch_to函数最后会跳转到这里
    # 恢复进程的上下文信息,返回用户态
return_to_user:
    sfence.vma zero, zero   # 更新高速缓存cache
    csrr t6,sscratch    # sscratch保存的是trapframe的虚拟地址
    load_all_registers  # 从trapframe中恢复进程上下文信息
    sret    # 返回用户进程