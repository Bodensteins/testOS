#include "include/types.h"
#include "include/sbi.h"
#include "include/riscv.h"
#include "include/param.h"
#include "include/printk.h"
#include "include/syscall.h"
#include "include/process.h"
#include "include/trap.h"
#include "include/vm.h"
#include "include/schedule.h"
#include "include/plic.h"
#include "include/console.h"
#include "include/systime.h"

#ifndef QEMU
#else
#include "include/virtio.h"
#endif

static int ticks=0; //计时器

void handle_extern_irq();

//系统调用中断处理函数
void handle_syscall(){ 
    current->trapframe->epc+=4; //epc+4，使其返回后执行下一条指令
    intr_on();  //中断开启
    current->trapframe->regs.a0=syscall();  //系统调用返回值存在a0寄存器中
}

//时钟中断处理函数
void handle_timer_trap(){
    ticks++;    //计时器递增
    sbi_set_timer(r_time()+TIMER_INTERVAL); //设置下一次时钟中断的时间间隔
    w_sip(r_sip()&(~SIP_SSIP)); //清除中断等待
    check_nanosleep_per_clk();
    if(ticks==TIME_SLICE && current!=NULL){  //如果时间片到了
        ticks=0;    //计时器归零
        if(current->state==RUNNING){    //将当前进程插入就绪队列
            current->state=READY;
            insert_into_queue(&runnable_queue,current);
        }
        intr_off();
        into_schedule();     //调用schedule调度进程
    }
}

//trap初始化，OS启动时调用
void trap_init(){
    //设置sstatus寄存器，具体参见riscv特权寄存器
    
    uint64 x = r_sstatus(); 
    x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    x |= SSTATUS_SIE;       //enable supervisor-mode interrupts.
    x |= SSTATUS_SPIE;  // enable interrupts in user mode
    w_sstatus(x);

    w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);    //开启中断使能位
    w_stvec((uint64)kernel_trap_vec);   //trap初始化时还处于内核态，因此先将stvec的值设置位kernel_trap_vec
    sbi_set_timer(r_time()+TIMER_INTERVAL); //设置下一次时钟中断的时间间隔
}

//当用户态发生trap时，user_trap_vec会跳转进入user_trap处理用户态的trap
void user_trap(){
    //更新进程运行时间
    uint64 tm=read_time();
    current->enter_ktimes=tm;
    current->times.utime+=(tm-current->leave_ktimes);
    
    //printk("user_trap\n");
    //检查是否是来自用户态的trap
    if((r_sstatus() & SSTATUS_SPP) != 0){
        panic("usertrap: not from user mode");
    }

    current->trapframe->epc=r_sepc();   //获取trap发生时的那条指令的虚拟地址
    uint64 cause=r_scause();    //获取trap发生的原因
    w_stvec((uint64)kernel_trap_vec);
    switch (cause){     
        case CAUSE_TIMER_S_TRAP:
            handle_timer_trap(); 
            break;
        case CAUSE_USER_ECALL:
            handle_syscall();
            break;
        case CAUSE_EXTERN_IRQ:
            handle_extern_irq();
            break;
        
        default:
            printk("scause=%p\n",(void*)cause);
            printk("epc=%p\n",(void*)current->trapframe->epc);
            printk("epc_pa=%p\n",va_to_pa(current->pagetable, (void*)current->trapframe->epc));
            printk("size=%d\n",current->size);
            printk("stval=%p\n",(void*)r_stval());
            printk("stval_pa=%p\n",(void*)va_to_pa(current->pagetable,(void*)(r_stval())));
            printk("current pid:%d\n",current->pid);
            printk("current name:%s\n",current->name);
            printk("ra: %p\n",current->trapframe->regs.ra);
            printk("sp: %p\n",current->trapframe->regs.sp);
            panic("unhandled trap\n");
            break;
    }
    user_trap_ret();    //返回用户态
}

//返回用户态
void user_trap_ret(){
    //printk("switch to pid:%d\n",current->pid);
    intr_off(); //关闭中断，执行sret后会自动打开中断
    // set S Previous Privilege mode to User.
    switch_to(current); //切换到当前进程
}

//内核态发生trap时，调用该函数处理
//内核态中断主要是处理设备中断，而目前的设备中断只有时钟中断
void kernel_trap(){
    //printk("enter kernel_trap\n");    
    uint64 sepc=r_sepc();
    uint64 status=r_sstatus();
    uint64 cause=r_scause();
  
    if((status & SSTATUS_SPP) == 0)
        panic("kerneltrap: not from supervisor mode");
    if(intr_get() != 0)
        panic("kerneltrap: interrupts enabled");
    switch (cause){
        case CAUSE_TIMER_S_TRAP:
            handle_timer_trap();
            break;
        case CAUSE_EXTERN_IRQ:
            handle_extern_irq();
            break;
        default:
            printk("scause=%p\n",(void*)cause);
            panic("unhandled trap\n");
            break;
    }
    w_sepc(sepc);
    w_sstatus(status);
}

void handle_extern_irq(){
    int is_exirq;
    #ifndef QEMU
    is_exirq=(r_stval()==9);
    #else
    uint64 scause=r_scause();
    is_exirq=((0x8000000000000000L & scause) && 9 == (scause & 0xff));
    #endif

    if(is_exirq){
        int irq=plic_claim();
		if (irq==UART_IRQ){
			// keyboard input 
			int c=sbi_console_getchar();
			if (c!=-1)
				console_intr(c);
		}
		else if (irq==DISK_IRQ){
            #ifndef QEMU
			panic("disk interrupt\n");
            #else
            virtio_disk_intr();
            #endif
		}
		else if (irq){
			printk("irq=%d\n", irq);
            panic("unexpected interrupt\n");
        }

		clear_plic(irq);
    }
    
}

void clear_plic(int irq){
    if (irq){
        plic_complete(irq);
    }
	w_sip(r_sip()&(~SIP_SSIP)); //清除中断等待
	sbi_set_mie();
}