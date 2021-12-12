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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




separate macro command,size,operation,destination,source
LOCAL DesCon,SouCon   
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





knowTheOperation macro operations,ourOperation,NumberOfOperation,invalidOperationFlag
LOCAL CONTINUE,EXIT1,EXIT2,FINISH,INVALID    
    
    ;know the exact operation
    mov cx,1             ;counter to know the operation
    lea si,operations
    lea di,ourOperation
    
    CONTINUE:
    cmp [si],2FH
    jz INVALID
    cmpsb
    jnz EXIT1
    ;equals
    cmpsw
    jnz EXIT2
    ;equals
    mov NumberOfOperation,cl
    jmp FINISH
    
    
    EXIT1:
    lea di,ourOperation
    add si,2
    inc cx
    jmp CONTINUE
    
    
    EXIT2:
    lea di,ourOperation
    inc cx    
    jmp CONTINUE
    
    INVALID:
    mov invalidOperationFlag,1 
    mov cx,0
    
    FINISH:
    
    
knowTheOperation endm