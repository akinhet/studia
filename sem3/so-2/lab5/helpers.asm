  default abs

  section .text
; rdi = error code
error:
  push rdi
  mov  rax, 1
  mov  rdi, 2
  mov  rsi, errstr
  mov  rdx, errstrlen
  syscall

  ; exit program
  mov  rax, 60
  pop  rdi
  syscall


; rdi = string address
; returns int
str_len:
  xor  rax, rax
  dec  rax
_str_len_loop:
  inc  rax
  cmp byte [rdi + rax], 0
  jne   _str_len_loop
  ret


; rdi = string address, rsi = string length
; returns int
str_to_int:
  xor  rcx, rcx
  xor  rax, rax
_str_to_int_loop:
  mov  bl, byte [rdi + rcx]
  sub  bl, '0'
  cmp  bl, 9
  ja   _str_to_int_error
  movzx rbx, bl
  mul  rax, 10
  add  rax, rbx
  inc  rcx
  cmp  rcx, rsi
  jl   _str_to_int_loop
  ret
_str_to_int_error:
  mov  rdi, 2
  call error


; rdi = int, rsi = buffer address
; returns string length
int_to_str:
  mov  rax, rdi
  lea  rdi, [rsi + 62]
  mov  byte [rdi + 1], 10
  mov  rcx, 10
_int_to_str_loop:
  xor  rdx, rdx
  div  rcx
  add  dl, '0'
  mov  [rdi], dl
  dec  rdi
  test rax, rax
  jnz  _int_to_str_loop

  lea  rax, [rsi + 63]
  sub  rax, rdi
  mov  rdi, rsi
  lea  rsi, [rsi + 64]
  sub  rsi, rax
  xor  rcx, rcx
_int_to_string_move_loop:
  mov  rdx, [rsi + rcx]
  mov  [rdi + rcx], rdx
  inc  rcx
  cmp  rcx, rax
  jle _int_to_string_move_loop
  ret



  section .data
errstr:    db   "Wrong input", 10
errstrlen: equ  $ - errstr
