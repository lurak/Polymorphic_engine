BITS 64
section .text

_start:
add eax, 5
sub eax, 5
mov	r9, 0
push r10
pop r10
mov	r10, 10
push r10
pop r10
mov eax, 5
nop
sub	r10,1
add eax,11
sub eax,4
cmp r10, r9