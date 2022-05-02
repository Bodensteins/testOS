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
extern pagetable_t kernel_pagetable;    //内核页表的声明

//将进程插入就绪队列尾端
void insert_to_runnable_queue(process *proc){
    if(runnable_queue==NULL){   //如果就绪队列为空，则直接插入
        runnable_queue=proc;
        proc->queue_next=NULL;
        return;
    }

    process *p;
    //遍历就绪队列，检查该进程是否已经被插入队列
    for(p=runnable_queue;p->queue_next!=NULL;p=p->queue_next){
        if(p->pid==proc->pid)
            return;
    }
    if(p->pid==proc->pid)
        return;
    
    //插入到队列尾端
    p->queue_next=proc;
    proc->queue_next=NULL;
    proc->state=READY;
}

//将进程从就绪队列中删除(这个函数似乎目前没什么用处)
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

//进程调度函数，每次时钟中断都会调用这个函数
//采用循环轮转方法调度进程
//维护一个就绪队列
//每当经过一个时间片后，将当前进程插入就绪队列尾端，并将队列首端进程设置为当前运行进程
//如果当前进程已经是僵尸态，则释放其占用的所有资源并将其置为UNUSED
void schedule(){

    if(proc_list[0].state==ZOMBIE){ //如果1号进程死亡，则系统关机
        sbi_shutdown();
    }

    if(current!=NULL && current->state==ZOMBIE){    //如果当前进程死亡，则给他收尸
        //printk("zombie: %d\n", current->pid);
        current->state=UNUSED;  //状态置为UNUSED
        
        for(int i=0;i<N_OPEN_FILE;i++){ //关闭所有还打开的文件
            if(current->open_files[i]!=NULL)
                release_file(current->open_files[i]);
        }

        release_dirent(current->cwd);   //释放当前目录的目录项缓冲

        for(int i=0;i<current->segment_num;i++){    //根据segment_map_info释放进程占用的内存
            segment_map_info* seg=current->segment_map_info+i;
            int free=1;
            if(seg->seg_type==SYSTEM_SEGMENT){  //trampoline段为内核和所有进程共享，不能释放，只是解除地址映射
                free=0;
            }
            user_vm_unmap(current->pagetable, seg->va,seg->page_num*PGSIZE,free);
        }
        
        free_pagetable(current->pagetable);     //将页表占用的内存释放
        current->segment_map_info->page_num=0;
        current->size=0;
    }

    if (runnable_queue==NULL)   //如果就绪队列为空，则返回
        return;

    //取队列首端进程为当前进程
    current=runnable_queue; 
    runnable_queue=runnable_queue->queue_next;
    //printk("running process: %d\n",current->pid);
    current->state=RUNNING;
    switch_to(current);     //切换到新的当前进程
}