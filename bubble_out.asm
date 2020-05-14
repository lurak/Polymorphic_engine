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
pop eax
nop
push eax
mov	r9, 0                           ; r9 = i
pop eax
nop
push eax
mov	r10, len                        ; r10 = len
pop eax
push eax
sub	r10,1
outer_loop:
sub eax, 6
add eax, 6
cmp	r9,r10                          ; if i < 10 -> outer_loop done
sub eax, 4
add eax, 4
je	done
pop eax
nop
push eax
mov	r8, 0                           ; r8 = j
inner_loop:
pop eax
nop
push eax
mov	rax, qword array
nop
mov	rsi, [rax +  r8*8]              ; rsi = array[j]
sub eax, 7
add eax, 7
mov	rdi, [rax + (r8 + 1)*8]         ; rdi = array[j+1]
pop eax
push eax
cmp	rsi, rdi                        ; if (rsi > rdi){swapping}; else skip
jl	skip
; swapping
pop eax
nop
push eax
mov	rbx, [rax +  r8*8]              ; temp1 = d[j]
pop eax
push eax
mov	rcx, [rax + (r8 + 1)*8]         ; temp2 = d[j+1]
sub eax, 5
add eax, 5
mov	[rax +  r8*8], rcx              ; d[j] = temp2
nop
mov	[rax + (r8 + 1)*8], rbx         ; d[j+1]= temp1
skip:
sub eax, 3
add eax, 3
mov	r11, r10                        ; r11 = len - i - 1
nop
sub	r11, r9
nop
sub	r11, 1
nop
cmp	r8, r11                         ; if j < len - i - 1 ->  inner_loop done i+= 1
pop eax
nop
push eax
je 	inner_loop_done
inc 	r8                              ; else j += 1
pop eax
nop
push eax
jmp 	inner_loop
inner_loop_done:
inc 	r9
sub eax, 3
add eax, 3
jmp 	outer_loop

done:
nop
mov	r9,0
pop eax
push eax
mov     r10, len
push	rbx				; align stack
print_loop:
pop eax
nop
push eax
cmp	r9,r10
nop
je	exit
pop eax
nop
push eax
mov	r11, qword array
nop
mov	rax, [r11 + r9*8]
call    _print_RAX
inc     r9
pop eax
push eax
jmp     print_loop

_print_RAX:
sub eax, 3
add eax, 3
mov     rcx, digit_space
pop eax
nop
push eax
nop
mov     rbx,10
pop eax
push eax
mov     [rcx],rbx
inc     rcx
pop eax
push eax
nop
nop
mov     [digit_space_pos], rcx
_print_RAX_loop:
pop eax
push eax
mov     rdx,0
mov     rbx,10
div     rbx
push    rax
add     rdx,17
add     rdx,31
nop
mov     rcx,[digit_space_pos]
nop
mov     [rcx],dl
inc     rcx
mov     [digit_space_pos], rcx

pop     rax
nop
cmp     rax,0
jne     _print_RAX_loop

_print_RAX_loop2:
sub eax, 1
add eax, 1
sub eax, 5
add eax, 5
mov     rcx, [digit_space_pos]
pop eax
push eax
mov     rax, 1
sub eax, 9
add eax, 9
mov     rdi, 1
pop eax
nop
push eax
mov     rsi, rcx
nop
mov     rdx, 1
syscall
mov     rcx, [digit_space_pos]
dec     rcx
mov     [digit_space_pos], rcx
sub eax, 0
add eax, 0
cmp     rcx, digit_space
jge     _print_RAX_loop2
ret
exit:
nop
mov     rax,60
pop eax
nop
push eax
mov     rdi, 0
syscall
