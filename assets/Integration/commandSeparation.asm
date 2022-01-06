include command.inc
include operations.inc
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
.model Huge
.stack 64
.data


Names             dw 'ax','bx','cx','dx','si','di','bp','sp','al','ah','bl','bh','cl','ch','dl','dh'
registers         dw 1111h,2222h,3303h,4444h,5555h,6666h,7777h,8888h
offsets           dw 16 dup(00)
flagdst           db 0h                    ;flag for wrong destination
flag              db 0h                    ;flag for wrong source

typeOfDestination db 0fh
destination       dw 0000h

typeOfSource      db 0fh
source            dw 0000h

memory            db 16 dup(0)
offsetMemory      dw ?
carry             db 0

;command that the player enters
MyCommand LABEL BYTE
CommandSize       db 30
ActualSize        db ?
command           db 15 dup('$')

;the forbidden char for that player
forbiddenChar     db 'M'
;forbidden flag to know that he entered forbidden char
forbiddenFlag     db 0            ;equal 1 when the player use that char

;the possible operations for the player to use
operations  db 'mov','add','adc','sub','sbb','xor'
            db 'and','nop','shr','shl','clc','ror'
            db 'rol','rcr','rcl','inc','dec','/'

;codes for the operation
;1=mov
;2=add
;3=adc
;4=sub
;5=sbb
;6=xor
;7=and
;8=nop
;9=shr
;10=shl
;11=clc
;12=ror
;13=rol
;14=rcr
;15=rcl
;16=inc
;17=dec
NumberOfOperation     db ?

;flags for invalid command
invalidOperationFlag  db 0     ;equal 1 when the operation is not in the array


;after getting the command we need to separate it into 3 parts
ourOperation          db 4 dup('$')
regName               db 5 dup('$')
SrcStr                db 5 dup('$')



.code
main proc
    mov ax,@data
    mov ds,ax
    mov es,ax
    
    
    getCommand command,ActualSize,forbiddenChar,forbiddenFlag

    ;operation --> ourOperation | destination --> regName | source --> SrcStr
    separate command,ActualSize,ourOperation,regName,SrcStr
    
    ;get the code of the operation | get the invalid flag
    knowTheOperation operations,ourOperation,NumberOfOperation,invalidOperationFlag
    
    ;if the invalid flag == 1 then exit and remove some points from the player
    mov al,invalidOperationFlag
    mov dl,1
    cmp al,dl
    jz EXITJMPOP
    jmp NOEXITOP
    EXITJMPOP: jmp EXITMAIN
    NOEXITOP:

    ;set the memory offset
    lea bx,memory
    mov offsetMemory,bx


    destinationCheck regName,Names,offsets,destination,flagdst,typeOfDestination,registers
    ;if the invalid flag == 1 then exit and remove some points from the player
    mov al,flagdst
    mov dl,1
    cmp al,dl
    jz EXITJMPDS
    jmp NOEXITDS
    EXITJMPDS: jmp EXITMAIN
    NOEXITDS:

    PUSHALL
    sourceCheck SrcStr,Names,offsets,source,flag,typeOfSource,registers
    POPALL
    ;if the invalid flag == 1 then exit and remove some points from the player
    mov al,flag
    mov dl,1
    cmp al,dl
    jz EXITJMPSO
    jmp NOEXITSO
    EXITJMPSO: jmp EXITMAIN
    NOEXITSO:


    execute NumberOfOperation,invalidOperationFlag,regName,SrcStr,destination,source,typeOfDestination,typeOfSource,carry
    
    
    EXITMAIN:
    hlt
main endp
end main