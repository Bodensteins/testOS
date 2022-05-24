#ifndef _PM_LAY_OUT_
#define _PM_LAY_OUT

/*
物理内存的分布情况
还是借鉴的xv6和上届参赛队的布局(不是xv6-k210，他们那个我有点看不明白)
注释都是他们写的，我就不赘述了
唯一的改变是，我将进程用户栈映射在了虚拟地址的高地址处，与trampoline和trapframe的虚拟地址放在一起
目前还没有实现堆内存，不过xv6那个堆内存也很简陋
*/

//#define QEMU

// Physical memory layout

// k210 peripherals
// (0x02000000, 0x1000),      /* CLINT     */
// // we only need claim/complete for target0 after initializing
// (0x0C200000, 0x1000),      /* PLIC      */
// (0x38000000, 0x1000),      /* UARTHS    */
// (0x38001000, 0x1000),      /* GPIOHS    */
// (0x50200000, 0x1000),      /* GPIO      */
// (0x50240000, 0x1000),      /* SPI_SLAVE */
// (0x502B0000, 0x1000),      /* FPIOA     */
// (0x502D0000, 0x1000),      /* TIMER0    */
// (0x502E0000, 0x1000),      /* TIMER1    */
// (0x502F0000, 0x1000),      /* TIMER2    */
// (0x50440000, 0x1000),      /* SYSCTL    */
// (0x52000000, 0x1000),      /* SPI0      */
// (0x53000000, 0x1000),      /* SPI1      */
// (0x54000000, 0x1000),      /* SPI2      */
// (0x80000000, 0x600000),    /* Memory    */

#define CLINT 0x02000000
//#define PLIC 0x0C200000
#define UARTHS 0x38000000
#define GPIOHS 0x38001000
#define DMAC 0x50000000
#define GPIO 0x50200000
#define SPI_SLAVE 0x50240000
#define FPIOA 0x502B0000
#define SYSCTL 0x50440000
#define SPI0 0x52000000
#define SPI1 0x53000000
#define SPI2 0x54000000

// qemu -machine virt is set up like this,
// based on qemu's hw/riscv/virt.c:
//
// 00001000 -- boot ROM, provided by qemu
// 02000000 -- CLINT
// 0C000000 -- PLIC
// 10000000 -- uart0 
// 10001000 -- virtio disk 
// 80000000 -- boot ROM jumps here in machine mode
//             -kernel loads the kernel here
// unused RAM after 80000000.

// the kernel uses physical memory thus:
// 80000000 -- entry.S, then kernel text and data
// end -- start of kernel page allocation area
// PHYSTOP -- end RAM used by the kernel

// qemu puts UART registers here in physical memory.
#define UART0 0x10000000L
#define UART0_IRQ 10

// virtio mmio interface
#define VIRTIO0 0x10001000
#define VIRTIO0_IRQ 1

// local interrupt controller, which contains the timer.
#ifndef CLINT
#define CLINT 0x2000000L
#define CLINT_MTIMECMP(hartid) (CLINT + 0x4000 + 8*(hartid))
#define CLINT_MTIME (CLINT + 0xBFF8) // cycles since boot.
#endif


#ifndef QEMU
#define PLIC 0x0c000000L
#else
#define PLIC 0x0c000000L
#endif
#define PLIC_PRIORITY (PLIC + 0x0)
#define PLIC_PENDING (PLIC + 0x1000)
#define PLIC_MENABLE(hart) (PLIC + 0x2000 + (hart)*0x100)
#define PLIC_SENABLE(hart) (PLIC + 0x2080 + (hart)*0x100)
#define PLIC_MPRIORITY(hart) (PLIC + 0x200000 + (hart)*0x2000)
#define PLIC_SPRIORITY(hart) (PLIC + 0x201000 + (hart)*0x2000)
#define PLIC_MCLAIM(hart) (PLIC + 0x200004 + (hart)*0x2000)
#define PLIC_SCLAIM(hart) (PLIC + 0x201004 + (hart)*0x2000)

// the kernel expects there to be RAM
// for use by the kernel and user pages
// from physical address 0x80000000 to PHYSTOP.
#define KERNBASE 0x80000000L
#define PHYSTOP (KERNBASE+0x600000L)
//#define PHYSTOP (KERNBASE + 128*1024*1024)

#ifdef QEMU     // QEMU 
#define UART_IRQ    10 
#define DISK_IRQ    1
#else           // k210 
#define UART_IRQ    33
#define DISK_IRQ    27
#endif 

#define CLINT_MTIME (CLINT+0xBFF8)

// User memory layout.
// Address zero first:
//   text
//   original data and bss
//   expandable heap
//   ...
//   fixed-size stack
//   TRAPFRAME (p->trapframe, used by the trampoline)
//   TRAMPOLINE (the same page as in the kernel)

// map the trampoline page to the highest address,
// in both user and kernel space.

#define TRAMPOLINE 0x7FFFF000  

#define TRAPFRAME (TRAMPOLINE-PGSIZE)

#define USER_STACK_TOP (TRAMPOLINE-3*PGSIZE)

#endif