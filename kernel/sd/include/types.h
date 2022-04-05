#ifndef _TYPES_H_
#define _TYPES_H_

//#define DEBUG

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

typedef uint64 pte_t;
typedef uint64 *pagetable_t; // 512 PTEs


#ifndef NULL
#define NULL ((void *)0)
#endif

#endif