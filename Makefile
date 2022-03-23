#platform = qemu
platform = k210

K = kernel
U = user
T = target
#O = obj

KERN_OBJS = \
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
	$K/schedule.o

USER_OBJS = \
	$U/test.o \
	$U/stdio.o \
	$U/user_syscall.o

TOOLPREFIX = riscv64-unknown-elf-

QEMU = qemu-system-riscv64

ifeq ($(platform), k210)
SBI = $K/rustsbi/sbi-k210
else
SBI = $K/rustsbi/sbi-qemu
endif

CC = $(TOOLPREFIX)gcc
AS = $(TOOLPREFIX)gas
LD = $(TOOLPREFIX)ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump

CFLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb
CFLAGS += -MD
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -I.
#CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)

LDFLAGS = -z max-page-size=4096

ifeq ($(platform), k210)
LINKER = tools/kernel-k210.ld
else
LINKER = tools/kernel-qemu.ld
endif

$T/kernel: $(KERN_OBJS) $(USER_OBJS) $(LINKER)
	if [ ! -d "./target" ]; then mkdir target; fi
	$(LD) $(LDFLAGS) -T $(LINKER)  $(KERN_OBJS) $(USER_OBJS) -o $T/kernel

ifndef CPUS
CPUS = 1
endif

QEMUOPTS = -machine virt -bios $(SBI) -kernel $T/kernel -m 128M -smp $(CPUS) -nographic
#QEMUOPTS += -drive file=fs.img,if=none,format=raw,id=x0
#QEMUOPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

kernel-image = $T/kernel.bin
k210-bootloader = $T/rustsbi.bin
k210-port = /dev/ttyUSB0

build: $T/kernel

k210: build
	$(OBJCOPY) $T/kernel --strip-all -O binary $(kernel-image)
	$(OBJCOPY) $(SBI) --strip-all -O binary $(k210-bootloader)
	dd if=$(kernel-image) of=$(k210-bootloader) bs=128k seek=1
	sudo chmod 777 $(k210-port)
	python3 tools/kflash.py -p $(k210-port) -b 1500000 -t $(k210-bootloader)

qemu: build
	$(QEMU) $(QEMUOPTS)


clean:
	rm -f */*.o */*.d $T/kernel $T/*.bin

.PHONY: clean qemu run build