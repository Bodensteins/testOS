#include "include/process.h"
#include "include/param.h"
#include "include/pmlayout.h"
#include "include/trap.h"
#include "include/printk.h"
#include "include/pm.h"
#include "include/vm.h"
#include "include/string.h"
#include "include/schedule.h"
#include "include/buffer.h"

#ifndef QEMU
#include "sd/include/fpioa.h"
#include "sd/include/sdcard.h"
#endif

#ifndef BSIZE
#define BSIZE 0x8000
#endif

extern char trampoline[];
void return_to_user();

void user_trap();

process* load_user_programe();
void just_init_the_device();
void test_sdcard(void);

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

    proc_list_init();
    trap_init();
    
    insert_to_runnable_queue(load_user_programe());
   
#ifndef QEMU
    fpioa_pin_init();
    just_init_the_device();
    sdcard_init();
#endif
    buffer_init();
    //test_sdcard();
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

// A simple test for sdcard read/write test 
void test_sdcard(void) {
    /*
    buffer* buf[40];
    for(int i=0;i<40;i++){
        *(buf+i)=acquire_buffer(i,_blockno_to_sectorno(0x7801));
        release_buffer(*(buf+i));
    }
    printk("done!\n");
	
    buf=acquire_buffer(0,_blockno_to_sectorno(0x7801));
    for (int i = 0; i < 512; i ++) {
         if (0 == i % 16) {
			printk("\n");
		}
		printk("%x ", buf->data[i]);
	}
    
    char str[16];
    memcpy(str,buf->data,16);
    printk(str);
    memcpy(buf->data,"not just a test",16);
    buffer_write(buf);
    release_buffer(buf);
    */
	while (1) ;
}
