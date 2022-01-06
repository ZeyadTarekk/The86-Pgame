.286
.model huge
.stack 64
.data

;dimensions of the screen
row dw 0
col dw 0

firstPointX db 3d

;position of my registers
myAXx db 3h
myAXy db 3h
myBXx db 3h
myBXy db 4h
myCXx db 3h
myCXy db 6h
myDXx db 3h
myDXy db 7h
mySIx db 0Bh
mySIy db 3h
myDIx db 0Bh
myDIy db 4h
mySPx db 0Bh
mySPy db 6h
myBPx db 0Bh
myBPy db 7h
;position of my memory
myMemx db 10h
;other's register positions
otherAXx db 18h
otherAXy db 3h
otherBXx db 18h
otherBXy db 4h
otherCXx db 18h
otherCXy db 6h
otherDXx db 18h
otherDXy db 7h
otherSIx db 20h
otherSIy db 3h
otherDIx db 20h
otherDIy db 4h
otherSPx db 20h
otherSPy db 6h
otherBPx db 20h
otherBPy db 7h
;position of other memory
otherMemx db 24h

; colors
WHITE EQU 0FH
RED EQU 0CH
YELLOW EQU 0EH
BLACK EQU 0H
GRAY EQU 7H
LBLUE EQU 9H
DBLUE EQU 1H
PURPLE EQU 0DH
LGREEN EQU 0AH
DGREEN EQU 2H
CYAN EQU 3H

;data for the char to draw (x,y,char,color)
charToDraw db ?
charToDrawColor db ?
charToDrawx db ?
charToDrawy db ?

myNameL LABEL BYTE
myNameSize db 15
myNameActualSize db ?
myName db 15 dup('$')

otherNameL LABEL BYTE
otherNameSize db 15
otherNameActualSize db ?
otherName db 15 dup('$')

; message to winner of the game
firstWin db ' is the  winner with score  ','$'
;flag to know that there is a winner     (1 --> my)  (2 --> other)
winnerFlag db 0
; ESC winner
ESCWinnerMSGTitle db "END GAME$"
ESCWinnerMSG db " got score $"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Main Screen;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
firstModifiedMSG db 'You Sent a game inivitation to ','$'
secondModifiedMSG db 'You Sent a chatting inivitation to ','$'
thirdModifiedMSG db ' sent you a game invitation to accept press F2 ','$'
fourthModifiedMSG db ' sent you a chatting invitation to accept press F1 ','$'
firstMSG db 'To Start Chatting Press F1','$'
secondMSG db 'To Start The Game Press F2','$'
thirdMSG db 'To End the program press ESC','$'
LINE db '--------------------------------------------------------------------------------','$'
carReturn db 10,13,'$'
selectedMode db ?    ; 1 for chat ---- 2 for game

;flag to know if the current user is the one who started the chat or the game
;0 --> the other started
;1 --> i started
starterMainScreenFlag db ?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Get Forbidden char;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; level window data
getLevelMSG db "Please enter the level (1-2): $"

; forbiden character window data
getForbiddenMSGWindow db "Please enter forbidden character: $"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Level 2 Registers;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AXmsg db 'AX = $'
BXmsg db 'BX = $'
CXmsg db 'CX = $'
DXmsg db 'DX = $'
SImsg db 'SI = $'
DImsg db 'DI = $'
SPmsg db 'SP = $'
BPmsg db 'BP = $'
Donemsg db 'Registers Done!$'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Wanted Value Variables;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wantedValue dw 105Eh        ; number not string to compare it with other
newWantedValueMessage db 'Wanted Value:$'

;if set to 1 this player used it before
flagChangeWantedValue db 0

newWantedValueL LABEL BYTE
newWantedValueSize db 5
newWantedValueActualSize db ?
newWantedValue db 6 dup('$')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Command Variables;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 0 my turn execute on other registers
; 1 his turn execute on my registers
flagTurn db 0


choiceMessage db '0->yours 1->other$'

myCommandL LABEL BYTE
myCommandSize db 15
myCommandActualSize db ?
myCommand db 15 dup('$')

otherCommandL LABEL BYTE
otherCommandSize db 15
otherCommandActualSize db ?
; otherCommandActualSize db 8
otherCommand db 15 dup('$')
; otherCommand db 'ADC BX,6$'

clearBGC db '                  $'

Names             dw 'xa','xb','xc','xd','is','id','pb','ps','la','ha','lb','hb','lc','hc','ld','hd'
offsets           dw 16 dup(00)
flagdst           db 0h                    ;flag for wrong destination
flag              db 0h                    ;flag for wrong source
;type of source and destination and the final offset of them
typeOfDestination db 0fh
destination       dw 0000h
typeOfSource      db 0fh
source            dw 0000h
;our memory variable
offsetMemory      dw ?
;our carry
carry             db 0
;the chosen level
level db 2
;after getting the command we need to separate it into 3 parts
ourOperation          db 4 dup('$')
regName               db 5 dup('$')
SrcStr                db 5 dup('$')
;our forbidden char
forbiddenChar   db ?  ; my  the other player enters it
myforbiddenChar   db ?  ; my  the other player enters it
otherforbiddenChar   db ?   ; other   i enter it
getForbiddenMsg db 'New Forbidden: $'
;forbidden flag to know that he entered forbidden char
forbiddenFlag     db 0            ;equal 1 when the player use that char
;forbidden flag to know if the user used the power up
forbiddenPowerUpFlag db 0         ;equal 1 when the player use the power up
;the possible operations for the player to use
operations  db 'mov','add','adc','sub','sbb','xor','and','nop','shr','shl','clc','ror','rol','rcr','rcl','inc','dec','/'
;codes for the operation
;1=mov, 2=add, 3=adc, 4=sub, 5=sbb, 6=xor, 7=and, 8=nop, 9=shr, 10=shl, 11=clc, 12=ror, 13=rol, 14=rcr, 15=rcl, 16=inc, 17=dec
CodeOfOperation     db ?
;flags for invalid command
invalidOperationFlag  db 0     ;equal 1 when the operation is wrong
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Get name & initial points;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
endl db  10,13 ,'$'
StringToPrint db 'Please enter your Name: ','$'

intialPointSize    db 5                    
intialPointActualSize db ?                    
initalPointStr      db 6 dup ('$')
STRIP           db 'Please enter your Intial Point: ','$'                    

intialPointSizeother    db 5                    
intialPointActualSizeother db ?                    
initalPointStrother      db 6 dup ('$')

myPointsValue db 14h
otherPointsValue db 14h
myPointsX db ?
otherPointsX db ?
pointsY db 0dh
;global variable for printing line (x)
linex dw ?
liney dw ?
;the values of hitted balls with a given color
;                 1     2       3     4       5
                ;Blue, green , Cyan, red , Magenta 
coloredPoints db  0h ,   0h  ,  0h ,  0h ,  0h

;flag to know which operation to perform
ReadyFlag db ?

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;variables for postioning
printX db ?
printY db ?

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Registers variables;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;my registers data needed
;dummy variable to help printing
RegStringToPrint db 4 dup(?)
MemStringToPring db 2 dup(?)
ASC_TBL DB   '0','1','2','3','4','5','6','7','8','9'
        DB   'A','B','C','D','E','F'

;flag to know where to run the command
; 0 --> execute on other Registers 
; 1 --> execute on my Registers 
whichRegisterToExecute db 0
flagSecondPowerUp db 0
;                 AX,    BX,    CX,    DX,    SI,    DI,    BP,   SP
myRegisters dw 0000H, 0000h, 0000h, 0000h, 0000h, 0000h, 0000h, 0000h
;                 AX,    BX,    CX,    DX,    SI,    DI,    BP,   SP
otherRegisters dw 0000h, 0000h, 0000h, 0000h, 0000h, 0000h, 0000h, 0000h

clearAllRegPowerUp db 0
clearAllRegMsg db 'Registers Cleared$'
myMemory db 16 dup(00h)
otherMemory db 16 dup(00h)

firstMessage db 'Hello from first$'
secondMessage db 'Hello from second$'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Gun Variables;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GUNLoopIterator dw 0
; Variables for Gun
;iterators for draw gun
; gun starts at row 80d 
rowGun dw 80d
colGun dw 20d
; gun start row and end  row are constants
gunEndRowPosition EQU 90d
; gun start column is variable
; This variable changes the position of my gun
gunStartColumnPosition dw 70d 
gunWidth EQU 20d
;Other Variables for Gun
;iterators for draw gun
; gun start column is variable
; This variable changes the position of Other gun
gunStartColumnPositionOther dw 200d

rowTarget dw 0d
colTarget dw 20d
; target start row and end  row are constants
targetEndRowPosition EQU 7d
; target start column is variable
; This variable changes the position of my target
targetStartColumnPosition dw 115d 
targetWidth EQU 10d
; gun start column is variable
; This variable changes the position of Other target
targetStartColumnPositionOther dw 277d
targetColor db 1 ; this is considered also as the score

rowBullet dw 80d                    ; iterator for row of bullet always starts at 80d
colBullet dw 20d                    ; iterator for columns of bullet
; target start row and end  row are constants
bulletStartRowPosition dw 85d          ; changes and it equals start row + bullet height
bulletStartRowPositionOther dw 85d          ; changes and it equals start row + bullet height
bulletEndRowPosition dw 5d          ; changes and it equals start row + bullet height
bulletEndRowPositionOther dw 5d          ; changes and it equals start row + bullet height
; target start column is variable   
; This variable changes the position of my target
bulletStartColumnPosition dw 10d    ; equals to midpoint of gun
bulletEndColumnPosition dw 10d
bulletWidth EQU 5d
; gun start column is variable
; This variable changes the position of Other target
bulletStartColumnPositionOther dw 200d
bulletEndColumnPositionOther dw 200d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;flag to know when to exit the game
exitGame db 0

.code
main proc
  mov ax,@data
  mov ds,ax
  mov es,ax

  call Portinitialization
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Names and Points;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  call GetNameAndIntialP
  call SendingAndRecevingNames
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Main Screen;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  MainScreenLoop:
  mov ah,0h
  mov al,3h
  int 10h
  call clearScreen
  call mainScreen
  mov al,selectedMode
  mov dl,2
  cmp al,dl
  jz StartGame
  mov dl,0
  cmp al,dl
  jz ProgramExit
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Chat Section;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  StartChat:

  jmp MainScreenLoop
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Game;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  StartGame:
  ;check if the current user is the one who start the game
  mov al,starterMainScreenFlag
  mov dl,1
  cmp al,dl
  jnz IamNotTheStarter
  call levelWindow
  IamNotTheStarter:
  ;get the forbidden char
  call myforbiddenWindow
  call getMyIntialPoints

  call SendingAndRecevingFCIP

  mov al,starterMainScreenFlag
  mov dl,1
  cmp al,dl
  jnz WillNotRecieveLvl
  call sendLevel
  jmp ContinueAfterLevel

  WillNotRecieveLvl:
  call recieveLevel
  ContinueAfterLevel:
  call calcInitialPoints
  ;set video mode   (320x200)
  mov ah,0h
  mov al,13h
  int 10h 

  call drawBackGround
  ;draw the register and its intial values
  call drawRegNames
  call drawMyRegisters
  call drawOtherRegisters
  ;draw the memory and its intial values
  call drawMemoryAdresses
  call drawMemoryLines
  call drawMyMemory
  call drawOtherMemory

  call printTwoNames
  call printPoints
  call printCommands
  call printWantedValue
  call printTwoMessage
  call printTwoPoints
  call level2Intial
  call printForbiddenChar
  ;for the main loop,   note: outside the loop called one time
  ;get out of the loop when (myPointsValue or otherPointsValue) = 0
  ;get out of the loop when (any register value = wantedValue)
  GameLoop:
  call getKeyPressed

  ;check if the exit game flag = 1
  mov al,exitGame
  mov dl,1
  cmp al,dl
  jz OutOfGame

  ;update the screen
  call drawRegNames
  call drawMyRegisters
  call drawOtherRegisters

  call drawMyMemory
  call drawOtherMemory

  call printTwoPoints
  call printPoints

  call checkWinner
  ;check the winner flag
  mov al,winnerFlag
  mov dl,1
  cmp al,dl
  jz HaveAWinner
  mov dl,2
  cmp al,dl
  jz HaveAWinner


  jmp GameLoop

  OutOfGame:
  call ESCWinnerScreen
  mov exitGame,0
  call clearTheGame
  jmp MainScreenLoop

  HaveAWinner:
  call WinnerScreen
  mov winnerFlag,0
  mov exitGame,0
  call clearTheGame
  jmp MainScreenLoop
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ProgramExit:
  call clearScreen
  hlt
main endp



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Communication;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Portinitialization proc
  ;Set Divisor Latch Access Bit
  mov dx,3fbh 			  ; Line Control Register
  mov al,10000000b		;Set Divisor Latch Access Bit
  out dx,al
  ;Set LSB byte of the Baud Rate Divisor Latch register.
  mov dx,3f8h			
  mov al,0ch
  out dx,al
  ;Set MSB byte of the Baud Rate Divisor Latch register.
  mov dx,3f9h
  mov al,00h
  out dx,al
  ;Set port configuration
  mov dx,3fbh
  mov al,00011011b
  out dx,al
  ret
Portinitialization endp
SendingAndRecevingNames proc
  ;who finish first send the other (DD --> will start sending his name first)
  ;check if the other sent (DD)
  ;{ send (DF) which means that we are ready to receive and call receive function } 
  ;else send him (DD)
  
  ;check if the other sent any thing
  mov dx , 3FDH		; Line Status Register
  in al , dx 
  AND al , 1
  jz sendReady
  mov dx , 03F8H
  in al , dx 
  mov ReadyFlag,al

  ;send DF to start receiving the other name
  mov dx , 3FDH   ;Line Status Register
  SDFAGAIN: 
  In al,dx        ;Read Line Status
  AND al,00100000b
  JZ SDFAGAIN
  mov dx , 3F8H   ;Transmit data register
  mov al,0DFH
  out dx,al

  call receiveOtherName

  ;send DD to start sending your name
  mov dx , 3FDH   ;Line Status Register
  SDDAGAIN: 
  In al,dx        ;Read Line Status
  AND al,00100000b
  JZ SDDAGAIN
  mov dx , 3F8H   ;Transmit data register
  mov al,0DDH
  out dx,al

  mov dx , 3FDH		; Line Status Register
	WAITDFCHK:	
  in al , dx 
  AND al , 1
  JZ WAITDFCHK
  mov dx , 03F8H
  in al , dx 
  mov ReadyFlag,al

  call sendMyName
  jmp readyFlagEnd

  sendReady:
  ;then send DD if no thing to receive
  mov dx , 3FDH   ;Line Status Register
  SRFAGAIN: 
  In al,dx        ;Read Line Status
  AND al,00100000b
  JZ SRFAGAIN
  mov dx , 3F8H   ;Transmit data register
  mov al,0DDH
  out dx,al

  mov dx , 3FDH		; Line Status Register
	WAITDFCHK2:	
  in al , dx 
  AND al , 1
  JZ WAITDFCHK2
  mov dx , 03F8H
  in al , dx 
  mov ReadyFlag,al

  call sendMyName

  mov dx , 3FDH		; Line Status Register
	WAITDDCHK:	
  in al , dx 
  AND al , 1
  JZ WAITDDCHK
  mov dx , 03F8H
  in al , dx 
  mov ReadyFlag,al

  ;send DF to start receiving the other name
  mov dx , 3FDH   ;Line Status Register
  SDFAGAIN2: 
  In al,dx        ;Read Line Status
  AND al,00100000b
  JZ SDFAGAIN2
  mov dx , 3F8H   ;Transmit data register
  mov al,0DFH
  out dx,al

  call receiveOtherName

  readyFlagEnd:
  ret
SendingAndRecevingNames endp
sendMyName proc
  ;send the actualSize
  mov dx , 3FDH   ;Line Status Register
  SACNAGAIN: 
  In al,dx        ;Read Line Status
  AND al,00100000b
  JZ SACNAGAIN
  mov dx , 3F8H   ;Transmit data register
  mov al,myNameActualSize
  out dx,al
  ;loop to send the entire name
  mov ch,0
  mov cl,myNameActualSize
  lea si,myName
  MyNameSendLoop:
  mov dx,3FDH   ;Line Status Register
  SMNAGAIN: 
  In al,dx        ;Read Line Status
  AND al,00100000b
  JZ SMNAGAIN
  mov dx , 3F8H   ;Transmit data register
  mov al,[si]
  out dx,al 
  inc si
  loop MyNameSendLoop
  ret
sendMyName endp
receiveOtherName proc
  ;receive the actual size of the otherName
  mov dx,3FDH		; Line Status Register
	RONACCHK:	
  in al,dx 
  AND al,1
  JZ RONACCHK

  mov dx,03F8H
  in al,dx 
  mov otherNameActualSize,al

  mov ch,0
  mov cl,otherNameActualSize
  lea si,otherName
  otherNameReceiveLoop:
  mov dx,3FDH		; Line Status Register
	RONCHK:	
  in al,dx 
  AND al,1
  JZ RONCHK

  mov dx,03F8H
  in al,dx 
  mov [si],al
  inc si
  loop otherNameReceiveLoop
  ret
receiveOtherName endp

SendingAndRecevingFCIP proc
  ;who finish first send the other (DD --> will start sending his name first)
  ;check if the other sent (DD)
  ;{ send (DF) which means that we are ready to receive and call receive function } 
  ;else send him (DD)
  
  ;check if the other sent any thing
  mov dx , 3FDH		; Line Status Register
  in al , dx 
  AND al , 1
  jz sendReadyFCIP
  mov dx , 03F8H
  in al , dx 
  mov ReadyFlag,al

  ;send DF to start receiving the forbidden char and intial points
  mov dx , 3FDH   ;Line Status Register
  SFCIPAGAIN: 
  In al,dx        ;Read Line Status
  AND al,00100000b
  JZ SFCIPAGAIN
  mov dx , 3F8H   ;Transmit data register
  mov al,0DFH
  out dx,al

  call receiveForbiddenChar
  call receiveIntialPoints

  ;send DD to start sending your forbidden char and intial point
  mov dx , 3FDH   ;Line Status Register
  SDDFCIPAGAIN: 
  In al,dx        ;Read Line Status
  AND al,00100000b
  JZ SDDFCIPAGAIN
  mov dx , 3F8H   ;Transmit data register
  mov al,0DDH
  out dx,al

  mov dx , 3FDH		; Line Status Register
	WAITDFFCIPCHK:	
  in al , dx 
  AND al , 1
  JZ WAITDFFCIPCHK
  mov dx , 03F8H
  in al , dx 
  mov ReadyFlag,al

  call sendForbiddenChar
  call sendIntialPoints
  jmp readyFlagEndFCIP

  sendReadyFCIP:
  ;then send DD if no thing to receive
  mov dx , 3FDH   ;Line Status Register
  SRFAGAINFCIP: 
  In al,dx        ;Read Line Status
  AND al,00100000b
  JZ SRFAGAINFCIP
  mov dx , 3F8H   ;Transmit data register
  mov al,0DDH
  out dx,al

  mov dx , 3FDH		; Line Status Register
	WAITDFFCIPCHK2:	
  in al , dx 
  AND al , 1
  JZ WAITDFFCIPCHK2
  mov dx , 03F8H
  in al , dx 
  mov ReadyFlag,al

  call sendForbiddenChar
  call sendIntialPoints

  mov dx , 3FDH		; Line Status Register
	WAITDDCHKFCIP:	
  in al , dx 
  AND al , 1
  JZ WAITDDCHKFCIP
  mov dx , 03F8H
  in al , dx 
  mov ReadyFlag,al

  ;send DF to start receiving the other name
  mov dx , 3FDH   ;Line Status Register
  SDFAGAINFCIP2: 
  In al,dx        ;Read Line Status
  AND al,00100000b
  JZ SDFAGAINFCIP2
  mov dx , 3F8H   ;Transmit data register
  mov al,0DFH
  out dx,al

  call receiveForbiddenChar
  call receiveIntialPoints

  readyFlagEndFCIP:
  ret
SendingAndRecevingFCIP endp
sendForbiddenChar proc
  ;send my forbidden char
  mov dx , 3FDH   ;Line Status Register
  SFCAGAIN: 
  In al,dx        ;Read Line Status
  AND al,00100000b
  JZ SFCAGAIN
  mov dx , 3F8H   ;Transmit data register
  mov al,otherforbiddenChar
  out dx,al
  ret
sendForbiddenChar endp
sendIntialPoints proc
  ;send my inital value
  mov dx , 3FDH   ;Line Status Register
  SIPAGAIN: 
  In al,dx        ;Read Line Status
  AND al,00100000b
  JZ SIPAGAIN
  mov dx , 3F8H   ;Transmit data register
  mov al,myPointsValue
  out dx,al
  ret
sendIntialPoints endp
receiveForbiddenChar proc
  ;receive the forbidden char
  mov dx,3FDH		; Line Status Register
	RFCCHK:	
  in al,dx 
  AND al,1
  JZ RFCCHK

  mov dx,03F8H
  in al,dx 
  mov myforbiddenChar,al
  ret
receiveForbiddenChar endp
receiveIntialPoints proc
  ;receive the intial point
  mov dx,3FDH		; Line Status Register
	RIPCHK:	
  in al,dx 
  AND al,1
  JZ RIPCHK

  mov dx,03F8H
  in al,dx 
  mov otherPointsValue,al
  ret
receiveIntialPoints endp

sendLevel proc
  ;send the level
  mov dx , 3FDH   ;Line Status Register
  SLVLAGAIN: 
  In al,dx        ;Read Line Status
  AND al,00100000b
  JZ SLVLAGAIN
  mov dx , 3F8H   ;Transmit data register
  mov al,level
  out dx,al
  ret
sendLevel endp
recieveLevel proc
  ;receive the level
  mov dx,3FDH		; Line Status Register
	RLVLCHK:	
  in al,dx 
  AND al,1
  JZ RLVLCHK

  mov dx,03F8H
  in al,dx 
  mov level,al
  ret
recieveLevel endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Main Screen;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clearScreen proc
  mov ax,0600h
  mov bh,07
  mov cx,0
  mov dx,184FH
  int 10h
  mov bh,0
  ret
clearScreen endp
mainScreen proc
  ; first display yhe first message
  mov ah,2
  mov dl,18h            ; set the cursor at the middle of the screen nearly
  mov dh,8d
  int 10h

  mov ah, 9
  mov dx, offset firstMSG
  int 21h

  mov ah,2
  mov dl,18h    ; for the second message set the position at after the first by two rows
  mov dh,10d
  int 10h 

  mov ah, 9
  mov dx, offset secondMSG
  int 21h

  mov ah,2
  mov dl,18h   ; for the third message set the position at after the second by two rows
  mov dh,12d
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
  ;check if the other send any thing
  ;f1 --> show on your screen that the other invites you to chat
  ;f2 --> show on your screen that the other invites you to play
  ;esc --> set the selected mode and exit

  mov dx , 3FDH		; Line Status Register
	in al , dx 
  AND al , 1
  jz GetCurrentUserKey
  ;the other user sent a char
  mov starterMainScreenFlag,0
  mov dx , 03F8H
  in al , dx
  ;al = char

  ; mov dl,3Bh    ;F1
  ; cmp al,dl
  ; mov selectedMode,1
  ; jz EXITFORMAINSCREEN

  mov dl,3Ch      ;F2
  cmp al,dl
  mov selectedMode,2
  jz EXITFORMAINSCREEN

  mov dl,01h      ;ESC
  cmp al,dl
  mov selectedMode,0
  jz EXITFORMAINSCREEN

  GetCurrentUserKey:
  ;main loop
  mov ah,1
  int 16h
  jz LoopChar       ; zero flag = 1 if no charachter is entered
  mov al,3Bh        ;if the pressed key is F1 this is chat mode
  cmp ah,al
  jz setChatMode
  mov al,3Ch        ;if the pressed key is F2 this is game mode
  cmp ah,al
  jz setGameMode
  mov al,1          ; check if ESC 
  cmp al,ah 
  jnz ClearBuffer   ; if not ESC Clear buffer and wait for more chars
  mov ah,0          ;Clear the buffer
  int 16h
  mov selectedMode,0 ;  (ESC) hlt the program
  mov starterMainScreenFlag,1
  jmp EXITFORMAINSCREEN
  ClearBuffer:
  mov ah,0          ;Clear the buffer
  int 16h
  jmp LoopChar

  setGameMode:
      mov selectedMode,2
      mov ah,0        ;Clear the buffer
      int 16h
      ;send F2 to the other
      mov starterMainScreenFlag,1
      mov dx , 3FDH		; Line Status Register
      SENDF2AGAIN:  	
      In al , dx 			;Read Line Status
      AND al , 00100000b
      JZ SENDF2AGAIN
      mov dx,3F8H		; Transmit data register
      mov al,3Ch
      out dx,al 
      jmp EXITFORMAINSCREEN

  setChatMode:
      mov selectedMode,1
      mov ah,0        ;Clear the buffer
      int 16h
      jmp EXITFORMAINSCREEN
      
  EXITFORMAINSCREEN:
  ; Here draw the lower part
  mov ah,2
  mov bh,0
  mov dx,1600h
  int 10h

  mov al,selectedMode
  mov ah,1 
  cmp al,ah 
  jz DrawChat
  mov ah,0
  cmp al,ah
  jz sendExit

  ;F2
  ;check who started to print his message
  mov al,starterMainScreenFlag
  mov dl,1
  cmp al,dl
  jnz otherSentMeG

  mov ah, 9
  mov dx, offset firstModifiedMSG
  int 21h
  mov ah, 9
  lea dx,otherName
  int 21h
  
  ;loop to wait for the response of the other user
  mov dx,3FDH		; Line Status Register
	F2FromOtherCHK:	
  in al,dx
  AND al,1
  JZ F2FromOtherCHK
  mov dx , 03F8H
  in al,dx 
  mov ReadyFlag,al
  jmp AfterDrawExit

  otherSentMeG:
  mov ah, 9
  lea dx,otherName
  int 21h
  mov ah, 9
  mov dx, offset thirdModifiedMSG
  int 21h
  ;loop to wait for F2 to continue
  NotF2:
  mov ah,0
  int 16h
  mov dl,3CH
  cmp ah,dl
  jnz NotF2
  mov dx , 3FDH		; Line Status Register
  SendF2AGAINGame:  	
  In al , dx 			;Read Line Status
  AND al , 00100000b
  JZ SendF2AGAINGame
  mov dx , 3F8H		; Transmit data register
  mov al,3CH
  out dx , al
  jmp AfterDrawExit


  DrawChat:
  ;F1

  
  jmp AfterDrawExit

  sendExit:
  ;ESC
  ;check who started
  mov al,starterMainScreenFlag
  mov dl,1
  cmp al,dl
  jnz AfterDrawExit

  ;send him esc(01h)
  mov dx , 3FDH		; Line Status Register
  SendESCAGAIN:  	
  In al , dx 			;Read Line Status
  AND al , 00100000b
  JZ SendESCAGAIN
  mov dx , 3F8H		; Transmit data register
  mov  al,01h
  out dx , al 
  jmp AfterDrawExit

  AfterDrawExit:
  ret
