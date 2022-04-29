#include "include/file.h"
#include "include/printk.h"
#include "include/sleeplock.h"
#include "include/string.h"
#include "include/process.h"

file_table ftable;

void file_init(){
    init_spinlock(&ftable.spinlock,"file table");
    for(int i=0;i<NFILE;i++){
        memset(ftable.file+i,0,sizeof(file));
    }
}

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

void release_file(file *file){
    acquire_spinlock(&ftable.spinlock);
    if(file->ref_count>1){
        file->ref_count--;
        release_spinlock(&ftable.spinlock);
        return;
    }
    else{
        switch(file->type){
            case FILE_TYPE_FS:
                release_dirent(file->dirent);
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

int read_file(file *file, void *buf, uint rsize){
    if(file==NULL || buf==NULL)
        return -1;

    switch(file->type){
        case FILE_TYPE_FS:
            //acquire_sleeplock(&file->dirent->sleeplock);
            rsize=read_by_dirent(file->dirent,buf,file->offset,rsize);
            if(rsize>0)
                file->offset+=rsize;
            //release_sleeplock(&file->dirent->sleeplock);
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

int write_file(file *file, void *buf, uint wsize){
    //to do
    return wsize;
}

file* file_dup(file* file){
    //acquire_spinlock(&ftable.spinlock);
    file->ref_count++;
    //release_spinlock(&ftable.spinlock);
    return file;
}