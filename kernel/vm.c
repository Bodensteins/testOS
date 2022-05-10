#include "include/string.h"
#include "include/riscv.h"
#include "include/pmlayout.h"
#include "include/pm.h"
#include "include/types.h"
#include "include/printk.h"
#include "include/vm.h"

pagetable_t kernel_pagetable;   //内核页表

extern char etext[];  // kernel.ld sets this to end of kernel code.

extern char trampoline[]; // trampoline.S

//根据指定的页表pd、虚拟地址va，找到其在页表中的pte，返回指向该pte的指针
//如果is_alloc不为0，则当页目录的pte为0时为其分配新的页
//对应于xv6中的walk函数，功能与其一模一样
static pte_t *find_pte(pagetable_t pd, uint64 va, int is_alloc){
    pte_t *pte_ptr;
    if(va>MAXVA)
        panic("find_pte,va>MAX VA\n");

    //遍历页目录，寻找最底层的页表
    for(int pde_level=2;pde_level>0;pde_level--){   
      pte_ptr=pd+PX(pde_level,va);  //确定pte在页表中的位置
      if(*pte_ptr & PTE_V){     //如果pte有效
          pd=(pagetable_t)PTE_TO_PA(*pte_ptr);  //pd置为下一级页表
      }
      else{     //否则
        if(!is_alloc || (pd=(pagetable_t)alloc_physical_page())==0)
            return NULL;    //如果is_alloc=0则返回NULL
        memset(pd,0,PGSIZE);    //否则为下一级页表分配一页
        *pte_ptr=(PA_TO_PTE(pd) | PTE_V);   //并将当前页表的pte置为有效
      }  
    }
    return (pte_t *)(pd+PX(0,va));  //返回最终找到的pte
}

//根据虚拟地址va和指定页表找到其对应物理页的物理地址pa
//此处的pa不是va的对应物理地址，而是其所在物理页的地址，因此pa是页对齐的
uint64 find_pa_align_pgsize(pagetable_t pd, uint64 va){
    if (va >= MAXVA) return 0;
    pte_t *pte=find_pte(pd,(uint64)va,0);   //根据页表pd和虚拟地址va找到pte
    if (pte == 0 || (*pte & PTE_V) == 0 || ((*pte & PTE_R) == 0 && (*pte & PTE_W) == 0))    //检查pte的属性
        return 0;
    return PTE_TO_PA(*pte); //将pte转换为pa并返回，这个pa是pte表示的那一页的首地址
}

//根据页表和虚拟地址获得相应的物理地址
void *va_to_pa(pagetable_t pd, void* va){
    uint64 pa=find_pa_align_pgsize(pd,(uint64)va);  //根据页表pd和虚拟地址va找到对应物理页的首地址
    if(pa==0)   //没找到，返回NULL
        return NULL;
    
    //计算该地址在物理页中的偏移
    uint64 offset=(uint64)va;
    offset&=(PGSIZE-1);
    
    //最终返回：物理页首地址+页内偏移
    return (void*)(pa+offset);
}

//在指定的页表pd中将一段连续的虚拟地址映射到连续的物理地址
//va：要映射的起始的虚拟地址
//pa：要映射的起始的物理地址
//sz：映射地址的大小
//permission：pte的属性
//该函数即是在指定的用户页表中将[va , va+sz)的虚拟地址区间映射到[pa，pa+sz)的物理地址区间
//注意，va，pa均会被页对齐
//相当于xv6中的mappages
static int map_pages(pagetable_t pd, uint va, uint size, uint pa, int permission){
    if(size<=0)
        return 0;
    uint64 addr=PGROUNDDOWN(va);    //起始虚拟地址，页对齐
    uint64 last=PGROUNDDOWN(va+size-1);     //终止虚拟地址，页对齐
    for(pte_t *pte; addr<=last; addr+=PGSIZE,pa+=PGSIZE){   //循环，将起始地址到最终地址全部映射
        if((pte=find_pte(pd,addr,1))==(void*)0)     //寻找pte，is_alloc参数置1
            return -1;
        if(*pte & PTE_V)    //如果pte已经有效，说明出现了重复映射
            panic("map_pages: used page\n");
        *pte = PA_TO_PTE(pa) | permission | PTE_V;      //没有问题，将页首地址和属性写入pte
    }
    return 0;
}

//在指定的页表中将一段连续的虚拟地址与其物理地址解除映射
//va：要解除映射的起始的虚拟地址
//size：连续地址的大小
//is_free_pa：是否释放物理内存，0为不释放，否则为释放
//该函数即是在指定的页表中将[va , va+sz)的虚拟地址区间解除与其对应的物理地址的映射关系
//相当于xv6中的uvmunmap函数
void unmap_pages(pagetable_t pd, uint va, uint size, int is_free_pa){
    if(size<=0)
        return;
    uint64 addr=PGROUNDDOWN(va);     //起始虚拟地址，页对齐
    uint64 last=PGROUNDDOWN(va+size-1);     //终止虚拟地址，页对齐
    for(pte_t* pte;addr<=last;addr+=PGSIZE){    //循环，将起始地址到最终地址全部解除映射
        pte=find_pte(pd,addr,0);    //寻找pte，is_alloc参数置0
        if(pte==NULL || !(*pte | PTE_V))
            return;
        if(is_free_pa){     //如果is_free_pa置1，则释放物理内存
            uint64 pa=PTE_TO_PA(*pte);
            free_physical_page((void*)pa);
        }
        *pte=0; //清除pte
    }
}

