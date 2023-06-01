global suma
section .text

suma:
	;rdi: v rsi: N
	;Acumulo el resultado de l asuma en RAX
	;Itero con N y comparo con 0
	push rbp
	mov rbp, rsp
	xor rbx, rbx ; Inicializo rbx en 0
	xor rax, rax ; Inicializo rax en 0
itero:
	add ax, [rdi + rbx*2]
	inc bx	
	cmp bx, si				
	jl itero 

	pop rbp
	ret