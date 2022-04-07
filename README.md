# testOS
2022 OS Competition

在qemu上运行：
    1、在kernel/include/types.h中添加：#define QEMU
    2、在bash中执行：make run platform=qemu

在k210上运行：
    1、连接k210
    2、执行ls /dev | grep USB 确认k210端口，Linux默认为tty/USB0
    3、若不是tty/USB0则修改Makefile中的k210-port变量
    4、在kernel/include/types.h中去掉：#define QEMU
    5、在bash中执行：make run platform=k210
    