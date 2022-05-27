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
#include "include/plic.h"
#include "include/console.h"
#include "include/device.h"
#include "include/inode.h"

#ifndef QEMU
#include "sd/include/fpioa.h"
//#include "sd/include/dmac.h"
#include "sd/include/sdcard.h"
#include "include/fat32.h"
#endif



/*
初始化OS
entry.S跳转到此
*/

extern char trampoline[];
void return_to_user();

void user_trap();

process* load_user_programe();      //加载第一个进程，现已不用
//void test_sd(void);     //sd卡测试函数，临时编写在此


/*
void test_for_read_entry_form_disk()
{
    
    
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


    fat32_dirent * a = find_dirent(NULL,"/111111111.4444444444.667788/qwerty");
    printk("\n%s\n",a->name);
    printk("%x\n",a->file_size);
    printk("%x\n",a->start_clusterno);
    printk("%x\n",a->total_clusters);
    printk("%x\n",a->offset_in_parent);
    printk("%x\n",a->attribute);

    
    

    

    

    
}
*/
/*
char longname[FILE_NAME_LENGTH] = "";

void test_for_create_entry()
{
   
    char longname[FILE_NAME_LENGTH] = "test_create1.txt";

    // 创建测试
    fat32_dirent*p= find_dirent(NULL,"/");
    printk("[ 1 ] before create dir name: %s, start_clusterno: %d  file_size: %d\n parent_clus:%d, offset_in_parent:%d\n\n",p->name,p->start_clusterno,p->file_size,
                                                p->clusterno_in_parent,p->offset_in_parent);
    
    
    if(0 == create_by_dirent(p,longname,ATTR_ARCHIVE))
    {
        printk("创建成功\n");
    }
    else{
        printk("fail\n");
    }
   

    printk("[ 2 ] after create  dir name: %s, start_clusterno: %d  file_size: %d\n parent_clus:%d, offset_in_parent:%d\n\n",p->name,p->start_clusterno,p->file_size,
                                                p->clusterno_in_parent,p->offset_in_parent);
    release_dirent(p);

    //error 创建的文件，find_dirent 发生报错
    p = find_dirent(NULL,"/test_create.txt");
    printk("[ 2.2 ] after create  dir name: %s, start_clusterno: %d  file_size: %d\n parent_clus:%d, offset_in_parent:%d\n\n",p->name,p->start_clusterno,p->file_size,
                                                p->clusterno_in_parent,p->offset_in_parent);
    release_dirent(p);
    //pass
}


void test_for_wirte_dirent()
{

    //写入测试
    printk("[ 3 ]   wirte by dirent start to test\n");
    fat32_dirent* add_file = find_dirent(NULL,"/test_create1.txt");
     printk("[ 5] %s file_size:%d\n",add_file->name, add_file->file_size);
    char src[] = "test file write and read";
    write_by_dirent2(add_file,src,add_file->file_size,strlen(src));
    printk("[ 6 ] %s file_size:%d\n",add_file->name, add_file->file_size);
    release_dirent(add_file);

    printk("[ 7 ] wirte by dirent end\n");

    //pass


}


void test_for_read_dirent()
{
    
 //读取测试
    printk("[ 8 ]   wirte by dirent start to test\n");
    fat32_dirent* add_file = find_dirent(NULL,"/test_create1.txt");
    char buf[100];
    int ret =  read_by_dirent(add_file,buf,0,100);
    printk("[ 9 ]  read len %d\n",ret);
    printk("[ 10 ]  read by dirent ##### \n");
    for(int i = 0;i<ret;i++)
    {
        printk("%x ",buf[i]);
        if((i+1)%16==0)
             printk("\n");
    }
    release_dirent(add_file);
    printk("\n");
    //pass
}


void test_for_del_dirent()
{
    
    //删除测试 by dirent ##### \n");
    printk("[ 11 ]  del by dirent start \n");
    fat32_dirent* add_file = find_dirent(NULL,"/test_create.txt");
    int ret = delete_by_dirent(add_file);
    release_dirent(add_file);

    if(NULL == find_dirent(NULL,"/test_for_create"))
        printk("[12] delete success!\n");
    printk("[ 13 ]  del by dirent  \n");
    //pass
}
*/



