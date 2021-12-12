lowercase MACRO text
    lea si,text; si-->address of string
    L1: cmp [si],24h
    jz done
    mov al,[si]
    cmp al,97
    or al,32
    mov [si],al ; address of bx-->al
    inc si ;inc address of string
    jmp L1
    done:
    ENDM text
ENDM text

