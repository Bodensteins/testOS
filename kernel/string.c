#include <stdint.h>
#include <ctype.h>
#include "include/string.h"

/*
字符串处理
与C标准库一致
不再赘述
*/


void* memset(void* dest, int byte, size_t len) {
  if(len<=0)
    return dest;
  if ((((uintptr_t)dest | len) & (sizeof(uintptr_t) - 1)) == 0) {
    uintptr_t word = byte & 0xFF;
    word |= word << 8;
    word |= word << 16;
    word |= word << 16 << 16;

    uintptr_t* d = dest;
    while (d < (uintptr_t*)(dest + len)) *d++ = word;
  } else {
    char* d = dest;
    while (d < (char*)(dest + len)) *d++ = byte;
  }
  return dest;
}

void* memcpy(void *dst, const void *src, uint n){
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}

int strcmp(char* str1, char* str2){
  while(*str1 && *str1==*str2){
    str1++;
    str2++;
  }
  if(*str1==0 && *str2==0)
    return 0;
  else
    return 1;
}

int strncmp(char* str1, char* str2, uint n){
  while (n>0 && *str1 && *str1==*str2){
    n--;str1++;str2++;
  }
  if(n==0)
      return 0;
  else if(*str1>*str2)
    return n;
  else 
    return -n;
}

int strlen(char *str){
  int n;
  for(n = 0; str[n]; n++){}
  return n;
}

//小写转大写
void upper(char *str){
  while(*str!=0){
    if(*str>='a' && *str<='z')
      *str-=0x20;
    str++;
  }
}

//大写转小写
void lower(char *str){
  while(*str!=0){
    if(*str>='A' && *str<='Z')
      *str+=0x20;
    str++;
  }
}