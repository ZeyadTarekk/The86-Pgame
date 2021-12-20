;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Wrote by: Beshoy Morad                                          
;; parameters:                    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

execute macro numofoper,invalidflag,destination,source,realDistination,realSource,typeOfDestination,typeOfSource
LOCAL OMOV,OMOVJMP,OMOVJMP2
LOCAL OADD,OADDJMP,OADDJMP2
LOCAL OADC,OADCJMP,OADCJMP2
LOCAL OSUB,OSUBJMP,OSUBJMP2
LOCAL OSBB,OSBBJMP,OSBBJMP2
LOCAL OXOR,OXORJMP,OXORJMP2
LOCAL OAND,OANDJMP,OANDJMP2
LOCAL ONOP,ONOPJMP,ONOPJMP2
LOCAL OCLC,OCLCJMP,OCLCJMP2
LOCAL OSHR,OSHRJMP,OSHRJMP2,SHRUpper,SHRCheckSource,SHRCheckDestination
LOCAL OSHL,OSHLJMP,OSHLJMP2,SHLUpper,SHLCheckSource,SHLCheckDestination
LOCAL OROR,ORORJMP,ORORJMP2,RORUpper,RORCheckSource,RORCheckDestination
LOCAL OROL,OROLJMP,OROLJMP2,ROLUpper,ROLCheckSource,ROLCheckDestination
LOCAL ORCR,ORCRJMP,ORCRJMP2,RCRUpper,RCRCheckSource,RCRCheckDestination
LOCAL ORCL,ORCLJMP,ORCLJMP2,RCLUpper,RCLCheckSource,RCLCheckDestination
LOCAL OINC,OINCJMP,OINCJMP2
LOCAL ODEC,ODECJMP,ODECJMP2
LOCAL EXIT
    
    ;check if the operation is valid or no
    mov al,invalidflag
    mov dl,1
    cmp al,dl
    jz EXIT
    
    ;compare the code of the operation to go to the block of that command
    mov al,numofoper
    mov dl,1h            
    cmp al,dl            ;code=1 for mov
    jz OMOVJMP
    jmp OMOVJMP2
        OMOVJMP: jmp OMOV
    OMOVJMP2:

    inc dl
    cmp al,dl            ;code=2 for add            
    jz OADDJMP
    jmp OADDJMP2
        OADDJMP: jmp OADD
    OADDJMP2:

    inc dl
    cmp al,dl            ;code=3 for adc            
    jz OADCJMP
    jmp OADCJMP2
        OADCJMP: jmp OADC
    OADCJMP2:

    inc dl
    cmp al,dl            ;code=4 for sub
    jz OSUBJMP
    jmp OSUBJMP2
        OSUBJMP: jmp OSUB
    OSUBJMP2:

    inc dl
    cmp al,dl
    jz OSBBJMP              ;code=5 for sbb
    jmp OSBBJMP2
        OSBBJMP: jmp OSBB
    OSBBJMP2:

    inc dl
    cmp al,dl               ;code=6 for xor
    jz OXORJMP
    jmp OXORJMP2
        OXORJMP: jmp OXOR
    OXORJMP2:

    inc dl
    cmp al,dl              ;code=7 for and
    jz OANDJMP
    jmp OANDJMP2
        OANDJMP: jmp OAND
    OANDJMP2:

    inc dl
    cmp al,dl              ;code=8 for nop
    jz ONOPJMP
    jmp ONOPJMP2
        ONOPJMP: jmp ONOP
    ONOPJMP2:

    inc dl
    cmp al,dl              ;code=9 for shr
    jz OSHRJMP
    jmp OSHRJMP2
        OSHRJMP: jmp OSHR
    OSHRJMP2:

    inc dl
    cmp al,dl              ;code=10 for shl
    jz OSHLJMP
    jmp OSHLJMP2
        OSHLJMP: jmp OSHL
    OSHLJMP2:

    inc dl
    cmp al,dl              ;code=11 for clc
    jz OCLCJMP
    jmp OCLCJMP2
        OCLCJMP: jmp OCLC
    OCLCJMP2:

    inc dl
    cmp al,dl              ;code=12 for ror
    jz ORORJMP
    jmp ORORJMP2
        ORORJMP: jmp OROR
    ORORJMP2:

    inc dl
    cmp al,dl              ;code=13 for rol
    jz OROLJMP
    jmp OROLJMP2
        OROLJMP: jmp OROL
    OROLJMP2:

    inc dl
    cmp al,dl              ;code=14 for rcr
    jz ORCRJMP
    jmp ORCRJMP2
        ORCRJMP: jmp ORCR
    ORCRJMP2:

    inc dl
    cmp al,dl              ;code=15 for rcl
    jz ORCLJMP
    jmp ORCLJMP2
        ORCLJMP: jmp ORCL
    ORCLJMP2:

    inc dl
    cmp al,dl              ;code=16 for inc
    jz OINCJMP
    jmp OINCJMP2
        OINCJMP: jmp OINC
    OINCJMP2:

    inc dl
    cmp al,dl              ;code=17 for dec
    jz ODECJMP
    jmp ODECJMP2
        ODECJMP: jmp ODEC
    ODECJMP2:

    
    ;for the mov
    OMOV:
        ;get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        mov di,realSource
        mov bx,realDistination
        mov ax,[di]
        mov [bx],ax
        jmp EXIT
        
    ;for the add
    OADD:
        ;get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables


        jmp EXIT
    
    ;for the adc
    OADC:
        ;get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables


        jmp EXIT
        
    ;for the sub
    OSUB:
        ;get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables


        jmp EXIT
    
    ;for the sbb
    OSBB:
        ;get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        
        jmp EXIT
    
    ;for the xor
    OXOR:
        ;get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables
        
        jmp EXIT
    
    ;for the and
    OAND:
        ;get the register from the variables section 
        ;and perform the operation on them
        ;then put the results back to the register variables

        jmp EXIT
        
    ;for the nop
    ONOP:
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
        mov al,1            ; here is 1 not '1' because the source is changed from the ascii to the real value in case of immediate
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
        mov al,1            ; here is 1 not '1' because the source is changed from the ascii to the real value in case of immediate
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
        mov al,1                ; here is 1 not '1' because the source is changed from the ascii to the real value in case of immediate
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
        mov al,1            ; here is 1 not '1' because the source is changed from the ascii to the real value in case of immediate
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
    ; Not handeled yet how to save the carry
    ORCR:
        mov dh,typeOfSource
        mov bl,0
        cmp dh,bl
        jz RCRCheckSource  ;If the source is register jump and check if cl
        mov bl,2h 
        cmp dh,bl 
        jnz EXIT           ; here if the source is neither register nor immediate (INVALID OPERATION)

        lea bx,source       ; now check if the source is immediate it must equal 1
        mov dl,[bx]
        mov al,1            ; here is 1 not '1' because the source is changed from the ascii to the real value in case of immediate
        cmp al,dl
        jz RCRCheckDestination   ; If the source equal 1 that's good check the destination 
        jnz EXIT                 ; else exit (INVALID OPERATION)


        RCRCheckSource:
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

        RCRCheckDestination:
        ;Check the destination 16 bit or 8 bit 
        lea bx,destination
        inc bx
        mov dl,[bx]
        mov al,'x'
        cmp al,dl
        jz RCRUpper         ;if 16 bit jump to SHRUpper 

        mov di,realSource
        mov bx,realDistination
        mov cl,[di]
        mov ax,[bx]
        rcr al,cl               ; here is the difference (work only on byte)
        mov [bx],al
        jmp EXIT

        RCRUpper:
        mov di,realSource
        mov bx,realDistination
        mov cl,[di]
        mov ax,[bx]
        rcr ax,cl               ; here is the difference (work on the whole word)
        mov [bx],ax
        jmp EXIT
    ;for the rcl
    ; Not handeled yet how to save the carry
    ORCL:
        mov dh,typeOfSource
        mov bl,0
        cmp dh,bl
        jz RCLCheckSource  ;If the source is register jump and check if cl
        mov bl,2h 
        cmp dh,bl 
        jnz EXIT           ; here if the source is neither register nor immediate (INVALID OPERATION)

        lea bx,source       ; now check if the source is immediate it must equal 1
        mov dl,[bx]
        mov al,1                ; here is 1 not '1' because the source is changed from the ascii to the real value in case of immediate
        cmp al,dl
        jz RCLCheckDestination   ; If the source equal 1 that's good check the destination 
        jnz EXIT                 ; else exit (INVALID OPERATION)


        RCLCheckSource:
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

        RCLCheckDestination:
        ;Check the destination 16 bit or 8 bit 
        lea bx,destination
        inc bx
        mov dl,[bx]
        mov al,'x'
        cmp al,dl
        jz RCLUpper         ;if 16 bit jump to SHRUpper 

        mov di,realSource
        mov bx,realDistination
        mov cl,[di]
        mov ax,[bx]
        rcl al,cl               ; here is the difference (work only on byte)
        mov [bx],al
        jmp EXIT

        RCLUpper:
        mov di,realSource
        mov bx,realDistination
        mov cl,[di]
        mov ax,[bx]
        rcl ax,cl               ; here is the difference (work on the whole word)
        mov [bx],ax
        jmp EXIT
    ;for the inc
    OINC:
        mov di,realSource   ; to check if it is empty or not to handle it later
        mov bx,realDistination
        ;Here no need to check if the destination is 8 or 16 bits as we only increment is value of the current offset
        mov ax,[bx]  
        inc ax
        mov [bx],ax
        jmp EXIT

    ;for the dec
    ODEC:
        mov di,realSource   ; to check if it is empty or not to handle it later
        mov bx,realDistination
        ;Here no need to check if the destination is 8 or 16 bits as we only increment is value of the current offset
        mov ax,[bx]  
        dec ax
        mov [bx],ax

    EXIT:
endm
