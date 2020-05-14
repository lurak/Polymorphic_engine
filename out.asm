BITS 64
section .text

_start:
nop
mov	r9, 0
nop
mov r10, 10
nop
mov eax, 5
nop
sub	r10, 1
add eax,8
sub eax,1
pop eax
push eax
cmp r9, r10
