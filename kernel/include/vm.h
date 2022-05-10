#ifndef _VM_H_
#define _VM_H_

#include "types.h"
#include "riscv.h"

/*
虚拟地址管理
虽然函数名称不同，但设计的思路与xv6也没有太大区别
*/

//内核页表
extern pagetable_t kernel_pagetable;


//在内核页表中将一段连续的虚拟地址映射到连续的物理地址
//va：要映射的起始的虚拟地址
//pa：要映射的起始的物理地址
//sz：映射地址的大小
//permission：pte的属性
//该函数即是在内核页表中将[va , va+sz)的虚拟地址区间映射到[pa，pa+sz)的物理地址区间
//注意，va，pa均会被页对齐
void kernel_vm_map(uint64 va, uint64 pa, uint64 sz, int permission);    


//启动分页机制
void start_paging();    


//内核虚拟地址初始化(基本上内核中的虚拟地址都等于物理地址)
void kernel_vm_init();  


/* --- user page table --- */

//根据页表和虚拟地址获得相应的物理地址
void *va_to_pa(pagetable_t page_dir, void *va);


//在指定的用户页表中将一段连续的虚拟地址映射到连续的物理地址
//va：要映射的起始的虚拟地址
//pa：要映射的起始的物理地址
//sz：映射地址的大小
//permission：pte的属性
//该函数即是在指定的用户页表中将[va , va+sz)的虚拟地址区间映射到[pa，pa+sz)的物理地址区间
//注意，va，pa均会被页对齐
void user_vm_map(pagetable_t page_dir, uint64 va, uint64 size, uint64 pa, int permission);


//在指定的用户页表中将一段连续的虚拟地址与其物理地址解除映射
//va：要解除映射的起始的虚拟地址
//size：连续地址的大小
//is_free_pa：是否释放物理内存，0为不释放，否则为释放
//该函数即是在用户页表中将[va , va+sz)的虚拟地址区间解除与其对应的物理地址的映射关系
void user_vm_unmap(pagetable_t pd, uint va, uint size, int is_free_pa);


//释放页表占用的内存空间
void free_pagetable(pagetable_t pagetable);

/*
解除页表虚拟地址从0到size映射关系，
如果is_free不为0，则将pte指向的有效物理内存也一并释放，
并不释放页表
*/
void free_pagetable2(pagetable_t pagetable, uint64 sz, int is_free);

//生成pte的属性
//is_read为1是可读
//is_write为1是可写
//is_exec为1是可执行
//is_user为1是用户进程使用
//返回生成的pte的属性，这个属性一般用于user_vm_map中的permission参数
int pte_permission(int is_read, int is_write, int is_exec, int is_user); 


//根据虚拟地址va和指定页表找到其对应物理页的物理地址pa
//此处的pa不是va的对应物理地址，而是其所在物理页的地址，因此pa是页对齐的
uint64 find_pa_align_pgsize(pagetable_t pd, uint64 va);

#endif