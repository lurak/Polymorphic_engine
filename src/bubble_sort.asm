bits 64
    org    0x4000b3 ; DYNAMICALLY CHANGING

	mov	r9, 0
    mov	r10, len
    sub	r10,1
outer_loop:
	cmp	r9,r10
	je	done
	mov	r8, 0
inner_loop:
        mov	rax, qword array
        mov	rsi, [rax +  r8*8]
        mov	rdi, [rax + (r8 + 1)*8]
	cmp	rsi, rdi
	jl	skip

        mov	rbx, [rax +  r8*8]
        mov	rcx, [rax + (r8 + 1)*8]
        mov	[rax +  r8*8], rcx
        mov	[rax + (r8 + 1)*8], rbx
skip:
        mov	r11, r10
	sub	r11, r9
	sub	r11, 1
	cmp	r8, r11
	je 	inner_loop_done
	inc 	r8
        jmp 	inner_loop
inner_loop_done:
        inc 	r9
        jmp 	outer_loop

done:
	mov	r9,0
	mov     r10, len
	push	rbx
print_loop:
	cmp	r9,r10
	je	codeEnd
	mov	r11, qword array
	mov	rax, [r11 + r9*8]
        call    _print_RAX
        inc     r9
        jmp     print_loop

_print_RAX:
        mov     rcx, digit_space
        mov     rbx,10
        mov     [rcx],rbx
        inc     rcx
        mov     [digit_space_pos], rcx
_print_RAX_loop:
        mov     rdx,0
        mov     rbx,10
        div     rbx
        push    rax
        add     rdx, 48
        mov     rcx,[digit_space_pos]
        mov     [rcx],dl
        inc     rcx
        mov     [digit_space_pos], rcx

        pop     rax
        cmp     rax,0
        jne     _print_RAX_loop

_print_RAX_loop2:
        mov     rcx, [digit_space_pos]
        mov     rax, 1
        mov     rdi, 1
        mov     rsi, rcx
        mov     rdx, 1
        syscall
        mov     rcx, [digit_space_pos]
        dec     rcx
        mov     [digit_space_pos], rcx
        cmp     rcx, digit_space
        jge     _print_RAX_loop2
        ret
        nop
        nop
        nop
        nop
codeEnd:
        mov     rax,60
        mov     rdi, 0
        syscall

; section .data
array:	dq  7, 9, 8, 1220, 3, 0
len	equ     ($ - array)/ 8

digit_space:     dq 100
digit_space_pos: dq 8

; File size calculation
filesize equ $ - $$

                                                        