#ifndef _FILE_H_
#define _FILE_H_

#include "types.h"
#include "fat32.h"
#include "pipe.h"

/*
文件结构
file.c依赖于fat32.c中的函数
*/

/*
文件系统相关依赖为：
    syscall.c-->file.c-->fat32.c-->buffer.c-->sd/sdcard.c(k210官方的sd卡驱动)-->底层驱动
*/

//文件类型
#define FILE_TYPE_NONE 0x0  //不存在
#define FILE_TYPE_SD 0x1    //SD卡类型
#define FILE_TYPE_DEVICE 0x2    //设备类型
#define FILE_TYPE_PIPE 0x4  //管道类型

//文件属性
#define FILE_ATTR_READ 0x1  //可读
#define FILE_ATTR_WRITE 0x2 //可写
#define FILE_ATTR_EXEC 0x4  //可执行
#define FILE_ATTR_DIR 0x8 //目录

#define AT_FDCWD -100

//文件结构体
typedef struct file{
    int type;   //文件类型
    fat32_dirent *fat32_dirent; //文件目录项
    //pipe *pipe;
    int attribute; //属性
    int dev;    //设备号
    pipe *pipe;  //管道
    int ref_count;  //文件被引用数量
    //to do
    uint32 offset;  //文件当前的偏移量
}file;

#define NFILE 128   //OS允许的文件打开数量上限   

//所有打开的文件的列表，由OS维护
typedef struct file_table{
    spinlock spinlock;  //自旋锁
    file file[NFILE];   //打开的文件列表
}file_table;

typedef struct dirent{
    uint64 d_ino;	// 索引结点号
    uint64 d_off;	// 到下一个dirent的偏移
    unsigned short d_reclen;	// 当前dirent的长度
    unsigned char d_type;	// 文件类型
    char d_name[FILE_NAME_LENGTH];	//文件名
}dirent;

typedef struct kstat{
    uint64    dev;
	uint64    ino;
	uint32    mode;
	uint32    nlink;
	uint32    uid;
	uint32    gid;
	uint64    rdev;
	uint64    __pad;
	uint64    size;
	uint32    blksize;
	int       __pad2;
	uint64    blocks;
	long      atime_sec;
	long      atime_nsec;
	long      mtime_sec;
	long      mtime_nsec;
	long      ctime_sec;
	long      ctime_nsec;
	uint32    __unused[2];
}kstat;

typedef struct dent{
    uint64 d_ino;	// 索引结点号
    uint64 d_off;	// 到下一个dirent的偏移
    unsigned short d_reclen;	// 当前dirent的长度
    unsigned char d_type;	// 文件类型
    char d_name[FILE_NAME_LENGTH];	//文件名
}dent;

extern file_table ftable;

void file_init();   //文件结构体和文件列表初始化
file *acquire_file();   //获取一个文件列表中的文件结构体
void release_file(file *file);  //释放一个文件结构体
int read_file(file *file, void *buf, uint rsize);   //根据文件结构体，读取rsize个字节到buf
int write_file(file *file, void *buf, uint wsize);  //根据文件结构体，写wsize个字节到buf
file* file_dup(file* file); //将file中的ref_count自加
int do_openat(int fd, char *file_name, int mode);
int do_close(int fd);
int do_mkdirat(int fd, char *path);
int do_chdir(char *path);
char* do_getcwd(char *buf, int sz);
int do_dup(process *proc, int fd);
int do_dup3(process *proc, int old, int new);
int do_fstat(int fd, kstat *kstat);
int do_getdents(int fd, char *buf, int len);
int do_unlinkat(int dir_fd, char *path, int flags);

#endif