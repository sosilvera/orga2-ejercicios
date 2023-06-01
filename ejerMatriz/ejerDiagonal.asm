global diagonal
section .text
diagonal:
	; rdi = matriz, rsi = n, rdx = vector
	push rbp;
	mov rbp, rsp
	xor rbx, rbx ; Inicializo en cero el incide
	and rsi, rsi ; Completo los bits restantes
	;Logica
interar:
	; vector[i] = matriz[i*n + i];
	mov r9, [rdi]
	mov [rdx], r9

	lea rdi, [rdi + rsi*2 + 2]

	add rdx, 2	; incremento la posicion de memoria
	inc rbx 	; rbx es indice
	cmp rbx, rsi
	je interar

	pop rbp
	ret