#include "include/types.h"
#include "include/process.h"
#include "include/printk.h"
#include "include/syscall.h"
#include "include/vm.h"
#include "include/file.h"
#include "include/sbi.h"
#include "include/systime.h"
#include "include/console.h"
#include "include/systime.h"
#include "include/string.h"
#include "include/inode.h"
#include "include/device.h"

//系统调用函数声明
uint64 sys_fork();
uint64 sys_kill();


uint64 sys_simple_read();
uint64 sys_simple_write();

uint64 sys_openat();
uint64 sys_read();
uint64 sys_write();
uint64 sys_close();
uint64 sys_pipe2();
uint64 sys_mkdirat();
uint64 sys_chdir();
uint64 sys_dup();
uint64 sys_dup3();
uint64 sys_exit();
uint64 sys_mount();
uint64 sys_umount();
uint64 sys_unlinkat();
uint64 sys_getcwd();
uint64 sys_getdents();
uint64 sys_fstat();
uint64 sys_clone();
uint64 sys_execve();
uint64 sys_wait4();
uint64 sys_getppid();
uint64 sys_getpid();
uint64 sys_brk();
uint64 sys_mmap();
uint64 sys_munmap();
uint64 sys_times();
uint64 sys_uname();
uint64 sys_sched_yield();
uint64 sys_gettimeofday();
uint64 sys_nanosleep();

