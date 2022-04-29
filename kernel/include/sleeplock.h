#ifndef _SLEEP_LOCK_
#define _SLEEP_LOCK_

#include "types.h"
#include "spinlock.h"
//#include "process.h"

typedef struct process process;

typedef struct sleeplock{
    uint is_locked;
    spinlock spinlock;
    process* sleep_queue;

    char* name;
    int pid;
}sleeplock;


void init_sleeplock(sleeplock *lock, char *name);
void acquire_sleeplock(sleeplock *lock);
void release_sleeplock(sleeplock *lock);
int is_holding_sleeplock(sleeplock* lock);
void insert_into_sleep_queue(sleeplock* lock, process* proc);
void sleep_on_lock(sleeplock* sleeplock, spinlock *spinlock);
void wakeup1_on_lock(sleeplock* sleeplock);


#endif