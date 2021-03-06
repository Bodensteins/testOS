#ifndef _FAT32_H_
#define _FAT32_H_

#include "types.h"
#include "sleeplock.h"

#ifndef BSIZE
#define BSIZE 512
#endif

/*
fat32文件系统相关
fat32.c依赖于buffer.c中的函数
*/

/*
文件系统相关依赖为：
syscall.c-->file.c-->vfs_inode.c-->fat32.c-->buffer.c-->sd/sdcard.c(k210官方的sd卡驱动)-->底层驱动
*/

#define FAT_CLUSTER_END 0x0fffffff    //fat表中，如果该簇为文件最后一个簇，则其在fat中的表项为0x0fffffff
#define FAT_CLUSTER_DAMAGE 0xffffff7  //如果该簇损坏，则其在fat中的表项为0xffffff7

//MBR中各种字段在MBR扇区中的偏移，详情参考fat32格式
#define MBR_DBR_ACTIVE 0x1BE
#define MBR_DBR_START_SECTOR_OFFSET 0x1C6   
#define MBR_TOTAL_SECORS_OFFSET 0x1CA

//mbr字段,建议用于索引
typedef struct fat32_mbr_dpt{
    uint8  active;                //* 分区有效标志  有效为0x80 无效为 0x00
    uint8  start_head;
    uint16 star_cyl_sect;
    uint8  part_type;        // 0x0B CHS 格式   0x0C LBA格式
    uint8  end_head;
    uint16 end_cyl_sect;
    uint32 start_lba;     //* 分区的第一个扇区，DBR的开始扇区
    uint32 size;   //* 总扇区数
} __attribute__((packed, aligned(4))) fat32_mbr_dpt;

//DBR中各种字段在DBR扇区中的偏移，详情参考fat32格式
#define DBR_JMP_CODE            0x0
#define DBR_BYTES_PER_SECTOR_OFFSET 0x0B
#define DBR_SECTORS_PER_CLUSTER_OFFSET 0x0D
#define DBR_RESERVE_SECTORS_OFFSET 0x0E
#define DBR_TOTAL_FATS_OFFSET 0x10
#define DBR_HIDDEN_SECTORS_OFFSET 0x1C
#define DBR_FS_TOTAL_SECTORS_OFFSET 0x20
#define DBR_SECTORS_PER_FAT_OFFSET 0x24
#define DBR_ROOT_DIR_CLUSTER_OFFSET 0x2C
#define DBR_FSINFO_SECTOR_OFFSET 0x30
#define DBR_BACKUP_SECTOR_OFFSET 0x32

//dbr字段信息

#define JMP_CODE_0x0  0xEB
#define JMP_CODE_0x1  0x58
#define JMP_CODE_0x2  0x90

/*-------------------------unused  start-------------------------*/
#define FAT32_DBR_BPB_OFFSET  0x0B
//DBR_BPB字段,建议用于索引
typedef struct fat32_dbr_bpb{
    uint16 bytes_per_sec;  //*每扇区字节数     512
    uint8 sec_per_clus;   //*每簇扇区数        8、16、32、64
    uint16 reserved_sec_cnt;   //* 保留扇区数      32
    uint8 fat_cnt;    //* FAT表数           2
    uint16 root_ent_cnt; //                  0
    uint16 to_sec_16;    //                  0
    uint8 medial;
    uint16 fat_sz_16;    //                  0
    uint16 sec_per_trk;  //磁道扇区数
    uint16 num_heads;
    uint32 hidd_sec;   // 隐藏扇区数
    uint32 tot_sec_32;  //*总扇区数
    uint32 fat_sz_32;  //* 一个FAT表扇区数
    uint16 ext_flags;
    uint16 fsver;
    uint32 root_clus; //* 第一个目录的簇号      2
    uint16 fs_info;   // 文件系统信息扇区       1
    uint16 bk_boot_sec; //备份引导扇区          6

    uint64 reserved_0_7; // 12字节
    uint32 reserved_8_11;

    uint8 drv_num;
    uint8 reserved1;
    uint8 boot_sig;
    uint32 vol_id;    // 卷序列号
    
    uint64 file_sys_type_0_7; // 11字节
    uint16 file_sys_type_8_9;
    uint8 file_sys_type_10;

    uint64 file_sys_type1;

}__attribute__((packed, aligned(4)))fat32_dbr_bpb;


