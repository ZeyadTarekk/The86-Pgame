include PUSHPOP.inc
include vMemSrc.inc
include SRC.inc
.model Huge
.stack 64

.data

Names             dw 'ax','bx','cx','dx','si','di','bp','sp','al','ah','bl','bh','cl','ch','dl','dh'
registers         dw 1111h,0FFFFh,3333h,4444h,5555h,6666h,7777h,8888h
offsets           dw 16 dup(00)
flagdst           db 0h                    ;flag for wrong destination
flag              db 0h                    ;flag for wrong source
;type of source and destination and the final offset of them
typeOfDestination db 0fh
destination       dw 0000h
typeOfSource      db 0fh
source            dw 0000h
;our memory variable
memory            db 11h,22h,33h,44h,11h,22h,33h,44h,11h,22h,33h,44h,11h,22h,33h,44h
offsetMemory      dw ?
;our carry
carry             db 0
;our command
MyCommand LABEL BYTE
CommandSize       db 30
ActualSize        db ?
command           db 15 dup('$')
;after getting the command we need to separate it into 3 parts
ourOperation          db 4 dup('$')
regName               db "123$"
SrcStr                db 5 dup('$')
;our forbidden char
forbiddenChar     db 'M'
;forbidden flag to know that he entered forbidden char
forbiddenFlag     db 0            ;equal 1 when the player use that char
operations  db 'mov','add','adc','sub','sbb','xor','and','nop','shr','shl','clc','ror','rol','rcr','rcl','inc','dec','/'

CodeOfOperation     db ?
invalidOperationFlag  db 0     ;equal 1 when the operation is wrong

; Lowercase parameters

.code
main PROC
    mov ax,@data
    mov ds,ax
    call destinationCheck
    mov bx,[destination]
    mov ax,[bx]
    hlt
main ENDP

destinationCheck proc 
    call offsetSetter 
    call lowercaseDest                              
                                                    
    ; trim spaces => begining and start             
    PUSHALL                                         
    call trimSpacesDest                             
    POPALL                                          
                                                    
    mov dx,word ptr regName                         
                                                    
    PUSHALL                                         
    call validateRegisterDest
    mov typeOfDestination,0h                        
    POPALL                                          
                                                    
    mov ah,1                                        
    cmp flagdst,ah                                  
    jnz jmpDone                                     
        jmp continue                                
    jmpDone: jmp exit_Dest                          
        continue:                                   
        mov flagdst,0ffh                            
        call validateMemoryDest                     
        mov typeOfDestination,01h                   
        mov ah,1                                    
        cmp flagdst,ah                              
        jnz jmpFix
        jmp validateRegrDt
            jmpFix: jmp memt
        validateRegrDt:
            ; mov ah,9h
            ; mov dx,destination
            ; int 21h
            mov flagdst,0ffh
            call validateRegisterDirectDest
            mov ah,1                                                                        
            cmp flagdst,ah                                                                     
            mov typeOfDestination,02h
            jmp exit_Dest
         memt: call convertStrHexaDest
    exit_Dest: 
    ret 
destinationCheck endp 




offsetSetter proc 
    ; loop 16 times => number of registers                                            ;;
    ;set offsets of 16bit registers                                                   ;;
    mov cx,16                                                                         ;;
     ; Loop start                                                                     ;;
     offsetLoop16:                                                                    ;;
        mov bx,cx                                                                     ;;
        mov ax,offset registers                                                  ;;
        add ax,cx                                                                     ;;
        mov offsets[bx],ax                                              ;;
        dec cx                                                                        ;;
     loop offsetLoop16                                                                ;;
                                                                                      ;;
    ;next two line Handels first 16bit register                                       ;;
    mov ax,offset registers                                                      ;;
    mov offsets,ax                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;set offsets of 8bit registers                                                    ;;
    ; cx only handels loop range                                                      ;;
    mov cx,16                                                                         ;;
    ; bx iterates over offsetArray                                                    ;;
    mov bx,16                                                                         ;;
    ; si iterates over registers                                                      ;;
    mov si,0                                                                          ;;
    ; Loop start                                                                      ;;
     offsetLoop8:                                                                     ;;
        mov ax,offset registers                                                  ;;
        add ax,si                                                                     ;;
        mov offsets[bx],ax                                              ;;
        inc si                                                                        ;;
        add bx,2                                                                      ;;
        dec cx                                                                        ;;
     loop offsetLoop8                                                                 ;;
    ret
