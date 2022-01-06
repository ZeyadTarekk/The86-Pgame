include PUSHPOP.inc
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
SrcStr                db "123$"
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
    call sourceCheck
    mov bx,[source]
    mov ax,[bx]
    hlt
main ENDP

sourceCheck proc  

    call offsetSetter                              
    call lowercaseSRC                                                 
                                                                     
    ; trim spaces => begining and start                              
    call trimSpacesSRC
                                                                     
    mov dx,word ptr SrcStr                                           
                                                                     
    PUSHALL                                                          
    call validateRegisterSRC                    
    mov typeOfSource,0h
    POPALL                                                           
                                                                     
    mov ah,1                                                         
    cmp flag,ah                                                      
    jnz jmpDonesourceCheck                                                      
        jmp continuesourceCheck                                                 
    jmpDonesourceCheck: jmp exitsrcsourceCheck                                             
        continuesourceCheck:                                                    
        mov flag,0ffh
        PUSHALL                                                      
        call validateMemorySrc
        POPALL
        mov ah,1                                                     
        cmp flag,ah                                                  
        jnz jmpFixsourceCheck
        jmp validateRegrDtsourceCheck
            jmpFixsourceCheck: jmp memtsourceCheck
        validateRegrDtsourceCheck:
            mov flag,0ffh
            PUSHALL
            call validateRegisterDirectSource
            POPALL
            mov ah,1                                                                        
            cmp flag,ah                                                                     
            mov typeOfSource,03h
            jmp exitsrcsourceCheck
         memtsourceCheck: call Hexaaa
    exitsrcsourceCheck:                                       
    ret
sourceCheck endp  
lowercaseSRC proc

    lea si,SrcStr     ;poitns to the 1st char of string

    mainLoopSRC:
    mov dh,24h  ;;check if $ or not
    cmp [si],dh

    jz exitLcaseSRC         ;if equal to $ ---> terminate
    mov dh,91       ;;to skip square brackt([)]
    cmp [si],dh
    jz openPractSRC

    mov dh,93
    cmp [si],dh
    jz closePractSRC  ;;to avoid square brcket (])

    mov al,[si]
    mov dh,97       ;;convert to upper to lower case
    cmp al,dh

    or al,32        ;or with ascci in string
    mov [si],al     ; lower character will be placed


    closePractSRC:
    openPractSRC:
    inc si      ;points to the next char

    jmp mainLoopSRC  ;iterate till $

    exitLcaseSRC: ; end if =$
lowercaseSRC endp                                          


trimSpacesSRC proc
    mov bx, offset SrcStr                           
                        
    ;iterate over all string                        
    loopOverAllStringSRC:                              
        ;check end of string                        
        mov ah,' '                                  
        cmp [bx],ah                                 
        jnz notSpaceSRC                                
            mov si,bx                               
            shiftStrSRC:                               
            mov ah,[si+1]                           
            mov [si],ah                             
            mov ah,'$'                              
            cmp [si],ah                             
            jz loopOverAllStringSRC                    
            inc si                                  
            jnz shiftStrSRC                            
    jmp loopOverAllStringSRC                           
    notSpaceSRC:                                       
                                                    
    movBXToEndSRC:                                     
    mov ah,'$'                                      
    cmp [bx],ah                                     
    jz loopOverAllStringEndSRC                         
    inc bx                                          
    jnz movBXToEndSRC                                  
                                                    
    loopOverAllStringEndSRC:                           
        dec bx                                      
        ;check end of string                        
        mov ah,' '                                  
        cmp [bx],ah                                 
        jnz notSpaceENDSRC                             
            mov si,bx                               
            shiftStrENDSRC:                            
            mov ah,[si+1]                           
            mov [si],ah                             
            mov ah,'$'                              
            cmp [si],ah                             
            jz loopOverAllStringEndSRC                 
            inc si                                  
            jnz shiftStrENDSRC                         
    jmp loopOverAllStringEndSRC                        
    notSpaceENDSRC:                                    
    ret
trimSpacesSRC endp                                                                                  ;;



