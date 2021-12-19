include func.inc
.model huge
.data

myName LABEL BYTE
nameSize db 15
ActualSize db ?
playerName db 15 dup('$')
endl    db  10,13 ,'$'
str         db 'Donee','$'
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
    
    getTheName playerName
                     
                     
    lea si,playerName
    mov ax,'9'
    cmp [si],ax;check if between 0,9
    jbe L09
      
    mov ax,'Z'
    cmp [si],ax ;check if between A,Z
    jbe LAZ
    
    mov ax,'z'
    cmp [si],ax     ;check if between a,z
    jbe Lza
    
    
    L09:
    cmp [si],'0'
    jae exit
    jmp mainLoop
    
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
    mov ah,9
    lea dx,endl
    int 21h
    mov ah,9
    lea dx,str   ;for testing to check if name is valid or not
    int 21h
    hlt
main ENDP
END main