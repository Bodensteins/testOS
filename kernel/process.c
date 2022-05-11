#include "include/process.h"
#include "include/string.h"
#include "include/pmlayout.h"
#include "include/pm.h"
#include "include/vm.h"
#include "include/printk.h"
#include "include/schedule.h"
#include "include/sleeplock.h"
#include "include/sbi.h"
#include "include/elf.h"

process proc_list[NPROC];   //进程池

process *current=NULL;  //当前运行的进程(目前未实现多核机制，因此先用这个全局变量代替)

extern char trampoline[];   //在usertrapvec.S中定义的符号
extern char return_to_user[];   //在usertrapvec.S中定义的符号
extern char user_trap_vec[];    //在usertrapvec.S中定义的符号

void user_trap();   //trap.c中的函数，处理用户态的trap
void user_trap_ret();   //trap.c中的函数，返回用户态

static void open_file_list_init(process*);  //初始化process中的打开文件列表
static void map_segment(process*, process*,int);   //段映射，使得一个进程共享另一个进程的程序段
static void copy_segment(process*,process*,int);   //段复制，将一个进程的程序段复制给另外一个进程
static void release_process(process *proc);     //释放proc进程所有资源
static void process_sleep_on_wait4(process *proc);  //子进程还未结束，调用此函数睡眠
static void process_wakeup_on_wait4(process *proc);  //子进程退出时，调用此函数尝试唤醒父进程

//进程池初始化函数，OS启动时调用
void proc_list_init(){
    for(int i=0;i<NPROC;i++){
        proc_list[i].state=UNUSED;  //初始时进程池中所有的进程都是UNUSED
        proc_list[i].pid=i+1;   //设置进程pid
        proc_list[i].killed=0;
        proc_list[i].size=0;

        proc_list[i].wait4_args.woptions=0;
        proc_list[i].wait4_args.wpid=0;
        proc_list[i].wait4_args.wstatus=NULL;

        proc_list[i].cwd=NULL; 
        open_file_list_init(proc_list+i);   //初始化process中的打开文件列表

        init_spinlock(&proc_list[i].spinlock,"process lock");   //初始化进程的自旋锁

        proc_list[i].kstack=(uint64)alloc_physical_page()+PGSIZE;   //为每个进程分配内核栈

        //记录进程各个段的信息的结构，分配一页
        proc_list[i].segment_map_info=(segment_map_info*)alloc_physical_page(); 
        memset(proc_list[i].segment_map_info,0,PGSIZE);
        proc_list[i].segment_num=0;
    }
}

//初始化process中的打开文件列表
static void open_file_list_init(process *proc){
    memset(proc->open_files,0,N_OPEN_FILE*sizeof(file));//所有指针都是NULL
}

process *alloc_process(){
    
    int i;
    process *p;
    for(i=0;i<NPROC;i++){   //在进程池中寻找UNUSED的进程项
        if(proc_list[i].state==UNUSED)
            break;
    }
    if(i==NPROC)    //如果没找到，说明进程池满了
        return NULL;
    p=proc_list+i;  //找到了

    p->pagetable=(pagetable_t)alloc_physical_page();    //分配页表
    memset(p->pagetable,0,PGSIZE);

    p->trapframe=(trapframe*)alloc_physical_page(); //分配trapframe
    memset(p->trapframe,0,PGSIZE);
    
    uint64 user_stack=(uint64)alloc_physical_page();    //分配用户栈，目前大小只有一页
    p->trapframe->regs.sp=USER_STACK_TOP;

    p->exit_state=0;

    p->segment_num=0;

    //在页表中映射用户栈地址
    user_vm_map(p->pagetable,USER_STACK_TOP-PGSIZE,PGSIZE,user_stack,
        pte_permission(1,1,0,1));
    //在segment_map_info中记录用户栈段的信息
    p->segment_map_info[0].page_num=1;
    p->segment_map_info[0].seg_type=STACK_SEGMENT;
    p->segment_map_info[0].va=USER_STACK_TOP-PGSIZE;
    p->segment_num++;

    //在页表中映射trapframe的地址
    user_vm_map(p->pagetable,TRAPFRAME,PGSIZE,(uint64)p->trapframe,
        pte_permission(1,1,0,0));
    //在segment_map_info中记录trapframe段的信息
    p->segment_map_info[1].page_num=1;
    p->segment_map_info[1].seg_type=TRAPFRAME_SEGMENT;
    p->segment_map_info[1].va=TRAPFRAME;
    p->segment_num++;

    //在页表中映射trap处理程序的地址
    user_vm_map(p->pagetable,TRAMPOLINE,PGSIZE,(uint64)trampoline,
        pte_permission(1,0,1,0));
    ////在segment_map_info中记录trap处理程序段的信息
    p->segment_map_info[2].page_num=1;
    p->segment_map_info[2].seg_type=SYSTEM_SEGMENT;
    p->segment_map_info[2].va=TRAMPOLINE;
    p->segment_num++;

    return p;
}

