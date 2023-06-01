section .text
global floatClone
extern malloc
; float* floatClone(float* a)
floatClone:
	push rbp
	mov rbp, rsp
	push rbx

	mov eax, 4		
	call malloc		; reservo 4 bytes en memoria
	mov ebx, [edi] 	; rdi = *a
	mov [eax], ebx	; asigno a la posicion de memoria
					; almacenada en eax el valor de a
	pop rbx
	pop rbp
ret