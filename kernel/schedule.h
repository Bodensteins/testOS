#ifndef _SCHEDULE_H_
#define _SCHEDULE_H_

extern process* runnable_queue;

void insert_to_runnable_queue(process *proc);
void delete_from_runnable_queue(process *proc);
void schedule();

#endif