//切换到指定进程
void switch_to(process* proc) {
    current=proc;

    if(proc->killed==1){
        //reparent(proc);
        proc->exit_state=1;
        process_zombie(proc); //free_process调用之后会进入schedule,再由schedule调用switch_to
        process_wakeup_on_wait4(proc->parent);   //need to wake up its parent
        schedule();
    }

    w_stvec(TRAMPOLINE+(user_trap_vec-trampoline)); //将user_trap_vec的虚拟地址写入stvec
    //将一些重要信息保存在trapframe中
    proc->trapframe->kernel_sp=proc->kstack;    //内核栈底部地址
    proc->trapframe->kernel_satp=r_satp();  //内核页表
    proc->trapframe->kernel_trap=(uint64)user_trap; //用户trap处理程序地址

    unsigned long x=r_sstatus();    //设置sstatus，参见riscv特权寄存器
    x &= ~SSTATUS_SPP;
    x |= SSTATUS_SPIE;
    w_sstatus(x);

    w_sepc((uint64)proc->trapframe->epc);   //设置sepc
    
    //切换页表后调用return_to_user函数(定义于usertrapvec.S)
    //因此须将其转换为对应的虚拟地址
    //类似于xv6的操作方式
    uint64 user_ret=TRAMPOLINE+(return_to_user-trampoline);  
    w_sscratch(TRAPFRAME);  //将trapframe的虚拟地址写入sscratch
    w_satp(MAKE_SATP((uint64)proc->pagetable));
    ((void(*)())user_ret)(); //转换为函数指针类型然后调用
    //return_to_user();
}

//将进程状态置为ZOMBIE
//之后交给schedule处理
int process_zombie(process* proc){
    intr_off();
    proc->state=ZOMBIE;
    //reparent(proc)
    return 0;
}

//实现fork功能，创建一个一模一样的新进程，与UNIX的fork功能一致
//为了简单，没有写时复制机制
uint64 do_fork(process *parent){
    return do_clone(parent,0,0);
}

//实现clone系统调用
uint64 do_clone(process *parent, uint64 flag, uint64 stack){
    process *child;
    child=alloc_process();  //从进程池分配一个新的进程

    //根据segment_map_info将父进程每个段都复制一份交给子进程
    for(int i=0;i<parent->segment_num;i++){
        switch(parent->segment_map_info[i].seg_type){
            case STACK_SEGMENT: //用户栈段
                /*
                if(stack!=0){
                    segment_map_info* seg=child->segment_map_info+i;
                    user_vm_unmap(child->pagetable, seg->va,seg->page_num*PGSIZE,1);
                    seg->page_num=0;
                    seg->va=stack;
                    // Do we need to copy data in parent's stack to child here?
                }
                else{
                    memcpy((void*)find_pa_align_pgsize(child->pagetable, child->segment_map_info[i].va),
                        (void*)find_pa_align_pgsize(parent->pagetable, parent->segment_map_info[i].va), PGSIZE);
                }
                */
                memcpy((void*)find_pa_align_pgsize(child->pagetable, child->segment_map_info[i].va),
                        (void*)find_pa_align_pgsize(parent->pagetable, parent->segment_map_info[i].va), PGSIZE);
                break; 
            case TRAPFRAME_SEGMENT://trapframe段
                *child->trapframe = *parent->trapframe;
                break;
            case CODE_SEGMENT:  //代码段
                copy_segment(parent, child, i);
                break;
            case DATA_SEGMENT:  //数据段(但实际上elf文件似乎将代码和数据都放到了一个段，所以这里似乎并没有什么意义)
                copy_segment(parent, child ,i);
                break;
        }
    }

    /*
    if(stack!=0)
        child->trapframe->regs.sp=stack;
    */

    //将父进程的文件描述符都复制给子进程
    for(int i=0;i<N_OPEN_FILE;i++){
        if(parent->open_files[i]!=NULL)
            child->open_files[i]=file_dup(parent->open_files[i]);
    }
    
    //设置子进程的当前工作目录
    child->cwd=dirent_dup(parent->cwd);

    child->size=parent->size;
    child->state=READY;
    child->trapframe->regs.a0=0; //子进程的fork返回0
    child->parent=parent;
    insert_into_queue(&runnable_queue,child);    //将子进程插入就绪队列
    return child->pid;  //父进程的fork返回i子进程pid
}

