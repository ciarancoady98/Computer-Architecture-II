option casemap:none                ; case sensitive
includelib legacy_stdio_definitions.lib
extrn printf:near

.data                               ;start of a data section
public g                            ;export variable g
g	QWORD	4						;declare global variable g initialised to 4


.code

;
; t2.asm
;

public      gcd						; make sure function name is exported

gcd:		push    rbp             ; push frame pointer
			mov		rbp, rsp		; update frame pointer
			xor		rax, rax		; set rax = 0
			cmp		rax, rdx		;
			je		gcd0			; if(b == 0)
			mov		rax, rcx		; setup a for mod operation
			mov		[rbp-16], rdx	; save b as it will be corrupted by mod operation
			xor		rdx, rdx		; clear out top end of rdx:rax
			cqo						; sign extend the upper portion of rdx:rax for division
			idiv	QWORD PTR [rbp-16]	; rdx = a%b	
			mov		rcx, [rbp-16]	; move b into param 1 slot from shadow space
			sub		rsp, 32			; allocate 32 bytes of shadow space
			call	gcd
			add		rsp, 32			; remove shadow space
			jmp		gcd1			; return gcd(b, a%b)
gcd0:		mov		rax, rcx		; return a
gcd1:		mov		rsp, rbp		; restore stack pointer
			pop		rbp				; restore frame pointer
			ret     0               ; return

public      min						; make sure function name is exported

min:        mov     rax, rcx	    ; mov a into eax
            cmp     rax, rdx	    ; if (b < v)
            jl      min1            ; v = b
            mov     rax, rdx		; 
min1:		cmp     rax, r8		    ; if (c < v)
            jl      min2            ; v = c
            mov     rax, r8		    ; 
min2:		ret     0               ; return
    


public      p						; make sure function name is exported

p:          push    rbp             ; push frame pointer
			mov		rbp, rsp		; update frame pointer
			mov		[rbp+16], r8	; add k to the shadow space as it will get corrupted otherwise
			mov		r8, rdx			; mov j into param slot 3
			mov		rdx, rcx		; mov i into param slot 2
			mov		rcx, g			; mov g into param slot 1
			sub		rsp, 32			; allocate 32 bytes shadow space
			call	min	
			add		rsp, 32			; deallocate 32 bytes shadow space
			mov		r8, r9			; mov l into param slot 3
			mov		rdx, [rbp+16]	; mov k into param slot 2
			mov		rcx, rax		; mov min(g, i, j) into param slot 1
			sub		rsp, 32			; allocate 32 bytes shadow space
			call	min	
			add		rsp, 32			; deallocate 32 bytes shadow space
			mov     rsp, rbp        ; restore rsp
            pop     rbp             ; restore rbp
            ret     0               ; return

public		q						; make sure function name is exported

fxp2 db 'a = %I64d b = %I64d c = %I64d d = %I64d e = %I64d sum = %I64d', 0AH, 00H ; ASCII format string

q:			push	rbp				; push frame pointer
			mov		rbp, rsp		; update frame pointer
			sub		rsp, 56			; allocate 48 bytes for printf
			xor		rax, rax		; set rax to 0
			add		rax, rcx		; 0 + a
			add		rax, rdx		; a + b
			add		rax, r8			; a + b + c
			add		rax, r9			; a + b + c + d
			add		rax, [rbp+48]	; a + b + c + d + e
			mov		[rbp+16], rax	; save sum in shadow space
			mov		[rsp+48], rax	; push sum as param for printf
			mov		rax, [rbp+48]	; mov e into a reg
			mov		[rsp+40], rax	; push e as a param for printf
			mov		[rsp+32], r9	; push d as a param for printf
			mov		r9, r8			; put c in param slot 4
			mov		r8, rdx			; put b in param slot 3
			mov		rdx, rcx		; put a in param slot 2
			lea		rcx, fxp2		; put format string in param slot 1
			call	printf	
			add		rsp, 48			; deallocate 32 bytes shadow space
			mov		rax, [rbp+16]	; return sum
			mov     rsp, rbp        ; restore rsp
            pop     rbp             ; restore rbp
            ret     0               ; return

public		qns						; make sure function name is exported

fxp1 db 'qns', 0AH, 00H ; ASCII format string

;	By not allocating shadow space we end up with a corrupted stack. This is due
;	to printf expecting shadow space and thus uses it as if it were there, this
;	results in the stack being corrupted when printf returns and the program crashes
qns:		lea		rcx, fxp2		; put format string in param slot 1
			call	printf
			ret		0	
      
    
end