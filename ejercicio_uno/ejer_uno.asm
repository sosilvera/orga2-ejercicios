global sumar
section .text
sumar:
	push rbp
	add rdi, rsi
	mov rax, rdi
	pop rbp
	ret