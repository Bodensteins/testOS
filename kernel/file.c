#include "include/file.h"
#include "include/printk.h"
#include "include/sleeplock.h"
#include "include/string.h"
#include "include/process.h"
#include "include/inode.h"
#include "include/fcntl.h"

/*
文件系统相关依赖为：
    syscall.c-->file.c-->fat32.c-->buffer.c-->sd/sdcard.c(k210官方的sd卡驱动)-->底层驱动
*/

//OS维护的文件列表
file_table ftable;

//文件列表初始化
void file_init(){
    init_spinlock(&ftable.spinlock,"file table");
    for(int i=0;i<NFILE;i++){
        memset(ftable.file+i,0,sizeof(file));
    }
}

//获取文件列表中的一个空闲的文件列表项
//一般是由系统调用函数使用
file *acquire_file(){
    acquire_spinlock(&ftable.spinlock);
    for(int i=0;i<NFILE;i++){
        if(ftable.file[i].ref_count==0){
            ftable.file[i].ref_count++;
            release_spinlock(&ftable.spinlock);
            return ftable.file+i;
        }
    }
    release_spinlock(&ftable.spinlock);
    return NULL;
}

//释放一个文件列表的表项
void release_file(file *file){
    acquire_spinlock(&ftable.spinlock);
    if(file->ref_count>1){
        file->ref_count--;
        release_spinlock(&ftable.spinlock);
        return;
    }
    else{   //目前只有SD卡上的文件
        switch(file->type){
            case FILE_TYPE_SD:
                release_dirent_i(file->fat32_dirent);
                break;
            case FILE_TYPE_DEVICE:
                //to do
                break;
            case FILE_TYPE_PIPE:
                //to do
                break;
            default:
                panic("release_file");
                break;
        }
        file->ref_count--;
        file->type=FILE_TYPE_NONE;
    }
    release_spinlock(&ftable.spinlock);
}

//根据一个文件表项(file结构体)读取数据
//rsize为读取数据的大小
//buf为读取数据的目的地
//其读取的数据在文件中的位置还取决于file中的offset字段
//读取后将file->offset更新至读完之后的位置
int read_file(file *file, void *buf, uint rsize){
    if(file==NULL || buf==NULL)
        return -1;

    switch(file->type){ //目前只有SD卡上的文件
        case FILE_TYPE_SD:
            //acquire_sleeplock(&file->fat32_dirent->sleeplock);
            rsize=read_by_dirent_i(file->fat32_dirent,buf,file->offset,rsize);
            if(rsize>0)
                file->offset+=rsize;    //更新offset
            //release_sleeplock(&file->fat32_dirent->sleeplock);
            break;
        case FILE_TYPE_DEVICE:
            //to do
            break;
        case FILE_TYPE_PIPE:
            //to do
            break;
        default:
            panic("read_file");
            break;
    }

    return rsize;
}

//根据文件结构体，写wsize个字节到buf
int write_file(file *file, void *buf, uint wsize){
    //to do
    return wsize;
}

//自加file结构体中的ref_count
//表示增加一个对该file的引用
file* file_dup(file* file){
    //acquire_spinlock(&ftable.spinlock);
    file->ref_count++;
    //release_spinlock(&ftable.spinlock);
    return file;
}

int do_open(char *file_name, int mode){
    //在当前工作目录搜索文件目录项
    fat32_dirent* de=find_dirent_i(current->cwd, file_name);
    if(de==NULL)    //没找到，返回-1
        return -1;
    //lock
    if((de->attribute & ATTR_DIRECTORY) && !(mode & O_RDONLY)){ //文件是目录，或不能读，返回-1
        //unlock
        return -1;
    }
    
    //获取OS维护的打开文件列表中的一个空闲列表项
    file* file=acquire_file();  
    if(file==NULL){
        //unlock
        return -1;
    }

    //获取一个新的文件描述符
    int fd=acquire_fd(current, file);
    if(fd<0){   //如果获取失败
        release_file(file); //关闭file，返回-1
        //unlock
        return -1;
    }
    
    //为file赋予打开文件的各种信息
    file->fat32_dirent=de;  
    file->dev=de->dev;
    file->offset=(mode & O_APPEND)?de->file_size:0;
    file->type=FILE_TYPE_SD;

    //文件属性
    if(mode & O_RDWR)
        file->attribute |= (FILE_ATTR_READ | FILE_ATTR_WRITE);
    else {
        if(mode & O_RDONLY)
            file->attribute |= FILE_ATTR_READ;
        if(mode & O_WRONLY)
            file->attribute |= FILE_ATTR_WRITE;
    }
    //unlock
    return fd;
}