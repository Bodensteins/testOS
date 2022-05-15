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
文件系统相关依赖为：
    syscall.c-->file.c-->fat32.c-->buffer.c-->sd/sdcard.c(k210官方的sd卡驱动)-->底层驱动
*/


//暂时将sd卡设备号设为0
#ifndef DEVICE_DISK_NUM
#define DEVICE_DISK_NUM 0
#endif


//sd卡一般只有一个分区
fat32_mbr_dpt mbr_info; //mbr信息
fat32_dbr dbr_info; //dbr信息

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
    printk("SDcard is_MBR called\n");
    //printk("%x %x %x",data[0],data[1],data[2]);
    if((unsigned int)data[0]==JMP_CODE_0x0 && (unsigned int)data[1]==JMP_CODE_0x1 && (unsigned int)data[2]==JMP_CODE_0x2) // EB 58 90 DBR 跳转指令
    {
        printk("SDcard 0 Sector is DBR\n");
        return 0;
    }   

    return 1;
}

/*
从buf中解析分区信息


*/
int MBR_DPT_info(fat32_mbr_dpt * DPT)
{


    return 0;

}


int DBR_BPB_info(fat32_dbr_bpb * BPB)
{



    return 0;
}

/*
 根据文件名中最后一个. 的位置决定
 返回最后一个dot 的偏移
  -1 无 dot .
  非负数，从0开始计算的偏移，
*/
int dot_search_in_name(char name_find_dot[])
{
    //printk("str: %s\n",name_find_dot);

    int len = strlen(name_find_dot);

    //printk("len: %d\n",len);

    if(len > 0)
    {
        int i = 0;
        for(i = len-1; name_find_dot[i]!='.'&& i>=0 ;i--);
        //printk("dot offset: %d\n",i);
    }
    return 0;
}

void test_dot()
{
    char name[] ="123456789";
    dot_search_in_name(name);

}

/*
    短文件名格式   "_ _ _ _ _ _ ~ N _ _ _"
    下划线表示空格，N 为数字字符 '1'至 '9'；前6个和后3个为填充字符(字母大写)，填充规则见下
    文件名长度，小于 9个字符，则从第一个字符开始填充，包括 dot . 
            例如： "a.txt"       -->  "A . T X T _ ~ 1 _ _ _"
                  "a.b.c.txt"   -->  "A . B . C . ~ 1 T X T"
    文件名长度，大于 9个字符，则从取文件名前6个字符，包括 (dot .)
                            取最后3个字符(包括)
 
                如 aa.bbb.c.dddd.hhh.gg  "A A . B B B ~ 1 . G G"

    如果形成文件名后，存在重名，则N++；若 N > '9'，文件创建失败；

    正确返回 0
    错误返回 -1
*/
int longname_to_shorname(char name_to_splite[],char shortname[])
{
     //printk("%s\n",name_to_splite);
     //printk("%s\n",shortname);

    int len = strlen(name_to_splite);
    if(strlen(shortname) == 11)
    {
        char template[12] = "      ~1   ";
        memcpy(shortname,template,12);
    }
    else{
        return -1;
    }

    if(len> 0 && len<=9)
    {
        int i = 0;
        for(;i< 6 && i< len;i++)
        {
           shortname[i] =  name_to_splite[i];
        }

        for(;i>= 6 && i< len;i++)
        {
            shortname[i+2] =  name_to_splite[i];
        }
        //printk("%s\n",shortname);
    }
    else if(len >9)
    {
        int i = 0;
        for(;i< 6 && i< len;i++)
        {
           shortname[i] =  name_to_splite[i];
        }

        int j = len-3;
        for(; i<len ;i++,j++)
        {
           shortname[i+2] =  name_to_splite[j];
        }
        //printk("%s\n",shortname);
    }
    else
    {
        return -1;
    }
    
    upper(shortname);
    return 0;
}

void test_for_long2shortname()
{
    char sn[12] ="  -  -  -  ";
    char longname1[] = "a.txt";
    char longname2[] = "a.b.c.txt";
    char longname3[] = "aa.bbb.c.dddd.hhh.gg";
    char longname4[] = ".bbade.ddaaegac";

    longname_to_shorname(longname1,sn);
    printk("%s\n\n",sn);
    longname_to_shorname(longname2,sn);
    printk("%s\n\n",sn);
    longname_to_shorname(longname3,sn);
    printk("%s\n\n",sn);
    longname_to_shorname(longname4,sn);
    printk("%s\n\n",sn);
    /*
    
    printk("%s\n",longname_to_shorname(longname2,sn));
    printk("%s\n",longname_to_shorname(longname3,sn));
    printk("%s\n",longname_to_shorname(longname4,sn));
    */

}