mainScreen endp
WinnerScreen proc
  mov  ah,0  ;move to winner Screen
  mov  al,3h 
  int  10h

  mov ah,2
  mov dl,20d
  mov dh,10d
  mov bh,0
  int 10h
  mov cl,winnerFlag
  cmp cl,1
  jz IamWinner
  ; display name of other player 
  mov ah, 9
  mov dx, offset otherName
  int 21h
  ;display meesage 
  mov ah,9
  lea dx,firstWin
  int 21h
  ;display score of the other player
  mov ax,0
  mov al,otherPointsValue
  call print3Decimal
  jmp exitPage2

  IamWinner:
  ;display player 1 name
  mov ah, 9
  mov dx, offset myName
  int 21h
  ;display meesage 
  mov ah,9
  lea dx,firstWin
  int 21h
  ;display score of the first player
  mov ax,0
  mov al,myPointsValue
  call print3Decimal
  exitPage2:

  ; delay 5 seconds
  mov bx,5
  DELAYWINNER:
  MOV CX, 0FH
  MOV DX, 4240H
  MOV AH, 86H
  INT 15H
  dec bx
  jnz DELAYWINNER
  ; return to video mode
  mov ah, 00h
  mov al, 13h
  int 10h 

  ret
WinnerScreen endp
checkWinner proc
  mov ax,wantedValue
  ;check all of my registers
  lea bx,myRegisters
  mov cx,8h
  checkMyRegWinner:
  mov dx,[bx]
  cmp ax,dx
  jz SetWinnerFlag2
  add bx,2
  loop checkMyRegWinner

  ;check all of other registers
  lea bx,otherRegisters
  mov cx,8h
  checkOtherRegWinner:
  mov dx,[bx]
  cmp ax,dx
  jz SetWinnerFlag1
  add bx,2
  loop checkOtherRegWinner

  mov al,0
  mov dl,myPointsValue
  cmp al,dl 
  jz SetWinnerFlag2

  mov dl,otherPointsValue
  cmp al,dl 
  jz SetWinnerFlag1

  jmp checkWinnerExit
  ;he is the winner
  SetWinnerFlag2:
  mov winnerFlag,2
  jmp checkWinnerExit

  ;i am the winner
  SetWinnerFlag1:
  mov winnerFlag,1
  checkWinnerExit:
  ret
checkWinner endp
clearTheGame proc
  ;clear all the registers
  mov cx,8h
  lea bx,myRegisters
  lea di,otherRegisters
  clearTheGameReg:
  mov [bx],0000H
  mov [di],0000H
  add bx,2
  add di,2
  loop clearTheGameReg

  ;clear all the memory
  mov cx,16d
  lea bx,myMemory
  lea di,otherMemory
  clearTheGameMem:
  mov [bx],00H
  mov [di],00H
  inc bx
  inc di
  loop clearTheGameMem

  ;clear the colored points
  mov coloredPoints,00h
  mov coloredPoints+1,00h
  mov coloredPoints+2,00h
  mov coloredPoints+3,00h
  mov coloredPoints+4,00h
  ;return the wanted value to its intial
  mov wantedValue,105Eh
  ;return the change wanted value flag power up 
  mov flagChangeWantedValue,0
  ;return the forbidden flag power up
  mov forbiddenPowerUpFlag,0
  ;return the clear register flag power up
  mov clearAllRegPowerUp,0
  ;clear the carry
  mov carry,0
  ;clear the forbidden char
  mov forbiddenChar,' '
  ret
clearTheGame endp
ESCWinnerScreen proc
  ;text mode
  mov  ah,0  
  mov  al,3h 
  int  10h

  ; set cursor
  mov ah,2
  mov dl,33d
  mov dh,5d
  mov bh,0
  int 10h
  ; display player 1 name
  mov ah, 9
  mov dx, offset ESCWinnerMSGTitle
  int 21h

  ; set cursor
  mov ah,2
  mov dl,25d
  mov dh,10d
  mov bh,0
  int 10h
  ; display player 1 name
  mov ah, 9
  mov dx, offset myName
  int 21h
  ; display message
  mov ah, 9
  mov dx, offset ESCWinnerMSG
  int 21h

  mov ax,0
  mov al,myPointsValue
  call print3Decimal
  
  ; set cursor
  mov ah,2
  mov dl,25d
  mov dh,12d
  mov bh,0
  int 10h
  ; display player 1 name
  mov ah, 9
  mov dx, offset otherName
  int 21h
  ; display message
  mov ah, 9
  mov dx, offset ESCWinnerMSG
  int 21h

  mov ax,0
  mov al,otherPointsValue
  call print3Decimal

  mov bx,5
  DELAYESCWINNER:
  MOV CX, 0FH
  MOV DX, 4240H
  MOV AH, 86H
  INT 15H
  dec bx
  jnz DELAYESCWINNER
  
  ret
ESCWinnerScreen endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Level Window;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
levelWindow PROC
    ;text mode
    mov  ah,0  
    mov  al,3h 
    int  10h
    ; set cursor
    mov ah,2
    mov dl,20d
    mov dh,10d
    mov bh,0
    int 10h
    ; display message
    mov ah, 9
    mov dx, offset getLevelMSG
    int 21h
    ;read one character => level
    mov ah,07
    int 21h
    ; print the character
    mov ah,2
    mov dl,al
    int 21h
    ;convert to number
    sub al,30h
    mov level,al

    ; delay one second
    MOV     CX, 0FH
    MOV     DX, 4240H
    MOV     AH, 86H
    INT     15H
    ret
levelWindow ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;forbidden Window;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
otherforbiddenWindow PROC  ; other player enters it
    ;text mode
    mov  ah,0  
    mov  al,3h 
    int  10h
    ; set cursor
    mov ah,2
    mov dl,20d
    mov dh,10d
    mov bh,0
    int 10h
    ; display message
    mov ah, 9
    mov dx, offset getForbiddenMSGWindow
    int 21h
    ;read one character => level
    mov ah,07
    int 21h
    ; print the character
    mov ah,2
    mov dl,al
    int 21h
    ;convert to number
    mov myforbiddenChar,al

    ; delay one second
    MOV     CX, 0FH
    MOV     DX, 4240H
    MOV     AH, 86H
    INT     15H
    ret
otherforbiddenWindow ENDP

myforbiddenWindow PROC  ; i enter it
    ;text mode
    mov  ah,0  
    mov  al,3h 
    int  10h
    ; set cursor
    mov ah,2
    mov dl,20d
    mov dh,10d
    mov bh,0
    int 10h
    ; display message
    mov ah, 9
    mov dx, offset getForbiddenMSGWindow
    int 21h
    ;read one character => level
    mov ah,07
    int 21h
    ; print the character
    mov ah,2
    mov dl,al
    int 21h
    ;convert to number
    mov otherforbiddenChar,al

    ; delay one second
    MOV     CX, 0FH
    MOV     DX, 4240H
    MOV     AH, 86H
    INT     15H
    ret
myforbiddenWindow ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Level 2 Intialization;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
level2Intial proc
  ;check for the level
  ;clear the command section and print a certain register for the user to enter
  ;take the string and convert it to word
  ;place the string in myRegisters

  mov al,level
  mov dl,1
  cmp al,dl
  jz level2IntialExit

  ;get ax value
  call clearCommandSection
  ;print register name
  mov ah,9
  lea dx,AXmsg
  int 21h

  mov ah,0AH
  mov dx,offset newWantedValueL
  int 21h

  call WantedValueToNumber
  mov ax,word ptr newWantedValue
  mov myRegisters,ax
  call clearInputLabel
  call drawMyRegisters

  ;get bx value
  call clearCommandSection
  ;print register name
  mov ah,9
  lea dx,BXmsg
  int 21h

  mov ah,0AH
  mov dx,offset newWantedValueL
  int 21h

  call WantedValueToNumber
  mov ax,word ptr newWantedValue 
  mov myRegisters+2,ax
  call clearInputLabel
  call drawMyRegisters

  ;get cx value
  call clearCommandSection
  ;print register name
  mov ah,9
  lea dx,CXmsg
  int 21h

  mov ah,0AH
  mov dx,offset newWantedValueL
  int 21h

  call WantedValueToNumber
  mov ax,word ptr newWantedValue 
  mov myRegisters+4,ax
  call clearInputLabel
  call drawMyRegisters

  ;get dx value
  call clearCommandSection
  ;print register name
  mov ah,9
  lea dx,DXmsg
  int 21h

  mov ah,0AH
  mov dx,offset newWantedValueL
  int 21h

  call WantedValueToNumber
  mov ax,word ptr newWantedValue 
  mov myRegisters+6,ax
  call clearInputLabel
  call drawMyRegisters

  ;get si value
  call clearCommandSection
  ;print register name
  mov ah,9
  lea dx,SImsg
  int 21h

  mov ah,0AH
  mov dx,offset newWantedValueL
  int 21h

  call WantedValueToNumber
  mov ax,word ptr newWantedValue 
  mov myRegisters+8,ax
  call clearInputLabel
  call drawMyRegisters

  ;get di value
  call clearCommandSection
  ;print register name
  mov ah,9
  lea dx,DImsg
  int 21h

  mov ah,0AH
  mov dx,offset newWantedValueL
  int 21h

  call WantedValueToNumber
  mov ax,word ptr newWantedValue 
  mov myRegisters+10d,ax
  call clearInputLabel
  call drawMyRegisters

  ;get sp value
  call clearCommandSection
  ;print register name
  mov ah,9
  lea dx,SPmsg
  int 21h

  mov ah,0AH
  mov dx,offset newWantedValueL
  int 21h

  call WantedValueToNumber
  mov ax,word ptr newWantedValue 
  mov myRegisters+14d,ax
  call clearInputLabel
  call drawMyRegisters

  ;get bp value
  call clearCommandSection
  ;print register name
  mov ah,9
  lea dx,BPmsg
  int 21h

  mov ah,0AH
  mov dx,offset newWantedValueL
  int 21h

  call WantedValueToNumber
  mov ax,word ptr newWantedValue 
  mov myRegisters+12d,ax
  call clearInputLabel
  call drawMyRegisters
  call clearCommandSection

  mov ah,9
  lea dx,Donemsg
  int 21h
  
  level2IntialExit:
  ret
level2Intial endp
clearCommandSection proc
  ;set the cursor
  mov ah,2
  mov dl,2h
  mov dh,11h
  mov bh,0
  int 10h
  call clearBGcommand
  ;set the cursor
  mov ah,2
  mov dl,2h
  mov dh,11h
  mov bh,0
  int 10h
  ret
clearCommandSection endp

clearOtherCommandSection proc
  ;set the cursor
  mov ah,2
  mov dl,16h
  mov dh,11h 
  mov bh,0
  int 10h
  call clearBGcommand
  ;set the cursor
  mov ah,2
  mov dl,16h
  mov dh,11h 
  mov bh,0
  int 10h
  ret
clearOtherCommandSection endp

clearInputLabel proc
  lea di,newWantedValue
  ClearInputAgain:
  mov al,[di]
  mov dl,'$'
  cmp al,dl
  jz ClearInputfinish
  mov [di],dl
  inc di
  jmp ClearInputAgain
  ClearInputfinish:
  mov newWantedValueActualSize,0
  ret
clearInputLabel endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Names and Points;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetNameAndIntialP proc
  GNPmainLoop:
    mov bx,0
    mov ah,2 
    mov dl,20d
    mov dh,7d
    int 10h
    call clearScreen         
    mov ah,9
    lea dx,StringToPrint   
    int 21h 
    
    mov ah,0AH      
    lea dx,myName-2    
    int 21h

    lea si,myName

    mov al,'Z'
    cmp [si],al ;check if between A,Z
    jbe LAZ
    
    mov al,'z'
    cmp [si],al     ;check if between a,z
    jbe Lza
    
    LAZ:
    mov al,'A'
    cmp [si],al
    jae GNPexit
    jmp GNPmainLoop

    Lza:
    mov al,'a'
    cmp [si],al
    jae GNPexit
    jmp GNPmainLoop
    
    GNPexit:

    ;convert the (enter) char to $
    lea si,myName
    mov al,0dh
    ConvertEnterName:
    inc si
    mov bl,[si]
    cmp bl,al 
    jnz ConvertEnterName
    mov [si],24h

    mov bx,0
    mov ah,2 
    mov dl,20d
    mov dh,9d
    int 10h

    mov ah,9
    lea dx,STRIP   
    int 21h 

    mov ah,1
    int 21h
    ;al=first digit
    sub al,30h
    mov bl,100
    mul bl
    mov cx,ax
    
    mov ah,1
    int 21h
    ;al=second digit
    sub al,30h
    mov bl,10
    mul bl
    add cx,ax
    
    mov ah,1
    int 21h
    ;al=third digit
    sub al,30h
    mov ah,0
    add cx,ax
    
    mov myPointsValue,cl

    ;delay one second
    MOV CX, 0FH
    MOV DX, 4240H
    MOV AH, 86H
    INT 15H
    ret
GetNameAndIntialP endp
GetNameAndIntialPother proc
  GNPmainLoopother:
    mov bx,0
    mov ah,2 
    mov dl,20d
    mov dh,7d
    int 10h
    call clearScreen         
    mov ah,9
    lea dx,StringToPrint   
    int 21h 
      
    mov ah,0AH      
    lea dx,otherName-2    
    int 21h

    lea si,otherName

    mov al,'Z'
    cmp [si],al ;check if between A,Z
    jbe LAZother
    
    mov al,'z'
    cmp [si],al     ;check if between a,z
    jbe Lzaother
    
    LAZother:
    mov al,'A'
    cmp [si],al
    jae GNPexitother
    jmp GNPmainLoopother

    Lzaother:
    mov al,'a'
    cmp [si],al
    jae GNPexitother
    jmp GNPmainLoopother
    
    GNPexitother:

    ;convert the (enter) char to $
    lea si,otherName
    mov al,0dh
    ConvertEnterNameother:
    inc si
    mov bl,[si]
    cmp bl,al 
    jnz ConvertEnterNameother
    mov [si],24h

    mov bx,0
    mov ah,2 
    mov dl,20d
    mov dh,9d
    int 10h

    mov ah,9
    lea dx,STRIP   
    int 21h 

    mov ah,1
    int 21h
    ;al=first digit
    sub al,30h
    mov bl,100
    mul bl
    mov cx,ax
    
    mov ah,1
    int 21h
    ;al=second digit
    sub al,30h
    mov bl,10
    mul bl
    add cx,ax
    
    mov ah,1
    int 21h
    ;al=third digit
    sub al,30h
    mov ah,0
    add cx,ax
    
    mov otherPointsValue,cl

    ;delay one second
    MOV CX, 0FH
    MOV DX, 4240H
    MOV AH, 86H
    INT 15H
    ret
GetNameAndIntialPother endp

getMyIntialPoints proc
  call clearScreen 
  mov bx,0
  mov ah,2 
  mov dl,20d
  mov dh,10d
  int 10h
  mov ah,9
  lea dx,STRIP
  int 21h 

  mov ah,1
  int 21h
  ;al=first digit
  sub al,30h
  mov bl,100
  mul bl
  mov cx,ax
  
  mov ah,1
  int 21h
  ;al=second digit
  sub al,30h
  mov bl,10
  mul bl
  add cx,ax
  
  mov ah,1
  int 21h
  ;al=third digit
  sub al,30h
  mov ah,0
  add cx,ax
  
  mov myPointsValue,cl

  ;delay one second
  MOV CX, 0FH
  MOV DX, 4240H
  MOV AH, 86H
  INT 15H
  ret
getMyIntialPoints endp
getOtherIntialPoints proc
  call clearScreen 
  mov bx,0
  mov ah,2 
  mov dl,20d
  mov dh,10d
  int 10h
  mov ah,9
  lea dx,STRIP
  int 21h 

  mov ah,1
  int 21h
  ;al=first digit
  sub al,30h
  mov bl,100
  mul bl
  mov cx,ax
  
  mov ah,1
  int 21h
  ;al=second digit
  sub al,30h
  mov bl,10
  mul bl
  add cx,ax
  
  mov ah,1
  int 21h
  ;al=third digit
  sub al,30h
  mov ah,0
  add cx,ax
  
  mov otherPointsValue,cl

  ;delay one second
  MOV CX, 0FH
  MOV DX, 4240H
  MOV AH, 86H
  INT 15H
  ret
getOtherIntialPoints endp

calcInitialPoints proc 
mov al,myPointsValue
mov dl,otherPointsValue
cmp al,dl 
ja myPointsLarger
mov otherPointsValue,al
jmp calcInitialPointsExit

myPointsLarger:
mov myPointsValue,dl

calcInitialPointsExit:
ret
calcInitialPoints endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Keys handling;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;get the key pressed
;F1 ---> chat    (scan code: 3Bh)
;F2 ---> get the command   (scan code: 3Ch)
;F3 ---> enter the gun game  (scan code: 3Dh)
;F4 ---> exit the main loop and get back to main screen (scan code: 3Eh)
;    PowerUps
;1 ---> Executing a command on your own processor + get the command after this (5 points)
;2 ---> Executing a command on your processor and your opponent processor at the same time + get the command after this (3 points)
;3 ---> Changing the forbidden character only once (8 points) + turn on a flag
;4 ---> Clearing all registers at once (30 points) + turn on a flag
;5 ---> (for level 2) change the target value + turn on a flag
getKeyPressed proc
  
  call RANDNUMBER
  mov dh,05d          ; if random number equals 5 
  cmp dh,dl           
  jz GKPgunGame       ;start the gun game cycle

  ;first check if there is any key pressed
  mov ah,1
  int 16h
  jz keyPressedExit

  ;ley pressed --> get that key ah=scan code
  mov ah,0
  int 16h

  mov dl,3Bh          ;F1
  cmp ah,dl
  jz GKPchat          ;start the chat cycle

  mov dl,3Ch          ;F2
  cmp ah,dl
  jz GKPcommand       ;start the command cycle

  ; mov dl,3Dh          ;F3
  ; cmp ah,dl
  ; jz GKPgunGame       ;start the gun game cycle

  mov dl,31h          ;1
  cmp al,dl
  jz GKPfirst         ;execute the first power up

  mov dl,32h          ;2
  cmp al,dl
  jz GKPsec           ;execute the second power up

  mov dl,33h          ;3
  cmp al,dl
  jz GKPthird         ;execute the third power up

  mov dl,34h          ;4
  cmp al,dl
  jz GKPforth         ;execute the forth power up

  mov dl,35h          ;5
  cmp al,dl
  jz levelTwoPowerUp         ;execute the forth power up

  mov dl,3Eh          ;F4 pressed
  cmp ah,dl
  jz GKPexitGame      ;exit the game and show static screen with scores
  jmp keyPressedExit

  GKPfirst:
  call firstPowerUp
  ;toggle the turn
  mov al,flagTurn
  mov dl,0
  cmp al,dl 
  jnz setFlagTurnZeroFiPU
  mov flagTurn,1
  jmp keyPressedExit
  setFlagTurnZeroFiPU:
  mov flagTurn,0
  jmp keyPressedExit

  GKPsec:
  ;check the turn to update the forbidden key
  mov al,flagTurn
  mov dl,0
  cmp al,dl
  jnz SPUForbiddenCheck
  mov al,myforbiddenChar
  mov forbiddenChar,al
  jmp SPUForbiddenDone
  SPUForbiddenCheck:
  mov al,otherforbiddenChar
  mov forbiddenChar,al
  SPUForbiddenDone:

  call printForbiddenChar
  call secondPowerUp
  ;toggle the turn
  mov al,flagTurn
  mov dl,0
  cmp al,dl 
  jnz setFlagTurnZeroSPU
  mov flagTurn,1
  jmp keyPressedExit
  setFlagTurnZeroSPU:
  mov flagTurn,0
  jmp keyPressedExit

  GKPthird:
  call thirdPowerUp
  jmp keyPressedExit

  GKPforth:
  call forthPowerUp
  jmp keyPressedExit

  levelTwoPowerUp:
  call changeWantedValue
  jmp keyPressedExit

  GKPcommand:
  mov al,level
  mov dl,1
  cmp al,dl
  jnz level2CommandCheck
  ;Here is level 1
  mov al,flagTurn
  mov dl,0
  cmp al,dl 
  jnz myRegistersExecute

  mov whichRegisterToExecute,0    ; execute on his registers
  mov al,myforbiddenChar
  mov forbiddenChar,al 
  jmp AfterSettingRegistersExecute

  myRegistersExecute:    ;execute on my registers
  mov whichRegisterToExecute,1
  mov al,otherforbiddenChar
  mov forbiddenChar,al 
  jmp AfterSettingRegistersExecute
  level2CommandCheck:
  ; Here is level 2
  call Level2ChooseWhichRegister

  AfterSettingRegistersExecute:
  call printForbiddenChar
  call commandCyle
  call ClearCommand
  call printCommands

  mov al,flagTurn
  mov dl,0
  cmp al,dl 
  jnz setFlagTurnZeroCommand
  mov flagTurn,1
  jmp keyPressedExit

  setFlagTurnZeroCommand:
  mov flagTurn,0

  jmp keyPressedExit

  GKPchat:
  ; call chatCycle
  jmp keyPressedExit

  GKPgunGame:
  call runGun
  call drawMemoryLines
  jmp keyPressedExit

  GKPexitGame:
  mov exitGame,1
  keyPressedExit:
  ret
getKeyPressed endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Run Gun;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; generate random number between [0:50]
RANDNUMBER proc
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 10000d    
   div  cx       ; here dx contains the remainder of the division - from 0 to 9

  ;  add  dl, '0'  ; to ascii from '0' to '9'
  ;  mov ah, 2h   ; call interrupt to display a value in DL
  ;  int 21h    
