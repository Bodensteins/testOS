#ifndef _SPIN_LOCK_H_
#define _SPIN_LOCK_H_

#include "types.h"

typedef struct spinlock{
    uint is_locked;
    char *name;
}spinlock;

void init_spinlock(spinlock* lock, char* name);

void acquire_spinlock(struct spinlock *lock);

void release_spinlock(struct spinlock *lock);

int is_holding_spinlock(struct spinlock *lock);

#endif