/*
    根据短文件名计算校验和
    返回 0，失败
    返回其他数值，为校验和
    算法经过验证，可以使用
*/
uint8 chksum_calc(char shortname[])
{
    if(strlen(shortname) !=11)
    {
        return 0;
    }

    //printk("%s\n",shortname);

    int i=0,j=0;
    uint8 chksum=0;
    for (i=11; i>0; i--)
    {
        chksum = ((chksum & 1) ? 0x80 : 0) + (chksum >> 1) + shortname[j++];
        //printk("%x\n",chksum);
    }

    //printk("%x\n\n",chksum);

    return chksum;
}

void test_for_chksum_calc()
{
    //校验码检验合格
    char shortname[12] ="123456~1TXT"; // 2A
    char shortname2[12] ="SDEF78~1HTL"; // B8
    char shortname3[12] ="ABCDEF~1   "; // CA
    char shortname4[12] ="AABBCC~1GGH"; // 99
    char shortname5[12] ="      ~1   "; // 
 
    printk("%x\n",chksum_calc(shortname));
    printk("%x\n",chksum_calc(shortname2));
    printk("%x\n",chksum_calc(shortname3));
    printk("%x\n",chksum_calc(shortname4));
    printk("%x\n",chksum_calc(shortname5));

}






/*
    根据输入的长文件名，填充长文件名目录项
    文件名不超过64个字符
    fat32_long_name_dir_entry long_name_dir_entry[5];
    返回-1，填充失败
    返回0，填充成功
*/
int fill_longname_entry(char longname[],
                        fat32_long_name_dir_entry *long_name_dir_entry)
{
    //fat32_short_name_dir_entry fat32_short_name_dir_entry;
    int name_len = strlen(longname);
    if(name_len >FILE_NAME_LENGTH ) return -1;

    int splite_num = (name_len / 13) +1; // 分成几个长目录项
          

    //long_name_dir_entry[5];// 长目录项填充位置
    memset(long_name_dir_entry,0xFF,sizeof(uint8)*5*32);
    
    char shortname[12]="  -  -  -  ";

    longname_to_shorname(longname,shortname);
    //printk("%s\n",shortname);
    uint8 chksum = chksum_calc(shortname);

    for(int i = 0; i<splite_num; i++)
    {
        (long_name_dir_entry+i)->atrribute = i+1;
        (long_name_dir_entry+i)->symbol = ATTR_LONG_NAME;
        (long_name_dir_entry+i)->system_reserve = 0;
        (long_name_dir_entry+i)->verify_value = chksum;
        (long_name_dir_entry+i)->start_cluster = 0;

        char name_splited[14];
        int remain_len = 13;
        if(i+1 == splite_num) //如果是最后一块
        {
            (long_name_dir_entry+i)->atrribute |= LAST_LONG_ENTRY;
            remain_len = name_len % 13;
            //printk("\nremian len: %d\n",remain_len);
        }
        
        
        memcpy(name_splited,longname+i*13,remain_len);
        name_splited[remain_len]='\0';
        
        printk("\n----%d------\n",i);
        printk("\nname_splited:%s\n",name_splited);
        //printk("\nname_splited:%s\n",longname+i*13);
        
        int k =0;
        for(int j =0;k<5 && k<remain_len ;k++,j++)
        {
            (long_name_dir_entry+i)->name1[j*2] = name_splited[k];
            (long_name_dir_entry+i)->name1[j*2+1] = 0;
        }
 
        for(int j =0;k<11 && k<remain_len;k++,j++)
        {
            (long_name_dir_entry+i)->name2[j*2] = name_splited[k];
            (long_name_dir_entry+i)->name2[j*2+1] = 0;
        }

        for(int j =0;k<13 && k<remain_len;k++,j++)
        {
            (long_name_dir_entry+i)->name3[j*2] = name_splited[k];
            (long_name_dir_entry+i)->name3[j*2+1] = 0;
        }
    }


    return 0;
}


void test_for_fill_longentry()
{

    char longname[] = "aa.bbb.c.dddd.hhh.gg.asvfdsoh.ajhgonfgopcn.shaif";
    fat32_long_name_dir_entry long_name_dir_entry[5];
    fill_longname_entry(longname,long_name_dir_entry);

    for(int i = 4;i>= 0; i--)
    {
        printk("----------%d-----------\n",i);
        uint8 * dir_entry = &long_name_dir_entry[i].atrribute;
        
        for(int j =0;j<16;j++)
            printk("%x  ",dir_entry[j]);
        printk("\n");

        dir_entry = (uint8*)&long_name_dir_entry[i].name2[2];
        for(int j =0;j<16;j++)
            printk("%x  ",dir_entry[j]);
        printk("\n");
    }
}

