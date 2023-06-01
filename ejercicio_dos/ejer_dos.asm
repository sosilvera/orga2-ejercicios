global sumar
section .text
sumar:
	push rbp
	addpd xmm0, xmm1
	pop rbp
	ret