; nasm -g -felf64 zad4.asm && ld zad4.o -o zad4 && ./zad4
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

  ; calculate the sum of digits
  mov  rdi, rax
  dec  rdi
  ; rdi is index in the buffer from the back, rdx is the sum
  mov  rdx, 0
sum_loop:
  mov  al, [buffer + rdi - 1]
  sub  al, 0x30
  cmp  al, 9
  ja   error
  movzx rax, al
  add  rdx, rax
  dec  rdi
  jnz  sum_loop

  ; convert the int to a string
  mov  rdi, rdx
  lea  rsi, [buffer]
  call int_to_str

  ; print input
  mov  rdx, rax
  mov  rax, 1
  lea  rsi, [buffer]
  mov  rdi, 1
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
