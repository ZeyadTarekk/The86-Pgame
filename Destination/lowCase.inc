lowercase MACRO text
LOCAL L1
LOCAL openPract
LOCAL closePract
LOCAL done
    lea si,text; si-->address of string
    L1:
    mov dh,24h
    cmp [si],dh
    jz done ;if equal to $ ---> terminate
    mov dh,91
    cmp [si],dh
    jz openPract
    mov dh,93
    cmp [si],dh
    jz closePract
    mov al,[si]
    mov dh,97
    cmp al,dh
    or al,32 ;or with ascci in string
    mov [si],al ; lower character will be placed
    closePract:
    openPract:
    inc si ;inc address of string
    jmp L1
    done: ; end if =$
ENDM 

