; nasm -f elf64 payload.s -o payload.o
; objcopy -O binary --only-section=.text payload.o payload.bin
; xxd -p payload.bin | tr -d '\n' | sed 's/../\\x&/g' ; echo
BITS 64
SECTION .text
global payload_start
payload_start:
    lea     rdi, [rel path]
    mov     rsi, 0x441
    mov     rdx, 0o644
    mov     rax, 2
    syscall ; open
    mov     rbx, rax
    mov     rdi, rbx
    mov     rsi, 1
    mov     rax, 33
    syscall ; dup2
    mov     rdi, rbx
    mov     rax, 3
    syscall ; close
    int3
path: db "/tmp/log",0
