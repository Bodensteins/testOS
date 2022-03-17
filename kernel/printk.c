#include <stdarg.h>
#include "types.h"
#include "uart.h"
#include "printk.h"

#define BACKSPACE 0x100
#define C(x)  ((x)-'@')  // Control-x

//
// send one character to the uart.
// called by printf, and to echo input characters,
// but not from write().
//
void putc(int c){
  if(c == BACKSPACE){
    // if the user typed backspace, overwrite with a space.
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
  } else {
    uartputc_sync(c);
  }
}

void puts(char *s){
  int i,c;
  for(i = 0; (c = s[i] & 0xff) != 0; i++){
    putc(c);
  }
}

// Print to the console. only understands %d, %x, %p, %s.
void printk(char *fmt, ...){
  va_list ap;
  int i, c;//, locking;
  char *s;

/*
  locking = pr.locking;
  if(locking)
    acquire(&pr.lock);
    */
  if (fmt == 0)
    panic("null fmt");

  va_start(ap, fmt);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      putc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
        /*
    case 'd':
      printint(va_arg(ap, int), 10, 1);
      break;
    case 'x':
      printint(va_arg(ap, int), 16, 1);
      break;
    case 'p':
      printptr(va_arg(ap, uint64));
      break;
      */
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        putc(*s);
      break;
    case '%':
      putc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      putc('%');
      putc(c);
      break;
    }
  }

  //if(locking)
    //release(&pr.lock);
}

void panic(char *s){
  //pr.locking = 0;
  printk("panic: ");
  printk(s);
  printk("\n");
  //panicked = 1; // freeze uart output from other CPUs
  for(;;)
    ;
}
