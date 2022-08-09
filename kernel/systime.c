#include "include/systime.h"
#include "include/riscv.h"
#include "include/process.h"
#include "include/printk.h"
#include "include/schedule.h"
#include "include/vm.h"

static process *nanosleep_queue=NULL;

static inline uint64 calc_timespec(timespec *ts);
static inline void make_timespec(timespec *ts, uint64 time);

uint64 do_times(tms *times){
    uint64 tm=read_time();
    
    if(times!=NULL){
        times->stime=current->times.stime+tm-current->enter_ktimes;
        times->utime=current->times.utime;
        times->cstime=current->times.cstime;
        times->cutime=current->times.cutime;
    }
   
    return tm;
}

uint64 do_gettimeofday(timespec *ts){
    if(ts==NULL)
        return (uint64)(-1);
    
    uint64 ticks=r_time();
    uint64 tmp=ticks/(CLK_FREQUENCE/100000);
    ts->nsec=(tmp%100000)*10;
    ts->sec=ticks/CLK_FREQUENCE;

    return 0;
}

uint64 do_nanosleep(timespec *req, timespec *rem){
    if(req==NULL)
        return (uint64)(-1);

    uint64 now,expire;
    now=read_time();
    expire=now+calc_timespec(req);

    if(now<expire){
        //lock
        current->sleep_expire=expire;
        process_sleep(&nanosleep_queue);
        //unlock
    }

    if(rem!=NULL)
        make_timespec(rem,expire);

    return 0;
}

void wakeup_on_nanosleep(process *proc){
    //if(delete_from_queue(&nanosleep_queue, proc)!=0)
        //return;
    proc->state=READY;
    insert_into_queue(&runnable_queue,proc);
}

void check_nanosleep_per_clk(){
    if(nanosleep_queue==NULL)
        return;

    uint64 now=read_time();
    process *cur=nanosleep_queue;
    process *pre=cur;
    cur=cur->queue_next;
    
    while(cur!=NULL){
        if(cur->sleep_expire<=now){
            pre->queue_next=cur->queue_next;
            wakeup_on_nanosleep(cur);
            cur=pre->queue_next;
        }
        else{
            pre=cur;
            cur=cur->queue_next;
        }
    }

    cur=nanosleep_queue;
    if(nanosleep_queue->sleep_expire<=now){
        nanosleep_queue=cur->queue_next;
        wakeup_on_nanosleep(cur);
    }
}

static inline uint64 calc_timespec(timespec *ts){
    return ts->sec*CLK_FREQUENCE+ts->nsec*(CLK_FREQUENCE/100000)/10000;
}

static inline void make_timespec(timespec *ts, uint64 time){
    ts->sec=time/CLK_FREQUENCE;
	ts->nsec=(time%CLK_FREQUENCE)*1000000000/CLK_FREQUENCE;
}
