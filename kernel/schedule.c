#include "include/pm.h"
#include "include/vm.h"
#include "include/process.h"
#include "include/printk.h"
#include "include/sbi.h"
#include "include/file.h"

/*
进程调度相关
采用循环轮转方法调度进程
维护一个就绪队列
每当经过一个时间片后，将当前进程插入就绪队列尾端，并将队列首端进程设置为当前运行进程
*/


process *runnable_queue=NULL;   //就绪队列
process *wait4_queue=NULL;  //wait4等待队列
extern pagetable_t kernel_pagetable;    //内核页表的声明

//将进程proc插入queue队列末端
//queue为指定队列的指针
void insert_into_queue(process **queue, process *proc){
    if(proc==NULL){
        return;
    }

    if(*queue==NULL){   //如果队列为空，则直接插入
        //printk("what?\n");
        *queue=proc;
        proc->queue_next=NULL;
        return;
    }

    process *p;
    //遍历队列，检查该进程是否已经被插入队列
    for(p=*queue;p->queue_next!=NULL;p=p->queue_next){
        if(p->pid==proc->pid)
            return;
    }
    if(p->pid==proc->pid)
        return;
    
    //插入到队列尾端
    p->queue_next=proc;
    proc->queue_next=NULL;
}

//将进程proc从队列queue中删除
//queue为指定队列的指针
int delete_from_queue(process **queue, process *proc){
    if(proc==NULL)
        return -1;

    if(*queue==NULL)
        return -1;

    //遍历队列，如果发现proc则删除并返回0
    //否则返回-1    
    if(*queue==proc){
        *queue=(*queue)->queue_next;
        return 0;
    }
    process*pre=*queue, *cur=(*queue)->queue_next;
    for(;cur!=NULL;pre=pre->queue_next,cur=cur->queue_next){
        if(cur==proc){
            pre->queue_next=cur->queue_next;
            return 0;
        }
    }
    return -1;
}

//进程调度函数，每次时钟中断都会调用这个函数
//采用循环轮转方法调度进程
//维护一个就绪队列
//每当经过一个时间片后，将当前进程插入就绪队列尾端，并将队列首端进程设置为当前运行进程
void schedule(){
    if(proc_list[0].state==ZOMBIE){ //如果1号进程死亡，则系统关机
        sbi_shutdown();
    }
    
    if (runnable_queue==NULL){   //如果就绪队列为空，则返回
        if(current->state!=RUNNING){
            intr_on();
            while(runnable_queue==NULL);
        }
        else
            return;
    }

    //取队列首端进程为当前进程
    current=runnable_queue; 
    runnable_queue=runnable_queue->queue_next;
    //printk("running process: %d\n",current->pid);
    current->state=RUNNING;
    switch_to(current);     //切换到新的当前进程
}