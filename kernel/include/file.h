#ifndef _FILE_H_
#define _FILE_H_

#include "types.h"
#include "fat32.h"

#define FILE_TYPE_DEVICE 0x1
#define FILE_TYPE_PIPE 0x2

#define FILE_ATTR_READ 0x1
#define FILE_ATTR_WRITE 0x2
#define FILE_ATTR_EXEC 0x4

typedef struct file{
    int type;
    dirent *dirent;
    //pipe *pipe;
    int attribute;
    int dev;
    int ref_count;
    uint32 offset;
}file;

#endif