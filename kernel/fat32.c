#include "include/fat32.h"
#include "include/buffer.h"
#include "include/string.h"
#include "include/printk.h"

#ifndef DEVICE_DISK_NUM
#define DEVICE_DISK_NUM 0
#endif

fat32_mbr mbr_info;
fat32_dbr dbr_info;

//LRU cache
static dirent_cache dcache;

void fat32_init(){
    buffer *buf;

    //mbr init
    buf=acquire_buffer(DEVICE_DISK_NUM,0);
    //mbr_info.dbr_start_sector=*((uint32*)(buf->data+MBR_DBR_START_SECTOR_OFFSET));
    memcpy(&mbr_info.dbr_start_sector,buf->data+MBR_DBR_START_SECTOR_OFFSET,sizeof(uint32));
    //mbr_info.total_sectors=*((uint32*)(buf->data+MBR_TOTAL_SECORS_OFFSET));
    memcpy(&mbr_info.total_sectors,buf->data+MBR_TOTAL_SECORS_OFFSET,sizeof(uint32));
    release_buffer(buf);
    
    //dbr init
    buf=acquire_buffer(DEVICE_DISK_NUM,mbr_info.dbr_start_sector);
    //dbr_info.bytes_per_sector=*((uint16*)(buf->data+DBR_BYTES_PER_SECTOR_OFFSET));
    memcpy(&dbr_info.bytes_per_sector,buf->data+DBR_BYTES_PER_SECTOR_OFFSET,sizeof(uint16));
    if(dbr_info.bytes_per_sector!=BSIZE)
        panic("bytes_per_sector is not 512\n");
    dbr_info.sectors_per_block=*((uint8*)(buf->data+DBR_SECTORS_PER_BLOCK_OFFSET));
    dbr_info.dbr_reserve_sectors=*((uint16*)(buf->data+DBR_RESERVE_SECTORS_OFFSET));
    dbr_info.total_fats=*((uint8*)(buf->data+DBR_TOTAL_FATS_OFFSET));
    dbr_info.hidden_sectors=*((uint32*)(buf->data+DBR_HIDDEN_SECTORS_OFFSET));
    dbr_info.fs_total_sectors=*((uint32*)(buf->data+DBR_FS_TOTAL_SECTORS_OFFSET));
    dbr_info.sectors_per_fat=*((uint32*)(buf->data+DBR_SECTORS_PER_FAT_OFFSET));
    dbr_info.root_dir_blockno=*((uint32*)(buf->data+DBR_ROOT_DIR_BLOCK_OFFSET));
    dbr_info.fsinfo_sector=*((uint16*)(buf->data+DBR_FSINFO_SECTOR_OFFSET));
    dbr_info.dbr_backup_sector=*((uint16*)(buf->data+DBR_BACKUP_SECTOR_OFFSET));
    release_buffer(buf);
    
    //root directory init
    memset(&dcache.root_dir,0,sizeof(dcache.root_dir));
    dcache.root_dir.attribute=ATTR_DIRECTORY;
    //dcache.root_dir.current_blockno=dbr_info.root_dir_blockno;
    dcache.root_dir.dev=DEVICE_DISK_NUM;
    dcache.root_dir.start_blockno=dbr_info.root_dir_blockno;
    memcpy(dcache.root_dir.name,"/",1);
    init_sleeplock(&dcache.root_dir.sleeplock,"root dirent");
    
    //dcache init
    init_spinlock(&dcache.spinlock, "dcache");
    dcache.root_dir.prev=&dcache.root_dir;
    dcache.root_dir.next=&dcache.root_dir;
    for(int i=0;i<DIRENT_LIST_LENGTH;i++){
        (dcache.dirent_list+i)->valid=0;
        (dcache.dirent_list+i)->dev=0;
        (dcache.dirent_list+i)->ref_count=0;
        (dcache.dirent_list+i)->parent=NULL;
        init_sleeplock(&(dcache.dirent_list+i)->sleeplock,"dirent");
        (dcache.dirent_list+i)->next=dcache.root_dir.next;
        (dcache.dirent_list+i)->prev=&dcache.root_dir;
        dcache.root_dir.next->prev=(dcache.dirent_list+i);
        dcache.root_dir.next=(dcache.dirent_list+i);
    }
}

