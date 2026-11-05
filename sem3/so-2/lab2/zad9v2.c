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

static void die(const char *msg) {
    perror(msg);
    exit(1);
}

static void wait_for_stop(pid_t pid) {
    int status;
    if (waitpid(pid, &status, 0) < 0) die("waitpid");
    if (!WIFSTOPPED(status)) {
        fprintf(stderr, "unexpected wait status: %d\n", status);
        exit(1);
    }
}

static void write_data(pid_t pid, uint8_t *dest, const void *src, size_t len) {
    size_t i = 0;
    const uint8_t *s = src;
    while (i < len) {
        uint64_t val = 0;
        size_t copy = (len - i) >= sizeof(val) ? sizeof(val) : (len - i);
        memcpy(&val, s + i, copy);
        if (ptrace(PTRACE_POKEDATA, pid, dest + i, (void*)val) == -1) die("PTRACE_POKEDATA");
        i += copy;
    }
}

static uint64_t read_word(pid_t pid, uint8_t *addr) {
    errno = 0;
    long v = ptrace(PTRACE_PEEKDATA, pid, addr, 0);
    if (v == -1 && errno) die("PTRACE_PEEKDATA");
    return (uint64_t)v;
}

static void write_word(pid_t pid, uint8_t *addr, uint64_t val) {
    if (ptrace(PTRACE_POKEDATA, pid, addr, (void*)val) == -1) die("PTRACE_POKEDATA");
}

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <pid> </full/path/to/errors.log>\n", argv[0]);
        return 2;
    }

    pid_t pid = (pid_t)atoi(argv[1]);
    const char *path = argv[2];
    if (path[0] != '/') {
        fprintf(stderr, "Please provide an absolute path for the log file.\n");
        return 2;
    }

    if (ptrace(PTRACE_ATTACH, pid, NULL, NULL) == -1) die("PTRACE_ATTACH");
    wait_for_stop(pid);

    struct user_regs_struct regs, saved_regs;
    if (ptrace(PTRACE_GETREGS, pid, NULL, &regs) == -1) die("PTRACE_GETREGS");
    saved_regs = regs;

    uint64_t remote_rsp = regs.rsp - 0x400;
    uint64_t write_addr = remote_rsp & ~0x7ULL;

    size_t path_len = strlen(path) + 1;
    write_data(pid, (uint8_t*)write_addr, path, path_len);

    uint8_t *rip = (uint8_t*)regs.rip;
    uint64_t orig_code = read_word(pid, rip);

    uint64_t injected = (uint64_t)0xCC050F;
    write_word(pid, rip, injected);

    regs.rax = SYS_openat;
    regs.rdi = AT_FDCWD;
    regs.rsi = write_addr;
    regs.rdx = O_WRONLY | O_CREAT | O_APPEND;
    regs.r10 = 0666;
    if (ptrace(PTRACE_SETREGS, pid, NULL, &regs) == -1) die("PTRACE_SETREGS (openat)");
    if (ptrace(PTRACE_SINGLESTEP, pid, NULL, NULL) == -1) die("PTRACE_SINGLESTEP (openat)");
    wait_for_stop(pid);

    if (ptrace(PTRACE_GETREGS, pid, NULL, &regs) == -1) die("PTRACE_GETREGS after openat");
    long newfd = (long)regs.rax;
    if (newfd < 0) {
        write_word(pid, rip, orig_code);
        ptrace(PTRACE_SETREGS, pid, NULL, &saved_regs);
        ptrace(PTRACE_DETACH, pid, NULL, NULL);
        return 1;
    }

#ifdef SYS_dup2
    regs.rax = SYS_dup2;
    regs.rdi = newfd;
    regs.rsi = 2;
    regs.rdx = 0;
#else
    regs.rax = SYS_dup3;
    regs.rdi = newfd;
    regs.rsi = 2;
    regs.rdx = 0;
#endif
    if (ptrace(PTRACE_SETREGS, pid, NULL, &regs) == -1) die("PTRACE_SETREGS (dup2)");
    if (ptrace(PTRACE_SINGLESTEP, pid, NULL, NULL) == -1) die("PTRACE_SINGLESTEP (dup2)");
    wait_for_stop(pid);

    if (ptrace(PTRACE_GETREGS, pid, NULL, &regs) == -1) die("PTRACE_GETREGS after dup2");
    long dup_ret = (long)regs.rax;
    if (dup_ret < 0) {
        write_word(pid, rip, orig_code);
        ptrace(PTRACE_SETREGS, pid, NULL, &saved_regs);
        ptrace(PTRACE_DETACH, pid, NULL, NULL);
        return 1;
    }

    regs.rax = SYS_close;
    regs.rdi = newfd;
    if (ptrace(PTRACE_SETREGS, pid, NULL, &regs) == -1) die("PTRACE_SETREGS (close)");
    if (ptrace(PTRACE_SINGLESTEP, pid, NULL, NULL) == -1) die("PTRACE_SINGLESTEP (close)");
    wait_for_stop(pid);
    if (ptrace(PTRACE_GETREGS, pid, NULL, &regs) == -1) die("PTRACE_GETREGS after close");

    write_word(pid, rip, orig_code);
    if (ptrace(PTRACE_SETREGS, pid, NULL, &saved_regs) == -1) die("PTRACE_SETREGS (restore)");
    if (ptrace(PTRACE_DETACH, pid, NULL, NULL) == -1) die("PTRACE_DETACH");

    printf("Successfully redirected pid %d stderr -> %s (fd %ld dup'd to fd 2)\n", pid, path, newfd);
    return 0;
}
