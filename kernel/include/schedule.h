#ifndef _SCHEDULE_H_
#define _SCHEDULE_H_

/*
进程调度相关
主要的函数是schedule
*/


extern process* runnable_queue;     //进程就绪队列
extern process* wait4_queue;        //进程等待队列

//void insert_to_runnable_queue(process *proc);
//void delete_from_runnable_queue(process *proc);

void insert_into_queue(process **queue, process *proc);     //将进程proc插入queue队列末端
int delete_from_queue(process **queue, process *proc);      //将进程proc从队列queue中删除

void schedule();    //进程调度函数，每次时钟中断都会调用这个函数

#endif