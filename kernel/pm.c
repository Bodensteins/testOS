#include "include/param.h"
#include "include/pmlayout.h"
#include "include/types.h"
#include "include/riscv.h"
#include "include/printk.h"
#include "include/pm.h"
#include "include/string.h"

/*
物理内存管理
虽然函数名称不同，但设计的思路与xv6也没有太大区别
*/

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

static uint64 free_pm_max_addr; //最大物理地址
static uint64 free_pm_min_addr; //最小物理地址

//空闲物理页链表，管理机制与xv6一模一样
typedef struct page_node{
    struct page_node *next;
}page_node;

page_node free_page_list;

//物理页面初始化，就是把所有空闲页面串在一起形成一个链表
void pm_init(){
    free_pm_min_addr=PGROUNDUP((uint64)end);
    free_pm_max_addr=(uint64)PHYSTOP;
    for(uint64 p=free_pm_min_addr;p+PGSIZE<=free_pm_max_addr;p+=PGSIZE){
        free_physical_page((void*)p);
    }
}

//分配一个空闲物理页面，返回其地址
//相当于xv6的kalloc
void* alloc_physical_page(){
    page_node* node=free_page_list.next;
    if(node)
        free_page_list.next=node->next;
    return (void*)node;
}

//释放一个物理页面，使其空闲
//相当于xv6的kfree
void free_physical_page(void* pa){
    if((uint64)pa%PGSIZE!=0 || 
        (uint64)pa<free_pm_min_addr || 
        (uint64)pa>free_pm_max_addr){
            panic("free_physical_page");
        }
    memset(pa, 1, PGSIZE);
    ((page_node*)pa)->next=free_page_list.next;
    free_page_list.next=((page_node*)pa);
}