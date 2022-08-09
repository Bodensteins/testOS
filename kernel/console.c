#include "include/console.h"
#include "include/sleeplock.h"
#include "include/device.h"
#include "include/schedule.h"
#include "include/process.h"
#include "include/vm.h"
#include "include/printk.h"
#include "include/string.h"
#include "include/trap.h"
#include "include/plic.h"

static process *console_queue=NULL;
static console_buffer cons_buf;

void console_init(){
    init_spinlock(&cons_buf.spinlock,"cons_buf lock");

    cons_buf.edit_index=0;
    cons_buf.read_index=0;
    cons_buf.write_index=0;
}

void console_intr(int c){
    switch(c){
        case CTRL('U'):  // Kill line.
            while(cons_buf.edit_index!=cons_buf.write_index &&
                cons_buf.input_buffer[(cons_buf.edit_index-1)%CONSOLE_BSIZE] != '\n'){
                cons_buf.edit_index--;
                putc(BACKSPACE);
            }
            break;
        case CTRL('H'): // Backspace
        case '\x7f':
            if(cons_buf.edit_index != cons_buf.write_index){
                cons_buf.edit_index--;
                putc(BACKSPACE);
            }
            break;
        default:
            if(c != 0 && cons_buf.edit_index-cons_buf.read_index<CONSOLE_BSIZE){
                #ifndef QEMU
                if (c == '\r') break;     // on k210, "enter" will input \n and \r
                #else
                c = (c == '\r') ? '\n' : c;
                #endif
                // echo back to the user.
                putc(c);

                // store for consumption by consoleread().
                cons_buf.input_buffer[cons_buf.edit_index%CONSOLE_BSIZE]=c;
                cons_buf.edit_index++;

                if(c=='\n' || c==CTRL('D') || cons_buf.edit_index==cons_buf.read_index+CONSOLE_BSIZE){
                    // wake up consoleread() if a whole line (or end-of-file) has arrived.
                    cons_buf.write_index=cons_buf.edit_index;
                    //process_wakeup_on_console(console_queue);
                    process_wakeup1(&console_queue);
                }
            }
            break;
    }
}

int read_from_console(void *des, int n){
    uint target;
    char *dst=(char*)des;
    char c;
    char cbuf;

    target = n;
    //acquire(&cons.lock);
    while(n > 0){
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while(cons_buf.read_index == cons_buf.write_index){
            if(current->killed){
                //release(&cons.lock);
                return -1;
            }
            //sleep(&cons.r, &cons.lock);
            process_sleep(&console_queue);
        }

        c = cons_buf.input_buffer[cons_buf.read_index++ % CONSOLE_BSIZE];

        // copy the input byte to the user-space buffer.
        cbuf = c;
        
        //if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
        //    break;
        if(c!='\n' && c!=CTRL('D'))
            memcpy(dst,&cbuf,1);
        else
            dst[0]=0;

        dst++;
        --n;
        if(c == '\n' || c==CTRL('D')){
            // a whole line has arrived, return to
            // the user-level read().
            n++;
            break;
        }
    }
    //release(&cons.lock);

    return target - n;
}

int write_to_console(void *src, int sz){
    int i=0;
    char *str=src;
    while(i<sz){
        if(str[i]==0)
            break;
        putc(str[i]);
        i++;
    }
    return i;
}
