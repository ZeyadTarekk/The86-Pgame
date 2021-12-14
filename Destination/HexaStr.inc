
Hexaaa MACRO string
                LOCAL mainLoop
                LOCAL done
                LOCAL from_zero_nine

                mov si,string
                ;lea   si,string
                ;lea   di,hexaWord    ;converted string to hexadecimal

    mainLoop:
                cmp   [si],24h       ;check if char is $
                jz    done           ;if ture ==>end
                mov   dl,[si]        ;assci of current char
                cmp dl,40h
                jbe   from_zero_nine
                sub dl,61h
                add dl,10
                jmp   finish
    from_zero_nine:
                sub dl,30h
    finish:
                mov [si],dl
                inc si
                ;inc di
                jmp   mainLoop
    done:
ENDM    
