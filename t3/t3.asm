//Computer architecture II - tutorial 3

Q1 ------------------------------------------------------------------------------------------------------------------

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


// i = r26, j = r27, k = r28, l = r29           ; int p(int i, int j, int k, int l)
p:      add r9, r0, r10                         ; put g into param slot 1
        add r26, r0, r11                        ; put i into param slot 2
        add r27, r0, r12                        ; put j inot param slot 3
        callr pc, #-14                          ; call relative?
        add pc, r0, r25                         ; save return address in r25
        add r1, r0, r10                         ; put min(j, i, j) into param slot 1
        add r28, r0, r11                        ; put k in param slot 2
        add r29, r0, r12                        ; put l in param slot 3
        callr pc, #-18                          ; call relative?
        add pc, r0, r25                         ; save return address in r25
        ret r25, 0                               ; return 
        xor r0, r0, r0                          ; Nop


// a = r26, b = r27 
gcd:    sub r26, 0, r0 {C}                      ; x == 0
        jne gcd0                                ;
        xor r0, r0, r0                          ; Nop
        add r27, #1, r1                         ; y+1
        ret r25, 0                              ; return y+1                              ;
gcd0:   add r26, r0, r10                        ; put a in param slot 1
        add r27, r0, r11                        ; put b in param slot 2
        call mod                                ;
        add pc, r0, r25                         ; save return address in r25
        add r27, r0, r10                        ; put b in param slot 1
        add r1, r0, r11                         ; put a % b in param slot 2
        call gcd                                ;
        add pc, r0, r25                         ; save return address in r25
        ret r25, 0                              ; return gcd(b, a % b)
        xor r0, r0, r0                          ; Nop

Q2 ----------------------------------------------------------------------------------------------------
//The solution to question 2 can be found in ackermann.c

Q3 ----------------------------------------------------------------------------------------------------
It takes 0.001160s to execute ackermann(3,6) on my machine

I calculated the time taken for execution by using the clock() function. When called, the clock function will
return a number of clock ticks that have been executed so far. So by calling the clock function before I execute
ackermann and after it returns, then subtracting the values, I can determine the number of clock cycles required
to execute the function. Then dividing that value by the number of clock cycles per second, the number of seconds
it took for the function to execute can be determined. 

The calculated value is a double, meaning we can get several decimal places of precision.

I then ran the function several times to obtain an average time. I created an automated test to do this programatically.
For my result I ran the function 100,000 times.