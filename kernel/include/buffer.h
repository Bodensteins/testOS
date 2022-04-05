#ifndef _BUFFER_H_
#define _BUFFER_H_

#include "types.h"
#include "sleeplock.h"

#define BISZE 512
#define NBUFFER 32

typedef struct buffer{
    int valid;   // has data been read from disk?
    uint dev;
    uint sectorno;
    uint ref_count;
    struct sleeplock sleeplock;
    struct buffer *prev; // LRU cache list
    struct buffer *next;
    uint8 data[BISZE];
}buffer;

typedef struct buffer_cache{
    spinlock spinlock;
    buffer buffer_list[NBUFFER];
    buffer head;
}buffer_cache;

void buffer_init();
buffer* acquire_buffer(uint dev, uint blockno);
void release_buffer(buffer *buf);
void buffer_write(buffer *buf);

#endif