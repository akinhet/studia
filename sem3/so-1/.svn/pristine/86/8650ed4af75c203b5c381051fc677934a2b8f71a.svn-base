#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ptrace.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/user.h>
#include <sys/wait.h>
#include <unistd.h>

#define ASMLEN sizeof(code) - 1

const int long_size = sizeof(long);

struct user_regs_struct regs, backup_regs;

// char code[] = "\x90\x90\xeb\x19\x5e\x48\xc7\xc0\x01\x00" // print hello world
//               "\x00\x00\x48\xc7\xc7\x02\x00\x00"
//               "\x00\x48\xc7\xc2\x0c\x00\x00\x00"
//               "\x0f\x05\xcc\xe8\xe2\xff\xff\xff"
//               "\x48\x65\x6c\x6c\x6f\x20\x57\x6f"
//               "\x72\x6c\x64\x0a\x00\x90\x5d\xc3";

char code[] = "\x48\x8d\x3d\x2e\x00\x00\x00\xbe" // open /tmp/log, dup2 to stdout, close
              "\x41\x04\x00\x00\xba\xa4\x01\x00"
              "\x00\xb8\x02\x00\x00\x00\x0f\x05"
              "\x48\x89\xc3\x48\x89\xdf\xbe\x01"
              "\x00\x00\x00\xb8\x21\x00\x00\x00"
              "\x0f\x05\x48\x89\xdf\xb8\x03\x00"
              "\x00\x00\x0f\x05\xcc\x2f\x74\x6d"
              "\x70\x2f\x6c\x6f\x67\x00";

char backup[ASMLEN];


void wait_for_proc(pid_t pid)
{
	int status;
	if (waitpid(pid, &status, 0) == -1) {
		perror("wait");
		exit(1);
	}
    if (!WIFSTOPPED(status)) {
		fprintf(stderr, "process didnt stop\n");
		exit(1);
    }
}


void getdata(pid_t child, long addr, char *str, int len)
{
	char *laddr;
	int i, j;
	union u {
			long val;
			char chars[long_size];
	}data;
	i = 0;
	j = len / long_size;
	laddr = str;
	while(i < j) {
		data.val = ptrace(PTRACE_PEEKDATA, child,
						  addr + i * long_size, NULL);
		memcpy(laddr, data.chars, long_size);
		++i;
		laddr += long_size;
	}
	j = len % long_size;
	if(j != 0) {
		data.val = ptrace(PTRACE_PEEKDATA, child,
						  addr + i * long_size, NULL);
		memcpy(laddr, data.chars, j);
	}
	str[len] = '\0';
}


void putdata(pid_t child, long addr, char *str, int len)
{
	char *laddr;
	int i, j;
	union u {
			long val;
			char chars[long_size];
	}data;
	i = 0;
	j = len / long_size;
	laddr = str;
	while(i < j) {
		memcpy(data.chars, laddr, long_size);
		ptrace(PTRACE_POKEDATA, child,
			   addr + i * long_size, data.val);
		++i;
		laddr += long_size;
	}
	j = len % long_size;
	if(j != 0) {
		memcpy(data.chars, laddr, j);
		ptrace(PTRACE_POKEDATA, child,
			   addr + i * long_size, data.val);
	}
}


int main(int argc, char *argv[])
{
	if (argc < 2)
		return 1;

	pid_t pid = atoi(argv[1]);
	printf("%d\n", pid);

	if (ptrace(PTRACE_ATTACH, pid, NULL, NULL) == -1) {
		perror("ptrace attach");
		return 1;
	}
	wait_for_proc(pid);
	printf("Attached to process %d\n", pid);

	ptrace(PTRACE_GETREGS, pid, NULL, &regs);
	backup_regs = regs;
	printf("backup\n");
	getdata(pid, regs.rip, backup, ASMLEN);
	printf("inejct\n");
	putdata(pid, regs.rip, code, ASMLEN);
	printf("continue\n");
	regs.rip += 2;
	ptrace(PTRACE_SETREGS, pid, NULL, &regs);
	printf("step\n");

	if (ptrace(PTRACE_CONT, pid, NULL, NULL) == -1) {
		printf("continue broke\n");
		exit(1);
	} else {
		printf("continue\n");
	}
	wait_for_proc(pid);

	printf("press a key to continue\n");
	getchar();
	regs = backup_regs;
	putdata(pid, regs.rip, backup, ASMLEN);

	ptrace(PTRACE_SETREGS, pid, NULL, &regs);

	if (ptrace(PTRACE_DETACH, pid, NULL, NULL) == -1) {
		perror("ptrace detach");
		return 1;
	}
	printf("Detached from process %d\n", pid);
	return 0;
}