offsetSetter endp                                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



lowercaseDest proc 
    lea si,regName     ;poitns to the 1st char of string

    mainLoop:
    mov dh,24h  ;;check if $ or not
    cmp [si],dh

    jz exitLcase         ;if equal to $ ---> terminate
    mov dh,91       ;;to skip square brackt([)]
    cmp [si],dh
    jz openPract

    mov dh,93
    cmp [si],dh
    jz closePract  ;;to avoid square brcket (])

    mov al,[si]
    mov dh,97       ;;convert to upper to lower case
    cmp al,dh

    or al,32        ;or with ascci in string
    mov [si],al     ; lower character will be placed


    closePract:
    openPract:
    inc si      ;points to the next char

    jmp mainLoop  ;iterate till $

    exitLcase: ; end if =$
    ret
lowercaseDest endp  


trimSpacesDest proc string                                                               ;;
    mov bx, offset regName                                                             ;;
                                                                                      ;;
    ;mov bx,offset string                                                             ;;
    ;iterate over all string                                                          ;;
    loopOverAllString:                                                                ;;
        ;check end of string                                                          ;;
        mov ah,' '                                                                    ;;
        cmp [bx],ah                                                                   ;;
        jnz notSpace                                                                  ;;
            mov si,bx                                                                 ;;
            shiftStr:                                                                 ;;
            mov ah,[si+1]                                                             ;;
            mov [si],ah                                                               ;;
            mov ah,'$'                                                                ;;
            cmp [si],ah                                                               ;;
            jz loopOverAllString                                                      ;;
            inc si                                                                    ;;
            jnz shiftStr                                                              ;;
    jmp loopOverAllString                                                             ;;
    notSpace:                                                                         ;;
                                                                                      ;;
    movBXToEnd:                                                                       ;;
    mov ah,'$'                                                                        ;;
    cmp [bx],ah                                                                       ;;
    jz loopOverAllStringEnd                                                           ;;
    inc bx                                                                            ;;
    jnz movBXToEnd                                                                    ;;
                                                                                      ;;
    loopOverAllStringEnd:                                                             ;;
        dec bx                                                                        ;;
        ;check end of string                                                          ;;
        mov ah,' '                                                                    ;;
        cmp [bx],ah                                                                   ;;
        jnz notSpaceEND                                                               ;;
            mov si,bx                                                                 ;;
            shiftStrEND:                                                              ;;
            mov ah,[si+1]                                                             ;;
            mov [si],ah                                                               ;;
            mov ah,'$'                                                                ;;
            cmp [si],ah                                                               ;;
            jz loopOverAllStringEnd                                                   ;;
            inc si                                                                    ;;
            jnz shiftStrEND                                                           ;;
    jmp loopOverAllStringEnd                                                          ;;
    notSpaceEND:
    ret                                                                      ;;
trimSpacesDest endp                                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




