
Hexaaa MACRO string,hexaWord
                LOCAL mainLoop
                LOCAL done
                LOCAL from_zero_nine
                LOCAL finish

                lea   si,string
                lea   di,hexaWord    ;converted string to hexadecimal
  
    mainLoop:   
                mov ax,24h
                cmp   [si],ax       ;check if char is $
                jz    done           ;if ture ==>end
                mov   dl,[si]        ;assci of current char
                converter
                mov [di],dl
                inc si
                inc di
                jmp   mainLoop
        
    done:       
                hlt
                proc  converter 
                mov al,40h
                cmp dl,al
                jbe   from_zero_nine
                sub dl,61h
                add dl,10
                jmp   finish
    from_zero_nine:
                sub dl,30h
    finish:     
                ret
                endp
ENDM    
