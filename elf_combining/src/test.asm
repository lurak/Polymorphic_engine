bits 64
    org   0x40009f

 

 
      ;Program load offset
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
mov       rax, 60                 ; system call for exit
xor       rdi, rdi                ; exit code 0
syscall                           ; invoke operating system to exit
; File size calculation
filesize equ $ - $$
