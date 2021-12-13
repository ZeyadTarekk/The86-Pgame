.model small
.stack 64
.data
dummy db ?
registers        dw 'ax','bx','cx','dx','si','di','bp','sp','ah','al','bh','bl','ch','cl','dh','dl'
registersOffsets dw 16 dup(00)
;string db " H e   l lo Worl    d   $"
string db '[014fe213213213cd]$'
string2 db '[ 014f e2132aa132 13cd]$'
string3 db '[ 01n4f e2132aa132 13cd]$'
string4 db 'Hello world$'
string5 db '[000f]$'
flag db 0ffh
destination dw 00000
testString db 0000
.code

printChar MACRO char
    mov ah,2h
    mov dl,char
    int 21h
ENDM
printString MACRO string
    mov ah,9h
    mov dx,offset string
    int 21h
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Written by : - Abdelrahman Hamza  12-12-2021                                        ;;
; parameters : - two arrays 1) input array 2) output array                            ;;
; return     : - fill output array with offsets of input array                        ;;
;A macro that fills registersOffsets array with offsets of registers array            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
offsetSetter MACRO InputRegisters, InputRegistersOffsets                              ;;
    LOCAL offsetLoop16                                                                ;;
    LOCAL offsetLoop8                                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; loop 16 times => number of registers                                            ;;
    ;set offsets of 16bit registers                                                   ;;
    mov cx,16                                                                         ;;
     ; Loop start                                                                     ;;
     offsetLoop16:                                                                    ;;
        mov bx,cx                                                                     ;;
        mov ax,offset InputRegisters                                                  ;;
        add ax,cx                                                                     ;;
        mov InputRegistersOffsets[bx],ax                                              ;;
        dec cx                                                                        ;;
     loop offsetLoop16                                                                ;;
                                                                                      ;;
    ;next two line Handels first 16bit register                                       ;;
    mov ax,offset InputRegisters                                                      ;;
    mov InputRegistersOffsets,ax                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;set offsets of 8bit registers                                                    ;;
    ; cx only handels loop range                                                      ;;
    mov cx,16                                                                         ;;
    ; bx iterates over offsetArray                                                    ;;
    mov bx,16                                                                         ;;
    ; si iterates over registers                                                      ;;
    mov si,0                                                                          ;;
    ; Loop start                                                                      ;;
     offsetLoop8:                                                                     ;;
        mov ax,offset InputRegisters                                                  ;;
        add ax,si                                                                     ;;
        mov InputRegistersOffsets[bx],ax                                              ;;
        inc si                                                                        ;;
        add bx,2                                                                      ;;
        dec cx                                                                        ;;
     loop offsetLoop8                                                                 ;;
ENDM                                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Written by : - Abdelrahman Hamza  12-12-2021                                        ;;
; parameters : - string you want to remove all spaces from it                         ;;
; return     : - Removes all spaces from this string                                  ;;
;A macro that takes a string with spaces and remove all spaces from it                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
removeSpaces MACRO string                                                             ;;
    LOCAL loopOverAllString                                                           ;;
    LOCAL stringEnd                                                                   ;;
    LOCAL notSpace                                                                    ;;
    LOCAL innerLoopString                                                             ;;
    LOCAL DontIncBX                                                                   ;;
    mov bx, string                                                                    ;;
                                                                                      ;;
    ;mov bx,offset string                                                             ;;
    ;iterate over all string                                                          ;;
    loopOverAllString:                                                                ;;
        ;check end of string                                                          ;;
        mov ah,'$'                                                                    ;;
        cmp [bx],ah                                                                   ;;
        jz stringEnd                                                                  ;;
        ;check if space                                                               ;;
        mov ah,' '                                                                    ;;
        cmp [bx],ah                                                                   ;;
        jnz notSpace                                                                  ;;
            ; if space what to do?                                                    ;;
            mov si,bx                                                                 ;;
            innerLoopString:                                                          ;;
                mov ah,'$'                                                            ;;
                cmp [si],ah                                                           ;;
                jz DontIncBX   ;not increament bx if space                            ;;
                mov ax,[si+1]                                                         ;;
                mov [si],ax                                                           ;;
                inc si                                                                ;;
            jmp innerLoopString                                                       ;;
                                                                                      ;;
        notSpace:                                                                     ;;
        inc bx                                                                        ;;
        DontIncBX:                                                                    ;;
    jmp loopOverAllString                                                             ;;
                                                                                      ;;
    stringEnd:                                                                        ;;
