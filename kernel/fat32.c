#include "include/fat32.h"
#include "include/buffer.h"
#include "include/string.h"
#include "include/printk.h"

#define DEVICE_SDCARD_NUM 0

fat32_mbr mbr_info;
fat32_dbr dbr_info;

//LRU cache
static dirent_cache dcache;

void fat32_init(){
    buffer *buf;

    //mbr init
    buf=acquire_buffer(DEVICE_SDCARD_NUM,0);
    mbr_info.dbr_start_sectors=*((uint32*)(buf->data+MBR_DBR_START_SECTORS_OFFSET));
    mbr_info.total_sectors=*((uint32*)(buf->data+MBR_TOTAL_SECORS_OFFSET));
    release_buffer(buf);

    //dbr init
    buf=acquire_buffer(DEVICE_SDCARD_NUM,mbr_info.dbr_start_sectors);
    dbr_info.bytes_per_sector=*((uint16*)(buf->data+DBR_BYTES_PER_SECTOR_OFFSET));
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
    dcache.root_dir.current_blockno=dcache.root_dir.start_blockno=dbr_info.root_dir_blockno;
    memcpy(dcache.root_dir.name,"/",1);
    init_sleeplock(&dcache.root_dir.sleeplock,"root dirent");

    //dcache init
    init_spinlock(&dcache.spinlock, "dcache");
    dcache.root_dir.prev=&dcache.root_dir;
    dcache.root_dir.next=&dcache.root_dir;
    for(int i=0;i<DIRENT_LIST_LENGTH;i++){
        (dcache.dirent_list+i)->valid=0;
        (dcache.dirent_list+i)->dev=0;
        (dcache.dirent_list+i)->total_refs=0;
        (dcache.dirent_list+i)->parent=NULL;
        init_sleeplock(&(dcache.dirent_list+i)->sleeplock,"dirent");
        (dcache.dirent_list+i)->next=dcache.root_dir.next;
        (dcache.dirent_list+i)->prev=&dcache.root_dir;
        dcache.root_dir.next->prev=(dcache.dirent_list+i);
        dcache.root_dir.next=(dcache.dirent_list+i);
    }
}

static int blockno_to_sectorno(int blockno){
    int sectorno=mbr_info.dbr_start_sectors+dbr_info.dbr_reserve_sectors;
    sectorno+=dbr_info.sectors_per_fat*dbr_info.total_fats;
    sectorno+=dbr_info.sectors_per_block*(blockno-dbr_info.root_dir_blockno);
	return sectorno;
}

static int sectorno_to_blockno(int sectorno){
    int blockno=sectorno-mbr_info.dbr_start_sectors;
    blockno+=dbr_info.dbr_reserve_sectors;
    blockno+=dbr_info.sectors_per_fat*dbr_info.total_fats;
    blockno/=dbr_info.sectors_per_block+2;
    return blockno;
}

static void read_dirent_from_disk(dirent* des_dir, int sectorno, int offset){}

static void dirent_write(dirent* dir){}

static void move_dirent_to_dcache_head(dirent* dir){}

dirent* acquire_dirent(dirent* parent, char* name ){}

void release_dirent(dirent* dir){}

