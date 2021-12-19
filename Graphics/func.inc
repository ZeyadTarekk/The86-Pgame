clearScreen MACRO
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
ENDM


getTheName MACRO name
    mov ah,0AH      
    lea dx,name-2    
    int 21h       
ENDM

; 1) read Name and handel first char    => sherif
; 2) read intial point                  => Hamza
; 3) Decsion screen => f1 f2 esc        => tarek
; 4) Game graphics                      => Beshoy