#ifndef _USER_SYSCALL_H_
#define _USER_SYSCALL_H_

#include "kernel/include/types.h"

uint64 fork();  //复制一个新进程
int openat(int fd, char *file_name, int flag); //打开文件
uint64 read(int fd, void* buf, size_t rsize);   //根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 kill(uint64 pid);    //根据pid杀死进程
uint64 simple_write(char *s, size_t n);     //一个简单的输出字符串到屏幕上的系统调用
uint64 close(int fd);   //根据文件描述符关闭文件

uint64 simple_read(char *s, size_t n);      //从键盘输入字符串
uint64 simple_write(char *s, size_t n);     //输出字符串到屏幕

uint64 clone(uint64 flag, void *stack, size_t sz);
uint64 execve(char *file_name, char **argv, char **env);   //根据文件路径和名字加载可执行文件
uint64 wait4(int pid, int *status, uint64 options);
uint64 exit(int code);  //进程退出
uint64 getppid();   //获取父进程pid
uint64 getpid();    //获取当前进程pid
int brk(uint64 addr);   //改变进程堆内存大小，当addr为0时，返回当前进程大小
uint64 sched_yield();

#endif
