.686                                ; create 32 bit code
.model flat, C                      ; 32 bit memory model
 option casemap:none                ; case sensitive

.data                               ;start of a data section
public g                            ;export variable g
g   DWORD 4                         ;declare global variable g initialised to 4


.code

;
; t1.asm
;

;
; example mixing C/C++ and IA32 assembly language
;
; use stack for local variables
;
; simple mechanical code generation which doesn't make good use of the registers
;
; 06/10/14  used ecx instead of ebx to initialise fi and fj as ecx volatile

public      gcd               ; make sure function name is exported

gcd:        push    ebp             ; push frame pointer
            mov     ebp, esp        ; update ebp
            sub     esp, 8          ; space for local variables fi [ebp-4] and fj [ebp-8]
            mov     eax, [ebp+8]    ; eax = n
            cmp     eax, 1          ; if (n <= 1) ...
            jle     gcd2			; return n
            xor     ecx, ecx        ; ecx = 0   NB: mov [ebp-4], 0 NOT allowed
            mov     [ebp-4], ecx    ; fi = 0
            inc     ecx             ; ecx = 1   NB: mov [ebp-8], 1 NOT allowed
            mov     [ebp-8], ecx    ; fj = 1
gcd0:		mov     eax, 1          ; eax = 1
            cmp     [ebp+8], eax    ; while (n > 1)
            jle     gcd1			;
            mov     eax, [ebp-4]    ; eax = fi
            mov     ecx, [ebp-8]    ; ecx = fj
            add     eax, ecx        ; ebx = fi + fj
            mov     [ebp-4], ecx    ; fi = fj
            mov     [ebp-8], eax    ; fj = eax
            dec     DWORD PTR[ebp+8]; n--
            jmp     gcd0			;
gcd1:		mov     eax, [ebp-8]    ; eax = fj
gcd2:		mov     esp, ebp        ; restore esp
            pop     ebp             ; restore ebp
            ret     0               ; return
    
;
; example mixing C/C++ and IA32 assembly language
;
; makes better use of registers and instruction set
;

public      min              ; make sure function name is exported

min:        push    ebp             ; push frame pointer
            mov     ebp, esp        ; update ebp
            sub     esp, 4          ; allocate space for local variable v
            mov     eax, [ebp+8]    ; mov a into eax
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
    


public      p              ; make sure function name is exported

p:          push    ebp             ; push frame pointer
            mov     ebp, esp        ; update ebp
            mov     eax, [ebp+8]    ; mov n into eax
            cmp     eax, 1          ; if (n <= 1)
            jle     p2				; return n
            xor     ecx, ecx        ; fi = 0
            mov     edx, 1          ; fj = 1
p0:			cmp     eax, 1          ; while (n > 1)
            jle     p1				;
            add     ecx, edx        ; fi = fi + fj
            xchg    ecx, edx        ; swap fi and fj
            dec     eax             ; n--
            jmp     p0				;
p1:			mov     eax, edx        ; eax = fj
p2:			mov     esp, ebp        ; restore esp
            pop     ebp             ; restore ebp
            ret     0               ; return
    
end