//将系统调用函数组织为一个函数指针数组
static uint64 (*syscalls[])() = {
    [SYS_fork] sys_fork,
    [SYS_kill] sys_kill,
    [SYS_open] sys_openat,

    [SYS_simple_read] sys_simple_read,
    [SYS_simple_write] sys_simple_write,

    [SYS_openat] sys_openat,
    [SYS_read] sys_read,
    [SYS_write] sys_write,
    [SYS_close] sys_close,
    [SYS_pipe2] sys_pipe2,
    [SYS_chdir] sys_chdir,
    [SYS_dup] sys_dup,
    [SYS_dup3] sys_dup3,
    [SYS_mkdirat] sys_mkdirat,
    [SYS_mount] sys_mount,
    [SYS_umount] sys_umount,
    [SYS_unlinkat] sys_unlinkat,
    [SYS_getcwd] sys_getcwd,
    [SYS_getdents64] sys_getdents,
    [SYS_fstat] sys_fstat,
    [SYS_clone] sys_clone,
    [SYS_execve] sys_execve,
    [SYS_wait4] sys_wait4,
    [SYS_exit] sys_exit,
    [SYS_getppid] sys_getppid,
    [SYS_getpid] sys_getpid,
    [SYS_brk] sys_brk,
    [SYS_mmap] sys_mmap,
    [SYS_munmap] sys_munmap,
    [SYS_times] sys_times,
    [SYS_uname] sys_uname,
    [SYS_sched_yield] sys_sched_yield,
    [SYS_gettimeofday] sys_gettimeofday,
    [SYS_nanosleep] sys_nanosleep,
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


//打开一个文件(没有同步控制)
//a0存储文件名的指针,a1存储打开方式(参见fcntl.h)
//返回该文件的文件描述符
uint64 sys_openat(){
    //获取参数
    int fd=(int)current->trapframe->regs.a0;
    char* file_name=(char*)current->trapframe->regs.a1; //a0存储文件名指针(包含路径)
    file_name=(char*)va_to_pa(current->pagetable, file_name);   //虚拟地址转为物理地址
    int flag=current->trapframe->regs.a2;
    return do_openat(fd, file_name, flag);  //返回文件描述符

}

//读取文件中的数据
uint64 sys_read(){
    //获取参数
    int fd=(int)current->trapframe->regs.a0; //a0存储文件描述符
    if(fd<0 || fd>N_OPEN_FILE || current->open_files[fd]==NULL){
        return -1;
    }
    char* buf=(char*)current->trapframe->regs.a1;   //a1为读取的内存位置
    buf=(char*)va_to_pa(current->pagetable,buf);    //虚拟地址转物理地址
    int rsize=current->trapframe->regs.a2;  //a2为希望读取多少字节
    
    rsize=read_file(current->open_files[fd],buf,rsize);     //调用read_file读取
    return rsize;   //返回实际读取的数据
}

uint64 sys_write(){
    //获取参数
    int fd=(int)current->trapframe->regs.a0; //a0存储文件描述符
    if(fd<0 || fd>N_OPEN_FILE || current->open_files[fd]==NULL){
        return -1;
    }
    char* buf=(char*)current->trapframe->regs.a1;   //a1为读取的内存位置
    buf=(char*)va_to_pa(current->pagetable,buf);    //虚拟地址转物理地址
    int wsize=current->trapframe->regs.a2;  //a2为希望读取多少字节
    //if(fd==1)
        //return write_to_console(buf,wsize);
    
    if(current->open_files[fd]==NULL){
        return -1;
    }

    wsize=write_file(current->open_files[fd],buf,wsize);     //调用read_file读取
    return wsize;   //返回实际读取的数据
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
    char* str=(char*)current->trapframe->regs.a1;
    str=(char*)va_to_pa(current->pagetable,str);
    int sz=current->trapframe->regs.a2;
    return write_to_console(str,sz);
}

//关闭文件
uint64 sys_close(){
    int fd=current->trapframe->regs.a0; //a0存储文件描述符
    return do_close(fd);
}

//创建目录
uint64 sys_mkdirat(){
    int fd=current->trapframe->regs.a0;
    char* path=(char*)current->trapframe->regs.a1;
    path=va_to_pa(current->pagetable,path);
    return do_mkdirat(fd,path);
}

uint64 sys_pipe2(){
    return 0;
}

uint64 sys_getcwd(){
    char *buf=(char*)current->trapframe->regs.a0;
    buf=va_to_pa(current->pagetable,buf);
    int sz=current->trapframe->regs.a1;
    return (uint64)do_getcwd(buf,sz);
}

uint64 sys_getdents(){
    int fd=current->trapframe->regs.a0;
    char *buf=(char*)current->trapframe->regs.a1;
    buf=va_to_pa(current->pagetable,buf);
    int sz=current->trapframe->regs.a2;
    return do_getdents(fd,buf,sz);
}

uint64 sys_chdir(){
    char *path=(char*)current->trapframe->regs.a0;
    path=va_to_pa(current->pagetable,path);
    return do_chdir(path);
}

uint64 sys_dup(){
    int fd=current->trapframe->regs.a0;
    return do_dup(current,fd);
}

uint64 sys_dup3(){
    int old=current->trapframe->regs.a0;
    int new=current->trapframe->regs.a1;
    return do_dup3(current,old,new);
}

uint64 sys_mount(){
    char *dev_name=(char*)current->trapframe->regs.a0;
    dev_name=va_to_pa(current->pagetable,dev_name);
    char *mnt_point=(char*)current->trapframe->regs.a1;
    mnt_point=va_to_pa(current->pagetable,mnt_point);
    char *fs_type=(char*)current->trapframe->regs.a2;
    fs_type=va_to_pa(current->pagetable,fs_type);
    return do_mount(dev_name,mnt_point,fs_type);
}

uint64 sys_umount(){
    char *mnt_point=(char*)current->trapframe->regs.a0;
    mnt_point=va_to_pa(current->pagetable,mnt_point);
    return do_umount(mnt_point);
}

uint64 sys_unlinkat(){
    int dir_fd=current->trapframe->regs.a0;
    char *path=(char*)current->trapframe->regs.a1;
    path=va_to_pa(current->pagetable,path);
    int flags=current->trapframe->regs.a2;
    return do_unlinkat(dir_fd,path,flags);
}

uint64 sys_fstat(){
    int fd=current->trapframe->regs.a0;
    kstat *stat=(kstat*)current->trapframe->regs.a1;
    stat=va_to_pa(current->pagetable,stat);
    return do_fstat(fd,stat);
}

//进程复制，可自行指定用户栈
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

//获取进程运行时间
uint64 sys_times(){
    tms *times=(tms*)current->trapframe->regs.a0;
    times=va_to_pa(current->pagetable,times);
    return do_times(times);
}

typedef struct utsname {    //系统信息
	char sysname[65];
	char nodename[65];
	char release[65];
	char version[65];
	char machine[65];
	char domainname[65];
}utsname;
//获取系统信息
uint64 sys_uname(){
    utsname *info=(utsname*)current->trapframe->regs.a0;
    info=va_to_pa(current->pagetable,info);
    if(info==NULL)
        return (uint64)(-1);
    memcpy(info->sysname,"testOS\0",7);
    memcpy(info->nodename,"none\0",5);
    memcpy(info->release,"debug\0",6);
    memcpy(info->version,"v1.0\0",5);
    memcpy(info->machine,"K210\0",5);
    memcpy(info->domainname,"none\0",5);
    return 0;
}

//进程放弃CPU
uint64 sys_sched_yield(){
    do_yield();
    return 0;
}

//获取时间
uint64 sys_gettimeofday(){
    timespec *ts=(timespec*)current->trapframe->regs.a0;
    ts=va_to_pa(current->pagetable,ts);
    return do_gettimeofday(ts);
}

//进程睡眠
uint64 sys_nanosleep(){
    timespec *req=(timespec*)current->trapframe->regs.a0;
    req=va_to_pa(current->pagetable,req);
    timespec *rem=(timespec*)current->trapframe->regs.a1;
    rem=va_to_pa(current->pagetable,rem);
    return do_nanosleep(req,rem);
}

//改变进程堆内存大小
//当addr为0时，返回当前进程大小
uint64 sys_brk(){
    uint64 addr=current->trapframe->regs.a0;
    return do_brk(current,addr);
}

uint64 sys_mmap(){
    return 0;
}

uint64 sys_munmap(){
    return 0;
}
