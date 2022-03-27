#ifndef _STRAP_H_
#define _STRAP_H_

extern void test();
extern void kernel_trap_vec();
extern void user_trap_vec();

void trap_init();
void user_trap();
void user_trap_ret();
void kernel_trap();

#endif