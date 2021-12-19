  
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
                lea si,string
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
    lea si,string       ;;conctenate the final answer ==> 01 02 00 0f $as exmaple ==>should be 120f
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
    lea si,string
    mov [si],ax
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include func.inc
.model huge
.data

myName LABEL BYTE
nameSize db 16
ActualSize db ?
playerName db 16 dup('$')
endl    db  10,13 ,'$'
str           db 10,13,10,13,10,13 
                                        
                    db '                            Please enter your Name: ','$'



intialPointSize    db 5                    
intialPointActualSize db ?                    
initalPointStr      db 6 dup ('$')
STRIP           db 10,13,10,13,10,13 
                                        
                    db '                            Please enter your Intial Point: ','$'                    

;invalid    db 'Please Enter Valid inputs [0-9],[A-Z]','$'
.code

;description
main PROC
    
    mov ax,@data
    mov ds,ax
    mainLoop:
    mov bx,0
    mov ah,2 
    mov dx,0 ;set cursor at x=0,y=0
    int 10h
    clearScreen
      mov ah,9
    lea dx,str   
    int 21h 
    
    getTheName playerName                
                     
    lea si,playerName
    ;mov ax,'9'
;    cmp [si],ax;check if between 0,9
;    jbe L09
      
    mov ax,'Z'
    cmp [si],ax ;check if between A,Z
    jbe LAZ
    
    mov ax,'z'
    cmp [si],ax     ;check if between a,z
    jbe Lza
    
  ;  
;    L09:
;    cmp [si],'0'
;    jae exit
;    jmp mainLoop
    
    LAZ:
    mov ax,'A'
    cmp [si],'A'
    jae exit
    jmp mainLoop
    
    
    
    Lza:
    mov ax,'a'
    cmp [si],ax
    jae exit
    jmp mainLoop
    
    exit:
    ; mov ah,9
    ; lea dx,endl
    ; int 21h
     mov ah,9
    lea dx,STRIP   
    int 21h 
    getTheName initalPointStr
    mov cl,intialPointActualSize
    mov ch,0
    lea bx,initalPointStr
    add bx,cx
    mov [bx],'$'
    Hexaaa initalPointStr



    hlt
main ENDP
END main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




  
