; ----------------------------------------------------------------------------------------
; 		Bubble sort of array, with syscalls
;
;      nasm -felf64 bubble_sort.asm && ld bubble_sort.o && ./a.out
;      nasm -felf64 -g -F dwarf bubble_sort.asm && ld bubble_sort.o && gdb a.out
; ----------------------------------------------------------------------------------------
    BITS 64

section .data
        array:	dq  7, 9, 8, 120, 2, 1
        len	equ     ($ - array)/ 8

section   .bss
        digit_space     resb 100
        digit_space_pos resb 8
section .text

global    _start
       default rel

_start:
	mov	r9, 0                           ; r9 = i
        mov	r10, len                        ; r10 = len
        sub	r10,1
outer_loop:
	cmp	r9,r10                          ; if i < 10 -> outer_loop done
	je	done
	mov	r8, 0                           ; r8 = j
inner_loop:
        mov	rax, qword array
        mov	rsi, [rax +  r8*8]              ; rsi = array[j]
        mov	rdi, [rax + (r8 + 1)*8]         ; rdi = array[j+1]
	cmp	rsi, rdi                        ; if (rsi > rdi){swapping}; else skip
	jl	skip
                	; swapping
        mov	rbx, [rax +  r8*8]              ; temp1 = d[j]
        mov	rcx, [rax + (r8 + 1)*8]         ; temp2 = d[j+1]
        mov	[rax +  r8*8], rcx              ; d[j] = temp2
        mov	[rax + (r8 + 1)*8], rbx         ; d[j+1]= temp1
skip:
        mov	r11, r10                        ; r11 = len - i - 1
	sub	r11, r9
	sub	r11, 1
	cmp	r8, r11                         ; if j < len - i - 1 ->  inner_loop done i+= 1
	je 	inner_loop_done
	inc 	r8                              ; else j += 1
        jmp 	inner_loop
inner_loop_done:
        inc 	r9
        jmp 	outer_loop

done:
	mov	r9,0
	mov     r10, len
	push	rbx				; align stack
print_loop:
	cmp	r9,r10
	je	exit
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
exit:
        mov     rax,60
        mov     rdi, 0
        syscall