RET
RANDNUMBER endp 
runGun proc
  mov GUNLoopIterator, 0
  runGunHome:
  inc GUNLoopIterator
  call drawRegNames
  call drawMyRegisters
  call drawOtherRegisters
  call printTwoPoints
  call printPoints
  ;get the key pressed to move the gun
  mov ah,1 ; check if key is clicked
  int 16h  ; do not wait for a key-AH:scancode,AL:ASCII)
  jz NoClickedKey  ; if no button is clicked DontRead it

  mov ah,0 ; read the pressed key
  int 16h  ; Get key pressed (Wait for a key-AH:scancode,AL:ASCII)

  mov dl,1        ; check if ESC 
  cmp dl,ah
  jz gunGameExit

  continueToMoveOrFire:
  mov cl, 20h  ; ascii of space
  cmp cl, al   ; compare clicked key with space
  jz ForceFireMyBullet 
  
  mov cl, 04Dh ; scan code of right arrow
  cmp cl, ah   ; compare clicked key with right arrow
  jz movGunRight

  mov cl, 04Bh ; Scan code of left arrow
  cmp cl, ah   ; compare clicked key with left arrow
  jz movGunLeft

  mov cl, 31d  ; scan of s
  cmp cl, ah   ; compare clicked key with s
  jz ForceFireOtherBullet 
  
  mov cl, 32d ; scan code of d
  cmp cl, ah   ; compare clicked key with d
  jz movOtherGunRight

  mov cl, 30d ; Scan code of a
  cmp cl, ah   ; compare clicked key with a
  jz movOtherGunLeft
  
  jmp runGunHome     ; if not pressed left or right arrow loop again
  
  NoClickedKey:
    ; if no key click try to fire bullets
    jmp fire
  movGunRight:
    mov bx,85d                    ; if bullet is not at its start position stop moving the Gun
    mov ax, bulletStartRowPosition
    cmp ax, bx
    jz ContinueToMoveRight
    jmp fire
    ContinueToMoveRight:
    ;Move the gun
    mov dx, gunStartColumnPosition ; check if gun reached end of screen
    add dx, gunWidth               ; add gun width to gun start position 
    mov cx, 125d                   ; 125d is the position of the first line
    cmp dx, cx                     ; compare position of first line to end of gun
    jz gunMoved                    ; if equal consider the gun has been moved (dont move the gun)
    
    inc gunStartColumnPosition     ; increament gun position => move to right
    
    jmp gunMoved

  movGunLeft:
    mov bx,85d                     ; if bullet is not at its start position stop moving the Gun
    mov ax, bulletStartRowPosition
    cmp ax, bx
    jz ContinueToMoveLeft
    jmp fire
    ContinueToMoveLeft:
    ; Move the Gun
    mov dx, gunStartColumnPosition ; check if gun reached start of screen
    mov cx, 0d                     ; 0d is the start of the screen
    cmp dx, cx                     ; compare position of screen start to start of gun
    jz gunMoved                    ; if equal consider the gun has been moved (dont move the gun)
    
    dec gunStartColumnPosition     ; decreament gun position => move to left 
    jmp gunMoved
  gunMoved:
  jmp continuePlaying
  


  movOtherGunRight:
    mov bx,85d                    ; if bullet is not at its start position stop moving the Gun
    mov ax, bulletStartRowPositionOther
    cmp ax, bx
    jz ContinueToMoveOtherRight
    jmp fire
    ContinueToMoveOtherRight:
    ;Move the gun
    mov dx, gunStartColumnPositionOther ; check if gun reached end of screen
    add dx, gunWidth                    ; add gun width to gun start position 
    mov cx, 287d                        ; 125d is the position of the first line
    cmp dx, cx                          ; compare position of first line to end of gun
    jz OthergunMoved                         ; if equal consider the gun has been moved (dont move the gun)
      inc gunStartColumnPositionOther     ; increament gun position => move to right
    
    jmp OthergunMoved
  
  movOtherGunLeft:
    mov bx,85d                     ; if bullet is not at its start position stop moving the Gun
    mov ax, bulletStartRowPositionOther
    cmp ax, bx
    jz ContinueToMoveOtherLeft
    jmp fire
    ContinueToMoveOtherLeft:
    ; Move the Gun
    mov dx, gunStartColumnPositionOther ; check if gun reached start of screen
    mov cx, 163d                     ; 0d is the start of the screen
    cmp dx, cx                     ; compare position of screen start to start of gun
    jz OthergunMoved                    ; if equal consider the gun has been moved (dont move the gun)
    
    dec gunStartColumnPositionOther     ; decreament gun position => move to left 
    jmp OthergunMoved

  OthergunMoved:
    jmp continuePlaying


    fire:
    ;Check if my bullet is not fired
    mov bx,85d
    mov ax, bulletStartRowPosition
    cmp ax, bx
    jz checkOtherBullet
    ForceFireMyBullet:
    call drawBullet 
    dec bulletStartRowPosition       ;decreament bullet position (move up)
    mov ax, bulletStartRowPosition   ;if width of bullet is more than position of 
    mov bx, bulletWidth              ;its lower border break;
    cmp ax,bx
    jae checkOtherBullet
      mov bulletStartRowPosition, 85d  ; return bullet to its start position

    checkOtherBullet:
    mov bx,85d
    mov ax, bulletStartRowPositionOther
    cmp ax, bx
    jz continuePlaying
    ForceFireOtherBullet:
    call drawBullet 
    dec bulletStartRowPositionOther       ;decreament bullet position (move up)
    mov ax, bulletStartRowPositionOther   ;if width of bullet is more than position of 
    mov bx, bulletWidth                   ;its lower border break;
    cmp ax,bx
    jae continuePlaying
    mov bulletStartRowPositionOther, 85d  ; return bullet to its start position
  
  
  continuePlaying:
  call drawGun
  
  call drawTarget
  dec targetStartColumnPosition       ;decreament bullet position (move up)
;   mov ax, targetStartColumnPosition   ;if width of bullet is more than position of 
;   mov bx, 0                           ;its lower border break;
;   cmp ax,bx
;   jnz continueMovingTarget
;     mov targetStartColumnPosition, 115d  ; return bullet to its start position
;   continueMovingTarget:

  ; Move other Target
  call drawGun
  
  call drawTarget
  dec targetStartColumnPositionOther       ;decreament bullet position (move up)
  mov ax, targetStartColumnPositionOther   ;if width of bullet is more than position of 
  mov bx, 162d                             ;its lower border break;
  cmp ax,bx
  jnz continueMovingTargetOther
    mov targetStartColumnPositionOther, 277d  ; return bullet to its start position
    mov targetStartColumnPosition, 115d  ; return bullet to its start position
    ;change the target color
    inc targetColor
    mov ah,6
    mov bh,targetColor
    cmp bh,ah
    jnz continueMovingTargetOther
      mov targetColor, 1
  continueMovingTargetOther:

  mov ax, bulletStartRowPosition
  add ax, bulletWidth
  mov cx, targetWidth
  cmp ax, cx
  ja helpJmpEndCompare
      jmp continueToCompare
    helpJmpEndCompare: jmp CheckIfOtherHits
  continueToCompare:
  
  ; Check if my bullet hits the my target
  mov ax, bulletStartColumnPosition
  mov cx, bulletEndColumnPosition

  mov bx, targetStartColumnPosition
  mov dx, targetStartColumnPosition
  add dx, targetWidth
  
  cmp ax,bx
  jb case2
    cmp cx, dx    ;case1 
    ja case2
      ; compare with dark Blue
      mov al, 1
      cmp al, targetColor
      jz increamentBlue1
      ; compare with green
      mov al, 2
      cmp al, targetColor
      jz increamentGreen1
      ; compare with Cyan
      mov al, 3
      cmp al, targetColor
      jz increamentCyan1
      ; compare with Red
      mov al, 4
      cmp al, targetColor
      jz increamentRed1
      ; compare with Magenta
      mov al, 5
      cmp al, targetColor
      jz increamentMagenta1

      increamentBlue1:
        inc coloredPoints
        jmp ENDINCCOLORS1
      increamentGreen1:
        inc coloredPoints[1]
        jmp ENDINCCOLORS1
      increamentCyan1:
        inc coloredPoints[2]
        jmp ENDINCCOLORS1
      increamentRed1:
        inc coloredPoints[3]
        jmp ENDINCCOLORS1
      increamentMagenta1:
        inc coloredPoints[4]
        jmp ENDINCCOLORS1
      ENDINCCOLORS1:

      mov targetStartColumnPosition, 115d
      mov targetStartColumnPositionOther, 277d
      mov al,targetColor ; ax = 0 targetColor
      mov ah,0           
      add myPointsValue,al ; add target color to my score the color is considered as score
      ;change the target color
      inc targetColor
      mov ah,6
      mov bh,targetColor
      cmp bh,ah
      jnz EndCompare
        mov targetColor, 1
      jmp EndCompare 
  case2:
  cmp cx, bx
  jb case3
      cmp ax,bx
      ja case3
      ; compare with dark Blue
      mov al, 1
      cmp al, targetColor
      jz increamentBlue2
      ; compare with green
      mov al, 2
      cmp al, targetColor
      jz increamentGreen2
      ; compare with Cyan
      mov al, 3
      cmp al, targetColor
      jz increamentCyan2
      ; compare with Red
      mov al, 4
      cmp al, targetColor
      jz increamentRed2
      ; compare with Magenta
      mov al, 5
      cmp al, targetColor
      jz increamentMagenta2

      increamentBlue2:
        inc coloredPoints
        jmp ENDINCCOLORS2
      increamentGreen2:
        inc coloredPoints[1]
        jmp ENDINCCOLORS2
      increamentCyan2:
        inc coloredPoints[2]
        jmp ENDINCCOLORS2
      increamentRed2:
        inc coloredPoints[3]
        jmp ENDINCCOLORS2
      increamentMagenta2:
        inc coloredPoints[4]
        jmp ENDINCCOLORS2
      ENDINCCOLORS2:

      mov targetStartColumnPosition, 115d
      mov targetStartColumnPositionOther, 277d
      mov al,targetColor ; ax = 0 targetColor
      mov ah,0           
      add myPointsValue,al ; add target color to my score the color is considered as score
      ;change the target color
      inc targetColor
      mov ah,6
      mov bh,targetColor
      cmp bh,ah
      jnz EndCompare
        mov targetColor, 1
        jmp EndCompare
  case3:
  cmp ax,dx
  ja CheckIfOtherHits
      cmp cx,dx
      jb CheckIfOtherHits
      ; compare with dark Blue
      mov al, 1
      cmp al, targetColor
      jz increamentBlue3
      ; compare with green
      mov al, 2
      cmp al, targetColor
      jz increamentGreen3
      ; compare with Cyan
      mov al, 3
      cmp al, targetColor
      jz increamentCyan3
      ; compare with Red
      mov al, 4
      cmp al, targetColor
      jz increamentRed3
      ; compare with Magenta
      mov al, 5
      cmp al, targetColor
      jz increamentMagenta3

      increamentBlue3:
        inc coloredPoints
        jmp ENDINCCOLORS3
      increamentGreen3:
        inc coloredPoints[1]
        jmp ENDINCCOLORS3
      increamentCyan3:
        inc coloredPoints[2]
        jmp ENDINCCOLORS3
      increamentRed3:
        inc coloredPoints[3]
        jmp ENDINCCOLORS3
      increamentMagenta3:
        inc coloredPoints[4]
        jmp ENDINCCOLORS3
      ENDINCCOLORS3:
      mov targetStartColumnPosition, 115d
      mov targetStartColumnPositionOther, 277d
      mov al,targetColor ; ax = 0 targetColor
      mov ah,0           
      add myPointsValue,al ; add target color to my score the color is considered as score
      ;change the target color
      inc targetColor
      mov ah,6
      mov bh,targetColor
      cmp bh,ah
      jnz EndCompare
        mov targetColor, 1
        jmp EndCompare
    
    CheckIfOtherHits:
    ; check if other bullet hits other target
      mov ax, bulletStartRowPositionOther
  add ax, bulletWidth
  mov cx, targetWidth
  cmp ax, cx
  ja helpJmpEndCompareOther
      jmp continueToCompareOther
    helpJmpEndCompareOther: jmp EndCompare
  continueToCompareOther:
  
  ; Check if my bullet hits the my target
  mov ax, bulletStartColumnPositionOther
  mov cx, bulletEndColumnPositionOther

  mov bx, targetStartColumnPositionOther
  mov dx, targetStartColumnPositionOther
  add dx, targetWidth
  
  cmp ax,bx
  jb case2Other
    cmp cx, dx    ;case1 
    ja case2Other
      ; compare with dark Blue
      mov al, 1
      cmp al, targetColor
      jz increamentBlueOther1
      ; compare with green
      mov al, 2
      cmp al, targetColor
      jz increamentGreenOther1
      ; compare with Cyan
      mov al, 3
      cmp al, targetColor
      jz increamentCyanOther1
      ; compare with Red
      mov al, 4
      cmp al, targetColor
      jz increamentRedOther1
      ; compare with Magenta
      mov al, 5
      cmp al, targetColor
      jz increamentMagentaOther1

      increamentBlueOther1:
        ; inc coloredPoints
        jmp ENDINCCOLORSOther1
      increamentGreenOther1:
        ; inc coloredPoints[1]
        jmp ENDINCCOLORSOther1
      increamentCyanOther1:
        ; inc coloredPoints[2]
        jmp ENDINCCOLORSOther1
      increamentRedOther1:
        ; inc coloredPoints[3]
        jmp ENDINCCOLORSOther1
      increamentMagentaOther1:
        ; inc coloredPoints[4]
        jmp ENDINCCOLORSOther1
      ENDINCCOLORSOther1:

      mov targetStartColumnPosition, 115d
      mov targetStartColumnPositionOther, 277d
      mov al,targetColor ; ax = 0 targetColor
      mov ah,0           
      add otherPointsValue,al ; add target color to my score the color is considered as score
      ;change the target color
      inc targetColor
      mov ah,6
      mov bh,targetColor
      cmp bh,ah
      jnz EndCompare
        mov targetColor, 1
      jmp EndCompare 
  case2Other:
  cmp cx, bx
  jb case3Other
     cmp ax,bx
     ja case3Other
      ; compare with dark Blue
      mov al, 1
      cmp al, targetColor
      jz increamentBlueOther2
      ; compare with green
      mov al, 2
      cmp al, targetColor
      jz increamentGreenOther2
      ; compare with Cyan
      mov al, 3
      cmp al, targetColor
      jz increamentCyanOther2
      ; compare with Red
      mov al, 4
      cmp al, targetColor
      jz increamentRedOther2
      ; compare with Magenta
      mov al, 5
      cmp al, targetColor
      jz increamentMagentaOther2

      increamentBlueOther2:
        ; inc coloredPoints
        jmp ENDINCCOLORSOther2
      increamentGreenOther2:
        ; inc coloredPoints[1]
        jmp ENDINCCOLORSOther2
      increamentCyanOther2:
        ; inc coloredPoints[2]
        jmp ENDINCCOLORSOther2
      increamentRedOther2:
        ; inc coloredPoints[3]
        jmp ENDINCCOLORSOther2
      increamentMagentaOther2:
        ; inc coloredPoints[4]
        jmp ENDINCCOLORSOther2
      ENDINCCOLORSOther2:

      mov targetStartColumnPosition, 115d
      mov targetStartColumnPositionOther, 277d
      mov al,targetColor ; ax = 0 targetColor
      mov ah,0           
      add otherPointsValue,al ; add target color to my score the color is considered as score
      ;change the target color
      inc targetColor
      mov ah,6
      mov bh,targetColor
      cmp bh,ah
      jnz EndCompare
        mov targetColor, 1
        jmp EndCompare
  case3Other:
  cmp ax,dx
  ja EndCompare
      cmp cx,dx
      jb EndCompare
      ; compare with dark Blue
      mov al, 1
      cmp al, targetColor
      jz increamentBlueOther3
      ; compare with green
      mov al, 2
      cmp al, targetColor
      jz increamentGreenOther3
      ; compare with Cyan
      mov al, 3
      cmp al, targetColor
      jz increamentCyanOther3
      ; compare with Red
      mov al, 4
      cmp al, targetColor
      jz increamentRedOther3
      ; compare with Magenta
      mov al, 5
      cmp al, targetColor
      jz increamentMagentaOther3

      increamentBlueOther3:
        ; inc coloredPoints
        jmp ENDINCCOLORSOther3
      increamentGreenOther3:
        ; inc coloredPoints[1]
        jmp ENDINCCOLORSOther3
      increamentCyanOther3:
        ; inc coloredPoints[2]
        jmp ENDINCCOLORSOther3
      increamentRedOther3:
        ; inc coloredPoints[3]
        jmp ENDINCCOLORSOther3
      increamentMagentaOther3:
        ; inc coloredPoints[4]
        jmp ENDINCCOLORSOther3
      ENDINCCOLORSOther3:
      mov targetStartColumnPosition, 115d
      mov targetStartColumnPositionOther, 277d
      mov al,targetColor ; ax = 0 targetColor
      mov ah,0           
      add otherPointsValue,al ; add target color to my score the color is considered as score
      ;change the target color
      inc targetColor
      mov ah,6
      mov bh,targetColor
      cmp bh,ah
      jnz EndCompare
        mov targetColor, 1
        jmp EndCompare
    
  EndCompare:
  
  mov ax,1000d
  cmp GUNLoopIterator, ax
  jz gunGameExit

  jmp runGunHome
  gunGameExit:
  ret
runGun endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Power Up;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
firstPowerUp proc
  ;check if the points < 5 then exit
  mov bl,flagTurn
  mov cl,0
  cmp bl,cl
  jnz FPUOther
  mov al,myPointsValue
  mov dl,5h
  cmp al,dl
  jb FiPUExit
  sub myPointsValue,5h 
  call printTwoPoints
  mov whichRegisterToExecute,1
  mov al,myforbiddenChar
  mov forbiddenChar,al 
  call printForbiddenChar
  call commandCyle
  call ClearCommand
  mov whichRegisterToExecute,0
  jmp FiPUExit

  FPUOther:
  mov al,otherPointsValue
  mov dl,5h
  cmp al,dl
  jb FiPUExit
  sub otherPointsValue,5h 
  call printTwoPoints
  mov whichRegisterToExecute,0
  mov al,otherforbiddenChar
  mov forbiddenChar,al 
  call printForbiddenChar
  call commandCyle
  call ClearCommand
  mov whichRegisterToExecute,1

  FiPUExit:

  ret
firstPowerUp endp
secondPowerUp proc
  ;check if the points < 3 then exit
  mov bl,flagTurn
  mov cl,0
  cmp bl,cl
  jnz SPUOther

  mov al,myPointsValue
  mov dl,3h
  cmp al,dl
  jb SPUExit
  sub myPointsValue,3h 
  jmp SPUCheckDone

  SPUOther:
  mov al,otherPointsValue
  mov dl,3h
  cmp al,dl
  jb SPUExit
  sub otherPointsValue,3h

  SPUCheckDone:
  call printTwoPoints
  mov whichRegisterToExecute,1
  call commandCyle
  mov whichRegisterToExecute,0
  mov flagSecondPowerUp,1
  call commandCyle
  call ClearCommand
  mov flagSecondPowerUp,0
  SPUExit:

  ret
secondPowerUp endp
thirdPowerUp proc
  ;check if the points < 8 then exit
  mov al,myPointsValue
  mov dl,8h
  cmp al,dl
  jb TPUExit

  ;check if the flag is off
  mov al,forbiddenPowerUpFlag
  mov dl,1
  cmp al,dl
  jz TPUExit

  call clearCommandSection
  ;print get the forbidden msg
  mov ah,9
  lea dx,getForbiddenMsg
  int 21h
  ;get the forbidden char
  mov ah,0
  int 16h
  ;draw the char
  mov  bl, GRAY
  mov  bh, 0                ;Display page
  mov  ah, 0Eh              ;Teletype
  int  10h 
  mov otherforbiddenChar,al
  mov forbiddenPowerUpFlag,1
  sub myPointsValue,8h
  call printForbiddenChar
  TPUExit:
  ret
thirdPowerUp endp
forthPowerUp proc
  ;check if the points < 30 then exit
  mov al,myPointsValue
  mov dl,30h
  cmp al,dl
  jb FPUExit

  ;check if the flag is off
  mov al,clearAllRegPowerUp
  mov dl,1
  cmp al,dl
  jz FPUExit

  mov cx,8h
  lea bx,myRegisters
  ; lea di,otherRegisters
  FPUclear:
  mov [bx],0000H
  ; mov [di],0000H
  add bx,2
  ; add di,2
  loop FPUclear
  mov clearAllRegPowerUp,1
  sub myPointsValue,30d
  
  call clearCommandSection
  ;print Clear all registers message
  mov ah,9
  lea dx,clearAllRegMsg
  int 21h
  FPUExit:
  ret
forthPowerUp endp
changeWantedValue proc
  mov al,level
  mov dl,1
  cmp al,dl
  jz ExitchangeWantedValue

  mov al,flagChangeWantedValue
  mov dl,1
  cmp al,dl
  jz ExitchangeWantedValue

  call clearCommandSection

  ;print Enter new wanted value
  mov ah,9
  lea dx,newWantedValueMessage
  int 21h

  mov ah,0AH
  mov dx,offset newWantedValueL
  int 21h

  call WantedValueToNumber
  mov ax, word ptr newWantedValue 

  mov cx,8d
  lea bx,myRegisters
  myRegisterLoop:
  cmp [bx],ax
  jz ExitchangeWantedValue
  add bx,2
  loop myRegisterLoop

  mov cx,8d
  lea bx,otherRegisters
  otherRegisterLoop:
  cmp [bx],ax
  jz ExitchangeWantedValue
  add bx,2
  loop otherRegisterLoop

  mov wantedValue,ax
  mov flagChangeWantedValue,1
  call printWantedValue
  call clearInputLabel
  
  ExitchangeWantedValue:
ret
changeWantedValue endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Command Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
commandCyle proc
  mov al,flagSecondPowerUp
  mov dl,1
  cmp al,dl 
  jz GCcont

  mov al,flagTurn
  mov dl,0
  cmp al,dl
  jnz otherTurn

  call clearCommandSection
  jmp afterClearCommandSection

  otherTurn:
  call clearOtherCommandSection

  afterClearCommandSection:
  ;check for the level to know how to enter the command
  mov al,level
  mov dl,1
  cmp al,dl
  jz CClvl1

  ;level 2
  call getCommandLvl2
  ;check if he used forbidden char
  mov al,forbiddenFlag
  mov dl,1
  cmp al,dl
  jz EXITJMPCO
  jmp NOEXITCO
  EXITJMPCO: jmp CCExit
  NOEXITCO:

  jmp GCcont
  CClvl1:
  call getCommandLvl1
  GCcont:
  ;operation --> ourOperation | destination --> regName | source --> SrcStr
  call separateCommand
  ;get the code of the operation | get the invalid flag
  call knowTheOperation
  ;if the invalid flag == 1 then exit and remove some points from the player
  mov al,invalidOperationFlag
  mov dl,1
  cmp al,dl
  jz EXITJMPOP
  jmp NOEXITOP
  EXITJMPOP: jmp CCExit
  NOEXITOP:

  ;set the memory offset

  mov al,whichRegisterToExecute
  mov dl,0    ;other
  cmp al,dl
  jnz COMCycleNotEqualZero

  lea bx,otherMemory
  jmp ComEXITCHECKEXECUTE
  
  COMCycleNotEqualZero:
  lea bx,myMemory

  ComEXITCHECKEXECUTE:

  mov offsetMemory,bx
  pusha
  call destinationCheck
  popa
  ;if the invalid flag == 1 then exit and remove some points from the player
  mov al,flagdst
  mov dl,1
  cmp al,dl
  jz EXITJMPDS
  jmp NOEXITDS
  EXITJMPDS: 
  mov invalidOperationFlag,1
  jmp CCExit
  NOEXITDS:

  pusha
  call sourceCheck
  popa

  ;if the invalid flag == 1 then exit and remove some points from the player
  mov al,flag
  mov dl,1
  cmp al,dl
  jz EXITJMPSO
  jmp NOEXITSO
  EXITJMPSO: 
  mov invalidOperationFlag,1
  jmp CCExit
  NOEXITSO:

  call Execute
  ;function to clear the command string (turn it back to $)
  CCExit:

  mov al,flagTurn
  mov dl,0
  cmp al,dl
  jnz otherDecCheck

  ;check the invalid flag to decrement the points
  mov al,invalidOperationFlag
  mov dl,1
  cmp al,dl
  jnz NoPointDec
  dec myPointsValue
  jmp NoPointDec

  otherDecCheck:
  mov al,invalidOperationFlag
  mov dl,1
  cmp al,dl
  jnz NoPointDec
  dec otherPointsValue

  NoPointDec:
  ret
commandCyle endp
clearBGcommand proc
  mov ah, 9
  lea dx,clearBGC
  int 21h
  ret
