include func.inc
.model huge
.data

myName LABEL BYTE
nameSize db 15
ActualSize db ?
playerName db 15 dup('$')
.code

;description
main PROC
    mov ax,@data
    mov ds,ax

    clearScreen 
    getTheName playerName
    clearScreen

    hlt
main ENDP
END main