;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Written by : - Abdelrahman Hamza and Ziad Sherif  13-12-2021                        ;;;;;
; parameters : -                                                                      ;;;;;
;   Destination string that you want to check                                         ;;;;;
;   Array of registers Names : -                                                      ;;;;;
;    'ax','bx','cx','dx','si','di','bp','sp','ah','al','bh','bl','ch','cl','dh','dl'  ;;;;;
;   registersOffsets => Marco handel its values we need it only to have 16 words      ;;;;;
;   destination the memory that you will recieve your result offset in it             ;;;;;
;   flag 1 => means not valid regardless value of destination                         ;;;;;
;   typeOfDestination => 1h means memory , 0h => means register,02=>register indirect ;;;;;
;A macro that fills registersOffsets array with offsets of registers array            ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
destinationCheck MACRO regName,Names,offsets,destination,flag,typeOfDestination,registers;;
    ; convert to lower                                                                   ;;
    LOCAL jmpDone                                                                        ;;
    LOCAL continue                                                                       ;;
    ;LOCAL done                                                                           ;;
    LOCAL exit_Dest
    PUSHALL                                                                              ;;
    offsetSetter registers,offsets                                                       ;;
    POPALL                                                                               ;;
    PUSHALL                                                                              ;;
    lowercase regName                                                                    ;;
    POPALL                                                                               ;;
                                                                                         ;;
    ; trim spaces => begining and start                                                  ;;
    PUSHALL                                                                              ;;
    trimSpaces regName                                                                   ;;
    POPALL                                                                               ;;
                                                                                         ;;
    mov dx,word ptr regName                                                              ;;
                                                                                         ;;
    PUSHALL                                                                              ;;
    validateRegister Names,offsets,dx,destination,flag                          ;;
    mov typeOfDestination,0h                                                             ;;
    POPALL                                                                               ;;
                                                                                         ;;
    mov ah,1                                                                             ;;
    cmp flag,ah                                                                          ;;
    jnz jmpDone                                                                          ;;
        jmp continue                                                                     ;;
    jmpDone: jmp exit_Dest                                                                    ;;
        continue:                                                                        ;;
        mov flag,0ffh                                                                    ;;
        validateMemory regName,flag,destination                                          ;;ax
        mov typeOfDestination,01h                                                        ;;[111] 11
        mov ah,1                                                                         ;;[ax]
        cmp flag,ah                                                                      ;;
        jnz jmpFix
        jmp validateRegrDt
            jmpFix: jmp memt
        validateRegrDt:
            ; mov ah,9h
            ; mov dx,destination
            ; int 21h
            mov flag,0ffh
            validateRegisterDirect Names,offsets,regName,destination,flag
            mov ah,1                                                                        
            cmp flag,ah                                                                     
            mov typeOfDestination,02h
            jmp exit_Dest
         memt: Hexaaa destination
    exit_Dest:  
ENDM                                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;