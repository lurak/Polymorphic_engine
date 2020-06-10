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
push r10
pop r10
mov	r10, len                        ; r10 = len
sub	r10,0
sub	r10,0
sub	r10,1
outer_loop:
nop
cmp	r9,r10                          ; if i < 10 -> outer_loop done
add eax, 4
sub eax, 4
je	done
add eax, 8
sub eax, 8
mov	r8, 0                           ; r8 = j
inner_loop:
push r10
pop r10
mov	rax, qword array
push r10
nop
pop r10
mov	rsi, [rax +  r8*8]              ; rsi = array[j]
add eax, 6
sub eax, 6
mov	rdi, [rax + (r8 + 1)*8]         ; rdi = array[j+1]
cmp rdi                        ; if (rsi > rdi){swapping}; else skip, rsi
jl	skip
; swapping
add eax, 3
sub eax, 3
mov	rbx, [rax +  r8*8]              ; temp1 = d[j]
nop
mov	rcx, [rax + (r8 + 1)*8]         ; temp2 = d[j+1]
nop
mov	[rax +  r8*8], rcx              ; d[j] = temp2
add eax, 2
sub eax, 2
mov	[rax + (r8 + 1)*8], rbx         ; d[j+1]= temp1
skip:
push r10
nop
pop r10
mov	r11, r10                        ; r11 = len - i - 1
nop
sub	r11, r9
push r10
pop r10
sub	r11, 1
push r10
pop r10
cmp	r8, r11                         ; if j < len - i - 1 ->  inner_loop done i+= 1
push r10
pop r10
je 	inner_loop_done
inc 	r8                              ; else j += 1
nop
jmp 	inner_loop
inner_loop_done:
inc 	r9
push r10
pop r10
jmp 	outer_loop

done:
nop
mov	r9,0
push r10
pop r10
mov     r10, len
push	rbx				; align stack
print_loop:
push r10
pop r10
cmp	r9,r10
push r10
pop r10
je	exit
push r10
nop
pop r10
mov	r11, qword array
push r10
nop
pop r10
mov	rax, [r11 + r9*8]
call    _print_RAX
inc     r9
add eax, 1
sub eax, 1
jmp     print_loop

_print_RAX:
push r10
nop
pop r10
mov     rcx, digit_space
nop
push r10
nop
pop r10
mov     rbx,10
add eax, 9
sub eax, 9
mov     [rcx],rbx
inc     rcx
push r10
pop r10
add eax, 0
sub eax, 0
push r10
pop r10
mov     [digit_space_pos], rcx
_print_RAX_loop:
push r10
nop
pop r10
mov     rdx,0
mov     rbx,10
div     rbx
push    rax
nop
add     rdx, 48
add eax, 9
sub eax, 9
mov     rcx,[digit_space_pos]
push r10
nop
pop r10
mov     [rcx],dl
inc     rcx
mov     [digit_space_pos], rcx

pop     rax
nop
cmp     rax,0
jne     _print_RAX_loop

_print_RAX_loop2:
push r10
nop
pop r10
nop
mov     rcx, [digit_space_pos]
push r10
nop
pop r10
mov     rax, 1
add eax, 1
sub eax, 1
mov     rdi, 1
nop
mov     rsi, rcx
add eax, 7
sub eax, 7
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
push r10
nop
pop r10
mov     rax,60
push r10
nop
pop r10
mov     rdi, 0
syscall
