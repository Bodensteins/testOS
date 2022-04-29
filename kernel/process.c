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

process proc_list[NPROC];

process *current=NULL;

extern char trampoline[];
extern char return_to_user[];
extern char user_trap_vec[];

void user_trap();

static void open_file_list_init(process*);
void map_segment(process*, process*,int);
void copy_segment(process*,process*,int);

void proc_list_init(){
    for(int i=0;i<NPROC;i++){
        proc_list[i].state=UNUSED;
        proc_list[i].pid=i+1;
        proc_list[i].killed=0;
        proc_list[i].size=0;

        proc_list[i].cwd=NULL;
        open_file_list_init(proc_list+i);

        init_spinlock(&proc_list[i].spinlock,"process lock");

        proc_list[i].kstack=(uint64)alloc_physical_page()+PGSIZE;

        proc_list[i].segment_map_info=(segment_map_info*)alloc_physical_page();
        memset(proc_list[i].segment_map_info,0,PGSIZE);

        proc_list[i].segment_num=0;
    }
}

static void open_file_list_init(process *proc){
    memset(proc->open_files,0,N_OPEN_FILE*sizeof(file));
}

process *alloc_process(){
  
    int i;
    process *p;
    for(i=0;i<NPROC;i++){
        if(proc_list[i].state==UNUSED)
            break;
    }
    if(i==NPROC)
        return NULL;
    p=proc_list+i;

    p->pagetable=(pagetable_t)alloc_physical_page();
    memset(p->pagetable,0,PGSIZE);

    p->trapframe=(trapframe*)alloc_physical_page();
    memset(p->trapframe,0,PGSIZE);
    
    uint64 user_stack=(uint64)alloc_physical_page();
    p->trapframe->regs.sp=USER_STACK_TOP;

    p->segment_num=0;

    user_vm_map(p->pagetable,USER_STACK_TOP-PGSIZE,PGSIZE,user_stack,
        pte_permission((PAGE_READ | PAGE_WRITE),1));
    p->segment_map_info[0].page_num=1;
    p->segment_map_info[0].seg_type=STACK_SEGMENT;
    p->segment_map_info[0].va=USER_STACK_TOP-PGSIZE;
    p->segment_num++;

    user_vm_map(p->pagetable,TRAPFRAME,PGSIZE,(uint64)p->trapframe,
        pte_permission((PAGE_READ | PAGE_WRITE),0));
    p->segment_map_info[1].page_num=1;
    p->segment_map_info[1].seg_type=TRAPFRAME_SEGMENT;
    p->segment_map_info[1].va=TRAPFRAME;
    p->segment_num++;

    user_vm_map(p->pagetable,TRAMPOLINE,PGSIZE,(uint64)trampoline,
        pte_permission((PAGE_READ | PAGE_EXEC),0));
    p->segment_map_info[2].page_num=1;
    p->segment_map_info[2].seg_type=SYSTEM_SEGMENT;
    p->segment_map_info[2].va=TRAMPOLINE;
    p->segment_num++;

    return p;
}

int free_process(process* proc){
    intr_off();
    proc->state=ZOMBIE;
    schedule();
    //delete_from_runnable_queue(proc);
    return 0;
}

uint64 do_fork(process *parent){
    process *child;
    child=alloc_process();

    for(int i=0;i<parent->segment_num;i++){
        switch(parent->segment_map_info[i].seg_type){
            case STACK_SEGMENT:
                memcpy( (void*)find_pa_align_pgsize(child->pagetable, child->segment_map_info[i].va),
                (void*)find_pa_align_pgsize(parent->pagetable, parent->segment_map_info[i].va), PGSIZE );
                break; 
            case TRAPFRAME_SEGMENT:
                *child->trapframe = *parent->trapframe;
                break;
            case CODE_SEGMENT:
                copy_segment(parent, child, i);
                break;
            case DATA_SEGMENT:
                copy_segment(parent, child ,i);
                break;
        }
    }

    for(int i=0;i<N_OPEN_FILE;i++){
        if(parent->open_files[i]!=NULL)
            child->open_files[i]=file_dup(parent->open_files[i]);
    }
    
    child->cwd=dirent_dup(parent->cwd);

    child->size=parent->size;
    child->state=RUNNABLE;
    child->trapframe->regs.a0=0;
    child->parent=parent;
    insert_to_runnable_queue(child);
    return child->pid;
}

