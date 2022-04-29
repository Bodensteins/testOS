#ifndef _FILE_H_
#define _FILE_H_

#include "types.h"
#include "fat32.h"

#define FILE_TYPE_NONE 0x0
#define FILE_TYPE_FS 0x1
#define FILE_TYPE_DEVICE 0x2
#define FILE_TYPE_PIPE 0x4

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

#define NFILE 128

typedef struct file_table{
    spinlock spinlock;
    file file[NFILE];
}file_table;

extern file_table ftable;

void file_init();
file *acquire_file();
void release_file(file *file);
int read_file(file *file, void *buf, uint rsize);
int write_file(file *file, void *buf, uint wsize);
file* file_dup(file* file);

#endif