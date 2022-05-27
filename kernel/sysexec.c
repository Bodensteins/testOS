#include "include/process.h"
#include "include/elf.h"
#include "include/pm.h"
#include "include/vm.h"
#include "include/fat32.h"
#include "include/string.h"
#include "include/printk.h"
#include "include/pmlayout.h"
#include "include/inode.h"

/*
sys_exec调用do_exec
根据可执行文件名及其在文件系统中的路径，将程序加载入内存中
目前还并不能处理argv参数
*/

extern char trampoline[];   //trampoline符号声明

//以下是do_exec使用的一些工具函数的声明

//根据可执行文件目录项de和程序头phdr，将该程序段加载入内存中，并映射到页表pagetable中
static int load_prog_segment(pagetable_t pagetable, fat32_dirent *de, elf64_prog_header *phdr);
//释放current进程占用的内存
static void clear_proc_pages(process *current);
//清空segement_map_info的CODE段和DATA段
static int clear_proc_segment_map(segment_map_info *segment_map_info, int segment_num);
//argv和env压栈(int main(int argc, char argv**, char **env))
static int push_stack(pagetable_t pagetable, char **argv, int *ac);
//当发生错误时，调用该函数释放已经分配的资源
static void release_memory(pagetable_t pagetable, int sz, segment_map_info *map, fat32_dirent *de);


