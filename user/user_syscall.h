#ifndef _USER_SYSCALL_H_
#define _USER_SYSCALL_H_

#include "kernel/include/types.h"

uint64 fork();
uint64 exit(int code);
uint64 open(char *file_name, int mode);
uint64 read(int fd, void* buf, size_t rsize);
uint64 kill(uint64 pid);
uint64 exec(char *file_name);
uint64 simple_write(char *s, size_t n);
uint64 close(int fd);

#endif