validateRegisterSRC proc 

    mov cx,30   ;;iterate on on 30 byte of Names==> ax bx ..dh dl            
    mov dx,word ptr SrcStr         
    mainLoopVRsrc:                                                                
                                                                             
        mov bx,cx                                                            
        mov ax,Names[bx]   ;;get the register with index bx from end to begin
        cmp ax,dx         ;;compare with input register                  
        jz foundVRsrc                                                             
                                                                             
        dec cx     ;dec cx by 2 ==>1 word                                    
    loop mainLoopVRsrc                                                            
                                                                             
                                                                             
    foundVRsrc:                                                                   
    mov ax,Names  ;ax points to the first reg ('ax')                         
    cmp ax,dx                                                            
                                                                             
    jnz NotFirstVRsrc                                                             
                                                                             
                                                                             
        mov ax,word ptr offsets   ;get first word of offset array            
        mov source,ax                                                        
        jmp exit_vrVRsrc                                                          
                                                                             
                                                                             
    NotFirstVRsrc:                                                                
    mov ax,0    ;check if reach to the  beggining of array or not            
    cmp cx,ax                                                                
    jz notFoundVRsrc                                                              
                                                                             
                                                                             
        mov bx,cx          ;;founded                                         
        mov ax,word ptr offsets[bx]                                          
        mov source,ax                                                        
        jmp exit_vrVRsrc                                                          
                                                                             
    notFoundVRsrc:                                                                
        mov flag,1  ;;set flag to 1 which indicates isNot Found              
                                                                             
    exit_vrVRsrc:       
    ret                                                          
validateRegisterSRC endp                                                                         


validateMemorySrc proc                                             
    mov di,offset SrcStr                                
    mov si,offset SrcStr                                
                                                        
    GoToStringEndVMSRC:                                      
        mov ah,'$'                                      
        cmp [si],ah                                     
        inc si                                          
        mov ah,'$'                                      
        cmp [si],ah                                     
    jnz GoToStringEndVMSRC                                   
    dec si                                              
                                                        
    mov ah,'['                                          
    cmp [di],ah                                         
    jnz compareEndVMSRC                                      
        mov ah,']'                                      
        cmp [si],ah                                     
        jnz notValidSquareVMSRC                              
        jmp WithSquareBracktesVMSRC                          
        compareEndVMSRC:                                     
        mov ah,']'                                      
        cmp [si],ah                                     
        jz notValidSquareVMSRC                               
        jmp noSqaureVMSRC                                    
    notValidSquareVMSRC: mov flag,0001h                      
    jmp exitVmemSrc                                     
    WithSquareBracktesVMSRC:                                 
    mov typeOfSource,01h
    inc di                                              
    mov ah,'$'                                          
    mov [si],ah                                         
    PUSHALL                                             
    call validateNumbersSrc                             
    POPALL                                              
    jmp exitVmemSrc                                     
    noSqaureVMSRC:                                           
    mov typeOfSource,02h
    PUSHALL                                             
    call validateNumbersSrc                             
    POPALL                                              
    exitVmemSrc:                                        
    mov source,di
    ret                                       
validateMemorySrc endp


validateNumbersSrc proc      
    mov bx,di              
    loopOverAllStringNumSRC:         
        mov ah,'$'             
        cmp [bx],ah            
        jz stringEndNumSRC           
        mov ax,[bx]            
        mov ah,0               
        sub ax,'0'             
        cmp ax,000Fh           
        jbe validNumberSRC        
            mov ax,[bx]        
            mov ah,0           
            sub ax,'a'         
            cmp ax,0005h       
            jbe validNumberSRC    
            mov flag,0001h     
            jmp stringEndNumSRC      
        validNumberSRC:           
        inc bx                 
    jmp loopOverAllStringNumSRC      
    stringEndNumSRC:     
    ret            
validateNumbersSrc endp                           
validateRegisterDirectSource proc
    
    mov dx,word ptr SrcStr+1                            
                                                         
    call validateRegisterRDSRC       
                                                         
    mov bx,word ptr SrcStr+1                            
                                                         
    mov ax, 'xb'                                         
    ; if regName == 'BX'                                 
    cmp ax, bx                                           
        jz foundRDSRC                                       
                                                         
    mov ax, 'is'                                         
    ; if regName == 'SI'                                 
    cmp ax, bx                                           
        jz foundRDSRC                                       
                                                         
    mov ax, 'id'                                         
    ; if regName == 'DI'                                 
    cmp ax, bx                                           
        jz foundRDSRC                                       
                                                         
    jmp notFoundRDSRC                                       
    ; if valid register dircet mode [BX],[SI],[DI]       
    foundRDSRC:                                             
        mov di,source                                    
        mov bx,[di]                                      
        mov di,offset source                             
        mov [di],bx                                      
        jmp exit_vrdSRC                                     
    notFoundRDSRC:                                          
        mov flag,01h                                     
    exit_vrdSRC:                                            
    ret
validateRegisterDirectSource endp                                                    

