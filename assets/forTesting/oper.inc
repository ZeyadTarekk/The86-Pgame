;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Wrote by: Beshoy Morad                                          
;; parameters:                    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

execute macro numofoper,invalidflag,destination,source
LOCAL checkDS,OMOV,OADD,OADC,OSUB,OSBB,OXOR,OAND,ONOP,OCLC,OSHR,OSHL,OROR,OROL,ORCR,ORCL,OINC,ODEC,EXIT
    
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

        jmp EXIT
        
    ;for the add
    OADD:

        jmp EXIT
    
    ;for the adc
    OADC:

        jmp EXIT
        
    ;for the sub
    OSUB:

        jmp EXIT
    
    ;for the sbb
    OSBB:

        jmp EXIT
    
    ;for the xor
    OXOR:

        jmp EXIT
    
    ;for the and
    OAND:

        jmp EXIT
        
    ;for the nop
    ONOP:
        ;this operation do nothing
        jmp EXIT
    
    ;for the shr
    OSHR:

        jmp EXIT

    ;for the shl
    OSHL:

        jmp EXIT


    ;for the clc
    OCLC:
        
        jmp EXIT
    
    ;for the ror
    OROR:

        jmp EXIT

    ;for the rol
    OROL:

        jmp EXIT

    ;for the rcr
    ORCR:

        jmp EXIT

    ;for the rcl
    ORCL:

        jmp EXIT

    ;for the inc
    OINC:

        jmp EXIT

    ;for the dec
    ODEC:


        jmp EXIT

    EXIT:       
endm


