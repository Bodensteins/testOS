#include "include/pipe.h"
#include "include/file.h"
#include "include/pm.h"
#include "include/vm.h"
#include "include/printk.h"
#include "include/process.h"
#include "include/schedule.h"

static process *pipe_read_queue=NULL;

void user_trap_ret();

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
    (*rd)->offset=0;

    (*wr)->type=FILE_TYPE_PIPE;
    (*wr)->attribute=FILE_ATTR_WRITE;
    (*wr)->pipe=pi;
    (*wr)->offset=0;

    return 0;
}

int do_pipe(int fd[2]){
    if(fd==NULL)
        return -1;
    
    file *rd=acquire_file();
    if(rd==NULL)
        return -1;
    file *wr=acquire_file();
    if(wr==NULL){
        release_file(rd);
        return -1;
    }

    fd[0]=acquire_fd(current,rd);
    if(fd[0]==-1){
        release_file(rd);
        release_file(wr);
        return -1;
    }

    fd[1]=acquire_fd(current,wr);
    if(fd[1]==-1){
        release_file(rd);
        release_file(wr);
        current->open_files[fd[0]]=NULL;
        return -1;
    }
    
    if(alloc_pipe(&rd,&wr)!=0){
        release_file(rd);
        release_file(wr);
        current->open_files[fd[0]]=NULL;
        current->open_files[fd[1]]=NULL;
        return -1;
    }

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

void static process_sleep_on_pipe(process *proc){
    if(proc==NULL)
        return;
    proc->state=SLEEPING;
    insert_into_queue(&pipe_read_queue,proc);
    schedule();
}

void static process_wake_up_on_pipe(process *proc){
    if(proc==NULL)
        return;
    if(delete_from_queue(&pipe_read_queue, proc)!=0)
        return;
    
    proc->state=RUNNING;
    current=proc;
    
    int fd=proc->trapframe->regs.a0;
    char *buf=(char*)proc->trapframe->regs.a1;
    buf=(char*)va_to_pa(proc->pagetable,buf);
    int sz=proc->trapframe->regs.a2;
    pipe *pi=proc->open_files[fd]->pipe;

    proc->trapframe->regs.a0=read_from_pipe(pi,buf,sz);

    user_trap_ret();
}

int write_to_pipe(pipe *pi, char *buf, int sz){
    if(pi==NULL || buf==NULL || sz<=0 || pi->writeopen==0 || current->killed)
        return -1;
    
    int i;
    for(i=0;i<sz && i<PIPE_SIZE;i++){
        pi->data[pi->nwrite%PIPE_SIZE]=buf[i];
        pi->nwrite++;
    }

    current->trapframe->regs.a0=i;
    current->state=READY;
    insert_into_queue(&runnable_queue, current);
    process_wake_up_on_pipe(pipe_read_queue);
    delete_from_queue(&runnable_queue,current);
    current->state=RUNNING;

    return i;
}

int read_from_pipe(pipe *pi, char *buf, int sz){
    if(pi==NULL || buf==NULL || sz<=0 || pi->readopen==0 || current->killed)
        return -1;
    
    if(sz>pi->nread-pi->nwrite){    //weird
        if(pi->nread==0)
            process_sleep_on_pipe(current);
        else
            return 0;
    }

    int i;
    for(i=0;i<sz && pi->nread<pi->nwrite;i++){
        buf[i]=pi->data[pi->nread%PIPE_SIZE];
        pi->nread++;
    }

    return i;
}

