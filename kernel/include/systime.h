#ifndef _SYSTIME_H_
#define _SYSTIME_H_

#include "types.h"

typedef struct tms{
    uint64 utime;		// user time 
	uint64 stime;		// system time 
	uint64 cutime;		// user time of children 
	uint64 cstime;		// system time of children 
}tms;

#endif