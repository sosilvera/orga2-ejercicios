section .text
global floatCmp

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
