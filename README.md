# compOS
2022 OS Competition

添加了注释

在k210上运行：

    0、运行k210时，先将target/main和target/test两个可执行文件读入sd卡根目录中，再将sd卡插入k210

    1、连接k210

    2、执行ls /dev | grep USB 确认k210端口，Linux默认为tty/USB0

    3、若不是tty/USB0则修改Makefile中的k210-port变量

    4、在kernel/include/types.h中去掉：#define QEMU

    5、在bash中执行：make k210 或 make run platform=k210

在qemu上运行：

    0、先别在qemu上运行

备注：

    1、kernel/mcode目录下的代码没有用(rustsbi已经将其代替)

    2、kernel/sd目录下的是k210官方给的sd卡驱动

    