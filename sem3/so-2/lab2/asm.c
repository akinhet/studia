void main()
{
__asm__("                  \n\
         jmp forward       \n\
backward:                  \n\
         pop    %rsi       \n\
         mov    $1, %rax   \n\
         mov    $2, %rdi   \n\
        #mov    %rsi, %rcx \n\
         mov    $12, %rdx  \n\
         syscall           \n\
         int3              \n\
forward:                   \n\
         call   backward   \n\
         .string \"Hello World\\n\""
       );
}