uint64 do_kill(uint64 pid){
    if(pid<=1 || pid>NPROC || proc_list[pid-1].state==UNUSED)
        return 1;
    proc_list[pid-1].killed=1;
    if(proc_list[pid-1].state==SLEEPING){
        proc_list[pid-1].state=RUNNABLE;

        insert_to_runnable_queue(proc_list+pid-1);
    }
    return 0;
}

void switch_to(process* proc) {
    current = proc;

    if(current->killed==1)
        free_process(current);

    w_stvec(TRAMPOLINE+(user_trap_vec-trampoline));
    //w_stvec((uint64)user_trap_vec);
    proc->trapframe->kernel_sp=proc->kstack;
    proc->trapframe->kernel_satp=r_satp();
    proc->trapframe->kernel_trap=(uint64)user_trap;

    unsigned long x=r_sstatus();
    x &= ~SSTATUS_SPP;
    x |= SSTATUS_SPIE;
    w_sstatus(x);

    w_sepc((uint64)proc->trapframe->epc);
    uint64 ret=TRAMPOLINE+(return_to_user-trampoline);
    w_sscratch(TRAPFRAME);
    w_satp(MAKE_SATP((uint64)proc->pagetable));
    ((void(*)())ret)();
    //return_to_user();
}

void reparent(process* p){
    for(int i=1;i<NPROC;i++){
        if(proc_list[i].state!=UNUSED && proc_list[i].parent==p)
            proc_list[i].parent=proc_list;
    }
}

void yield(){
    current->state=RUNNABLE;
    insert_to_runnable_queue(current);
    schedule();
}

void map_segment(process* parent, process* child, int i){
    user_vm_map(
                    child->pagetable,
                    parent->segment_map_info[i].va,
                    parent->segment_map_info[i].page_num*PGSIZE,
                    find_pa_align_pgsize(parent->pagetable, parent->segment_map_info[i].va),
                    pte_permission(PAGE_READ | PAGE_EXEC | PAGE_WRITE, 1)
                );
    child->segment_map_info[child->segment_num].page_num=parent->segment_map_info[i].page_num;
    child->segment_map_info[child->segment_num].seg_type=parent->segment_map_info[i].page_num;
    child->segment_map_info[child->segment_num].va=parent->segment_map_info[i].va;
    child->segment_num++;
}

void copy_segment(process* parent,process* child,int i){
    int pn=parent->segment_map_info[i].page_num;
    uint64 pdata_pa,cdata_pa;
    for(int k=0;k<pn;k++){
        pdata_pa=find_pa_align_pgsize(
            parent->pagetable,
            parent->segment_map_info[i].va+k*PGSIZE
        );
        if(pdata_pa==0)
            printk("panic: copy data segement\n");
        cdata_pa=(uint64)alloc_physical_page();
        memcpy((void*)cdata_pa, (void*)pdata_pa, PGSIZE);
        user_vm_map(
            child->pagetable,
            parent->segment_map_info[i].va+k*PGSIZE,
            PGSIZE,cdata_pa,
            pte_permission(PAGE_READ | PAGE_EXEC | PAGE_WRITE, 1)
        );
    }
    child->segment_map_info[child->segment_num].page_num=parent->segment_map_info[i].page_num;
    child->segment_map_info[child->segment_num].seg_type=parent->segment_map_info[i].seg_type;
    child->segment_map_info[child->segment_num].va=parent->segment_map_info[i].va;
    child->segment_num++;
}
