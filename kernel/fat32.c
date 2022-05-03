#include "include/fat32.h"
#include "include/buffer.h"
#include "include/string.h"
#include "include/printk.h"

/*
目前实现的功能仅仅包括文件的读取
没有文件的写入、创建、删除，对目录的操作也仅仅是读取目录项
没有同步控制，锁还没有派上用场
且只支持段文件目录项(名字不超过8字节，扩展名不超过3字节)
不区分大小写
*/

/*
代码里面把“簇”写成了block，
虽然“簇”应该翻译为cluster，
而block应该是“块”，
不过这两个概念本质上没有区别，只是不同的OS叫法不一样，
并且因为我们是仿的UNIX的系统调用，所以用了block，但都是一个意思
*/

/*
文件系统相关依赖为：
    syscall.c-->file.c-->fat32.c-->buffer.c-->sd/sdcard.c(k210官方的sd卡驱动)-->底层驱动
*/


//暂时将sd卡设备号设为0
#ifndef DEVICE_DISK_NUM
#define DEVICE_DISK_NUM 0
#endif



//sd卡一般只有一个分区
FAT32_MBR_DPT mbr_info; //mbr信息
FAT32_DBR dbr_info; //dbr信息

//LRU cache
//目录项缓冲区
static fat32_dirent_cache dcache;

/*
根据字节码判断是否为MBR
1 为 MBR
0 为 DBR
*/
int is_MBR(buffer *buf)
{
    uint8* data = buf->data;
    if(data[0]==JMP_CODE_0x0 \ 
        && data[1]==JMP_CODE_0x1 && data[2]==JMP_CODE_0x2) // EB 58 90 DBR 跳转指令
        return 0;

    return 1;
}

/*
从buf中解析分区信息


*/
int MBR_DPT_info(buffer *buf)
{


    return 0;

}


//fat32文件系统相关初始化，在OS启动时调用
void fat32_init(){
    buffer *buf;

    //读取mbr信息，0号扇区为mbr
    buf=acquire_buffer(DEVICE_DISK_NUM,0);
    //读取dbr起始的扇区号
    memcpy(&mbr_info.dbr_start_sector,buf->data+MBR_DBR_START_SECTOR_OFFSET,sizeof(uint32));//使用memcpy函数代替赋值，防止k210报错
    //读取磁盘总扇区数
    memcpy(&mbr_info.total_sectors,buf->data+MBR_TOTAL_SECORS_OFFSET,sizeof(uint32));
    release_buffer(buf);
    
    //读取dbr信息，根据mbr_info中的dbr_start_sector找到dbr所在扇区
    buf=acquire_buffer(DEVICE_DISK_NUM,mbr_info.dbr_start_sector);
    //读取每扇区的字节数
    memcpy(&dbr_info.bytes_per_sector,buf->data+DBR_BYTES_PER_SECTOR_OFFSET,sizeof(uint16));
    //检查每扇区字节数是否等于512字节
    if(dbr_info.bytes_per_sector!=BSIZE)
        panic("bytes_per_sector is not 512\n");
    //以下均是从dbr扇区中读取相应字段来初始化dbr_info，标注几个重要的
    dbr_info.sectors_per_block=*((uint8*)(buf->data+DBR_SECTORS_PER_BLOCK_OFFSET));  //每簇的扇区数
    dbr_info.dbr_reserve_sectors=*((uint16*)(buf->data+DBR_RESERVE_SECTORS_OFFSET));    //dbr保留扇区数(dbr之后就是fat表)
    dbr_info.total_fats=*((uint8*)(buf->data+DBR_TOTAL_FATS_OFFSET));   //fat个数
    dbr_info.hidden_sectors=*((uint32*)(buf->data+DBR_HIDDEN_SECTORS_OFFSET));  
    dbr_info.fs_total_sectors=*((uint32*)(buf->data+DBR_FS_TOTAL_SECTORS_OFFSET));
    dbr_info.sectors_per_fat=*((uint32*)(buf->data+DBR_SECTORS_PER_FAT_OFFSET));    //每个fat占用的扇区数
    dbr_info.root_dir_blockno=*((uint32*)(buf->data+DBR_ROOT_DIR_BLOCK_OFFSET));    //根目录所在簇号
    dbr_info.fsinfo_sector=*((uint16*)(buf->data+DBR_FSINFO_SECTOR_OFFSET));   
    dbr_info.dbr_backup_sector=*((uint16*)(buf->data+DBR_BACKUP_SECTOR_OFFSET));
    release_buffer(buf);
    
    //初始化根目录的目录项
    memset(&dcache.root_dir,0,sizeof(dcache.root_dir));
    dcache.root_dir.attribute=ATTR_DIRECTORY;
    //dcache.root_dir.current_blockno=dbr_info.root_dir_blockno;
    dcache.root_dir.dev=DEVICE_DISK_NUM;
    dcache.root_dir.start_blockno=dbr_info.root_dir_blockno;
    memcpy(dcache.root_dir.name,"/",1);
    init_sleeplock(&dcache.root_dir.sleeplock,"root fat32_dirent");
    
    //dcache init
    //参照buffer.c中的bcache，也将dcache中的目录项(fat32_dirent)组织为双向循环链表
    init_spinlock(&dcache.spinlock, "dcache");
    dcache.root_dir.prev=&dcache.root_dir;
    dcache.root_dir.next=&dcache.root_dir;
    for(int i=0;i<DIRENT_LIST_LENGTH;i++){
        (dcache.dirent_list+i)->valid=0;
        (dcache.dirent_list+i)->dev=0;
        (dcache.dirent_list+i)->ref_count=0;
        (dcache.dirent_list+i)->parent=NULL;
        init_sleeplock(&(dcache.dirent_list+i)->sleeplock,"fat32_dirent");
        (dcache.dirent_list+i)->next=dcache.root_dir.next;
        (dcache.dirent_list+i)->prev=&dcache.root_dir;
        dcache.root_dir.next->prev=(dcache.dirent_list+i);
        dcache.root_dir.next=(dcache.dirent_list+i);
    }
}

