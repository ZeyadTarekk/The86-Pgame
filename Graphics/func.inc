clearScreen MACRO
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
ENDM


mainScreen MACRO firstMSG,secondMSG,thirdMSG,selectedMode,LINE,fourthMSG,gameMSG,chatMSG,fifthMSG,nameOfTheSecondPlayer,carReturn,nameOfTheFirstPlayer,sixthMSG,seventhMSG
LOCAL EXITFORMAINSCREEN,setGameMode,setChatMode,DrawChat,AfterDraw,DrawChatSec,AfterDrawSec
    ; first display yhe first message
    mov ah,2
    mov dx,0A18h            ; set the cursor at the middle of the screen nearly
    int 10h

    mov ah, 9
    mov dx, offset firstMSG
    int 21h

    mov ah,2
    mov dx,0C18h    ; for the second message set the position at after the first by two rows
    int 10h 

    mov ah, 9
    mov dx, offset secondMSG
    int 21h

    mov ah,2
    mov dx,0E18h   ; for the third message set the position at after the second by two rows
    int 10h

    mov ah, 9
    mov dx, offset thirdMSG
    int 21h

    ; print the line 
    mov ah,2
    mov dx,1500h
    int 10h

    mov ah, 9
    mov dx, offset LINE
    int 21h



    ; then get the pressed key 
    mov ah,0
    int 16h
    mov al,3Ch      ;if the pressed key is F2 this is chat mode
    cmp ah,al
    jz setChatMode
    mov al,3Dh      ;if the pressed key is F3 this is game mode
    cmp ah,al
    jz setGameMode
    hlt             ; else (ESC or any another key ) hlt the program

    setGameMode:
        mov selectedMode,2
        jmp EXITFORMAINSCREEN
    setChatMode:
        mov selectedMode,1
        jmp EXITFORMAINSCREEN
        
    EXITFORMAINSCREEN:
    ; Here draw the lower part
    mov ah,2
    mov dx,1600h
    int 10h

    mov ah, 9
    mov dx, offset fourthMSG
    int 21h

    mov al,selectedMode
    mov ah,1 
    cmp al,ah 
    jz DrawChat

    mov ah, 9
    mov dx, offset gameMSG
    int 21h
    jmp AfterDraw


    DrawChat:
    mov ah, 9
    mov dx, offset chatMSG
    int 21h
    
    AfterDraw:

    mov ah, 9
    mov dx, offset fifthMSG
    int 21h

    mov ah, 9
    mov dx, offset nameOfTheSecondPlayer
    int 21h

    mov ah, 9
    mov dx, offset carReturn
    int 21h

    mov ah, 9
    mov dx, offset nameOfTheFirstPlayer
    int 21h

    mov ah, 9
    mov dx, offset sixthMSG
    int 21h

    mov al,selectedMode
    mov ah,1 
    cmp al,ah 
    jz DrawChatSec

    mov ah, 9
    mov dx, offset gameMSG
    int 21h
    jmp AfterDrawSec


    DrawChatSec:
    mov ah, 9
    mov dx, offset chatMSG
    int 21h
    
    AfterDrawSec:

    mov ah, 9
    mov dx, offset seventhMSG
    int 21h

ENDM
mainScreen2 MACRO firstMSG,secondMSG,thirdMSG,selectedMode,LINE,fourthMSG,gameMSG,chatMSG,fifthMSG,nameOfTheSecondPlayer,carReturn,nameOfTheFirstPlayer,sixthMSG,seventhMSG
LOCAL EXITFORMAINSCREEN,setGameMode,setChatMode,DrawChat,AfterDraw,DrawChatSec,AfterDrawSec,LoopChar
    ; first display yhe first message
    mov ah,2
    mov dx,0A18h            ; set the cursor at the middle of the screen nearly
    int 10h

    mov ah, 9
    mov dx, offset firstMSG
    int 21h

    mov ah,2
    mov dx,0C18h    ; for the second message set the position at after the first by two rows
    int 10h 

    mov ah, 9
    mov dx, offset secondMSG
    int 21h

    mov ah,2
    mov dx,0E18h   ; for the third message set the position at after the second by two rows
    int 10h

    mov ah, 9
    mov dx, offset thirdMSG
    int 21h

    ; print the line 
    mov ah,2
    mov dx,1500h
    int 10h

    mov ah, 9
    mov dx, offset LINE
    int 21h



    ; then get the pressed key 
    LoopChar:
    mov ah,1
    int 16h
    jz LoopChar   ; zero flag = 1 if no charachter is entered
    mov al,3Ch      ;if the pressed key is F2 this is chat mode
    cmp ah,al
    jz setChatMode
    mov al,3Dh      ;if the pressed key is F3 this is game mode
    cmp ah,al
    jz setGameMode
    hlt             ; else (ESC or any another key ) hlt the program

    setGameMode:
        mov selectedMode,2
        jmp EXITFORMAINSCREEN
    setChatMode:
        mov selectedMode,1
        jmp EXITFORMAINSCREEN
        
    EXITFORMAINSCREEN:
    ; Here draw the lower part
    mov ah,2
    mov dx,1600h
    int 10h

    mov ah, 9
    mov dx, offset fourthMSG
    int 21h

    mov al,selectedMode
    mov ah,1 
    cmp al,ah 
    jz DrawChat

    mov ah, 9
    mov dx, offset gameMSG
    int 21h
    jmp AfterDraw


    DrawChat:
    mov ah, 9
    mov dx, offset chatMSG
    int 21h
    
    AfterDraw:

    mov ah, 9
    mov dx, offset fifthMSG
    int 21h

    mov ah, 9
    mov dx, offset nameOfTheSecondPlayer
    int 21h

    mov ah, 9
    mov dx, offset carReturn
    int 21h

    mov ah, 9
    mov dx, offset nameOfTheFirstPlayer
    int 21h

    mov ah, 9
    mov dx, offset sixthMSG
    int 21h

    mov al,selectedMode
    mov ah,1 
    cmp al,ah 
    jz DrawChatSec

    mov ah, 9
    mov dx, offset gameMSG
    int 21h
    jmp AfterDrawSec


    DrawChatSec:
    mov ah, 9
    mov dx, offset chatMSG
    int 21h
    
    AfterDrawSec:

    mov ah, 9
    mov dx, offset seventhMSG
    int 21h

ENDM


getTheName MACRO name
    mov ah,0AH      
    lea dx,name-2    
    int 21h       
ENDM

; 1) read Name and handel first char    => sherif
; 2) read intial point                  => Hamza
; 3) Decsion screen => f1 f2 esc        => tarek
; 4) Game graphics                      => Beshoy