  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Written by : - Ziad Sherif  13-12-2021                                              ;;
; parameters : - string                                                               ;;
; return     : - string which is converted to hexadecimal                             ;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Hexaaa MACRO string
                LOCAL mainLoop                                                         ;;
                LOCAL exitHexa                                                             ;;
                LOCAL from_zero_nine                                                   ;;
                LOCAL skip                                                              ;;
                LOCAL LOOPMain                                                              ;;
                LOCAL Outloop                                                              ;;
                mov si,string
                ;lea   si,string
                ;lea   di,hexaWord    ;converted string to hexadecimal
    mainLoop:
                mov ah,24h              ;to avoid dbox khara error :3
                cmp   [si],ah       ;check if char is $
                jz    exitHexa           ;if ture ==>end
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
    exitHexa:
    mov si,string       ;;conctenate the final answer ==> 01 02 00 0f $as exmaple ==>should be 120f
    mov bx,10h             ;; ax 00 01 => 00 10 => 00  12 => 01 20=> 12 0f
    mov al,[si]
    mov ah,0
    mov cl,'$'

    cmp al,cl
    jz Outloop
    inc si
    LOOPMain:
        mov dl,[si]
        cmp dl,cl
        jz Outloop
            mul bx
            add al,[si]
            inc si
    jmp LOOPMain
    Outloop:
    mov si,string
    mov [si],ax
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;