//工具函数，作用是将簇号(blockno)转换为该簇的第一个扇区的扇区号(sectorno)
static uint32 blockno_to_sectorno(uint32 blockno){
    int sectorno=mbr_info.dbr_start_sector+dbr_info.dbr_reserve_sectors;
    sectorno+=dbr_info.sectors_per_fat*dbr_info.total_fats;
    sectorno+=dbr_info.sectors_per_block*(blockno-dbr_info.root_dir_blockno);
	return sectorno;
}

//工具函数，作用是将扇区号(sectorno)转换为其所在簇的簇号(blockno)
//由于目前暂未使用这个函数，而makefile中开启了将warning转换为error的选项，保留该函数会导致编译不通过，因此先注释掉
/*
static uint32 sectorno_to_blockno(uint32 sectorno){
    int blockno=sectorno-mbr_info.dbr_start_sector;
    blockno+=dbr_info.dbr_reserve_sectors;
    blockno+=dbr_info.sectors_per_fat*dbr_info.total_fats;
    blockno/=dbr_info.sectors_per_block+2;
    return blockno;
}
*/

//工具函数，给定簇号(blockno)和第几个fat表(fatno取1或2)，返回该簇号在fat表中对应位置的扇区号
//这个函数用于fat_find_next_blockno函数中
static inline uint32 fat_blockno_to_sectorno(uint32 blockno, uint32 fatno){
    return 4*blockno/dbr_info.bytes_per_sector+mbr_info.dbr_start_sector+
        dbr_info.dbr_reserve_sectors+dbr_info.sectors_per_fat*(fatno-1);
}

//工具函数，给定簇号(blockno)和第几个fat表(fatno取1或2)，返回该簇号在fat表中对应扇区中的偏移
//这个函数用于fat_find_next_blockno函数中
static inline uint32 fat_blockno_to_offset(uint32 blockno){
    return (4*blockno)%dbr_info.bytes_per_sector;
}

