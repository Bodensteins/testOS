#include "include/device.h"
#include "include/console.h"
#include "include/file.h"
#include "include/string.h"
#include "include/printk.h"

/*
设备管理相关
*/

device dev_list[NDEV];

void device_init(){
    dev_list[DEVICE_CONSOLE_NUM].read=read_from_console;
    dev_list[DEVICE_CONSOLE_NUM].write=write_to_console;
}

file* open_device(char *dev_name){
    file* f=acquire_file();
    f->fat32_dirent=NULL;
    f->type=FILE_TYPE_DEVICE;
    if(strncmp(dev_name,"/dev/console",12)==0){
        printk("open /dev/console success!\n");
        f->dev=DEVICE_CONSOLE_NUM;
        f->attribute |= (FILE_ATTR_READ|FILE_ATTR_WRITE);
        return f;
    }
    return NULL;
}

int do_mount(char *dev, char *mnt, char *fs){
    //do nothing
    return 0;
}

int do_umount(char *mnt){
    //do nothing
    return 0;
}