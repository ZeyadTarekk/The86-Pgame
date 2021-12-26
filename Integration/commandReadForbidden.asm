                            
getChar MACRO   
  mov ah, 07h   
  int 21h        
ENDM

.model small
 .stack 64
 .data
 ;MyCommand LABEL BYTE
CommandSize db 20
ActualSize db ?
newStr db 20 dup('$')
.code
main proc far

    mov ax,@data
    mov ds,ax
    lea di,newStr
    
    mainLoop:
    getChar
    mov dl,al
    mov bh,0Dh
    cmp dl,bh
    jz exit
    mov bh,08h
    cmp dl,bh
    jz Backspace
    
                               
    mov bl,'F' ;;forbidden Character 
    cmp al,bl
    jz found   
    
    mov ah,0eh  ;Display a character in AL
    int 10h    
    mov [di],al
    inc di 
    
   
    found:
    jmp mainLoop
      
    Backspace: ;if user enter backspace 
    dec di
    mov bl,'$'
    mov [di],bl
    mov ah,3h
    mov bh,0h  ;get cursor
    int 10h
    dec dl
    mov ah,2
    int 10h
    mov ah,2
    mov dl,' '
    int 21h
    mov ah,3h
    mov bh,0h 
    int 10h
    dec dl
    mov ah,2
    int 10h              
       
    jmp mainLoop
    
    exit:
    hlt
main endp
end main