// 建议用于存储关键信息
typedef struct fat32_mbr_dbr_info{
    uint32 bpb_sector_no; // （DBR）BPB 所在扇区号  fat32_mbr_dpt.start_lba
    double total_size_mb; //总容量MB(fat32_mbr_dpt.Size)*(fat32_dbr_bpb.bytes_per_sec)/(1024*1024)
    
    uint16 bytes_per_sector; //每个扇区的字节数 fat32_dbr_bpb.bytes_per_sec
    uint8  sectors_per_clus;  // 每簇扇区数       fat32_dbr_bpb.sec_per_clus

    uint8  fat_num;         // FAT表数量
    uint32 fat_sectors;    // FAT表占用的扇区数 FAT32_DBR_BPB.fat_sz_32

    uint32 first_dir_clust; // 第一个目录所在的簇 FAT32_DBR_BPB.RootClus，数据区按簇访问
    uint32 first_fat_sector;// 第一个FAT表扇区号 bpb_sector_no + FAT32_DBR_BPB.reserved_sec_cnt
    uint32 second_fat_sector;// 第二个FAT表扇区号 FirstFATSector + FATsectors
    uint32 data_area_sector;  // 数据区起始扇区号
    uint32 first_dir_sector;// 第一个目录的扇区号 FirstFATSector + FATNum * FATsectors
}__attribute__((packed, aligned(4))) fat32_mbr_dbr_info;

//fat32_mbr_dbr_info fat32_mbr_dbr_info;


//数据区 簇号转扇区号 
#define Block2Sector(a)  ((a)-2) // to do

//FAT 簇号确认在FAT中的偏移
#define Block2offinFAT(a) (a)*4  // to do


/*-------------------------unused  end  -------------------------*/


typedef struct fat32_dbr{
    uint16 bytes_per_sector;    //每扇区字节数
    uint8 sectors_per_cluster;    //每簇扇区数
    uint16 dbr_reserve_sectors;    //dbr保留的扇区数(根据该字段和mbr中dbr_start_sector字段可定位到fat表在磁盘中的位置)
    uint8 total_fats;   //fat表数量，一般是2个
    uint32 hidden_sectors;      //隐藏扇区个数，与mbr中0x01C6的4字节相同
    uint32 fs_total_sectors;    //文件系统总扇区数
    uint32 sectors_per_fat;     //每个fat表占用的扇区数
    uint32 root_dir_clusterno;    //根目录所在的第一个簇的簇号，一般是2号簇
    uint16 fsinfo_sector;   //文件系统信息扇区的扇区号
    uint16 dbr_backup_sector;   //dbr备份扇区的扇区号
}fat32_dbr;


//FSINFO
#define FSINFO_FS_TOTAL_EMPTY_CLUSTERS_OFFSET 0x1E8
#define FSINFO_NEXT_USABLE_CLUSTER_OFFSET 0x1EC

//这个目前还没什么用
typedef struct fat32_fsinfo{
    uint32 fs_total_empty_clusters;
    uint32 next_usable_cluster;
}fat32_fsinfo;


//fat32 directory entry
#define SHORT_NAME_LENGTH 8 //短文件名最大长度
#define EXTEND_NAME_LENGTH 3    //短文件名的扩展名最大长度
#define DIR_ENTRY_BYTES 32  //一个目录项占32字节

//目录项属性，参见fat32目录项属性格式
#define ATTR_READ_ONLY      0x01
#define ATTR_HIDDEN         0x02
#define ATTR_SYSTEM         0x04
#define ATTR_VOLUME_ID      0x08
#define ATTR_DIRECTORY      0x10
#define ATTR_ARCHIVE        0x20
#define ATTR_LONG_NAME      0x0F
#define LAST_LONG_ENTRY     0x40


//短文件名目录项中几个字段的偏移
#define SHORT_DENTRY_ATRRIBUTE_OFFSET 0xB
#define SHORT_DENTRY_START_CLUSTERNO_HIGH_OFFSET 0x14
#define SHORT_DENTRY_START_CLUSTERNO_LOW_OFFSET 0x1A
#define SHORT_DENTRY_FILE_SIZE_OFFSET 0x1C

//fat32目录项格式

/*
关于fat32目录项，需要说明的是:
对于fat32_dir_entry，无论是fat32_short_name_dir_entry，还是fat32_long_name_dir_entry
他们都是目录项存储在磁盘上的格式，并不适合直接拿来给OS使用
因此我们需要对其进行一些转换，使其更适合OS使用
于是就有了fat32_dirent,这个结构是直接拿给OS使用的
从磁盘中读取目录项后，都要立刻转换为fat32_dirent
同样，之后要修改目录项信息，也需要将fat32_dirent转换为fat32_dir_entry后再写入
*/


//fat32短文件名目录项
//具体参见fat32目录项格式
typedef struct fat32_short_name_dir_entry{
    char name[SHORT_NAME_LENGTH];
    char extend_name[EXTEND_NAME_LENGTH];
    uint8 atrribute;   // 文件属性
    uint8 system_reserve;
    uint8 create_time_tenth_msec;
    uint16 create_time;
    uint16 create_date;
    uint16 last_access_date;
    uint16 start_clusterno_high;
    uint16 last_write_time;
    uint16 last_write_date;
    uint16 start_clusterno_low;
    uint32 file_size;
}__attribute__((packed, aligned(4))) fat32_short_name_dir_entry;