ENDM                                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Written by : - Abdelrahman Hamza  12-12-2021                                        ;;
; parameters : - a number represented as a string you want to validate                ;;
; return     : - flag = 1 if not valid else not affect it                             ;;
;A macro that validate a number => has spaces and 0,1,...f                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validateNumbers MACRO string,flag                                                     ;;
    LOCAL validNumber                                                                 ;;
    LOCAL loopOverAllString                                                           ;;
    LOCAL stringEnd                                                                   ;;
    LOCAL done                                                                        ;;
    pusha                                                                             ;;
    removeSpaces string                                                               ;;
    popa                                                                              ;;
    mov bx,string                                                                     ;;
    ;mov bx,offset string                                                             ;;
                                                                                      ;;
    loopOverAllString:                                                                ;;
        mov ah,'$'
        cmp [bx],ah                                                                  ;;
        jz stringEnd                                                                  ;;
        mov ax,[bx]                                                                   ;;
        mov ah,0                                                                      ;;
        sub ax,'0'                                                                    ;;
        cmp ax,000Fh                                                                  ;;
        jbe validNumber                                                               ;;
            mov ax,[bx]                                                               ;;
            mov ah,0                                                                  ;;
            sub ax,'a'                                                                ;;
            cmp ax,0005h                                                              ;;
            jbe validNumber                                                           ;;
            mov flag,0001h                                                            ;;
            jmp stringEnd                                                             ;;
        validNumber:                                                                  ;;
        inc bx                                                                        ;;
    jmp loopOverAllString                                                             ;;
    stringEnd:                                                                        ;;
ENDM                                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Written by : - Abdelrahman Hamza  12-12-2021                                        ;;
; parameters : - a number represented as a string you want to validate                ;;
; return     : - flag = 1 if not valid memory else not affect it                      ;;
;A macro that validate a number => has spaces and 0,1,...f                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validateMemory MACRO string,flag,destination                                          ;;
    pusha                                                                             ;;
    mov bx,offset string                                                              ;;
    removeSpaces bx                                                                   ;;
    popa                                                                              ;;
    mov bx,offset string                                                              ;;
    mov si,offset string                                                              ;;
                                                                                      ;;
    GoToStringEnd:                                                                    ;;
        mov ah,'$'                                                                    ;;
        cmp [si],ah                                                                   ;;
        inc si                                                                        ;;
        mov ah,'$'                                                                    ;;
        cmp [si],ah                                                                   ;;
    jnz GoToStringEnd                                                                 ;;
    dec si                                                                            ;;
                                                                                      ;;
    mov ah,'['                                                                        ;;
    cmp [bx],ah                                                                       ;;
    jnz compareEnd                                                                    ;;
        mov ah,']'                                                                    ;;
        cmp [si],ah                                                                   ;;
        jnz notValidSquare                                                            ;;
        jmp WithSquareBracktes                                                        ;;
        compareEnd:                                                                   ;;
        mov ah,']'                                                                    ;;
        cmp [si],ah                                                                   ;;
        jz notValidSquare                                                             ;;
        jmp noSqaure                                                                  ;;
    notValidSquare: mov flag,0001h                                                    ;;
    jmp done                                                                          ;;
    WithSquareBracktes:                                                               ;;
    inc bx                                                                            ;;
    mov ah,'$'                                                                        ;;
    mov [si],ah                                                                       ;;
    pusha                                                                             ;;
    validateNumbers bx,flag                                                           ;;
    popa                                                                              ;;
    jmp done                                                                          ;;
    noSqaure:                                                                         ;;
    pusha                                                                             ;;
    validateNumbers bx,flag                                                           ;;
    popa                                                                              ;;
    done:                                                                             ;;
    mov destination,bx                                                                ;;
ENDM                                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main proc far

    mov ax,@data
    mov ds,ax
    mov es,ax
    validateMemory string,flag,destination

    mov ah,9h
    mov dx,destination
    int 21h
    hlt
main endp
end main