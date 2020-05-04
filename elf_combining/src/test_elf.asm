BITS 64
;org    0x00400000      ;Program load offset
section .text
global   _start

;Hello World!/your program here
_start:
mov al,12h ; set the key
mov edi, codeEnd ; starting address
;mov ecx, codeEnd - codeStart ; length of encrypted block

;    now decrypt the code, starting from the last byte
decryptLoop:
    xor byte [edi], al ; decrypt byte
    dec edi ; move to the next byte
    loop decryptLoop
codeStart:
nop
nop
nop
nop
nop
nop
codeEnd:

