#include "pm.h"
#include "vm.h"
#include "process.h"
#include "printk.h"

process *runnable_queue=NULL;

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

    current = runnable_queue;
    runnable_queue = runnable_queue->queue_next;
    //printk("running process: %d\n",current->pid);
    current->state = RUNNING;
    switch_to( current );   
}