;Manipulation of Students' marks records                    RECORDS.ASM
;
;        Objective: To maintain and manipulate students marks records
;            Input: None.
;           Output: Displays the percentage, max and min marks, sorted list, search result
%include "io.mac"


.DATA 
  MAX_SIZE      EQU 10
  prompt_no_stud    db  "Enter the number of students", 0
  input_prompt    db  "Enter Student Data : RollNo, Sub1, Sub2, Sub3 ", 0
  input_format    db  "RollNo, Sub1, Sub2, Sub3, Total", 0
  total_output    db  "Total : ", 0
  per_output      db  "Percentage : ", 0
  max_output      db  "Maximum Marks : ", 0
  min_output      db  "Minimum Marks : ", 0
  sort_output     db  "Sorted Output according to total marks: ", 0
  space           db  "  ", 0
  query_number   db  "Enter the number to be searched: ",0
  out_msg        db  "The number is at position ",0
  not_found_msg  db  "Number not in the array!",0
  query_msg      db  "Do you want to quit (Y/N): ",0
  er_msg         db  "size should be greater than 1",0
  
.UDATA  
  roll_nos  resd MAX_SIZE
  size    resd 1
  subject1  resd MAX_SIZE
  subject2  resd MAX_SIZE
  subject3  resd MAX_SIZE
  total     resd MAX_SIZE
  percentage  resd MAX_SIZE
  min     resd 1
  max     resd 1
  test1    resd 1
  test2    resd 1
  test3    resd 1
  test4    resd 1

.CODE
  .STARTUP
  
 
  PutStr  prompt_no_stud ; request input array
  nwln
  GetInt BX
  cmp BX,1
  je error

  mov [size], BX
  sub ESI, ESI ; array index = 0
    


  array_input:
      cmp EBX, 0
      je exit_input
      
      mov EAX, 100
      mov [min], EAX
      mov EAX, 0
      mov [max], EAX


      PutStr  input_prompt ; request input array
      nwln
      sub ECX, ECX

      GetLInt EAX
      mov [roll_nos+ESI*4], EAX
      
      GetLInt EAX
      cmp EAX, [max]
      jle Donothing
        mov [max], EAX
      Donothing: 
      cmp EAX, [min]
      jge Donothing2
        mov [min], EAX
      Donothing2: 


      mov [subject1+ESI*4], EAX
      add ECX, EAX

      

      GetLInt EAX
      cmp EAX, [max]
      jle Donothing3
        mov [max], EAX
      Donothing3: 
      cmp EAX, [min]
      jge Donothing4
        mov [min], EAX
      Donothing4: 

      mov [subject2+ESI*4], EAX
      add ECX,EAX

      GetLInt EAX

      cmp EAX, [max]
      jle Donothing5
        mov [max], EAX
      Donothing5: 
      cmp EAX, [min]
      jge Donothing6
        mov [min], EAX
      Donothing6: 

      mov [subject3+ESI*4], EAX
      add ECX,EAX
      

      mov [total+ESI*4], ECX
      PutStr total_output 
      PutInt [total+ESI*4]
      nwln

      mov EAX,ECX       ;Storing total in AX for division
      sub EDX, EDX      ;DX = 0

      mov ECX, 3
      div ECX
      
      mov [percentage+ESI*4], EAX
      PutStr per_output
      PutInt [percentage+ESI*4]
      nwln
      PutStr max_output  
      PutInt [max]
      nwln
      PutStr min_output
      PutInt [min]
      nwln

      
      inc ESI
      dec EBX
      jmp array_input
    exit_input:


      mov EDX, [size]
      push    EDX          ; push array size & array pointer
      push    total
      call    insertion_sort

      nwln
      nwln
      sub ESI, ESI
      mov EDX, [size]
      PutStr sort_output
      nwln
display_loop:
       cmp EDX, 0
       je exit_display
        
       PutStr input_format
       nwln

       PutInt  [roll_nos + ESI*4]
       PutStr space
       PutInt  [subject1 + ESI*4]
       PutStr space
       PutInt  [subject2+ ESI*4]
       PutStr space
       PutInt  [subject3 + ESI*4]
       PutStr space
       PutInt  [total + ESI*4]

       nwln

       dec EDX
       inc ESI
       jmp    display_loop
