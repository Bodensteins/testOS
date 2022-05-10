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

static void open_file_list_init(process*);  //初始化process中的打开文件列表
void map_segment(process*, process*,int);   //段映射，使得一个进程共享另一个进程的程序段
void copy_segment(process*,process*,int);   //段复制，将一个进程的程序段复制给另外一个进程

//进程池初始化函数，OS启动时调用
void proc_list_init(){
    for(int i=0;i<NPROC;i++){
        proc_list[i].state=UNUSED;  //初始时进程池中所有的进程都是UNUSED
        proc_list[i].pid=i+1;   //设置进程pid
        proc_list[i].killed=0;
        proc_list[i].size=0;

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

//释放一个进程(将其状态置为ZOMBIE)
//之后交给schedule处理
int free_process(process* proc){
    intr_off();
    proc->state=ZOMBIE;
    schedule();
    //delete_from_runnable_queue(proc);
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
    insert_to_runnable_queue(child);    //将子进程插入就绪队列
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
        insert_to_runnable_queue(proc_list+pid-1);
    }
    return 0;
}

//切换到指定进程
void switch_to(process* proc) {
    current = proc;

    if(current->killed==1)
        free_process(current); //free_process调用之后会进入schedule,再由schedule调用switch_to

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
    uint64 ret=TRAMPOLINE+(return_to_user-trampoline);  
    w_sscratch(TRAPFRAME);  //将trapframe的虚拟地址写入sscratch
    w_satp(MAKE_SATP((uint64)proc->pagetable));
    ((void(*)())ret)(); //转换为函数指针类型然后调用
    //return_to_user();
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
void yield(){
    current->state=READY;
    insert_to_runnable_queue(current);
    schedule();
}

//工具函数，用于do_fork(虽然现在还没用)
//根据segment_map_info，通过i索引，将parent的某一段与child共享
void map_segment(process* parent, process* child, int i){
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
void copy_segment(process* parent,process* child,int i){
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
