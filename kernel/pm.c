#include "include/param.h"
#include "include/pmlayout.h"
#include "include/types.h"
#include "include/riscv.h"
#include "include/printk.h"
#include "include/pm.h"
#include "include/string.h"

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

uint64 free_pm_max_addr;
uint64 free_pm_min_addr;

typedef struct page_node{
    struct page_node *next;
}page_node;

page_node free_page_list;

// Initialize phisical memeory manager
void pm_init(){
    free_pm_min_addr=PGROUNDUP((uint64)end);
    free_pm_max_addr=(uint64)PHYSTOP;
    for(uint64 p=free_pm_min_addr;p+PGSIZE<=free_pm_max_addr;p+=PGSIZE){
        free_physical_page((void*)p);
    }
}


// Allocate a free physical page
void* alloc_physical_page(){
    page_node* node=free_page_list.next;
    if(node)
        free_page_list.next=node->next;
    return (void*)node;
}


// Free an allocated page
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