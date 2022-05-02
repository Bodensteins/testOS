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

#ifndef NULL
#define NULL ((void *)0)
#endif

#endif