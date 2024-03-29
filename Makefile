#编译参数
platform = qemu
#platform = k210

#目录
K = kernel
U = user
T = target
#O = obj

#内核obj文件
KERN_OBJS := \
	$K/entry.o \
	$K/sstart.o \
	$K/load_store.o \
	$K/kerneltrapvec.o \
	$K/usertrapvec.o \
	$K/trap.o \
	$K/printk.o \
	$K/syscall.o \
	$K/string.o \
	$K/pm.o \
	$K/vm.o \
	$K/process.o \
	$K/swtch.o \
	$K/testcode.o \
	$K/schedule.o \
	$K/spinlock.o \
	$K/sleeplock.o \
	$K/buffer.o \
	$K/sysexec.o \
	$K/plic.o \
	$K/console.o \
	$K/systime.o \
	$K/device.o\
	$K/vfs_inode.o \
	$K/pipe.o \
	$K/sysmmap.o \
	$K/fat32.o \
	$K/file.o

ifeq ($(platform), k210)
KERN_OBJS += \
	$K/sd/fpioa.o \
	$K/sd/gpiohs.o \
	$K/sd/spi.o \
	$K/sd/utils.o \
	$K/sd/sdcard.o
else
KERN_OBJS += \
	$K/virtio_disk.o
endif

#编译工具前缀
TOOLPREFIX = riscv64-unknown-elf-

#qemu模拟器
QEMU = qemu-system-riscv64

#确定使用哪种SBI
ifeq ($(platform), k210)
SBI = $K/rustsbi/sbi-k210
else
SBI = $K/rustsbi/sbi-qemu
endif

#一系列工具
CC = $(TOOLPREFIX)gcc	#编译器
AS = $(TOOLPREFIX)gas	#汇编器
LD = $(TOOLPREFIX)ld		#链接器
OBJCOPY = $(TOOLPREFIX)objcopy		#目标文件格式转换器
OBJDUMP = $(TOOLPREFIX)objdump		#反汇编器

#编译参数
CFLAGS = -Wall -O -fno-omit-frame-pointer -ggdb
CFLAGS += -MD
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -I.
#CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)

#链接参数
LDFLAGS = -z max-page-size=4096

#确定使用哪个链接脚本
ifeq ($(platform), k210)
LINKER = tools/kernel-k210.ld
else
LINKER = tools/kernel-qemu.ld
endif

#编译内核目标文件
$T/kernel: $(KERN_OBJS) $(LINKER)
	if [ ! -d "./target" ]; then mkdir target; fi
	$(LD) $(LDFLAGS) -T $(LINKER)  $(KERN_OBJS) -o $T/kernel

#用户库文件
ULIB = $U/user_syscall.o $U/stdio.o

#main程序和test程序都是两个用来测试的小程序

#编译main程序
$T/main: $U/main.o $(ULIB)
	$(LD) $(LDFLAGS) -N -e main -Ttext 10148 -o $@ $^
	@$(OBJDUMP) -S $T/main > $T/main.asm

#编译init程序
$T/init: $U/init.o $(ULIB)
	$(LD) $(LDFLAGS) -N -e main -Ttext 10140 -o $@ $^
	@$(OBJDUMP) -S $@ > $@.asm

#编译userinit程序
$T/userinit: $U/userinit.o $(ULIB)
	$(CC) $(CFLAGS) -march=rv64g -nostdinc -I. -Ikernel -c $U/userinit.S -o $U/userinit.o
	$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $T/userinit.out $U/userinit.o
	$(OBJCOPY) -S -O binary $T/userinit.out $T/userinit

$T/test: $U/test.o $(ULIB)
	$(LD) $(LDFLAGS) -N -e main -Ttext 1000 -o $T/test.out $^
	$(OBJCOPY) -S -O binary $T/test.out $T/test
	$(OBJDUMP) -S $T/test.out > $T/test.asm
	od -t xC $T/test > $T/test.txt
	sed -i 's/^.\{7\}//g' $T/test.txt
	sed -i "s/ /,0x/g"  $T/test.txt
	sed -i '1s/.//1' $T/test.txt
	rm -rf $T/test

#CPU个数为1个
ifndef CPUS
CPUS = 1
endif

#qemu模拟器参数
QEMUOPTS = -machine virt -bios $(SBI) -kernel $T/kernel -m 8M -smp $(CPUS) -nographic
QEMUOPTS += -drive file=fs.img,if=none,format=raw,id=x0
QEMUOPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0


kernel-image = $T/kernel.bin	#烧写到k210的kernel二进制目标文件
k210-bootloader = $T/k210.bin	#烧写到k210的rustsbi二进制目标文件
k210-port = /dev/ttyUSB0	#k210的USB端口

init: $T/init $T/main

test: $T/test

#编译所有目标文件的标签
build: $T/kernel

all: $T/kernel $(SBI)
	$(OBJCOPY) $T/kernel --strip-all -O binary $(kernel-image)
	$(OBJCOPY) $(SBI) --strip-all -O binary $(k210-bootloader)
	dd if=$(kernel-image) of=$(k210-bootloader) bs=128k seek=1
	cp $(k210-bootloader) os.bin

#运行k210的标签
k210: build
	$(OBJCOPY) $T/kernel --strip-all -O binary $(kernel-image)
	$(OBJCOPY) $(SBI) --strip-all -O binary $(k210-bootloader)
	dd if=$(kernel-image) of=$(k210-bootloader) bs=128k seek=1
	sudo chmod 777 $(k210-port)
	python3 tools/kflash.py -p $(k210-port) -b 1500000 -t $(k210-bootloader)

#运行qemu的标签
qemu: build
	$(QEMU) $(QEMUOPTS)

dst = /mnt
test_src = ~/riscv/testsuits-for-oskernel/riscv-syscalls-testing/user/build/riscv64

# Make fs image
fs:
	@if [ ! -f "fs.img" ]; then \
		echo "making fs image..."; \
		dd if=/dev/zero of=fs.img bs=512k count=512; \
		mkfs.vfat -F 32 fs.img; fi
	@sudo mount fs.img $(dst)
#	@if [ ! -d "$(dst)/bin" ]; then sudo mkdir $(dst)/bin; fi
#	@sudo cp README.md $(dst)/README.md
	@sudo cp $T/init $(dst)/init
	@sudo cp $T/main $(dst)/main
	@sudo cp $T/busybox $(dst)/busybox
	@sudo cp $T/busybox_cmd.txt $(dst)/busybox_cmd.txt
	@sudo cp $T/busybox_testcode.sh $(dst)/busybox_testcode.sh
#	@for file in $$( ls ${test_src}/* ); do \
		sudo cp -r $$file $(dst)/$${file#${test_src}/};\
		done
	@sudo umount $(dst)

#根据platform参数来运行k210或qemu的标签
run: build
ifeq ($(platform),k210)
	$(OBJCOPY) $T/kernel --strip-all -O binary $(kernel-image)
	$(OBJCOPY) $(SBI) --strip-all -O binary $(k210-bootloader)
	dd if=$(kernel-image) of=$(k210-bootloader) bs=128k seek=1
	sudo chmod 777 $(k210-port)
	python3 tools/kflash.py -p $(k210-port) -b 1500000 -t $(k210-bootloader)
else 
	$(QEMU) $(QEMUOPTS)
endif

#清理中间文件的标签
clean:
	rm -f */*.o */*.d $T/kernel $T/*.bin $T/*.sym */*/*.o */*/*.d $T/*.asm $T/.out *.bin

.PHONY: clean qemu run build all init test