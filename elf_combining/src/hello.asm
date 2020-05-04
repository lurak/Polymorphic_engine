bits 64
    org    0x40008b      ;Program load offset
_start:

    xor     rax,rax
    mov     rdi,1
    mov     rsi,message
    mov     rdx,message.len
    inc     rax
    syscall
    mov       rax, 60                 ; system call for exit
    xor       rdi, rdi                ; exit code 0
    syscall                           ; invoke operating system to exit

; section .data
message:    db  'Hello, world! Im new message',0x0A    ;message and newline
.len:       equ $-message               ;message length calculation
filesize    equ $ - $$

