#ifndef _INODE_H_
#define _INODE_H_
#include "types.h"
#include "sleeplock.h"
#include "fat32.h"

typedef unsigned int mode_t;

typedef struct vfs_inode{
    uint32 i_ino;//inode号
    uint32  i_count;//引用数
    uint32  i_nlink;//硬连接数
    fat32_dirent *i_de;//相关联的目录项
    uint8     i_dev;//设备号
    uint32  i_file_size;//文件大小
    sleeplock sleeplock;    //睡眠锁
}vfs_inode;

#define INODE_LIST_LENGTH 256

typedef struct  inode_cache{
    vfs_inode inode[INODE_LIST_LENGTH];   //vfs_inode列表
    spinlock spinlock;  //自旋锁
}vfs_inode_cache;

fat32_dirent* find_dirent_i(fat32_dirent* current_de, char *file_name);
void release_dirent_i(fat32_dirent* de);
vfs_inode* dirent_dup_i(fat32_dirent *de)

#endif