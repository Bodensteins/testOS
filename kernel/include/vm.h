#ifndef _VM_H_
#define _VM_H_

#include "types.h"
#include "riscv.h"

#define PAGE_READ 1
#define PAGE_WRITE 2
#define PAGE_EXEC 4

extern pagetable_t kernel_pagetable;

void kernel_vm_map(uint64 va, uint64 pa, uint64 sz, int permission);

void start_paging();

// Initialize the kernel pagetable
void kernel_vm_init();

/* --- user page table --- */
void *va_to_pa(pagetable_t page_dir, void *va);
void user_vm_map(pagetable_t page_dir, uint64 va, uint64 size, uint64 pa, int permission);
void user_vm_unmap(pagetable_t pd, uint va, uint size, int is_free_pa);
void free_pagetable(pagetable_t pagetable);

int pte_permission(int,int);

uint64 find_pa_align_pgsize(pagetable_t pd, uint64 va);

#endif