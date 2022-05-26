#include "include/inode.h"
#include "include/fat32.h"
#include "include/printk.h"


static vfs_inode_cache icache;

void fat32_init_i(){
    fat32_dirent* de=fat32_init();
    init_spinlock(&icache.spinlock,"dcache");
    for(int i=0;i<INODE_LIST_LENGTH;i++){
        init_sleeplock(&(icache.inode[i].i_sleeplock),"vfs_inode");
        icache.inode[i].i_ino=i;
        icache.inode[i].i_count=0;
        icache.inode[i].i_de=NULL;
        icache.inode[i].i_dev=0;
        icache.inode[i].i_nlink=0;
        icache.inode[i].i_start_blockno=0;
        icache.inode[i].i_total_blocks=0;
    }
    icache.inode[0].i_start_blockno=de->start_clusterno;
    icache.inode[0].i_total_blocks=1;
    //icache.inode[0].i_blocks[0]=icache.inode[0].i_start_blockno;
    icache.inode[0].i_de=de;
    icache.inode[0].i_dev=de->dev;
    icache.inode[0].i_file_size=de->file_size;
    icache.inode[0].i_count=de->ref_count;
}

fat32_dirent* find_dirent_i(fat32_dirent* current_de, char *file_name){
    fat32_dirent *de=find_dirent( current_de, file_name);
    if(de==NULL)    
        return  NULL;
    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(de==icache.inode[i].i_de){
            return de;
        }
    }

    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(icache.inode[i].i_de==NULL){
            icache.inode[i].i_ino=i;
            icache.inode[i].i_count=de->ref_count;
            icache.inode[i].i_nlink=1;
            icache.inode[i].i_dev=de->dev;
            icache.inode[i].i_de=de;
            icache.inode[i].i_file_size=de->file_size;
            icache.inode[i].i_start_blockno=de->start_clusterno;
            icache.inode[i].i_total_blocks=de->total_clusters;
            de->i_ino=i;
            //icache.inode[i].i_blocks[0]=icache.inode[i].i_start_blockno;
            //for(int j=1;i<icache.inode[j].i_total_blocks;j++){
            //    icache.inode[i].i_blocks[j]=fat_find_next_clusterno(icache.inode[i].i_blocks[j-1],1);
            //}
            return de;
        }
    }
    printk("inode is full\n");
    return NULL;
}

fat32_dirent* find_dirent_with_create_i(fat32_dirent* current_de, char *file_name,int is_create, int attribute){
    fat32_dirent *de=find_dirent_with_create( current_de, file_name, is_create, attribute);
    if(de==NULL)    
        return  NULL;
    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(de==icache.inode[i].i_de){
            return de;
        }
    }

    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(icache.inode[i].i_de==NULL){
            icache.inode[i].i_ino=i;
            icache.inode[i].i_count=de->ref_count;
            icache.inode[i].i_nlink=1;
            icache.inode[i].i_mode=1;
            icache.inode[i].i_atime=0xB906;
            icache.inode[i].i_mtime=0x54A5;
            icache.inode[i].i_ctime=0xB905;
            icache.inode[i].i_dev=de->dev;
            icache.inode[i].i_de=de;
            icache.inode[i].i_file_size=de->file_size;
            icache.inode[i].i_start_blockno=de->start_clusterno;
            icache.inode[i].i_total_blocks=de->total_clusters;
            de->i_ino=i;
            //icache.inode[i].i_blocks[0]=icache.inode[i].i_start_blockno;
            //for(int j=1;i<icache.inode[j].i_total_blocks;j++){
            //    icache.inode[i].i_blocks[j]=fat_find_next_clusterno(icache.inode[i].i_blocks[j-1],1);
            //}
            return de;
        }
    }
    printk("inode is full\n");
    return NULL;
}

void release_dirent_i(fat32_dirent* de){
    if(de==NULL || de->i_ino==0)
        return;
    release_dirent(de);
    if(de==icache.inode[0].i_de)    
        return;
    if(de->i_ino<INODE_LIST_LENGTH && icache.inode[de->i_ino].i_de==de){
        icache.inode[de->i_ino].i_count--;
        if(icache.inode[de->i_ino].i_count==0) {
            icache.inode[de->i_ino].i_de=NULL;
        } 
    }
    /*
    int i=1;
    for(;i<INODE_LIST_LENGTH;i++){
        if(de==icache.inode[i].i_de){
            icache.inode[i].i_count--;
            if(icache.inode[i].i_count==0) {
                icache.inode[i].i_de=NULL;
            } 
        }
    }
    */

    
}

fat32_dirent * dirent_dup_i(fat32_dirent *de){
    dirent_dup(de);
    if(de->i_ino<INODE_LIST_LENGTH && icache.inode[de->i_ino].i_de==de){
        icache.inode[de->i_ino].i_count++;
    }
    /*
    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(de==icache.inode[i].i_de){
            icache.inode[i].i_count++;
        }
    }
    */
    return de;
}

/*
fat32_dirent* acquire_dirent_i(fat32_dirent* parent, char* name){
    fat32_dirent* de=acquire_dirent( parent, name);
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
*/


int read_by_dirent_i(fat32_dirent *de, void *dst, uint offset, uint rsize){
    return read_by_dirent(de, dst, offset,  rsize);
}

int write_by_dirent_i(fat32_dirent *de, void *src, uint offset,  uint wsize){
    int result=write_by_dirent2(de, src, offset, wsize);
    if(de->i_ino<INODE_LIST_LENGTH && icache.inode[de->i_ino].i_de==de){
        icache.inode[de->i_ino].i_file_size=de->file_size;
        icache.inode[de->i_ino].i_start_blockno=de->start_clusterno;
        icache.inode[de->i_ino].i_total_blocks=de->total_clusters;
    }
    /*
    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(de==icache.inode[i].i_de){
            icache.inode[i].i_file_size=de->file_size;
            icache.inode[i].i_start_blockno=de->start_clusterno;
            icache.inode[i].i_total_blocks=de->total_clusters;
            //icache.inode[i].i_blocks[0]=icache.inode[i].i_start_blockno;
            //for(int j=1;i<icache.inode[j].i_total_blocks;j++){
            //    icache.inode[i].i_blocks[j]=fat_find_next_clusterno(icache.inode[i].i_blocks[j-1],1);
            //}
            break;
        }
    }
    */
    return  result;
}

void trunc_by_dirent_i(fat32_dirent *de){
    trunc_by_dirent(de);
    if(de->i_ino<INODE_LIST_LENGTH && icache.inode[de->i_ino].i_de==de){
        icache.inode[de->i_ino].i_file_size=0;
        icache.inode[de->i_ino].i_start_blockno=0;
        icache.inode[de->i_ino].i_total_blocks=0;
    }
    /*
    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(de==icache.inode[i].i_de){
            icache.inode[i].i_file_size=0;
            icache.inode[i].i_start_blockno=0;
            icache.inode[i].i_total_blocks=0;
        }
    }
    */
}

vfs_inode* get_inode_by_ino(uint32 ino){
    if(ino>=INODE_LIST_LENGTH)  return  NULL;
    //if(icache.inode[ino].i_de==NULL)    return  NULL;
    return  &icache.inode[ino];
}   

vfs_inode* get_inode_by_dirent(fat32_dirent*    de){
    if(de->i_ino<INODE_LIST_LENGTH && icache.inode[de->i_ino].i_de==de){
        return icache.inode+de->i_ino;
    }
    /*
    for(int i=0;i<INODE_LIST_LENGTH;i++){
        if(icache.inode[i].i_de==de){
            return  &icache.inode[i];
        }
    }
    */
    return  NULL;
}
