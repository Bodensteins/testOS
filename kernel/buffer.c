#include "include/buffer.h"
#include "include/spinlock.h"
#include "include/sleeplock.h"
#include "include/string.h"

#ifndef QEMU
#include "sd/include/sdcard.h"
#else
#include "include/virtio.h"
#endif

#include "include/printk.h"

/*
文件系统相关依赖为：
syscall.c-->file.c-->vfs_inode.c-->fat32.c-->buffer.c-->sd/sdcard.c(k210官方的sd卡驱动)-->底层驱动
*/

/*
sd卡缓冲区
仿照xv6的设计
使用LRU算法，所有buffer被组织为buffer_cache中的一个双向循环链表
每当一个buffer被释放且其ref_count减为0，即将该buffer移至链表头部，表示其是最近才被使用过的
每次需要从sd卡读取一个扇区时时，先正向遍历链表，如果该扇区中的数据已经存在于buffer_cache中，则直接获取该buffer中的数据
如果未能找到，则从尾部开始反向遍历链表，直至找到ref_count==0的buffer，此即为最长时间未被使用的buffer，将扇区中的数据读入该buffer
*/

//buffer缓存，定义为静态全局变量
static buffer_cache bcache;

//buffer初始化函数，在OS启动初始化时调用
void buffer_init(){
    init_spinlock(&bcache.spinlock,"buffer cache lock");    //初始化bcache自旋锁

    //接下来的步骤是在将bcache中的buffer_list的全部元素都串成一个双向循环链表
    bcache.head.next=&bcache.head;
    bcache.head.prev=&bcache.head;
    for(int i=0;i<NBUFFER;i++){
        init_sleeplock(&bcache.buffer_list[i].sleeplock,"buffer lock"); //初始化buffer的睡眠锁
        (bcache.buffer_list+i)->prev=&bcache.head;
        (bcache.buffer_list+i)->next=bcache.head.next;
        bcache.head.next->prev=(bcache.buffer_list+i);
        bcache.head.next=(bcache.buffer_list+i);
        bcache.buffer_list[i].ref_count=0;
        bcache.buffer_list[i].valid=0;
        bcache.buffer_list[i].dirty=0;

        #ifdef QEMU
        bcache.buffer_list[i].virtio_queue=NULL;
        #endif
    }

}

//将buf移动至bcache中循环链表的头部,即表示该buffer是最近使用过的
static void move_buffer_to_bcache_head(buffer *buf){
    buf->prev->next=buf->next;
    buf->next->prev=buf->prev;
    buf->next=bcache.head.next;
    buf->prev=&bcache.head;
    bcache.head.next->prev=buf;
    bcache.head.next=buf;
}

//根据buf中的设备号和扇区号，将数据读入buf的data字段
static void buffer_read_from_dev(buffer *buf){
    #ifndef QEMU
    sdcard_read_sector(buf->data, buf->sectorno);
    #else
    virtio_disk_rw(buf,0);
    #endif

}

//根据buf中的设备号和扇区号，将buf的data字段数据写入设备的扇区中
static void buffer_write_to_dev(buffer *buf){
    #ifndef QEMU
    sdcard_write_sector(buf->data, buf->sectorno);
    #else
    virtio_disk_rw(buf,1);
    #endif
}

/*
根据指定的设备号和扇区号，获取一个buffer
返回值为一个指向bcache中的buffer的指针，该buffer的data字段保存了读取的指定扇区的数据
*/
buffer* acquire_buffer(uint dev, uint sectorno){
    //acquire(&bcache.spinlock);
    buffer *buf;

    //首先正向遍历链表
    //如果该扇区中的数据已经在缓冲区中了，则直接返回对应buffer的指针就行
    for(buf=bcache.head.next;buf!=&bcache.head;buf=buf->next){
        if(buf->valid && buf->dev==dev && buf->sectorno==sectorno){
            //release_spinlock(&bcache.spinlock);
            //acquire_sleeplock(&buf->sleeplock);
            buf->ref_count++;   //找到了，则ref_count自加
            return buf;
        }
    }

    //如果扇区数据并不在缓冲区中，则反向遍历链表
    //找到空闲了最长时间的那个buffer，将数据读入该buffer并返回其指针
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

    //所有buffer都满了，则出错
    panic("buffers are all full and busy\n");
    return NULL;
}

//释放buffer
//当buffer使用完之后，需要及时释放
void release_buffer(buffer *buf){
    //if(!is_holding_sleeplock(&buf->sleeplock))
        //panic("release_buffer\n");

    //release_sleeplock(&buf->sleeplock); 
    //acquire(&bcache.spinlock);

    //ref_count自减
    buf->ref_count--;
    //如果ref_count为0，说明buffer已经空闲
    if(buf->ref_count==0){
        if(buf->dirty!=0){
            buffer_write(buf);
            buf->dirty=0;
        }
        move_buffer_to_bcache_head(buf);    //将该空闲buffer移动至链表表头，表示其为最近才使用过的buffer
    }

    //release(&bcache.spinlock);
}

//将该buf中的数据根据buffer中的设备号和扇区号写入设备
void buffer_write(buffer *buf){
    //if(!is_holding_sleeplock(&buf->sleeplock))
        //panic("buffer_write\n");
    buffer_write_to_dev(buf);
}

//将src中的数据写入buf，off为buf写入位置的偏移,wsize为写入的数据多少
void write_to_buffer(buffer *buf, void*src, int off, int wsize){
    if(off>=BSIZE)
        return;
    if(off+wsize>BSIZE){
        wsize=BSIZE-off;
    }
    buf->dirty=1;
    memcpy(buf->data+off, src, wsize);
}