validateRegisterDest proc                                               

    mov cx,30   ;;iterate on on 30 byte of Names==> ax bx ..dh dl                     ;;
    mov dx,word ptr regName                                                                            ;;
    mainLoopVR:                                                                         ;;
                                                                                      ;;
        mov bx,cx                                                                     ;;
        mov ax,Names[bx]   ;;get the register with index bx from end to begin         ;;
        cmp ax,dx         ;;compare with input register                              ;;
        jz found                                                                      ;;
                                                                                      ;;
        dec cx     ;dec cx by 2 ==>1 word                                             ;;
    loop mainLoopVR                                                                     ;;
                                                                                      ;;
                                                                                      ;;
    found:                                                                            ;;
    mov ax,Names  ;ax points to the first reg ('ax')                                  ;;
    cmp ax,dx                                                                        ;;
                                                                                      ;;
    jnz NotFirst                                                                      ;;
                                                                                      ;;
                                                                                      ;;
        mov ax,word ptr offsets   ;get first word of offset array                     ;;
        mov destination,ax                                                            ;;
        jmp exit_vr                                                                      ;;
                                                                                      ;;
                                                                                      ;;
    NotFirst:                                                                         ;;
    mov ax,0    ;check if reach to the  beggining of array or not                     ;;
    cmp cx,ax                                                                         ;;
    jz notFound                                                                       ;;
                                                                                      ;;
                                                                                      ;;
        mov bx,cx          ;;founded                                                  ;;
        mov ax,word ptr offsets[bx]                                                   ;;
        mov destination,ax                                                            ;;
        jmp exit_vr                                                                      ;;
                                                                                      ;;
    notFound:                                                                         ;;
        mov flagdst,1  ;;set flag to 1 which indicates isNot Found                       ;;
                                                                                      ;;
    exit_vr:                                                                             ;;
    ret
validateRegisterDest endp                                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



validateMemoryDest proc   
    mov bx,offset regName                    
    mov si,offset regName                    
                                             
    GoToStringEnd:                           
        mov ah,'$'                           
        cmp [si],ah                          
        inc si                               
        mov ah,'$'                           
        cmp [si],ah                          
    jnz GoToStringEnd                        
    dec si                                   
                                             
    mov ah,'['                               
    cmp [bx],ah                              
    jnz compareEnd                           
        mov ah,']'                           
        cmp [si],ah                          
        jnz notValidSquare                   
        jmp WithSquareBracktes               
        compareEnd:                          
        mov ah,']'                           
        cmp [si],ah                          
        jz notValidSquare                    
        jmp noSqaure                         
    notValidSquare: mov flagdst,0001h        
    jmp VmemExit                             
    WithSquareBracktes:                      
    inc bx                                   
    mov ah,'$'                               
    mov [si],ah                              
    PUSHALL                                  
    call validateNumbers             
    POPALL                                   
    jmp VmemExit                             
    noSqaure:                                
    PUSHALL                                  
    call validateNumbers              
    POPALL                                   
    VmemExit:                                
    mov destination,bx                       
    ret
validateMemoryDest endp                                         



validateRegisterDirectDest proc   
                                                                                                                                       
    mov dx,word ptr regName+1                                               
                                                                            
    call validateRegisterRDProc                            
                                                                  
    mov bx,word ptr regName+1                                               
                                                                            
    mov ax, 'xb'                                                            
    ; if regName == 'BX'                                                    
    cmp ax, bx                                                              
        jz foundRD                                                          
                                                                            
    mov ax, 'is'                                                            
    ; if regName == 'SI'                                                    
    cmp ax, bx                                                              
        jz foundRD                                                          
                                                                            
    mov ax, 'id'                                                            
    ; if regName == 'DI'                                                    
    cmp ax, bx                                                              
        jz foundRD                                                          
                                                                            
    jmp notFoundRD                                                          
    ; if valid register dircet mode [BX],[SI],[DI]                          
    foundRD:                                                                
        mov di,destination                                                  
        mov bx,[di]                                                         
        mov di,offset destination                                           
        mov [di],bx                                                         
        jmp exit_vrd                                                        
    notFoundRD:                                                             
        mov flagdst,01h                                                     
    exit_vrd:           
    ret                                                    
validateRegisterDirectDest endp                                                                        