clearBGcommand endp
getCommandLvl1 proc
  lea di,myCommand
  lea si,myCommand

  mov al,forbiddenChar
  or al,32                           ;or with ascci in string
  mov forbiddenChar,al               ;lower character will be placed

  Com1mainLoop:
  mov ah,0
  int 16h
  mov dl,1CH
  cmp ah,dl
  jz Com1exit
  mov bh,08h
  cmp al,bh
  jz Com1Backspace

  cmp al,5BH
  jz GC1braketJMP
  cmp al,5DH
  jz GC1braketJMP

  or al,32
  mov bl,forbiddenChar ;forbidden Character 
  cmp al,bl
  jz Com1found   
  
  GC1braketJMP:
  ;draw the char
  mov  bl, GRAY
  mov  bh, 0                ;Display page
  mov  ah, 0Eh              ;Teletype
  int  10h 
  mov [di],al
  inc di 
  
  Com1found:
  jmp Com1mainLoop
  
  Com1Backspace: ;if user enter backspace
  cmp di,si
  jz NoDEC1
  dec di
  NoDEC1:
  mov bl,'$'
  mov [di],bl
  mov ah,3h
  mov bh,0h  ;get cursor
  int 10h
  ;check if the cursor(x) = 0
  mov bl,flagTurn
  mov cl,0
  cmp bl,cl
  jnz SecondTurnCheckCommandBackSpace
  mov al,2
  jmp afterCheckBackspaceSecond
  SecondTurnCheckCommandBackSpace:
  mov al,16h
  afterCheckBackspaceSecond:
  cmp al,dl
  jz NoDEC2
  dec dl
  NoDEC2:
  mov ah,2
  int 10h
  mov ah,2
  mov dl,' '
  int 21h
  mov ah,3h
  mov bh,0h 
  int 10h
  dec dl
  mov ah,2
  int 10h              
  jmp Com1mainLoop
  
  Com1exit:
  sub di,si
  mov ax,di
  mov myCommandActualSize,al
  ret
getCommandLvl1 endp
getCommandLvl2 proc
  ;get the player's command
  mov ah,0AH
  lea dx,myCommand-2
  int 21h
  ;convert the (enter) char to $
  lea si,myCommand
  mov al,0dh
  getCommandLoop:
  inc si
  mov bl,[si]
  cmp bl,al 
  jnz getCommandLoop
  mov [si],24h
  ; Convert forbidden Character to lowercase
  mov al,forbiddenChar
  or al,32                           ;or with ascci in string
  mov forbiddenChar,al               ;lower character will be placed
  ;start to convert all the command characters to lowercase
  lea si,myCommand                     ;si-->address of string
  L1: cmp [si],24h                   ;if equal to '$' ---> terminate
  jz GC2done
  ;compare with the brackets []
  mov al,[si]
  cmp al,5BH
  jz GC2braketJMP
  cmp al,5DH
  jz GC2braketJMP
  ;not [] then it is a normal char
  cmp al,97
  or al,32                           ;or with ascci in string
  mov [si],al                        ;lower character will be placed
  GC2braketJMP:
  inc si                             ;inc address of string
  jmp L1
  GC2done:                              ;end if = 'enter'
  ;search for the forbidden char in the command
  lea si,myCommand                     ;the command itself 
  mov al,forbiddenChar
  lea di,myCommandActualSize
  mov ch,0
  mov cl,[di]                        ;the actual size  
  repne SCASB                        ;scan the command for the forbidden char
  ;if cl!=0 then the forbidden flag will be 1
  cmp cl,0
  jz GC2EXIT
  mov forbiddenFlag,01h
  GC2EXIT:
  ret
getCommandLvl2 endp

Level2ChooseWhichRegister proc

mov al,flagTurn
mov dl,0
cmp al,dl
jnz otherChoice
;here this is my choice 
mov al,myforbiddenChar
mov forbiddenChar,al
call clearCommandSection
mov dx,offset choiceMessage
mov ah,9h
int 21h
mov ah,0
int 16h
mov ah,30h
cmp al,ah
jnz executeOnOtherFirstSelection  
;here he clicked 0 so execute on my registers
mov whichRegisterToExecute,1
jmp Level2ChooseWhichRegisterExit
executeOnOtherFirstSelection:   ;he clicked 1 so execute on other registers
mov whichRegisterToExecute,0
jmp Level2ChooseWhichRegisterExit

otherChoice:
; here is the other choice
mov al,otherforbiddenChar
mov forbiddenChar,al
call clearOtherCommandSection
mov dx,offset choiceMessage
mov ah,9h
int 21h
mov ah,0
int 16h
mov ah,30h
cmp al,ah
jnz executeOnOtherSecondSelection  
;here he clicked 0 so execute on his registers
mov whichRegisterToExecute,0
jmp Level2ChooseWhichRegisterExit
executeOnOtherSecondSelection:   ;he clicked 1 so execute on my registers
mov whichRegisterToExecute,1

Level2ChooseWhichRegisterExit:
ret
Level2ChooseWhichRegister endp

separateCommand proc
  ;get the operation
  lea si,myCommand
  lea di,ourOperation
  mov dl,20h
  SECON:
  mov al,[si]
  cmp al,dl     ;if the current char is space then exit and inc (si) 
  jz SEOPEREND
  mov [di],al
  inc di
  inc si
  jmp SECON
  SEOPEREND:
  inc si
  ;now the di is on the first char of the destination
  mov di,si
  ;we need to get the comma (,) so that the destination done
  mov al,2Ch
  lea bx,myCommandActualSize
  mov ch,0
  mov cl,[bx]           ;the actual size
  repne SCASB
  ;now the di is on the first char of the source     
  ;copy the destination to its variable
  mov cx,di
  dec cx
  lea bx,regName    
  SEDesCon:
  mov al,[si]
  mov [bx],al
  inc bx                 ;move to next char of destination
  inc si
  cmp si,cx
  jnz SEDesCon
  ;copy the source to its variable
  lea bx,SrcStr
  SESouCon:
  mov al,[di]
  mov [bx],al
  inc bx
  inc di
  mov al,[di]
  cmp al,24H
  jnz SESouCon
  ret
separateCommand endp
knowTheOperation proc
  ;know the exact operation
  mov cx,1             ;counter to know the operation
  lea si,operations
  lea di,ourOperation
  KTOCONTINUE:
  mov al,[si]
  cmp al,2FH
  jz KTOINVALID
  cmpsb
  jnz KTOEXIT1
  ;equals
  cmpsw
  jnz KTOEXIT2
  ;equals
  mov CodeOfOperation,cl
  jmp KTOFINISH
  KTOEXIT1:
  lea di,ourOperation
  add si,2
  inc cx
  jmp KTOCONTINUE
  KTOEXIT2:
  lea di,ourOperation
  inc cx    
  jmp KTOCONTINUE
  KTOINVALID:
  mov invalidOperationFlag,1 
  mov cx,0
  KTOFINISH:
  ret
knowTheOperation endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Execute proc
  ;if the operation between memory to memory then exit
  mov al,typeOfDestination
  mov dl,0h
  cmp al,dl
  jz EXECUTEOP
  mov dl,1h
  cmp al,dl
  jz DSISMEM
  jmp DSISDIM
  DSISMEM:
  ;destination is memory (1h) now check the source
  mov al,typeOfSource
  mov dl,1h
  cmp al,dl
  jz MEMMEMError
  mov dl,3h
  cmp al,dl
  jz MEMMEMError
  jmp EXECUTEOP
  DSISDIM:
  ;destination is memory (2h) now check the source
  mov al,typeOfSource
  mov dl,1h
  cmp al,dl
  jz MEMMEMError
  mov dl,3h
  cmp al,dl
  jz MEMMEMError
  jmp EXECUTEOP

  MEMMEMError:
  ;they both are memory
  mov invalidOperationFlag,1
  jmp EXEXIT

  EXECUTEOP:
  ;compare the code of the operation to go to the block of that command
  mov al,CodeOfOperation
  mov dl,1h
  cmp al,dl            ;code=1 for mov
  jz OMOVJMP
  jmp OMOVJMP2
      OMOVJMP: call EXMOV
      jmp EXEXIT
  OMOVJMP2:
  inc dl
  cmp al,dl            ;code=2 for add            
  jz OADDJMP
  jmp OADDJMP2
      OADDJMP: call EXADD
      jmp EXEXIT
  OADDJMP2:
  inc dl
  cmp al,dl            ;code=3 for adc            
  jz OADCJMP
  jmp OADCJMP2
      OADCJMP: call EXADC
      jmp EXEXIT
  OADCJMP2:
  inc dl
  cmp al,dl            ;code=4 for sub
  jz OSUBJMP
  jmp OSUBJMP2
      OSUBJMP: call EXSUB
      jmp EXEXIT
  OSUBJMP2:
  inc dl
  cmp al,dl
  jz OSBBJMP              ;code=5 for sbb
  jmp OSBBJMP2
      OSBBJMP: call EXSBB
      jmp EXEXIT
  OSBBJMP2:
  inc dl
  cmp al,dl               ;code=6 for xor
  jz OXORJMP
  jmp OXORJMP2
      OXORJMP: call EXXOR
      jmp EXEXIT
  OXORJMP2:
  inc dl
  cmp al,dl              ;code=7 for and
  jz OANDJMP
  jmp OANDJMP2
      OANDJMP: call EXAND
      jmp EXEXIT
  OANDJMP2:
  inc dl
  cmp al,dl              ;code=8 for nop
  jz ONOPJMP
  jmp ONOPJMP2
      ONOPJMP: jmp EXEXIT
  ONOPJMP2:
  inc dl
  cmp al,dl              ;code=9 for shr
  jz OSHRJMP
  jmp OSHRJMP2
      OSHRJMP: call EXSHR
      jmp EXEXIT
  OSHRJMP2:
  inc dl
  cmp al,dl              ;code=10 for shl
  jz OSHLJMP
  jmp OSHLJMP2
      OSHLJMP: call EXSHL
      jmp EXEXIT
  OSHLJMP2:
  inc dl
  cmp al,dl              ;code=11 for clc
  jz OCLCJMP
  jmp OCLCJMP2
      OCLCJMP: call EXCLC
      jmp EXEXIT
  OCLCJMP2:
  inc dl
  cmp al,dl              ;code=12 for ror
  jz ORORJMP
  jmp ORORJMP2
      ORORJMP: call EXROR
      jmp EXEXIT
  ORORJMP2:
  inc dl
  cmp al,dl              ;code=13 for rol
  jz OROLJMP
  jmp OROLJMP2
      OROLJMP: call EXROL
      jmp EXEXIT
  OROLJMP2:
  inc dl
  cmp al,dl              ;code=14 for rcr
  jz ORCRJMP
  jmp ORCRJMP2
      ORCRJMP: call EXRCR
      jmp EXEXIT
  ORCRJMP2:
  inc dl
  cmp al,dl              ;code=15 for rcl
  jz ORCLJMP
  jmp ORCLJMP2
      ORCLJMP: call EXRCL
      jmp EXEXIT
  ORCLJMP2:
  inc dl
  cmp al,dl              ;code=16 for inc
  jz OINCJMP
  jmp OINCJMP2
      OINCJMP: call EXINC
      jmp EXEXIT
  OINCJMP2:
  inc dl
  cmp al,dl              ;code=17 for dec
  jz ODECJMP
  jmp ODECJMP2
      ODECJMP: call EXDEC
      jmp EXEXIT
  ODECJMP2:
  EXEXIT:
  ret
Execute endp
Error proc
  mov invalidOperationFlag,1
  ret
Error endp
SecondChar proc
  lea bx,SrcStr
  inc bx
  mov al,[bx]
  lea bx,regName
  inc bx
  mov ah,[bx]
  ret
SecondChar endp
EditCarry proc
  mov al,carry
  mov dl,0
  cmp al,dl
  jnz CARRYON
  CLC
  jmp CARRYEXIT
  CARRYON:
  STC
  CARRYEXIT:
  ret
EditCarry endp
ClearCommand proc
  lea di,myCommand
  ClearComAgain:
  mov al,[di]
  mov dl,'$'
  cmp al,dl
  jz ClearComfinish
  mov [di],dl
  inc di
  jmp ClearComAgain
  ClearComfinish:

  lea di,ourOperation
  ClearComAgain2:
  mov al,[di]
  mov dl,'$'
  cmp al,dl
  jz ClearComfinish2
  mov [di],dl
  inc di
  jmp ClearComAgain2
  ClearComfinish2:

  lea di,regName
  ClearComAgain3:
  mov al,[di]
  mov dl,'$'
  cmp al,dl
  jz ClearComfinish3
  mov [di],dl
  inc di
  jmp ClearComAgain3
  ClearComfinish3:

  lea di,SrcStr
  ClearComAgain4:
  mov al,[di]
  mov dl,'$'
  cmp al,dl
  jz ClearComfinish4
  mov [di],dl
  inc di
  jmp ClearComAgain4
  ClearComfinish4:

  ;reset all the flags
  mov flag,0
  mov flagdst,0
  mov invalidOperationFlag,0
  mov CodeOfOperation,0
  mov forbiddenFlag,0
  ret
ClearCommand endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV16 proc
  mov si,source
  mov bx,destination
  mov ax,[si]                 ;source
  mov [bx],ax                 ;mov the source into destination
  ret
MOV16 endp
MOV8 proc
  mov si,source
  mov bx,destination
  mov al,[si]                 ;source
  mov [bx],al                 ;mov the source into destination
  ret
MOV8 endp
EXMOV proc
  ;check the destination
  mov al,typeOfDestination
  mov dl,0
  cmp al,dl
  jnz MOVDSMEMH
  jmp MOVDSCON
  MOVDSMEMH: jmp MOVDSMEM
  MOVDSCON:
  ;start the destination is register --> now check the source
  mov al,typeOfSource
  mov dl,0
  cmp al,dl
  jnz MOVSONUMH
  jmp MOVSOCON
  MOVSONUMH: jmp MOVSONUM
  MOVSOCON:
  ;source is register --> have to check the second char (size matching)
  call SecondChar     ;ah=second char in destination , al=second char in source
  ;compare al with x
  mov dl,'x'
  cmp al,dl
  jz MOV16BIT
  mov dl,'i'
  cmp al,dl
  jz MOV16BIT
  mov dl,'p'
  cmp al,dl
  jnz MOVSODSREGL

  MOV16BIT:  ;source 16-bits
  ;check the destination if (l,h)
  mov dl,'h'
  cmp ah,dl
  jz MOVSMERR
  mov dl,'l'
  cmp ah,dl
  jz MOVSMERR
  ;source and destination are 16-bits
  call MOV16
  jmp MOVEXIT

  MOVSODSREGL:  ;source 8-bits
  ;check the destination
  mov dl,'x'
  cmp ah,dl
  jz MOVSMERR
  mov dl,'i'
  cmp ah,dl
  jz MOVSMERR
  mov dl,'p'
  cmp ah,dl
  jz MOVSMERR
  ;source and destination are 8-bits
  call MOV8
  jmp MOVEXIT

  MOVSMERR:
  call Error
  jmp MOVEXIT

  MOVSONUM: ;source is number or Memory
  mov al,typeOfSource
  mov dl,2
  cmp al,dl
  jnz MOVSOMEMH
  jmp MOVSON
  MOVSOMEMH: jmp MOVSOMEM
  MOVSON:
  ;source is number --> mov the number to the destination
  ;now check for the register if 8-bits or 16-bits
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz MOVREG16BITS
  mov dl,'i'
  cmp al,dl
  jz MOVREG16BITS
  mov dl,'p'
  cmp al,dl
  jnz MOVREG8BITS
  ;16-bit
  MOVREG16BITS:
  call MOV16
  jmp MOVEXIT
  ;8-bits
  MOVREG8BITS:
  call MOV8
  jmp MOVEXIT

  MOVSOMEM: ;source is (Memory,Register Indirect)
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz MOVREGMEM16
  mov dl,'i'
  cmp al,dl
  jz MOVREGMEM16
  mov dl,'p'
  cmp al,dl
  jnz MOVREGMEM8
  
  MOVREGMEM16:   ;move into 16-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz MOVREGMEM16IND
  ;memory
  add bx,[di]
  jmp MOVREGMEM16INDCON
  MOVREGMEM16IND:
  ;register indirect
  add bx,di
  MOVREGMEM16INDCON:
  mov di,destination
  mov ax,[bx]
  mov [di],ax
  jmp MOVEXIT

  MOVREGMEM8:    ;move into 8-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz MOVREGMEM8IND
  ;memory
  add bx,[di]
  jmp MOVREGMEM8INDCON
  MOVREGMEM8IND:
  ;register indirect
  add bx,di
  MOVREGMEM8INDCON:
  mov di,destination
  mov al,[bx]
  mov [di],al
  jmp MOVEXIT
  
  ;end destination is reg
  MOVDSMEM: ;destination is not register (Memory,Register Indirect) , source may be register or number
  mov al,typeOfSource
  mov dl,2h
  cmp al,dl
  jnz MOVSOREG
  ;check if the number bigger than FF then 16-bits else 8-bits
  mov di,source
  mov ax,[di]            ;if ah=0 then 8-bits
  mov dl,0
  cmp ah,dl
  jnz MOVMEMSO16
  jmp MOVMEMSO8
  MOVSOREG:
  ;check the source if 8-bits or 16-bits
  lea bx,SrcStr
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz MOVMEMSO16
  mov dl,'i'
  cmp al,dl
  jz MOVMEMSO16
  mov dl,'p'
  cmp al,dl
  jnz MOVMEMSO8

  MOVMEMSO16:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz MOVMEM16
  ;memory
  add bx,[di]
  jmp MOVNOMEM16
  MOVMEM16:
  ;register indirect
  add bx,di
  MOVNOMEM16:
  mov di,source
  mov ax,[di]
  mov [bx],al
  inc bx
  mov [bx],ah
  jmp MOVEXIT

  MOVMEMSO8:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz MOVMEM8
  ;memory
  add bx,[di]
  jmp MOVNOMEM8
  MOVMEM8:
  ;register indirect
  add bx,di
  MOVNOMEM8:
  mov di,source
  mov al,[di]
  mov [bx],al
  MOVEXIT:
  ret
EXMOV endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ADD16 proc
  mov si,source
  mov bx,destination
  call EditCarry
  mov ax,[si]                 ;source
  mov di,[bx]                 ;destination
  add di,ax
  mov carry,0
  jnc ADDNOCARRY16
  mov carry,1
  ADDNOCARRY16:
  mov [bx],di
  ret
ADD16 endp
ADD8 proc
  mov si,source
  mov bx,destination
  call EditCarry
  mov al,[si]                 ;source
  mov ah,[bx]                 ;destination
  add ah,al
  mov carry,0
  jnc ADDNOCARRY8
  mov carry,1
  ADDNOCARRY8:
  mov [bx],ah
  ret
ADD8 endp
EXADD proc
  ;check the destination
  mov al,typeOfDestination
  mov dl,0
  cmp al,dl
  jnz ADDDSMEMH
  jmp ADDDSCON
  ADDDSMEMH: jmp ADDDSMEM
  ADDDSCON:
  ;start the destination is register --> now check the source
  mov al,typeOfSource
  mov dl,0
  cmp al,dl
  jnz ADDSONUMH
  jmp ADDSOCON
  ADDSONUMH: jmp ADDSONUM
  ADDSOCON:
  ;source is register --> have to check the second char (size matching)
  call SecondChar     ;ah=second char in destination , al=second char in source
  ;compare al with x
  mov dl,'x'
  cmp al,dl
  jz ADD16BIT
  mov dl,'i'
  cmp al,dl
  jz ADD16BIT
  mov dl,'p'
  cmp al,dl
  jnz ADDSODSREGL
  ADD16BIT:  ;source 16-bits
  ;check the destination if (l,h)
  mov dl,'h'
  cmp ah,dl
  jz ADDSMERR
  mov dl,'l'
  cmp ah,dl
  jz ADDSMERR
  ;source and destination are 16-bits
  call ADD16
  jmp ADDEXIT

  ADDSODSREGL:  ;source 8-bits
  ;check the destination
  mov dl,'x'
  cmp ah,dl
  jz ADDSMERR
  mov dl,'i'
  cmp ah,dl
  jz ADDSMERR
  mov dl,'p'
  cmp ah,dl
  jz ADDSMERR
  ;source and destination are 8-bits
  call ADD8
  jmp ADDEXIT

  ADDSMERR:
  call Error
  jmp ADDEXIT

  ADDSONUM: ;source is number or Memory
  mov al,typeOfSource
  mov dl,2
  cmp al,dl
  jnz ADDSOMEMH
  jmp ADDSON
  ADDSOMEMH: jmp ADDSOMEM
  ADDSON:
  ;source is number --> add the number to the destination
  ;now check for the register if 8-bits or 16-bits
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz ADDREG16BITS
  mov dl,'i'
  cmp al,dl
  jz ADDREG16BITS
  mov dl,'p'
  cmp al,dl
  jnz ADDREG8BITS
  ;16-bit
  ADDREG16BITS:
  call ADD16
  jmp ADDEXIT
  ;8-bits
  ADDREG8BITS:
  call ADD8
  jmp ADDEXIT

  ADDSOMEM: ;source is (Memory,Register Indirect)
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz ADDREGMEM16
  mov dl,'i'
  cmp al,dl
  jz ADDREGMEM16
  mov dl,'p'
  cmp al,dl
  jnz ADDREGMEM8
  
  ADDREGMEM16:   ;add to 16-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz ADDREGMEM16IND
  ;memory
  add bx,[di]
  jmp ADDREGMEM16INDCON
  ADDREGMEM16IND:
  ;register indirect
  add bx,di
  ADDREGMEM16INDCON:
  mov di,destination
  call EditCarry
  mov ax,[bx]       ;source
  mov cx,[di]       ;destination
  add cx,ax
  mov carry,0
  jnc ADDMNOCARRY16
  mov carry,1
  ADDMNOCARRY16:
  mov [di],cx
  jmp ADDEXIT

  ADDREGMEM8:    ;add to 8-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz ADDREGMEM8IND
  ;memory
  add bx,[di]
  jmp ADDREGMEM8INDCON
  ADDREGMEM8IND:
  ;register indirect
  add bx,di
  ADDREGMEM8INDCON:
  mov di,destination
  call EditCarry
  mov al,[bx]       ;source
  mov ah,[di]       ;destination
  add ah,al
  mov carry,0
  jnc ADDMNOCARRY8
  mov carry,1
  ADDMNOCARRY8:
  mov [di],ah
  jmp ADDEXIT
  
  ;end destination is reg
  ADDDSMEM: ;destination is not register (Memory,Register Indirect) , source may be register or number
  mov al,typeOfSource
  mov dl,2h
  cmp al,dl
  jnz ADDSOREG
  ;check if the number bigger than FF then 16-bits else 8-bits
  mov di,source
  mov ax,[di]            ;if ah=0 then 8-bits
  mov dl,0
  cmp ah,dl
  jnz ADDMEMSO16
  jmp ADDMEMSO8
  ADDSOREG:
  ;check the source if 8-bits or 16-bits
  lea bx,SrcStr
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz ADDMEMSO16
  mov dl,'i'
  cmp al,dl
  jz ADDMEMSO16
  mov dl,'p'
  cmp al,dl
  jnz ADDMEMSO8

  ADDMEMSO16:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz ADDMEM16
  ;memory
  add bx,[di]
  jmp ADDNOMEM16
  ADDMEM16:
  ;register indirect
  add bx,di
  ADDNOMEM16:
  mov di,source
  call EditCarry
  mov ax,[di]     ;source
  mov cx,[bx]     ;destination
  add cx,ax
  mov carry,0
  jnc ADDMNOCARRY216
  mov carry,1
  ADDMNOCARRY216:
  mov [bx],cl
  inc bx
  mov [bx],ch
  jmp ADDEXIT

  ADDMEMSO8:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz ADDMEM8
  ;memory
  add bx,[di]
  jmp ADDNOMEM8
  ADDMEM8:
  ;register indirect
  add bx,di
  ADDNOMEM8:
  mov di,source
  call EditCarry
  mov al,[di]     ;source
  mov ah,[bx]     ;destination
  add ah,al
  mov carry,0
  jnc ADDMNOCARRY28
  mov carry,1
  ADDMNOCARRY28:
  mov [bx],ah
  ADDEXIT:
  ret
EXADD endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ADC16 proc
  mov si,source
  mov bx,destination
  call EditCarry
  mov ax,[si]                 ;source
  mov di,[bx]                 ;destination
  adc di,ax
  mov carry,0
  jnc ADCNOCARRY16
  mov carry,1
  ADCNOCARRY16:
  mov [bx],di
  ret
ADC16 endp
ADC8 proc
  mov si,source
  mov bx,destination
  call EditCarry
  mov al,[si]                 ;source
  mov ah,[bx]                 ;destination
  adc ah,al
  mov carry,0
  jnc ADCNOCARRY8
  mov carry,1
  ADCNOCARRY8:
  mov [bx],ah
  ret
