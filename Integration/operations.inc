;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Wrote by: Beshoy Morad                                          
;; parameters:                    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

execute macro numofoper,invalidflag,destination,source,realDistination,realSource,typeOfDestination,typeOfSource
LOCAL checkDS,OMOV,OADD,OADC,OSUB,OSBB,OXOR,OAND,ONOP,OCLC,OSHR,OSHL,OROR,OROL,ORCR,ORCL,OINC,ODEC,invalid,EXIT,SHRUpper,SHLUpper,SHRCheckSource,SHRCheckDestination,SHLCheckSource,SHLCheckDestination,RORUpper,RORCheckSource,RORCheckDestination,ROLUpper,ROLCheckSource,ROLCheckDestination
    
    ;check if the operation is valid or no
    mov al,invalidflag
    mov dl,1
    cmp al,dl
    jz EXIT
        
    ;compare the code of the operation to go to the block of that command
    mov al,numofoper
    mov dl,1h            
    cmp al,dl            ;code=1 for mov
    jz OMOV
    
    inc dl
    cmp al,dl
    jz OADD              ;code=2 for add
    
    inc dl
    cmp al,dl
    jz OADC              ;code=3 for adc
    
    inc dl
    cmp al,dl
    jz OSUB              ;code=4 for sub
    
    inc dl
    cmp al,dl
    jz OSBB              ;code=5 for sbb
    
    inc dl
    cmp al,dl
    jz OXOR              ;code=6 for xor
        
    inc dl
    cmp al,dl
    jz OAND              ;code=7 for and
        
    inc dl
    cmp al,dl
    jz ONOP              ;code=8 for nop
        
    inc dl
    cmp al,dl
    jz OSHR              ;code=9 for shr

    inc dl
    cmp al,dl
    jz OSHL              ;code=10 for shl

    inc dl
    cmp al,dl
    jz OCLC              ;code=11 for clc
    
    inc dl
    cmp al,dl
    jz OROR              ;code=12 for ror

    inc dl
    cmp al,dl
    jz OROL              ;code=13 for rol

    inc dl
    cmp al,dl
    jz ORCR              ;code=14 for rcr

    inc dl
    cmp al,dl
    jz ORCL              ;code=15 for rcl

    inc dl
    cmp al,dl
    jz OINC              ;code=16 for inc

    inc dl
    cmp al,dl
    jz ODEC              ;code=17 for dec


    
    ;for the mov
    OMOV:
        ;need to check if there is destination and source first
        
        mov di,realSource
        mov bx,realDistination
        mov ax,[di]
        mov [bx],ax
        
        ;check the flag if equal 1 then invalid --> exit
        mov al,invalidflag
        mov dl,1
        cmp al,dl
        jz EXIT
        
        ;else
        ;now we need to check the destination it self if it valid
        
        
        ;if yes check the source
        
        ;if yes get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        jmp EXIT
        
    ;for the add
    OADD:
        ;need to check if there is destination and source first
        jmp checkDS
        
        ;check the flag if equal 1 then invalid --> exit
        mov al,invalidflag
        mov dl,1
        cmp al,dl
        jz EXIT
        
        ;else
        ;now we need to check the destination it self if it valid
        
        
        ;if yes check the source
        
        ;if yes get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        jmp EXIT
    
    ;for the adc
    OADC:
        ;need to check if there is destination and source first
        jmp checkDS
        
        ;check the flag if equal 1 then invalid --> exit
        mov al,invalidflag
        mov dl,1
        cmp al,dl
        jz EXIT
        
        ;else
        ;now we need to check the destination it self if it valid
        
        
        ;if yes check the source
        
        ;if yes get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        jmp EXIT
        
    ;for the sub
    OSUB:
        ;need to check if there is destination and source first
        jmp checkDS
        
        ;check the flag if equal 1 then invalid --> exit
        mov al,invalidflag
        mov dl,1
        cmp al,dl
        jz EXIT
        
        ;else
        ;now we need to check the destination it self if it valid
        
        
        ;if yes check the source
        
        ;if yes get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        jmp EXIT
    
    ;for the sbb
    OSBB:
        ;need to check if there is destination and source first
        jmp checkDS
        
        ;check the flag if equal 1 then invalid --> exit
        mov al,invalidflag
        mov dl,1
        cmp al,dl
        jz EXIT
        
        ;else
        ;now we need to check the destination it self if it valid
        
        
        ;if yes check the source
        
        ;if yes get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        jmp EXIT
    
    ;for the xor
    OXOR:
        ;need to check if there is destination and source first
        jmp checkDS
        
        ;check the flag if equal 1 then invalid --> exit
        mov al,invalidflag
        mov dl,1
        cmp al,dl
        jz EXIT
        
        ;else
        ;now we need to check the destination it self if it valid
        
        
        ;if yes check the source
        
        ;if yes get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        jmp EXIT
    
    ;for the and
    OAND:
        ;need to check if there is destination and source first
        jmp checkDS
        
        ;check the flag if equal 1 then invalid --> exit
        mov al,invalidflag
        mov dl,1
        cmp al,dl
        jz EXIT
        
        ;else
        ;now we need to check the destination it self if it valid
        
        
        ;if yes check the source
        
        ;if yes get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        jmp EXIT
        
    ;for the nop
    ONOP:
        ;need to check that there is no destination and source
        jmp checkDS
        
        ;check the flag if equal 1 then it is valid 
        mov al,invalidflag
        mov dl,1
        cmp al,dl
        jnz EXIT
        
        ;note we need to turn the flag back off
        mov invalidflag,0
        
        ;this operation do nothing
        
        jmp EXIT
    
    ;for the shr
    OSHR:
        mov dh,typeOfSource
        mov bl,0
        cmp dh,bl
        jz SHRCheckSource  ;If the source is register jump and check if cl
        mov bl,2h 
        cmp dh,bl 
        jnz EXIT           ; here if the source is neither register nor immediate (INVALID OPERATION)

        lea bx,source       ; now check if the source is immediate it must equal 1
        mov dl,[bx]
        mov al,1
        cmp al,dl
        jz SHRCheckDestination   ; If the source equal 1 that's good check the destination 
        jnz EXIT                 ; else exit (INVALID OPERATION)


        SHRCheckSource:
        lea bx,source
        mov dl,[bx]
        mov al,'c'  ;Check for first letter to be c (only cl is valid)
        cmp al,dl
        jnz EXIT  (INVALID OPERATION)
        inc bx       ;Move for the second letter
        mov dl,[bx]
        mov al,'l'  ;Check for second letter to be l (only cl is valid)
        cmp al,dl
        jnz EXIT        (INVALID OPERATION)

        SHRCheckDestination:
        ;Check the destination 16 bit or 8 bit 
        lea bx,destination
        inc bx
        mov dl,[bx]
        mov al,'x'
        cmp al,dl
        jz SHRUpper         ;if 16 bit jump to SHRUpper 

        mov di,realSource
        mov bx,realDistination
        mov cl,[di]
        mov ax,[bx]
        shr al,cl               ; here is the difference (work only on byte)
        mov [bx],al
        jmp EXIT

        SHRUpper:
        mov di,realSource
        mov bx,realDistination
        mov cl,[di]
        mov ax,[bx]
        shr ax,cl               ; here is the difference (work on the whole word)
        mov [bx],ax
        jmp EXIT


    ;for the shl
    OSHL:
        mov dh,typeOfSource
        mov bl,0
        cmp dh,bl
        jz SHLCheckSource  ;If the source is register jump and check if cl
        mov bl,2h 
        cmp dh,bl 
        jnz EXIT           ; here if the source is neither register nor immediate(INVALID OPERATION)

        lea bx,source       ; now check if the source is immediate it must equal 1
        mov dl,[bx]
        mov al,1
        cmp al,dl
        jz SHLCheckDestination   ; If the source equal 1 that's good check the destination 
        jnz EXIT                 ; else exit (INVALID OPERATION)


        SHLCheckSource:
        lea bx,source
        mov dl,[bx]
        mov al,'c'  ;Check for first letter to be c (only cl is valid)
        cmp al,dl
        jnz EXIT        ;(INVALID OPERATION)
        inc bx       ;Move for the second letter
        mov dl,[bx]
        mov al,'l'  ;Check for second letter to be l (only cl is valid)
        cmp al,dl
        jnz EXIT        ;(INVALID OPERATION)

        SHLCheckDestination:
        ;Check the destination 16 bit or 8 bit 
        lea bx,destination
        inc bx
        mov dl,[bx]
        mov al,'x'
        cmp al,dl
        jz SHLUpper         ;if 16 bit jump to SHLUpper 

        mov di,realSource
        mov bx,realDistination
        mov cl,[di]
        mov ax,[bx]
        shl al,cl               ; here is the difference (work only on byte)
        mov [bx],al
        jmp EXIT

        SHLUpper:
        mov di,realSource
        mov bx,realDistination
        mov cl,[di]
        mov ax,[bx]
        shl ax,cl               ; here is the difference (work on the whole word)
        mov [bx],ax
        jmp EXIT

    ;for the clc
    OCLC:
        ;need to check that there is no destination and source
        jmp checkDS
        
        ;check the flag if equal 1 then it is valid 
        mov al,invalidflag
        mov dl,1
        cmp al,dl
        jnz EXIT
        
        ;note we need to turn the flag back off
        mov invalidflag,0
        
        ;get the carry variable and set it to zero
        
        
        jmp EXIT
    
    ;for the ror
    OROR:
        mov dh,typeOfSource
        mov bl,0
        cmp dh,bl
        jz RORCheckSource  ;If the source is register jump and check if cl
        mov bl,2h 
        cmp dh,bl 
        jnz EXIT           ; here if the source is neither register nor immediate (INVALID OPERATION)

        lea bx,source       ; now check if the source is immediate it must equal 1
        mov dl,[bx]
        mov al,1
        cmp al,dl
        jz RORCheckDestination   ; If the source equal 1 that's good check the destination 
        jnz EXIT                 ; else exit (INVALID OPERATION)


        RORCheckSource:
        lea bx,source
        mov dl,[bx]
        mov al,'c'  ;Check for first letter to be c (only cl is valid)
        cmp al,dl
        jnz EXIT  (INVALID OPERATION)
        inc bx       ;Move for the second letter
        mov dl,[bx]
        mov al,'l'  ;Check for second letter to be l (only cl is valid)
        cmp al,dl
        jnz EXIT        (INVALID OPERATION)

        RORCheckDestination:
        ;Check the destination 16 bit or 8 bit 
        lea bx,destination
        inc bx
        mov dl,[bx]
        mov al,'x'
        cmp al,dl
        jz RORUpper         ;if 16 bit jump to SHRUpper 

        mov di,realSource
        mov bx,realDistination
        mov cl,[di]
        mov ax,[bx]
        ror al,cl               ; here is the difference (work only on byte)
        mov [bx],al
        jmp EXIT

        RORUpper:
        mov di,realSource
        mov bx,realDistination
        mov cl,[di]
        mov ax,[bx]
        ror ax,cl               ; here is the difference (work on the whole word)
        mov [bx],ax
        jmp EXIT
    ;for the rol
    OROL:
        mov dh,typeOfSource
        mov bl,0
        cmp dh,bl
        jz ROLCheckSource  ;If the source is register jump and check if cl
        mov bl,2h 
        cmp dh,bl 
        jnz EXIT           ; here if the source is neither register nor immediate (INVALID OPERATION)

        lea bx,source       ; now check if the source is immediate it must equal 1
        mov dl,[bx]
        mov al,1
        cmp al,dl
        jz ROLCheckDestination   ; If the source equal 1 that's good check the destination 
        jnz EXIT                 ; else exit (INVALID OPERATION)


        ROLCheckSource:
        lea bx,source
        mov dl,[bx]
        mov al,'c'  ;Check for first letter to be c (only cl is valid)
        cmp al,dl
        jnz EXIT  (INVALID OPERATION)
        inc bx       ;Move for the second letter
        mov dl,[bx]
        mov al,'l'  ;Check for second letter to be l (only cl is valid)
        cmp al,dl
        jnz EXIT        (INVALID OPERATION)

        ROLCheckDestination:
        ;Check the destination 16 bit or 8 bit 
        lea bx,destination
        inc bx
        mov dl,[bx]
        mov al,'x'
        cmp al,dl
        jz ROLUpper         ;if 16 bit jump to SHRUpper 

        mov di,realSource
        mov bx,realDistination
        mov cl,[di]
        mov ax,[bx]
        rol al,cl               ; here is the difference (work only on byte)
        mov [bx],al
        jmp EXIT

        ROLUpper:
        mov di,realSource
        mov bx,realDistination
        mov cl,[di]
        mov ax,[bx]
        rol ax,cl               ; here is the difference (work on the whole word)
        mov [bx],ax
        jmp EXIT
    ;for the rcr
    ORCR:
        ;check the flag if equal 1 then invalid --> exit
        mov al,invalidflag
        mov dl,1
        cmp al,dl
        jz EXIT
        
        ;else
        
        ;if yes get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        jmp EXIT

    ;for the rcl
    ORCL:
        ;check the flag if equal 1 then invalid --> exit
        mov al,invalidflag
        mov dl,1
        cmp al,dl
        jz EXIT
        
        ;else
        
        ;if yes get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        jmp EXIT

    ;for the inc
    OINC:
        ;check the flag if equal 1 then invalid --> exit
        mov al,invalidflag
        mov dl,1
        cmp al,dl
        jz EXIT
        
        ;else
        
        ;if yes get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        jmp EXIT

    ;for the dec
    ODEC:
        ;check the flag if equal 1 then invalid --> exit
        mov al,invalidflag
        mov dl,1
        cmp al,dl
        jz EXIT
        
        ;else
        
        ;if yes get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        jmp EXIT


    checkDS:
    ;check the destination
    mov al,destination
    mov dl,24h         ;check if the first char is $ (no destination)
    cmp al,dl
    jz invalid         ;invalid operation then turn on the flag and exit
        
    mov dl,0DH         ;check if the first char is enter (no destination)
    cmp al,dl
    jz invalid         ;invalid operation then turn on the flag and exit
        
    ;else, there is a destination
    ;now check the source
    mov al,source
    mov dl,24h         ;check if the first char is $ (no source)
    cmp al,dl
    jz invalid         ;invalid operation then turn on the flag and exit
        
    mov dl,0DH         ;check if the first char is enter (no source)
    cmp al,dl
    jz invalid         ;invalid operation then turn on the flag and exit    
    ;else, there is a source
    jmp EXIT
    
    invalid:
        mov invalidflag,1
        jmp EXIT
    EXIT:
           
endm
