#ifndef _SYSTIME_H_
#define _SYSTIME_H_

#include "types.h"

#define CLK_FREQUENCE 8900000

typedef struct tms{
    long utime;		// user time 
	long stime;		// system time 
	long cutime;		// user time of children 
	long cstime;		// system time of children 
}tms;

typedef struct timespec {
	uint64 sec;			/* seconds */
	uint64 nsec;		/* nanoseconds */
}timespec;

uint64 do_times(tms *times);
uint64 do_gettimeofday(timespec *ts);
uint64 do_nanosleep(timespec *req, timespec *rem);
void check_nanosleep_per_clk();

#endif