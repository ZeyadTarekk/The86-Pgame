

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Written by : - Ziad Sherif  12-12-2021                                              ;;
; parameters : - String                                                               ;;
; return     : -lower Case of String                                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lowercase MACRO text

LOCAL mainLoop
LOCAL openPract
LOCAL closePract
LOCAL done


    lea si,text     ;poitns to the 1st char of string

    mainLoop:
    mov dh,24h  ;;check if $ or not
    cmp [si],dh

    jz done         ;if equal to $ ---> terminate
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

    done: ; end if =$
ENDM                                          
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;