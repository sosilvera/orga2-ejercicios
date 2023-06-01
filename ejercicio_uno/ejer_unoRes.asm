section .text
global fun
fun:
	push rbp
	mov rbp, rsp

	; edi: entero1
	; esi: entero2
	add edi, esi

	mov eax, edi

	pop rbp
	ret
