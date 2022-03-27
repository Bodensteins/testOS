#ifndef _PM_H_
#define _PM_H_

// Initialize phisical memeory manager
void pm_init();
// Allocate a free physical page
void* alloc_physical_page();
// Free an allocated page
void free_physical_page(void* pa);

#endif