static uint32 blockno_to_sectorno(uint32 blockno){
    int sectorno=mbr_info.dbr_start_sector+dbr_info.dbr_reserve_sectors;
    sectorno+=dbr_info.sectors_per_fat*dbr_info.total_fats;
    sectorno+=dbr_info.sectors_per_block*(blockno-dbr_info.root_dir_blockno);
	return sectorno;
}

/*
static uint32 sectorno_to_blockno(uint32 sectorno){
    int blockno=sectorno-mbr_info.dbr_start_sector;
    blockno+=dbr_info.dbr_reserve_sectors;
    blockno+=dbr_info.sectors_per_fat*dbr_info.total_fats;
    blockno/=dbr_info.sectors_per_block+2;
    return blockno;
}
*/

static inline uint32 fat_blockno_to_sectorno(uint32 blockno, uint32 fatno){
    return 4*blockno/dbr_info.bytes_per_sector+mbr_info.dbr_start_sector+
        dbr_info.dbr_reserve_sectors+dbr_info.sectors_per_fat*(fatno-1);
}

static inline uint32 fat_blockno_to_offset(uint32 blockno){
    return (4*blockno)%dbr_info.bytes_per_sector;
}

static uint32 fat_find_next_blockno(uint32 blockno, uint32 fatno){
    if(blockno==FAT_BLOCK_END || blockno==FAT_BLOCK_DAMAGE)
        return blockno;
    uint32 sec=fat_blockno_to_sectorno(blockno, fatno);
    if(sec>=mbr_info.dbr_start_sector+dbr_info.dbr_reserve_sectors+dbr_info.sectors_per_fat*fatno)
        return blockno;
    uint32 off=fat_blockno_to_offset(blockno);
    buffer* buf=acquire_buffer(DEVICE_DISK_NUM, sec);
    uint32 next_block=*((uint32*)(buf->data+off));
    release_buffer(buf);
    return next_block;
}

uint32 fat_temp(uint32 blockno){
    return fat_find_next_blockno(blockno,1);
}

/*
static void fat_update_next_blockno(uint32 blockno, uint32 next_blockno, uint32 fatno){
    uint32 sec=fat_blockno_to_sectorno(blockno, fatno);
    if(sec>=mbr_info.dbr_start_sector+dbr_info.dbr_reserve_sectors+dbr_info.sectors_per_fat*fatno)
        return;
    uint32 off=fat_blockno_to_offset(blockno);
    buffer* buf=acquire_buffer(DEVICE_DISK_NUM, sec);
    *((uint32*)(buf->data+off))=next_blockno;
    buffer_write(buf);
    release_buffer(buf);
}
*/

static uint32 get_start_blockno_in_short_entry(fat32_short_name_dir_entry* sde){
    uint32 h=(uint32)sde->start_blockno_high;
    uint32 l=(uint32)sde->start_blockno_low;
    return (h<<16)+l;
}

static void get_full_short_name(fat32_short_name_dir_entry* sde,char* full_name){
    memset(full_name,0,FILE_NAME_LENGTH+1);
    memcpy(full_name,sde->name,SHORT_NAME_LENGTH);
    int point=-1;
    for(int i=0;i<SHORT_NAME_LENGTH;i++){
        if(full_name[i]==0x20){
            full_name[i]=0;
            if(point==-1)
                point=i;
        }
    }
    if(point==-1)
        point=SHORT_NAME_LENGTH;
    full_name[point]='.';
    memcpy(full_name+point+1,sde->extend_name,EXTEND_NAME_LENGTH);
    for(int i=1;i<=EXTEND_NAME_LENGTH;i++){
        if(full_name[point+i]==0x20){
            full_name[point+i]=0;
            if(i==1)
                full_name[point]=0;
        }
    }
}

