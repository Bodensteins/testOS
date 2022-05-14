#ifndef _PARAM_H_
#define _PARAM_H_

//从xv6复制过来的

#define NCPU          1  // maximum number of CPUs
#define NINODE       50  // maximum number of active i-nodes
#define NDEV         8  // maximum major device number
#define ROOTDEV       1  // device number of file system root disk
#define MAXARG       32  // max execve arguments
#define MAXENV      8   // max execve environment
#define MAXOPBLOCKS  10  // max # of blocks any FS op writes
#define LOGSIZE      (MAXOPBLOCKS*3)  // max data blocks in on-disk log
#define NBUF         (MAXOPBLOCKS*3)  // size of disk block cache
#define FSSIZE       1000  // size of file system in blocks

#endif