//根据可执行文件名和路径，将程序加载入内存中，并释放旧程序的内存
//暂时不处理argv参数，一律为NULL
int do_execve(char *path, char **argv, char **env){
    //printk("do_execve: %s\n",path);
    //temporary
    if(env!=NULL && env[0]!=NULL){
        printk("not support env yet\n");
    }

    fat32_dirent *de=NULL;   //可执行文件目录项
    pagetable_t pagetable=NULL;  //新页表
    elf64_header hdr;   //elf文件头

    //分配新的semgent_map_info
    int temp_seg_num=current->segment_num;  
    segment_map_info *temp_map=(segment_map_info*)alloc_physical_page();
    if(temp_map==NULL)
        return -1;
    memcpy(temp_map,current->segment_map_info,temp_seg_num*sizeof(segment_map_info));
    temp_seg_num=clear_proc_segment_map(temp_map,temp_seg_num);

    //为新页表分配内存
    pagetable=(pagetable_t)alloc_physical_page();
    if(pagetable==NULL){
        release_memory(pagetable,0,temp_map,de);
        return -1;
    }
    memset(pagetable,0,PGSIZE);

    //根据路径和文件名获取elf文件的目录项
    de=find_dirent_i(current->cwd,path);
    if(de==NULL){
        //printk("not found elf\n");
        release_memory(pagetable,0,temp_map,de);
        return -1;
    }
    
    //根据文件目录项读取elf文件头信息
    if(
        read_by_dirent_i(de,&hdr,0,sizeof(elf64_header))!=sizeof(elf64_header) ||
        hdr.magic!=ELF_MAGIC
    ){
        release_memory(pagetable,0,temp_map,de);
        return -1;
    }
    
    
    /*
    根据elf文件头信息(hdr)，读取所有的程序头信息(phdr)，并根据phdr读取所有的段(Segment)入内存
    我们的OS读取的elf文件目前还比较简单，一般只有一个段，因此也只有一个phdr，下面的循环一般只会执行一次
    不过不排除以后会有其他情况
    */
    elf64_prog_header phdr;
    uint64 sz=0;    //记录程序的大小
    for(int i=0,psz=sizeof(elf64_prog_header);i<hdr.ph_num;i++){
        //读取程序头信息(phdr)

        if(
            read_by_dirent_i(de,&phdr,hdr.ph_off+i*psz,psz)!=psz ||
            phdr.mem_size<phdr.file_size ||
            phdr.va+phdr.mem_size<phdr.va
        ){
            printk("memsz:%d, filesz:%d\n",phdr.mem_size,phdr.file_size);
            release_memory(pagetable,sz,temp_map,de);
            return -1;
        }
        else if(phdr.type!=ELF_PROG_LOAD)   //程序段的类型必须是可加载的
            continue;
        
       //根据可执行文件目录项de和程序头phdr，将该程序段加载入内存中，并映射到页表pagetable中
        if(phdr.va>=sz)
            sz=phdr.va+phdr.file_size;   //记录当前程序在内存中的大小
        int pg_cnt=load_prog_segment(pagetable,de,&phdr);

        if(pg_cnt<0){
            release_memory(pagetable,sz,temp_map,de);
            return -1;
        }

        //更新segment_map_info
        temp_map[temp_seg_num].page_num=pg_cnt;
        temp_map[temp_seg_num].va=phdr.va;
        temp_map[temp_seg_num].seg_type=
            phdr.flags & ELF_PROG_FLAG_EXEC ? CODE_SEGMENT : HEAP_SEGMENT;
        temp_seg_num++;
    }
    
    //接下来为进程分配用户栈
    uint64 user_stack=(uint64)alloc_physical_page();
    //printk("userstack=%p\n",(void*)user_stack);
    if(!user_stack){
        release_memory(pagetable,sz,temp_map,de);
        return -1;
    }
    //在页表中映射栈的地址
    user_vm_map(pagetable,USER_STACK_TOP-PGSIZE,PGSIZE,user_stack,
        pte_permission(1,1,0,1));
    user_vm_map(pagetable,USER_STACK_TOP,PGSIZE,(uint64)alloc_physical_page(),
        pte_permission(1,1,0,1));
    //更新segment_map_info
    for(int i=0;i<temp_seg_num;i++){
        if(temp_map[i].seg_type==STACK_SEGMENT){
            temp_map[i].va=USER_STACK_TOP-PGSIZE;
            temp_map[i].page_num=2;
            break;
        }
    }

    //接下来处理argv参数，并将其压入用户栈
    int argc=0;
    uint64 sp=USER_STACK_TOP;
    if(argv!=NULL){
        sp=push_stack(pagetable,argv,&argc);

        if(sp<0){
            release_memory(pagetable,sz,temp_map,de);
            return -1;
        }
        current->trapframe->regs.a1=sp;
    }

    //接下来清理进程之前的内存
    clear_proc_pages(current);

    //将新的segment_map_info交给当前进程
    segment_map_info *old_map=current->segment_map_info;
    current->segment_map_info=temp_map;
    current->segment_num=temp_seg_num;

    //最后更新process结构体
    //将trampoline和trapframe都映射到新页表上
    user_vm_map(pagetable,TRAMPOLINE,PGSIZE,(uint64)trampoline,
        pte_permission(1,0,1,0));
    user_vm_map(pagetable,TRAPFRAME,PGSIZE,(uint64)current->trapframe,
        pte_permission(1,1,0,0));
    current->pagetable=pagetable;   //启用新页表
    current->trapframe->epc=hdr.entry;  //epc寄存器设置为程序入口的虚拟地址，使得之后进入用户态可以跳到新程序开头
    current->size=sz;   //进程大小
    current->trapframe->regs.sp=sp; //sp寄存器设为栈底

    memset(current->name,0,50);
    memcpy(current->name,"/inexec\0",8);

    release_dirent_i(de); //释放目录项缓冲
    free_physical_page(old_map);    //释放旧的segment_map_info
    return argc;
}