static int read_dirent_from_disk(dirent* parent, char *name, dirent* des_dir){
    char full_name[FILE_NAME_LENGTH+1];
    for(uint32 blk=parent->start_blockno;blk!=FAT_BLOCK_END;blk=fat_find_next_blockno(blk,1)){
        uint32 start_sec=blockno_to_sectorno(blk);
        for(int sec_off=0;sec_off<dbr_info.sectors_per_block;sec_off++){
            buffer *buf=acquire_buffer(DEVICE_DISK_NUM,start_sec+sec_off);
            for(uint32 off=0;off<dbr_info.bytes_per_sector;off+=DIR_ENTRY_BYTES){
                fat32_dir_entry dentry;
                memcpy(&dentry,buf->data+off,DIR_ENTRY_BYTES);
                if(dentry.short_name_dentry.atrribute==ATTR_LONG_NAME){
                    //panic("not support long name dentry yet\n");
                    continue;
                }
                get_full_short_name(&dentry.short_name_dentry,full_name);
                if(!strcmp(name,full_name)){
                    release_buffer(buf);
                    memcpy(des_dir->name, full_name,12);
                    des_dir->attribute=dentry.short_name_dentry.atrribute;
                    des_dir->offset_in_parent=sec_off*dbr_info.bytes_per_sector+off;
                    des_dir->start_blockno=get_start_blockno_in_short_entry(&dentry.short_name_dentry);
                    //des_dir->current_blockno=des_dir->start_blockno;
                    des_dir->file_size=dentry.short_name_dentry.file_size;
                    des_dir->total_blocks=des_dir->file_size/(dbr_info.bytes_per_sector*dbr_info.sectors_per_block);
                    if(des_dir->start_blockno==0x0)
                        des_dir->start_blockno=0x2;
                    return 0;
                }
            }
            release_buffer(buf);
        }
    }
    return -1;
}

/*
static void dirent_write_to_disk(dirent* dir){
    //need to be done
    
}
*/

static void move_dirent_to_dcache_head(dirent* dir){
    dir->prev->next=dir->next;
    dir->next->prev=dir->prev;
    dir->prev=dcache.root_dir.prev;
    dir->next=&dcache.root_dir;
    dcache.root_dir.prev->next=dir;
    dcache.root_dir.prev=dir;
}

dirent* acquire_dirent(dirent* parent, char* name ){
    if(name==NULL)
        return NULL;
    //acquire_spinlock(&dcache.spinlock);
    dirent* de;
    for( de=dcache.root_dir.next;de!=&dcache.root_dir;de=de->next){
        if(de->valid==1 && de->parent==parent && 
            !strcmp(name,de->name)){
            //release_spinlock(&de->spinlock);
            //acquire_sleeplock(&de->sleeplock);
            if(de->ref_count==0)
                parent->ref_count++;
            de->ref_count++;
            return de;
        }
    }

    for(de=dcache.root_dir.prev;de!=&dcache.root_dir;de=de->prev){
        if(de->ref_count==0){
            de->ref_count++;
            de->parent=parent;
            de->dev=parent->dev;
            de->valid=1;
            //release_spinlock(&de->spinlock);
            //acquire_sleeplock(&de->sleeplock);
            int ret=read_dirent_from_disk(parent,name,de);
            if(ret==-1){
                //release_sleeplock(&de->sleeplock);
                return NULL;
            }
            return de;
        }
    }

    panic("dcache is full\n");
    return NULL;
}

void release_dirent(dirent* dir){
    //if(!is_holding_sleeplock(&dir->sleeplock))
        //panic("release_dirent\n");
    
    //release_sleeplock(&dir->sleeplock);
    //acquire_spinlock(&dcache.spinlock);

    dir->ref_count--;
    if(dir->ref_count==0){
        dir->parent->ref_count--;
        move_dirent_to_dcache_head(dir);
    }

    //release_spinlock(&dcache.spinlock);
}

