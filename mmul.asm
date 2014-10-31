;Sum of a column in a 2-dimensional array      TEST_SUM.ASM
;
;        Objective: To demonstrate array index manipulation
;                   in a two-dimensional array of integers.
;            Input: None.
;           Output: Displays the sum.
%include "io.mac"

.DATA
NROWMAT1       EQU  2
NCOLMAT1       EQU  2
NROWMAT1_BYTES   EQU  NCOLMAT1 * 2  ; number of bytes per row of matrix 1
MAT_1          dw   90,89
               dw   79,66
               
NROWMAT2	     EQU 2
NCOLMAT2       EQU 2
NROWMAT2_BYTES   EQU  NCOLMAT2 * 2  ; number of bytes per row of matrix 2

MAT_2          dw   60,55
               dw   51,59
			   
NROWMAT3	     EQU 2
NCOLMAT3       EQU 2
NROWMAT3_BYTES   EQU  NCOLMAT2 * 2  ; number of bytes per row of matrix 2

MAT_3          dw   0,0
               dw   0,0
space           db  "  ", 0

sum_msg        db   "The sum of the two matrices is: ",0


.UDATA
    i   resw 1 
    j   resw 1
    k   resw 1
    l   resw 1
    adder resw 1


.CODE
    .STARTUP
    
    sub AX, AX
    sub ESI, ESI
    sub CX, CX


    out_loop:
        cmp ESI, NROWMAT1
        je end_out_loop
        sub AX, AX
        mov [i], AX



            sub AX, AX
            mov [j], AX

            in_loop:
                mov AX, [j] 
                cmp AX,NCOLMAT1
                je end_in_loop

                   sub AX, AX
                   mov [k], AX

                   sub AX, AX
                   mov [l], AX
                    mul_loop:
                       
                        mov AX, [k]
                      

                        cmp AX, NCOLMAT1
                        je end_mul_loop



                         mov EDX, 0    
                        mov CX, [i]
                        mov DX, [k]
                        
                       
                        mov AX, [MAT_1 + ECX + EDX*2]

                        

                        mov CX, [j]
                        mov DX, [l]
                        mov BX, [MAT_2 + EDX + ECX*2]


                        mov DX, 0
                        mul BX

                        mov BX, [i]
                        mov CX, [j]
                        mov [adder], AX


                        
                        mov DX, [adder]
                        add [MAT_3 + EBX + ECX*2], DX
                         

                        mov  DX, [MAT_3 + EBX + ECX*2]


                        mov AX, [l]
                        add AX, NROWMAT1_BYTES
                        mov [l], AX


                        mov AX, [k]
                       
                        inc AX
                        mov [k], AX


                        jmp mul_loop
                   end_mul_loop:

                    mov  DX,[MAT_3 + EBX + ECX*2]
                    PutInt DX
                    PutStr space


                mov AX,[j]
                inc AX
                mov [j], AX
                jmp in_loop
             end_in_loop:

             nwln
        mov AX, [i]
        add AX, NROWMAT1_BYTES
        mov [i], AX
        inc ESI
        jmp out_loop
    end_out_loop:
 
  .EXIT