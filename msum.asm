;Sum of a column in a 2-dimensional array      MSUM.ASM
;
;        Objective: To demonstrate array index manipulation
;                   in a two-dimensional array of integers.
;            Input: None.
;           Output: Displays the sum.
%include "io.mac"

.DATA 
    MAX_SIZE        EQU     10
    space           db   "  ", 0
    sum_msg         db   "The sum of the two matrices is: ",0
    prompt_size     db   "Enter the size of the matrices: ",0
    prompt_mat1     db   "Enter the elements of the first matrix in row order: ",0
    prompt_mat2     db   "Enter the elements of the second matrix in row order: ",0

    
.UDATA
    SIZE            resd  1
    ROWS            EQU  MAX_SIZE
    COLMS           EQU  MAX_SIZE
    ROWS_BYTES      EQU  COLMS * 2  ; number of bytes per row of matrix 1
    MAT_1           resw  MAX_SIZE*MAX_SIZE
    MAT_2           resw  MAX_SIZE*MAX_SIZE      
    MAT_3           resw  MAX_SIZE*MAX_SIZE
    i               resw  1
    j               resw  1

.CODE
    .STARTUP
        PutStr prompt_size
        GetLInt EAX
        mov [SIZE], EAX


;       MATRIX ONE INPUT
        PutStr prompt_mat1
        nwln
        sub AX, AX
        sub ESI, ESI
        sub ECX, ECX
        mat1_out_loop:
            mov EBX, [SIZE]
            cmp ESI, EBX
            je end_mat1_out_loop
            sub EDX, EDX

            mat1_in_loop:
                mov EBX, [SIZE]
               ; PutLInt EBX
                cmp EDX, EBX
                je end_mat1_in_loop

                GetInt AX
                mov  [MAT_1+ECX+EDX*2], AX
                inc EDX
                jmp mat1_in_loop
            end_mat1_in_loop:

            mov EBX, [SIZE]
            add EBX, EBX
            add ECX, EBX
            inc ESI
            jmp mat1_out_loop
        end_mat1_out_loop:


;       MATRIX TWO INPUT
        PutStr prompt_mat2
        nwln
         
        sub AX, AX
        sub ESI, ESI
        sub ECX, ECX
        mat2_out_loop:
            mov EBX, [SIZE]
            cmp ESI, EBX
            je end_mat2_out_loop
            sub EDX, EDX

            mat2_in_loop:
                mov EBX, [SIZE]
               ; PutLInt EBX
                cmp EDX, EBX
                je end_mat2_in_loop

                GetInt AX

                mov  [MAT_2+ECX+EDX*2], AX
                inc EDX
                
                jmp mat2_in_loop
            end_mat2_in_loop:
            mov EBX, [SIZE]
            add EBX, EBX
            add ECX, EBX
            inc ESI
            jmp mat2_out_loop
        end_mat2_out_loop:



;       ADD ANSWER  
        PutStr  sum_msg
        nwln 
        sub AX, AX
        sub ESI, ESI
        sub ECX, ECX
        out_loop:
            mov EBX, [SIZE]

            cmp ESI, EBX
            je end_out_loop
            sub EDX, EDX

            in_loop:
                mov EBX, [SIZE]

                cmp EDX, EBX
                je end_in_loop

                mov     AX,[MAT_1+ECX+EDX*2]
                add     AX,[MAT_2+ECX+EDX*2]
                mov     [MAT_3+ECX+EDX*2],AX
                PutInt AX 
                PutStr space
                

                inc EDX
                jmp in_loop
            end_in_loop:
            nwln
            mov EBX, [SIZE]
            add EBX, EBX
            add ECX, EBX
            inc ESI
            jmp out_loop
        end_out_loop:
    .EXIT