//fat32长文件名目录项
//具体参见fat32目录项格式
typedef struct fat32_long_name_dir_entry{
    uint8 atrribute;
    char name1[10];
    uint8 symbol;   // 0x0F
    uint8 system_reserve; // 0x00
    uint8 verify_value;
    char name2[12];
    uint16 start_cluster;// 0x00 0x00 
    char name3[4];
}__attribute__((packed, aligned(4))) fat32_long_name_dir_entry;

typedef struct fat32_dir_entry{
    fat32_short_name_dir_entry short_name_dentry;
    fat32_long_name_dir_entry long_name_dentry[5];
    int long_dir_entry_num;
    uint32 longname_dirent_clusterno_in_parent;
    uint32 longname_dirent_offset_in_parent;
}fat32_dir_entry;

#define FILE_NAME_LENGTH 64

//将fat32_dir_entry整理后，得到以下的fat32_dirent
typedef struct fat32_dirent{
    char name[FILE_NAME_LENGTH+1];  //文件名(包括扩展名)
    uint8 attribute;    //文件属性
    uint32 file_size;   //文件大小
    uint32 start_clusterno;   //文件起始簇号
    //uint32 current_clusterno;  
    uint32 i_ino;
    uint32 total_clusters;    //文件总共簇数
    uint32 clusterno_in_parent;   //文件目录项在父目录中的簇位置
    uint32 offset_in_parent;    //文件目录项在父目录簇中的偏移
    uint32 longname_dirent_clusterno_in_parent;   //长文件目录项在父目录中的簇位置
    uint32 longname_dirent_offset_in_parent; //长文件目录项在父目录簇中的偏移
    uint8  longname_entry_num;
    uint8 dev;  //设备号(一般是0，表示sd卡)
    struct fat32_dirent* parent;    //父目录的目录项
    uint32 ref_count;   //该目录项的引用数量
    uint8 valid;    //是否有效
    uint8 dirty;    //脏位，表示缓冲区中目录项的内容和磁盘中的是否一致，即目录项更新是否有写入磁盘(0为一致，否则不一致)
    uint8 del;   //删除标志
    struct fat32_dirent* prev;  //在LRU双向循环链表中，指向该目录项的上一个链表节点
    struct fat32_dirent* next;  //在LRU双向循环链表中，指向该目录项的下一个链表节点
    sleeplock sleeplock;    //睡眠锁
}fat32_dirent;


#define DIRENT_LIST_LENGTH 256

/*
fat32_dirent缓存，其管理思路与缓冲区管理类似，采用LRU算法，组织为双向缓冲链表，不再赘述
将根目录作为表头
*/

typedef struct fat32_dirent_cache{
    fat32_dirent dirent_list[DIRENT_LIST_LENGTH];   //fat32_dirent列表
    fat32_dirent root_dir;  //根目录，同时也是链表表头
    spinlock spinlock;  //自旋锁
}fat32_dirent_cache;

extern fat32_mbr_dpt mbr_info;
extern fat32_dbr dbr_info;

fat32_dirent*  fat32_init();  //fat32初始化，OS启动时调用
fat32_dirent* find_dirent(fat32_dirent* current_de, char *file_name);   //根据当前目录的目录项和文件路径名寻找文件目录项
fat32_dirent* find_dirent_with_create(fat32_dirent* current_de, char *file_name, int is_create, int attribute);
void release_dirent(fat32_dirent* de); //释放一个目录项
int read_by_dirent(fat32_dirent *de, void *dst, uint offset, uint rsize);   //根据文件的目录项，偏移，读取数据的大小，将数据读入指定位置
int write_by_dirent(fat32_dirent *de, void *src, uint offset, uint wsize);  //根据文件的目录项，偏移，写入数据的大小，将指定位置数据写入文件
int write_by_dirent2(fat32_dirent *de, void *src, uint offset,  uint wsize);
void trunc_by_dirent(fat32_dirent *de); //根据文件的目录项，释放文件占用的所有簇
fat32_dirent* dirent_dup(fat32_dirent *de); //增加一个目录项的引用
int create_by_dirent(fat32_dirent *parent,char * name, uint8 attribute);
int delete_by_dirent(fat32_dirent *file_to_delete);
uint32 calc_dir_file_size(fat32_dirent *root_dir);
//uint32 fat_find_next_clusterno(uint32 clusterno, uint32 fatno);//寻找簇列表中下一个簇
#endif