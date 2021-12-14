
convertHexa MACRO string,hexaWord
                LOCAL mainLoop
                LOCAL done
                LOCAL its_digit

                lea   si,string
                lea   di,hexaWord    ;converted string to hexadecimal
                mov   ax,0
  
    mainLoop:   
                cmp   [si],24h       ;check if char is $
                jz    done           ;if ture ==>end
                mov   al,[si]        ;assci of current char
                mov   dl,10h         ;divid by 10 to seperate number
                div   dl
                mov   dl,al          ;cotient
                call  converter      ;convert char to letter or digit
                mov   [di],dl
                inc   di
                mov   dl,ah          ;rest
                call  converter      ;convert char to letter or digit
                mov   [di],dl
                inc   di
                inc   si
                mov   ax,0
                jmp   mainLoop
        
    done:       
                hlt

                proc  converter
                cmp   dl,9
    
                jbe   its_digit
    ;its_a_letter:  IF NO JUMP,
    
                add   dl,55
    
                jmp   finish
    
    its_digit:  
    
                add   dl,48
    
    finish:     
                ret
                endp
ENDM    
