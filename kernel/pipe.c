#include "include/pipe.h"
#include "include/file.h"
#include "include/pm.h"
#include "include/printk.h"

int alloc_pipe(file **rd, file **wr){
    pipe *pi=(pipe*)alloc_physical_page();
    if(pi==NULL)
        return -1;
    pi->readopen=1;
    pi->writeopen=1;
    pi->nread=0;
    pi->nwrite=0;
    init_spinlock(&pi->lock, "pipe");

    (*rd)->type=FILE_TYPE_PIPE;
    (*rd)->attribute=FILE_ATTR_READ;
    (*rd)->pipe=pi;

    (*wr)->type=FILE_TYPE_PIPE;
    (*wr)->attribute=FILE_ATTR_READ;
    (*wr)->pipe=pi;

    return 0;
}

int do_pipe(int fd[2]){
    return 0;
}

void close_pipe(pipe *pi, int is_write){
    //acquire_spinlock(&pi->lock);
    if(is_write){
        pi->writeopen = 0;
    } 
    else {
        pi->readopen = 0;
    }

    if(pi->readopen==0 && pi->writeopen==0){
        //release_spinlock(&pi->lock);
        free_physical_page(pi);
    }
    //else
        //release_spinlock(&pi->lock);
}

