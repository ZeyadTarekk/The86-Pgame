include lowCase.inc
        include setOff.inc
        include PUSHPOP.inc
        include validNum.inc
        include validMem.inc
        include strSpcs.inc
        include trimSpcs.inc
        include validReg.inc
        include HexaStr.inc
        include validRD.inc
        include Dest.inc
        include vMemSrc.inc
        include SRC.inc
.model small
.stack 64
.data

; Names        dw 'ax','bx','cx','dx','si','di','bp','sp','ah','al','bh','bl','ch','cl','dh','dl'
; registers dw 1111h,2222h,3333h,4444h,5555h,6666h,7777h,8888h
; offsets LABEL word
; registersOffsets dw 16 dup(00)
; flag db 0ffh
; typeOfDestination db 0fh
; destination dw 00000h
; SrcStr db 'bx$'

Names        dw 'ax','bx','cx','dx','si','di','bp','sp','ah','al','bh','bl','ch','cl','dh','dl'
registers dw 1111h,2222h,3333h,4444h,5555h,6666h,7777h,8888h
offsets dw 16 dup(00)
flag db 0ffh
typeOfDestination db 0fh
destination dw 00000h
SrcStr db '[bx]$'
.code
        main proc far

mov ax,@data
        mov ds,ax
        mov es,ax
        sourceCheck SrcStr,Names,offsets,destination,flag,typeOfDestination

        hlt
main endp
end main
hlt
        main endp
        end main