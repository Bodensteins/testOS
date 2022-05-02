#ifndef _DEVICE_H_
#define _DEVICE_H_

#include "types.h"

/*
设备管理相关
这里还没怎么设计好，先忽略
*/

typedef struct device{
    enum {BLOCK_TYPE, CHARACTER_TYPE, NONE_TYPE} type;
    int (*read)(void* ,int);
    int (*write)(void* ,int);
}device;

#define NDEV 16

extern device dev_list[NDEV];

#endif