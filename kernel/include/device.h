#ifndef _DEVICE_H_
#define _DEVICE_H_

#include "types.h"

typedef struct device{
    enum {BLOCK_TYPE, CHARACTER_TYPE, NONE_TYPE} type;
    int (*read)(uint8*,int);
    int (*write)(uint8*,int);
}device;

#define NDEV 16

extern device dev_list[NDEV];

#endif