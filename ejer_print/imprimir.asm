global print
extern printf
section .data
formato: db 'a %d , b %f , s %s', 10, 0
section .text
print:
	push rbp
	mov rbp, rsp

	; extern void print(int a, double f, char* s)
	; RDI = A, RSI = S
	mov rdx, rsi ; Muevo S a rdx
	mov esi, edi ; Muevo A a esi
	mov rdi, formato ; Muevo el texto completo
					 ; a rdi, XMM0 no se mueve
	mov rax, 1		 ; Indico que va a haber
					 ; un parametro Double
	call printf
	pop rbp
	ret