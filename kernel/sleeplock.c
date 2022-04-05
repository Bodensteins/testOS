#include "include/sleeplock.h"
#include "include/process.h"
#include "include/schedule.h"
#include "include/printk.h"

void init_sleeplock(sleeplock *lock, char *name){
    lock->is_locked=0;
    lock->name=name;
    lock->pid=0;
    lock->sleep_queue=NULL;
    init_spinlock(&lock->spinlock,"sleep lock");
}

void acquire_sleeplock(sleeplock *lock){
    //acquire_spinlock(&lock->spinlock);
    while(lock->is_locked){
        sleep_on_lock(lock,&lock->spinlock);
    }
    lock->is_locked=1;
    lock->pid=current->pid;
    //release_spinlock(&lock->spinlock);
}

void release_sleeplock(sleeplock *lock){
    //acquire_spinlock(&lock->spinlock);
    lock->pid=0;
    lock->is_locked=0;
    wakeup1_on_lock(lock);
    //release_spinlock(&lock->spinlock);
}

int is_holding_sleeplock(sleeplock* lock){
    int ret;
    //acquire_spinlock(&lock->spinlock);
    ret=lock->is_locked && current->pid;
    //release_spinlock(&lock->spinlock);
    return ret;
}

void insert_into_sleep_queue(sleeplock* lock, process* proc){
    proc->queue_next=lock->sleep_queue->queue_next;
    lock->sleep_queue=proc;
}

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
    insert_into_sleep_queue(sleeplock,p);
    schedule();
}

void wakeup1_on_lock(sleeplock* sleeplock){
    if(sleeplock->sleep_queue==NULL){
        return;
    }
    //acquire(proc)

    process *p=sleeplock->sleep_queue;
    sleeplock->sleep_queue=p->queue_next;
    p->state=RUNNABLE;
    insert_to_runnable_queue(p);

    //release()
}