include lowCase.inc
include setOff.inc
include PUSHPOP.inc
include validNum.inc
include validMem.inc
include strSpcs.inc
include trimSpcs.inc
include validReg.inc
include vMemSrc.inc
.model small
.stack 64
.data

Names        dw 'ax','bx','cx','dx','si','di','bp','sp','ah','al','bh','bl','ch','cl','dh','dl'
registers dw 8 dup(0000h)
registersOffsets dw 16 dup(00)
flag db 0ffh
typeOfSource db 0fh
source dw 00000h
SrcStr db '  [120f] $'

sourceCheck MACRO SrcStr,Names,registersOffsets,source,flag,typeOfSource
    ; convert to lower
    LOCAL jmpDone
    LOCAL continue
    LOCAL done
        PUSHALL
    offsetSetter registers,registersOffsets
    POPALL
    PUSHALL
    lowercase SrcStr
    POPALL

    ; trim spaces => begining and start
    PUSHALL
    trimSpaces SrcStr
    POPALL

    mov dx,word ptr SrcStr

    PUSHALL
    validateRegister Names,registersOffsets,dx,source,flag
    POPALL

    mov ah,1
    cmp flag,ah
    jnz jmpDone
        jmp continue
    jmpDone: jmp done
        continue:
        mov flag,0ffh
        validateMemorySrc SrcStr,flag,source,typeOfSource
        ;;;;; convert destination to hexa
    done:
ENDM
.code
main proc far

    mov ax,@data
    mov ds,ax
    mov es,ax
    sourceCheck  SrcStr,Names,registersOffsets,source,flag,typeOfSource

     mov ah,9h
     mov dx,source
     int 21h
    hlt
main endp
end main