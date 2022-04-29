#include "include/types.h"
#include "include/process.h"
#include "include/printk.h"
#include "include/syscall.h"
#include "include/vm.h"
#include "include/file.h"
#include "include/fcntl.h"
#include "include/sbi.h"

extern trapframe temp[];

uint64 sys_fork();
uint64 sys_exit();
uint64 sys_read();
uint64 sys_kill();
uint64 sys_open();
uint64 sys_simple_write();
uint64 sys_close();
uint64 sys_exec();

static uint64 (*syscalls[])() = {
    [SYS_fork] sys_fork,
    [SYS_exit] sys_exit,
    [SYS_read] sys_read,
    [SYS_kill] sys_kill,
    [SYS_exec] sys_exec,
    [SYS_open] sys_open,
    [SYS_write] sys_simple_write,
    [SYS_close] sys_close,
};

uint64 syscall(){
    int syscall_num=current->trapframe->regs.a7;
    if(syscalls[syscall_num]!=NULL)
        return syscalls[syscall_num]();
    else 
        return -1;
}

uint64 sys_fork(){
    return do_fork(current);
}

uint64 sys_exit(){
    int code=current->trapframe->regs.a0;
    if(current->pid==1)
        sbi_shutdown();
    free_process(current);
    return code;
}

static int acquire_fd(process* proc, file *file){
    int fd;
    for(fd=3;fd<N_OPEN_FILE;fd++){
        if(proc->open_files[fd]==NULL){
            proc->open_files[fd]=file;
            return fd;
        }
    }
    return -1;
}

//to do(lock)
uint64 sys_open(){
    char* file_name=(char*)current->trapframe->regs.a0;
    file_name=(char*)va_to_pa(current->pagetable, file_name);
    int mode=current->trapframe->regs.a1;

    dirent* de=find_dirent(current->cwd, file_name);
    if(de==NULL)
        return -1;
    //lock
    if((de->attribute & ATTR_DIRECTORY) && !(mode & O_RDONLY)){
        //unlock
        return -1;
    }
    
    file* file=acquire_file();
    if(file==NULL){
        //unlock
        return -1;
    }

    int fd=acquire_fd(current, file);
    if(fd<0){
        release_file(file);
        //unlock
        return -1;
    }
    
    file->dirent=de;
    file->dev=de->dev;
    file->offset=(mode & O_APPEND)?de->file_size:0;
    file->type=FILE_TYPE_FS;

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

uint64 sys_read(){
    int fd=current->trapframe->regs.a0;
    if(current->open_files[fd]==NULL || 
        !(current->open_files[fd]->attribute & FILE_ATTR_READ)){
        return -1;
    }
    char* buf=(char*)current->trapframe->regs.a1;
    buf=(char*)va_to_pa(current->pagetable,buf);
    int rsize=current->trapframe->regs.a2;
    
    rsize=read_file(current->open_files[fd],buf,rsize);
    return rsize;
}

uint64 sys_kill(){
    uint64 pid=current->trapframe->regs.a0;
    return do_kill(pid);
}

//void exec_test(char *file_name);
uint64 sys_exec(){
    char *file_name=(char*)current->trapframe->regs.a0;
    file_name=va_to_pa(current->pagetable,file_name);
    do_exec(file_name,NULL);
    return 0;
}

uint64 sys_simple_write(){
    char* str=(char*)current->trapframe->regs.a0;
    str=(char*)va_to_pa(current->pagetable,str);
    printk(str);
    return current->trapframe->regs.a1;
}

uint64 sys_close(){
    int fd=current->trapframe->regs.a0;
    if(current->open_files[fd]==NULL)
        return -1;
    release_file(current->open_files[fd]);
    current->open_files[fd]=NULL;
    return 0;
}