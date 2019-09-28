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

gcd:		xor		eax, eax		; set eax = 0
			cmp		eax, [ebp+12]	;
			je		gcd0			; if(b == 0)
			mov		eax, [ebp+8]	; setup a for mod operation
			cdq						; sign extend the upper portion of edx:eax for division
			idiv	QWORD PTR [ebp+12]		; edx = a%b	
			push	edx				; push param gcd(a%b);
			push	[ebp+12]		; push param b
			call	gcd
			add		esp, 8			; remove params
			jmp		gcd1			; return gcd(b, a%b)
gcd0:		mov		eax, [ebp+8]	; return a
gcd1:       mov     esp, ebp        ; restore esp
            pop     ebp             ; restore ebp
            ret     0               ; return
    
;
; example mixing C/C++ and IA32 assembly language
;
; makes better use of registers and instruction set
;

public      min						; make sure function name is exported

min:        mov     eax, [ep+8]    ; mov a into eax
            cmp     eax, [ebp+12]   ; if (b < v)
            jl      min1             ; v = b
            mov     eax, [ebp+12]   ; fi = 0
min1:		cmp     eax, [ebp+16]   ; if (c < v)
            jl      min2             ; v = c
            mov     eax, [ebp+16]   ; fi = 0
min2:		add     esp, 4          ; deallocate space for local variable
            mov     esp, ebp        ; restore esp
            pop     ebp             ; restore ebp
            ret     0               ; return
    


public      p						; make sure function name is exported

p:          push    ebp             ; push frame pointer
            mov     ebp, esp        ; update ebp
			push	[ebp+12]		; push j to stack
			push	[ebp+8]			; push i to stack
			push	g				; push g to stack
			call	min	
			add		esp, 12			; remove params from stack
			push	[ebp+20]		; push l to the stack
			push	[ebp+16]		; push k to the stack
			push	eax				; push eax to the stack
			call	min
			add		esp,12			; remove params for stack
			mov     esp, ebp        ; restore esp
            pop     ebp             ; restore ebp
            ret     0               ; return
      
    
end