int find_dirent(dirent* des_de, dirent* current_de, char *file_name){
    upper(file_name);
    if(des_de==NULL || file_name==NULL || strlen(file_name)>FILE_NAME_LENGTH)
        return 1;
    if(*file_name=='/'){
        current_de=&dcache.root_dir;
        file_name++;
    }
    if(current_de==NULL)
        return 2;
    int slash_pos=0;
    int beg_pos=0;
    int is_end=0;
    char temp_name[FILE_NAME_LENGTH+1];
    dirent* parent=current_de;
    dirent* child=NULL;
    while(!is_end){
        while(file_name[slash_pos]!='/'){
            if(file_name[slash_pos]==0){
                is_end=1;
                break;
            }
            slash_pos++;
        }
        if(file_name[beg_pos]==0 && file_name[slash_pos]==0)
            break;
        memset(temp_name,0,FILE_NAME_LENGTH+1);
        memcpy(temp_name,file_name+beg_pos,slash_pos-beg_pos);
        child=acquire_dirent(parent,temp_name);
        if(parent!=NULL && parent!=current_de)
            release_dirent(parent);
        if(child==NULL){
            printk("%s : file not found\n",temp_name);
            return -1;
        }
        //printk("%s, %x\n",child->name,child->start_blockno);
        parent=child;
        slash_pos++;
        beg_pos=slash_pos;
    }
    memcpy(des_de,child,sizeof(dirent));
    if(child!=NULL)
        release_dirent(child);
    return 0;
}

int read_by_dirent(dirent *de, void *dst, uint offset, uint rsize){
    if((de->attribute & ATTR_DIRECTORY) || offset>de->file_size || rsize<=0)
        return 0;

    if(offset+rsize>de->file_size)
        rsize=de->file_size-offset;

    uint32 blk=offset/(dbr_info.bytes_per_sector*dbr_info.sectors_per_block)+de->start_blockno;
    uint32 sec=(offset%(dbr_info.bytes_per_sector*dbr_info.sectors_per_block))/dbr_info.bytes_per_sector;
    uint32 off=offset%dbr_info.bytes_per_sector;

    uint32 nblk=rsize/(dbr_info.bytes_per_sector*dbr_info.sectors_per_block);
    uint32 nsec=(rsize%(dbr_info.bytes_per_sector*dbr_info.sectors_per_block))/dbr_info.bytes_per_sector;
    uint32 noff=rsize%dbr_info.bytes_per_sector;
    
    if(noff+off>dbr_info.bytes_per_sector){
        nsec++;
        if(nsec>=dbr_info.sectors_per_block){
            nsec=0;
            nblk++;
        }
        noff=(noff+off)%dbr_info.bytes_per_sector;
    }

    uint tot_sz=0;
    buffer *buf;
    for(int b=0;b<=nblk;b++){
        if(blk==FAT_BLOCK_END){
            return tot_sz;
        }

        int s_beg=0;
        int s_end=dbr_info.sectors_per_block-1;
        if(b==0)
            s_beg=sec;
        if(b==nblk)
            s_end=s_beg+nsec;
        for(int s=s_beg,s_sec=blockno_to_sectorno(blk);s<=s_end;s++){
            int beg=0;
            int nsz=dbr_info.bytes_per_sector;

            if(b==0 && s==0){
                tot_sz=0;
                beg=off;
                nsz-=off;
            }
            if(b==nblk && s==s_end)
                nsz=noff;
            
            buf=acquire_buffer(de->dev,s_sec+s);
            memcpy(dst+tot_sz,buf->data+beg,nsz);
            release_buffer(buf);
            tot_sz+=nsz;
        }

        blk=fat_find_next_blockno(blk,1);
    }

    return tot_sz;
}

int write_by_dirent(dirent *de, void *src, uint offset, uint wsize){
    return wsize;
}