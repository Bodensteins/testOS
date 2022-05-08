#ifndef __SDCARD_H
#define __SDCARD_H

void sdcard_init(void);

void sdcard_read_sector(uint8 *buf, int sectorno);

void sdcard_write_sector(uint8 *buf, int sectorno);

void sdcard_read_block(uint8*buf, int blockno);

void sdcard_write_block(uint8*buf, int blockno);

int _blockno_to_sectorno(int blockno);

int _sectorno_to_blockno(int sectorno);

#endif 
