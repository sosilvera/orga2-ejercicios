section .data
fprintf_s: db "%s", 0
fprintf_null: db "NULL",0
fin_string: db "\0"
fprintf_f: db "%f", 10
float_lenght EQU $ - fprintf_f

section .text
global listAdd

global floatCmp		; Hecho
global floatClone	; Hecho
global floatDelete	; Hecho
global floatPrint	; Arreglar

global strClone		; Hecho
global strLen 		; Hecho
global strCmp 		; Hecho
global strDelete 	; Hecho
global strPrint 	; Hecho

extern malloc
extern free
extern fprintf
extern intCmp

; Calculo offset del header (puntero inicial)
%define loffset_type 0
%define loffset_size 4
%define loffset_first 8
%define loffset_last 16

; Calculo offset de los nodos
%define loffset_data 0
%define loffset_next 8
%define loffset_prev 16

;*** Float ***

floatCmp:
; rdi = a, rsi = b
	push rbp
	mov rbp, rsp

	movss xmm0, [rdi]
	movss xmm1, [rsi]
	
	comiss xmm0, xmm1
	jb .returnUno 		; rax < rbx
	ja .returnMenosUno 	; rax > rbx
	mov rax, 0
	jmp .end

.returnUno:
	mov rax, 1
	jmp .end

.returnMenosUno:
	mov rax, -1

.end:
	pop rbp
	ret

floatClone:
	push rbp
	mov rbp, rsp
	push rbx

	mov rbx, [rdi] 	; rdi = *a 
	mov rdi, 4		
	call malloc		; reservo 4 bytes en memoria
	mov [rax], rbx	; asigno a la posicion de memoria
					; almacenada en eax el valor de a
	pop rbx
	pop rbp
ret

floatDelete:
	push rbp
	mov rbp, rsp

	; rdi = *a
	call free

	pop rbp
ret

floatPrint:
	push rbp
	mov rbp, rsp
	; void floatPrint(float* a, FILE *pFile)

	movq xmm0, [rdi] 	; Muevo el float a xmm0
	mov rdi, rsi 	; Paso el destino al primer arg.
	mov rsi, fprintf_f ; Paso el %f 
	call fprintf

	pop rbp
ret

;*** String ***

strClone:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push rbx

%define a r12
%define clone r13
%define i rbx
%define len r14d

	xor r14,r14
	xor rax,rax

	mov a,rdi
	call strLen

	mov len,eax
	xor i,i
	add eax,1
	lea eax,[eax*8]

	xor rdi,rdi
	mov edi,eax

	call malloc

	mov clone,rax

	xor rax,rax
.ciclo:
	cmp byte [a+i],0
	je .fin
	mov byte al,[a+i]
	mov [clone+i],al
	inc i
	jmp .ciclo
.fin:
	mov byte [clone+i],0
	mov rax,clone
	pop rbx
	pop r14
	pop r13
	pop r12
	pop rbp
  ret

strLen:
  ; rdi: char* a
  ; Como el resultado va a ser un uint32_t (32bits) => El resultado lo devuelvo el EAX

	push rbp		; Me guardo rbp
	mov rbp, rsp	; Muevo rsp a rbp

	xor eax, eax 	; Mi contador va a ser EAX. Lo pongo en 0

.loop:
	cmp byte [rdi], 0	; Los strings son cero
	je .end
	inc eax				; incremento el contador
	lea rdi, [rdi + 1]	; paso al siguiente elemento
	jmp .loop

.end:
	pop rbp		; Vuelvo el rbp a como estaba
  ret

strCmp:
	push rbp
	mov rbp, rsp
	sub rsp,8
	push r12
	push r13
	push r14
	push r15
	push rbx

	;rdi char a
	;rsi char b

	mov r12, rdi
	mov r13, rsi

	call strLen
	mov r14, rax

	mov rdi, r13
	call strLen
	mov r15, rax
	xor rbx,rbx
	xor rax,rax

	;r12 = a
	;r13 = b
	;r14 = strLen(a)
	;r15 = strLen(b)

	xor rcx, rcx

	; mov rdi, r12
	; mov rsi, r13

.ciclo:
	cmp ecx, r14d
	je .fin_ciclo
	cmp ecx, r15d
	je .fin_ciclo

	mov byte al, [r12+rcx]
	mov byte bl, [r13+rcx]

	cmp al, bl
	jl .return_uno
	jg .return_menos_uno


	inc ecx
	jmp .ciclo

.fin_ciclo:
	cmp ecx, r14d
	jne .return_menos_uno
	cmp ecx, r15d
	je .return_cero
	jmp .return_uno


.return_uno:
	xor rax,rax
	mov dword eax, 1
	jmp .end

.return_menos_uno:
	xor rax,rax
	mov dword eax,-1
	jmp .end

.return_cero:
	xor rax,rax
	mov dword eax, 0
	jmp .end

