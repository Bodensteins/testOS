#ifndef _FAT32_H_
#define _FAT32_H_

#include "types.h"
#include "sleeplock.h"

#ifndef BSIZE
#define BSIZE 512
#endif

#define FAT_BLOCK_END 0x0fffffff
#define FAT_BLOCK_DAMAGE 0xffffff7

//MBR
#define MBR_DBR_START_SECTOR_OFFSET 0x1C6
#define MBR_TOTAL_SECORS_OFFSET 0x1CA

typedef struct fat32_mbr{
    uint32 dbr_start_sector;     //to dbr sector
    uint32 total_sectors;
}fat32_mbr;

//DBR
#define DBR_BYTES_PER_SECTOR_OFFSET 0x0B
#define DBR_SECTORS_PER_BLOCK_OFFSET 0x0D
#define DBR_RESERVE_SECTORS_OFFSET 0x0E
#define DBR_TOTAL_FATS_OFFSET 0x10
#define DBR_HIDDEN_SECTORS_OFFSET 0x1C
#define DBR_FS_TOTAL_SECTORS_OFFSET 0x20
#define DBR_SECTORS_PER_FAT_OFFSET 0x24
#define DBR_ROOT_DIR_BLOCK_OFFSET 0x2C
#define DBR_FSINFO_SECTOR_OFFSET 0x30
#define DBR_BACKUP_SECTOR_OFFSET 0x32

typedef struct fat32_dbr{
    uint16 bytes_per_sector;
    uint8 sectors_per_block;
    uint16 dbr_reserve_sectors;    //to fat sector
    uint8 total_fats;
    uint32 hidden_sectors;      //same with relative_sectors in mbr(0x01C6)
    uint32 fs_total_sectors;
    uint32 sectors_per_fat;
    uint32 root_dir_blockno;
    uint16 fsinfo_sector;
    uint16 dbr_backup_sector;
}fat32_dbr;


//FSINFO
#define FSINFO_FS_TOTAL_EMPTY_BLOCKS_OFFSET 0x1E8
#define FSINFO_NEXT_USABLE_BLOCK_OFFSET 0x1EC

typedef struct fat32_fsinfo{
    uint32 fs_total_empty_blocks;
    uint32 next_usable_block;
}fat32_fsinfo;


//directory entry
#define SHORT_NAME_LENGTH 8
#define EXTEND_NAME_LENGTH 3
#define DIR_ENTRY_BYTES 32
#define ATTR_READ_ONLY      0x01
#define ATTR_HIDDEN         0x02
#define ATTR_SYSTEM         0x04
#define ATTR_VOLUME_ID      0x08
#define ATTR_DIRECTORY      0x10
#define ATTR_ARCHIVE        0x20
#define ATTR_LONG_NAME      0x0F
#define LAST_LONG_ENTRY     0x40

#define SHORT_DENTRY_ATRRIBUTE_OFFSET 0xB
#define SHORT_DENTRY_START_BLOCKNO_HIGH_OFFSET 0x14
#define SHORT_DENTRY_START_BLOCKNO_LOW_OFFSET 0x1A
#define SHORT_DENTRY_FILE_SIZE_OFFSET 0x1C

typedef struct fat32_short_name_dir_entry{
    char name[SHORT_NAME_LENGTH];
    char extend_name[EXTEND_NAME_LENGTH];
    uint8 atrribute;
    uint8 system_reserve;
    uint8 create_time_tenth_msec;
    uint16 create_time;
    uint16 create_date;
    uint16 last_access_date;
    uint16 start_blockno_high;
    uint16 last_write_time;
    uint16 last_write_date;
    uint16 start_blockno_low;
    uint32 file_size;
}__attribute__((packed, aligned(4))) fat32_short_name_dir_entry;

typedef struct fat32_long_name_dir_entry{
    uint8 atrribute;
    char name1[10];
    uint8 symbol;
    uint8 system_reserve;
    uint8 verify_value;
    char name2[12];
    uint16 start_block;
    char name3[4];
}__attribute__((packed, aligned(4))) fat32_long_name_dir_entry;

typedef union fat32_dir_entry{
    fat32_short_name_dir_entry short_name_dentry;
    fat32_long_name_dir_entry long_name_dentry;
}fat32_dir_entry;

#define FILE_NAME_LENGTH 64

typedef struct dirent{
    char name[FILE_NAME_LENGTH+1];
    uint8 attribute;
    uint32 file_size;
    uint32 start_blockno;
    uint32 current_blockno;
    uint32 total_blocks;
    uint32 offset_in_parent;
    uint8 dev;
    struct dirent* parent;
    uint32 ref_count;
    uint8 valid;
    struct dirent* prev;
    struct dirent* next;
    sleeplock sleeplock;
}dirent;


#define DIRENT_LIST_LENGTH 32

typedef struct dirent_cache{
    dirent dirent_list[DIRENT_LIST_LENGTH];
    dirent root_dir;
    spinlock spinlock;
}dirent_cache;

extern fat32_mbr mbr_info;
extern fat32_dbr dbr_info;

void fat32_init();
int find_dirent(dirent* des_de, dirent* current_de, char *file_name);

#endif