include func.inc
.model huge
.stack 64
.data
firstModifiedMSG db 'You Sent a game inivitation to ','$'
secondModifiedMSG db 'You Sent a chatting inivitation to ','$'
thirdModifiedMSG db ' sent you a game invitation to accept press F2 ','$'
fourthModifiedMSG db ' sent you a chatting invitation to accept press F2 ','$'
firstMSG db 'To Start Chatting Press F2','$'
secondMSG db 'To Start The Game Press F3','$'
thirdMSG db 'To End the program press ESC','$'
LINE db '--------------------------------------------------------------------------------','$'
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
    clearScreen
    mov bh,0
    mainScreen2 firstMSG,secondMSG,thirdMSG,selectedMode,LINE,nameOfTheSecondPlayer,carReturn,nameOfTheFirstPlayer,firstModifiedMSG,secondModifiedMSG,thirdModifiedMSG,fourthModifiedMSG


    
    ; getTheName playerName
    ; clearScreen 
    ; clearScreen

    hlt
main ENDP
END main