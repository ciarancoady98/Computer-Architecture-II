//Computer architecture II - tutorial 3

add r0, #4, r9                                  ; int g = 4 <---global variable

// a = r26, b = r27, c = r28                    ; int min(int a, int b, int c)
min:    add r26, r0, r1                         ; int v = a (store local var v in r1 to save on moving it there later)
        sub r27, r1, r0 {C}                     ; b < v
        jge min0                                ;
        xor r0, r0, r0                          ; Nop
        add r27, r0, r1                         ; int v = b
min0:   sub r28, r1, r0 {C}                     ; c < v
        jge min1                                ;
        xor r0, r0, r0                          ; Nop
        add r28, r0, r1                         ; v = c 
min1:   ret r25, 0                              ; return
        xor r0, r0, r0                          ; Nop