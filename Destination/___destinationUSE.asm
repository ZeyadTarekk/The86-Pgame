include lowCase.inc
include setOff.inc
include PUSHPOP.inc
include validNum.inc
include validMem.inc
include strSpcs.inc
include trimSpcs.inc
include validReg.inc
.model small
.stack 64
.data

Names        dw 'ax','bx','cx','dx','si','di','bp','sp','ah','al','bh','bl','ch','cl','dh','dl'
registers dw 8 dup(0000h)
registersOffsets dw 16 dup(00)
flag1112 db 0ffh
typeOfDestination db 0fh
destination dw 00000h
DestStr db '  [120f] $'

destinationCheck MACRO DestStr,Names,registersOffsets,destination,flag
    ; convert to lower
    LOCAL jmpDone
    LOCAL continue
    LOCAL done
    PUSHALL
    offsetSetter registers,registersOffsets
    POPALL
    PUSHALL
    lowercase DestStr
    POPALL

    ; trim spaces => begining and start
    PUSHALL
    trimSpaces DestStr
    POPALL

    mov dx,word ptr DestStr

    PUSHALL
    validateRegister Names,registersOffsets,dx,destination,flag1112
    POPALL

    mov ah,1
    cmp flag1112,ah
    jnz jmpDone
        jmp continue
    jmpDone: jmp done
        continue:
        mov flag1112,0ffh
        validateMemory DestStr,flag1112,destination
        ;;;;; convert destination to hexa
    done:
ENDM
.code
main proc far

    mov ax,@data
    mov ds,ax
    mov es,ax
    destinationCheck DestStr,Names,registersOffsets,destination,flag
     mov ah,9h
     mov dx,destination
     int 21h
    hlt
main endp
end main