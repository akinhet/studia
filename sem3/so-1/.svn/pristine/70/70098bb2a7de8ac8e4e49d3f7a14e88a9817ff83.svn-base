; nasm -g -felf64 zad5.asm && ld zad5.o -o zad5 && ./zad5 1 2 3 4 5 6 7 8 9
%include "helpers.asm"
  global _start
  default abs

  section .text
_start:
  pop  rdi
  mov  rsi, rsp
  cmp  rdi, 10 ; check if got the right input
  jne  err
  mov  rcx, 1
argv_loop:
  push rdi
  push rsi
  push rcx
  mov  rdi, [rsi + rcx*8]
  call str_len ; calc string length
  mov  rsi, rax
  call str_to_int ; convert the string to int
  pop  rcx
  pop  rsi
  pop  rdi
  mov  [matrix + (rcx - 1)*8], rax
  inc  rcx
  cmp  rcx, rdi
  jl   argv_loop

  ; calc sum of elements
  mov  rdx, 9
  xor  rcx, rcx
  xor  rax, rax
sum_all_loop:
  add  rax, [matrix + rcx*8]
  inc  rcx
  cmp  rcx, rdx
  jl  sum_all_loop

  push rax
  mov  rax, 1
  mov  rdi, 1
  mov  rsi, pr1
  mov  rdx, pr1len
  syscall

  pop  rax
  mov  rdi, rax
  lea  rsi, [buffer]
  call int_to_str

  mov  rdx, rax
  mov  rax, 1
  mov  rdi, 1
  lea  rsi, [buffer]
  syscall

  ; calc sum of diagonal
  xor  rax, rax
  mov  rax, [matrix]
  add  rax, [matrix + 4*8]
  add  rax, [matrix + 8*8]

  push rax
  mov  rax, 1
  mov  rdi, 1
  mov  rsi, pr2
  mov  rdx, pr2len
  syscall

  pop  rax
  mov  rdi, rax
  lea  rsi, [buffer]
  call int_to_str

  mov  rdx, rax
  mov  rax, 1
  mov  rdi, 1
  lea  rsi, [buffer]
  syscall

  mov  rax, 60
  mov  rdi, 0
  syscall

err:
  mov  rdi, 1
  call error


  section .data
pr1:    db   "Suma elementów: "
pr1len: equ  $ - pr1
pr2:    db   "Suma przekątnej: "
pr2len: equ  $ - pr2


  section   .bss
buffer: resb  64
matrix: resq  9
