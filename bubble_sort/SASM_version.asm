%include "io64.inc"

section .text
global CMAIN
CMAIN:
                mov rbp, rsp                                            ;for correct debugging
		;sub 		        rsp,8  				; Align the stack
		mov     	        r9, 0                           ; r9 = i
                mov                     r10, len                        ; r10 = len
outer_loop:
		cmp			r9,r10                          ; if i < 10 -> outer_loop done
		je			done
		mov			r8, 0                           ; r8 = j
inner_loop:
                mov                     rax, qword array
                mov                     rsi, [rax +  r8*8]              ; rsi = array[j]
                mov                     rdi, [rax + (r8 + 1)*8]         ; rdi = array[j+1]
		cmp			rsi, rdi                        ; if (rsi > rdi){swapping}; else skip
		jl			skip
                ; swapping
                mov                     rbx, [rax +  r8*8]              ; temp1 = d[j]
                mov                     rcx, [rax + (r8 + 1)*8]         ; temp2 = d[j+1]
                mov                     [rax +  r8*8], rcx              ; d[j] = temp2
                mov                     [rax + (r8 + 1)*8], rbx         ; d[j+1]= temp1 
skip:
                mov                     r11, r10                        ; r11 = len - i - 1
		sub			r11, r9
		sub			r11, 1
		cmp			r8, r11                         ; if j < len - i - 1 ->  inner_loop done i+= 1
		je inner_loop_done
		inc r8                                                  ; else j += 1
                jmp inner_loop

inner_loop_done:
                inc r9
                jmp outer_loop
      

done:
                PRINT_DEC 2,array
                NEWLINE
                PRINT_DEC 2,array + 8
                NEWLINE
                PRINT_DEC 2,array + 16
                NEWLINE
                PRINT_DEC 2,array + 24
                NEWLINE
                PRINT_DEC 2,array + 32
                NEWLINE
                PRINT_DEC 2,array + 40
                NEWLINE
                ;add 	  rsp,8
                xor       rax,rax
                ret

                          ; Return from main back into C library wrapper
		section .data
format:	db      "%d", 10, 0
array:	dq      6, 5, 4, -3, 2, -2
len	equ     ($ - array)/ 8
