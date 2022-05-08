#ifndef __FAT32_H
#define __FAT32_H

#include "sleeplock.h"
#include "stat.h"

#define MBR_DPT_OFFSET      0x1c6

#define JMP_CODE_0x0  0xEB
#define JMP_CODE_0x1  0x58
#define JMP_CODE_0x2  0x90



#define ATTR_READ_ONLY      0x01
#define ATTR_HIDDEN         0x02
#define ATTR_SYSTEM         0x04
#define ATTR_VOLUME_ID      0x08
#define ATTR_DIRECTORY      0x10
#define ATTR_ARCHIVE        0x20
#define ATTR_LONG_NAME      0x0F

#define LAST_LONG_ENTRY     0x40
#define FAT32_EOC           0x0ffffff8
#define EMPTY_ENTRY         0xe5
#define END_OF_ENTRY        0x00
#define CHAR_LONG_NAME      13
#define CHAR_SHORT_NAME     11

#define FAT32_MAX_FILENAME  255
#define FAT32_MAX_PATH      260
#define ENTRY_CACHE_NUM     50
/*
//fat32 directory entry
#define SHORT_NAME_LENGTH 8 //短文件名最大长度
#define EXTEND_NAME_LENGTH 3    //短文件名的扩展名最大长度
#define DIR_ENTRY_BYTES 32  //一个目录项占32字节

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
}fat32_dir_entry;

*/



struct dirent {
    char  filename[FAT32_MAX_FILENAME + 1];
    uint8   attribute;
    // uint8   create_time_tenth;
    // uint16  create_time;
    // uint16  create_date;
    // uint16  last_access_date;
    uint32  first_clus;
    // uint16  last_write_time;
    // uint16  last_write_date;
    uint32  file_size;

    uint32  cur_clus;
    uint    clus_cnt;

    /* for OS */
    uint8   dev;
    uint8   dirty;
    short   valid;
    int     ref;
    uint32  off;            // offset in the parent dir entry, for writing convenience
    struct dirent *parent;  // because FAT32 doesn't have such thing like inum, use this for cache trick
    struct dirent *next;
    struct dirent *prev;
    struct sleeplock    lock;
};

int             fat32_init(void);
struct dirent*  dirlookup(struct dirent *entry, char *filename, uint *poff);
char*           formatname(char *name);
void            emake(struct dirent *dp, struct dirent *ep, uint off);
struct dirent*  ealloc(struct dirent *dp, char *name, int attr);
struct dirent*  edup(struct dirent *entry);
void            eupdate(struct dirent *entry);
void            etrunc(struct dirent *entry);
void            eremove(struct dirent *entry);
void            eput(struct dirent *entry);
void            estat(struct dirent *ep, struct stat *st);
void            elock(struct dirent *entry);
void            eunlock(struct dirent *entry);
int             enext(struct dirent *dp, struct dirent *ep, uint off, int *count);
struct dirent*  ename(char *path);
struct dirent*  enameparent(char *path, char *name);
int             eread(struct dirent *entry, int user_dst, uint64 dst, uint off, uint n);
int             ewrite(struct dirent *entry, int user_src, uint64 src, uint off, uint n);

#endif