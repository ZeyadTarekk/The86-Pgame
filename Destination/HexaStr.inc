  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Written by : - Ziad Sherif  13-12-2021                                              ;;
; parameters : - string                                                               ;;
; return     : - string which is converted to hexadecimal                             ;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Hexaaa MACRO string
                LOCAL mainLoop                                                         ;;
                LOCAL done                                                             ;;
                LOCAL from_zero_nine                                                   ;;   
                LOCAL skip                                                              ;;          
                mov si,string
                ;lea   si,string
                ;lea   di,hexaWord    ;converted string to hexadecimal
    mainLoop:
                mov ah,24h              ;to avoid dbox khara error :3
                cmp   [si],ah       ;check if char is $
                jz    done           ;if ture ==>end
                mov   dl,[si]        ;assci of current char
                mov ah,40h          
                cmp dl,40h          ;compare if digit from 0-9
                jbe   from_zero_nine    ;jump to get hexadecimal of digit
                sub dl,61h  ;  get hexa of  digit (A==>F)
                add dl,10 
                jmp   skip  ; jump to skip (0-->9)
    from_zero_nine:
                sub dl,30h
    skip:
                mov [si],dl ; assignment value of dl to string
                inc si   ; points to the next digit
                jmp   mainLoop  ;iterate till  $
    done:
    mov si,string       ;;conctenate the final answer ==> 01 02 00 0f as exmaple ==>should be 120f
    mov bx,10h
    mov ax,[si]
    mul bx
    add al,[si+1]
    mul bx
    add al,[si+2]
    mul bx
    add al,[si+3]
    mov [si],ax
ENDM    
                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;