ADC8 endp
EXADC proc
  ;check the destination
  mov al,typeOfDestination
  mov dl,0
  cmp al,dl
  jnz ADCDSMEMH
  jmp ADCDSCON
  ADCDSMEMH: jmp ADCDSMEM
  ADCDSCON:
  ;start the destination is register --> now check the source
  mov al,typeOfSource
  mov dl,0
  cmp al,dl
  jnz ADCSONUMH
  jmp ADCSOCON
  ADCSONUMH: jmp ADCSONUM
  ADCSOCON:
  ;source is register --> have to check the second char (size matching)
  call SecondChar     ;ah=second char in destination , al=second char in source
  ;compare al with x
  mov dl,'x'
  cmp al,dl
  jz ADC16BIT
  mov dl,'i'
  cmp al,dl
  jz ADC16BIT
  mov dl,'p'
  cmp al,dl
  jnz ADCSODSREGL
  ADC16BIT:  ;source 16-bits
  ;check the destination if (l,h)
  mov dl,'h'
  cmp ah,dl
  jz ADCSMERR
  mov dl,'l'
  cmp ah,dl
  jz ADCSMERR
  ;source and destination are 16-bits
  call ADC16
  jmp ADCEXIT

  ADCSODSREGL:  ;source 8-bits
  ;check the destination
  mov dl,'x'
  cmp ah,dl
  jz ADCSMERR
  mov dl,'i'
  cmp ah,dl
  jz ADCSMERR
  mov dl,'p'
  cmp ah,dl
  jz ADCSMERR
  ;source and destination are 8-bits
  call ADC8
  jmp ADCEXIT

  ADCSMERR:
  call Error
  jmp ADCEXIT

  ADCSONUM: ;source is number or Memory
  mov al,typeOfSource
  mov dl,2
  cmp al,dl
  jnz ADCSOMEMH
  jmp ADCSON
  ADCSOMEMH: jmp ADCSOMEM
  ADCSON:
  ;source is number --> add the number to the destination
  ;now check for the register if 8-bits or 16-bits
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz ADCREG16BITS
  mov dl,'i'
  cmp al,dl
  jz ADCREG16BITS
  mov dl,'p'
  cmp al,dl
  jnz ADCREG8BITS
  ;16-bit
  ADCREG16BITS:
  call ADC16
  jmp ADCEXIT
  ;8-bits
  ADCREG8BITS:
  call ADC8
  jmp ADCEXIT

  ADCSOMEM: ;source is (Memory,Register Indirect)
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz ADCREGMEM16
  mov dl,'i'
  cmp al,dl
  jz ADCREGMEM16
  mov dl,'p'
  cmp al,dl
  jnz ADCREGMEM8
  
  ADCREGMEM16:   ;add to 16-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz ADCREGMEM16IND
  ;memory
  add bx,[di]
  jmp ADCREGMEM16INDCON
  ADCREGMEM16IND:
  ;register indirect
  add bx,di
  ADCREGMEM16INDCON:
  mov di,destination
  call EditCarry
  mov ax,[bx]       ;source
  mov cx,[di]       ;destination
  adc cx,ax
  mov carry,0
  jnc ADCMNOCARRY16
  mov carry,1
  ADCMNOCARRY16:
  mov [di],cx
  jmp ADCEXIT

  ADCREGMEM8:    ;add to 8-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz ADCREGMEM8IND
  ;memory
  add bx,[di]
  jmp ADCREGMEM8INDCON
  ADCREGMEM8IND:
  ;register indirect
  add bx,di
  ADCREGMEM8INDCON:
  mov di,destination
  call EditCarry
  mov al,[bx]       ;source
  mov ah,[di]       ;destination
  adc ah,al
  mov carry,0
  jnc ADCMNOCARRY8
  mov carry,1
  ADCMNOCARRY8:
  mov [di],ah
  jmp ADCEXIT
  
  ;end destination is reg
  ADCDSMEM: ;destination is not register (Memory,Register Indirect) , source may be register or number
  mov al,typeOfSource
  mov dl,2h
  cmp al,dl
  jnz ADCSOREG
  ;check if the number bigger than FF then 16-bits else 8-bits
  mov di,source
  mov ax,[di]            ;if ah=0 then 8-bits
  mov dl,0
  cmp ah,dl
  jnz ADCMEMSO16
  jmp ADCMEMSO8
  ADCSOREG:
  ;check the source if 8-bits or 16-bits
  lea bx,SrcStr
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz ADCMEMSO16
  mov dl,'i'
  cmp al,dl
  jz ADCMEMSO16
  mov dl,'p'
  cmp al,dl
  jnz ADCMEMSO8

  ADCMEMSO16:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz ADCMEM16
  ;memory
  add bx,[di]
  jmp ADCNOMEM16
  ADCMEM16:
  ;register indirect
  add bx,di
  ADCNOMEM16:
  mov di,source
  call EditCarry
  mov ax,[di]     ;source
  mov cx,[bx]     ;destination
  adc cx,ax
  mov carry,0
  jnc ADCMNOCARRY216
  mov carry,1
  ADCMNOCARRY216:
  mov [bx],cl
  inc bx
  mov [bx],ch
  jmp ADCEXIT

  ADCMEMSO8:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz ADCMEM8
  ;memory
  add bx,[di]
  jmp ADCNOMEM8
  ADCMEM8:
  ;register indirect
  add bx,di
  ADCNOMEM8:
  mov di,source
  call EditCarry
  mov al,[di]     ;source
  mov ah,[bx]     ;destination
  adc ah,al
  mov carry,0
  jnc ADCMNOCARRY28
  mov carry,1
  ADCMNOCARRY28:
  mov [bx],ah
  ADCEXIT:
  ret
EXADC endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SUB16 proc
  mov si,source
  mov bx,destination
  call EditCarry
  mov ax,[si]                 ;source
  mov di,[bx]                 ;destination
  sub di,ax
  mov carry,0
  jnc SUBNOCARRY16
  mov carry,1
  SUBNOCARRY16:
  mov [bx],di
  ret
SUB16 endp
SUB8 proc
  mov si,source
  mov bx,destination
  call EditCarry
  mov al,[si]                 ;source
  mov ah,[bx]                 ;destination
  sub ah,al
  mov carry,0
  jnc SUBNOCARRY8
  mov carry,1
  SUBNOCARRY8:
  mov [bx],ah
  ret
SUB8 endp
EXSUB proc
  ;check the destination
  mov al,typeOfDestination
  mov dl,0
  cmp al,dl
  jnz SUBDSMEMH
  jmp SUBDSCON
  SUBDSMEMH: jmp SUBDSMEM
  SUBDSCON:
  ;start the destination is register --> now check the source
  mov al,typeOfSource
  mov dl,0
  cmp al,dl
  jnz SUBSONUMH
  jmp SUBSOCON
  SUBSONUMH: jmp SUBSONUM
  SUBSOCON:
  ;source is register --> have to check the second char (size matching)
  call SecondChar     ;ah=second char in destination , al=second char in source
  ;compare al with x
  mov dl,'x'
  cmp al,dl
  jz SUB16BIT
  mov dl,'i'
  cmp al,dl
  jz SUB16BIT
  mov dl,'p'
  cmp al,dl
  jnz SUBSODSREGL
  SUB16BIT:  ;source 16-bits
  ;check the destination if (l,h)
  mov dl,'h'
  cmp ah,dl
  jz SUBSMERR
  mov dl,'l'
  cmp ah,dl
  jz SUBSMERR
  ;source and destination are 16-bits
  call SUB16
  jmp SUBEXIT

  SUBSODSREGL:  ;source 8-bits
  ;check the destination
  mov dl,'x'
  cmp ah,dl
  jz SUBSMERR
  mov dl,'i'
  cmp ah,dl
  jz SUBSMERR
  mov dl,'p'
  cmp ah,dl
  jz SUBSMERR
  ;source and destination are 8-bits
  call SUB8
  jmp SUBEXIT

  SUBSMERR:
  call Error
  jmp SUBEXIT

  SUBSONUM: ;source is number or Memory
  mov al,typeOfSource
  mov dl,2
  cmp al,dl
  jnz SUBSOMEM
  ;source is number --> add the number to the destination
  ;now check for the register if 8-bits or 16-bits
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz SUBREG16BITS
  mov dl,'i'
  cmp al,dl
  jz SUBREG16BITS
  mov dl,'p'
  cmp al,dl
  jnz SUBREG8BITS
  ;16-bit
  SUBREG16BITS:
  call SUB16
  jmp SUBEXIT
  ;8-bits
  SUBREG8BITS:
  call SUB8
  jmp SUBEXIT

  SUBSOMEM: ;source is (Memory,Register Indirect)
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz SUBREGMEM16
  mov dl,'i'
  cmp al,dl
  jz SUBREGMEM16
  mov dl,'p'
  cmp al,dl
  jnz SUBREGMEM8
  
  SUBREGMEM16:   ;sub from 16-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz SUBREGMEM16IND
  ;memory
  add bx,[di]
  jmp SUBREGMEM16INDCON
  SUBREGMEM16IND:
  ;register indirect
  add bx,di
  SUBREGMEM16INDCON:
  mov di,destination
  call EditCarry
  mov ax,[bx]       ;source
  mov cx,[di]       ;destination
  sub cx,ax
  mov carry,0
  jnc SUBMNOCARRY16
  mov carry,1
  SUBMNOCARRY16:
  mov [di],cx
  jmp SUBEXIT

  SUBREGMEM8:    ;sub from 8-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz SUBREGMEM8IND
  ;memory
  add bx,[di]
  jmp SUBREGMEM8INDCON
  SUBREGMEM8IND:
  ;register indirect
  add bx,di
  SUBREGMEM8INDCON:
  mov di,destination
  call EditCarry
  mov al,[bx]       ;source
  mov ah,[di]       ;destination
  sub ah,al
  mov carry,0
  jnc SUBMNOCARRY8
  mov carry,1
  SUBMNOCARRY8:
  mov [di],ah
  jmp SUBEXIT
  
  ;end destination is reg
  SUBDSMEM: ;destination is not register (Memory,Register Indirect) , source may be register or number
  mov al,typeOfSource
  mov dl,2h
  cmp al,dl
  jnz SUBSOREG
  ;check if the number bigger than FF then 16-bits else 8-bits
  mov di,source
  mov ax,[di]            ;if ah=0 then 8-bits
  mov dl,0
  cmp ah,dl
  jnz SUBMEMSO16
  jmp SUBMEMSO8
  SUBSOREG:
  ;check the source if 8-bits or 16-bits
  lea bx,SrcStr
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz SUBMEMSO16
  mov dl,'i'
  cmp al,dl
  jz SUBMEMSO16
  mov dl,'p'
  cmp al,dl
  jnz SUBMEMSO8

  SUBMEMSO16:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz SUBMEM16
  ;memory
  add bx,[di]
  jmp SUBNOMEM16
  SUBMEM16:
  ;register indirect
  add bx,di
  SUBNOMEM16:
  mov di,source
  call EditCarry
  mov ax,[di]     ;source
  mov cx,[bx]     ;destination
  sub cx,ax
  mov carry,0
  jnc SUBMNOCARRY216
  mov carry,1
  SUBMNOCARRY216:
  mov [bx],cl
  inc bx
  mov [bx],ch
  jmp SUBEXIT

  SUBMEMSO8:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz SUBMEM8
  ;memory
  add bx,[di]
  jmp SUBNOMEM8
  SUBMEM8:
  ;register indirect
  add bx,di
  SUBNOMEM8:
  mov di,source
  call EditCarry
  mov al,[di]     ;source
  mov ah,[bx]     ;destination
  sub ah,al
  mov carry,0
  jnc SUBMNOCARRY28
  mov carry,1
  SUBMNOCARRY28:
  mov [bx],ah
  SUBEXIT:
  ret
EXSUB endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SBB16 proc
  mov si,source
  mov bx,destination
  call EditCarry
  mov ax,[si]                 ;source
  mov di,[bx]                 ;destination
  sbb di,ax
  mov carry,0
  jnc SBBNOCARRY16
  mov carry,1
  SBBNOCARRY16:
  mov [bx],di
  ret
SBB16 endp
SBB8 proc
  mov si,source
  mov bx,destination
  call EditCarry
  mov al,[si]                 ;source
  mov ah,[bx]                 ;destination
  sbb ah,al
  mov carry,0
  jnc SBBNOCARRY8
  mov carry,1
  SBBNOCARRY8:
  mov [bx],ah
  ret
SBB8 endp
EXSBB proc
  ;check the destination
  mov al,typeOfDestination
  mov dl,0
  cmp al,dl
  jnz SBBDSMEMH
  jmp SBBDSCON
  SBBDSMEMH: jmp SBBDSMEM
  SBBDSCON:
  ;start the destination is register --> now check the source
  mov al,typeOfSource
  mov dl,0
  cmp al,dl
  jnz SBBSONUMH
  jmp SBBSOCON
  SBBSONUMH: jmp SBBSONUM
  SBBSOCON:
  ;source is register --> have to check the second char (size matching)
  call SecondChar     ;ah=second char in destination , al=second char in source
  ;compare al with x
  mov dl,'x'
  cmp al,dl
  jz SBB16BIT
  mov dl,'i'
  cmp al,dl
  jz SBB16BIT
  mov dl,'p'
  cmp al,dl
  jnz SBBSODSREGL
  SBB16BIT:  ;source 16-bits
  ;check the destination if (l,h)
  mov dl,'h'
  cmp ah,dl
  jz SBBSMERR
  mov dl,'l'
  cmp ah,dl
  jz SBBSMERR
  ;source and destination are 16-bits
  call SBB16
  jmp SBBEXIT

  SBBSODSREGL:  ;source 8-bits
  ;check the destination
  mov dl,'x'
  cmp ah,dl
  jz SBBSMERR
  mov dl,'i'
  cmp ah,dl
  jz SBBSMERR
  mov dl,'p'
  cmp ah,dl
  jz SBBSMERR
  ;source and destination are 8-bits
  call SBB8
  jmp SBBEXIT

  SBBSMERR:
  call Error
  jmp SBBEXIT

  SBBSONUM: ;source is number or Memory
  mov al,typeOfSource
  mov dl,2
  cmp al,dl
  jnz SBBSOMEM
  ;source is number --> add the number to the destination
  ;now check for the register if 8-bits or 16-bits
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz SBBREG16BITS
  mov dl,'i'
  cmp al,dl
  jz SBBREG16BITS
  mov dl,'p'
  cmp al,dl
  jnz SBBREG8BITS
  ;16-bit
  SBBREG16BITS:
  call SBB16
  jmp SBBEXIT
  ;8-bits
  SBBREG8BITS:
  call SBB8
  jmp SBBEXIT

  SBBSOMEM: ;source is (Memory,Register Indirect)
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz SBBREGMEM16
  mov dl,'i'
  cmp al,dl
  jz SBBREGMEM16
  mov dl,'p'
  cmp al,dl
  jnz SBBREGMEM8
  
  SBBREGMEM16:   ;sub from 16-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz SBBREGMEM16IND
  ;memory
  add bx,[di]
  jmp SBBREGMEM16INDCON
  SBBREGMEM16IND:
  ;register indirect
  add bx,di
  SBBREGMEM16INDCON:
  mov di,destination
  call EditCarry
  mov ax,[bx]       ;source
  mov cx,[di]       ;destination
  sbb cx,ax
  mov carry,0
  jnc SBBMNOCARRY16
  mov carry,1
  SBBMNOCARRY16:
  mov [di],cx
  jmp SBBEXIT

  SBBREGMEM8:    ;sub from 8-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz SBBREGMEM8IND
  ;memory
  add bx,[di]
  jmp SBBREGMEM8INDCON
  SBBREGMEM8IND:
  ;register indirect
  add bx,di
  SBBREGMEM8INDCON:
  mov di,destination
  call EditCarry
  mov al,[bx]       ;source
  mov ah,[di]       ;destination
  sbb ah,al
  mov carry,0
  jnc SBBMNOCARRY8
  mov carry,1
  SBBMNOCARRY8:
  mov [di],ah
  jmp SBBEXIT
  
  ;end destination is reg
  SBBDSMEM: ;destination is not register (Memory,Register Indirect) , source may be register or number
  mov al,typeOfSource
  mov dl,2h
  cmp al,dl
  jnz SBBSOREG
  ;check if the number bigger than FF then 16-bits else 8-bits
  mov di,source
  mov ax,[di]            ;if ah=0 then 8-bits
  mov dl,0
  cmp ah,dl
  jnz SBBMEMSO16
  jmp SBBMEMSO8
  SBBSOREG:
  ;check the source if 8-bits or 16-bits
  lea bx,SrcStr
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz SBBMEMSO16
  mov dl,'i'
  cmp al,dl
  jz SBBMEMSO16
  mov dl,'p'
  cmp al,dl
  jnz SBBMEMSO8

  SBBMEMSO16:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz SBBMEM16
  ;memory
  add bx,[di]
  jmp SBBNOMEM16
  SBBMEM16:
  ;register indirect
  add bx,di
  SBBNOMEM16:
  mov di,source
  call EditCarry
  mov ax,[di]     ;source
  mov cx,[bx]     ;destination
  sbb cx,ax
  mov carry,0
  jnc SBBMNOCARRY216
  mov carry,1
  SBBMNOCARRY216:
  mov [bx],cl
  inc bx
  mov [bx],ch
  jmp SBBEXIT

  SBBMEMSO8:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz SBBMEM8
  ;memory
  add bx,[di]
  jmp SBBNOMEM8
  SBBMEM8:
  ;register indirect
  add bx,di
  SBBNOMEM8:
  mov di,source
  call EditCarry
  mov al,[di]     ;source
  mov ah,[bx]     ;destination
  sbb ah,al
  mov carry,0
  jnc SBBMNOCARRY28
  mov carry,1
  SBBMNOCARRY28:
  mov [bx],ah
  SBBEXIT:
  ret
EXSBB endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
XOR16 proc
  mov si,source
  mov bx,destination
  mov ax,[si]                 ;source
  mov di,[bx]                 ;destination
  xor di,ax
  mov carry,0
  mov [bx],di
  ret
XOR16 endp
XOR8 proc
  mov si,source
  mov bx,destination
  mov al,[si]                 ;source
  mov ah,[bx]                 ;destination
  xor ah,al
  mov carry,0
  mov [bx],ah
  ret
XOR8 endp
EXXOR proc
  ;check the destination
  mov al,typeOfDestination
  mov dl,0
  cmp al,dl
  jnz XORDSMEMH
  jmp XORDSCON
  XORDSMEMH: jmp XORDSMEM
  XORDSCON:
  ;start the destination is register --> now check the source
  mov al,typeOfSource
  mov dl,0
  cmp al,dl
  jnz XORSONUMH
  jmp XORSOCON
  XORSONUMH: jmp XORSONUM
  XORSOCON:
  ;source is register --> have to check the second char (size matching)
  call SecondChar     ;ah=second char in destination , al=second char in source
  ;compare al with x
  mov dl,'x'
  cmp al,dl
  jz XOR16BIT
  mov dl,'i'
  cmp al,dl
  jz XOR16BIT
  mov dl,'p'
  cmp al,dl
  jnz XORSODSREGL
  XOR16BIT:  ;source 16-bits
  ;check the destination if (l,h)
  mov dl,'h'
  cmp ah,dl
  jz XORSMERR
  mov dl,'l'
  cmp ah,dl
  jz XORSMERR
  ;source and destination are 16-bits
  call XOR16
  jmp XOREXIT

  XORSODSREGL:  ;source 8-bits
  ;check the destination
  mov dl,'x'
  cmp ah,dl
  jz XORSMERR
  mov dl,'i'
  cmp ah,dl
  jz XORSMERR
  mov dl,'p'
  cmp ah,dl
  jz XORSMERR
  ;source and destination are 8-bits
  call XOR8
  jmp XOREXIT

  XORSMERR:
  call Error
  jmp XOREXIT

  XORSONUM: ;source is number or Memory
  mov al,typeOfSource
  mov dl,2
  cmp al,dl
  jnz XORSOMEM
  ;source is number --> add the number to the destination
  ;now check for the register if 8-bits or 16-bits
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz XORREG16BITS
  mov dl,'i'
  cmp al,dl
  jz XORREG16BITS
  mov dl,'p'
  cmp al,dl
  jnz XORREG8BITS
  ;16-bit
  XORREG16BITS:
  call XOR16
  jmp XOREXIT
  ;8-bits
  XORREG8BITS:
  call XOR8
  jmp XOREXIT

  XORSOMEM: ;source is (Memory,Register Indirect)
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz XORREGMEM16
  mov dl,'i'
  cmp al,dl
  jz XORREGMEM16
  mov dl,'p'
  cmp al,dl
  jnz XORREGMEM8
  
  XORREGMEM16:   ;xor with 16-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz XORREGMEM16IND
  ;memory
  add bx,[di]
  jmp XORREGMEM16INDCON
  XORREGMEM16IND:
  ;register indirect
  add bx,di
  XORREGMEM16INDCON:
  mov di,destination
  mov ax,[bx]       ;source
  mov cx,[di]       ;destination
  xor cx,ax
  mov carry,0
  mov [di],cx
  jmp XOREXIT

  XORREGMEM8:    ;xor with 8-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz XORREGMEM8IND
  ;memory
  add bx,[di]
  jmp XORREGMEM8INDCON
  XORREGMEM8IND:
  ;register indirect
  add bx,di
  XORREGMEM8INDCON:
  mov di,destination
  mov al,[bx]       ;source
  mov ah,[di]       ;destination
  xor ah,al
  mov carry,0
  mov [di],ah
  jmp XOREXIT
  
  ;end destination is reg
  XORDSMEM: ;destination is not register (Memory,Register Indirect) , source may be register or number
  mov al,typeOfSource
  mov dl,2h
  cmp al,dl
  jnz XORSOREG
  ;check if the number bigger than FF then 16-bits else 8-bits
  mov di,source
  mov ax,[di]            ;if ah=0 then 8-bits
  mov dl,0
  cmp ah,dl
  jnz XORMEMSO16
  jmp XORMEMSO8
  XORSOREG:
  ;check the source if 8-bits or 16-bits
  lea bx,SrcStr
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz XORMEMSO16
  mov dl,'i'
  cmp al,dl
  jz XORMEMSO16
  mov dl,'p'
  cmp al,dl
  jnz XORMEMSO8

  XORMEMSO16:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz XORMEM16
  ;memory
  add bx,[di]
  jmp XORNOMEM16
  XORMEM16:
  ;register indirect
  add bx,di
  XORNOMEM16:
  mov di,source
  mov ax,[di]     ;source
  mov cx,[bx]     ;destination
  xor cx,ax
  mov carry,0
  mov [bx],cl
  inc bx
  mov [bx],ch
  jmp XOREXIT

  XORMEMSO8:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz XORMEM8
  ;memory
  add bx,[di]
  jmp XORNOMEM8
  XORMEM8:
  ;register indirect
  add bx,di
  XORNOMEM8:
  mov di,source
  mov al,[di]     ;source
  mov ah,[bx]     ;destination
  xor ah,al
  mov carry,0
  mov [bx],ah
  XOREXIT:
  ret
EXXOR endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AND16 proc
  mov si,source
  mov bx,destination
  mov ax,[si]                 ;source
  mov di,[bx]                 ;destination
  and di,ax
  mov carry,0
  mov [bx],di
  ret
AND16 endp
AND8 proc
  mov si,source
  mov bx,destination
  mov al,[si]                 ;source
  mov ah,[bx]                 ;destination
  and ah,al
  mov carry,0
  mov [bx],ah
  ret