.end:
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	add rsp,8
	pop rbp
  ret

strDelete:
  ; rdi: char* a
	push rbp		;Armo el stack frame
	mov rbp, rsp

	call free		; *a ya esta en rdi

	pop rbp			; Vuelvo el stack frame
  ret

strPrint:
  ; rdi char *a
  ; rsi FILE *pfile
	push rbp
	mov rbp, rsp
	push r12
	push r13

	mov r12, rdi	; Me guardo el char
	mov r13, rsi	; Me guardo destino

	call strLen		; llamo a strLen para que me de el largo del string
	cmp rax, 0x00
	je .null		;si es NULL tengo que imprimir NULL

.not_null:
	mov rdi, r13	; para llamar a fprintf tengo que primero pasarle el destino
	mov rsi, fprintf_s	;despues el %s
	mov rdx, r12	;por ultimo lo que quiero imprimir
	jmp .end

.null:
	mov rdi, r13	; para llamar a fprintf tengo que primero pasarle el destino
	mov rsi, fprintf_s	;despues el %s
	mov rdx, fprintf_null	;por ultimo lo que quiero imprimir

.end:
	call fprintf

	pop r13
	pop r12
	pop rbp
ret
;*** List ***
; Hay que añadir ordenado
; void listAdd(list_t* l, void* data)

listAdd:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r14
	push r15
	push r10
	; rdi = *l, rsi = data
	mov rbx, rdi 					;	rbx = *l
	mov r12, rsi 					;	r12 = data

	; Reservo memoria para el nuevo nodo
	; Le asigno los valores
	mov rdi, 24	 					; reservo 24 bytes para el nodo
	call malloc
	mov [rax], r12					; guardo la data en el nodo
	mov r10, rax					; muevo a r10 el punto *l
	mov r14, [rbx + loffset_last] 	; muevo el puntero del ultimo nodo a r14
	cmp r14, 0
	je .esPrimeroSinLista

	; Muevo a los parametros rdi y rsi los ptr a valores a comparar
	mov rdi, [r14 + loffset_data]
	mov rsi, [r10 + loffset_data]	; Puntero nuevo

	jmp .comparar

.continuar:
	cmp rax, 1						; if(rax == 1){.verUltimo}
	je .verUltimo					
	cmp byte [r14 + loffset_prev], 0		; else{if(r14->prev != 0){.anterior}
	jne .anterior
	mov [r10 + loffset_next], r14
	mov byte [r10 + loffset_prev], 0
	mov [r14 + loffset_prev], r10
	mov [rbx + loffset_next], r10	; 	else{esPrimeroConLista}
	jmp .end

.verUltimo:							
	cmp byte [r14 + loffset_next], 0		; if(r14->next == 0){.esUltimo}
	je .esUltimo

	; INSERTAR (en medio)			; else{.insertar}}
	; r10 es el nuevo, r14 es el siguiente
	; Completo el nuevo a partir de los otros dos nodos
	mov r12, [r14 + loffset_next]
	mov [r10 + loffset_next], r12
	mov r12, [r12 + loffset_prev]
	mov [r10 + loffset_prev], r12
	; Actualizo el next y prev de los nodos cercanos
	mov [r12 + loffset_next], r10
	mov r12, [r10 + loffset_next]
	mov [r12 + loffset_prev], r10
	jmp .end

.esPrimeroSinLista:
	mov byte [r10 + loffset_next], 0
	mov byte [r10 + loffset_prev], 0
	; Actualizo head
	mov [rbx + loffset_first], r10
	mov [rbx + loffset_last], r10
	jmp .end

.esUltimo:
	mov [r10 + loffset_prev], r14
	mov byte [r10 + loffset_next], 0
	; Actualizo head
	mov [r14 + loffset_next], r10
	mov [rbx + loffset_last], r10
	jmp .end

.anterior:
	mov r14, [r14 + loffset_prev]
	mov rdi, [r14 + loffset_data]

.comparar:
	mov r15d, [ebx]	; Me fijo el tipo de dato
	; Para poder hacer los llamados a las funciones,
	; Necesito que los punteros esten en RDI y RSI
	cmp r15d, 1		; Veo si es integer
	je .compareInt
	cmp r15d, 2		; Veo si es Float
	je .compareFloat
	cmp r15d, 3		; Veo si es string
	je .compareString
;	cmp r15, 4		; Veo si es Document
;	je .compareDocument


.compareInt:
	call intCmp
	jmp .continuar
.compareFloat:
	call floatCmp
	jmp .continuar
.compareString:
	call strCmp
	jmp .continuar
;.compareDocument:
;	call docCmp
;	jmp .continuar

.end:
	inc byte [rbx + loffset_size]
	pop r10
	pop r15
	pop r14
	pop r12
	pop rbx
	pop rbp
ret