//fat32文件系统相关初始化，在OS启动时调用
void fat32_init(){

    buffer *buf;
    //test_for_fill_longentry();
    //test_for_long2shortname();
    //test_for_chksum_calc();

    //读取mbr信息，0号扇区为mbr
    buf=acquire_buffer(DEVICE_DISK_NUM,0);

    //is_MBR(buf);
    //读取dbr起始的扇区号
    memcpy(&mbr_info.start_lba,buf->data+MBR_DBR_START_SECTOR_OFFSET,sizeof(uint32));//使用memcpy函数代替赋值，防止k210报错
    //读取磁盘总扇区数
    memcpy(&mbr_info.size,buf->data+MBR_TOTAL_SECORS_OFFSET,sizeof(uint32));
    release_buffer(buf);
    
    //读取dbr信息，根据mbr_info中的dbr_start_sector找到dbr所在扇区
    buf=acquire_buffer(DEVICE_DISK_NUM,mbr_info.start_lba);
    //读取每扇区的字节数
    memcpy(&dbr_info.bytes_per_sector,buf->data+DBR_BYTES_PER_SECTOR_OFFSET,sizeof(uint16));
    //检查每扇区字节数是否等于512字节
    if(dbr_info.bytes_per_sector!=BSIZE)
        panic("bytes_per_sector is not 512\n");
    //以下均是从dbr扇区中读取相应字段来初始化dbr_info，标注几个重要的
    dbr_info.sectors_per_cluster=*((uint8*)(buf->data+DBR_SECTORS_PER_CLUSTER_OFFSET));  //每簇的扇区数
    dbr_info.dbr_reserve_sectors=*((uint16*)(buf->data+DBR_RESERVE_SECTORS_OFFSET));    //dbr保留扇区数(dbr之后就是fat表)
    dbr_info.total_fats=*((uint8*)(buf->data+DBR_TOTAL_FATS_OFFSET));   //fat个数
    dbr_info.hidden_sectors=*((uint32*)(buf->data+DBR_HIDDEN_SECTORS_OFFSET));  
    dbr_info.fs_total_sectors=*((uint32*)(buf->data+DBR_FS_TOTAL_SECTORS_OFFSET));
    dbr_info.sectors_per_fat=*((uint32*)(buf->data+DBR_SECTORS_PER_FAT_OFFSET));    //每个fat占用的扇区数
    dbr_info.root_dir_clusterno=*((uint32*)(buf->data+DBR_ROOT_DIR_CLUSTER_OFFSET));    //根目录所在簇号
    dbr_info.fsinfo_sector=*((uint16*)(buf->data+DBR_FSINFO_SECTOR_OFFSET));   
    dbr_info.dbr_backup_sector=*((uint16*)(buf->data+DBR_BACKUP_SECTOR_OFFSET));
    release_buffer(buf);
    
    //初始化根目录的目录项
    memset(&dcache.root_dir,0,sizeof(dcache.root_dir));
    dcache.root_dir.attribute=ATTR_DIRECTORY;
    //dcache.root_dir.current_clusterno=dbr_info.root_dir_clusterno;
    dcache.root_dir.dev=DEVICE_DISK_NUM;
    dcache.root_dir.parent=&dcache.root_dir;
    dcache.root_dir.start_clusterno=dbr_info.root_dir_clusterno;
    memcpy(dcache.root_dir.name,"/",1);
    init_sleeplock(&dcache.root_dir.sleeplock,"root fat32_dirent");
    
    //dcache init
    //参照buffer.c中的bcache，也将dcache中的目录项(fat32_dirent)组织为双向循环链表
    init_spinlock(&dcache.spinlock, "dcache");
    dcache.root_dir.prev=&dcache.root_dir;
    dcache.root_dir.next=&dcache.root_dir;
    for(int i=0;i<DIRENT_LIST_LENGTH;i++){
        (dcache.dirent_list+i)->valid=0;
        (dcache.dirent_list+i)->dirty=0;
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

//工具函数，作用是将簇号(clusterno)转换为该簇的第一个扇区的扇区号(sectorno)
uint32 clusterno_to_sectorno(uint32 clusterno){
    int sectorno=mbr_info.start_lba+dbr_info.dbr_reserve_sectors;
    sectorno+=dbr_info.sectors_per_fat*dbr_info.total_fats;
    sectorno+=dbr_info.sectors_per_cluster*(clusterno-dbr_info.root_dir_clusterno);
	return sectorno;
}

//工具函数，作用是将扇区号(sectorno)转换为其所在簇的簇号(clusterno)
static uint32 sectorno_to_clusterno(uint32 sectorno){
    int clusterno=sectorno-mbr_info.start_lba;
    clusterno+=dbr_info.dbr_reserve_sectors;
    clusterno+=dbr_info.sectors_per_fat*dbr_info.total_fats;
    clusterno/=dbr_info.sectors_per_cluster+2;
    return clusterno;
}


//工具函数，给定簇号(clusterno)和第几个fat表(fatno取1或2)，返回该簇号在fat表中对应位置的扇区号
//这个函数用于fat_find_next_clusterno函数中
static inline uint32 fat_clusterno_to_sectorno(uint32 clusterno, uint32 fatno){
    return 4*clusterno/dbr_info.bytes_per_sector+mbr_info.start_lba+
        dbr_info.dbr_reserve_sectors+dbr_info.sectors_per_fat*(fatno-1);
}

//工具函数，给定簇号(clusterno)和第几个fat表(fatno取1或2)，返回该簇号在fat表中对应扇区中的偏移
//这个函数用于fat_find_next_clusterno函数中
static inline uint32 fat_clusterno_to_offset(uint32 clusterno){
    return (4*clusterno)%dbr_info.bytes_per_sector;
}

//给定一个簇号clusterno以及fat表号(fatno取1或2，表示第1或第2个fat表)
//返回该簇所对应的下一个簇号，如果是文件中的最后一个簇则返回0x0fffffff
//具体原理请参考fat32格式说明
uint32 fat_find_next_clusterno(uint32 clusterno, uint32 fatno){
    if(clusterno==FAT_CLUSTER_END || clusterno==FAT_CLUSTER_DAMAGE)
        return clusterno;
    //以下步骤就是在定位该clusterno的下一个clusterno在磁盘中的位置(扇区号+扇区内偏移)
    uint32 sec=fat_clusterno_to_sectorno(clusterno, fatno);
    if(sec>=mbr_info.start_lba+dbr_info.dbr_reserve_sectors+dbr_info.sectors_per_fat*fatno)
        return clusterno;
    uint32 off=fat_clusterno_to_offset(clusterno);
    //找到位置后，直接返回next_clusterno就行
    buffer* buf=acquire_buffer(DEVICE_DISK_NUM, sec);
    uint32 next_cluster=*((uint32*)(buf->data+off));
    release_buffer(buf);
    return next_cluster;
}

//给定一个簇号clusterno，需要更新的next_clusterno，以及fat表号(fatno取1或2，表示第1或第2个fat表)
//该函数将在相应fat表中把clusterno对应的下一个簇号更新为next_cluster
//由于目前暂未使用这个函数，而makefile中开启了将warning转换为error的选项，保留该函数会导致编译不通过，因此先注释掉
void fat_update_next_clusterno(uint32 clusterno, uint32 next_clusterno, uint32 fatno){
    uint32 sec=fat_clusterno_to_sectorno(clusterno, fatno);
    if(sec>=mbr_info.start_lba+dbr_info.dbr_reserve_sectors+dbr_info.sectors_per_fat*fatno)
        return;
    uint32 off=fat_clusterno_to_offset(clusterno);
    buffer* buf=acquire_buffer(DEVICE_DISK_NUM, sec);
    //*((uint32*)(buf->data+off))=next_clusterno;
    //buffer_write(buf);
    write_to_buffer(buf,&next_clusterno,off,sizeof(uint32));
    release_buffer(buf);
}

//将指定簇内容清0，clusterno为簇号
//驱动问题，没办法完全清零
void clear_cluster(uint32 clusterno){
    buffer *buf;
    uint32 sec=clusterno_to_sectorno(clusterno);
    for(int i=0;i<dbr_info.sectors_per_cluster;i++){
        printk("%d\n",i);
        buf=acquire_buffer(DEVICE_DISK_NUM,sec+i);
        buf->dirty=1;
        memset(buf->data,0,BSIZE);
        release_buffer(buf);
    }
}

//工具函数，遍历FAT表，找到一个未被使用的簇，清空其内容，更新FAT，返回该簇号
//也许可以优化，如维护一个空闲簇列表以代替遍历
uint32 alloc_cluster(){
    printk("enter alloc cluster\n");
    buffer* buf;
    uint32 sec=mbr_info.start_lba+dbr_info.dbr_reserve_sectors;
    for(int i=0;i<dbr_info.sectors_per_fat;i++,sec++){
        buf=acquire_buffer(DEVICE_DISK_NUM,sec);
        for(int off=0;off<dbr_info.sectors_per_cluster;off+=sizeof(uint32)){
            uint32 *clus_ptr=(uint32*)(buf->data+off);
            if(*clus_ptr==0){
                uint32 clusno=FAT_CLUSTER_END;
                write_to_buffer(buf,&clusno,off,sizeof(uint32));
                release_buffer(buf);
                clusno=(i*dbr_info.bytes_per_sector+off)/sizeof(uint32);
                fat_update_next_clusterno(clusno,FAT_CLUSTER_END,2);
                printk("alloc cluster: %d\n",clusno);
                //clear_cluster(clusno);
                printk("return\n");
                return clusno;
            }
        }
        release_buffer(buf);
    }
    //panic("no more free cluster\n");
    printk("no more free cluster\n");
    return 0;
}




/*
    从长目录项缓冲区中，读出长文件名
    返回 长文件名 长度
    返回 0 或 -1 表示错误

*/
static int  get_full_long_name(fat32_dir_entry* dentry,char* full_name)
{
    int num = dentry->long_dir_entry_num;
    if(num <= 0)
        return -1;
    fat32_long_name_dir_entry* long_name_dir_entrys = dentry->long_name_dentry;
    
    int k =0; // k指向full_name
    int i =0;
    for(;i<num-1;i++) // 长名目录不是最后一项
    {    
        for(int j =0;j<5;k++,j++) // j指向各长文件目录项 name 字段
        {
            full_name[k] = long_name_dir_entrys[i].name1[j*2];
        }
        for(int j =0;j<6;k++,j++)
        {
            full_name[k] = long_name_dir_entrys[i].name2[j*2];
        }
        for(int j =0;j<2;k++,j++)
        {
            full_name[k] = long_name_dir_entrys[i].name3[j*2];
        }
    }

    //最后一项长名目录
    uint8 c_tmp;
    for(int j =0;j<5;k++,j++) // j指向各长文件目录项 name 字段
    {
        c_tmp = long_name_dir_entrys[i].name1[j*2]; 
        if(c_tmp == 0xFF)
            goto end;
        full_name[k] = c_tmp;
    }
    for(int j =0;j<6;k++,j++)
    {
        c_tmp = long_name_dir_entrys[i].name2[j*2];
        if(c_tmp == 0xFF)
            goto end;
        full_name[k] = c_tmp;
    }
    for(int j =0;j<2;k++,j++)
    {
        c_tmp = long_name_dir_entrys[i].name3[j*2];
        if(c_tmp == 0xFF)
            goto end;
        full_name[k] = c_tmp;
    }

end:
    memset(long_name_dir_entrys,0,DIR_ENTRY_BYTES*num); // 清空 长目录项缓冲区
    dentry->long_dir_entry_num =0;
    full_name[k] = '\0';
    return k;

}


/*
    校验长目录项的校验位
    返回 0 ，校验错误
    返回 1 ， 校验正确
*/
static int check_chksum(fat32_dir_entry * dentry)
{
    int num = dentry->long_dir_entry_num;
    char str_name[12];
    memcpy(str_name,(char *)&(dentry->short_name_dentry),11);
    str_name[11] ='\0';
    
    //printk("check_chksum: %s\n",str_name);

    uint8 chksum_std = chksum_calc(str_name) ;
    for(int i =0; i<num ;i++)
    {
        if(dentry->long_name_dentry[i].verify_value  != chksum_std)
        {
            return 0;
        }
    }
    //printk("\n校验成功\n");
    return 1;

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


//shortname
//工具函数，从fat32_short_name_dir_entry中获取文件初始簇号
static uint32 get_start_clusterno_in_short_entry(fat32_short_name_dir_entry* sde){
    uint32 h=(uint32)sde->start_clusterno_high;
    uint32 l=(uint32)sde->start_clusterno_low;
    return (h<<16)+l;
}

//shortname
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

//shortname
//de->name保证为短文件名
static void fat32_dirent_to_short_name_dir_entry(fat32_short_name_dir_entry *sde, fat32_dirent *de){
    sde->atrribute=de->attribute;
    sde->file_size=de->file_size;
    sde->start_clusterno_high=(uint16)(de->start_clusterno >> 16);
    sde->start_clusterno_low=(uint16)(de->start_clusterno & 0x0000FFFF);
}

//shortname
//工具函数，将目录项缓冲中的数据写入磁盘
static void fat32_dirent_write_to_disk(fat32_dirent* de){
    fat32_dir_entry dentry;
    fat32_dirent_to_short_name_dir_entry(&dentry.short_name_dentry,de);
    buffer *buf=acquire_buffer(DEVICE_DISK_NUM,
        clusterno_to_sectorno(de->clusterno_in_parent)+de->offset_in_parent/dbr_info.bytes_per_sector);
    //write_to_buffer(buf, &dentry, de->offset_in_parent%dbr_info.bytes_per_sector, DIR_ENTRY_BYTES);
    write_to_buffer(buf, &dentry.short_name_dentry.atrribute, 
        de->offset_in_parent%dbr_info.bytes_per_sector+SHORT_DENTRY_ATRRIBUTE_OFFSET, 1);
    write_to_buffer(buf, &dentry.short_name_dentry.start_clusterno_high, 
        de->offset_in_parent%dbr_info.bytes_per_sector+SHORT_DENTRY_START_CLUSTERNO_HIGH_OFFSET, 2);
    write_to_buffer(buf, &dentry.short_name_dentry.start_clusterno_low, 
        de->offset_in_parent%dbr_info.bytes_per_sector+SHORT_DENTRY_START_CLUSTERNO_LOW_OFFSET, 2);
    write_to_buffer(buf, &dentry.short_name_dentry.file_size, 
        de->offset_in_parent%dbr_info.bytes_per_sector+SHORT_DENTRY_FILE_SIZE_OFFSET, 4);
    release_buffer(buf);
}


//shortname
//一个比较重要的中间函数
//根据父目录项(parent)，文件名(name,包括扩展名)，读取磁盘上的目录项(fat32_dir_entry)
//并将fat32_dir_entry转换为fat32_dirent
//将信息写入des_de指针指向的位置
static int read_fat32_dirent_from_disk(fat32_dirent* parent, char *name, fat32_dirent* des_de){
    char full_name[FILE_NAME_LENGTH+1];

    uint8 buffer_for_entry[32];
    memset(buffer_for_entry,0,sizeof(uint8)*32);

    fat32_dir_entry dentry;
    memset(&dentry,0,sizeof(fat32_dir_entry));

    //三层循环，分别代表簇号，簇中扇区号偏移，扇区中的偏移
    //clus为起始簇号
    for(uint32 clus=parent->start_clusterno;clus!=FAT_CLUSTER_END;clus=fat_find_next_clusterno(clus,1)){
        uint32 start_sec=clusterno_to_sectorno(clus);  //根据簇号确定簇的起始扇区号
        for(int sec_off=0;sec_off<dbr_info.sectors_per_cluster;sec_off++){    //遍历该簇所有扇区
            buffer *buf=acquire_buffer(DEVICE_DISK_NUM,start_sec+sec_off);  //读取扇区
            for(uint32 off=0;off<dbr_info.bytes_per_sector;off+=DIR_ENTRY_BYTES){   //遍历该扇区中每一个目录项
                if(((buf->data)+off)[0] != 0xE5) // 目录项未被删除
                {
                    memcpy(&dentry,buf->data+off,DIR_ENTRY_BYTES);
                    if(dentry.short_name_dentry.atrribute==ATTR_LONG_NAME){ //是长文件名目录项

                        int id_num = dentry.short_name_dentry.name[0] & 0x1f; //  取出序号
                        
                        if( (dentry.short_name_dentry.name[0]&LAST_LONG_ENTRY) == LAST_LONG_ENTRY ) // 是否为 长文件名目录项 最后一项
                        {
                            dentry.long_dir_entry_num =id_num; //记录 长文件名目录项 总数
                        }
                        
                        memcpy(&dentry.long_name_dentry[id_num-1], &dentry.short_name_dentry,DIR_ENTRY_BYTES); // 存入对应的缓冲区
                        memset(&dentry.short_name_dentry,0,DIR_ENTRY_BYTES);// 清空短文件名目录项
                        continue;
                    }
                    else{
                        
                        if(dentry.long_dir_entry_num == 0 || check_chksum(&dentry) == 0) //缓冲区中无长文件名目录项，或者 校验失败
                        {
                            get_full_short_name(&dentry.short_name_dentry,full_name);   //获取该目录项指向的文件的文件全名
                            if(!strcmp(name,full_name)){    //与name参数比较
                                //如果名字一致，那么就算找到了
                                release_buffer(buf);    //释放缓冲区
                                //将dentry中的信息转到des_de中
                                memcpy(des_de->name, full_name,12);    //文件名
                                des_de->attribute=dentry.short_name_dentry.atrribute;  //属性
                                des_de->offset_in_parent=sec_off*dbr_info.bytes_per_sector+off;    //在父目录中的位置偏移
                                des_de->start_clusterno=get_start_clusterno_in_short_entry(&dentry.short_name_dentry);     //起始簇号
                                //des_de->current_clusterno=des_de->start_clusterno;
                                des_de->file_size=dentry.short_name_dentry.file_size;  //文件大小
                                des_de->total_clusters=des_de->file_size/(dbr_info.bytes_per_sector*dbr_info.sectors_per_cluster);    //文件总簇数
                                if(des_de->start_clusterno==0x0) //不知道为什么，sd卡中记录的根目录簇号一律是0，因此得修改
                                    des_de->start_clusterno=dbr_info.root_dir_clusterno;
                                return 0;
                            }
                        }
                        else
                        {
                            //缓冲区中有长文件名目录且校验成功
                            int len = get_full_long_name(&dentry,full_name);// 注意需要传入整个dentry,如果没有错误，那么长目录项缓冲区会被清空
                            if(len>0)
                            {
                                if(!strcmp(name,full_name))
                                {
                                    //如果名字一致，那么就算找到了
                                    release_buffer(buf);
                                    memcpy(des_de->name, full_name,len+1);    //文件名
                                    des_de->attribute=dentry.short_name_dentry.atrribute;  //属性
                                    des_de->offset_in_parent=sec_off*dbr_info.bytes_per_sector+off;    //在父目录中的位置偏移
                                    des_de->start_clusterno=get_start_clusterno_in_short_entry(&dentry.short_name_dentry);     //起始簇号
                                    des_de->file_size=dentry.short_name_dentry.file_size;  //文件大小
                                    des_de->total_clusters=des_de->file_size/(dbr_info.bytes_per_sector*dbr_info.sectors_per_cluster);    //文件总簇数
                                    //if(des_de->start_clusterno==0x0)
                                        //des_de->start_clusterno=dbr_info.root_dir_clusterno;
                                    return 0;
                                }

                            }
                        }
                    }
                }
            }
            release_buffer(buf);
        }
    }
    return -1;
}



//将指定的目录项移动至链表头部
static void move_dirent_to_dcache_head(fat32_dirent* de){
    de->prev->next=de->next;
    de->next->prev=de->prev;
    de->prev=dcache.root_dir.prev;
    de->next=&dcache.root_dir;
    dcache.root_dir.prev->next=de;
    dcache.root_dir.prev=de;
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
            int ret=read_fat32_dirent_from_disk(parent,name,de);
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
void release_dirent(fat32_dirent* de){
    if(de==NULL)
        return;
    //if(!is_holding_sleeplock(&de->sleeplock))
        //panic("release_dirent\n");
    if(de==&dcache.root_dir){
        if(de->dirty!=0){
            fat32_dirent_write_to_disk(de);
            de->dirty=0;
        }
        //release_sleeplock(&de->sleeplock);
        return;
    }
    
    //release_sleeplock(&de->sleeplock);
    //acquire_spinlock(&dcache.spinlock);
    
    //与buffer的管理类似
    de->ref_count--;
    if(de->ref_count==0){
        if(de->dirty!=0){
            fat32_dirent_write_to_disk(de);
            de->dirty=0;
        }
        //空闲，将其移动至链表头
        move_dirent_to_dcache_head(de);
        //release_spinlock(&dcache.spinlock);

        //同时还需释放其父目录的目录项缓冲区
        release_dirent(de->parent);
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
    
    //upper(file_name);   //文件名字母全部转为大写
    
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
        slash_pos++;
        beg_pos=slash_pos;
        
        if(!strcmp(temp_name,".")){
            if(is_end)
                return child;
            continue;
        }
        else if(!strcmp(temp_name,"..")){
            child=parent->parent;
            release_dirent(parent);
            parent=child;
            if(is_end)
                return child;
            continue;
        }

        //获取名字后，直接寻找
        child=acquire_dirent(parent,temp_name);
        
        //如果没有找到，返回NULL
        if(child==NULL){

            if(strlen(temp_name) <= 11)
            {   
                printk("find_dirent temp_name : %s",temp_name);

                upper(temp_name);

                child=acquire_dirent(parent,temp_name);
                if(child==NULL)
                {
                    printk("%s : file not found\n",temp_name);
                    
                    if(parent!=NULL && parent!=current_de)
                        release_dirent(parent);
                        
                    return NULL;
                }
            }
            
        }
        //printk("%s, %x\n",child->name,child->start_clusterno);

        if(parent!=NULL && parent!=current_de)
                    release_dirent(parent);
        //如果找到了，则将父目录设置为当前找到的这个目录，继续下一轮迭代
        parent=child;
    }
    return child;
}

 //根据文件的目录项，偏移，读取数据的大小，将数据读入指定位置
 //返回实际读取的字节数
int read_by_dirent(fat32_dirent *de, void *dst, uint offset, uint rsize){
    //指针不能为NULL
    if(de==NULL || dst==NULL)
        return 0;

    //offset不能超过文件大小，rsize不能小于等于0
    if(offset>de->file_size || rsize<=0)
        return 0;

    //根据offset和file_size调整实际读取文件的数据大小
    if(offset+rsize>de->file_size)
        rsize=de->file_size-offset;

    //计算读取数据的起始簇号clus、起始簇中偏移扇区号sec、扇区中偏移字节数off
    uint32 clus=de->start_clusterno;
    uint32 n=offset/(dbr_info.bytes_per_sector*dbr_info.sectors_per_cluster);
    for(int i=0;i<n;i++)
        clus=fat_find_next_clusterno(clus,1);
    uint32 sec=(offset%(dbr_info.bytes_per_sector*dbr_info.sectors_per_cluster))/dbr_info.bytes_per_sector;
    uint32 off=offset%dbr_info.bytes_per_sector;

    //计算读取的数据大小：有几个簇nclus，最后一个簇要读几个扇区nsec，最后一个扇区要读几个字节noff
    uint32 nclus=rsize/(dbr_info.bytes_per_sector*dbr_info.sectors_per_cluster);
    uint32 nsec=(rsize%(dbr_info.bytes_per_sector*dbr_info.sectors_per_cluster))/dbr_info.bytes_per_sector;
    uint32 noff=rsize%dbr_info.bytes_per_sector;
    if(noff+off>dbr_info.bytes_per_sector){
        nsec++;
        if(nsec>=dbr_info.sectors_per_cluster){
            nsec=0;
            nclus++;
        }
    }
    noff=(noff+off)%dbr_info.bytes_per_sector;

    uint tot_sz=0;  //实际读取的字节数
    buffer *buf;
    for(int c=0;c<=nclus;c++){   //遍历簇
        if(clus==FAT_CLUSTER_END){ //如果读完了最后一个簇，则直接返回
            return tot_sz;
        }

        //确定本簇中需要读取的起始扇区和结束扇区位置
        int s_beg=0;
        int s_end=dbr_info.sectors_per_cluster-1;
        if(c==0)
            s_beg=sec;
        if(c==nclus)
            s_end=s_beg+nsec;
        
        //遍历簇中的扇区
        for(int s=s_beg,s_sec=clusterno_to_sectorno(clus);s<=s_end;s++){
            int beg=0;
            int nsz=dbr_info.bytes_per_sector;

            //确定本扇区中需要读取的起始偏移和结束偏移位置
            if(c==0 && s==0){
                tot_sz=0;
                beg=off;
                nsz-=off;
            }
            if(c==nclus && s==s_end)
                nsz=noff-beg;

            buf=acquire_buffer(de->dev,s_sec+s);    //根据扇区号获取相应buffer
            memcpy(dst+tot_sz,buf->data+beg,nsz);   //根据扇区中起始和结束的偏移获取数据到dst
            release_buffer(buf);    //释放buffer
            tot_sz+=nsz;    //tot_sz加上刚才读取的数据大小
        }

        clus=fat_find_next_clusterno(clus,1);   //获取下一个簇号
    }

    return tot_sz;
}

//根据文件的目录项，偏移，写入数据的大小，将指定位置数据写入文件
int write_by_dirent(fat32_dirent *de, void *src, uint offset,  uint wsize){
    //指针不能为NULL，wsize不能小于等于0
    if(de==NULL || src==NULL || wsize<=0)
        return 0;

    if(offset>de->file_size)
        offset=de->file_size;

    if(de->file_size==0){
        de->dirty=1;
        de->start_clusterno=alloc_cluster();
    }

    //计算写入数据位置的起始簇号clus、起始簇中偏移扇区号sec、扇区中偏移字节数off
    uint32 clus=de->start_clusterno;
    uint32 n=offset/(dbr_info.bytes_per_sector*dbr_info.sectors_per_cluster);
    for(int i=0;i<n;i++)
        clus=fat_find_next_clusterno(clus,1);
    uint32 sec=(offset%(dbr_info.bytes_per_sector*dbr_info.sectors_per_cluster))/dbr_info.bytes_per_sector;
    uint32 off=offset%dbr_info.bytes_per_sector;

    //计算写入的数据大小：有几个簇nclus，最后一个簇要读几个扇区nsec，最后一个扇区要读几个字节noff
    uint32 nclus=wsize/(dbr_info.bytes_per_sector*dbr_info.sectors_per_cluster);
    uint32 nsec=(wsize%(dbr_info.bytes_per_sector*dbr_info.sectors_per_cluster))/dbr_info.bytes_per_sector;
    uint32 noff=wsize%dbr_info.bytes_per_sector;
    if(noff+off>dbr_info.bytes_per_sector){
        nsec++;
        if(nsec>=dbr_info.sectors_per_cluster){
            nsec=0;
            nclus++;
        }
    }
    noff=(noff+off)%dbr_info.bytes_per_sector;

    uint tot_sz=0;  //实际写入的字节数
    buffer *buf;
    uint32 next_clus;
    for(int c=0;c<=nclus;c++){   //遍历簇
        if(clus==FAT_CLUSTER_END){ //如果遍历到了最后一个簇，或未分配簇，则分配新簇
            //return tot_sz;
            next_clus=alloc_cluster();
            if(next_clus==0)
                return tot_sz;
            fat_update_next_clusterno(clus,next_clus,1);
            fat_update_next_clusterno(clus,next_clus,2);
            clus=next_clus;
        }

        //确定本簇中需要写入的起始扇区和结束扇区位置
        int s_beg=0;
        int s_end=dbr_info.sectors_per_cluster-1;
        if(c==0)
            s_beg=sec;
        if(c==nclus)
            s_end=s_beg+nsec;
        
        //遍历簇中的扇区
        for(int s=s_beg,s_sec=clusterno_to_sectorno(clus);s<=s_end;s++){
            int beg=0;
            int nsz=dbr_info.bytes_per_sector;

            //确定本扇区中需要写入的起始偏移和结束偏移位置
            if(c==0 && s==0){
                tot_sz=0;
                beg=off;
                nsz-=off;
            }
            if(c==nclus && s==s_end)
                nsz=noff-beg;

            buf=acquire_buffer(de->dev,s_sec+s);    //根据扇区号获取相应buffer
            write_to_buffer(buf,src+tot_sz,beg,nsz);     //根据扇区中起始和结束的偏移写入数据到buffer
            release_buffer(buf);    //释放buffer
            tot_sz+=nsz;    //tot_sz加上刚才写入的数据大小
            if(offset+tot_sz>de->file_size){
                de->dirty=1;
                de->file_size=offset+tot_sz;
            }
        }

        clus=fat_find_next_clusterno(clus,1);   //获取下一个簇号
    }

    return tot_sz;
}

//根据文件的目录项，释放文件占用的所有簇
void trunc_by_dirent(fat32_dirent *de){
    for (uint32 clus=de->start_clusterno; clus>=2 && clus!=FAT_CLUSTER_END;) {
        uint32 next_clus=fat_find_next_clusterno(clus,1);
        fat_update_next_clusterno(clus,0,1);
        fat_update_next_clusterno(clus,0,2);
        clus=next_clus;
    }
    de->file_size=0;
    de->start_clusterno=0;
    de->dirty=1;
}

//增加目录项缓冲区的引用数
fat32_dirent* dirent_dup(fat32_dirent *de){
    //acquire_spinlock(&dcache.spinlock);
    de->ref_count++;
    //release_spinlock(&dcache.spinlock);
    return de;
}