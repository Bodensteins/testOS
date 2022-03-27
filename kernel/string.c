#include <stdint.h>
#include <ctype.h>
#include "include/string.h"

void* memset(void* dest, int byte, size_t len) {
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

void* memmove(void *dst, const void *src, uint n){
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

// memcpy exists to placate GCC.  Use memmove.
void* memcpy(void *dst, const void *src, uint n){
  return memmove(dst, src, n);
}