AND8 endp
EXAND proc
  ;check the destination
  mov al,typeOfDestination
  mov dl,0
  cmp al,dl
  jnz ANDDSMEMH
  jmp ANDDSCON
  ANDDSMEMH: jmp ANDDSMEM
  ANDDSCON:
  ;start the destination is register --> now check the source
  mov al,typeOfSource
  mov dl,0
  cmp al,dl
  jnz ANDSONUMH
  jmp ANDSOCON
  ANDSONUMH: jmp ANDSONUM
  ANDSOCON:
  ;source is register --> have to check the second char (size matching)
  call SecondChar     ;ah=second char in destination , al=second char in source
  ;compare al with x
  mov dl,'x'
  cmp al,dl
  jz AND16BIT
  mov dl,'i'
  cmp al,dl
  jz AND16BIT
  mov dl,'p'
  cmp al,dl
  jnz ANDSODSREGL
  AND16BIT:  ;source 16-bits
  ;check the destination if (l,h)
  mov dl,'h'
  cmp ah,dl
  jz ANDSMERR
  mov dl,'l'
  cmp ah,dl
  jz ANDSMERR
  ;source and destination are 16-bits
  call AND16
  jmp ANDEXIT

  ANDSODSREGL:  ;source 8-bits
  ;check the destination
  mov dl,'x'
  cmp ah,dl
  jz ANDSMERR
  mov dl,'i'
  cmp ah,dl
  jz ANDSMERR
  mov dl,'p'
  cmp ah,dl
  jz ANDSMERR
  ;source and destination are 8-bits
  call AND8
  jmp ANDEXIT

  ANDSMERR:
  call Error
  jmp ANDEXIT

  ANDSONUM: ;source is number or Memory
  mov al,typeOfSource
  mov dl,2
  cmp al,dl
  jnz ANDSOMEM
  ;source is number --> add the number to the destination
  ;now check for the register if 8-bits or 16-bits
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz ANDREG16BITS
  mov dl,'i'
  cmp al,dl
  jz ANDREG16BITS
  mov dl,'p'
  cmp al,dl
  jnz ANDREG8BITS
  ;16-bit
  ANDREG16BITS:
  call AND16
  jmp ANDEXIT
  ;8-bits
  ANDREG8BITS:
  call AND8
  jmp ANDEXIT

  ANDSOMEM: ;source is (Memory,Register Indirect)
  lea bx,regName
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz ANDREGMEM16
  mov dl,'i'
  cmp al,dl
  jz ANDREGMEM16
  mov dl,'p'
  cmp al,dl
  jnz ANDREGMEM8
  
  ANDREGMEM16:   ;and with 16-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz ANDREGMEM16IND
  ;memory
  add bx,[di]
  jmp ANDREGMEM16INDCON
  ANDREGMEM16IND:
  ;register indirect
  add bx,di
  ANDREGMEM16INDCON:
  mov di,destination
  call EditCarry
  mov ax,[bx]       ;source
  mov cx,[di]       ;destination
  and cx,ax
  mov carry,0
  mov [di],cx
  jmp ANDEXIT

  ANDREGMEM8:    ;and with 8-bits register
  mov bx,offsetMemory
  mov di,source
  mov al,typeOfSource
  mov dl,1
  cmp al,dl
  jnz ANDREGMEM8IND
  ;memory
  add bx,[di]
  jmp ANDREGMEM8INDCON
  ANDREGMEM8IND:
  ;register indirect
  add bx,di
  ANDREGMEM8INDCON:
  mov di,destination
  mov al,[bx]       ;source
  mov ah,[di]       ;destination
  and ah,al
  mov carry,0
  mov [di],ah
  jmp ANDEXIT
  
  ;end destination is reg
  ANDDSMEM: ;destination is not register (Memory,Register Indirect) , source may be register or number
  mov al,typeOfSource
  mov dl,2h
  cmp al,dl
  jnz ANDSOREG
  ;check if the number bigger than FF then 16-bits else 8-bits
  mov di,source
  mov ax,[di]            ;if ah=0 then 8-bits
  mov dl,0
  cmp ah,dl
  jnz ANDMEMSO16
  jmp ANDMEMSO8
  ANDSOREG:
  ;check the source if 8-bits or 16-bits
  lea bx,SrcStr
  inc bx
  mov al,[bx]
  mov dl,'x'
  cmp al,dl
  jz ANDMEMSO16
  mov dl,'i'
  cmp al,dl
  jz ANDMEMSO16
  mov dl,'p'
  cmp al,dl
  jnz ANDMEMSO8

  ANDMEMSO16:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz ANDMEM16
  ;memory
  add bx,[di]
  jmp ANDNOMEM16
  ANDMEM16:
  ;register indirect
  add bx,di
  ANDNOMEM16:
  mov di,source
  mov ax,[di]     ;source
  mov cx,[bx]     ;destination
  and cx,ax
  mov carry,0
  mov [bx],cl
  inc bx
  mov [bx],ch
  jmp ANDEXIT

  ANDMEMSO8:
  mov bx,offsetMemory
  mov di,destination
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz ANDMEM8
  ;memory
  add bx,[di]
  jmp ANDNOMEM8
  ANDMEM8:
  ;register indirect
  add bx,di
  ANDNOMEM8:
  mov di,source
  mov al,[di]     ;source
  mov ah,[bx]     ;destination
  and ah,al
  mov carry,0
  mov [bx],ah
  ANDEXIT:
  ret
EXAND endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXSHR proc
  mov dh,typeOfSource
  mov bl,0
  cmp dh,bl
  jz SHRCheckSource  ;If the source is register jump and check if cl
  mov bl,2h 
  cmp dh,bl 
  jnz SHREXITError    ; here if the source is neither register nor immediate (INVALID OPERATION)

  lea bx,SrcStr       ; now check if the source is immediate it must equal 1
  mov dl,[bx]
  mov al,1            ; here is 1 not '1' because the source is changed from the ascii to the real value in case of immediate
  cmp al,dl
  jz SHRCheckDestination   ; If the source equal 1 that's good check the destination 
  jnz SHREXITError                 ; else exit (INVALID OPERATION)


  SHRCheckSource:
  lea bx,SrcStr
  mov dl,[bx]
  mov al,'c'          ;Check for first letter to be c (only cl is valid)
  cmp al,dl
  jnz SHREXITError            ;(INVALID OPERATION)
  inc bx              ;Move for the second letter
  mov dl,[bx]
  mov al,'l'          ;Check for second letter to be l (only cl is valid)
  cmp al,dl
  jnz SHREXITError    ;(INVALID OPERATION)

  SHRCheckDestination:
  ;Check the destination 16 bit or 8 bit 
  lea bx,regName
  inc bx
  mov dl,[bx]
  mov al,'x'
  cmp al,dl
  jz SHRUpper         ;if 16 bit jump to SHRUpper 

  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  shr al,cl               ; here is the difference (work only on byte)
  mov [bx],al
  jc SHRSetCarry
  jmp SHREXIT

  SHRUpper:
  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  shr ax,cl               ; here is the difference (work on the whole word)
  mov [bx],ax
  jnc SHREXIT

  SHRSetCarry:
  mov carry,1

  SHREXITError:
  call Error
  
  SHREXIT:
  ret
EXSHR endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXSHL proc
  mov dh,typeOfSource
  mov bl,0
  cmp dh,bl
  jz SHLCheckSource  ;If the source is register jump and check if cl
  mov bl,2h 
  cmp dh,bl 
  jnz SHLEXITError           ; here if the source is neither register nor immediate(INVALID OPERATION)

  lea bx,SrcStr       ; now check if the source is immediate it must equal 1
  mov dl,[bx]
  mov al,1            ; here is 1 not '1' because the source is changed from the ascii to the real value in case of immediate
  cmp al,dl
  jz SHLCheckDestination   ; If the source equal 1 that's good check the destination 
  jnz SHLEXITError                 ; else exit (INVALID OPERATION)


  SHLCheckSource:
  lea bx,SrcStr
  mov dl,[bx]
  mov al,'c'  ;Check for first letter to be c (only cl is valid)
  cmp al,dl
  jnz SHLEXITError        ;(INVALID OPERATION)
  inc bx       ;Move for the second letter
  mov dl,[bx]
  mov al,'l'  ;Check for second letter to be l (only cl is valid)
  cmp al,dl
  jnz SHLEXITError        ;(INVALID OPERATION)

  SHLCheckDestination:
  ;Check the destination 16 bit or 8 bit 
  lea bx,regName
  inc bx
  mov dl,[bx]
  mov al,'x'
  cmp al,dl
  jz SHLUpper         ;if 16 bit jump to SHLUpper 

  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  shl al,cl               ; here is the difference (work only on byte)
  mov [bx],al
  jc SHLSetCarry
  jmp SHLEXIT

  SHLUpper:
  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  shl ax,cl               ; here is the difference (work on the whole word)
  mov [bx],ax
  jnc SHLEXIT

  SHLSetCarry:
  mov carry,1
  jmp SHLEXIT


  SHLEXITError:
  call Error
  
  SHLEXIT:
  ret
EXSHL endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXCLC proc
  mov carry,0
  ret
EXCLC endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXROR proc
  mov dh,typeOfSource
  mov bl,0
  cmp dh,bl
  jz RORCheckSource  ;If the source is register jump and check if cl
  mov bl,2h 
  cmp dh,bl 
  jnz ROREXITError         ; here if the source is neither register nor immediate (INVALID OPERATION)

  lea bx,SrcStr       ; now check if the source is immediate it must equal 1
  mov dl,[bx]
  mov al,1                ; here is 1 not '1' because the source is changed from the ascii to the real value in case of immediate
  cmp al,dl
  jz RORCheckDestination   ; If the source equal 1 that's good check the destination 
  jnz ROREXITError           ; else exit (INVALID OPERATION)


  RORCheckSource:
  lea bx,SrcStr
  mov dl,[bx]
  mov al,'c'  ;Check for first letter to be c (only cl is valid)
  cmp al,dl
  jnz ROREXITError  ;(INVALID OPERATION)
  inc bx       ;Move for the second letter
  mov dl,[bx]
  mov al,'l'  ;Check for second letter to be l (only cl is valid)
  cmp al,dl
  jnz ROREXITError        ;(INVALID OPERATION)

  RORCheckDestination:
  ;Check the destination 16 bit or 8 bit 
  lea bx,regName
  inc bx
  mov dl,[bx]
  mov al,'x'
  cmp al,dl
  jz RORUpper         ;if 16 bit jump to SHRUpper 

  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  ror al,cl               ; here is the difference (work only on byte)
  mov [bx],al
  jc RORSetCarry
  jmp ROREXIT

  RORUpper:
  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  ror ax,cl               ; here is the difference (work on the whole word)
  mov [bx],ax
  jnc ROREXIT

  RORSetCarry:
  mov carry,1
  jmp ROREXIT

  ROREXITError:
  call Error
  
  ROREXIT:

  ret
EXROR endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXROL proc
  mov dh,typeOfSource
  mov bl,0
  cmp dh,bl
  jz ROLCheckSource  ;If the source is register jump and check if cl
  mov bl,2h 
  cmp dh,bl 
  jnz ROLEXITError         ; here if the source is neither register nor immediate (INVALID OPERATION)

  lea bx,SrcStr       ; now check if the source is immediate it must equal 1
  mov dl,[bx]
  mov al,1                ; here is 1 not '1' because the source is changed from the ascii to the real value in case of immediate
  cmp al,dl
  jz ROLCheckDestination   ; If the source equal 1 that's good check the destination 
  jnz ROLEXITError           ; else exit (INVALID OPERATION)


  ROLCheckSource:
  lea bx,SrcStr
  mov dl,[bx]
  mov al,'c'  ;Check for first letter to be c (only cl is valid)
  cmp al,dl
  jnz ROLEXITError  ;(INVALID OPERATION)
  inc bx       ;Move for the second letter
  mov dl,[bx]
  mov al,'l'  ;Check for second letter to be l (only cl is valid)
  cmp al,dl
  jnz ROLEXITError        ;(INVALID OPERATION)

  ROLCheckDestination:
  ;Check the destination 16 bit or 8 bit 
  lea bx,regName
  inc bx
  mov dl,[bx]
  mov al,'x'
  cmp al,dl
  jz ROLUpper         ;if 16 bit jump to SHRUpper 

  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  rol al,cl               ; here is the difference (work only on byte)
  mov [bx],al
  jc ROLSetCarry
  jmp ROLEXIT

  ROLUpper:
  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  rol ax,cl               ; here is the difference (work on the whole word)
  mov [bx],ax
  jnc ROLEXIT

  ROLSetCarry:
  mov carry,1
  jmp ROLEXIT

  ROLEXITError:
  call Error
  
  ROLEXIT:

  ret
EXROL endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXRCR proc
  mov dh,typeOfSource
  mov bl,0
  cmp dh,bl
  jz RCRCheckSource  ;If the source is register jump and check if cl
  mov bl,2h 
  cmp dh,bl 
  jnz RCREXITError           ; here if the source is neither register nor immediate (INVALID OPERATION)

  lea bx,SrcStr       ; now check if the source is immediate it must equal 1
  mov dl,[bx]
  mov al,1            ; here is 1 not '1' because the source is changed from the ascii to the real value in case of immediate
  cmp al,dl
  jz RCRCheckDestination   ; If the source equal 1 that's good check the destination 
  jnz RCREXITError                 ; else exit (INVALID OPERATION)


  RCRCheckSource:
  lea bx,SrcStr
  mov dl,[bx]
  mov al,'c'  ;Check for first letter to be c (only cl is valid)
  cmp al,dl
  jnz RCREXITError  ;(INVALID OPERATION)
  inc bx       ;Move for the second letter
  mov dl,[bx]
  mov al,'l'  ;Check for second letter to be l (only cl is valid)
  cmp al,dl
  jnz RCREXITError        ;(INVALID OPERATION)

  RCRCheckDestination:
  ;Check the destination 16 bit or 8 bit 
  lea bx,regName
  inc bx
  mov dl,[bx]
  mov al,'x'
  cmp al,dl
  jz RCRUpper         ;if 16 bit jump to SHRUpper 

  mov al,carry    ; check if the carry equal to 1
  mov ah,1
  cmp al,ah
  jnz RCRNOCARRY  ;if not equal jump without setting the carry
  stc             ;else set the  carry
  jmp RCRCARRY    ; jump to carry


  RCRNOCARRY:
  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  clc
  rcr al,cl               ; here is the difference (work only on byte)
  mov [bx],al
  jc RCRSetCarry
  jmp RCREXIT

  RCRCARRY:
  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  rcr al,cl               ; here is the difference (work only on byte)
  mov [bx],al
  jc RCRSetCarry
  jmp RCREXIT

  RCRUpper:
  mov al,carry    ; check if the carry equal to 1
  mov ah,1
  cmp al,ah
  jnz RCRNOCARRYUpper  ;if not equal jump without setting the carry
  stc             ; else set the  carry
  jmp RCRCARRYUpper ; jump to carry 

  RCRNOCARRYUpper:
  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  clc
  rcr ax,cl               ; here is the difference (work on the whole word)
  mov [bx],ax
  jnc RCREXIT
  jc RCRSetCarry

  RCRCARRYUpper:
  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  rcr ax,cl               ; here is the difference (work on the whole word)
  mov [bx],ax
  jnc RCREXIT

  RCRSetCarry:
  mov carry,1
  jmp RCREXIT

  RCREXITError:
  call Error
  
  RCREXIT:

  ret
EXRCR endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXRCL proc
  mov dh,typeOfSource
  mov bl,0
  cmp dh,bl
  jz RCLCheckSource  ;If the source is register jump and check if cl
  mov bl,2h 
  cmp dh,bl 
  jnz RCLEXITError           ; here if the source is neither register nor immediate (INVALID OPERATION)

  lea bx,SrcStr       ; now check if the source is immediate it must equal 1
  mov dl,[bx]
  mov al,1            ; here is 1 not '1' because the source is changed from the ascii to the real value in case of immediate
  cmp al,dl
  jz RCLCheckDestination   ; If the source equal 1 that's good check the destination 
  jnz RCLEXITError                 ; else exit (INVALID OPERATION)


  RCLCheckSource:
  lea bx,SrcStr
  mov dl,[bx]
  mov al,'c'  ;Check for first letter to be c (only cl is valid)
  cmp al,dl
  jnz RCLEXITError  ;(INVALID OPERATION)
  inc bx       ;Move for the second letter
  mov dl,[bx]
  mov al,'l'  ;Check for second letter to be l (only cl is valid)
  cmp al,dl
  jnz RCLEXITError        ;(INVALID OPERATION)

  RCLCheckDestination:
  ;Check the destination 16 bit or 8 bit 
  lea bx,regName
  inc bx
  mov dl,[bx]
  mov al,'x'
  cmp al,dl
  jz RCLUpper         ;if 16 bit jump to SHRUpper 

  mov al,carry    ; check if the carry equal to 1
  mov ah,1
  cmp al,ah
  jnz RCLNOCARRY  ;if not equal jump without setting the carry
  stc             ;else set the  carry
  jmp RCLCARRY    ; jump to carry


  RCLNOCARRY:
  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  clc
  rcl al,cl               ; here is the difference (work only on byte)
  mov [bx],al
  jc RCLSetCarry
  jmp RCLEXIT

  RCLCARRY:
  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  rcl al,cl               ; here is the difference (work only on byte)
  mov [bx],al
  jc RCLSetCarry
  jmp RCLEXIT

  RCLUpper:
  mov al,carry    ; check if the carry equal to 1
  mov ah,1
  cmp al,ah
  jnz RCLNOCARRYUpper  ;if not equal jump without setting the carry
  stc             ; else set the  carry
  jmp RCLCARRYUpper ; jump to carry 

  RCLNOCARRYUpper:
  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  clc
  rcl ax,cl               ; here is the difference (work on the whole word)
  mov [bx],ax
  jnc RCLEXIT
  jc RCLSetCarry

  RCLCARRYUpper:
  mov di,source
  mov bx,destination
  mov cl,[di]
  mov ax,[bx]
  rcl ax,cl               ; here is the difference (work on the whole word)
  mov [bx],ax
  jnc RCLEXIT

  RCLSetCarry:
  mov carry,1
  jmp RCLEXIT

  RCLEXITError:
  call Error
  
  RCLEXIT:

  ret
EXRCL endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXINC proc
  mov al,typeOfDestination
  mov dl,0
  cmp al,dl
  jnz EXINCDestNotRegister
  mov di,source
  mov bx,destination
  mov ax,[bx]  
  inc ax
  mov [bx],ax
  jmp EXINCEXIT
  EXINCDestNotRegister:
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz EXINCDestNotMemory
  ; Here destination is memory
  mov bx,offsetMemory
  mov di,destination
  add bx,[di]
  mov ax,[bx]
  inc ax
  mov [bx],ax
  jmp EXINCEXIT
  EXINCDestNotMemory:
  ; Here destination is register indirect
  mov bx,offsetMemory
  mov di,destination
  add bx,di
  mov al,[bx]
  inc al
  mov [bx],al
  EXINCEXIT:
  ret
EXINC endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EXDEC proc
  mov al,typeOfDestination
  mov dl,0
  cmp al,dl
  jnz EXDECDestNotRegister
  mov di,source
  mov bx,destination
  mov ax,[bx]  
  dec ax
  mov [bx],ax
  jmp EXDECEXIT
  EXDECDestNotRegister:
  mov al,typeOfDestination
  mov dl,1
  cmp al,dl
  jnz EXDECDestNotMemory
  ; Here destination is memory
  mov bx,offsetMemory
  mov di,destination
  add bx,[di]
  mov ax,[bx]
  dec ax
  mov [bx],ax
  jmp EXDECEXIT
  EXDECDestNotMemory:
  ; Here destination is register indirect
  mov bx,offsetMemory
  mov di,destination
  add bx,di
  mov al,[bx]
  dec al
  mov [bx],al
  EXDECEXIT:
  ret
EXDEC endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
destinationCheck proc 
    mov al,whichRegisterToExecute
    mov dl,0    ;other
    cmp al,dl
    jnz DSNotEqualZero
    call otherOffsetSetter 
    jmp DSEXITCHECKEXECUTE

    DSNotEqualZero:
    call offsetSetter 

    DSEXITCHECKEXECUTE:
    call lowercaseDest                              
    
    ; trim spaces => begining and start             
    PUSHA                                         
    call trimSpacesDest                             
    POPA                                          
    
    mov dx,word ptr regName                         
    
    PUSHA                                         
    call validateRegisterDest
    mov typeOfDestination,0h                        
    POPA                                          
    
    mov ah,1                                        
    cmp flagdst,ah                                  
    jnz jmpDone                                     
        jmp continue                                
    jmpDone: jmp exit_Dest                          
        continue:                                   
        mov flagdst,0ffh                            
        call validateMemoryDest                     
        mov typeOfDestination,01h                   
        mov ah,1                                    
        cmp flagdst,ah                              
        jnz jmpFix
        jmp validateRegrDt
            jmpFix: jmp memt
        validateRegrDt:
            ; mov ah,9h
            ; mov dx,destination
            ; int 21h
            mov flagdst,0ffh
            call validateRegisterDirectDest
            mov ah,1                                                                        
            cmp flagdst,ah                                                                     
            mov typeOfDestination,02h
            jmp exit_Dest
        memt: call convertStrHexaDest
    exit_Dest: 
    ret 
destinationCheck endp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
offsetSetter proc 
    ; loop 16 times => number of registers
    ;set offsets of 16bit registers
    mov cx,16
    ; Loop start
    offsetLoop16:
        mov bx,cx
        mov ax,offset myRegisters
        add ax,cx
        mov offsets[bx],ax
        dec cx
    loop offsetLoop16
    
    ;next two line Handels first 16bit register
    mov ax,offset myRegisters
    mov offsets,ax
    ;set offsets of 8bit registers
    ; cx only handels loop range
    mov cx,16
    ; bx iterates over offsetArray
    mov bx,16
    ; si iterates over registers
    mov si,0
    ; Loop start
    offsetLoop8:
        mov ax,offset myRegisters
        add ax,si
        mov offsets[bx],ax
        inc si
        add bx,2
        dec cx
    loop offsetLoop8
    ret
offsetSetter endp
otherOffsetSetter proc 
    ; loop 16 times => number of registers
    ;set offsets of 16bit registers
    mov cx,16
    ; Loop start
    otherOffsetLoop16:
        mov bx,cx
        mov ax,offset otherRegisters
        add ax,cx
        mov offsets[bx],ax
        dec cx
    loop otherOffsetLoop16
    
    ;next two line Handels first 16bit register
    mov ax,offset otherRegisters
    mov offsets,ax
    ;set offsets of 8bit registers
    ; cx only handels loop range
    mov cx,16
    ; bx iterates over offsetArray
    mov bx,16
    ; si iterates over registers
    mov si,0
    ; Loop start
    otherOffsetLoop8:
        mov ax,offset otherRegisters
        add ax,si
        mov offsets[bx],ax
        inc si
        add bx,2
        dec cx
    loop otherOffsetLoop8
    ret
otherOffsetSetter endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lowercaseDest proc 
    lea si,regName     ;poitns to the 1st char of string

    mainLoop:
    mov dh,24h  ;;check if $ or not
    cmp [si],dh

    jz exitLcase         ;if equal to $ ---> terminate
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

    exitLcase: ; end if =$
    ret
lowercaseDest endp  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
trimSpacesDest proc
    mov bx, offset regName
    ;mov bx,offset string
    ;iterate over all string
    loopOverAllString:
        ;check end of string
        mov ah,' '
        cmp [bx],ah
        jnz notSpace
            mov si,bx
            shiftStr:
            mov ah,[si+1]
            mov [si],ah
            mov ah,'$'
            cmp [si],ah
            jz loopOverAllString
            inc si
            jnz shiftStr
    jmp loopOverAllString
    notSpace:
    movBXToEnd:
    mov ah,'$'
    cmp [bx],ah
    jz loopOverAllStringEnd
    inc bx
    jnz movBXToEnd
    loopOverAllStringEnd:
        dec bx
        ;check end of string
        mov ah,' '
        cmp [bx],ah
        jnz notSpaceEND
            mov si,bx
            shiftStrEND:
            mov ah,[si+1]
            mov [si],ah
            mov ah,'$'
            cmp [si],ah
            jz loopOverAllStringEnd
            inc si
            jnz shiftStrEND
    jmp loopOverAllStringEnd
    notSpaceEND:
    ret
trimSpacesDest endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validateRegisterDest proc                                               
    mov cx,30   ;;iterate on on 30 byte of Names==> ax bx ..dh dl
    mov dx,word ptr regName
    mainLoopVR:
        mov bx,cx
        mov ax,Names[bx]   ;;get the register with index bx from end to begin
        cmp ax,dx         ;;compare with input register
        jz found
        dec cx     ;dec cx by 2 ==>1 word
    loop mainLoopVR
    found:
    mov ax,Names  ;ax points to the first reg ('ax')
    cmp ax,dx
    jnz NotFirst
        mov ax,word ptr offsets   ;get first word of offset array
        mov destination,ax
        jmp exit_vr
    NotFirst:
    mov ax,0
    cmp cx,ax
    jz notFound
        mov bx,cx          ;;founded
        mov ax,word ptr offsets[bx]
        mov destination,ax
        jmp exit_vr
    notFound:
        mov flagdst,1  ;;set flag to 1 which indicates isNot Found
    exit_vr:
    ret
