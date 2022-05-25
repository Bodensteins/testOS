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
        icache.inode[i].i_count=1;
        icache.inode[i].i_de=NULL;
        icache.inode[i].i_dev=0;
        icache.inode[i].i_nlink=0;
        icache.inode[i].i_start_blockno=0;
        icache.inode[i].i_total_blocks=0;
    }
    icache.inode[0].i_start_blockno=de->start_clusterno;
    icache.inode[0].i_total_blocks=1;
    icache.inode[0].i_blocks[0]=icache.inode[0].i_start_blockno;
    icache.inode[0].i_de=de;
    icache.inode[0].i_dev=de->dev;
    icache.inode[0].i_file_size=de->file_size;
    icache.inode[0].i_count=de->ref_count;
    de->ino=0;
}

fat32_dirent* find_dirent_i(fat32_dirent* current_de, char *file_name){
    fat32_dirent *de= find_dirent( current_de, file_name);
    if(de==NULL)    return  NULL;
    if(de->ino!=-1){
        return de;
    }

    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(icache.inode[i].i_de==NULL){
            de->ino=i;
            icache.inode[i].i_ino=i;
            icache.inode[i].i_count=1;
            icache.inode[i].i_nlink=0;
            icache.inode[i].i_dev=de->dev;
            icache.inode[i].i_de=de;
            icache.inode[i].i_file_size=de->file_size;
            icache.inode[i].i_start_blockno=de->start_clusterno;
            icache.inode[i].i_total_blocks=de->total_clusters;
            icache.inode[i].i_blocks[0]=icache.inode[i].i_start_blockno;
            for(int j=1;i<icache.inode[j].i_total_blocks;j++){
                icache.inode[i].i_blocks[j]=fat_find_next_clusterno(icache.inode[i].i_blocks[j-1],1);
            }
            return de;
        }
    }
     panic("inode is full\n");
     return NULL;
}

void release_dirent_i(fat32_dirent* de){
    release_dirent(de);
    if(de==NULL||de->ino==-1)    return;
    if(de==icache.inode[0].i_de)    return;
    uint32  ino=de->ino;
    icache.inode[ino].i_count--;
    if(icache.inode[ino].i_count==0) {
        icache.inode[ino].i_de=NULL;
    } 
}

fat32_dirent * dirent_dup_i(fat32_dirent *de){
    dirent_dup(de);
    uint32  ino=de->ino;
    icache.inode[ino].i_count++;
    return de;
}


int read_by_dirent_i(fat32_dirent *de, void *dst, uint offset, uint rsize){
    return read_by_dirent(de, dst, offset,  rsize);
}

int write_by_dirent_i(fat32_dirent *de, void *src, uint offset,  uint wsize){
    int result=write_by_dirent(de, src, offset, wsize);
    uint32  ino=de->ino;
    icache.inode[ino].i_file_size=de->file_size;
    icache.inode[ino].i_start_blockno=de->start_clusterno;
    icache.inode[ino].i_total_blocks=de->total_clusters;
    icache.inode[ino].i_blocks[0]=icache.inode[ino].i_start_blockno;
    for(int j=1;i<icache.inode[j].i_total_blocks;j++){
         icache.inode[ino].i_blocks[j]=fat_find_next_clusterno(icache.inode[ino].i_blocks[j-1],1);
    }
    return  result;
}

void trunc_by_dirent_i(fat32_dirent *de){
    trunc_by_dirent(de);
    uint32  ino=de->ino;
    icache.inode[ino].i_file_size=0;
    icache.inode[ino].i_start_blockno=0;
    icache.inode[ino].i_total_blocks=0;
}

vfs_inode* get_inode_by_ino(uint32 ino){
    if(ino>=INODE_LIST_LENGTH)  return  NULL;
    if(icache.inode[ino].i_de==NULL)    return  NULL;
    return  &icache.inode[ino];
}   

vfs_inode* get_inode_by_dirent(fat32_dirent*    de){
    if(de->ino==-1) return  NULL;
   return   &icache.inode[de->ino];
}
