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
global floatPrint2	; Arreglar

global strClone		; Hecho
global strLen 		; Hecho
global strCmp 		; Hecho
global strDelete 	; Hecho
global strPrint 	; Hecho

global treeInsert
global treePrint
global printInOrder

extern malloc
extern free
extern fprintf
extern intCmp
extern listNew
extern intClone
extern intPrint
extern listPrint
extern floatPrint

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
	mov rax, 0			; devuelvo 0 si son iguales
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

floatPrint2:
	push rbp
	mov rbp, rsp
	; void floatPrint(float* a, FILE *pFile)

	movsd xmm0, [rdi] 	; Muevo el float a xmm0
	mov rdi, rsi 	; Paso el destino al primer arg.
	mov rsi, fprintf_f ; Paso el %f 
	mov rax, 1
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

%define tree_first	0
%define tree_size	8
%define tree_typeK	12
%define tree_dup	16
%define tree_typeD	20

%define tnode_key	0
%define tnode_value 8
%define tnode_left	16
%define tnode_right	24


treeInsert:
	; int treeInsert(tree_t* tree, void* key, void* data)(82 Inst.)
	push rbp
	mov rbp, rsp
	push rbx
	push r10
	push r12
	push r13
	push r14
	push r15

	; rdi: *tree , rsi: *key , rdx: *data

	mov rbx, rdi 	; rbx tiene *tree
	mov r15, rsi 	; r15 tiene *key
	mov r13, rdx 	; r12 tiene *data
	mov r14, [rbx + tree_typeK]
	jmp .clonarKey
.continuar:
	mov rdi, 32 	; Reservo espacio para un nodo
	call malloc
	mov r14, rax	; Almaceno en r14 el puntero al nuevo nodo
	mov [r14 + tnode_key], r15
	mov qword [rax + tnode_right], 0
	mov qword [rax + tnode_left], 0

	mov r12, [rbx + tree_first]	; Almaceno el nodo actual
	cmp r12, 0
	je .esPrimerHoja

	mov rdi, [r14 + tnode_key]	; Guardo el puntero a la key nueva
	mov rsi, [r12 + tnode_key]	; Guardo el puntero a la key actual 

.comparar:
	mov r15d, [ebx + tree_typeK]
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
	jmp .avanzar
.compareFloat:
	call floatCmp
	jmp .avanzar
.compareString:
	call strCmp
	jmp .avanzar
;.compareDocument:
;	call docCmp
;	jmp .avanzar

.clonarKey:
	; R15 tiene KEY y R13 tiene DATA
	cmp r14d, 1
	je .clonarKInt
	cmp r14d, 2
	je .clonarKFloat
	cmp r14d, 3
	je .clonarKString
	;cmp r14d, 4
	;je .clonarKDoc

.clonarData:
	mov r14, [rbx + tree_typeD]
	cmp r14d, 1
	je .clonarDInt
	cmp r14d, 2
	je .clonarDFloat
	cmp r14d, 3
	je .clonarDString
	;cmp r14d, 4
	;je .clonarDDoc

.clonarKInt:
	mov rdi, r15
	call intClone
	mov r15, rax
	jmp .clonarData

.clonarKFloat:
	mov rdi, r15
	call floatClone
	mov r15, rax
	jmp .clonarData

.clonarKString:
	mov rdi, r15
	call strClone
	mov r15, rax
	jmp .clonarData

;.clonarKDoc:
;	mov rdi, r15
;	call docClone
;	mov r15, rax
;	jmp .clonarData

.clonarDInt:
	mov rdi, r13
	call intClone
	mov r13, rax
	jmp .continuar

.clonarDFloat:
	mov rdi, r13
	call floatClone
	mov r13, rax
	jmp .continuar

.clonarDString:
	mov rdi, r13
	call strClone
	mov r13, rax
	jmp .continuar

;.clonarDDoc:
;	mov rdi, r13
;	call docClone
;	mov r13, rax
; 	jmp .continuar


.avanzar:	; Revisar logica del call CMP
	cmp eax, 1	; Ponele que Nuevo < Actual
	je .right
	cmp eax, -1	; Ponele que Nuevo > Actual
	je .left
	; Iguales
	cmp qword [rbx + tree_dup], 0
	jne .insertarDuplicado
	mov rdi, r10
	call free	 			; Si no acepta duplicado, entonces libero la memoria
	mov rax, 0
	jmp .end				; del nuevo nodo