validateRegisterDest endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validateMemoryDest proc   
    mov bx,offset regName                    
    mov si,offset regName                    
    GoToStringEnd:                           
        mov ah,'$'                           
        cmp [si],ah                          
        inc si                               
        mov ah,'$'                           
        cmp [si],ah                          
    jnz GoToStringEnd                        
    dec si                                   
    mov ah,'['                               
    cmp [bx],ah                              
    jnz compareEnd                           
        mov ah,']'                           
        cmp [si],ah                          
        jnz notValidSquare                   
        jmp WithSquareBracktes               
        compareEnd:                          
        mov ah,']'                           
        cmp [si],ah                          
        jz notValidSquare                    
        jmp noSqaure                         
    notValidSquare: mov flagdst,0001h        
    jmp VmemExit                             
    WithSquareBracktes:                      
    inc bx                                   
    mov ah,'$'                               
    mov [si],ah                              
    PUSHA                                  
    call validateNumbers             
    POPA                                   
    jmp VmemExit                             
    noSqaure:                                
    PUSHA                                  
    call validateNumbers              
    POPA                                   
    VmemExit:                                
    mov destination,bx                       
    ret
validateMemoryDest endp                                         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validateRegisterDirectDest proc
    mov dx,word ptr regName+1                                               
    call validateRegisterRDProc                            
    mov bx,word ptr regName+1                                               
    mov ax, 'xb'                                                            
    ; if regName == 'BX'                                                    
    cmp ax, bx                                                              
        jz foundRD                                                          
    mov ax, 'is'                                                            
    ; if regName == 'SI'                                                    
    cmp ax, bx                                                              
        jz foundRD                                                          
    mov ax, 'id'                                                            
    ; if regName == 'DI'                                                    
    cmp ax, bx                                                              
        jz foundRD                                                          
    jmp notFoundRD                                                          
    ; if valid register dircet mode [BX],[SI],[DI]                          
    foundRD:                                                                
        mov di,destination                                                  
        mov bx,[di]                                                         
        mov di,offset destination                                           
        mov [di],bx                                                         
        jmp exit_vrd                                                        
    notFoundRD:                                                             
        mov flagdst,01h                                                     
    exit_vrd:           
    ret                                                    
validateRegisterDirectDest endp                                                                        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validateRegisterRDProc proc                                               
    mov cx,30   ;;iterate on on 30 byte of Names==> ax bx ..dh dl              
    mov dx,word ptr regName+1                                     
    mainLoopDestRegDirect:
        mov bx,cx                                                              
        mov ax,Names[bx]   ;;get the register with index bx from end to begin  
        cmp ax,dx         ;;compare with input register               
        jz foundDestRegDirect                                           
        dec cx     ;dec cx by 2 ==>1 word                             
    loop mainLoopDestRegDirect                                          
    foundDestRegDirect:                                                            
    mov ax,Names  ;ax points to the first reg ('ax')                  
    cmp ax,dx                                                         
    jnz NotFirstDestRegDirect
        mov ax,word ptr offsets   ;get first word of offset array     
        mov destination,ax                                            
        jmp exit_vr
    NotFirstDestRegDirect:                                                         
    mov ax,0    ;check if reach to the  beggining of array or not     
    cmp cx,ax                                                         
    jz notFoundDestRegDirect
        mov bx,cx          ;;founded                                  
        mov ax,word ptr offsets[bx]                                   
        mov destination,ax                                            
        jmp exit_vrDestRegDirect
    notFoundDestRegDirect:                                                         
        mov flagdst,1  ;;set flag to 1 which indicates isNot Found
    exit_vrDestRegDirect:                                                          
    ret
validateRegisterRDProc endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
convertStrHexaDest proc 
                mov si,destination
                ;lea   si,string
                ;lea   di,hexaWord    ;converted string to hexadecimal
    mainLoopHexa:
                mov ah,24h              ;to avoid dbox khara error :3
                cmp   [si],ah       ;check if char is $
                jz    exitHexa           ;if ture ==>end
                mov   dl,[si]        ;assci of current char
                mov ah,40h
                cmp dl,40h          ;compare if digit from 0-9
                jbe   from_zero_nine    ;jump to get hexadecimal of digit
                sub dl,61h  ;  get hexa of  digit (A==>F)
                add dl,10
                jmp   skip  ; jump to skip (0-->9)
    from_zero_nine:
                sub dl,30h
    skip:
                mov [si],dl ; assignment value of dl to string
                inc si   ; points to the next digit
                jmp   mainLoopHexa  ;iterate till  $
    exitHexa:
    mov si,destination       ;;conctenate the final answer ==> 01 02 00 0f $as exmaple ==>should be 120f
    mov bx,10h             ;; ax 00 01 => 00 10 => 00  12 => 01 20=> 12 0f
    mov al,[si]
    mov ah,0
    mov cl,'$'

    cmp al,cl
    jz Outloop
    inc si
    LOOPMain:
        mov dl,[si]
        cmp dl,cl
        jz Outloop
            mul bx
            add al,[si]
            inc si
    jmp LOOPMain
    Outloop:
    mov si,destination
    mov [si],ax
    ret
convertStrHexaDest endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validateNumbers proc                             
    mov bx,bx                                               
    loopOverAllStringNumbers:                     
        mov ah,'$'                         
        cmp [bx],ah                        
        jz stringEnd                       
        mov ax,[bx]                        
        mov ah,0                           
        sub ax,'0'                         
        cmp ax,000Fh                       
        jbe validNumber                    
            mov ax,[bx]                    
            mov ah,0                       
            sub ax,'a'                     
            cmp ax,0005h                   
            jbe validNumber                
            mov flagdst,0001h                 
            jmp stringEnd                  
        validNumber:                       
        inc bx                             
    jmp loopOverAllStringNumbers                  
    stringEnd:
    ret                             
validateNumbers endp                                        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sourceCheck proc  
    mov al,whichRegisterToExecute
    mov dl,0    ;other
    cmp al,dl
    jnz SCNotEqualZero
    call otherOffsetSetter 
    jmp SCEXITCHECKEXECUTE
    
    SCNotEqualZero:
    call offsetSetter 

    SCEXITCHECKEXECUTE:

    call lowercaseSRC                                                 
    ; trim spaces => begining and start                              
    call trimSpacesSRC
    mov dx,word ptr SrcStr
    pusha
    call validateRegisterSRC                    
    mov typeOfSource,0h
    popa
    mov ah,1                                                         
    cmp flag,ah                                                      
    jnz jmpDonesourceCheck                                                      
        jmp continuesourceCheck                                                 
    jmpDonesourceCheck: jmp exitsrcsourceCheck                                             
        continuesourceCheck:                                                    
        mov flag,0ffh
        pusha
        call validateMemorySrc
        popa
        mov ah,1                                                     
        cmp flag,ah
        jnz jmpFixsourceCheck
        jmp validateRegrDtsourceCheck
            jmpFixsourceCheck: jmp memtsourceCheck
        validateRegrDtsourceCheck:
            mov flag,0ffh
            pusha
            call validateRegisterDirectSource
            popa
            mov ah,1                                                                        
            cmp flag,ah                                                                     
            mov typeOfSource,03h
            jmp exitsrcsourceCheck
        memtsourceCheck: call Hexaaa
    exitsrcsourceCheck:                                       
    ret
sourceCheck endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lowercaseSRC proc
    lea si,SrcStr     ;poitns to the 1st char of string
    mainLoopSRC:
    mov dh,24h  ;;check if $ or not
    cmp [si],dh
    jz exitLcaseSRC         ;if equal to $ ---> terminate
    mov dh,91       ;;to skip square brackt([)]
    cmp [si],dh
    jz openPractSRC
    mov dh,93
    cmp [si],dh
    jz closePractSRC  ;;to avoid square brcket (])
    mov al,[si]
    mov dh,97       ;;convert to upper to lower case
    cmp al,dh
    or al,32        ;or with ascci in string
    mov [si],al     ; lower character will be placed
    closePractSRC:
    openPractSRC:
    inc si      ;points to the next char
    jmp mainLoopSRC  ;iterate till $
    exitLcaseSRC: ; end if =$
    ret
lowercaseSRC endp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
trimSpacesSRC proc
  mov bx, offset SrcStr
  ;iterate over all string                        
  loopOverAllStringSRC:                              
  ;check end of string                        
  mov ah,' '
  cmp [bx],ah
  jnz notSpaceSRC
  mov si,bx
  shiftStrSRC:
  mov ah,[si+1]
  mov [si],ah
  mov ah,'$'
  cmp [si],ah
  jz loopOverAllStringSRC
  inc si
  jnz shiftStrSRC
  jmp loopOverAllStringSRC
  notSpaceSRC:
  movBXToEndSRC:                                     
  mov ah,'$'                                      
  cmp [bx],ah                                     
  jz loopOverAllStringEndSRC
  inc bx
  jnz movBXToEndSRC
  loopOverAllStringEndSRC:                           
  dec bx
  ;check end of string
  mov ah,' '
  cmp [bx],ah
  jnz notSpaceENDSRC
  mov si,bx
  shiftStrENDSRC:                            
  mov ah,[si+1]                           
  mov [si],ah                             
  mov ah,'$'                              
  cmp [si],ah                             
  jz loopOverAllStringEndSRC                 
  inc si                                  
  jnz shiftStrENDSRC                         
  jmp loopOverAllStringEndSRC                        
  notSpaceENDSRC:                                    
  ret
trimSpacesSRC endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validateRegisterSRC proc 
    mov cx,30   ;;iterate on on 30 byte of Names==> ax bx ..dh dl            
    mov dx,word ptr SrcStr         
    mainLoopVRsrc:
        mov bx,cx                                                            
        mov ax,Names[bx]   ;;get the register with index bx from end to begin
        cmp ax,dx         ;;compare with input register                  
        jz foundVRsrc
        dec cx     ;dec cx by 2 ==>1 word                                    
    loop mainLoopVRsrc
    foundVRsrc:                                                                   
    mov ax,Names  ;ax points to the first reg ('ax')                         
    cmp ax,dx
    jnz NotFirstVRsrc
        mov ax,word ptr offsets   ;get first word of offset array            
        mov source,ax                                                        
        jmp exit_vrVRsrc
    NotFirstVRsrc:                                                                
    mov ax,0    ;check if reach to the  beggining of array or not            
    cmp cx,ax                                                                
    jz notFoundVRsrc
        mov bx,cx          ;;founded                                         
        mov ax,word ptr offsets[bx]                                          
        mov source,ax                                                        
        jmp exit_vrVRsrc                                                        
    notFoundVRsrc:                                                                
        mov flag,1  ;;set flag to 1 which indicates isNot Found              
    exit_vrVRsrc:       
    ret                                                          
validateRegisterSRC endp                                                                         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validateMemorySrc proc                                             
    mov di,offset SrcStr                                
    mov si,offset SrcStr
    GoToStringEndVMSRC:                                      
        mov ah,'$'                                      
        cmp [si],ah                                     
        inc si                                          
        mov ah,'$'                                      
        cmp [si],ah                                     
    jnz GoToStringEndVMSRC                                   
    dec si
    mov ah,'['                                          
    cmp [di],ah                                         
    jnz compareEndVMSRC                                      
        mov ah,']'                                      
        cmp [si],ah                                     
        jnz notValidSquareVMSRC                              
        jmp WithSquareBracktesVMSRC                          
        compareEndVMSRC:                                     
        mov ah,']'                                      
        cmp [si],ah                                     
        jz notValidSquareVMSRC                               
        jmp noSqaureVMSRC                                    
    notValidSquareVMSRC: mov flag,0001h                      
    jmp exitVmemSrc                                     
    WithSquareBracktesVMSRC:                                 
    mov typeOfSource,01h
    inc di                                              
    mov ah,'$'                                          
    mov [si],ah                                         
    PUSHA                                             
    call validateNumbersSrc                             
    POPA                                              
    jmp exitVmemSrc                                     
    noSqaureVMSRC:                                           
    mov typeOfSource,02h
    PUSHA                                             
    call validateNumbersSrc                             
    POPA                                              
    exitVmemSrc:                                        
    mov source,di
    ret                                       
validateMemorySrc endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validateNumbersSrc proc      
    mov bx,di              
    loopOverAllStringNumSRC:         
        mov ah,'$'             
        cmp [bx],ah            
        jz stringEndNumSRC           
        mov ax,[bx]            
        mov ah,0               
        sub ax,'0'             
        cmp ax,000Fh           
        jbe validNumberSRC        
            mov ax,[bx]        
            mov ah,0           
            sub ax,'a'         
            cmp ax,0005h       
            jbe validNumberSRC    
            mov flag,0001h     
            jmp stringEndNumSRC      
        validNumberSRC:           
        inc bx                 
    jmp loopOverAllStringNumSRC      
    stringEndNumSRC:     
    ret            
validateNumbersSrc endp  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validateRegisterDirectSource proc
    mov dx,word ptr SrcStr+1
    call validateRegisterRDSRC
    mov bx,word ptr SrcStr+1
    mov ax, 'xb'                                         
    ; if regName == 'BX'                                 
    cmp ax, bx                                           
        jz foundRDSRC
    mov ax, 'is'                                         
    ; if regName == 'SI'                                 
    cmp ax, bx                                           
        jz foundRDSRC
    mov ax, 'id'                                         
    ; if regName == 'DI'                                 
    cmp ax, bx                                           
        jz foundRDSRC
    jmp notFoundRDSRC                                       
    ; if valid register dircet mode [BX],[SI],[DI]       
    foundRDSRC:                                             
        mov di,source                                    
        mov bx,[di]                                      
        mov di,offset source                             
        mov [di],bx                                      
        jmp exit_vrdSRC                                     
    notFoundRDSRC:                                          
        mov flag,01h                                     
    exit_vrdSRC:                                            
    ret
validateRegisterDirectSource endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validateRegisterRDSRC proc 
    mov cx,30   ;;iterate on on 30 byte of Names==> ax bx ..dh dl            
    mov dx,word ptr SrcStr+1         
    mainLoopVRsrcRD:
        mov bx,cx                                                            
        mov ax,Names[bx]   ;;get the register with index bx from end to begin
        cmp ax,dx         ;;compare with input register                  
        jz foundVRsrcRD
        dec cx     ;dec cx by 2 ==>1 word                                    
    loop mainLoopVRsrcRD
    foundVRsrcRD:                                                                   
    mov ax,Names  ;ax points to the first reg ('ax')                         
    cmp ax,dx
    jnz NotFirstVRsrcRD
        mov ax,word ptr offsets   ;get first word of offset array            
        mov source,ax                                                        
        jmp exit_vrVRsrcRD
    NotFirstVRsrcRD:                                                                
    mov ax,0    ;check if reach to the  beggining of array or not            
    cmp cx,ax                                                                
    jz notFoundVRsrcRD
        mov bx,cx          ;;founded                                         
        mov ax,word ptr offsets[bx]                                          
        mov source,ax                                                        
        jmp exit_vrVRsrcRD
    notFoundVRsrcRD:                                                                
        mov flag,1  ;;set flag to 1 which indicates isNot Found
    exit_vrVRsrcRD:       
    ret                                                          
validateRegisterRDSRC endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Hexaaa proc
  mov si,source
  ;lea   si,string
  ;lea   di,hexaWord    ;converted string to hexadecimal
  mainLoopHexaSrc:
    mov ah,24h              ;to avoid dbox khara error :3
    cmp   [si],ah       ;check if char is $
    jz    exitHexaHexaSrc           ;if ture ==>end
    mov   dl,[si]        ;assci of current char
    mov ah,40h
    cmp dl,40h          ;compare if digit from 0-9
    jbe   from_zero_nineHexaSrc    ;jump to get hexadecimal of digit
    sub dl,61h  ;  get hexa of  digit (A==>F)
    add dl,10
    jmp   skipHexaSrc  ; jump to skip (0-->9)
  from_zero_nineHexaSrc:
      sub dl,30h
  skipHexaSrc:
      mov [si],dl ; assignment value of dl to string
      inc si   ; points to the next digit
      jmp   mainLoopHexaSrc  ;iterate till  $
    exitHexaHexaSrc:
    mov si,source       ;;conctenate the final answer ==> 01 02 00 0f $as exmaple ==>should be 120f
    mov bx,10h             ;; ax 00 01 => 00 10 => 00  12 => 01 20=> 12 0f
    mov al,[si]
    mov ah,0
    mov cl,'$'
    cmp al,cl
    jz OutloopHexaSrc
    inc si
    LOOPMainHexaSrc:
        mov dl,[si]
        cmp dl,cl
        jz OutloopHexaSrc
            mul bx
            add al,[si]
            inc si
    jmp LOOPMainHexaSrc
    OutloopHexaSrc:
    mov si,source
    mov [si],ax
    ret
Hexaaa endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WantedValueToNumber proc
  mov cl,newWantedValueActualSize
  mov ch,0
  lea bx,newWantedValue
  add bx,cx
  mov al,'$'
  mov [bx],al

  mov si,offset newWantedValue
  mainLoopHexaWVTN:
  mov ah,24h              ;to avoid dbox khara error :3
  cmp   [si],ah       ;check if char is $
  jz    exitHexaHexaWVTN           ;if ture ==>end
  mov   dl,[si]        ;assci of current char
  mov ah,40h
  cmp dl,40h          ;compare if digit from 0-9
  jbe   from_zero_nineHexaWVTN    ;jump to get hexadecimal of digit
  sub dl,61h  ;  get hexa of  digit (A==>F)
  add dl,10
  jmp   skipHexaWVTN  ; jump to skip (0-->9)
  from_zero_nineHexaWVTN:
    sub dl,30h
  skipHexaWVTN:
    mov [si],dl ; assignment value of dl to string
    inc si   ; points to the next digit
    jmp   mainLoopHexaWVTN  ;iterate till  $
  exitHexaHexaWVTN:
  mov si,offset newWantedValue       ;;conctenate the final answer ==> 01 02 00 0f $as exmaple ==>should be 120f
  mov bx,10h             ;; ax 00 01 => 00 10 => 00  12 => 01 20=> 12 0f
  mov al,[si]
  mov ah,0
  mov cl,'$'
  cmp al,cl
  jz OutloopHexaWVTN
  inc si
  LOOPMainHexaWVTN:
      mov dl,[si]
      cmp dl,cl
      jz OutloopHexaWVTN
          mul bx
          add al,[si]
          inc si
  jmp LOOPMainHexaWVTN
  OutloopHexaWVTN:
  mov si,offset newWantedValue
  mov [si],ax
  ret
WantedValueToNumber endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Draw functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;function to draw the background color of the main screen
drawBackGround proc
  rowLoop:
  mov ah, 0ch    ;write pixels on screen
  mov bh, 0      ;page
  mov dx, row    ;row
  mov cx, col    ;column
  mov al, BLACK   ;colour
  int 10h
  ;need to mov the row 
  inc col
  mov ax,col
  mov dx,320d
  cmp ax,dx
  jnz rowLoop
  mov col,0
  inc row
  mov ax,row
  mov dx,200d
  cmp ax,dx
  jnz rowLoop
  mov row,0
  mov col,0
  ret
drawBackGround endp
; draw bullet
drawBullet proc
  mov cx, gunStartColumnPosition  ; column iterator starts at gunStartColumnPositionOther
  add cx, 10d                     ; half width of gun
  mov bulletStartColumnPosition, cx
  mov colBullet, cx
  add cx, bulletWidth
  mov bulletEndColumnPosition, cx      ; end of bullet column = gunStartColumnPositionOther+ bullet width
  
  mov ax, bulletStartColumnPosition
  mov rowBullet, ax
  RemoverowLoopBullet:
    mov ah, 0ch                     ;write pixels on screen
    mov bh, 0                       ;page
    mov dx, bulletStartRowPosition    ;row
    mov cx, rowBullet    ;column
    mov al, BLACK          ;colour
    int 10h
    inc rowBullet
    mov ax,rowBullet
    cmp ax,bulletEndColumnPosition
  jnz RemoverowLoopBullet

  ;intialization of other iterators
  mov cx, gunStartColumnPositionOther  ; column iterator starts at gunStartColumnPositionOther
  add cx, 10d                     ; half width of gun
  mov bulletStartColumnPositionOther, cx
  mov colBullet, cx
  add cx, bulletWidth
  mov bulletEndColumnPositionOther, cx      ; end of bullet column = gunStartColumnPositionOther+ bullet width
  
  mov ax, bulletStartColumnPositionOther
  mov rowBullet, ax
  RemoverowLoopBulletOther:
    mov ah, 0ch                            ;write pixels on screen
    mov bh, 0                              ;page
    mov dx, bulletStartRowPositionOther    ;row
    mov cx, rowBullet                      ;column
    mov al, BLACK                          ;colour
    int 10h
    inc rowBullet
    mov ax,rowBullet
    cmp ax,bulletEndColumnPositionOther
  jnz RemoverowLoopBulletOther

  ;Intialization of my iterators
  mov cx, gunStartColumnPosition  ; column iterator starts at gunStartColumnPositionOther
  add cx, 10d                     ; half width of gun
  mov bulletStartColumnPosition, cx
  mov colBullet, cx
  add cx, bulletWidth
  mov bulletEndColumnPosition, cx      ; end of bullet column = gunStartColumnPositionOther+ bullet width
  
  mov ax, bulletStartRowPosition
  sub ax, bulletWidth
  mov rowBullet, ax 
  ;start drawing of my bullet
  rowLoopBullet:
  mov ah, 0ch    ;write pixels on screen
  mov bh, 0      ;page
  mov dx, rowBullet    ;row
  mov cx, colBullet    ;column
  mov al, WHITE     ;colour
  int 10h
  ;need to mov the row 
  inc colBullet
  mov ax,colBullet
  mov dx,bulletEndColumnPosition
  ; add dx, gunWidth
  cmp ax,dx
  jnz rowLoopBullet

  mov ax,bulletStartColumnPosition
  mov colBullet,ax
  inc rowBullet
  mov ax,rowBullet
  mov dx,bulletStartRowPosition
  cmp ax,dx
  jnz rowLoopBullet

  ; Draw other bullet
  ;Intialization of other iterators
  mov cx, gunStartColumnPositionOther  ; column iterator starts at gunStartColumnPositionOther
  add cx, 10d                     ; half width of gun
  mov bulletStartColumnPositionOther, cx
  mov colBullet, cx
  add cx, bulletWidth
  mov bulletEndColumnPositionOther, cx      ; end of bullet column = gunStartColumnPositionOther+ bullet width
  
  mov ax, bulletStartRowPositionOther
  sub ax, bulletWidth
  mov rowBullet, ax 
  ; Start drawing
  rowLoopBulletOther:
  mov ah, 0ch    ;write pixels on screen
  mov bh, 0      ;page
  mov dx, rowBullet    ;row
  mov cx, colBullet    ;column
  mov al, WHITE     ;colour
  int 10h

  ;need to mov the row 
  inc colBullet
  mov ax,colBullet
  mov dx,bulletEndColumnPositionOther
  ; add dx, gunWidth
  cmp ax,dx
  jnz rowLoopBulletOther

  mov ax,bulletStartColumnPositionOther
  mov colBullet,ax
  inc rowBullet
  mov ax,rowBullet
  mov dx,bulletStartRowPositionOther
  cmp ax,dx
  jnz rowLoopBulletOther
  ret
drawBullet endp
; draw gun
drawGun proc
  mov colGun,0
  mov rowGun, 80d
  RemoverowLoop:
    mov ah, 0ch                          ;write pixels on screen
    mov bh, 0                            ;page
    mov dx, rowGun                    ;row
    mov cx, gunStartColumnPosition    ;column
    dec cx
    mov al, BLACK   ;colour
    int 10h

    mov ah, 0ch                          ;write pixels on screen
    mov bh, 0                            ;page
    mov dx, rowGun                    ;row
    mov cx, gunStartColumnPosition    ;column
    add cx, gunWidth
    mov al, BLACK   ;colour
    int 10h
    inc rowGun
    mov ax, rowGun
    cmp ax, 90d
  jnz RemoverowLoop

  mov colGun,0
  mov rowGun, 80d
  RemoverowLoopOther:
    mov ah, 0ch                            ;write pixels on screen
    mov bh, 0                              ;page
    mov dx, rowGun                         ;row
    mov cx, gunStartColumnPositionOther    ;column
    dec cx
    mov al, BLACK   ;colour
    int 10h

    mov ah, 0ch                            ;write pixels on screen
    mov bh, 0                              ;page
    mov dx, rowGun                         ;row
    mov cx, gunStartColumnPositionOther    ;column
    add cx, gunWidth
    mov al, BLACK   ;colour
    int 10h
    inc rowGun
    mov ax, rowGun
    cmp ax, 90d
  jnz RemoverowLoopOther

  mov rowGun,80d


  mov ax, gunStartColumnPosition
  mov colGun, ax
  
  rowLoopGun:
  mov ah, 0ch    ;write pixels on screen
  mov bh, 0      ;page
  mov dx, rowGun    ;row
  mov cx, colGun    ;column
  mov al, LBLUE     ;colour
  int 10h

  ;need to mov the row 
  inc colGun
  mov ax,colGun
  mov dx,gunStartColumnPosition
  add dx, gunWidth
  cmp ax,dx
  jnz rowLoopGun

  mov ax,gunStartColumnPosition
  mov colGun,ax
  inc rowGun
  mov ax,rowGun
  mov dx,gunEndRowPosition
  cmp ax,dx
  jnz rowLoopGun

  mov rowGun,80d
  mov colGun,0


  mov rowGun,80d
  mov ax, gunStartColumnPositionOther
  mov colGun, ax
  
  rowLoopGunOther:
  mov ah, 0ch    ;write pixels on screen
  mov bh, 0      ;page
  mov dx, rowGun    ;row
  mov cx, colGun    ;column
  mov al, LBLUE     ;colour
  int 10h

  ;need to mov the row 
  inc colGun
  mov ax,colGun
  mov dx,gunStartColumnPositionOther
  add dx, gunWidth
  cmp ax,dx
  jnz rowLoopGunOther

  mov ax,gunStartColumnPositionOther
  mov colGun,ax
  inc rowGun
  mov ax,rowGun
  mov dx,gunEndRowPosition
  cmp ax,dx
  jnz rowLoopGunOther

  mov rowGun,80d
  mov colGun,0
  ret
