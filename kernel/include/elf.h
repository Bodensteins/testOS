#ifndef _ELF_H_
#define _ELF_H_

#include "types.h"

/*
elf文件解析
gcc编译的可执行文件格式为elf64
exec系统调用读取可执行文件加载入内存时需要解析elf格式
*/

#define ELF_MAGIC 0x464C457FU  //elf校验码
#define NIDENT 12

//prog_header type
#define ELF_PROG_LOAD 1 



typedef  uint64 elf64_addr; //elf64的地址变量类型
typedef uint64 elf64_off;   //elf64的地址偏移变量类型

//elf头部格式
//是elf文件最开头的64个字节
//描述elf文件的整体信息
//目前exec中只使用了其中4个字段，以下标注为(重要)
typedef struct elf64_header{
    uint32 magic;   //最开头4个字节是elf校验码，固定不变
    uchar ident[NIDENT];    //存储与机器无关的信息
    uint16 type;    //该文件的类型
    uint16 machine; //该程序需要的体系架构
    uint32 version; //文件的版本
    elf64_addr entry;   //程序的入口地址(重要)
    elf64_off ph_off;   //Program header table在文件中的偏移量(重要)
    elf64_off sh_off;   //Section header table在文件中的偏移量
    uint32 flags;   //对IA32，此项为0
    uint16 eh_size; //表示elf header的大小
    uint16 phent_size;  //表示Program header table中每一个条目的大小
    uint16 ph_num;  //表示Program header table中条目的数量(重要)
    uint16 shent_size;  //表示Section header table中每一个条目的大小
    uint16 sh_num;  //表示Section header table中条目的数量
    uint16 sh_str_ndx;  //包含Section名称的字符串是第几字节
}elf64_header;


//prog_header flags
#define ELF_PROG_FLAG_EXEC      1
#define ELF_PROG_FLAG_WRITE     2
#define ELF_PROG_FLAG_READ      4

//程序头(Program header)格式定义
//一个程序头对应程序的一个segment
//这个系统一般来说载入的程序都只有一个segment
//因此Program header table中一般只有一个条目
//以下的字段，exec大多数都有用到
typedef struct elf64_prog_header{
    uint32 type;    //当前Program header所描述的Segment的类型
    uint32 flags;   //与Segment相关的标志
    elf64_off offset;   //Segment的第一个字节在文件中的偏移
    elf64_addr va;  //Segment的第一个字节在内存中的虚拟地址
    elf64_addr pa;  //一些特定系统的物理地址相关，可忽略
    uint64 file_size;   //Segment在文件中的长度
    uint64 mem_size;    //Segment在内存中的长度，一般与file_size相同
    uint64 align;   //确定Segment如何对齐
}elf64_prog_header;

#endif