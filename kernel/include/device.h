#ifndef _DEVICE_H_
#define _DEVICE_H_

#include "types.h"
//#include "spinlock.h"

/*
设备管理相关
*/

#define DEVICE_DISK_NUM 0
#define DEVICE_CONSOLE_NUM 1

typedef struct device{
    //enum {BLOCK_TYPE, CHARACTER_TYPE, NONE_TYPE} type;
    int (*read)(void* ,int);
    int (*write)(void* ,int);
}device;

#ifndef NDEV
#define NDEV 8
#endif

extern device dev_list[NDEV];

file* open_device(char *dev_name);
void device_init();

#endif