validateRegisterRDProc proc                                               

    mov cx,30   ;;iterate on on 30 byte of Names==> ax bx ..dh dl              
    mov dx,word ptr regName+1                                     
    mainLoopDestRegDirect:                                                                
                                                                               
        mov bx,cx                                                              
        mov ax,Names[bx]   ;;get the register with index bx from end to begin  
        cmp ax,dx         ;;compare with input register               
        jz foundDestRegDirect                                                      
                                                                      
        dec cx     ;dec cx by 2 ==>1 word                             
    loop mainLoopDestRegDirect                                                   
                                                                      
                                                                      
    foundDestRegDirect:                                                            
    mov ax,Names  ;ax points to the first reg ('ax')                  
    cmp ax,dx                                                         
                                                                      
    jnz NotFirstDestRegDirect                                                      
                                                                      
                                                                      
        mov ax,word ptr offsets   ;get first word of offset array     
        mov destination,ax                                            
        jmp exit_vr                                                   
                                                                      
                                                                      
    NotFirstDestRegDirect:                                                         
    mov ax,0    ;check if reach to the  beggining of array or not     
    cmp cx,ax                                                         
    jz notFoundDestRegDirect                                                       
                                                                      
                                                                      
        mov bx,cx          ;;founded                                  
        mov ax,word ptr offsets[bx]                                   
        mov destination,ax                                            
        jmp exit_vrDestRegDirect                                                   
                                                                      
    notFoundDestRegDirect:                                                         
        mov flagdst,1  ;;set flag to 1 which indicates isNot Found    
                                                                      
    exit_vrDestRegDirect:                                                          
    ret
validateRegisterRDProc endp                                                                                  ;;

convertStrHexaDest proc 
                mov si,destination
                ;lea   si,string
                ;lea   di,hexaWord    ;converted string to hexadecimal
    mainLoopHexa:
                mov ah,24h              ;to avoid dbox khara error :3
                cmp   [si],ah       ;check if char is $
                jz    exitHexa           ;if ture ==>end
                mov   dl,[si]        ;assci of current char
                mov ah,40h
                cmp dl,40h          ;compare if digit from 0-9
                jbe   from_zero_nine    ;jump to get hexadecimal of digit
                sub dl,61h  ;  get hexa of  digit (A==>F)
                add dl,10
                jmp   skip  ; jump to skip (0-->9)
    from_zero_nine:
                sub dl,30h
    skip:
                mov [si],dl ; assignment value of dl to string
                inc si   ; points to the next digit
                jmp   mainLoopHexa  ;iterate till  $
    exitHexa:
    mov si,destination       ;;conctenate the final answer ==> 01 02 00 0f $as exmaple ==>should be 120f
    mov bx,10h             ;; ax 00 01 => 00 10 => 00  12 => 01 20=> 12 0f
    mov al,[si]
    mov ah,0
    mov cl,'$'

    cmp al,cl
    jz Outloop
    inc si
    LOOPMain:
        mov dl,[si]
        cmp dl,cl
        jz Outloop
            mul bx
            add al,[si]
            inc si
    jmp LOOPMain
    Outloop:
    mov si,destination
    mov [si],ax
    ret
convertStrHexaDest endp



validateNumbers proc                             
    mov bx,bx                                               
    loopOverAllStringNumbers:                     
        mov ah,'$'                         
        cmp [bx],ah                        
        jz stringEnd                       
        mov ax,[bx]                        
        mov ah,0                           
        sub ax,'0'                         
        cmp ax,000Fh                       
        jbe validNumber                    
            mov ax,[bx]                    
            mov ah,0                       
            sub ax,'a'                     
            cmp ax,0005h                   
            jbe validNumber                
            mov flagdst,0001h                 
            jmp stringEnd                  
        validNumber:                       
        inc bx                             
    jmp loopOverAllStringNumbers                  
    stringEnd:
    ret                             
validateNumbers endp                                        




end main

