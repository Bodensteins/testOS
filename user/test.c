#include "user_syscall.h"

char *test_files[] = {
	"brk", 
	//"chdir", 
	"clone", 
	"close", 
	"dup2", 
	"dup", 
	"execve", 
	"exit", 
	"fork", 
	//"fstat", 
	//"getcwd", 
	//"getdents", 
	"getpid", 
	"getppid", 
	"gettimeofday",
	"mkdir_", 
	//"mmap",
	"mount", 
	//"munmap",
	"openat", 
	"open", 
	//"pipe", 
	"read", 
	"times",
	"umount", 
	"uname", 
	//"unlink", 
	"wait", 
	"waitpid", 
	"write", 
	"yield", 
	"sleep", 
};
int const test_file_num = sizeof(test_files) / sizeof(char const*);

void main(void) __attribute__((naked));
void main(void) {
	int fd=openat(-100,"/dev/console",0x4);
	dup(fd);
	dup(fd);

	for (int i = 0; i < test_file_num; i ++) {
		if (fork() == 0) {
			execve(test_files[i],NULL , NULL);
		}
		else {
			wait4(-1,NULL,0);
		}
	}
	
	exit(0);
}
