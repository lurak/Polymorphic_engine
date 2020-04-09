; ----------------------------------------------------------------------------------------
; 		Bubble sort of array, with C library linking
;
;       nasm -felf64 clear_version.asm && gcc clear_version.o && ./a.out
; ----------------------------------------------------------------------------------------
			global    main
			extern    printf

main:
				mov 					rbp, rsp                        ;for correct debugging
				mov     	        	r9, 0                           ; r9 = i
				mov                		r10, len                        ; r10 = len
				sub						r10, 1							; r10 = len - 1 
outer_loop:
				cmp						r9,r10                          ; if i < len -> outer_loop done
				je						done
				mov						r8, 0                           ; r8 = j
inner_loop:
                mov                     rax, qword array
                mov                     rsi, [rax +  r8*8]              ; rsi = array[j]
				mov                     rdi, [rax + (r8 + 1)*8]         ; rdi = array[j+1]
				cmp						rsi, rdi                        ; if (rsi > rdi){swapping}; else skip
				je						skip
						; swapping
                mov                     rbx, [rax +  r8*8]              ; temp1 = d[j]
                mov                     rcx, [rax + (r8 + 1)*8]         ; temp2 = d[j+1]
                mov                     [rax +  r8*8], rcx              ; d[j] = temp2
                mov                     [rax + (r8 + 1)*8], rbx         ; d[j+1]= temp1 
skip:
                mov                     r11, r10                        ; r11 = len - i - 1
				sub						r11, r9
				sub						r11, 1
				cmp						r8, r11                         ; if j < len - i - 1 ->  inner_loop done i+= 1
				je 						inner_loop_done
				inc 					r8                                                  ; else j += 1
                jmp 					inner_loop

inner_loop_done:
                inc 					r9
                jmp 					outer_loop
      

done:
                mov						r9,0
				mov                		r10, len
				push					rbx						; align stack
print_loop:		
				cmp						r9,r10
				je						exit
				mov       				rdi, format            ; First integer (or pointer) argument in rdi
				mov						rax, qword array
				mov						rsi, [rax + r9*8]
				push					r9
				push					r10
				xor						rax,rax
				call      				printf                  ; printf(message)
				pop						r10
				pop						r9
				inc						r9
				jmp						print_loop
				
exit:
				pop						rbx						
				ret                           	  				; invoke operating system to exit


		section .data
format:	db  	  "%i", 10, 0
array:	dq      6, 5, 4, 3, 2, 1
len	equ     ($ - array)/ 8
