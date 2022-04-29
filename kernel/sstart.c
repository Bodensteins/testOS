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
#include "include/elf.h"

#ifndef QEMU
#include "sd/include/fpioa.h"
#include "sd/include/sdcard.h"
#include "include/fat32.h"
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
    
    start_paging();

    proc_list_init();
    trap_init();
   
#ifndef QEMU
    fpioa_pin_init();
    //just_init_the_device();
    sdcard_init();
#endif
    buffer_init();
    fat32_init();
    //test_sdcard();
    insert_to_runnable_queue(load_user_programe());
    schedule();
}

process* load_user_programe(){
    process* proc=alloc_process();
    
    dirent* de=find_dirent(NULL,"/test");
    char* code=alloc_physical_page();
    elf64_header hdr;
    elf64_prog_header phdr;

    read_by_dirent(de,&hdr,0,sizeof(elf64_header));

    proc->trapframe->epc=hdr.entry;

    read_by_dirent(de,&phdr,hdr.ph_off,sizeof(elf64_prog_header));
    read_by_dirent(de,code,phdr.offset,phdr.file_size);
    proc->size=phdr.file_size;
    user_vm_map(proc->pagetable,phdr.va,PGSIZE,(uint64)code,
        pte_permission(PAGE_READ | PAGE_EXEC | PAGE_WRITE,1));
    proc->segment_map_info[3].va=phdr.va;
    proc->segment_map_info[3].page_num=1;
    proc->segment_map_info[3].seg_type=CODE_SEGMENT;
    proc->segment_num++;
    release_dirent(de);

    proc->cwd=find_dirent(NULL,"/");

    return proc;
}

void just_init_the_device(){
    uint32 *hart0_m_threshold = (uint32*)PLIC;
    *(hart0_m_threshold) = 0;
    uint32 *hart0_m_int_enable_hi = (uint32*)(PLIC_MENABLE(0) + 0x04);
    *(hart0_m_int_enable_hi) = (1 << 0x1);
}

uint32 fat_temp(uint32);
uint8 buf[PGSIZE];
// A simple test for sdcard read/write test
void test_sdcard(void) {
    dirent* de=find_dirent(NULL,"/main");
    if(de!=NULL){
        int ret=read_by_dirent(de,buf,120,1200);
        printk("off: 120, rsize: 1200 ,ret: %d\n",ret);
    }
    release_dirent(de);
	while (1) ;
}