//根据可执行文件目录项de和程序头phdr，将该程序段加载入内存中，并映射到页表pagetable中
static int load_prog_segment(pagetable_t pagetable, fat32_dirent *de, elf64_prog_header *phdr){
    //起始地址必须页对齐
    if(phdr->va % PGSIZE !=0){
        printk("va :%p\n",(void*)phdr->va);
        panic("load_prog_segment: va is not page aligned\n");
    }

    uint64 va,pa;
    int perm=0,pg_cnt=0;

    //pte属性设置为可读、可写、可执行、用户使用
    perm=pte_permission(1,1,1,1);
    
    //循环读取该程序段的内容
    for(va=phdr->va;pg_cnt*PGSIZE<phdr->file_size;va+=PGSIZE,pg_cnt++){
        //分配物理页
        pa=(uint64)alloc_physical_page();
        if(!pa){
            //missing page fault
            panic("page miss\n");
        }

        //地址映射到页表中
        user_vm_map(pagetable,va,PGSIZE,pa,perm);

        //确定需要读取的字节数量
        uint sz=PGSIZE;
        if(phdr->file_size-pg_cnt*PGSIZE<PGSIZE)
            sz=phdr->file_size-pg_cnt*PGSIZE;

        int sz1;
        //读取elf文件中的内容
        if((sz1=read_by_dirent_i(de,(void*)pa,phdr->offset+pg_cnt*PGSIZE,sz))!=sz){
            printk("sz=%d\n, sz1=%d\n",sz,sz1);
            return -1;
        }
    }

    return pg_cnt;
}

//释放current进程占用的内存
static void clear_proc_pages(process *current){
    //根据segment_map_info释放进程占用的内存
    for(int i=0;i<current->segment_num;i++){
            segment_map_info* seg=current->segment_map_info+i;
            //释放堆段、栈段
            if(seg->seg_type==HEAP_SEGMENT || seg->seg_type==STACK_SEGMENT)
                user_vm_unmap(current->pagetable, PGROUNDUP(seg->va),seg->page_num*PGSIZE,1);
            //如果是trapframe或trampoline段，则不释放，只是解除地址映射
            else if(seg->seg_type==TRAPFRAME_SEGMENT || seg->seg_type==SYSTEM_SEGMENT || seg->seg_type==CODE_SEGMENT)
                user_vm_unmap(current->pagetable, PGROUNDUP(seg->va),seg->page_num*PGSIZE,0);
        }
    //释放页表占用的内存
    free_pagetable(current->pagetable);
}

//清空segement_map_info的CODE段和DATA段
//实际上CODE和DATA在elf里面是一个段
static int clear_proc_segment_map(segment_map_info *segment_map_info, int segment_num){
    for(int i=segment_num-1;i>=0;i++){
        if(segment_map_info[i].seg_type==CODE_SEGMENT ||
            segment_map_info[i].seg_type==HEAP_SEGMENT){
                segment_num--;
        }
        else
            break;
    }
    return segment_num;
}

static int push_stack(pagetable_t pagetable, char **argv, int *ac){
    uint64 sp=USER_STACK_TOP, sb=USER_STACK_TOP-PGSIZE;
    uint64 argv_ptr[MAXARG+1];
    int argc;
    for(argc=0;argv[argc]!=NULL && argc<MAXARG;argc++){
        int arglen=strlen(argv[argc])+1;
        sp-=arglen;
        sp-=(sp%16);    // riscv sp must be 16-byte aligned
        if(sp<sb){
            //bad
            return -1;
        }
        //copy argv into stack
        char* sp_pa=va_to_pa(pagetable,(char *)sp);
        memcpy(sp_pa,argv[argc],arglen);
        argv_ptr[argc]=sp;
    }
    argv_ptr[argc]=0;
    *ac=argc;

    int argclen=(argc+1)*sizeof(uint64);
    sp-=argclen;
    sp-=(sp%16);
    if(sp<sb){
        //bad
        return -1;
    }
    //copy argv_ptr into stack
    char* sp_pa=va_to_pa(pagetable,(char *)sp);
    memcpy(sp_pa,argv_ptr,argclen);
    return sp;
}

static void release_memory(pagetable_t pagetable ,int sz, segment_map_info *map, fat32_dirent *de){
    printk("execve error\n");
    if(pagetable!=NULL && sz>=0){
        user_vm_unmap(pagetable,USER_STACK_TOP-PGSIZE,PGSIZE,1);
        free_pagetable2(pagetable,sz,1);
    }
    if(map!=NULL)
        free_physical_page(map);
    if(de!=NULL)
        release_dirent_i(de);
}