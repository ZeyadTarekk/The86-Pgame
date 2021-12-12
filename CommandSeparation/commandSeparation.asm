.model small
.stack 64

.data

;command that the player enters
MyCommand LABEL BYTE
CommandSize db 30
ActualSize db ?
command db 30 dup('$')

;the forbidden char for that player       (for testing it will be 'M')
forbiddenChar db 'M'
;forbidden flag to know that he entered forbidden char
forbiddenFlag db 0            ;equal 1 when the player use that char

;the possible operations for the player to use
operations db 'MOV','ADD','ADC','SUB','SBB','XOR'
           db 'AND','NOP','SHR','SHL','CLC','ROR'
           db 'ROL','RCR','RCL','INC','DEC','/'

;flags for invalid command
invalidOperationFlag db 0     ;equal 1 when the operation is not in the array

;after getting the command we need to separate it into 3 parts
ourOperation   db 3 dup('$')
ourDestination db 4 dup('$')
ourSource      db 4 dup('$')


;functions
getCommand macro command,size,forbiddenChar,forbiddenFlag
LOCAL EXIT           
   ;get the player's command
       
   mov ah,0AH
   lea dx,command-2
   int 21h
   
   ;check if the command contains forbidden char 
   ;then turn on the forbidden flag   
   
   lea si,command      ;the command itself
   mov al,forbiddenChar  
   lea di,size
   mov cl,[di]           ;the actual size      
   repne SCASB           ;scan the command for the forbidden char
   
   ;if cl!=0 then the forbidden flag will be 1
   cmp cl,0
   jz EXIT
   mov forbiddenFlag,01h
   
   EXIT:
getCommand endm


separate macro command,size,operation,destination,source
   
    ;get the operation
    lea si,command
    mov al,[si]
    mov operation,al
    inc si
    mov al,[si]
    mov operation+1,al
    inc si
    mov al,[si]
    mov operation+2,al
        
    ;first find the space to get the operation
    lea di,command
    mov al,20h
    lea bx,size
    mov cl,[bx]           ;the actual size
    repne SCASB
    ;now the di is on the first char of the destination
    mov si,di
    
    ;we need to get the comma(,) so that the destination done
    mov al,2Ch
    lea bx,size
    mov cl,[bx]           ;the actual size
    repne SCASB
    ;now the di is on the first char of the source     
     
    ;copy the destination to its variable
    mov cx,di
    dec cx    
    lea bx,destination    
    DesCon:
    mov al,[si]
    mov [bx],al
    inc bx                 ;move to next char of destination
    inc si                 
    cmp si,cx
    jnz DesCon 
    
    ;copy the source to its variable
    lea bx,source
    SouCon:
    mov al,[di]
    mov [bx],al
    inc bx
    inc di
    cmp [di],0DH
    jnz SouCon   
   
   
   
separate endm

.code
main proc
    mov ax,@data
    mov ds,ax
    mov es,ax
    
    
    getCommand command,ActualSize,forbiddenChar,forbiddenFlag
    
    separate command,ActualSize,ourOperation,ourDestination,ourSource
    
    
    
    
    hlt
main endp
end main