.insertarDuplicado:
	mov rdi, [r12 + tnode_value]	; Muevo el puntero de la lista actual
	mov rsi, r13					; Muevo el puntero al dato del nodo nuevo
	call listAdd
	mov rax, 1
	jmp .end

.esPrimerHoja:
	mov [rbx + tree_first], r14
	inc byte [rbx + tree_size]
	mov rdi, [rbx + tree_typeD]
	call listNew
	mov [r14 + tnode_value], rax
	mov rdi, rax
	mov rsi, r13
	call listAdd
	mov rax, 1
	jmp .end

.right:
	mov r10, [r12 + tnode_right]
	cmp r10, 0
	jne .asignar				; Si el nodo Right no es nulo, hay que comparar
	; Inserto R
	mov [r12 + tnode_right], r14 	; Apunto el actual al nuevo
	jmp .asignarLista
	
.left:
	mov r10, [r12 + tnode_left]
	cmp r10, 0
	jne .asignar				; Si el nodo Left no es nulo, hay que comparar
	; Inserto L
	mov [r12 + tnode_left], r14 	; Apunto el actual al nuevo
	jmp .asignarLista

.asignar:
	mov r12, r10
	mov rsi, [r12 + tnode_key]
	jmp .comparar				; En este punto tengo rsi = [r12 + key] ; ptr_viejo
								; 					  rdi = [r14 + key] ; ptr_nuevo

.asignarLista:
	mov rdi, [rbx + tree_typeD]
	call listNew
	mov [r14 + tnode_value], rax	; Asigno la lista de valores al nodo actual? al nuevo
	mov rdi, rax
	mov rsi, r13
	call listAdd
	inc byte [rbx + tree_size]
	mov rax, 1

.end:
	pop r15
	pop r14
	pop r13
	pop r12
	pop r10
	pop rbx
	pop rbp
ret
; ************ TREE PRINT ************ ;
printInOrder:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r14
	push r15

	; rdi: nodo*, rsi: *pfile, rdx: t_key
	mov rbx, rdi 	; rbx es el nodo
	mov r12, rsi 	; r12 el file
	mov r15, rdx 	; r15 el tipo de dato de key

	cmp rbx, 0		; Pregunto si rbx es nulo
	je .end

	; Si no lo es, llamo a printInOrder(right)
	mov rdi, [rbx + tnode_right]
	mov rsi, r12
	mov rdx, r15

	call printInOrder 	; printInOrder(right)

	jmp .print

.inOrderLeft:
	; Una vez impreso, llamo al nodo derecho
	mov rdi, [rbx + tnode_left]	
	mov rsi, r12
	mov rdx, r15

	call printInOrder
	jmp .end

.print:
	; R15 tiene KEY y R13 tiene DATA
	mov rdi, [rbx + tnode_key]
	mov rsi, r12
	cmp r15d, 1
	je .imprimirKInt
	cmp r15d, 2
	je .imprimirKFloat
	cmp r15d, 3
	je .imprimirKString
	;cmp r14d, 4
	;je .imprimirKDoc

.imprimirKInt:
	call intPrint
	jmp .imprimirDatos
.imprimirKFloat:
	call floatPrint
	jmp .imprimirDatos
.imprimirKString:
	call strPrint
	jmp .imprimirDatos
;.imprimirKDoc:
;	call docPrint
;	jmp .imprimirDatos
				
.imprimirDatos:
	; R15 tiene KEY y R13 tiene DATA
	mov rdi, [rbx + tnode_value]	; Muevo el ptr de lista
	mov rsi, r12				; Muevo el ptr de pfile
	call listPrint
	jmp	.inOrderLeft

.end:
	pop r15
	pop r14
	pop r12
	pop rbx
	pop rbp
ret

treePrint:
	push rbp
	mov rbp, rsp

	; rdi: *tree, rsi: *pfile
	mov rdx, [rdi + tree_typeK]	; Paso como argumento el tipo de Key
	mov rdi, [rdi + tree_first]	; Paso como argumento el primer nodo
	; mov rsi, rsi 				; "Paso" el pfile

	call printInOrder

	pop rbp
ret