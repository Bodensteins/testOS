#ifndef _CONSOLE_H_
#define _CONSOLE_H_

#include "types.h"
#include "spinlock.h"

#define CTRL(x)  ((x)-'@')  // Control-x
#define BACKSPACE 0x100

#define CONSOLE_BSIZE 256

typedef struct console_buffer{
    spinlock spinlock;
    char input_buffer[CONSOLE_BSIZE];
    uint64 edit_index;
    uint64 read_index;
    uint64 write_index;
}console_buffer;

void console_init();
void console_intr(int c);
int read_from_console(void *dst, int sz);
int write_to_console(void *src, int sz);

#endif