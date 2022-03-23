#include "string.h"
#include "riscv.h"
#include "pmlayout.h"
#include "pm.h"
#include "types.h"
#include "printk.h"
#include "vm.h"

pagetable_t kernel_pagetable;

extern char etext[];  // kernel.ld sets this to end of kernel code.

extern char trampoline[]; // trampoline.S

pte_t *find_pte(pagetable_t pd, uint64 va, int is_alloc){
    pte_t *pte_ptr;
    if(va>MAXVA)
        panic("find_pte,va>MAX VA\n");
    for(int pde_level=2;pde_level>0;pde_level--){
      pte_ptr=pd+PX(pde_level,va);
      if(*pte_ptr & PTE_V){
          pd=(pagetable_t)PTE_TO_PA(*pte_ptr);
      }
      else{
        if(!is_alloc || (pd=(pagetable_t)alloc_physical_page())==0)
            return NULL;
        memset(pd,0,PGSIZE);
        *pte_ptr=(PA_TO_PTE(pd) | PTE_V);
      }  
    }
    return (pte_t *)(pd+PX(0,va));
}

uint64 find_pa_align_pgsize(pagetable_t pd, uint64 va){
    if (va >= MAXVA) return 0;
    pte_t *pte=find_pte(pd,(uint64)va,0);
    if (pte == 0 || (*pte & PTE_V) == 0 || ((*pte & PTE_R) == 0 && (*pte & PTE_W) == 0))
        return 0;
    return PTE_TO_PA(*pte);
}

void *va_to_pa(pagetable_t pd, void* va){
    uint64 pa=find_pa_align_pgsize(pd,(uint64)va);
    if(pa==0)
        return NULL;
    uint64 offset=(uint64)va;
    offset&=(PGSIZE-1);
    return (void*)(pa+offset);
}

int map_pages(pagetable_t pd, uint va, uint size, uint pa, int permission){
    uint64 addr=PGROUNDDOWN(va);
    uint64 last=PGROUNDDOWN(va+size-1);
    for(pte_t *pte; addr<=last; addr+=PGSIZE,pa+=PGSIZE){
        if((pte=find_pte(pd,addr,1))==(void*)0)
            return -1;
        if(*pte & PTE_V)
            panic("map_pages: used page\n");
        *pte = PA_TO_PTE(pa) | permission | PTE_V;
    }
    return 0;
}

void unmap_pages(pagetable_t pd, uint va, uint size, int is_free_pa){
    uint64 addr=PGROUNDDOWN(va);
    uint64 last=PGROUNDDOWN(va+size-1);
    for(pte_t* pte;addr<=last;addr+=PGSIZE){
        pte=find_pte(pd,addr,0);
        if(pte==NULL || !(*pte | PTE_V))
            return;
        if(is_free_pa){
            uint64 pa=PTE_TO_PA(*pte);
            free_physical_page((void*)pa);
        }
        *pte&=(~PTE_V);
    }
}

int pte_permission(int rwx, int is_user){
    uint64 perm = 0;
  if (rwx & PAGE_READ) perm |= PTE_R | PTE_A;
  if (rwx & PAGE_WRITE) perm |= PTE_W | PTE_D;
  if (rwx & PAGE_EXEC) perm |= PTE_X | PTE_A;
  if (perm == 0) perm = PTE_R;
  if (is_user) perm |= PTE_U;
  return perm;
}

void kernel_vm_map(uint64 va, uint64 pa, uint64 sz, int permission){
    if(map_pages(kernel_pagetable,va,sz,pa,permission)!=0)
        panic("kernel_vm_map\n");
}

void kernel_vm_init(){
    kernel_pagetable=(pagetable_t)alloc_physical_page();
    memset(kernel_pagetable,0,PGSIZE);

    kernel_vm_map(UART0, UART0, PGSIZE, PTE_R | PTE_W);

    // virtio mmio disk interface
    //kernel_vm_map(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);

    // CLINT
    kernel_vm_map(CLINT, CLINT, 0x10000, PTE_R | PTE_W);

    // PLIC
    kernel_vm_map(PLIC, PLIC, 0x400000, PTE_R | PTE_W);

    // map kernel text executable and read-only.
    kernel_vm_map(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);

    // map kernel data and the physical RAM we'll make use of.
    kernel_vm_map((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W | PTE_X);

    // map the trampoline for trap entry/exit to
    // the highest virtual address in the kernel.
    kernel_vm_map(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);

}

void start_paging(){
    w_satp(MAKE_SATP(kernel_pagetable));
    sfence_vma();
}

void user_vm_map(pagetable_t page_dir, uint64 va, uint64 sz, uint64 pa, int permission){
    if(map_pages(page_dir,va,sz,pa,permission)!=0)
        panic("user_vm_map\n");
}

void user_vm_unmap(pagetable_t pd, uint va, uint size, int is_free_pa){
    unmap_pages(pd,va,size,is_free_pa);
}

void free_pagetable(pagetable_t pagetable){
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
      // this PTE points to a lower-level page table.
      uint64 child = PTE_TO_PA(pte);
      free_pagetable((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    }
  }
  free_physical_page((void*)pagetable);
}