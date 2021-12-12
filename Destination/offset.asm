.model small
.stack 64
.data

registers        dw 'ax','bx','cx','dx','si','di','bp','sp','ah','al','bh','bl','ch','cl','dh','dl'
registersOffsets dw 16 dup(00)

.code



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Written by : - Abdelrahman Hamza  12-12-2021
; parameters : - two arrays 1) input array 2) output array                            ;;
; return     : - fill output array with offsets of input array                        ;;
;A macro that fills registersOffsets array with offsets of registers array            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
offsetSetter MACRO InputRegisters, InputRegistersOffsets                              ;;
    LOCAL offsetLoop                                                                  ;;
    ; loop 16 times => number of registers                                            ;;
    mov cx,30                                                                         ;;
     ; Loop start                                                                     ;;
     offsetLoop:                                                                      ;;
        mov bx,cx                                                                     ;;
        mov ax,offset InputRegisters                                                  ;;
        add ax,cx                                                                     ;;
        mov InputRegistersOffsets[bx],ax                                              ;;
        dec cx                                                                        ;;
     loop offsetLoop                                                                  ;;
ENDM                                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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