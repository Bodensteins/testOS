#ifndef _INODE_H_
#define _INODE_H_
#include "types.h"
#include "sleeplock.h"
#include "fat32.h"

typedef unsigned int mode_t;

#define BLOCKS_MAX_NUMBER   256

typedef struct vfs_inode{
    uint32 i_ino;//inode号
    uint32  i_count;//引用数
    uint32  i_nlink;//硬连接数
    fat32_dirent *i_de;//相关联的目录项
    uint32 i_start_blockno;   //文件起始block号
    uint32 i_total_blocks;    //文件总共block号
    uint32  i_blocks[BLOCKS_MAX_NUMBER];//簇列表
    uint32  i_atime;//inode最后一次存取时间
    uint32  i_mtime;//inode最后一次修改时间
    uint32  i_ctime;//inode产生时间
    uint8     i_dev;//设备号
    uint32  i_file_size;//文件大小
    uint32  i_mode;
    sleeplock i_sleeplock;    //睡眠锁
}vfs_inode;

#define INODE_LIST_LENGTH 256

typedef struct  inode_cache{
    vfs_inode inode[INODE_LIST_LENGTH];   //vfs_inode列表
    spinlock spinlock;  //自旋锁
}vfs_inode_cache;

fat32_dirent* find_dirent_i(fat32_dirent* current_de, char *file_name);
void release_dirent_i(fat32_dirent* de);
fat32_dirent* dirent_dup_i(fat32_dirent *de);
fat32_dirent* acquire_dirent_i(fat32_dirent* parent, char* name);
int read_by_dirent_i(fat32_dirent *de, void *dst, uint offset, uint rsize);
int write_by_dirent_i(fat32_dirent *de, void *src, uint offset,  uint wsize);
void trunc_by_dirent_i(fat32_dirent *de);
void fat32_init_i();
vfs_inode* get_inode_by_ino(uint32 ino);
vfs_inode* get_inode_by_dirent(fat32_dirent*    de);
#endif