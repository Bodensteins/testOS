#include "pm.h"
#include "vm.h"
#include "process.h"
#include "printk.h"
#include "sbi.h"

process *runnable_queue=NULL;
extern pagetable_t kernel_pagetable;

void insert_to_runnable_queue(process *proc){
    if(runnable_queue==NULL){
        runnable_queue=proc;
        proc->queue_next=NULL;
        return;
    }

    process *p;
    for(p=runnable_queue;p->queue_next!=NULL;p=p->queue_next){
        if(p->pid==proc->pid)
            return;
    }
    if(p->pid==proc->pid)
        return;
    p->queue_next=proc;
    proc->queue_next=NULL;
    proc->state=RUNNABLE;
}

void delete_from_runnable_queue(process *proc){
    if(runnable_queue==NULL)
        return;
    if(runnable_queue==proc){
        runnable_queue=runnable_queue->queue_next;
        return;
    }
    process*pre=runnable_queue, *cur=runnable_queue->queue_next;
    for(;cur!=NULL;pre=pre->queue_next,cur=cur->queue_next){
        if(cur==proc){
            pre->queue_next=cur->queue_next;
            return;
        }
    }
    return;
}

void schedule(){
    if ( runnable_queue==NULL ){
        //int should_shutdown = 1;
        return;
    }

    if(proc_list[0].state==ZOMBIE){
        sbi_shutdown();
    }

    if(current!=NULL && current->state==ZOMBIE){
        printk("zombie: %d\n", current->pid);
        current->state=UNUSED;
        
        for(int i=0;i<current->segment_num;i++){
            segment_map_info* seg=current->segment_map_info+i;
            int free=1;
            if(seg->seg_type==SYSTEM_SEGMENT || 
                seg->seg_type==CODE_SEGMENT)
                free=0;
            user_vm_unmap(current->pagetable, seg->va,seg->page_num*PGSIZE,free);
        }
        
        //free_physical_page((void*)(current->kstack-PGSIZE));
        free_physical_page(current->segment_map_info);
        free_pagetable(current->pagetable);
    }
    //printk("run process\n");
    current = runnable_queue;
    runnable_queue = runnable_queue->queue_next;
    printk("running process: %d\n",current->pid);
    current->state = RUNNING;
    switch_to( current );   
}