exit_display:  
  
read_input:
        PutStr  query_number ; request number to be searched for
        GetLInt EAX
        ;       call    binary_search
        ; binary_search returns in AX the position of the number 
        ; in the array; if not found, it returns 0.
        mov ECX, [size]
        sub ESI, ESI
        search :
            cmp ECX, 0
            je not_found
            

            cmp EAX, [roll_nos+ ESI*4]
            je exit_search

            inc ESI
            dec ECX
            jmp search
        exit_search:
     ;   cmp     AX,0         ; number found?
      ;  je      not_found    ; if not, display number not found
        PutStr  out_msg      ; else, display number position
       mov EAX, ESI
        PutLInt  ESI
        nwln
       PutInt  [roll_nos + ESI*4]
       PutStr space
       PutInt  [subject1 + ESI*4]
       PutStr space
       PutInt  [subject2+ ESI*4]
       PutStr space
       PutInt  [subject3 + ESI*4]
       PutStr space
       PutInt  [total + ESI*4]
        jmp     user_query
not_found:
        PutStr  not_found_msg
user_query:
        nwln
        PutStr  query_msg    ; query user whether to terminate
        GetCh   AL           ; read response
        cmp     AL,'Y'       ; if response is not 'Y'
        jne     read_input   ; repeat the loop
done:                        ; otherwise, terminate program

      

  .EXIT

error:
	 PutStr er_msg
         nwln
        .EXIT 

  ;------------------------------------------------------------

;-----------------------------------------------------------
; This procedure receives a pointer to an array of integers
; and the array size via the stack. The array is sorted by
; using insertion sort. All registers are preserved.
;-----------------------------------------------------------
%define   SORT_ARRAY   EBX
insertion_sort: 
       pushad                ; save registers
       mov     EBP,ESP
       mov     EBX,[EBP+36]  ; copy array pointer
       mov     ECX,[EBP+40]  ; copy array size
       PutInt CX
       nwln
       mov     ESI,4        ; array left of ESI is sorted
for_loop:
       ; variables of the algorithm are mapped as follows.
       ; EDX = temp, ESI = i, and EDI = j
       mov     EDX,[SORT_ARRAY+ESI] ; temp = array[i]
       
       mov     EAX,[roll_nos+ESI]
       mov     [test1], EAX
       
       mov     EAX,[subject1+ESI]
       mov     [test2], EAX
       
       mov     EAX,[subject2+ESI]
       mov     [test3], EAX
       
       mov     EAX,[subject3+ESI]
       mov     [test4], EAX
       

       mov     EDI,ESI       ; j = i-1
       sub     EDI,4
while_loop:
       cmp     EDX,[SORT_ARRAY+EDI]  ; temp < array[j]
       jge     exit_while_loop
       ; array[j+1] = array[j]
       mov     EAX,[SORT_ARRAY+EDI]         ;Bubbling back
       mov     [SORT_ARRAY+EDI+4],EAX        ;Bubbling back

       mov      EAX,[roll_nos+EDI]
       mov      [roll_nos+EDI+4], EAX

       mov      EAX,[subject1+EDI]
       mov      [subject1+EDI+4], EAX

       mov      EAX,[subject2+EDI]
       mov      [subject2+EDI+4], EAX

       mov      EAX,[subject3+EDI]
       mov      [subject3+EDI+4], EAX



       sub     EDI,4         ; j = j-1
       cmp     EDI,0         ; j >= 0
       jge     while_loop
exit_while_loop:
       ; array[j+1] = temp
       mov     [SORT_ARRAY+EDI+4],EDX
       mov     EAX, [test1]
       mov     [roll_nos+EDI+4],EAX
       mov     EAX, [test2]
       mov     [subject1+EDI+4],EAX
       mov     EAX, [test3]
       mov     [subject2+EDI+4],EAX
       mov     EAX, [test4]
       mov     [subject3+EDI+4],EAX

       add     ESI,4         ; i = i+1
       dec     ECX
       cmp     ECX,1         ; if ECX = 1, we are done
       jne     for_loop
sort_done:
       popad                 ; restore registers
       ret     8   


