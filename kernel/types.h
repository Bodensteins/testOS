#ifndef _TYPES_H_
#define _TYPES_H_

//#define NULL ((void*)0)

typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int  uint32;
typedef unsigned long long uint64;

typedef uint64 pde_t;

typedef unsigned long size_t;

#ifndef NULL
#define NULL ((void *)0)
#endif

#endif