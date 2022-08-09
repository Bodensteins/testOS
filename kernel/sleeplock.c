#include "include/sleeplock.h"
#include "include/process.h"
#include "include/schedule.h"
#include "include/printk.h"

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

//初始化睡眠锁
void init_sleeplock(sleeplock *lock, char *name){
    lock->is_locked=0;
    lock->name=name;
    lock->pid=0;
    lock->sleep_queue=NULL;
    init_spinlock(&lock->spinlock,"sleep lock");
}

//当前进程试图占用睡眠锁
void acquire_sleeplock(sleeplock *lock){
    //acquire_spinlock(&lock->spinlock);
    while(lock->is_locked){
        sleep_on_lock(lock,&lock->spinlock);
    }
    lock->is_locked=1;
    lock->pid=current->pid;
    //release_spinlock(&lock->spinlock);
}

//释放睡眠锁
void release_sleeplock(sleeplock *lock){
    //acquire_spinlock(&lock->spinlock);
    lock->pid=0;
    lock->is_locked=0;
    wakeup1_on_lock(lock);
    //release_spinlock(&lock->spinlock);
}

//是否持有锁？
int is_holding_sleeplock(sleeplock* lock){
    int ret;
    //acquire_spinlock(&lock->spinlock);
    ret=lock->is_locked && current->pid;
    //release_spinlock(&lock->spinlock);
    return ret;
}

//将进程插入某个睡眠锁的睡眠队列
void insert_into_sleeplock_queue(sleeplock* lock, process* proc){
    insert_into_queue(&(lock->sleep_queue),proc);
}

//令当前进程在某睡眠锁上睡眠(加入该锁的睡眠队列)
void sleep_on_lock(sleeplock* sleeplock, spinlock *spinlock){
    /*
    if(&current->spinlock!=spinlock){
        acquire_spinlock(&current->spinlock);
        release_spinlock(spinlock);
    }
    */

    process *p=current;
    if(p->state==SLEEPING){
        //release()
        return;
    }
    
    p->state=SLEEPING;
    insert_into_sleeplock_queue(sleeplock,p);
    intr_off();
    into_schedule();
}

//叫醒某个睡眠锁队列中首端的进程
void wakeup1_on_lock(sleeplock* sleeplock){
    if(sleeplock->sleep_queue==NULL){
        return;
    }
    //acquire(proc)

    process *p=sleeplock->sleep_queue;
    sleeplock->sleep_queue=p->queue_next;
    p->state=READY;
    insert_into_queue(&runnable_queue,p);

    //release()
}