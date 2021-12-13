lowercase MACRO text
    LOCAL done
    lea si,text; si-->address of string
    L1: cmp [si],24h
    jz done ;if equal to $ ---> terminate
    mov al,[si] 
    cmp al,97 
    or al,32 ;or with ascci in string
    mov [si],al ; lower character will be placed
    inc si ;inc address of string
    jmp L1
    done: ; end if =$
ENDM 