validateRegisterRDSRC proc 

    mov cx,30   ;;iterate on on 30 byte of Names==> ax bx ..dh dl            
    mov dx,word ptr SrcStr+1         
    mainLoopVRsrcRD:                                                                
                                                                             
        mov bx,cx                                                            
        mov ax,Names[bx]   ;;get the register with index bx from end to begin
        cmp ax,dx         ;;compare with input register                  
        jz foundVRsrcRD                                                             
                                                                             
        dec cx     ;dec cx by 2 ==>1 word                                    
    loop mainLoopVRsrcRD                                                            
                                                                             
                                                                             
    foundVRsrcRD:                                                                   
    mov ax,Names  ;ax points to the first reg ('ax')                         
    cmp ax,dx                                                            
                                                                             
    jnz NotFirstVRsrcRD                                                             
                                                                             
                                                                             
        mov ax,word ptr offsets   ;get first word of offset array            
        mov source,ax                                                        
        jmp exit_vrVRsrcRD                                                          
                                                                             
                                                                             
    NotFirstVRsrcRD:                                                                
    mov ax,0    ;check if reach to the  beggining of array or not            
    cmp cx,ax                                                                
    jz notFoundVRsrcRD                                                              
                                                                             
                                                                             
        mov bx,cx          ;;founded                                         
        mov ax,word ptr offsets[bx]                                          
        mov source,ax                                                        
        jmp exit_vrVRsrcRD                                                          
                                                                             
    notFoundVRsrcRD:                                                                
        mov flag,1  ;;set flag to 1 which indicates isNot Found              
                                                                             
    exit_vrVRsrcRD:       
    ret                                                          
validateRegisterRDSRC endp


Hexaaa proc
                                                            ;;
                mov si,source
                ;lea   si,string
                ;lea   di,hexaWord    ;converted string to hexadecimal
    mainLoopHexaSrc:
                mov ah,24h              ;to avoid dbox khara error :3
                cmp   [si],ah       ;check if char is $
                jz    exitHexaHexaSrc           ;if ture ==>end
                mov   dl,[si]        ;assci of current char
                mov ah,40h
                cmp dl,40h          ;compare if digit from 0-9
                jbe   from_zero_nineHexaSrc    ;jump to get hexadecimal of digit
                sub dl,61h  ;  get hexa of  digit (A==>F)
                add dl,10
                jmp   skipHexaSrc  ; jump to skip (0-->9)
    from_zero_nineHexaSrc:
                sub dl,30h
    skipHexaSrc:
                mov [si],dl ; assignment value of dl to string
                inc si   ; points to the next digit
                jmp   mainLoopHexaSrc  ;iterate till  $
    exitHexaHexaSrc:
    mov si,source       ;;conctenate the final answer ==> 01 02 00 0f $as exmaple ==>should be 120f
    mov bx,10h             ;; ax 00 01 => 00 10 => 00  12 => 01 20=> 12 0f
    mov al,[si]
    mov ah,0
    mov cl,'$'

    cmp al,cl
    jz OutloopHexaSrc
    inc si
    LOOPMainHexaSrc:
        mov dl,[si]
        cmp dl,cl
        jz OutloopHexaSrc
            mul bx
            add al,[si]
            inc si
    jmp LOOPMainHexaSrc
    OutloopHexaSrc:
    mov si,source
    mov [si],ax
    ret
Hexaaa endp



;destinationCheck proc 
;    call offsetSetter 
;    call lowercaseDest                              
;                                                    
;    ; trim spaces => begining and start             
;    PUSHALL                                         
;    call trimSpacesDest                             
;    POPALL                                          
;                                                    
;    mov dx,word ptr regName                         
;                                                    
;    PUSHALL                                         
;    call validateRegisterDest
;    mov typeOfDestination,0h                        
;    POPALL                                          
;                                                    
;    mov ah,1                                        
;    cmp flagdst,ah                                  
;    jnz jmpDone                                     
;        jmp continue                                
;    jmpDone: jmp exit_Dest                          
;        continue:                                   
;        mov flagdst,0ffh                            
;        call validateMemoryDest                     
;        mov typeOfDestination,01h                   
;        mov ah,1                                    
;        cmp flagdst,ah                              
;        jnz jmpFix
;        jmp validateRegrDt
;            jmpFix: jmp memt
;        validateRegrDt:
;            ; mov ah,9h
;            ; mov dx,destination
;            ; int 21h
;            mov flagdst,0ffh
;            call validateRegisterDirectDest
;            mov ah,1                                                                        
;            cmp flagdst,ah                                                                     
;            mov typeOfDestination,02h
;            jmp exit_Dest
;         memt: call convertStrHexaDest
;    exit_Dest: 
;    ret 
;destinationCheck endp 




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


trimSpacesDest proc                                                                ;;
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

