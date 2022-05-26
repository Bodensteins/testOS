#include "include/file.h"
#include "include/printk.h"
#include "include/sleeplock.h"
#include "include/string.h"
#include "include/process.h"
#include "include/inode.h"
#include "include/fcntl.h"
#include "include/device.h"

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
    if(file==NULL || buf==NULL || !(file->attribute & FILE_ATTR_READ))
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
            if(dev_list[file->dev].read==NULL)
                return -1;
            dev_list[file->dev].read(buf,rsize);
            break;
        case FILE_TYPE_PIPE:
            //to do
            break;
        default:
            return -1;
            break;
    }

    return rsize;
}

//根据文件结构体，写wsize个字节到buf
int write_file(file *file, void *buf, uint wsize){
    if(file==NULL || buf==NULL || !(file->attribute & FILE_ATTR_WRITE))
        return -1;

    switch(file->type){ //目前只有SD卡上的文件
        case FILE_TYPE_SD:
            //acquire_sleeplock(&file->fat32_dirent->sleeplock);
            wsize=write_by_dirent_i(file->fat32_dirent,buf,file->offset,wsize);
            if(wsize>0)
                file->offset=file->fat32_dirent->file_size;    //更新offset
            //release_sleeplock(&file->fat32_dirent->sleeplock);
            break;
        case FILE_TYPE_DEVICE:
            if(dev_list[file->dev].write==NULL)
                return -1;
            dev_list[file->dev].write(buf,wsize);
            break;
        case FILE_TYPE_PIPE:
            //to do
            break;
        default:
            return -1;
            break;
    }
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

//工具函数，获取proc进程中一个空闲的文件描述符(文件句柄)
//一般来说，0对应标准输入(stdin)，1对应标准输出(stdout)，2对应标准错误输出(stderr)
static int acquire_fd(process* proc, file *file){
    int fd;
    for(fd=0;fd<N_OPEN_FILE;fd++){
        if(proc->open_files[fd]==NULL){
            proc->open_files[fd]=file;
            return fd;
        }
    }
    return -1;
}

int do_openat(int fd, char *file_name, int flag){
    if(file_name==NULL)
        return -1;

    if(strncmp(file_name,"/dev",4)==0){
        file *f=open_device(file_name);
        if(f==NULL)
            return -1;
        int fd=acquire_fd(current, f);
        if(fd==-1){
            release_file(f);
            return -1;
        }
        return fd;
    }

    fat32_dirent* dir;
    if(fd>0 && fd<N_OPEN_FILE)
        dir=current->open_files[fd]->fat32_dirent;
    else if(fd==AT_FDCWD || *file_name=='/')
        dir=current->cwd;
    else 
        return -1;

    //在指定目录搜索文件目录项
    fat32_dirent* de=find_dirent_i(dir, file_name);
    if(de==NULL){   //没找到
        if(flag & O_CREATE){
            //to do
            //int ret=create_by_dirent(dir,file_name,);
            //
        }
        else
            return -1;
    }

    
    //lock
    //获取OS维护的打开文件列表中的一个空闲列表项
    file* file=acquire_file();  
    if(file==NULL){
        //unlock
        release_dirent_i(de);
        return -1;
    }

    //获取一个新的文件描述符
    int fd=acquire_fd(current, file);
    if(fd<0){   //如果获取失败
        release_file(file); //关闭file，返回-1
        release_dirent_i(de);
        //unlock
        return -1;
    }
    
    //为file赋予打开文件的各种信息
    file->fat32_dirent=de;  
    file->dev=de->dev;
    file->offset=(flag & O_APPEND)?de->file_size:0;
    file->type=FILE_TYPE_SD;

    //文件属性
    if(flag & O_RDWR)
        file->attribute |= (FILE_ATTR_READ | FILE_ATTR_WRITE);
    else {
        if(flag & O_RDONLY)
            file->attribute |= FILE_ATTR_READ;
        if(flag & O_WRONLY)
            file->attribute |= FILE_ATTR_WRITE;
    }
    if(flag & O_DIRECTORY){
        file->attribute |= FILE_ATTR_DIR;
        file->attribute &= ~(FILE_ATTR_WRITE);
    }

    file->attribute |= FILE_ATTR_READ;

    //unlock
    return fd;
}

int do_dup(process *proc, int fd){
    if(fd<0 || fd>N_OPEN_FILE)
        return -1;
    file *f=proc->open_files[fd];
    if(f==NULL)
        return -1;
    int new_fd=acquire_fd(proc,f);
    file_dup(f);
    return new_fd;
}

int do_dup3(process *proc, int old, int new){
    if(old<0 || old>N_OPEN_FILE || new<0 || new>N_OPEN_FILE)
        return -1;
    file *f=proc->open_files[old];
    if(f==NULL)
        return -1;
    proc->open_files[new]=proc->open_files[old];
    file_dup(f);
    return new;
}