drawGun endp
; darw target
drawTarget proc
  mov rowTarget,0 
  RemoverowLoopTarget:
    mov ah, 0ch                          ;write pixels on screen
    mov bh, 0                            ;page
    mov dx, rowTarget                    ;row
    mov cx, targetStartColumnPosition    ;column
    add cx, targetWidth
    mov al, BLACK   ;colour
    int 10h
    inc rowTarget
    mov ax, rowTarget
    cmp ax, 07d
  jnz RemoverowLoopTarget

  mov rowTarget,0
  mov colTarget,0
  rowLastTarget:
  mov ah, 0ch    ;write pixels on screen
  mov bh, 0      ;page
  mov dx, rowTarget    ;row
  mov cx, colTarget  ;column
  mov al, BLACK   ;colour
  int 10h
  ;need to mov the row 
  inc colTarget
  mov ax,colTarget
  mov dx,targetWidth
  cmp ax,dx
  jnz rowLastTarget
  mov colTarget,0
  inc rowTarget
  mov ax,rowTarget
  mov dx,targetWidth
  cmp ax,dx
  jnz rowLastTarget
  mov rowTarget,0
  mov colTarget,0
  
  mov rowTarget,0
  mov colTarget,163d
  rowLastTargetOther:
  mov ah, 0ch    ;write pixels on screen
  mov bh, 0      ;page
  mov dx, rowTarget  ;row
  mov cx, colTarget  ;column
  mov al, BLACK   ;colour
  int 10h
  ;need to mov the row 
  inc colTarget
  mov ax,colTarget
  mov dx,targetWidth
  add dx,163d
  cmp ax,dx
  jnz rowLastTargetOther
  mov colTarget,163d
  inc rowTarget
  mov ax,rowTarget
  mov dx,targetWidth
  cmp ax,dx
  jnz rowLastTargetOther
  mov rowTarget,0
  mov colTarget,0

  mov rowTarget,0d
  RemoverowLoopOtherTarget:
    mov ah, 0ch                          ;write pixels on screen
    mov bh, 0                            ;page
    mov dx, rowTarget                    ;row
    mov cx, targetStartColumnPositionOther    ;column
    add cx, targetWidth
    mov al, BLACK   ;colour
    int 10h
    inc rowTarget
    mov ax, rowTarget
    cmp ax, 07d
  jnz RemoverowLoopOtherTarget

  mov rowTarget,0d

  ;Draw my target
  mov ax, targetStartColumnPosition
  mov colTarget, ax
  
  rowLoopMyTarget:
  mov ah, 0ch    ;write pixels on screen
  mov bh, 0      ;page
  mov dx, rowTarget    ;row
  mov cx, colTarget    ;column
  mov al, targetColor     ;colour
  int 10h

  ;need to mov the row 
  inc colTarget
  mov ax,colTarget
  mov dx,targetStartColumnPosition
  add dx, targetWidth
  cmp ax,dx
  jnz rowLoopMyTarget

  mov ax,targetStartColumnPosition
  mov colTarget,ax
  inc rowTarget
  mov ax,rowTarget
  mov dx,targetEndRowPosition
  cmp ax,dx
  jnz rowLoopMyTarget

  ;Draw other player target
  mov rowTarget,0d
  mov ax, targetStartColumnPositionOther
  mov colTarget, ax

  rowLoopOtherTarget:
  mov ah, 0ch    ;write pixels on screen
  mov bh, 0      ;page
  mov dx, rowTarget    ;row
  mov cx, colTarget    ;column
  mov al, targetColor     ;colour
  int 10h

  ;need to mov the row 
  inc colTarget
  mov ax,colTarget
  mov dx,targetStartColumnPositionOther
  add dx, targetWidth
  cmp ax,dx
  jnz rowLoopOtherTarget

  mov ax,targetStartColumnPositionOther
  mov colTarget,ax
  inc rowTarget
  mov ax,rowTarget
  mov dx,targetEndRowPosition
  cmp ax,dx
  jnz rowLoopOtherTarget
  mov rowTarget, 0d
  ret
drawTarget endp
;function to draw a given char at given location with given color
drawCharWithGivenVar  proc
  ;set the cursur
  mov ah,2
  mov dl,charToDrawx      ;x
  mov dh,charToDrawy      ;y
  mov bh,0
  int 10h
  ;draw the char
  mov  al, charToDraw
  mov  bl, charToDrawColor
  mov  bh, 0                ;Display page
  mov  ah, 0Eh              ;Teletype
  int  10h
  ret
drawCharWithGivenVar endp
;function to draw memory lines (called once at the begining)
drawMemoryLines proc
  ;draw the memory lines
  mov linex,125d
  call drawLine
  mov linex,147d
  call drawLine
  mov linex,162d
  call drawLine
  mov linex,287d
  call drawLine
  mov linex,307d
  call drawLine
  mov liney,130d
  call drawLineHorizontal
  mov liney,180d
  call drawLineHorizontal
  mov liney,150d
  call drawLineHorizontal

  mov linex,162d
  mov di,130d
  LineLoopSmall:
  mov ah, 0ch     ;write pixels on screen
  mov bh, 0       ;page
  mov dx, di      ;row
  mov cx, linex   ;column
  mov al, WHITE   ;colour
  int 10h
  inc di
  mov ax,150d
  cmp di,ax
  jnz LineLoopSmall
  ret
drawMemoryLines endp
drawLine proc
  mov di,0
  LineLoop:
  mov ah, 0ch     ;write pixels on screen
  mov bh, 0       ;page
  mov dx, di      ;row
  mov cx, linex   ;column
  mov al, WHITE   ;colour
  int 10h
  inc di
  mov ax,130d
  cmp di,ax
  jnz LineLoop
  ret
drawLine endp
drawLineHorizontal proc 
  mov di,0
  HLineLoop:
  mov ah, 0ch     ;write pixels on screen
  mov bh, 0       ;page
  mov dx, liney      ;row
  mov cx, di   ;column
  mov al, WHITE   ;colour
  int 10h
  inc di
  mov ax,320d
  cmp di,ax
  jnz HLineLoop
  ret
drawLineHorizontal endp
;function to draw the register names (AX,BX,..etc)
drawRegNames proc
  ;draw my
  mov charToDraw,'A'
  mov charToDrawColor,WHITE
  mov charToDrawx,0
  mov al,myAXy
  mov charToDrawy,al
  call drawCharWithGivenVar
  ;draw other
  mov charToDrawx,15h
  call drawCharWithGivenVar
  mov charToDraw,'X'
  inc charToDrawx
  call drawCharWithGivenVar
  mov charToDrawx,1
  call drawCharWithGivenVar

  ;draw my
  mov charToDraw,'B'
  mov charToDrawColor,WHITE
  mov charToDrawx,0
  mov al,myBXy
  mov charToDrawy,al
  call drawCharWithGivenVar
  ;draw other
  mov charToDrawx,15h
  call drawCharWithGivenVar
  mov charToDraw,'X'
  inc charToDrawx
  call drawCharWithGivenVar
  mov charToDrawx,1
  call drawCharWithGivenVar

  ;draw my
  mov charToDraw,'C'
  mov charToDrawColor,WHITE
  mov charToDrawx,0
  mov al,myCXy
  mov charToDrawy,al
  call drawCharWithGivenVar
  ;draw other
  mov charToDrawx,15h
  call drawCharWithGivenVar
  mov charToDraw,'X'
  inc charToDrawx
  call drawCharWithGivenVar
  mov charToDrawx,1
  call drawCharWithGivenVar

  ;draw my
  mov charToDraw,'D'
  mov charToDrawColor,WHITE
  mov charToDrawx,0
  mov al,myDXy
  mov charToDrawy,al
  call drawCharWithGivenVar
  ;draw other
  mov charToDrawx,15h
  call drawCharWithGivenVar
  mov charToDraw,'X'
  inc charToDrawx
  call drawCharWithGivenVar
  mov charToDrawx,1
  call drawCharWithGivenVar

  ;draw my
  mov charToDraw,'S'
  mov charToDrawColor,WHITE
  mov charToDrawx,8
  mov al,mySIy
  mov charToDrawy,al
  call drawCharWithGivenVar
  ;draw other
  mov charToDrawx,1Dh
  call drawCharWithGivenVar
  mov charToDraw,'I'
  inc charToDrawx
  call drawCharWithGivenVar
  mov charToDrawx,9
  call drawCharWithGivenVar

  ;draw my
  mov charToDraw,'D'
  mov charToDrawColor,WHITE
  mov charToDrawx,8
  mov al,myDIy
  mov charToDrawy,al
  call drawCharWithGivenVar
  ;draw other
  mov charToDrawx,1Dh
  call drawCharWithGivenVar
  mov charToDraw,'I'
  inc charToDrawx
  call drawCharWithGivenVar
  mov charToDrawx,9
  call drawCharWithGivenVar

  ;draw my
  mov charToDraw,'S'
  mov charToDrawColor,WHITE
  mov charToDrawx,8
  mov al,mySPy
  mov charToDrawy,al
  call drawCharWithGivenVar
  ;draw other
  mov charToDrawx,1Dh
  call drawCharWithGivenVar
  mov charToDraw,'P'
  inc charToDrawx
  call drawCharWithGivenVar
  mov charToDrawx,9
  call drawCharWithGivenVar

  ;draw my
  mov charToDraw,'B'
  mov charToDrawColor,WHITE
  mov charToDrawx,8
  mov al,myBPy
  mov charToDrawy,al
  call drawCharWithGivenVar
  ;draw other
  mov charToDrawx,1Dh
  call drawCharWithGivenVar
  mov charToDraw,'P'
  inc charToDrawx
  call drawCharWithGivenVar
  mov charToDrawx,9
  call drawCharWithGivenVar
  ret
drawRegNames endp
;function to draw the memory adresses
drawMemoryAdresses proc 
mov charToDraw,'0'
mov charToDrawColor, LBLUE
mov charToDrawx,27h
mov charToDrawy,0
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'1'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'2'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'3'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'4'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'5'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'6'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'7'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'8'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'9'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'A'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'B'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'C'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'D'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'E'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'F'
inc charToDrawy
call drawCharWithGivenVar
mov charToDrawx,13h
call drawCharWithGivenVar
ret
drawMemoryAdresses endp
;function to convert the hexa number to string to display (need ax=num)
convertRegToStr proc
  lea si,RegStringToPrint
  mov bx,4096
  mov dx,0
  div bx
  ;dx=num
  ;al=num to print      
  lea bx, ASC_TBL
  XLAT
  mov [si],al
  inc si
  
  mov ax,dx
  mov dx,0
  mov bx,256
  div bx
  lea bx, ASC_TBL
  XLAT
  mov [si],al
  inc si

  mov ax,dx
  mov dx,0
  mov bx,16
  div bx
  ;al=num to print      
  lea bx, ASC_TBL
  XLAT
  mov [si],al
  inc si

  mov al,dl
  lea bx, ASC_TBL
  XLAT
  mov [si],al
  ret
convertRegToStr endp
;function to convert the hexa number to string to display (need al=num, ah=0)
convertMemToStr proc
  lea si,MemStringToPring
  mov bl,16d
  div bl
  ;al=num to print      
  lea bx, ASC_TBL
  XLAT
  mov [si],al
  inc si
  mov al,ah
  lea bx, ASC_TBL
  XLAT
  mov [si],al
  ret
convertMemToStr endp
;functions to draw my registers data
drawMyRegisters proc
  ;first we need to get the number (4-bytes) and covert it to char
  ;then move it to charToDraw and pick a color and postions then draw
  
  ;print AX
  mov ax,myRegisters
  call convertRegToStr
  mov al,myAXx
  mov printX,al
  mov al,myAXy
  mov printY,al
  call printRegWithGivenVar

  ;print BX
  mov ax,myRegisters+2
  call convertRegToStr
  mov al,myBXx
  mov printX,al
  mov al,myBXy
  mov printY,al
  call printRegWithGivenVar

  ;print CX
  mov ax,myRegisters+4
  call convertRegToStr
  mov al,myCXx
  mov printX,al
  mov al,myCXy
  mov printY,al
  call printRegWithGivenVar

  ;print DX
  mov ax,myRegisters+6
  call convertRegToStr
  mov al,myDXx
  mov printX,al
  mov al,myDXy
  mov printY,al
  call printRegWithGivenVar

  ;print SI
  mov ax,myRegisters+8
  call convertRegToStr
  mov al,mySIx
  mov printX,al
  mov al,mySIy
  mov printY,al
  call printRegWithGivenVar

  ;print DI
  mov ax,myRegisters+10d
  call convertRegToStr
  mov al,myDIx
  mov printX,al
  mov al,myDIy
  mov printY,al
  call printRegWithGivenVar

  ;print BP
  mov ax,myRegisters+12d
  call convertRegToStr
  mov al,myBPx
  mov printX,al
  mov al,myBPy
  mov printY,al
  call printRegWithGivenVar

  ;print SP
  mov ax,myRegisters+14d
  call convertRegToStr
  mov al,mySPx
  mov printX,al
  mov al,mySPy
  mov printY,al
  call printRegWithGivenVar
  ret
drawMyRegisters endp
;functions to draw other registers data
drawOtherRegisters proc
  ;print AX
  mov ax,OtherRegisters
  call convertRegToStr
  mov al,otherAXx
  mov printX,al
  mov al,otherAXy
  mov printY,al
  call printRegWithGivenVar

  ;print BX
  mov ax,otherRegisters+2
  call convertRegToStr
  mov al,otherBXx
  mov printX,al
  mov al,otherBXy
  mov printY,al
  call printRegWithGivenVar

  ;print CX
  mov ax,otherRegisters+4
  call convertRegToStr
  mov al,otherCXx
  mov printX,al
  mov al,otherCXy
  mov printY,al
  call printRegWithGivenVar

  ;print DX
  mov ax,otherRegisters+6
  call convertRegToStr
  mov al,otherDXx
  mov printX,al
  mov al,otherDXy
  mov printY,al
  call printRegWithGivenVar

  ;print SI
  mov ax,otherRegisters+8
  call convertRegToStr
  mov al,otherSIx
  mov printX,al
  mov al,otherSIy
  mov printY,al
  call printRegWithGivenVar

  ;print DI
  mov ax,otherRegisters+10d
  call convertRegToStr
  mov al,otherDIx
  mov printX,al
  mov al,otherDIy
  mov printY,al
  call printRegWithGivenVar

  ;print BP
  mov ax,otherRegisters+12d
  call convertRegToStr
  mov al,otherBPx
  mov printX,al
  mov al,otherBPy
  mov printY,al
  call printRegWithGivenVar

  ;print SP
  mov ax,otherRegisters+14d
  call convertRegToStr
  mov al,otherSPx
  mov printX,al
  mov al,otherSPy
  mov printY,al
  call printRegWithGivenVar
  ret
drawOtherRegisters endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printRegWithGivenVar proc
  mov al,printX
  mov charToDrawx,al
  mov al,printY
  mov charToDrawy,al
  mov charToDrawColor,YELLOW

  lea si,RegStringToPrint
  mov al,[si]
  mov charToDraw,al
  call drawCharWithGivenVar

  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  call drawCharWithGivenVar

  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  call drawCharWithGivenVar

  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  call drawCharWithGivenVar
  ret
printRegWithGivenVar endp
printMemWithGivenVar proc
  mov al,printX
  mov charToDrawx,al
  mov al,printY
  mov charToDrawy,al
  mov charToDrawColor,RED

  lea si,MemStringToPring
  mov al,[si]
  mov charToDraw,al
  call drawCharWithGivenVar

  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  call drawCharWithGivenVar
  ret
printMemWithGivenVar endp
;functions to draw my memory data
drawMyMemory proc
  lea di,myMemory
  mov cx,15d
  add di,cx
  MyMemLoop:
  mov ah,0
  mov al,[di]
  call convertMemToStr
  mov al,myMemx
  mov printX,al
  mov al,cl
  mov printY,al
  call printMemWithGivenVar
  dec di
  LOOP MyMemLoopH
  jmp myMemExit
  MyMemLoopH: jmp MyMemLoop
  myMemExit:

  mov ah,0
  mov al,[di]
  call convertMemToStr
  mov al,myMemx
  mov printX,al
  mov al,0
  mov printY,al
  call printMemWithGivenVar
  ret
drawMyMemory endp
;functions to draw other memory data
drawOtherMemory proc
  lea di,otherMemory
  mov cx,15d
  add di,cx
  OtherMemLoop:
  mov ah,0
  mov al,[di]
  call convertMemToStr
  mov al,otherMemx
  mov printX,al
  mov al,cl
  mov printY,al
  call printMemWithGivenVar
  dec di
  LOOP OtherMemLoopH
  jmp otherMemExit
  OtherMemLoopH: jmp OtherMemLoop
  otherMemExit:

  mov ah,0
  mov al,[di]
  call convertMemToStr
  mov al,otherMemx
  mov printX,al
  mov al,0
  mov printY,al
  call printMemWithGivenVar
  ret
drawOtherMemory endp
;function to print the two names
printTwoNames proc 
  ;set cursor
  mov ah,2
  mov dl,3h
  mov dh,0Dh
  mov bh,0
  int 10h
  ; print name
  lea dx,myName
  mov ah,9
  int 21h
  ;set cursor
  mov ah,2
  mov dl,18h
  mov dh,0Dh 
  mov bh,0
  int 10h
  ; print name
  lea dx,otherName
  mov ah,9
  int 21h

  mov al,4h 
  add al,myNameActualSize 
  mov myPointsX,al

  mov al,19h 
  add al,otherNameActualSize 
  mov otherPointsX,al
  ret
printTwoNames endp
;funtion to print the decimal number from hexa one
print3Decimal proc
  ;ah=0 , al=num
  mov bl,100
  div bl
  add al,30h    
  mov dh,ah
  mov ah,9
  mov bh,0 
  mov cx,1
  mov bl,RED
  int 10h
  mov di,dx
  ;get the cursor position
  mov ah,3h
  mov bh,0h
  int 10h
  inc dl
  ;move the cursor
  mov ah,2
  int 10h
  mov dx,di
  ;print the second digit
  mov ax,0
  mov al,dh
  mov bl,10
  div bl
  add al,30h    
  mov dh,ah
  mov ah,9
  mov bh,0 
  mov cx,1
  mov bl,RED
  int 10h 
  mov di,dx
  ;get the cursor position
  mov ah,3h
  mov bh,0h
  int 10h
  inc dl
  ;move the cursor
  mov ah,2
  int 10h 
  mov dx,di
  ;print the third digit
  mov dl,dh
  add dl,30h
  mov al,dl
  mov ah,9
  mov bh,0 
  mov cx,1
  mov bl,RED
  int 10h
  ret
print3Decimal endp
print2Decimal proc
  ;ah=0 , al=num , si = color
  ;print the first digit
  mov bl,10
  div bl
  mov di,ax
  add al,30h    
  mov ah,9 
  mov cx,1
  mov bx,si
  int 10h 
  ;get the cursor position
  mov ah,3h
  mov bh,0h
  int 10h
  inc dl
  ;move the cursor
  mov ah,2
  int 10h
  ;print the second digit
  mov ax,di
  mov cl,8
  shr ax,cl
  add al,30h
  mov ah,9
  mov cx,1
  mov bx,si
  int 10h
  ret
print2Decimal endp
;function to draw the two players points
printTwoPoints proc
  ;convert myPointValue to decimal then print it
  ;set the cursor
  mov ah,2
  mov dl,myPointsX
  mov dh,0Dh
  mov bh,0
  int 10h
  ;print the first digit
  mov ax,0
  mov al,myPointsValue
  call print3Decimal

  ;print other points
  ;set the cursor
  mov ah,2
  mov dl,otherPointsX
  mov dh,0Dh
  mov bh,0
  int 10h
  ;print the first digit
  mov ax,0
  mov al,otherPointsValue
  call print3Decimal
  ret
printTwoPoints endp
;function to print commands
printCommands proc
  ;set cursor
  mov ah,2
  mov dl,2h
  mov dh,11h
  mov bh,0
  int 10h
  ; print name
  lea dx,myCommand
  mov ah,9
  int 21h
  ;set cursor
  mov ah,2
  mov dl,16h
  mov dh,11h 
  mov bh,0
  int 10h
  ; print name
  lea dx,otherCommand
  mov ah,9
  int 21h
  ret
printCommands endp
;function to draw the points of each color 
printPoints proc
  ;set the cursor
  mov ah,2
  mov dl,firstPointX
  mov dh,21d
  int 10h
  ;print the first digit
  mov ah,0
  mov al,coloredPoints
  mov si,0
  mov si,DBLUE
  call print2Decimal

  ;set the cursor
  mov ah,2
  mov dl,firstPointX
  add dl,3
  mov dh,21d
  int 10h
  ;print the first digit
  mov ah,0
  mov al,coloredPoints+1
  mov si,0
  mov si,LGREEN
  call print2Decimal

  ;set the cursor
  mov ah,2
  mov dl,firstPointX
  add dl,6
  mov dh,21d
  int 10h
  ;print the first digit
  mov ah,0
  mov al,coloredPoints+2
  mov si,0
  mov si,CYAN
  call print2Decimal

  ;set the cursor
  mov ah,2
  mov dl,firstPointX
  add dl,9
  mov dh,21d
  int 10h
  ;print the first digit
  mov ah,0
  mov al,coloredPoints+3
  mov si,0
  mov si,RED
  call print2Decimal

  ;set the cursor
  mov ah,2
  mov dl,firstPointX
  add dl,12
  mov dh,21d
  int 10h
  ;print the first digit
  mov ah,0
  mov al,coloredPoints+4
  mov si,0
  mov si,PURPLE
  call print2Decimal
  ret
printPoints endp
;function print two messages of chatting 
printTwoMessage proc 
  ;set cursor
  mov ah,2
  mov dl,0
  mov dh,23d
  mov bh,0
  int 10h
  ; print name
  lea dx,firstMessage
  mov ah,9
  int 21h
  ;set cursor
  mov ah,2
  mov dl,0
  mov dh,24d
  mov bh,0
  int 10h
  ; print name
  lea dx,secondMessage
  mov ah,9
  int 21h
  ret
printTwoMessage endp
;function to print wanted value
printWantedValue proc
  mov charToDrawx,16h
  mov charToDrawy,19d
  mov charToDrawColor,LGREEN
  mov charToDraw,'W'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'a'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'n'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'t'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'e'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'d'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,' '
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'V'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'a'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'l'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'u'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'e'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,':'
  call drawCharWithGivenVar

  mov charToDrawx,23h
  mov charToDrawy,19d
  mov charToDrawColor,LGREEN

  mov ax,wantedValue
  call convertRegToStr

  lea si,RegStringToPrint
  mov al,[si]
  mov charToDraw,al
  call drawCharWithGivenVar

  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  call drawCharWithGivenVar

  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  call drawCharWithGivenVar

  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  call drawCharWithGivenVar
  ret
printWantedValue endp
;function to print the forbidden char for level 1
printForbiddenChar proc
  mov al,level
  mov dl,2
  cmp al,dl
  jz ForbiddenExit

  mov charToDrawx,16h
  mov charToDrawy,21d
  mov charToDrawColor,RED
  mov charToDraw,'F'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'o'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'r'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'b'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'i'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'d'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'d'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'e'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'n'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,' '
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'C'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'h'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'a'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,'r'
  call drawCharWithGivenVar
  inc charToDrawx
  mov charToDraw,':'
  call drawCharWithGivenVar
  inc charToDrawx
  mov al,forbiddenChar
  mov charToDraw,al
  call drawCharWithGivenVar
  ForbiddenExit:
  ret
printForbiddenChar endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end main