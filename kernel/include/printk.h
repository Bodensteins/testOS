#ifndef _PRINTK_H_
#define _PRINTK_H_

void putc(int c);
void puts(char *s);
void printk(char *fmt, ...);
void panic(char *s);

#endif