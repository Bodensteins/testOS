#include "include/buffer.h"
#include "include/spinlock.h"
#include "include/sleeplock.h"

#ifndef QEMU
#include "sd/include/sdcard.h"
#endif

#include "include/printk.h"

//LRU cache
static buffer_cache bcache;

void buffer_init(){
    init_spinlock(&bcache.spinlock,"buffer cache lock");
    bcache.head.next=&bcache.head;
    bcache.head.prev=&bcache.head;
    for(int i=0;i<NBUFFER;i++){
        init_sleeplock(&bcache.buffer_list[i].sleeplock,"buffer lock");
        (bcache.buffer_list+i)->prev=&bcache.head;
        (bcache.buffer_list+i)->next=bcache.head.next;
        bcache.head.next->prev=(bcache.buffer_list+i);
        bcache.head.next=(bcache.buffer_list+i);
        bcache.buffer_list[i].ref_count=0;
        bcache.buffer_list[i].valid=0;
    }

}

static void move_buffer_to_bcache_head(buffer *buf){
    buf->prev->next=buf->next;
    buf->next->prev=buf->prev;
    buf->next=bcache.head.next;
    buf->prev=&bcache.head;
    bcache.head.next->prev=buf;
    bcache.head.next=buf;
}

static void buffer_read_from_dev(buffer *buf){
    //temporary
    #ifndef QEMU
    sdcard_read_sector(buf->data, buf->sectorno);
    #endif
}

static void buffer_write_to_dev(buffer *buf){
    //temporary
    #ifndef QEMU
    sdcard_write_sector(buf->data, buf->sectorno);
    #endif
}

buffer* acquire_buffer(uint dev, uint sectorno){
    //acquire(&bcache.spinlock);
    buffer *buf;
    for(buf=bcache.head.next;buf!=&bcache.head;buf=buf->next){
        if(buf->valid && buf->dev==dev && buf->sectorno==sectorno){
            //release_spinlock(&bcache.spinlock);
            //acquire_sleeplock(&buf->sleeplock);
            buf->ref_count++;
            return buf;
        }
    }

    for(buf=bcache.head.prev;buf!=&bcache.head;buf=buf->prev){
        if(buf->ref_count==0){
            buf->ref_count++;
            buf->sectorno=sectorno;
            buf->dev=dev;
            buf->valid=1;

            //release_spinlock(&bcache.spinlock);
            //acquire_sleeplock(&buf->sleeplock);
            buffer_read_from_dev(buf);
            return buf;
        }
    }
    panic("buffers are all full and busy\n");
    return NULL;
}

void release_buffer(buffer *buf){
    //if(!is_holding_sleeplock(&buf->sleeplock))
        //panic("release_buffer\n");

    //release_sleeplock(&buf->sleeplock);
    //acquire(&bcache.spinlock);

    buf->ref_count--;
    if(buf->ref_count==0){
        move_buffer_to_bcache_head(buf);
    }

    //release(&bcache.spinlock);
}

void buffer_write(buffer *buf){
    //if(!is_holding_sleeplock(&buf->sleeplock))
        //panic("buffer_write\n");
    buffer_write_to_dev(buf);
}