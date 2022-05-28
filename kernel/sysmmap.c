#include "include/sysmmap.h"
#include "include/printk.h"
#include "include/process.h"
#include "include/file.h"
#include "include/pm.h"
#include "include/vm.h"
#include "include/riscv.h"
#include "include/inode.h"
#include "include/string.h"
// 寻找空闲的mmap_area 存放信息
static int acquire_mmap_areas(void* start,size_t len,int port,int flags,int fd,off_t offset)
{
    /*
    if (current->mmap_va_availbale == 0) // 初始化，推迟到此处
    {
        printk("mmap_va_availbale init \n");
        current->mmap_va_availbale  = MMAP_START_VA;
    }
*/
    for(int i =0;i<MMAP_NUM;i++)
    {
        
        if(current->mmap_areas[i].used == 0)
        {  // 寻找未使用的mmap_areas存放信息
            if(start == NULL)
            {   
                
                current->mmap_areas[i].start = current->mmap_va_availbale;
                //printk("mmap_va_availbale %x\n",current->mmap_va_availbale);
            }
            else
            {
                current->mmap_areas[i].start = start;
            }
            
            current->mmap_areas[i].len = len;
            current->mmap_areas[i].port = port;
            current->mmap_areas[i].flags = flags;
            current->mmap_areas[i].fd = fd;
            current->mmap_areas[i].offset = offset;
            file * f = current->open_files[fd];
            current->mmap_areas[i].used = 1;
            file_dup(f); // 增加引用数量
            return i;
        }
    }
    return -1;
}

// 根据映射的起始地址 寻找mmap_area结构体偏移
static int find_mmap_areas(uint64 start,int len)
{
    for(int i =0;i<MMAP_NUM;i++)
    {
        if(current->mmap_areas[i].start== start && current->mmap_areas[i].len== len )
        {  
            return i;
        }
    }
    return -1;
}



uint64 do_mmap(void* start,size_t len,int port,int flags,int fd,off_t offset)
{
    //printk("[ 1 ]do mmap start\n");
    uint64 err = 0xffffffffffffffff;
    
    if(fd < 0 || offset <0 || len <0 || (uint64)start < 0)
        return err; // 异常情况

    if(start != NULL && current->mmap_va_availbale+len > MMAP_END_VA)
        return err; // 暂时只接受系统自动分配的内存大小 且超出映射允许范围 直接报错

    // 选择合适的 mmap_area 存放信息
    int mmap_area_offset =  acquire_mmap_areas(start, len, port, flags, fd, offset);
    if(-1 == mmap_area_offset) // 存储信息，增加引用数量
        return err; // 无可用的 mmap_area

    fat32_dirent* file_to_mmap = current->open_files[fd]->fat32_dirent; //需要映射的文件
    if(offset + len > file_to_mmap->file_size)   //映射的文件长度 大于 实际的 文件长度
        return err; //避免非法溢出
    uint tot_size = len;// 需要映射的文件大小 
    // 分配并映射足够的内存空间

    int page_num = (tot_size + PGSIZE -1) / PGSIZE; //分配的页数，向上取证

    //权限设置

    int permission  = PTE_U;//用户态可访问
    if(port& PROT_READ) 
        permission  |= PTE_R;//读权限
    if(port& PROT_WRITE)
        permission  |= PTE_W;//写权限
    if(port&PROT_EXEC)
        permission  |= PTE_X;//执行权限

      
    uint64 start_mmap_addr = current->mmap_va_availbale; // 开始映射的虚拟地址，注意写回  
    

    uint off = offset;// 写入的偏移
    uint size = PGSIZE;
    if( tot_size<= PGSIZE)
        size = tot_size ; // 如果不足一页，那么size全部要写的文件长度


    for(int i =0;i<page_num;i++)
    {
        void * pa =alloc_physical_page(); // 分配一页物理地址
        memset(pa,0,PGSIZE);
        user_vm_map(current->pagetable,start_mmap_addr,PGSIZE,pa,permission); //映射
        read_by_dirent_i(file_to_mmap,pa,off,size); // 往内存空间中写入文件内容  直接对内核地址写入
        // segments 记录
        
        start_mmap_addr +=PGSIZE;
        off+=size;
        if(tot_size - size <PGSIZE)
        {
            tot_size -= size; 
            size = tot_size - size ;
        }
        else
        {
            tot_size -= PGSIZE;
            size = PGSIZE;
        }

    }

    //段记录,递增记录
    current->segment_map_info[current->segment_num].va = current->mmap_va_availbale;
    current->segment_map_info[current->segment_num].page_num = page_num;
    current->segment_map_info[current->segment_num].seg_type = MMAP_SEGMENT;
    current->segment_num++;
   
    current->mmap_va_availbale = start_mmap_addr ; 
    //printk("ret mmap va %x\n",current->mmap_areas[mmap_area_offset].start);
    //printk("[ 10 ]do mmap end\n");
    return current->mmap_areas[mmap_area_offset].start;
}

