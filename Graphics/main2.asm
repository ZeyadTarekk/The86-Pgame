include func.inc
.model huge
.data
firstMSG db 'To Start Chatting Press F2','$'
secondMSG db 'To Start The Game Press F3','$'
thirdMSG db 'To End the program press any except Except ESC','$'
LINE db '--------------------------------------------------------------------------------','$'
fourthMSG db 'You sent a ','$'
fifthMSG db ' invitation to ','$'
gameMSG db 'game','$'
chatMSG db 'chatting','$'
sixthMSG db ' sent you a ','$'
seventhMSG db ' invitation to accept press F2 ','$'
carReturn db 10,13,'$'
nameOfTheSecondPlayer db 'zeyad','$'
nameOfTheFirstPlayer db 'ahmed','$'
selectedMode db ?    ; 1 for chat,,, 2 for game
myName LABEL BYTE
nameSize db 15
ActualSize db ?
playerName db 15 dup('$')
.code

;description
main PROC
    mov ax,@data
    mov ds,ax
    mov ah, 9
    mov dx, offset seventhMSG
    int 21h
    clearScreen
    mov bh,0
    mainScreen2 firstMSG,secondMSG,thirdMSG,selectedMode,LINE,fourthMSG,gameMSG,chatMSG,fifthMSG,nameOfTheSecondPlayer,carReturn,nameOfTheFirstPlayer,sixthMSG,seventhMSG


    
    ; getTheName playerName
    ; clearScreen 
    ; clearScreen

    hlt
main ENDP
END main