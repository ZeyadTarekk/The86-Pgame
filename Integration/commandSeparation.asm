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
.model small
.stack 64
.data


Names        dw 'ax','bx','cx','dx','si','di','bp','sp','ah','al','bh','bl','ch','cl','dh','dl'
registers dw 0000h,0000h,0000h,0000h,5555h,6666h,7777h,8888h
offsets dw 16 dup(00)
flag db 0ffh
typeOfDestination db 0fh
destination dw 0000h
typeOfSource db 0fh
source dw 0000h

;command that the player enters
MyCommand LABEL BYTE
CommandSize db 30
ActualSize db ?
command db 15 dup('$')

;the forbidden char for that player       (for testing it will be 'M')
forbiddenChar db 'M'
;forbidden flag to know that he entered forbidden char
forbiddenFlag db 0            ;equal 1 when the player use that char

;the possible operations for the player to use
operations db 'mov','add','adc','sub','sbb','xor'
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

NumberOfOperation db ?

;flags for invalid command
invalidOperationFlag db 0     ;equal 1 when the operation is not in the array


;after getting the command we need to separate it into 3 parts
ourOperation   db 4 dup('$')
regName db 5 dup('$')
SrcStr      db 5 dup('$')



.code
main proc
    mov ax,@data
    mov ds,ax
    mov es,ax
    
    
    getCommand command,ActualSize,forbiddenChar,forbiddenFlag
    
    separate command,ActualSize,ourOperation,regName,SrcStr
    
    knowTheOperation operations,ourOperation,NumberOfOperation,invalidOperationFlag
    
    destinationCheck regName,Names,offsets,destination,flag,typeOfDestination

    sourceCheck SrcStr,Names,offsets,source,flag,typeOfSource

    execute NumberOfOperation,invalidOperationFlag,regName,SrcStr,destination,source
    
    
    
    hlt
main endp
end main