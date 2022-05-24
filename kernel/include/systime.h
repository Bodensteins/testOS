#ifndef _SYSTIME_H_
#define _SYSTIME_H_

#include "types.h"

typedef struct tms{
    long utime;		// user time 
	long stime;		// system time 
	long cutime;		// user time of children 
	long cstime;		// system time of children 
}tms;

uint64 do_times(tms *times);

#endif