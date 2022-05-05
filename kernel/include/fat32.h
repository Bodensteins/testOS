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
    syscall.c-->file.c-->fat32.c-->buffer.c-->sd/sdcard.c(k210官方的sd卡驱动)-->底层驱动
*/

#define FAT_CLUSTER_END 0x0fffffff    //fat表中，如果该簇为文件最后一个簇，则其在fat中的表项为0x0fffffff
#define FAT_CLUSTER_DAMAGE 0xffffff7  //如果该簇损坏，则其在fat中的表项为0xffffff7

//MBR中各种字段在MBR扇区中的偏移，详情参考fat32格式
#define MBR_DBR_START_SECTOR_OFFSET 0x1C6   
#define MBR_TOTAL_SECORS_OFFSET 0x1CA

//mbr字段信息
typedef struct fat32_mbr{
    uint32 dbr_start_sector;     //从磁盘开始到分区开始的偏移量(根据该字段找到存储dbr的扇区)
    uint32 total_sectors;   //总扇区数
}fat32_mbr;

//DBR中各种字段在DBR扇区中的偏移，详情参考fat32格式
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
#define SHORT_DENTRY_START_clusterNO_HIGH_OFFSET 0x14
#define SHORT_DENTRY_START_clusterNO_LOW_OFFSET 0x1A
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
    uint8 atrribute;
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
    uint8 symbol;
    uint8 system_reserve;
    uint8 verify_value;
    char name2[12];
    uint16 start_cluster;
    char name3[4];
}__attribute__((packed, aligned(4))) fat32_long_name_dir_entry;

typedef union fat32_dir_entry{
    fat32_short_name_dir_entry short_name_dentry;
    fat32_long_name_dir_entry long_name_dentry;
}fat32_dir_entry;

#define FILE_NAME_LENGTH 64

//将fat32_dir_entry整理后，得到以下的fat32_dirent
typedef struct fat32_dirent{
    char name[FILE_NAME_LENGTH+1];  //文件名(包括扩展名)
    uint8 attribute;    //文件属性
    uint32 file_size;   //文件大小
    uint32 start_clusterno;   //文件起始扇区号
    //uint32 current_clusterno;  
    uint32 total_clusters;    //文件总共扇区号
    uint32 offset_in_parent;    //文件目录项在父目录中的偏移
    uint8 dev;  //设备号(一般是0，表示sd卡)
    struct fat32_dirent* parent;    //父目录的目录项
    uint32 ref_count;   //该目录项的引用数量
    uint8 valid;    //是否有效
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

extern fat32_mbr mbr_info;
extern fat32_dbr dbr_info;

void fat32_init();  //fat32初始化，OS启动时调用
fat32_dirent* find_dirent(fat32_dirent* current_de, char *file_name);   //根据当前目录的目录项和文件路径名寻找文件目录项
void release_dirent(fat32_dirent* dir); //释放一个目录项
int read_by_dirent(fat32_dirent *de, void *dst, uint offset, uint rsize);   //根据文件的目录项，偏移，读取数据的大小，将数据读入指定位置
int write_by_dirent(fat32_dirent *de, void *src, uint offset, uint wsize);  //根据文件的目录项，偏移，写入数据的大小，将指定位置数据写入文件
fat32_dirent* dirent_dup(fat32_dirent *de); //增加一个目录项的引用

#endif