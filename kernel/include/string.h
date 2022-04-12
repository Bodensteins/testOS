#ifndef _STRING_H_
#define STRING_H_

#include "types.h"

void *memset(void*, int, size_t);
void* memcpy(void *dst, const void *src, uint n);

int strcmp(char* str1, char* str2);
int strncmp(char* str1, char* str2, uint n);
int strlen(char *str);
void upper(char *str);
void lower(char *str);

#endif