#ifndef _SPIN_LOCK_H_
#define _SPIN_LOCK_H_

#include "types.h"

/*
自旋锁相关
目前还并没有开始同步控制
这里暂未使用
*/

/*
注意，自旋锁主要针对的是CPU之间的互斥，
因此如果我们还没实现多核，那么就用不到自旋锁
*/

//自旋锁结构体，最重要的就只有is_locked字段，表示该锁是否被占用
typedef struct spinlock{
    uint is_locked;
    char *name;
}spinlock;

void init_spinlock(spinlock* lock, char* name); //初始化自旋锁

void acquire_spinlock(struct spinlock *lock);   //试图获取自旋锁

void release_spinlock(struct spinlock *lock);   //释放自旋锁

int is_holding_spinlock(struct spinlock *lock); //是否持有自旋锁

#endif