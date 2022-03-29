#include "include/process.h"
#include "include/param.h"
#include "include/pmlayout.h"
#include "include/trap.h"
#include "include/printk.h"
#include "include/pm.h"
#include "include/vm.h"
#include "include/string.h"
#include "sd/include/fpioa.h"

#ifndef QEMU
#include "sd/include/sdcard.h"
#include "include/schedule.h"
#endif

extern char trampoline[];
void return_to_user();

void user_trap();
//void switch_to(process* proc);
process* load_user_programe();
void just_init_the_device();

extern trapframe temp[];

extern void test();

char *code;

void s_start(){
    printk("entering into system...\n");
    pm_init();
    kernel_vm_init();
    
    code=(char*)alloc_physical_page();
    memmove(code,(void*)test,PGSIZE);
    
    start_paging();

    init_proc_list();
    //uartinit();
    trap_init();
    
    insert_to_runnable_queue(load_user_programe());
   
#ifndef QEMU
    fpioa_pin_init();
    just_init_the_device();
    sdcard_init();
#endif
    test_sdcard();
    schedule();
}

process* load_user_programe(){
    process* proc=alloc_process();

    char* test_str=(char*)alloc_physical_page();
    memmove(test_str,"child\n\0",12);
    char* test_str2=(char*)alloc_physical_page();
    memmove(test_str2,"father\n\0",13);

    proc->trapframe->epc=0x1000;

    user_vm_map(proc->pagetable,0x1000,PGSIZE,(uint64)code,
        pte_permission(PAGE_READ | PAGE_EXEC,1));
    proc->segment_map_info[3].va=0x1000;
    proc->segment_map_info[3].page_num=1;
    proc->segment_map_info[3].seg_type=CODE_SEGMENT;
    

    user_vm_map(proc->pagetable,0x2000,PGSIZE,(uint64)test_str,
        pte_permission(PAGE_READ | PAGE_WRITE,1));
    user_vm_map(proc->pagetable,0x3000,PGSIZE,(uint64)test_str2,
        pte_permission(PAGE_READ | PAGE_WRITE,1));
    proc->segment_map_info[4].va=0x2000;
    proc->segment_map_info[4].page_num=2;
    proc->segment_map_info[4].seg_type=DATA_SEGMENT;

    proc->segment_num=5;

    return proc;
}

void just_init_the_device(){
    uint32 *hart0_m_threshold = (uint32*)PLIC;
    *(hart0_m_threshold) = 0;
    uint32 *hart0_m_int_enable_hi = (uint32*)(PLIC_MENABLE(0) + 0x04);
    *(hart0_m_int_enable_hi) = (1 << 0x1);
}