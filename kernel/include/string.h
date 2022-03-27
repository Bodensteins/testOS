#ifndef _STRING_H_
#define STRING_H_

#include "types.h"

void *memset(void*, int, size_t);
void* memmove(void *dst, const void *src, uint n);
void* memcpy(void *dst, const void *src, uint n);

#endif