#include "include/inode.h"
#include "include/fat32.h"
#include "include/printk.h"

static vfs_inode_cache icache;

void fat32_init_i(){
    fat32_dirent* de=fat32_init();
    init_spinlock(&icache.spinlock,"dcache");
    for(int i=0;i<INODE_LIST_LENGTH;i++){
        init_spinlock(&(icache.inode[i].i_sleeplock),"vfs_inode");
        icache.inode[i].i_ino=i;
        icache.inode[i].i_count=0;
        icache.inode[i].i_de=NULL;
        icache.inode[i].i_dev=0;
        icache.inode[i].i_nlink=0;
    }
    icache.inode[0].i_de=de;
    icache.inode[0].i_dev=de->dev;
    icache.inode[0].i_file_size=de->file_size;
    icache.inode[0].i_count=de->ref_count;
}

fat32_dirent* find_dirent_i(fat32_dirent* current_de, char *file_name){
    fat32_dirent *de= find_dirent( current_de, file_name);
    if(de==NULL)    return  NULL;
    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(de==icache.inode[i].i_de){
            return de;
        }
    }

    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(icache.inode[i].i_de==NULL){
            icache.inode[i].i_ino=i;
            icache.inode[i].i_count=de->ref_count;
            icache.inode[i].i_nlink=0;
            icache.inode[i].i_dev=de->dev;
            icache.inode[i].i_de=de;
            icache.inode[i].i_file_size=de->file_size;
            icache.inode[i].i_start_blockno=de->start_clusterno;
            icache.inode[i].i_start_blockno=de->total_clusters;
            return de;
        }
    }
     panic("inode is full\n");
     return NULL;
}

void release_dirent_i(fat32_dirent* de){
    release_dirent(de);
    if(de==icache.inode[0].i_de)    return;
    int i=1;
    for(;i<INODE_LIST_LENGTH;i++){
        if(de==icache.inode[i].i_de){
            icache.inode[i].i_count--;
            if(icache.inode[i].i_count==0) {
                icache.inode[i].i_de=NULL;
            } 
        }
    }
}

fat32_dirent * dirent_dup_i(fat32_dirent *de){
    dirent_dup(de);
    int i=1;
    for(;i<INODE_LIST_LENGTH;i++){
        if(de==icache.inode[i].i_de){
            icache.inode[i].i_count++;
        }
    }
    return de;
}

fat32_dirent* acquire_dirent_i(fat32_dirent* parent, char* name){
    fat32_dirent* de=acquire_dirent(fat32_dirent* parent, char* name);
    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(de==icache.inode[i].i_de){
            return de;
        }
    }
    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(icache.inode[i].i_de==NULL){
            icache.inode[i].i_ino=i;
            icache.inode[i].i_count=de->ref_count;
            icache.inode[i].i_nlink=0;
            icache.inode[i].i_dev=de->dev;
            icache.inode[i].i_de=de;
            icache.inode[i].i_file_size=de->file_size;
            icache.inode[i].i_start_blockno=de->start_clusterno;
            icache.inode[i].i_start_blockno=de->total_clusters;
            return de;
        }
    }
     panic("inode is full\n");
     return NULL;
}

int read_by_dirent_i(fat32_dirent *de, void *dst, uint offset, uint rsize){
    return read_by_dirent(de, dst, offset,  rsize);
}

int write_by_dirent_i(fat32_dirent *de, void *src, uint offset,  uint wsize){
    int result=write_by_dirent(de, src, offset, wsize);
    for(;i<INODE_LIST_LENGTH;i++){
        if(de==icache.inode[i].i_de){
            icache.inode[i].i_file_size=de->file_size;
        }
    }
    return  result;
}

void trunc_by_dirent_i(fat32_dirent *de){
    trunc_by_dirent(fat32_dirent *de);
    for(;i<INODE_LIST_LENGTH;i++){
        if(de==icache.inode[i].i_de){
            icache.inode[i].i_file_size=0;
            icache.inode[i].i_start_blockno=0;
        }
    }
}

vfs_inode* get_inode_by_ino(uint32 ino){
    if(ino>=INODE_LIST_LENGTH)  return  NULL;
    if(icache.inode[ino].i_de==NULL)    return  NULL;
    return  &icache.inode[ino];
}   

vfs_inode* get_inode_by_dirent(fat32_dirent*    de){
    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(icache.inode[i].i_de==de){
            return  &icache.inode[i];
        }
    }
    return  NULL;
}
