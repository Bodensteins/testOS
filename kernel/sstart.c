#include "include/process.h"
#include "include/param.h"
#include "include/pmlayout.h"
#include "include/trap.h"
#include "include/printk.h"
#include "include/pm.h"
#include "include/vm.h"
#include "include/string.h"
#include "include/schedule.h"
#include "include/buffer.h"
#include "include/elf.h"

#ifndef QEMU
#include "sd/include/fpioa.h"
#include "sd/include/sdcard.h"
#include "include/fat32.h"
#endif

#ifndef BSIZE
#define BSIZE 512
#endif

/*
初始化OS
entry.S跳转到此
*/

extern char trampoline[];
void return_to_user();

void user_trap();

process* load_user_programe();      //加载第一个进程，暂时先用这个
void test_sdcard(void);     //sd卡测试函数，临时编写在此



void test_for_read_entry_form_disk()
{
    
    /*
    a= find_dirent(NULL,"/123456789ABCDC.txt");
    printk("\n%s\n",a->name);
    printk("%x\n",a->file_size);
    printk("%x\n",a->start_clusterno);
    printk("%x\n",a->total_clusters);
    printk("%x\n",a->offset_in_parent);
    printk("%x\n",a->attribute);


    a = find_dirent(NULL,"/eeee.ff.gdd/123456789ABCDC.txt");
    printk("\n%s\n",a->name);
    printk("%x\n",a->file_size);
    printk("%x\n",a->start_clusterno);
    printk("%x\n",a->total_clusters);
    printk("%x\n",a->offset_in_parent);
    printk("%x\n",a->attribute);

    
    a = find_dirent(NULL,"/abcdefghijklmnopqrstuvwxyz/1234567890123/123456789ABCDC.txt");
    printk("\n%s\n",a->name);
    printk("%x\n",a->file_size);
    printk("%x\n",a->start_clusterno);
    printk("%x\n",a->total_clusters);
    printk("%x\n",a->offset_in_parent);
    printk("%x\n",a->attribute);

    a = find_dirent(NULL,"/pp.txtqqqqqqqq/");
    printk("\n%s\n",a->name);
    printk("%x\n",a->file_size);
    printk("%x\n",a->start_clusterno);
    printk("%x\n",a->total_clusters);
    printk("%x\n",a->offset_in_parent);
    printk("%x\n",a->attribute);
    a = find_dirent(NULL,"/.txt");
    printk("\n%s\n",a->name);
    printk("%x\n",a->file_size);
    printk("%x\n",a->start_clusterno);
    printk("%x\n",a->total_clusters);
    printk("%x\n",a->offset_in_parent);
    printk("%x\n",a->attribute);


    
     a = find_dirent(NULL,"/111111111.4444444444.667788");
    printk("\n%s\n",a->name);
    printk("%x\n",a->file_size);
    printk("%x\n",a->start_clusterno);
    printk("%x\n",a->total_clusters);
    printk("%x\n",a->offset_in_parent);
    printk("%x\n",a->attribute);

    fat32_dirent *a = find_dirent(NULL,"/amd");
    printk("\n%s\n",a->name);

*/
    fat32_dirent * a = find_dirent(NULL,"/111111111.4444444444.667788/qwerty");
    printk("\n%s\n",a->name);
    printk("%x\n",a->file_size);
    printk("%x\n",a->start_clusterno);
    printk("%x\n",a->total_clusters);
    printk("%x\n",a->offset_in_parent);
    printk("%x\n",a->attribute);

    
    

    

    

    
}

//entry.S跳转到s_start
void s_start(){
    printk("entering into system...\n");
    pm_init();  //物理页面初始化
    kernel_vm_init();   //内核页表初始化
    
    start_paging();     //启动保护模式

    proc_list_init();   //进程池初始化
    trap_init();    //trap初始化，设置内核态特权寄存器
   
#ifndef QEMU    //如果不是运行在qemu上(即是运行在k210上)
    fpioa_pin_init();   //fpioa初始化
    sdcard_init();  //sd卡驱动初始化
#endif
    buffer_init();  //磁盘缓冲区初始化
    fat32_init();   //fat32初始化
    //test_sdcard();

    

    insert_to_runnable_queue(load_user_programe()); //加载第一个用户进程进入内存(临时这样，之后可改)
    //test_for_read_entry_form_disk();

    schedule(); //进入schedule开始调度进程
}


 /*
编译时，会生成两个简单的进程：test、main
在target目录下可以找到这两个可执行文件
这两个程序主要是为了测试exec系统调用
启动OS前，须先将test和mian写入sd卡的根目录下
之后，OS会加载test作为1号进程，test会打印字符串会执行exec加载main程序，最后main打印"Hello world\n"字符串，然后死循环
test、main源码放在user目录中
如果能正确打印字符串则运行成功
 */
 //加载第一个用户进程进入内存(临时这样，之后可改)
process* load_user_programe(){
    process* proc=alloc_process();  //从内存池获取一个新进程
    
    fat32_dirent* de=find_dirent(NULL,"/test"); //在sd卡根目录中找到test可执行文件
    char* code=alloc_physical_page();   //分配一页
    elf64_header hdr;
    elf64_prog_header phdr;

    read_by_dirent(de,&hdr,0,sizeof(elf64_header));     //读取elf_header

    proc->trapframe->epc=hdr.entry;     //确定进程入口地址

    read_by_dirent(de,&phdr,hdr.ph_off,sizeof(elf64_prog_header));  //读取elf_prog_header
    read_by_dirent(de,code,phdr.offset,phdr.file_size); //将程序段读入内存
    proc->size=phdr.file_size;  //设置程序大小
    user_vm_map(proc->pagetable,phdr.va,PGSIZE,(uint64)code,
        pte_permission(1,1,1,1));   //地址映射入页表
    //更新segment_map_info
    proc->segment_map_info[3].va=phdr.va;   
    proc->segment_map_info[3].page_num=1;
    proc->segment_map_info[3].seg_type=CODE_SEGMENT;
    proc->segment_num++;
    release_dirent(de); //释放目录项缓冲区

    proc->cwd=find_dirent(NULL,"/");    //设置工作目录为根目录

    return proc;    //返回该进程
}


uint8 buf[BSIZE];
// A simple test for sdcard read/write test
void test_sdcard(void) {
    /*
    fat32_dirent* de=find_dirent(NULL,"/main");
    if(de!=NULL){
        int ret=read_by_dirent(de,buf,120,1200);
        printk("off: 120, rsize: 1200 ,ret: %d\n",ret);
    }
    release_dirent(de);
	*/
    sdcard_read_sector(buf,0);
    for(int i=0;i<BISZE;i++){
        if(i%16==0)printk("\n");
        printk("%x ",buf[i]);
    }
    while (1) ;
}
