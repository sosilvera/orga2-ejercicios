section .text
global suma_parametros
suma_parametros:
push rbp
mov rbp, rsp

;int a0 = RDI, int a1 = RSI, int a2 = RDX, int a3 = RCX, int a4 = R8, int a5 = R9, int a6 = [rsp + 8], int a7 = [rsp + 24]
;a0-a1+a2-a3+a4-a5+a6-a7
sub rdi, rsi 	;a0-a1
add rdi, rdx 	;+a2
sub rdi, rcx 	;-a3
add rdi, r8 	;+a4
sub rdi, r9 	;-a5
add rdi, [rsp + 16] ;+a6
sub rdi, [rsp + 24]	;-a7

mov rax, rdi
pop rbp
ret