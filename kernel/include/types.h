#ifndef _TYPES_H_
#define _TYPES_H_

//#define DEBUG
//#define QEMU

/*
一些变量类型的定义，一目了然
*/

typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int  uint32;
typedef unsigned long long uint64;

typedef uint64 pde_t;

typedef unsigned long size_t;
typedef unsigned long uintptr_t;

typedef unsigned int off_t;

#ifndef NULL
#define NULL ((void *)0)
#endif

#define readb(addr) (*(volatile uint8 *)(addr))
#define readw(addr) (*(volatile uint16 *)(addr))
#define readd(addr) (*(volatile uint32 *)(addr))
#define readq(addr) (*(volatile uint64 *)(addr))

#define writeb(v, addr)                      \
    {                                        \
        (*(volatile uint8 *)(addr)) = (v); \
    }
#define writew(v, addr)                       \
    {                                         \
        (*(volatile uint16 *)(addr)) = (v); \
    }
#define writed(v, addr)                       \
    {                                         \
        (*(volatile uint32 *)(addr)) = (v); \
    }
#define writeq(v, addr)                       \
    {                                         \
        (*(volatile uint64 *)(addr)) = (v); \
    }


#endif