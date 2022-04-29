#include "include/process.h"
#include "include/elf.h"
#include "include/pm.h"
#include "include/vm.h"
#include "include/fat32.h"
#include "include/string.h"
#include "include/printk.h"
#include "include/pmlayout.h"

extern char trampoline[];

static int load_prog_segment(pagetable_t pagetable, dirent *de, elf64_prog_header *phdr){
    if(phdr->va % PGSIZE !=0)
        panic("load_prog_segment: va is not page aligned\n");

    uint64 va,pa;
    int perm=0,pg_cnt=0;

    perm|=(PAGE_READ|PAGE_EXEC|PAGE_WRITE);
    perm=pte_permission(perm,1);
    
    for(va=phdr->va;pg_cnt*PGSIZE<phdr->file_size;va+=PGSIZE,pg_cnt++){
        pa=(uint64)alloc_physical_page();
        if(!pa){
            //missing page fault
            panic("page miss\n");
        }

        user_vm_map(pagetable,va,PGSIZE,pa,perm);

        uint sz=PGSIZE;
        if(phdr->file_size-pg_cnt*PGSIZE<PGSIZE)
            sz=phdr->file_size-pg_cnt*PGSIZE;

        if(read_by_dirent(de,(void*)pa,phdr->offset+pg_cnt*PGSIZE,sz)!=sz){
            return -1;
        }
    }

    return pg_cnt;
}

static void clear_proc_pages(process *current){
    for(int i=0;i<current->segment_num;i++){
            segment_map_info* seg=current->segment_map_info+i;
            if(seg->seg_type==CODE_SEGMENT || seg->seg_type==DATA_SEGMENT || seg->seg_type==STACK_SEGMENT)
                user_vm_unmap(current->pagetable, seg->va,seg->page_num*PGSIZE,1);
            else if(seg->seg_type==TRAPFRAME_SEGMENT || seg->seg_type==SYSTEM_SEGMENT)
                user_vm_unmap(current->pagetable, seg->va,seg->page_num*PGSIZE,0);
        }
        
    free_pagetable(current->pagetable);
}

static int clear_proc_segment_map(segment_map_info *segment_map_info, int segment_num){
    for(int i=segment_num;i>=0;i++){
        if(segment_map_info[i].seg_type==CODE_SEGMENT ||
            segment_map_info[i].seg_type==DATA_SEGMENT){
                segment_num--;
        }
        else
            break;
    }
    return segment_num;
}

int do_exec(char *path, char **argv){
    //temporary
    if(argv!=NULL)
        return -1;
    
    dirent *de;
    pagetable_t pagetable;
    elf64_header hdr;

    int temp_seg_num=current->segment_num;
    segment_map_info *temp_map=(segment_map_info*)alloc_physical_page();
    if(temp_map==NULL)
        return -1;
    memcpy(temp_map,current->segment_map_info,temp_seg_num*sizeof(segment_map_info));
    temp_seg_num=clear_proc_segment_map(temp_map,temp_seg_num);

    pagetable=(pagetable_t)alloc_physical_page();
    if(pagetable==NULL){
        free_physical_page(temp_map);
        return -1;
    }
    memset(pagetable,0,PGSIZE);

    de=find_dirent(current->cwd,path);
    if(de==NULL){
        return -1;
        free_physical_page(temp_map);
        free_pagetable(pagetable);
    }
    
    if(
        read_by_dirent(de,&hdr,0,sizeof(elf64_header))!=sizeof(elf64_header) ||
        hdr.magic!=ELF_MAGIC
    ){
        free_physical_page(temp_map);
        release_dirent(de);
        free_pagetable(pagetable);
        return -1;
    }
    
    elf64_prog_header phdr;
    uint64 sz=0;
    for(int i=0,psz=sizeof(elf64_prog_header);i<hdr.ph_num;i++){
        if(
            read_by_dirent(de,&phdr,hdr.ph_off+i*psz,psz)!=psz ||
            phdr.mem_size!=phdr.file_size ||
            phdr.va+phdr.mem_size<phdr.va
        ){
            free_physical_page(temp_map);
            release_dirent(de);
            free_pagetable(pagetable);
            return -1;
        }
        else if(phdr.type!=ELF_PROG_LOAD)
            continue;
        
        int pg_cnt=load_prog_segment(pagetable,de,&phdr);
        if(pg_cnt<0){
            free_physical_page(temp_map);
            release_dirent(de);
            free_pagetable(pagetable);
            return -1;
        }
        if(phdr.va>=sz)
            sz=phdr.va+phdr.mem_size;

        temp_map[temp_seg_num].page_num=pg_cnt;
        temp_map[temp_seg_num].va=phdr.va;
        temp_map[temp_seg_num].seg_type=
            phdr.flags & ELF_PROG_FLAG_EXEC ? CODE_SEGMENT : DATA_SEGMENT;
        temp_seg_num++;
    }
    
    uint64 user_stack=(uint64)alloc_physical_page();
    if(!user_stack){
        free_physical_page(temp_map);
        release_dirent(de);
        free_pagetable(pagetable);
        return -1;
    }
    user_vm_map(pagetable,USER_STACK_TOP-PGSIZE,PGSIZE,user_stack,
        pte_permission((PAGE_READ | PAGE_WRITE),1));
    
    for(int i=0;i<temp_seg_num;i++){
        if(temp_map[i].seg_type==STACK_SEGMENT){
            temp_map[i].va=USER_STACK_TOP-PGSIZE;
            temp_map[i].page_num=1;
            break;
        }
    }
    
    //handle argv
    //to do
    
    //update segment map
    clear_proc_pages(current);
    segment_map_info *old_map=current->segment_map_info;
    current->segment_map_info=temp_map;
    current->segment_num=temp_seg_num;

    //finally,update pcb
    user_vm_map(pagetable,TRAMPOLINE,PGSIZE,(uint64)trampoline,
        pte_permission((PAGE_READ | PAGE_EXEC),0));
    user_vm_map(pagetable,TRAPFRAME,PGSIZE,(uint64)current->trapframe,
        pte_permission((PAGE_READ | PAGE_WRITE),0));
    current->pagetable=pagetable;
    current->trapframe->epc=hdr.entry;
    current->size=sz;
    current->trapframe->regs.sp=USER_STACK_TOP;

    release_dirent(de);
    free_physical_page(old_map);
    return 0;
}
