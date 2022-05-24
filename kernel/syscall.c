#include "include/types.h"
#include "include/process.h"
#include "include/printk.h"
#include "include/syscall.h"
#include "include/vm.h"
#include "include/file.h"
#include "include/fcntl.h"
#include "include/sbi.h"
#include "include/console.h"
#include "include/inode.h"

//系统调用函数声明
uint64 sys_fork();
uint64 sys_read();
uint64 sys_kill();
uint64 sys_open();
uint64 sys_simple_write();
uint64 sys_close();

uint64 sys_simple_read();
uint64 sys_simple_write();

uint64 sys_exit();
uint64 sys_clone();
uint64 sys_execve();
uint64 sys_wait4();
uint64 sys_getppid();
uint64 sys_getpid();
uint64 sys_brk();
uint64 sys_sched_yield();

//将系统调用函数组织为一个函数指针数组
//效仿xv6的设计
static uint64 (*syscalls[])() = {
    [SYS_fork] sys_fork,
    [SYS_read] sys_read,
    [SYS_kill] sys_kill,
    [SYS_open] sys_open,
    [SYS_write] sys_simple_write,
    [SYS_close] sys_close,

    [SYS_simple_read] sys_simple_read,
    [SYS_simple_write] sys_simple_write,

    [SYS_clone] sys_clone,
    [SYS_execve] sys_execve,
    [SYS_wait4] sys_wait4,
    [SYS_exit] sys_exit,
    [SYS_getppid] sys_getppid,
    [SYS_getpid] sys_getpid,
    [SYS_brk] sys_brk,
    [SYS_sched_yield] sys_sched_yield,
};

//syscall，由trap调用至此
//根据寄存器a7中的系统调用号，确定是哪个系统调用
uint64 syscall(){
    int syscall_num=current->trapframe->regs.a7;
    if(syscalls[syscall_num]!=NULL)
        return syscalls[syscall_num]();
    else 
        return -1;
}

//进程复制
uint64 sys_fork(){
    return do_fork(current);
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

//打开一个文件(没有同步控制)
//a0存储文件名的指针,a1存储打开方式(参见fcntl.h)
//返回该文件的文件描述符
uint64 sys_open(){
    //获取参数
    char* file_name=(char*)current->trapframe->regs.a0; //a0存储文件名指针(包含路径)
    file_name=(char*)va_to_pa(current->pagetable, file_name);   //虚拟地址转为物理地址
    int mode=current->trapframe->regs.a1;

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
    return fd;  //返回文件描述符

}

//读取文件中的数据
uint64 sys_read(){
    //获取参数
    int fd=current->trapframe->regs.a0; //a0存储文件描述符
    if(current->open_files[fd]==NULL || 
        !(current->open_files[fd]->attribute & FILE_ATTR_READ)){
        return -1;
    }
    char* buf=(char*)current->trapframe->regs.a1;   //a1为读取的内存位置
    buf=(char*)va_to_pa(current->pagetable,buf);    //虚拟地址转物理地址
    int rsize=current->trapframe->regs.a2;  //a2为希望读取多少字节
    
    rsize=read_file(current->open_files[fd],buf,rsize);     //调用read_file读取
    return rsize;   //返回实际读取的数据
}

//根据pid杀死进程
uint64 sys_kill(){
    uint64 pid=current->trapframe->regs.a0;
    return do_kill(pid);
}

//控制台读，临时写在这里
uint64 sys_simple_read(){
    char* str=(char*)current->trapframe->regs.a1;
    str=(char*)va_to_pa(current->pagetable,str);
    int sz=current->trapframe->regs.a2;
    return read_from_console(str,sz);
}

//一个简单的print系统调用，临时写在这里
uint64 sys_simple_write(){
    if(current->trapframe->regs.a0==8)
        printk("here\n");
    char* str=(char*)current->trapframe->regs.a1;
    str=(char*)va_to_pa(current->pagetable,str);
    int sz=current->trapframe->regs.a2;
    return write_to_console(str,sz);
}

//关闭文件
uint64 sys_close(){
    int fd=current->trapframe->regs.a0; //a0存储文件描述符
    if(current->open_files[fd]==NULL)
        return -1;
    release_file(current->open_files[fd]);  //释放file
    current->open_files[fd]=NULL;
    return 0;
}

uint64 sys_clone(){
    uint64 flag=current->trapframe->regs.a0;
    uint64 stack=current->trapframe->regs.a1;
    return do_clone(current,flag,stack);
}

//execve系统调用
uint64 sys_execve(){
    //a0存储可执行文件名指针(包含路径)
    char *file_name=(char*)current->trapframe->regs.a0;
    file_name=va_to_pa(current->pagetable,file_name);   //虚拟地址转换为物理地址
    
    //a1存储argv地址
    char **user_argv=(char**)current->trapframe->regs.a1;
    char *argv[MAXARG+1];
    if(user_argv!=NULL){
        user_argv=va_to_pa(current->pagetable,user_argv);      //虚拟地址转换为物理地址
        int argc;
        for(argc=0;user_argv[argc]!=NULL && argc<MAXARG;argc++){
            argv[argc]=va_to_pa(current->pagetable,user_argv[argc]);    //虚拟地址转换为物理地址
        }
        argv[argc]=NULL;
    }
    char **av=user_argv!=NULL?argv:NULL;

    //a2存储env地址
    char **user_env=(char**)current->trapframe->regs.a2;
    char *env[MAXENV+1];
    if(user_env!=NULL){
        user_env=va_to_pa(current->pagetable,user_env);     //虚拟地址转换为物理地址
        int envc;
        for(envc=0;user_env[envc]!=NULL && envc<MAXENV;envc++){
            env[envc]=va_to_pa(current->pagetable,user_env[envc]);      //虚拟地址转换为物理地址
        }
        env[envc]=NULL;
    }
    char **ev=user_env!=NULL?env:NULL;

    return do_execve(file_name,av,ev);    //调用do_execve
}

//父进程等待子进程结束
uint64 sys_wait4(){
    int pid=(int)current->trapframe->regs.a0;
    int* status=(int*)current->trapframe->regs.a1;
    status=va_to_pa(current->pagetable,status);
    uint64 options=current->trapframe->regs.a2;
    return do_wait4(pid,status,options);
}

//进程退出
uint64 sys_exit(){
    int xstate=current->trapframe->regs.a0;
    return do_exit(xstate);
}

//获取父进程pid
uint64 sys_getppid(){
    if(current->parent!=NULL)
        return current->parent->pid;
    else{
        printk("process has no parent!\n");
        return 0;
    }
}

//获取进程pid
uint64 sys_getpid(){
    return current->pid;
}

//改变进程堆内存大小
//当addr为0时，返回当前进程大小
uint64 sys_brk(){
    uint64 addr=current->trapframe->regs.a0;
    return do_brk(current,addr);
}

//进程放弃CPU
uint64 sys_sched_yield(){
    do_yield();
    return 0;
}
