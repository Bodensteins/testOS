#include "include/inode.h"
#include "include/fat32.h"

static vfs_inode_cache icache;

fat32_dirent* find_dirent_i(fat32_dirent* current_de, char *file_name){
    fat32_dirent *de= find_dirent( current_de, file_name);
    if(de==NULL)    return  NULL;
    int i=0;
    for(;i<INODE_LIST_LENGTH;i++){
        if(de==icache.inode[i].i_de){
            return de;
        }
    }

    int i=0;
    for(;i<INODE_LIST_LENGTH;i++){
        if(icache.inode[i].i_de==NULL){
            icache.inode[i].i_ino=i;
            icache.inode[i].i_count=de->ref_count;
            icache.inode[i].i_nlink=0;
            icache.inode[i].i_dev=de->dev;
            icache.inode[i].i_de=de;
            icache.inode[i].i_file_size=de->file_size;
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
    for(;i<INODE_LIST_LENGTH&&icache.inode[i].i_de;i++){
        if(de==icache.inode[i].i_de){
            icache.inode[i].i_count--;
            if(icache.inode[i].i_count==0) {
                icache.inode[i].i_de=NULL;
            } 
        }
    }
}

vfs_inode* dirent_dup_i(fat32_dirent *de){
    dirent_dup(de);
    int i=1;
    for(;i<INODE_LIST_LENGTH&&icache.inode[i].i_de;i++){
        if(de==icache.inode[i].i_de){
            icache.inode[i].i_count++;
        }
    }
    return de;
}