//寻找到 segments map info 
static int find_segments_map_info(uint64 start_va)
{

    for (int  i = 0; i <current->segment_num ; i++)
    {
        if(current->segment_map_info[i].va ==start_va  && 
            current->segment_map_info[i].page_num !=0  &&
            current->segment_map_info[i].seg_type==MMAP_SEGMENT)
        {// 起始地址 正确，且有效
            return i;
        }

    }
    return -1;

}



int do_munmap(void* start,size_t len)
{
    //printk("[ 11 ]do munmap start\n");
    uint64 err = 0xffffffffffffffff;
    if(len <0 || (uint64)start < 0)
        return err; // 异常情况


    uint64 start_va =(uint64)start;

    int mmap_area_offset = find_mmap_areas(start_va,len);//寻找seg 信息
    if(mmap_area_offset == -1)
    {
        //printk("mmap_area_offset unfound\n");
        return -1;// 未找到对应信息
    }
       

    int segments_map_info_off =  find_segments_map_info(start_va);//寻找mmap信息
    if(segments_map_info_off == -1)
    {
        //printk("segments_map_info_off unfound\n");
        return -1;// 未找到对应信息
    }
        

    mmap_infos* mmap_info = &(current->mmap_areas[mmap_area_offset]);//mmap信息
    segment_map_info * seg_map_info = &(current->segment_map_info[segments_map_info_off]);//seg 信息
    
    int is_writeback = mmap_info->flags & MAP_SHARED;// 是否需要写回

    // 写回准备
    int page_num = seg_map_info->page_num; // 需要写回的页数
    int start_mmap_addr = seg_map_info->va;// 开始映射的虚拟地址
    fat32_dirent* file_to_writeback =current->open_files[mmap_info->fd]->fat32_dirent;//需要写回的文件目录项
    int offset = mmap_info->offset; // 文件起始偏移
    //int len = mmap_info->len; //映射的长度
    
    int tot_size = len;//需要写回的总长度
    int off = offset;// 写回偏移
    int size = PGSIZE; //写回大小

    if(tot_size<PGSIZE)
        size=tot_size;// 如果不足一页，那么size全部要写的文件长度

    
    for(int i =0;i<page_num;i++)
    {
        void* pa = va_to_pa(current->pagetable,start_mmap_addr);// 将虚拟地址转化为物理地址
        if(is_writeback)
        {   // 写回原文件
            write_by_dirent_i(file_to_writeback,pa,off,size);
            off += size;
            if(tot_size - size <PGSIZE)
            {// 最后一页
                tot_size -= size; 
                size = tot_size - size ;
            }
            else
            {
                tot_size -= PGSIZE;
                size = PGSIZE;
            }
        }
        user_vm_unmap(current->pagetable,start_mmap_addr,PGSIZE,1);//解除映射，并收回内存页   

        start_mmap_addr+=PGSIZE;
        
    }
    mmap_info->used=0;
    release_file(current->open_files[mmap_info->fd]);

    seg_map_info->page_num = 0;
    
    //printk("[ 20 ]do munmap end\n");
    return 0;
}


//线段树