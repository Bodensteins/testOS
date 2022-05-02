#ifndef _FCNTL_H_
#define _FCNTL_H_

/*
该头文件用于read、write、create等系统调用
表示打开的文件的权限
*/

#define O_RDONLY  0x1   //只读
#define O_WRONLY  0x2   //只写
#define O_RDWR    0x4   //读写
#define O_APPEND  0x8   //追加写
#define O_CREATE  0x200     //创建文件
#define O_TRUNC   0x400     //截断文件

#endif