//生成pte的属性
//is_read为1是可读
//is_write为1是可写
//is_exec为1是可执行
//is_user为1是用户进程使用
//返回生成的pte的属性，这个属性一般用于user_vm_map中的permission参数
int pte_permission(int is_read, int is_write, int is_exec, int is_user){
    uint64 perm = 0;
  if (is_read) perm |= PTE_R | PTE_A;
  if (is_write) perm |= PTE_W | PTE_D;
  if (is_exec) perm |= PTE_X | PTE_A;
  if (perm == 0) perm = PTE_R;
  if (is_user) perm |= PTE_U;
  return perm;
}

//在内核页表中将一段连续的虚拟地址映射到连续的物理地址
//va：要映射的起始的虚拟地址
//pa：要映射的起始的物理地址
//sz：映射地址的大小
//permission：pte的属性
//该函数即是在内核页表中将[va , va+sz)的虚拟地址区间映射到[pa，pa+sz)的物理地址区间
//注意，va，pa均会被页对齐
void kernel_vm_map(uint64 va, uint64 pa, uint64 sz, int permission){
    if(map_pages(kernel_pagetable,va,sz,pa,permission)!=0)
        panic("kernel_vm_map\n");
}

//内核页表初始化，在OS启动时调用
//基本上内核中的虚拟地址都等于物理地址
void kernel_vm_init(){
    kernel_pagetable=(pagetable_t)alloc_physical_page();
    memset(kernel_pagetable,0,PGSIZE);

    // uart registers
    kernel_vm_map(UARTHS, UARTHS, PGSIZE, PTE_R | PTE_W);

    #ifdef QEMU
    kernel_vm_map(UART0, UART0, PGSIZE, PTE_R | PTE_W);

    // virtio mmio disk interface
    kernel_vm_map(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    #endif

    // CLINT
    kernel_vm_map(CLINT, CLINT, 0x10000, PTE_R | PTE_W);

    // PLIC
    kernel_vm_map(PLIC, PLIC, 0x4000, PTE_R | PTE_W);
    kernel_vm_map(PLIC + 0x200000, PLIC + 0x200000, 0x4000, PTE_R | PTE_W);

    #ifndef QEMU
    // GPIOHS
    kernel_vm_map(GPIOHS, GPIOHS, 0x1000, PTE_R | PTE_W);

    // DMAC
    kernel_vm_map(DMAC, DMAC, 0x1000, PTE_R | PTE_W);

    // GPIO
    kernel_vm_map(GPIO, GPIO, 0x1000, PTE_R | PTE_W);

    // SPI_SLAVE
    kernel_vm_map(SPI_SLAVE, SPI_SLAVE, 0x1000, PTE_R | PTE_W);

    // FPIOA
    kernel_vm_map(FPIOA, FPIOA, 0x1000, PTE_R | PTE_W);

    // SYSCTL
    kernel_vm_map(SYSCTL, SYSCTL, 0x1000, PTE_R | PTE_W);

    // SPI0
    kernel_vm_map(SPI0, SPI0, 0x1000, PTE_R | PTE_W);

    // SPI1
    kernel_vm_map(SPI1, SPI1, 0x1000, PTE_R | PTE_W);

    // SPI2
    kernel_vm_map(SPI2, SPI2, 0x1000, PTE_R | PTE_W);
    #endif

    // map kernel text executable and read-only.
    kernel_vm_map(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);

    // map kernel data and the physical RAM we'll make use of.
    kernel_vm_map((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W | PTE_X);

    // map the trampoline for trap entry/exit to
    // the highest virtual address in the kernel.
    kernel_vm_map(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);

}

//启动分页机制
void start_paging(){
    w_satp(MAKE_SATP(kernel_pagetable));
    sfence_vma();
}

//在指定的用户页表中将一段连续的虚拟地址映射到连续的物理地址
//va：要映射的起始的虚拟地址
//pa：要映射的起始的物理地址
//sz：映射地址的大小
//permission：pte的属性
//该函数即是在指定的用户页表中将[va , va+sz)的虚拟地址区间映射到[pa，pa+sz)的物理地址区间
//注意，va，pa均会被页对齐
void user_vm_map(pagetable_t page_dir, uint64 va, uint64 sz, uint64 pa, int permission){
    if(map_pages(page_dir,va,sz,pa,permission)!=0)
        panic("user_vm_map\n");
}

//在指定的用户页表中将一段连续的虚拟地址与其物理地址解除映射
//va：要解除映射的起始的虚拟地址
//size：连续地址的大小
//is_free_pa：是否释放物理内存，0为不释放，否则为释放
//该函数即是在用户页表中将[va , va+sz)的虚拟地址区间解除与其对应的物理地址的映射关系
void user_vm_unmap(pagetable_t pd, uint va, uint size, int is_free_pa){
    unmap_pages(pd,va,size,is_free_pa);
}

//释放页表占用的内存空间
//使用该函数必须确保页表中已经没有任何虚拟地址还映射有物理地址，即所有虚拟地址都解除了映射关系
void free_pagetable(pagetable_t pagetable){
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){  //检查该pte指向的是否是另一个更低级的页表
      // this PTE points to a lower-level page table.
      uint64 child = PTE_TO_PA(pte);
      free_pagetable((pagetable_t)child);   //通过递归的方式逐层释放内存
      pagetable[i] = 0;
    } else if(pte & PTE_V){     //如果还有pte对应了有效的物理地址，则出错
      panic("freewalk: leaf");
    }
  }
  free_physical_page((void*)pagetable); //最后释放根页表
}

/*
解除页表虚拟地址从0到size映射关系，
如果is_free不为0，则将pte指向的有效物理内存也一并释放，
并不释放页表
*/
void free_pagetable2(pagetable_t pagetable, uint64 size, int is_free){
    user_vm_unmap(pagetable,0,size,is_free);
    //free_pagetable(pagetable);
}