//entry.S跳转到s_start
void s_start(){
    printk("entering into system...\n");
    
    console_init();
    device_init();

    pm_init();  //物理页面初始化
    kernel_vm_init();   //内核页表初始化
    
    start_paging();     //启动保护模式

    proc_list_init();   //进程池初始化
    trap_init();    //trap初始化，设置内核态特权寄存器
    plic_init_temp();
#ifndef QEMU    //如果不是运行在qemu上(即是运行在k210上)
    fpioa_pin_init();   //fpioa初始化
    //dmac_init();    //dmac初始化
    sdcard_init();  //sd卡驱动初始化
#endif
    buffer_init();  //磁盘缓冲区初始化
    fat32_init_i();   //fat32初始化

    //test_for_create_entry();
    //test_for_wirte_dirent();
    //test_for_read_dirent();

    //test_for_del_dirent();
    //while(1) {};

    load_user_proc();   //加载init进程
    //insert_into_queue(&runnable_queue,load_user_programe());
    schedule(); //进入schedule开始调度进程
}


 //加载第一个用户进程进入内存，测试用
/*
process* load_user_programe(){
    process* proc=alloc_process();  //从内存池获取一个新进程
    
    fat32_dirent* root=find_dirent(NULL,"/");    //设置工作目录为根目录

    fat32_dirent* de=find_dirent(root,"/brk"); //在sd卡根目录中找到init可执行文件
    char* code=alloc_physical_page();   //分配一页
    elf64_header hdr;
    elf64_prog_header phdr;

    read_by_dirent_i(de,&hdr,0,sizeof(elf64_header));     //读取elf_header

    proc->trapframe->epc=hdr.entry;     //确定进程入口地址

    read_by_dirent_i(de,&phdr,hdr.ph_off,sizeof(elf64_prog_header));  //读取elf_prog_header
    read_by_dirent_i(de,code,phdr.offset,phdr.file_size); //将程序段读入内存

    proc->size=phdr.file_size;  //设置程序大小
    user_vm_map(proc->pagetable,phdr.va,PGSIZE,(uint64)code,
        pte_permission(1,1,1,1));   //地址映射入页表
    //更新segment_map_info
    proc->segment_map_info[proc->segment_num].va=phdr.va;   
    proc->segment_map_info[proc->segment_num].page_num=1;
    proc->segment_map_info[proc->segment_num].seg_type=CODE_SEGMENT;
    proc->segment_num++;
    release_dirent_i(de); //释放目录项缓冲区    

    proc->cwd=root;

    proc->state=READY;

    proc->parent=proc;

    return proc;    //返回该进程
}



uint32 clusterno_to_sectorno(uint32 clusterno);
void clear_cluster(uint32 clusterno);
uint32 alloc_cluster();
uint32 fat_find_next_clusterno(uint32 clusterno, uint32 fatno);
void fat_update_next_clusterno(uint32 clusterno, uint32 next_clusterno, uint32 fatno);
int create_by_dirent(fat32_dirent *parent,char * name, uint8 attribute);
// A simple test for sdcard read/write test
char buf[512]="abcdefgm\0";
void test_sd(void) {
    fat32_dirent *de=find_dirent(NULL,"/mnt");
    
    
    
    //memset(buf,'a',511);
    //buf[511]=0;
    //fat32_dirent *de=find_dirent(NULL,"/text.txt");
    printk("sz=%d\n",de->file_size);
    printk("prt=%d\n",de->clusterno_in_parent);
    printk("cls=%d\n",de->start_clusterno);

    //read_by_dirent(de,buf,200,de->file_size);
    

    //fat32_dirent *root=find_dirent(NULL,"/");

    //printk("root c:%d\n",root->start_clusterno);

    //int sz=write_by_dirent(de,buf,de->file_size,512);

    //printk("new sz=%d\n",sz);

    //printk(buf);

    //release_dirent(de);

    while (1) ;
}
*/
