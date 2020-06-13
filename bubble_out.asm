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
push r12
nop
pop r12
mov	r9, 0                           ; r9 = i
push r12
pop r12
mov	r10, len                        ; r10 = len
nop
sub	r10,1
outer_loop:
cmp	r9,r10                          ; if i < 10 -> outer_loop done
push r12
pop r12
je	done
push r12
pop r12
mov	r8, 0                           ; r8 = j
inner_loop:
nop
mov	rax, qword array
push r12
nop
pop r12
mov	rsi, [rax +  r8*8]              ; rsi = array[j]
nop
mov	rdi, [rax + (r8 + 1)*8]         ; rdi = array[j+1]
cmp	rsi, rdi                        ; if (rsi > rdi){swapping}; else skip
jl	skip
; swapping
nop
mov	rbx, [rax +  r8*8]              ; temp1 = d[j]
push r12
pop r12
mov	rcx, [rax + (r8 + 1)*8]         ; temp2 = d[j+1]
push r12
pop r12
mov	[rax +  r8*8], rcx              ; d[j] = temp2
add r12, 0
sub r12, 0
mov	[rax + (r8 + 1)*8], rbx         ; d[j+1]= temp1
skip:
push r12
pop r12
mov	r11, r10                        ; r11 = len - i - 1
nop
sub	r11, r9
sub	r11,0
sub	r11,1
cmp	r8, r11                         ; if j < len - i - 1 ->  inner_loop done i+= 1
push r12
pop r12
je 	inner_loop_done
inc 	r8                              ; else j += 1
add r12, 8
sub r12, 8
jmp 	inner_loop
inner_loop_done:
inc 	r9
push r12
nop
pop r12
jmp 	outer_loop

done:
add r12, 0
sub r12, 0
mov	r9,0
push r12
nop
pop r12
mov     r10, len
push	rbx				; align stack
print_loop:
cmp	r9,r10
add r12, 8
sub r12, 8
je	exit
push r12
nop
pop r12
mov	r11, qword array
nop
mov	rax, [r11 + r9*8]
call    _print_RAX
inc     r9
push r12
nop
pop r12
jmp     print_loop

_print_RAX:
push r12
nop
pop r12
mov     rcx, digit_space
push r12
pop r12
nop
mov     rbx,10
push r12
pop r12
mov     [rcx],rbx
inc     rcx
push r12
nop
pop r12
push r12
pop r12
add r12, 4
sub r12, 4
mov     [digit_space_pos], rcx
_print_RAX_loop:
push r12
pop r12
mov     rdx,0
mov     rbx,10
div     rbx
push    rax
nop
add     rdx, 48
add r12, 6
sub r12, 6
mov     rcx,[digit_space_pos]
add r12, 8
sub r12, 8
mov     [rcx],dl
inc     rcx
mov     [digit_space_pos], rcx

pop     rax
cmp     rax,0
jne     _print_RAX_loop

_print_RAX_loop2:
add r12, 0
sub r12, 0
push r12
nop
pop r12
mov     rcx, [digit_space_pos]
add r12, 9
sub r12, 9
mov     rax, 1
push r12
nop
pop r12
mov     rdi, 1
push r12
pop r12
mov     rsi, rcx
add r12, 5
sub r12, 5
mov     rdx, 1
syscall
mov     rcx, [digit_space_pos]
dec     rcx
mov     [digit_space_pos], rcx
cmp     rcx, digit_space
jge     _print_RAX_loop2
ret
exit:
add r12, 4
sub r12, 4
mov     rax,60
push r12
nop
pop r12
mov     rdi, 0
syscall
