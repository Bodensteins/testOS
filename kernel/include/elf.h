#ifndef _ELF_H_
#define _ELF_H_

#include "types.h"

#define ELF_MAGIC 0x464C457FU  // "\x7FELF" in little endian
#define NIDENT 12

//prog_header type
#define ELF_PROG_LOAD 1

//prog_header flags
#define ELF_PROG_FLAG_EXEC      1
#define ELF_PROG_FLAG_WRITE     2
#define ELF_PROG_FLAG_READ      4

typedef  uint64 elf64_addr;
typedef uint64 elf64_off;

typedef struct elf64_header{
    uint32 magic;
    uchar ident[NIDENT];
    uint16 type;
    uint16 machine;
    uint32 version;
    elf64_addr entry;
    elf64_off ph_off;
    elf64_off sh_off;
    uint32 flags;
    uint16 eh_size;
    uint16 phent_size;
    uint16 ph_num;
    uint16 shent_size;
    uint16 sh_num;
    uint16 sh_str_ndx;
}elf64_header;

typedef struct elf64_prog_header{
    uint32 type;
    uint32 flags;
    elf64_off offset;
    elf64_addr va;
    elf64_addr pa;
    uint64 file_size;
    uint64 mem_size;
    uint64 align;
}elf64_prog_header;

typedef struct elf64_section_header{
    uint32 name;
    uint32 type;
    uint64 flags;
    elf64_addr addr;
    elf64_off offset;
    uint64 size;
    uint32 link;
    uint32 info;
    uint64 align;
    uint64 entsize;
}elf64_section_header;

#endif