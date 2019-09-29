option casemap:none                ; case sensitive

.data                               ;start of a data section
public g                            ;export variable g
g	QWORD	4						;declare global variable g initialised to 4


.code

;
; t2.asm
;

;
; example mixing C/C++ and x64 assembly language
;
; use stack for local variables
;
; simple mechanical code generation which doesn't make good use of the registers
;
; 06/10/14  used ecx instead of ebx to initialise fi and fj as ecx volatile

public      gcd						; make sure function name is exported

gcd:		xor		rax, rax		; set rax = 0
			cmp		rax, rdx		;
			je		gcd0			; if(b == 0)
			mov		rax, rcx		; setup a for mod operation
			mov		[rsp+8], rdx	; save b as it will be corrupted by mod operation
			cdq						; sign extend the upper portion of rdx:rax for division
			idiv	QWORD PTR rdx	; rdx = a%b	
			mov		rcx, [rsp+8]	; move b into param 1 slot from shadow space
			sub		rsp, 32			; allocate 32 bytes of shadow space
			call	gcd
			add		rsp, 32			; remove shadow space
			jmp		gcd1			; return gcd(b, a%b)
gcd0:		mov		rax, rdx		; return a
gcd1:       ret     0               ; return
    
;
; example mixing C/C++ and IA32 assembly language
;
; makes better use of registers and instruction set
;

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
			mov		r9, rdx			; mov j into param slot 3
			mov		rdx, rcx		; mov i into param slot 2
			mov		g, rcx			; mov g into param slot 1
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
      
    
end