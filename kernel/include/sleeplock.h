#ifndef _SLEEP_LOCK_
#define _SLEEP_LOCK_

#include "types.h"
#include "spinlock.h"
//#include "process.h"

/*
睡眠锁相关
目前还并没有开始同步控制
这里暂未使用
*/

/*
与xv6中的睡眠锁不同
这里的每个睡眠锁会维护一个睡眠进程队列
当进程试图获取一个锁，而这个锁已经被占用
那么这个进程就会被加入该锁的睡眠队列
当占用锁的进程将锁释放后，锁就会唤醒睡眠队列首端的进程，令其占用锁
*/

/*
注意，这里的函数还并为真正使用过，所以到底能不能用还暂时不知道
*/

typedef struct process process;     //进程结构体的声明，防止编译错误

//睡眠锁结构，维护一个睡眠队列
typedef struct sleeplock{
    uint is_locked; //该锁是否被占用
    spinlock spinlock;  //保护睡眠锁的自旋锁
    process* sleep_queue;   //睡眠锁的睡眠进程队列(即等待占用睡眠锁的队列)

    //debug使用
    char* name; //睡眠锁名字
    int pid;    //占用睡眠锁的进程的pid
}sleeplock;


void init_sleeplock(sleeplock *lock, char *name);   //初始化睡眠锁
void acquire_sleeplock(sleeplock *lock);    //当前进程试图占用睡眠锁
void release_sleeplock(sleeplock *lock);    //释放睡眠锁
int is_holding_sleeplock(sleeplock* lock);  //是否持有锁？
void insert_into_sleep_queue(sleeplock* lock, process* proc);   //将进程插入某个睡眠锁的睡眠队列
void sleep_on_lock(sleeplock* sleeplock, spinlock *spinlock);   //令当前进程在某睡眠锁上睡眠(加入该锁的睡眠队列)
void wakeup1_on_lock(sleeplock* sleeplock);     //叫醒某个睡眠锁队列中首端的进程


#endif