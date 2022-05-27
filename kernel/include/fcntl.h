#ifndef _FCNTL_H_
#define _FCNTL_H_

/*
该头文件用于read、write、create等系统调用
表示打开的文件的权限
*/

#define O_RDONLY  0x000
#define O_WRONLY  0x001
#define O_RDWR    0x002
#define O_CREATE  0x040
#define O_TRUNC   0x200
#define O_APPEND  0x400
#define O_DIRECTORY 0x010000
#define O_CLOEXEC 0x80000

#ifndef AT_FDCWD
#define AT_FDCWD  -100
#endif

#define AT_REMOVEDIR 0x200

#define FD_CLOEXEC 1

#define F_DUPFD         1
#define F_DUPFD_CLOEXEC 1030

#endif