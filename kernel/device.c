#include "include/device.h"
#include "include/console.h"

/*
设备管理相关
*/

device dev_list[NDEV];

void device_init(){
    dev_list[DEVICE_CONSOLE_NUM].read=read_from_console;
    dev_list[DEVICE_CONSOLE_NUM].write=write_to_console;
}