//给定一个簇号blockno以及fat表号(fatno取1或2，表示第1或第2个fat表)
//返回该簇所对应的下一个簇号，如果是文件中的最后一个簇则返回0x0fffffff
//具体原理请参考fat32格式说明
static uint32 fat_find_next_blockno(uint32 blockno, uint32 fatno){
    if(blockno==FAT_BLOCK_END || blockno==FAT_BLOCK_DAMAGE)
        return blockno;

    //以下步骤就是在定位该blockno的下一个blockno在磁盘中的位置(扇区号+扇区内偏移)
    uint32 sec=fat_blockno_to_sectorno(blockno, fatno);
    if(sec>=mbr_info.dbr_start_sector+dbr_info.dbr_reserve_sectors+dbr_info.sectors_per_fat*fatno)
        return blockno;
    uint32 off=fat_blockno_to_offset(blockno);
    
    //找到位置后，直接返回next_blockno就行
    buffer* buf=acquire_buffer(DEVICE_DISK_NUM, sec);
    uint32 next_block=*((uint32*)(buf->data+off));
    release_buffer(buf);
    return next_block;
}

//给定一个簇号blockno，需要更新的next_blockno，以及fat表号(fatno取1或2，表示第1或第2个fat表)
//该函数将在相应fat表中把blockno对应的下一个簇号更新为next_block
//由于目前暂未使用这个函数，而makefile中开启了将warning转换为error的选项，保留该函数会导致编译不通过，因此先注释掉
/*
static void fat_update_next_blockno(uint32 blockno, uint32 next_blockno, uint32 fatno){
    uint32 sec=fat_blockno_to_sectorno(blockno, fatno);
    if(sec>=mbr_info.dbr_start_sector+dbr_info.dbr_reserve_sectors+dbr_info.sectors_per_fat*fatno)
        return;
    uint32 off=fat_blockno_to_offset(blockno);
    buffer* buf=acquire_buffer(DEVICE_DISK_NUM, sec);
    *((uint32*)(buf->data+off))=next_blockno;
    buffer_write(buf);
    release_buffer(buf);
}
*/

//测试用的，忽略这个函数。。。
uint32 fat_temp(uint32 blockno){
    return fat_find_next_blockno(blockno,1);
}

//工具函数，从fat32_short_name_dir_entry中获取文件初始簇号
static uint32 get_start_blockno_in_short_entry(fat32_short_name_dir_entry* sde){
    uint32 h=(uint32)sde->start_blockno_high;
    uint32 l=(uint32)sde->start_blockno_low;
    return (h<<16)+l;
}

//工具函数，从fat32_short_name_dir_entry中获取文件全名("文件名.扩展名")
//由于目前并未实现长文件名目录项的处理，因此文件名长度不能超过8字节，扩展名长度不能超过3字节
//下面都是字符串处理，不赘述了
//注意，fat32目录项中，如果文件名未满8字节或扩展名未满3字节，剩下的内容用0x20(ASCII码)填充
static void get_full_short_name(fat32_short_name_dir_entry* sde,char* full_name){
    memset(full_name,0,FILE_NAME_LENGTH+1);
    memcpy(full_name,sde->name,SHORT_NAME_LENGTH);
    int point=-1;
    for(int i=0;i<SHORT_NAME_LENGTH;i++){
        if(full_name[i]==0x20){
            full_name[i]=0;
            if(point==-1)
                point=i;
        }
    }
    if(point==-1)
        point=SHORT_NAME_LENGTH;
    full_name[point]='.';
    memcpy(full_name+point+1,sde->extend_name,EXTEND_NAME_LENGTH);
    for(int i=1;i<=EXTEND_NAME_LENGTH;i++){
        if(full_name[point+i]==0x20){
            full_name[point+i]=0;
            if(i==1)
                full_name[point]=0;
        }
    }
}

/*
关于fat32目录项，需要说明的是:
对于fat32_dir_entry，无论是fat32_short_name_dir_entry，还是fat32_long_name_dir_entry
他们都是目录项存储在磁盘上的格式，并不适合直接拿来给OS使用
因此我们需要对其进行一些转换，使其更适合OS使用
于是就有了fat32_dirent,这个结构是直接拿给OS使用的
从磁盘中读取目录项后，都要立刻转换为fat32_dirent
同样，之后要修改目录项信息，也需要将fat32_dirent转换为fat32_dir_entry后再写入
*/


