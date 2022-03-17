K=kernel
U=user

KERN_OBJS = \
	$K/entry.o \
	$K/mstart.o \
	$K/sstart.o \
	$K/uart.o \
	$K/load_store.o \
	$K/timevec.o \
	$K/timetrap.o \
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

$K/kernel: $(KERN_OBJS) $(USER_OBJS) $K/kernel.ld
	$(LD) $(LDFLAGS) -T $K/kernel.ld  $(KERN_OBJS) $(USER_OBJS) -o $K/kernel

ifndef CPUS
CPUS := 1
endif

QEMUOPTS = -machine virt -bios none -kernel $K/kernel -m 128M -smp $(CPUS) -nographic
#QEMUOPTS += -drive file=fs.img,if=none,format=raw,id=x0
#QEMUOPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

qemu: $K/kernel
	$(QEMU) $(QEMUOPTS)


clean:
	rm -f */*.o */*.d $K/kernel

.PHONY: clean