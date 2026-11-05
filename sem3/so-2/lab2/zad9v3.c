#define _GNU_SOURCE
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/user.h>
#include <sys/syscall.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


void write_data(void *src, void *dst, pid_t pid, size_t len)
{
	int copied = 0;
	while (len > copied) {
		uint64_t word = 0;
		size_t copy = (len - copied) >= sizeof(word) ? sizeof(word) : (len - copied);
		memcpy(&word, src + copied, copy);
		if (ptrace(PTRACE_POKEDATA, pid, dst + copied, (void*)word) == -1) {
			perror("pokedata");
			exit(-1);
		}
		copied += copy;
	}
}


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
	if (WSTOPSIG(status) != 19) {
		fprintf(stderr, "unexpected wait status: %s %d\n", strsignal(WSTOPSIG(status)), WSTOPSIG(status));
	}
}

int main(int argc, char *argv[])
{
	if (argc < 2)
		return 1;

	pid_t pid = atoi(argv[1]);
	printf("%d\n", pid);

	int status;

	if (ptrace(PTRACE_ATTACH, pid, NULL, NULL) == -1) {
		perror("ptrace attach");
		return 1;
	}
	wait_for_proc(pid);
	printf("Attached to process %d\n", pid);

	struct user_regs_struct regs, backup_regs;

	ptrace(PTRACE_GETREGS, pid, NULL, &regs);
	if (regs.orig_rax != SYS_nanosleep)
		printf("not in nanosleep: %lld\n", regs.orig_rax);

	backup_regs = regs;
	uint64_t string_addr = regs.rsp - 0x400;


	return 0;
}
