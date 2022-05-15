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

void user_trap_ret();
static void process_sleep_on_console(process *proc);
static void process_wakeup_on_console(process *proc);
static void console_get_args(process *proc, uint64 *addr, int *sz);

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
                    process_wakeup_on_console(console_queue);
                }
            }
            break;
    }
}

int read_from_console(void *dst, int sz){
    char *str=dst;
    if(sz<=cons_buf.write_index-cons_buf.read_index){
        for(int i=0;i<sz;i++)
            str[i]=cons_buf.input_buffer[(cons_buf.read_index+i)%CONSOLE_BSIZE];
        cons_buf.read_index=cons_buf.read_index+sz;
        return sz;
    }

    uint64 r=cons_buf.read_index;
    uint8 is_line=0;
    while(r<cons_buf.write_index){
        char c=cons_buf.input_buffer[r%CONSOLE_BSIZE];
        r++;
        if(c=='\n' || c==CTRL('D')){
            is_line=1;
            break;
        }
    }

    if(!is_line){
        if(current->killed)
            return -1;
        process_sleep_on_console(current);
    }

    sz=r-cons_buf.read_index;
    for(int i=0;i<sz;i++)
        str[i]=cons_buf.input_buffer[(cons_buf.read_index+i)%CONSOLE_BSIZE];
    cons_buf.read_index=r;
    if(str[sz-1]=='\n' || str[sz-1]==CTRL('D'))
        str[sz-1]=0;

    return sz-1;
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

static void process_sleep_on_console(process *proc){
    if(proc==NULL)
        return;
    
    proc->state=SLEEPING;
    insert_into_queue(&console_queue,proc);
    intr_on();
    schedule();
}

static void process_wakeup_on_console(process *proc){
    if(proc==NULL || proc->state!=SLEEPING)
        return;
    
    if(delete_from_queue(&console_queue, proc)!=0)
        return;

    proc->state=RUNNING;
    current=proc;

    uint64 dst;
    int sz;
    console_get_args(proc,&dst,&sz);
    proc->trapframe->regs.a0=read_from_console((void*)dst,sz);

    clear_plic(UART_IRQ);
    
    user_trap_ret();
}

static void console_get_args(process *proc, uint64 *addr, int *sz){
    *addr=proc->trapframe->regs.a1;
    *addr=(uint64)va_to_pa(proc->pagetable,(void*)(*addr));
    *sz=proc->trapframe->regs.a2;
}
