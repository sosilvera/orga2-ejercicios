;*** List ***
; Hay que añadir ordenado
; void listAdd(list_t* l, void* data)
section .text
global listAdd
extern malloc

; Calculo offset del header (puntero inicial)
%define loffset_type 0
%define loffset_size 4
%define loffset_first 8
%define loffset_last 16

; Calculo offset de los nodos
%define loffset_date 0
%define loffset_next 8
%define loffset_prev 16

listAdd:
	push rbp
	mov rbp, rsi
	push rbx
	push r12
	; rdi = *l, rsi = data
	mov rbx, rdi 					;	rbx = *l
	mov r12, rsi 					;	r12 = data

	; Reservo memoria para el nuevo nodo
	; Le asigno los valores
	mov rdi, 24	 ;	reservo 24 bytes para el nodo
	call malloc
	mov [rax], r12	; guardo la data en el nodo

	; Comparo la data con el ultimo nodo
	mov rdi, [rbx + loffset_last] 	; Muevo a rdi el ptr del nodo final
	mov r13, [rdi]					; Muevo a R13 el valor de data del prt final
	cmp r13, r12
	ja .nodoAnterior				; Si R13 > R12 => data_f < data_nuevo

	; Si es mayor, el nuevo nodo pasa a ser el ultimo
	mov [rdi + loffset_next], rax
	mov [rax + loffset_prev], rdi
	mov byte [rax + loffset_next], 0
	jmp .modifHead

.nodoAnterior:
	mov rdi, [rdi + loffset_prev]
	mov r13, [rdi]
	cmp r13, r12
	ja .nodoAnterior

	; Si paso de aca, es porque encontro el lugar
	
	;mov [rax + loffset_next], [rdi + loffset_next] 	; Muevo al nuevo nodo el siguiente del anterior
	mov r13, [rdi + loffset_next] 	; Muevo al nuevo nodo el siguiente del anterior
	mov [rax + loffset_next], r13
	
	mov rdi, [rax + loffset_next]	; rdi pasa a ser el siguiente

	;mov [rax + loffset_prev], [rdi + loffset_prev]	; Muevo al nuevo nodo el anterior del siguiente
	mov r13, [rdi + loffset_prev]
	mov [rax + loffset_prev], r13
	
	mov [rdi + loffset_prev], rax	; Muevo al *ptr_prev el puntero de rax
	mov rdi, [rax + loffset_prev]	; Muevo a rdi el puntero del anterior al nuevo
	mov [rdi + loffset_next], rax	; Muevo a siguiente del anterior el puntero al nuevo

.modifHead:
	inc byte [rbx + loffset_size]
	mov r12, [rbx + loffset_last]
	mov r13, [r12 + loffset_next]
	cmp r13, 0
	jne .nuevoEsUltimo	; Si prt_last_next != 0 => el nuevo puntero es el Ultimo
	; Si es igual a cero, entonces el primero puede ser el nuevo
	; Todo esta armado para que modifique los punteros de los nodos modificados
	mov r12, [rbx + loffset_next]	; Obtengo el primero
	mov r13, [r12 + loffset_prev]	; Obtengo el previo del primero
	cmp r13, 0
	jne .nuevoEsPrimero

.nuevoEsUltimo:
	mov [rbx + loffset_last], r13

.nuevoEsPrimero:
	mov [rbx + loffset_next], r13

	pop r12
	pop rbx
	pop rbp
ret
