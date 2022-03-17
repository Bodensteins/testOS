#ifndef _USER_SYSCALL_H_
#define _USER_SYSCALL_H_

#include "kernel/types.h"

uint64 fork();
uint64 exit(int code);
uint64 kill(uint64 pid);
uint64 simple_write(char *s, size_t n);


#endif