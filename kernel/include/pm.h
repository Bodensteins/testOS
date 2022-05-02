#ifndef _PM_H_
#define _PM_H_

/*
物理内存管理
虽然函数名称不同，但设计的思路与xv6也没有太大区别
*/

void pm_init(); //物理内存初始化
void* alloc_physical_page();    //分配一个空闲的物理页面，返回其物理地址
void free_physical_page(void* pa);  //释放一个物理页面，将其加入空闲页面链表

#endif