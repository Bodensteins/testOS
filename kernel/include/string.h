#ifndef _STRING_H_
#define STRING_H_

#include "types.h"

/*
字符串处理
与C标准库一致
不再赘述
*/

void *memset(void*, int, size_t);
void* memcpy(void *dst, const void *src, uint n);

int strcmp(char* str1, char* str2);
int strncmp(char* str1, char* str2, uint n);
int strlen(char *str);
void upper(char *str);  //小写转大写
void lower(char *str);  //大写转小写

#endif