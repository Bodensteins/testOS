// mmap 系统调用需要用到的一些数据结构和对外接口
#ifndef _MMAP_H_
#define _MMAP_H_


#include "types.h"

#define PROT_NONE		0
#define PROT_READ		1
#define PROT_WRITE		2
#define PROT_EXEC		4
#define PROT_GROWSDOWN	0x01000000
#define PROT_GROWSUP	0x02000000
#define PROT_ALL (PROT_READ|PROT_WRITE|PROT_EXEC|PROT_GROWSDOWN|PROT_GROWSUP)

#define MAP_FILE		0
#define MAP_SHARED		0x01
#define MAP_PRIVATE		0x02
#define MAP_FIXED		0x10
#define MAP_ANONYMOUS	0x20
#define MAP_FAILED ((void *) -1)

#define MS_ASYNC		1
#define MS_INVALIDATE	2
#define MS_SYNC			4


#define MMAP_START_VA 0x50000000 // mmap文件的最低地址
#define MMAP_END_VA  0x51000000 // mmap文件的最高地址 16M空间 依次往后排列，不考虑回收重用


typedef struct mmap_infos{
    int used;
    uint64 start; //映射起始地址
    size_t len;
    int port;
    int flags;
    int fd;
    off_t offset;

}mmap_infos;


uint64 do_mmap(void* start,size_t len,int port,int flags,int fd,off_t offset);
int do_munmap(void* start,size_t len);
#endif