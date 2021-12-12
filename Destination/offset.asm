.model small
.stack 64
.data

registers        dw 'ax','bx','cx','dx','si','di','bp','sp','ah','al','bh','bl','ch','cl','dh','dl'
registersOffsets dw 16 dup(00)

.code


main proc far

    mov ax,@data
    mov ds,ax
    mov es,ax
    offsetSetter registers,registersOffsets
    mov bx,registersOffsets[2]
    mov [bx],12ffh
    hlt
main endp
end main