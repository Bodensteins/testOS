#ifndef __SDCARD_H
#define __SDCARD_H

void sdcard_init(void);

void sdcard_read_sector(uint8 *buf, int sectorno);

void sdcard_write_sector(uint8 *buf, int sectorno);

void sdcard_read_cluster(uint8*buf, int clusterno);

void sdcard_write_cluster(uint8*buf, int clusterno);

int _clusterno_to_sectorno(int clusterno);

int _sectorno_to_clusterno(int sectorno);

#endif 
