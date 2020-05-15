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
nop
mov	r9, 0                           ; r9 = i
nop
mov	r10, len                        ; r10 = len
sub	r10,0
sub	r10,1
outer_loop:
nop
cmp	r9,r10                          ; if i < 10 -> outer_loop done
push r10
pop r10
je	done
push r10
pop r10
mov	r8, 0                           ; r8 = j
inner_loop:
add eax, 9
sub eax, 9
mov	rax, qword array
push r10
nop
pop r10
mov	rsi, [rax +  r8*8]              ; rsi = array[j]
push r10
pop r10
mov	rdi, [rax + (r8 + 1)*8]         ; rdi = array[j+1]
push r10
pop r10
cmp	rsi, rdi                        ; if (rsi > rdi){swapping}; else skip
jl	skip
; swapping
push r10
pop r10
mov	rbx, [rax +  r8*8]              ; temp1 = d[j]
push r10
pop r10
mov	rcx, [rax + (r8 + 1)*8]         ; temp2 = d[j+1]
push r10
pop r10
mov	[rax +  r8*8], rcx              ; d[j] = temp2
nop
mov	[rax + (r8 + 1)*8], rbx         ; d[j+1]= temp1
skip:
push r10
pop r10
mov	r11, r10                        ; r11 = len - i - 1
nop
sub	r11, r9
sub	r11,0
sub	r11,0
sub	r11,1
add eax, 5
sub eax, 5
cmp	r8, r11                         ; if j < len - i - 1 ->  inner_loop done i+= 1
push r10
pop r10
je 	inner_loop_done
inc 	r8                              ; else j += 1
push r10
pop r10
jmp 	inner_loop
inner_loop_done:
inc 	r9
push r10
nop
pop r10
jmp 	outer_loop

done:
add eax, 1
sub eax, 1
mov	r9,0
nop
mov     r10, len
push	rbx				; align stack
print_loop:
nop
cmp	r9,r10
add eax, 2
sub eax, 2
je	exit
push r10
pop r10
mov	r11, qword array
push r10
pop r10
mov	rax, [r11 + r9*8]
call    _print_RAX
inc     r9
push r10
pop r10
jmp     print_loop

_print_RAX:
push r10
nop
pop r10
mov     rcx, digit_space
push r10
pop r10
add eax, 9
sub eax, 9
mov     rbx,10
add eax, 2
sub eax, 2
mov     [rcx],rbx
inc     rcx
nop
nop
add eax, 6
sub eax, 6
mov     [digit_space_pos], rcx
_print_RAX_loop:
nop
mov     rdx,0
mov     rbx,10
div     rbx
push    rax
push r10
pop r10
add     rdx, 48
add eax, 8
sub eax, 8
mov     rcx,[digit_space_pos]
push r10
pop r10
mov     [rcx],dl
inc     rcx
mov     [digit_space_pos], rcx

pop     rax
push r10
pop r10
cmp     rax,0
jne     _print_RAX_loop

_print_RAX_loop2:
nop
nop
mov     rcx, [digit_space_pos]
push r10
nop
pop r10
mov     rax, 1
push r10
nop
pop r10
mov     rdi, 1
push r10
pop r10
mov     rsi, rcx
push r10
nop
pop r10
mov     rdx, 1
syscall
mov     rcx, [digit_space_pos]
dec     rcx
mov     [digit_space_pos], rcx
push r10
pop r10
cmp     rcx, digit_space
jge     _print_RAX_loop2
ret
exit:
nop
mov     rax,60
push r10
pop r10
mov     rdi, 0
syscall