//一个比较重要的中间函数
//根据父目录项(parent)，文件名(name,包括扩展名)，读取磁盘上的目录项(fat32_dir_entry)
//并将fat32_dir_entry转换为fat32_dirent
//将信息写入des_dir指针指向的位置
static int read_dirent_from_disk(fat32_dirent* parent, char *name, fat32_dirent* des_dir){
    char full_name[FILE_NAME_LENGTH+1];
    //三层循环，分别代表簇号，簇中扇区号偏移，扇区中的偏移
    //blk为起始簇号
    for(uint32 blk=parent->start_blockno;blk!=FAT_BLOCK_END;blk=fat_find_next_blockno(blk,1)){
        uint32 start_sec=blockno_to_sectorno(blk);  //根据簇号确定簇的起始扇区号
        for(int sec_off=0;sec_off<dbr_info.sectors_per_block;sec_off++){    //遍历该簇所有扇区
            buffer *buf=acquire_buffer(DEVICE_DISK_NUM,start_sec+sec_off);  //读取扇区
            for(uint32 off=0;off<dbr_info.bytes_per_sector;off+=DIR_ENTRY_BYTES){   //遍历该扇区中每一个目录项
                fat32_dir_entry dentry;
                memcpy(&dentry,buf->data+off,DIR_ENTRY_BYTES);
                if(dentry.short_name_dentry.atrribute==ATTR_LONG_NAME){ //暂时跳过长文件名目录项
                    //panic("not support long name dentry yet\n");
                    continue;
                }
                get_full_short_name(&dentry.short_name_dentry,full_name);   //获取该目录项指向的文件的文件全名
                if(!strcmp(name,full_name)){    //与name参数比较
                    //如果名字一致，那么就算找到了
                    release_buffer(buf);    //释放缓冲区
                    //将dentry中的信息转到des_dir中
                    memcpy(des_dir->name, full_name,12);    //文件名
                    des_dir->attribute=dentry.short_name_dentry.atrribute;  //属性
                    des_dir->offset_in_parent=sec_off*dbr_info.bytes_per_sector+off;    //在父目录中的位置偏移
                    des_dir->start_blockno=get_start_blockno_in_short_entry(&dentry.short_name_dentry);     //起始簇号
                    //des_dir->current_blockno=des_dir->start_blockno;
                    des_dir->file_size=dentry.short_name_dentry.file_size;  //文件大小
                    des_dir->total_blocks=des_dir->file_size/(dbr_info.bytes_per_sector*dbr_info.sectors_per_block);    //文件总簇数
                    if(des_dir->start_blockno==0x0) //不知道为什么，sd卡中记录的根目录簇号一律是0，因此得修改
                        des_dir->start_blockno=dbr_info.root_dir_blockno;
                    return 0;
                }
            }
            release_buffer(buf);
        }
    }
    return -1;
}

/*
static void dirent_write_to_disk(fat32_dirent* dir){
    //need to be done
    
}
*/

//将指定的目录项移动至链表头部
static void move_dirent_to_dcache_head(fat32_dirent* dir){
    dir->prev->next=dir->next;
    dir->next->prev=dir->prev;
    dir->prev=dcache.root_dir.prev;
    dir->next=&dcache.root_dir;
    dcache.root_dir.prev->next=dir;
    dcache.root_dir.prev=dir;
}

