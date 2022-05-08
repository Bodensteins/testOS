// Copyright (c) 2006-2019 Frans Kaashoek, Robert Morris, Russ Cox,
//                         Massachusetts Institute of Technology

#include "include/types.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/riscv.h"
#include "include/sbi.h"
#include "include/console.h"
#include "include/printf.h"
#include "include/kalloc.h"
#include "include/timer.h"
#include "include/trap.h"
#include "include/proc.h"
#include "include/plic.h"
#include "include/vm.h"
#include "include/disk.h"
#include "include/buf.h"
#include "include/printk.h"

#ifndef QEMU
#include "include/sdcard.h"
#include "include/fpioa.h"
#include "include/dmac.h"
#endif

static inline void inithartid(unsigned long hartid) {
  asm volatile("mv tp, %0" : : "r" (hartid & 0x1));

  //printf("inithartid: %x\n",hartid);
}

volatile static int started = 0;

//extern uint32 TEXT_START;


void
main(unsigned long hartid, unsigned long dtb_pa)
{

  //printk("-------------------main enter OK ------------------------\n");
  //printk("TEXT_START:%x\n",TEXT_START);

  inithartid(hartid);
  

  if (hartid == 0) {

    printf("-------------------hart %d enter main()------------------------\n", hartid);
    consoleinit();
    printfinit();   // init a lock for printf 
    print_logo();
    //printk("------------------- logo OK ------------------------\n");

    #ifdef DEBUG
    printf("hart %d enter main()...\n", hartid);
    #endif
    kinit();         // physical page allocator
    //printk("-------------------kinit OK ------------------------\n");

    kvminit();       // create kernel page table
    //printk("-------------------kvminit OK ------------------------\n");
    kvminithart();   // turn on paging
    //printk("-------------------kvminithart OK ------------------------\n");
    timerinit();     // init a lock for timer
    
    trapinithart();  // install kernel trap vector, including interrupt handler
    procinit();
    plicinit();
    plicinithart();
    #ifndef QEMU
    fpioa_pin_init();
    dmac_init();
    #endif 
    disk_init();
    binit();         // buffer cache
    fileinit();      // file table
    userinit();      // first user process

    printf("hart 0 init done\n");
    
    for(int i = 1; i < NCPU; i++) {
      unsigned long mask = 1 << i;
      sbi_send_ipi(&mask);
    }
    __sync_synchronize();
    started = 1;
    /*
    for(;;)
    ;
    */
   
  }
  else
  {
    // hart 1
    while (started == 0)
      ;
    __sync_synchronize();
    #ifdef DEBUG
    printf("hart %d enter main()...\n", hartid);
    #endif
    
    kvminithart();
    trapinithart();
    plicinithart();  // ask PLIC for device interrupts
    printf("hart 1 init done\n");
    /*
    for(;;)
    ;
    */
  }

  scheduler();
}
