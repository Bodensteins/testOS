#ifndef _SCHEDULE_H_
#define _SCHEDULE_H_

/*
进程调度相关
主要的函数是schedule
*/

//进程就绪队列
extern process* runnable_queue;

void insert_to_runnable_queue(process *proc);   //将进程插入就绪队列尾端
void delete_from_runnable_queue(process *proc);     //将进程从就绪队列中删除(似乎目前没什么用处)
void schedule();    //进程调度函数，每次时钟中断都会调用这个函数

#endif