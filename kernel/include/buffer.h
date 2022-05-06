#ifndef _BUFFER_H_
#define _BUFFER_H_

#include "types.h"
#include "sleeplock.h"

/*
sd卡缓冲区
仿照xv6的设计
使用LRU算法，所有buffer被组织为buffer_cache中的一个双向循环链表
每当一个buffer被释放且其ref_count减为0，即将该buffer移至链表头部，表示其是最近才被使用过的
每次需要从sd卡读取一个扇区时时，先正向遍历链表，如果该扇区中的数据已经存在于buffer_cache中，则直接获取该buffer中的数据
如果未能找到，则从尾部开始反向遍历链表，直至找到ref_count==0的buffer，此即为最长时间未被使用的buffer，将扇区中的数据读入该buffer
*/

/*
文件系统相关依赖为：
    syscall.c-->file.c-->fat32.c-->buffer.c-->sd/sdcard.c(k210官方的sd卡驱动)-->底层驱动
*/

#define BSIZE 512 //单个buffer中的数据大小，与一个扇区大小相同，512字节
#define NBUFFER 128 //buffer数量

//单个缓冲区(buffer)的结构
typedef struct buffer{
    int valid;   //缓冲区是否有效
    int dirty;  //
    uint dev;   //设备号(这个字段是xv6中的，但似乎目前的缓冲区只管理sd卡这一个设备，也许之后会有扩展)
    uint sectorno;  //该缓冲区对应的sd卡扇区号
    uint ref_count;  //该缓冲区当前被引用的数量，当ref_count为0表示该buffer空闲
    struct sleeplock sleeplock;  //缓冲区睡眠锁
    struct buffer *prev;    //在LRU双向循环链表中，指向该buffer的上一个链表节点
    struct buffer *next;    //在LRU双向循环链表中，指向该buffer的下一个链表节点
    uint8 data[BSIZE];      //buffer中的数据区，存储从sd卡扇区中读出来的512字节
}buffer;

//buffer缓存，维护buffer列表并将其组织为一个双向循环链表
typedef struct buffer_cache{
    spinlock spinlock; //buffer缓存自旋锁
    buffer buffer_list[NBUFFER]; //buffer列表，其中的所有buffer都会被组织为双向循环链表
    buffer head;    //双向循环链表的表头，其prev字段即指向表尾，其next字段指向最近被使用过的空闲buffer
}buffer_cache;

void buffer_init(); //缓冲区初始化，OS启动时调用
buffer* acquire_buffer(uint dev, uint sectorno); //根据设备号和扇区号，获取一个buffer
void release_buffer(buffer *buf);   //释放一个buffer
void buffer_write(buffer *buf); //将该buffer中的数据写入设备(目前的设备就一个sd卡)
void write_to_buffer(buffer *buf, void*src, int off, int wsize);    //将src中的数据写入buf，off为buf写入位置的偏移,wsize为写入的数据多少

#endif