//根据父目录的目录项和文件名，获取对应的文件目录项
//类似于acquire_buffer
fat32_dirent* acquire_dirent(fat32_dirent* parent, char* name){
    if(name==NULL)
        return NULL;
    //acquire_spinlock(&dcache.spinlock);
    fat32_dirent* de;
    //首先正向遍历链表
    //如果该目录项已经在缓冲区中了，则直接返回对应buffer的指针就行
    for( de=dcache.root_dir.next;de!=&dcache.root_dir;de=de->next){
        if(de->valid==1 && de->parent==parent && 
            !strcmp(name,de->name)){
            //release_spinlock(&de->spinlock);
            //acquire_sleeplock(&de->sleeplock);
            if(de->ref_count==0)
                parent->ref_count++;
            de->ref_count++;
            return de;
        }
    }

    //如果目录项并不在缓冲区中，则反向遍历链表
    //找到空闲了最长时间的那个目录项缓冲区，将磁盘中的目录项读入该缓冲区并返回其指针
    for(de=dcache.root_dir.prev;de!=&dcache.root_dir;de=de->prev){
        if(de->ref_count==0){
            de->ref_count++;
            de->parent=parent;
            parent->ref_count++;
            de->dev=parent->dev;
            de->valid=1;
            //release_spinlock(&de->spinlock);
            //acquire_sleeplock(&de->sleeplock);
            int ret=read_dirent_from_disk(parent,name,de);
            if(ret==-1){
                //release_sleeplock(&de->sleeplock);
                return NULL;
            }
            return de;
        }
    }

    //dcache都满了，则出错
    panic("dcache is full\n");
    return NULL;
}

//释放目录项缓冲区
void release_dirent(fat32_dirent* dir){
    //if(!is_holding_sleeplock(&dir->sleeplock))
        //panic("release_dirent\n");
    if(dir==&dcache.root_dir){
        //release_sleeplock(&dir->sleeplock);
        return;
    }
    
    //release_sleeplock(&dir->sleeplock);
    //acquire_spinlock(&dcache.spinlock);
    
    //与buffer的管理类似
    dir->ref_count--;
    if(dir->ref_count==0){
        //空闲，将其移动至链表头
        move_dirent_to_dcache_head(dir);
        //release_spinlock(&dcache.spinlock);

        //同时还需释放其父目录的目录项缓冲区
        release_dirent(dir->parent);
        return;
    }
    //to do

    //release_spinlock(&dcache.spinlock);
}

//根据当前目录的目录项(current_de)和文件路径名(file_name)寻找文件目录项
//其中file_name为文件本身的全名加上其所在路径
//可以是绝对路径，如/a/b/t.txt，此时则忽略current_de
//也可以是相对路径，如b/t.txt，则此时就在current_de指向的目录中寻找b/t.txt
fat32_dirent* find_dirent(fat32_dirent* current_de, char *file_name){
    if(file_name==NULL || strlen(file_name)>FILE_NAME_LENGTH)
        return NULL;
    upper(file_name);   //文件名字母全部转为大写
    if(!strcmp(file_name,"/"))  //若为根目录，则直接返回根目录项
        return &dcache.root_dir;
    if(*file_name=='/'){    //若为绝对路径
        current_de=&dcache.root_dir;    //则设置current_de为根目录项
        file_name++;    //并将路径改为相对根目录的相对路径
    }
    if(current_de==NULL)  
        return NULL;

    //接下来就是以'/'为分隔，循环获取目录名并在父目录中寻找，
    //若找到则将该目录设置为父目录，迭代继续寻找下一个目录
    //直到迭代到最后一个文件名
    //如果中间没有找到则返回NULL
    int slash_pos=0;
    int beg_pos=0;
    int is_end=0;
    char temp_name[FILE_NAME_LENGTH+1];
    fat32_dirent* parent=current_de;
    fat32_dirent* child=NULL;
    while(!is_end){
        //定位下一个'/'所在位置
        while(file_name[slash_pos]!='/'){
            if(file_name[slash_pos]==0){//如果遍历到'\0',说明已经是最后一个文件
                is_end=1;   //设置结束标志
                break;
            }
            slash_pos++;
        }
        if(file_name[beg_pos]==0 && file_name[slash_pos]==0)
            break;
        //根据beg_pos和slash_pos确定当前要寻找的目录名或文件名
        memset(temp_name,0,FILE_NAME_LENGTH+1);
        memcpy(temp_name,file_name+beg_pos,slash_pos-beg_pos);
        //获取名字后，直接寻找
        child=acquire_dirent(parent,temp_name);
        //完成寻找后，就可以释放之前的父目录了
        if(parent!=NULL && parent!=current_de)
            release_dirent(parent);
        //如果没有找到，返回NULL
        if(child==NULL){
            printk("%s : file not found\n",temp_name);
            return NULL;
        }
        //printk("%s, %x\n",child->name,child->start_blockno);

        //如果找到了，则将父目录设置为当前找到的这个目录，继续下一轮迭代
        parent=child;
        slash_pos++;
        beg_pos=slash_pos;
    }
    return child;
}

 //根据文件的目录项，偏移，读取数据的大小，将数据读入指定位置
 //返回实际读取的字节数
