#include "process.h"
#include "string.h"
#include "pmlayout.h"
#include "pm.h"
#include "vm.h"
#include "printk.h"
#include "schedule.h"

process proc_list[NPROC];

process *current;

extern char trampoline[];
extern void return_to_user();
extern void user_trap_vec();

void user_trap();

static void map_code_segment(process*, process*,int);
static void copy_data_segment(process*,process*,int);

void init_proc_list(){
    for(int i=0;i<NPROC;i++){
        proc_list[i].state=UNUSED;
        proc_list[i].pid=i+1;
    }
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

    p->kstack=(uint64)alloc_physical_page()+PGSIZE;
    uint64 user_stack=(uint64)alloc_physical_page();
    p->trapframe->regs.sp=USER_STACK_TOP;


    p->segment_map_info=(segment_map_info*)alloc_physical_page();
    memset(p->segment_map_info,0,PGSIZE);

    p->segment_num=0;

    user_vm_map(p->pagetable,USER_STACK_TOP-PGSIZE,PGSIZE,user_stack,
        pte_permission((PAGE_READ | PAGE_WRITE),1));
    p->segment_map_info[0].page_num=1;
    p->segment_map_info[0].seg_type=STACK_SEGMENT;
    p->segment_map_info[0].va=USER_STACK_TOP-PGSIZE;
    p->segment_num++;

    user_vm_map(p->pagetable,(uint64)p->trapframe,PGSIZE,(uint64)p->trapframe,
        pte_permission((PAGE_READ | PAGE_WRITE),0));
    p->segment_map_info[1].page_num=1;
    p->segment_map_info[1].seg_type=TRAPFRAME_SEGMENT;
    p->segment_map_info[1].va=(uint64)p->trapframe;
    p->segment_num++;


    user_vm_map(p->pagetable,(uint64)trampoline,PGSIZE,(uint64)trampoline,
        pte_permission((PAGE_READ | PAGE_EXEC),0));
    p->segment_map_info[2].page_num=1;
    p->segment_map_info[2].seg_type=SYSTEM_SEGMENT;
    p->segment_map_info[2].va=(uint64)trampoline;
    p->segment_num++;

    return p;
}

int free_process( process* proc ) {
    intr_off();
    proc->state= ZOMBIE;
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
                map_code_segment(parent, child, i);
                break;
            case DATA_SEGMENT:
                copy_data_segment(parent, child ,i);
                break;
        }
    }

    child->state = RUNNABLE;
    child->trapframe->regs.a0 = 0;
    child->parent = parent;
    insert_to_runnable_queue(child);
    return child->pid;
}

void switch_to(process* proc) {
    current = proc;

    //write_csr(stvec, (uint64)smode_trap_vector);
    w_stvec((uint64)user_trap_vec);
    // set up trapframe values that smode_trap_vector will need when
    // the process next re-enters the kernel.
    proc->trapframe->kernel_sp = proc->kstack;      // process's kernel stack
    proc->trapframe->kernel_satp = r_satp();  // kernel page table
    proc->trapframe->kernel_trap = (uint64)user_trap;

    // set up the registers that strap_vector.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    x |= SSTATUS_SPIE;  // enable interrupts in user mode

    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc((uint64)proc->trapframe->epc);

    w_sscratch((uint64)proc->trapframe);

    
    //make user page table
    w_satp(MAKE_SATP((uint64)proc->pagetable));
    sfence_vma();

    // switch to user mode with sret.
    return_to_user();
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

static void map_code_segment(process* parent, process* child, int i){
    user_vm_map(
                    child->pagetable,
                    parent->segment_map_info[i].va,
                    parent->segment_map_info[i].page_num*PGSIZE,
                    find_pa_align_pgsize(parent->pagetable, parent->segment_map_info[i].va),
                    pte_permission(PAGE_READ | PAGE_EXEC, 1)
                );
    child->segment_map_info[child->segment_num].page_num=parent->segment_map_info[i].page_num;
    child->segment_map_info[child->segment_num].seg_type=CODE_SEGMENT;
    child->segment_map_info[child->segment_num].va=parent->segment_map_info[i].va;
    child->segment_num++;
}

static void copy_data_segment(process* parent,process* child,int i){
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
            pte_permission(PAGE_READ | PAGE_WRITE, 1)
        );
    }
    child->segment_map_info[child->segment_num].page_num=parent->segment_map_info[i].page_num;
    child->segment_map_info[child->segment_num].seg_type=DATA_SEGMENT;
    child->segment_map_info[child->segment_num].va=parent->segment_map_info[i].va;
    child->segment_num++;
}