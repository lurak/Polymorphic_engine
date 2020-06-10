 BITS 64
section .text

_start:
	mov	r9, 0
    mov	r10, 10
    mov eax, 5
    sub	r10,1
    add eax, 7
    cmp r9, r10
