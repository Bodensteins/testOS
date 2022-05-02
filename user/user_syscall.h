#ifndef _USER_SYSCALL_H_
#define _USER_SYSCALL_H_

#include "kernel/include/types.h"

uint64 fork();  //复制一个新进程
uint64 exit(int code);  //进程退出
uint64 open(char *file_name, int mode); //打开文件
uint64 read(int fd, void* buf, size_t rsize);   //根据文件描述符fd，读取文件中rsize个字节到buf中
uint64 kill(uint64 pid);    //根据pid杀死进程
uint64 exec(char *file_name);   //根据文件路径和名字加载可执行文件
uint64 simple_write(char *s, size_t n);     //一个简单的输出字符串到屏幕上的系统调用
uint64 close(int fd);   //根据文件描述符关闭文件

#endif