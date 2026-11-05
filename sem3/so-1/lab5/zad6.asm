; nasm -g -felf64 zad6.asm && ld zad6.o -o zad6 && ./zad6
%include "helpers.asm"
  global _start
  default abs

  section .text
_start:
  ; Show prompt
  mov  rax, 1
  mov  rdi, 1
  mov  rsi, msg
  mov  rdx, msglen
  syscall

  ; read user input
  mov  rax, 0
  mov  rdi, 0
  mov  rsi, buffer
  mov  rdx, 64
  syscall

  ; conv input to int
  mov  rsi, rax
  dec  rsi
  lea  rdi, [buffer]
  call str_to_int

  ; conv int to hex
  xor  rcx, rcx
  lea  rdi, [buffer + 63]
hex_loop:
  mov  bl, 0xf
  and  bl, al
  add  bl, '0'
  cmp  bl, '9'
  jle  isdigit ; test if the digit is 0-9 or A-F
  add  bl, 7
isdigit:
  mov  [rdi], bl
  dec  rdi
  inc  rcx
  shr  rax, 4
  jnz  hex_loop

  ; move str to front of buffer
  mov  rax, rcx
  xor  rcx, rcx
  lea  rdi, [buffer]
  lea  rsi, [buffer + 64]
  sub  rsi, rax
move_loop:
  mov  rdx, [rsi + rcx]
  mov  [rdi + rcx], rdx
  inc  rcx
  cmp  rcx, rax
  jl   move_loop
  mov  [rdi + rcx], 10
  inc  rax

  ; print buffer
  mov  rdx, rax
  mov  rax, 1
  mov  rdi, 1
  lea  rsi, [buffer]
  syscall

  ; exit program
  mov  rax, 60
  xor  rdi, rdi
  syscall

  section .data
msg:    db   "Number: "
msglen: equ  $ - msg
err:    db   "Wrong input", 10
errlen: equ  $ - err


  section   .bss
buffer: resb  64
