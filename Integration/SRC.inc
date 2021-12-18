;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Written by : - Abdelrahman Hamza and Ziad Sherif  13-12-2021                        ;;;;;
; parameters : -                                                                      ;;;;;
;   source string that you want to check                                              ;;;;;
;   Array of registers Names : -                                                      ;;;;;
;    'ax','bx','cx','dx','si','di','bp','sp','ah','al','bh','bl','ch','cl','dh','dl'  ;;;;;
;   registersOffsets => Marco handel its values we need it only to have 16 words      ;;;;;
;   source the memory that you will recieve your result offset in it                  ;;;;;
;   flag 1 => means not valid regardless value of destination                         ;;;;;
;   typeOfSource => 1h means memory , 0h => means register, 02 => means immediate     ;;;;;
;                   03=> means register indirect                                      ;;;;;
;A macro that fills registersOffsets array with offsets of registers array            ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sourceCheck MACRO SrcStr,Names,offsets,destination,flag,typeOfSource                 ;;
    ; convert to lower                                                                   ;;
    LOCAL jmpDone                                                                        ;;
    LOCAL continue                                                                       ;;
    LOCAL exitsrc                                                                           ;;
    LOCAL jmpFix                                                                           ;;
    LOCAL memt                                                                           ;;
    LOCAL validateRegrDt                        ;;
    PUSHALL                                                                          ;;
    offsetSetter registers,offsets                                              ;;
    POPALL                                                                               ;;
    PUSHALL                                                                              ;;
    lowercase SrcStr                                                                     ;;
    POPALL                                                                               ;;
                                                                                         ;;
    ; trim spaces => begining and start                                                  ;;
    PUSHALL                                                                              ;;
    trimSpaces SrcStr                                                                    ;;
    POPALL                                                                               ;;
                                                                                         ;;
    mov dx,word ptr SrcStr                                                               ;;
                                                                                         ;;
    PUSHALL                                                                              ;;
    validateRegister Names,offsets,dx,destination,flag                               ;;
    mov typeOfSource,0h
    POPALL                                                                               ;;
                                                                                         ;;
    mov ah,1                                                                             ;;
    cmp flag,ah                                                                          ;;
    jnz jmpDone                                                                          ;;
        jmp continue                                                                     ;;
    jmpDone: jmp exitsrc                                                                    ;;
        continue:                                                                        ;;
        mov flag,0ffh                                                                    ;;
        validateMemorySrc SrcStr,flag,destination,typeOfSource                                ;;
        mov ah,1                                                                         ;;[ax]
        cmp flag,ah                                                                      ;;
        jnz jmpFix
        jmp validateRegrDt
            jmpFix: jmp memt
        validateRegrDt:
            mov ah,9h
            mov dx,destination
            int 21h
            mov flag,0ffh
            validateRegisterDirect Names,offsets,SrcStr,destination,flag
            mov ah,1
            cmp flag,ah
            mov typeOfSource,03h
            jmp exitsrc
         memt: Hexaaa destination
    exitsrc:                                                                                ;;
ENDM                                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;