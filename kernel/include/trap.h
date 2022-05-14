#ifndef _STRAP_H_
#define _STRAP_H_

/*
trap相关，与xv6类似
*/

extern void kernel_trap_vec();  //内核态trap时调用的中断向量函数 (在kerneltrapvec.S中定义)
extern void user_trap_vec();    //用户态trap时调用的中断向量函数 (在usertrapve.S中定义)

void trap_init();   //trap初始化
void user_trap();   //用户态trap转到该函数处理
void user_trap_ret();   //trap处理结束后返回用户态 (在usertrapve.S中定义)
void kernel_trap(); //内核态trap转到该函数处理

void clear_plic(int irq);

#endif