int read_by_dirent(fat32_dirent *de, void *dst, uint offset, uint rsize){
    //指针不能为NULL
    if(de==NULL || dst==NULL)
        return 0;

    //读取的文件不能为目录，offset不能超过文件大小，rsize不能小于等于0
    if((de->attribute & ATTR_DIRECTORY) || offset>de->file_size || rsize<=0)
        return 0;

    //根据offset和file_size调整实际读取文件的数据大小
    if(offset+rsize>de->file_size)
        rsize=de->file_size-offset;

    //计算读取数据的起始簇号blk、起始簇中偏移扇区号sec、扇区中偏移字节数off
    uint32 blk=offset/(dbr_info.bytes_per_sector*dbr_info.sectors_per_block)+de->start_blockno;
    uint32 sec=(offset%(dbr_info.bytes_per_sector*dbr_info.sectors_per_block))/dbr_info.bytes_per_sector;
    uint32 off=offset%dbr_info.bytes_per_sector;

    //计算读取的数据大小：有几个簇nblk，最后一个簇要读几个扇区nsec，最后一个扇区要读几个字节noff
    uint32 nblk=rsize/(dbr_info.bytes_per_sector*dbr_info.sectors_per_block);
    uint32 nsec=(rsize%(dbr_info.bytes_per_sector*dbr_info.sectors_per_block))/dbr_info.bytes_per_sector;
    uint32 noff=rsize%dbr_info.bytes_per_sector;
    if(noff+off>dbr_info.bytes_per_sector){
        nsec++;
        if(nsec>=dbr_info.sectors_per_block){
            nsec=0;
            nblk++;
        }
    }
    noff=(noff+off)%dbr_info.bytes_per_sector;

    uint tot_sz=0;  //实际读取的字节数
    buffer *buf;
    for(int b=0;b<=nblk;b++){   //遍历簇
        if(blk==FAT_BLOCK_END){ //如果读完了最后一个簇，则直接返回
            return tot_sz;
        }

        //确定本簇中需要读取的起始扇区和结束扇区位置
        int s_beg=0;
        int s_end=dbr_info.sectors_per_block-1;
        if(b==0)
            s_beg=sec;
        if(b==nblk)
            s_end=s_beg+nsec;
        
        //遍历簇中的扇区
        for(int s=s_beg,s_sec=blockno_to_sectorno(blk);s<=s_end;s++){
            int beg=0;
            int nsz=dbr_info.bytes_per_sector;

            //确定本扇区中需要读取的起始偏移和结束偏移位置
            if(b==0 && s==0){
                tot_sz=0;
                beg=off;
                nsz-=off;
            }
            if(b==nblk && s==s_end)
                nsz=noff-beg;

            buf=acquire_buffer(de->dev,s_sec+s);    //根据扇区号获取相应buffer
            memcpy(dst+tot_sz,buf->data+beg,nsz);   //根据扇区中起始和结束的偏移获取数据到dst
            release_buffer(buf);    //释放buffer
            tot_sz+=nsz;    //tot_sz加上刚才读取的数据大小
        }

        blk=fat_find_next_blockno(blk,1);   //获取下一个簇号
    }

    return tot_sz;
}

//根据文件的目录项，偏移，写入数据的大小，将指定位置数据写入文件
int write_by_dirent(fat32_dirent *de, void *src, uint offset, uint wsize){
    return wsize;
}

//增加目录项缓冲区的引用数
fat32_dirent* dirent_dup(fat32_dirent *de){
    //acquire_spinlock(&dcache.spinlock);
    de->ref_count++;
    //release_spinlock(&dcache.spinlock);
    return de;
}