//根据pid杀死当前进程
uint64 do_kill(uint64 pid){
    if(pid<=1 || pid>NPROC || proc_list[pid-1].state==UNUSED)
        return 1;
    proc_list[pid-1].killed=1;
    if(proc_list[pid-1].state==SLEEPING){//进程在睡眠态的情况，这里还没有给出完善的处理
        proc_list[pid-1].state=READY;
        //to do
        insert_into_queue(&runnable_queue,proc_list+pid-1);
    }
    return 0;
}

//遍历进程池
//如果一个进程的父进程是p
//则将其父进程重新设置为1号进程
//一般用于进程p死亡时给其子进程重新设置父进程
void reparent(process* p){
    for(int i=1;i<NPROC;i++){
        if(proc_list[i].state!=UNUSED && proc_list[i].parent==p)
            proc_list[i].parent=proc_list;
    }
}

//令当前进程放弃CPU
//将当前进程状态置为就绪态
//然后将其插入就绪队列
//最后调用schedule函数
void do_yield(){
    current->state=READY;
    insert_into_queue(&runnable_queue,current);
    schedule();
}

//工具函数，用于do_fork(虽然现在还没用)
//根据segment_map_info，通过i索引，将parent的某一段与child共享
static void map_segment(process* parent, process* child, int i){
    user_vm_map(    //将该段的地址映射到child的页表中
                    child->pagetable,
                    parent->segment_map_info[i].va,
                    parent->segment_map_info[i].page_num*PGSIZE,
                    find_pa_align_pgsize(parent->pagetable, parent->segment_map_info[i].va),
                    pte_permission(1,1,1,1)
                );
    //更新child的segment_map_info
    child->segment_map_info[child->segment_num].page_num=parent->segment_map_info[i].page_num;
    child->segment_map_info[child->segment_num].seg_type=parent->segment_map_info[i].page_num;
    child->segment_map_info[child->segment_num].va=parent->segment_map_info[i].va;
    child->segment_num++;
}

//工具函数，用于do_fork
//根据segment_map_info，通过i索引到指定段，将parent的某一段复制一份给child
static void copy_segment(process* parent,process* child,int i){
    int pn=parent->segment_map_info[i].page_num;
    uint64 pdata_pa,cdata_pa;
    for(int k=0;k<pn;k++){  //开始复制

        //找到待复制段的物理页地址
        pdata_pa=find_pa_align_pgsize(  
            parent->pagetable,
            parent->segment_map_info[i].va+k*PGSIZE
        );
        if(pdata_pa==0)
            printk("panic: copy data segement\n");

        //复制到新地址
        cdata_pa=(uint64)alloc_physical_page();
        memcpy((void*)cdata_pa, (void*)pdata_pa, PGSIZE);   

        //地址映射到child的页表中
        user_vm_map(    
            child->pagetable,
            parent->segment_map_info[i].va+k*PGSIZE,
            PGSIZE,cdata_pa,
            pte_permission(1,1,1,1)
        );
    }
    
    //更新child的segment_map_info
    child->segment_map_info[child->segment_num].page_num=parent->segment_map_info[i].page_num;
    child->segment_map_info[child->segment_num].seg_type=parent->segment_map_info[i].seg_type;
    child->segment_map_info[child->segment_num].va=parent->segment_map_info[i].va;
    child->segment_num++;
}

