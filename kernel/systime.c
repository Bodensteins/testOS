#include "include/systime.h"
#include "include/riscv.h"
#include "include/process.h"
#include "include/printk.h"

uint64 do_times(tms *times){
    uint64 tm=read_time();
    if(times!=NULL){
        times->stime=current->times.stime+tm-current->enter_ktimes;
        times->utime=current->times.utime;
        times->cstime=current->times.cstime;
        times->cutime=current->times.cutime;
    }
    //printk("%d %d %d %d\n",times->stime,times->utime,times->cstime,times->cutime);
    return tm;
}