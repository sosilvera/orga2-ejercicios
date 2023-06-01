
section .data
fprintf_s: db "%s", 0
fprintf_null: db "NULL",0
fin_string: db "\0"

section .text

global floatCmp
global floatClone
global floatDelete
global floatPrint

global strClone
global strLen
global strCmp
global strDelete
global strPrint

global docClone
global docDelete

global listAdd

global treeInsert
global treePrint

extern malloc
extern free
extern fprintf

;*** Float ***

floatCmp:
; rdi = a, rsi = b
	push rbp
	mov rbp, rsp

	mov rax, [rdi]
	mov rbx, [rsi]
	
	cmp rax, rbx
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
ret
floatDelete:
ret
floatPrint:
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

;*** Document ***

docClone:
ret
docDelete:
ret

;*** List ***

listAdd:
ret

;*** Tree ***

treeInsert:
ret
treePrint:
ret

