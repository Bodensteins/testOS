#ifndef _PRINTK_H_
#define _PRINTK_H_

/*
这里提供一些内核中输出信息的接口
用法与C标准库的printf、putc、puts等一致
*/

void putc(int c);
void puts(char *s);

//命名为printk是为了与用户态的printf相区分
void printk(char *fmt, ...);

//panic在输出错误信息后会进入死循环
void panick(char *s);

#endif