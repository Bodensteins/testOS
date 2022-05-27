#ifndef _PIPE_H_
#define _PIPE_H_

#include "types.h"
#include "spinlock.h"

#define PIPE_SIZE 2048

typedef struct pipe {
  uint nread;     // number of bytes read
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open

  struct spinlock lock;
  char data[PIPE_SIZE];
}pipe;

int do_pipe(int fd[2]);
void close_pipe(pipe *pi, int is_write);
int write_to_pipe(pipe *pi, char *buf, int sz);
int read_from_pipe(pipe *pi, char *buf, int sz);

#endif