//释放proc进程所有资源
static void release_process(process *proc){
    proc->state=UNUSED;  //状态置为UNUSED
        
    for(int i=0;i<N_OPEN_FILE;i++){ //关闭所有还打开的文件
        if(proc->open_files[i]!=NULL)
            release_file(proc->open_files[i]);
    }

    release_dirent(proc->cwd);   //释放当前目录的目录项缓冲

    for(int i=0;i<proc->segment_num;i++){    //根据segment_map_info释放进程占用的内存
        segment_map_info* seg=proc->segment_map_info+i;
        int free=1;
        if(seg->seg_type==SYSTEM_SEGMENT){  //trampoline段为内核和所有进程共享，不能释放，只是解除地址映射
            free=0;
        }
        if(seg->page_num>0)
            user_vm_unmap(proc->pagetable, seg->va,seg->page_num*PGSIZE,free);
    }
    
    free_pagetable(proc->pagetable);     //将页表占用的内存释放
    proc->segment_map_info->page_num=0;
    proc->size=0;
}

//子进程还未结束，调用此函数睡眠
static void process_sleep_on_wait4(process *proc){
    proc->state=SLEEPING;
    insert_into_queue(&wait4_queue,proc);   //插入wait4队列
    schedule();
}

//子进程退出时，调用此函数尝试唤醒父进程
static void process_wakeup_on_wait4(process *proc){
    if(proc->state!=SLEEPING)
        return;
    if(proc->wait4_args.wpid!=-1 && proc->wait4_args.wpid!=current->pid)
        return;
    
    if(delete_from_queue(&wait4_queue,proc)!=0) //从wait4队列中删除
        return;

    //获取wait4参数
    int wpid=current->pid;
    int *wstatus=proc->wait4_args.wstatus;
    uint64 woptions=proc->wait4_args.woptions;
    proc->wait4_args.wpid=0;
    proc->wait4_args.wstatus=0;
    proc->wait4_args.woptions=0;

    //将父进程设置为当前运行进程
    proc->state=RUNNING;
    current=proc;

    //父进程重新运行do_wait4
    current->trapframe->regs.a0=do_wait4(wpid,wstatus,woptions);
    user_trap_ret();    //直接返回父进程用户态
}

//实际执行wait4的函数
uint64 do_wait4(int pid, int* status, uint64 options){
    if(pid<-1 || pid==0 || pid>NPROC)
        return -1;

    uint8 is_child=0;
    process *child;
    //acqiure lock

    if(pid>0 && proc_list[pid-1].parent==current){  //如果pid不为-1且确为子进程
        is_child=1;     //子进程找到了
        child=proc_list+pid-1;
        if(child->state==ZOMBIE){   //如果子进程已经结束
            //acquire child's lock
            uint64 child_pid=child->pid;
            //release lock
            *status=child->exit_state<<8;   //获取子进程exit返回值
            release_process(child);     //释放其资源
            //release child's lock
            return child_pid;   //返回子进程pid
        }
    }
    else if(pid==-1){   //如果pid参数为-1，则搜索其任一子进程
        //遍历进程池，可优化
        for(int i=1;i<NPROC;i++){
            if(proc_list[i].parent==current && pid==-1){    //子进程找到了
                is_child=1;
                //acquire child's lock
                child=proc_list+i;
                if(child->state!=ZOMBIE){   //子进程并未结束，继续搜索
                    //release child's lock
                    continue;
                }
                else{   //子进程确实结束了
                    uint64 child_pid=child->pid;
                    //release lock
                    *status=child->exit_state<<8;   //获取子进程exit返回值
                    release_process(child);      //释放其资源
                    //release child's lock
                    return child_pid;   //返回子进程pid
                }
            }
        }
    }

    if(!is_child || current->killed){   //没有子进程或已被杀死则直接返回i
        //release lock
        return -1;
    }
    else{   //如果有子进程
        if (options & WAIT_OPTIONS_WNOHANG) {   //如果有WAIT_OPTIONS_WNOHANG参数，则不必等待直接返回i
			//release lock
			return 0;
		}
        else{   //否则，记录下wait4参数，然后睡眠等待
            //sleep
            current->wait4_args.wpid=pid;
            current->wait4_args.wstatus=status;
            current->wait4_args.woptions=options;
            process_sleep_on_wait4(current);
        }
    }
    
    //正常情况下，不可能运行至此处，否则为异常，返回-1
    return -1;
}

//实际执行进程结束的函数
uint64 do_exit(int xstate){
    if(current->pid==1)
        sbi_shutdown();
    
    //reparent(current);
    current->exit_state=xstate;
    process_zombie(current);    //进程变为僵尸态
    process_wakeup_on_wait4(current->parent);   //尝试唤醒父进程
    schedule();     //未能唤醒父进程，继续调度
    
    //正常情况下，不可能运行至此处
    return xstate;
}