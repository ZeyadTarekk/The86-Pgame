.286
.model huge
.stack 64
.data

;dimensions of the screen
row dw 0
col dw 0

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

;data for the char to draw (x,y,char,color)
charToDraw db ?
charToDrawColor db ?
charToDrawx db ?
charToDrawy db ?

myName db 'Zeyad$'
otherName db 'Beshoy$'

myNameL LABEL BYTE
myNameSize db 15
; myNameActualSize db ?
myNameActualSize db 5
; myName db 15 dup('$')

otherNameL LABEL BYTE
otherNameSize db 15
; otherNameActualSize db ?
otherNameActualSize db 6

wantedValue dw 105Eh        ; number not string to compare it with other


myCommand db 'MOV AX,5$'
otherCommand db 'ADC BX,6$'

myCommandL LABEL BYTE
myCommandSize db 15
; myCommandActualSize db ?
myCommandActualSize db 8
; myCommand db 15 dup('$')

otherCommandL LABEL BYTE
otherCommandSize db 15
; otherCommandActualSize db ?
otherCommandActualSize db 8
; otherCommand db 15 dup('$')

myPointsValue db 9d
otherPointsValue db 5d
myPointsX db ?
otherPointsX db ?
pointsY db 0dh
;global variable for printing line (x)
linex dw ?
liney dw ?
;the values of hitted balls with a given color
;               1     2       3     4         5
              ;red, Yellow , blue, Green , PURPLE 
coloredPoints db 5h,3h,8h,2h,1h

firstPointX db 3d
; firstPointY db 21d

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

;variables for postioning
printX db ?
printY db ?

;my registers data needed
;dummy variable to help printing
RegStringToPrint db 4 dup(?)
MemStringToPring db 2 dup(?)
ASC_TBL DB   '0','1','2','3','4','5','6','7','8','9'
        DB   'A','B','C','D','E','F'

;              AX    , BX   , CX   , DX   , SI   , DI   , BP   , SP
myRegisters dw 0F4FEH, 1034h, 154Fh, 57FEh, 5ADFh, 1254h, 0010h, 1000h
;                 AX   , BX   , CX   , DX   , SI   , DI   , BP    , SP
otherRegisters dw 1034h, 1034h, 1000h, 57FEh, 5ADFh, 0F4FEH, 0010h, 1254h

myMemory db 12h,54h,43h,56h,88h,75h,54h,0FDh,75h,13h,57h,86h,11h,58h,0FFh,5Fh

otherMemory db 13h,66h,43h,56h,88h,0FFh,54h,33h,75h,13h,57h,86h,11h,0FDh,77h,5Fh

firstMessage db 'Hello from first$'
secondMessage db 'Hello from second$'



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
targetStartColumnPositionOther dw 200d
targetColor db 1 ; this is considered also as the score

rowBullet dw 80d                    ; iterator for row of bullet always starts at 80d
colBullet dw 20d                    ; iterator for columns of bullet
; target start row and end  row are constants
bulletStartRowPosition dw 80d          ; changes and it equals start row + bullet height
bulletStartRowPositionOther dw 80d          ; changes and it equals start row + bullet height
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

;Player Score
MyScore dw 0


;function to draw the background color of the main screen
drawBackGround MACRO
LOCAL rowLoop 
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
ENDM

; draw gun macro 
drawBullet MACRO
    local rowLoopBullet
    local RemoverowLoopBullet
    local RemoverowLoopOtherBullet
    local rowLoopBulletOther

    mov cx, gunStartColumnPosition  ; column iterator starts at gunStartColumnPositionOther
    add cx, 10d                     ; half width of gun
    mov bulletStartColumnPosition, cx
    mov colBullet, cx
    add cx, bulletWidth
    mov bulletEndColumnPosition, cx      ; end of bullet column = gunStartColumnPositionOther+ bullet width
    
    mov ax, bulletStartRowPosition
    sub ax, bulletWidth
    mov rowBullet, 07d  

    RemoverowLoopBullet:
    mov ah, 0ch    ;write pixels on screen
    mov bh, 0      ;page
    mov dx, rowBullet    ;row
    mov cx, colBullet    ;column
    mov al, RED   ;colour
    int 10h
    ;need to mov the row 
    inc colBullet
    mov ax,colBullet
    mov dx,bulletEndColumnPosition
    cmp ax,dx
    jnz RemoverowLoopBullet  
    mov ax, bulletStartColumnPosition  ; column iterator starts at gunStartColumnPositionOther
    mov colBullet, ax
    inc rowBullet
    mov ax,rowBullet
    mov dx,80d
    cmp ax,dx
    jnz RemoverowLoopBullet


    ;intialization of other iterators
    mov cx, gunStartColumnPositionOther  ; column iterator starts at gunStartColumnPositionOther
    add cx, 10d                     ; half width of gun
    mov bulletStartColumnPositionOther, cx
    mov colBullet, cx
    add cx, bulletWidth
    mov bulletEndColumnPositionOther, cx      ; end of bullet column = gunStartColumnPositionOther+ bullet width
    
    mov ax, bulletStartRowPositionOther
    sub ax, bulletWidth
    mov rowBullet, 07d 
    
    RemoverowLoopOtherBullet:
    mov ah, 0ch    ;write pixels on screen
    mov bh, 0      ;page
    mov dx, rowBullet    ;row
    mov cx, colBullet    ;column
    mov al, RED   ;colour
    int 10h
    ;need to mov the row 
    inc colBullet
    mov ax,colBullet
    mov dx,bulletEndColumnPositionOther
    cmp ax,dx
    jnz RemoverowLoopOtherBullet
    mov ax, bulletStartColumnPositionOther  ; column iterator starts at gunStartColumnPositionOther
    mov colBullet, ax
    inc rowBullet
    mov ax,rowBullet
    mov dx,80d
    cmp ax,dx
    jnz RemoverowLoopOtherBullet


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

ENDM

; draw gun macro 
drawGun MACRO
    local rowLoopGun
    local RemoverowLoop
    local RemoverowLoopOther
    local rowLoopGunOther

    mov colGun,0
    RemoverowLoop:
    mov ah, 0ch    ;write pixels on screen
    mov bh, 0      ;page
    mov dx, rowGun    ;row
    mov cx, colGun    ;column
    mov al, RED   ;colour
    int 10h
    ;need to mov the row 
    inc colGun
    mov ax,colGun
    mov dx,125d
    cmp ax,dx
    jnz RemoverowLoop
    mov colGun,0
    inc rowGun
    mov ax,rowGun
    mov dx,gunEndRowPosition
    cmp ax,dx
    jnz RemoverowLoop

    mov rowGun,80d
    mov colGun,163d
    RemoverowLoopOther:
    mov ah, 0ch    ;write pixels on screen
    mov bh, 0      ;page
    mov dx, rowGun    ;row
    mov cx, colGun    ;column
    mov al, RED   ;colour
    int 10h
    ;need to mov the row 
    inc colGun
    mov ax,colGun
    mov dx,287d
    cmp ax,dx
    jnz RemoverowLoopOther
    mov colGun,163d
    inc rowGun
    mov ax,rowGun
    mov dx,gunEndRowPosition
    cmp ax,dx
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
ENDM

drawTarget MACRO
    local RemoverowLoopTarget
    local RemoverowLoopOtherTarget
    local rowLoopMyTarget
    local rowLoopOtherTarget
    mov colTarget,0
    RemoverowLoopTarget:
    mov ah, 0ch    ;write pixels on screen
    mov bh, 0      ;page
    mov dx, rowTarget    ;row
    mov cx, colTarget    ;column
    mov al, RED   ;colour
    int 10h
    ;need to mov the row 
    inc colTarget
    mov ax,colTarget
    mov dx,125d
    cmp ax,dx
    jnz RemoverowLoopTarget
    mov colTarget,0
    inc rowTarget
    mov ax,rowTarget
    mov dx,targetEndRowPosition
    cmp ax,dx
    jnz RemoverowLoopTarget

    mov rowTarget,0d
    mov colTarget,163d
    RemoverowLoopOtherTarget:
    mov ah, 0ch    ;write pixels on screen
    mov bh, 0      ;page
    mov dx, rowTarget    ;row
    mov cx, colTarget    ;column
    mov al, RED   ;colour
    int 10h
    ;need to mov the row 
    inc colTarget
    mov ax,colTarget
    mov dx,287d
    cmp ax,dx
    jnz RemoverowLoopOtherTarget
    mov colTarget,163d
    inc rowTarget
    mov ax,rowTarget
    mov dx,targetEndRowPosition
    cmp ax,dx
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
ENDM


;function to draw a given char at given location with given color
drawCharWithGivenVar  MACRO
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
ENDM

;function to draw memory lines (called once at the begining)
drawMemoryLines MACRO
  LOCAL LineLoopSmall
  ;draw the memory lines
  mov linex,125d
  drawLine
  mov linex,147d
  drawLine
  mov linex,162d
  drawLine
  mov linex,287d
  drawLine
  mov linex,307d
  drawLine
  mov liney,130d
  drawLineHorizontal
  mov liney,180d
  drawLineHorizontal
  mov liney,150d
  drawLineHorizontal

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

ENDM
drawLine macro
LOCAL LineLoop
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
endm
drawLineHorizontal MACRO 
LOCAL HLineLoop
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
ENDM

;function to draw the register names (AX,BX,..etc)
drawRegNames MACRO
  ;draw my
  mov charToDraw,'A'
  mov charToDrawColor,WHITE
  mov charToDrawx,0
  mov al,myAXy
  mov charToDrawy,al
  drawCharWithGivenVar
  ;draw other
  mov charToDrawx,15h
  drawCharWithGivenVar
  mov charToDraw,'X'
  inc charToDrawx
  drawCharWithGivenVar
  mov charToDrawx,1
  drawCharWithGivenVar

  ;draw my
  mov charToDraw,'B'
  mov charToDrawColor,WHITE
  mov charToDrawx,0
  mov al,myBXy
  mov charToDrawy,al
  drawCharWithGivenVar
  ;draw other
  mov charToDrawx,15h
  drawCharWithGivenVar
  mov charToDraw,'X'
  inc charToDrawx
  drawCharWithGivenVar
  mov charToDrawx,1
  drawCharWithGivenVar

  ;draw my
  mov charToDraw,'C'
  mov charToDrawColor,WHITE
  mov charToDrawx,0
  mov al,myCXy
  mov charToDrawy,al
  drawCharWithGivenVar
  ;draw other
  mov charToDrawx,15h
  drawCharWithGivenVar
  mov charToDraw,'X'
  inc charToDrawx
  drawCharWithGivenVar
  mov charToDrawx,1
  drawCharWithGivenVar

  ;draw my
  mov charToDraw,'D'
  mov charToDrawColor,WHITE
  mov charToDrawx,0
  mov al,myDXy
  mov charToDrawy,al
  drawCharWithGivenVar
  ;draw other
  mov charToDrawx,15h
  drawCharWithGivenVar
  mov charToDraw,'X'
  inc charToDrawx
  drawCharWithGivenVar
  mov charToDrawx,1
  drawCharWithGivenVar

  ;draw my
  mov charToDraw,'S'
  mov charToDrawColor,WHITE
  mov charToDrawx,8
  mov al,mySIy
  mov charToDrawy,al
  drawCharWithGivenVar
  ;draw other
  mov charToDrawx,1Dh
  drawCharWithGivenVar
  mov charToDraw,'I'
  inc charToDrawx
  drawCharWithGivenVar
  mov charToDrawx,9
  drawCharWithGivenVar

  ;draw my
  mov charToDraw,'D'
  mov charToDrawColor,WHITE
  mov charToDrawx,8
  mov al,myDIy
  mov charToDrawy,al
  drawCharWithGivenVar
  ;draw other
  mov charToDrawx,1Dh
  drawCharWithGivenVar
  mov charToDraw,'I'
  inc charToDrawx
  drawCharWithGivenVar
  mov charToDrawx,9
  drawCharWithGivenVar

  ;draw my
  mov charToDraw,'S'
  mov charToDrawColor,WHITE
  mov charToDrawx,8
  mov al,mySPy
  mov charToDrawy,al
  drawCharWithGivenVar
  ;draw other
  mov charToDrawx,1Dh
  drawCharWithGivenVar
  mov charToDraw,'P'
  inc charToDrawx
  drawCharWithGivenVar
  mov charToDrawx,9
  drawCharWithGivenVar

  ;draw my
  mov charToDraw,'B'
  mov charToDrawColor,WHITE
  mov charToDrawx,8
  mov al,myBPy
  mov charToDrawy,al
  drawCharWithGivenVar
  ;draw other
  mov charToDrawx,1Dh
  drawCharWithGivenVar
  mov charToDraw,'P'
  inc charToDrawx
  drawCharWithGivenVar
  mov charToDrawx,9
  drawCharWithGivenVar
ENDM

;function to draw the memory adresses
drawMemoryAdresses MACRO 
mov charToDraw,'0'
mov charToDrawColor, LBLUE
mov charToDrawx,27h
mov charToDrawy,0
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'1'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'2'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'3'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'4'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'5'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'6'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'7'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'8'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'9'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'A'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'B'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'C'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'D'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'E'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar

mov charToDrawx,27h
mov charToDraw,'F'
inc charToDrawy
drawCharWithGivenVar
mov charToDrawx,13h
drawCharWithGivenVar
ENDM

;function to convert the hexa number to string to display (need ax=num)
convertRegToStr MACRO
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
ENDM

;function to convert the hexa number to string to display (need al=num, ah=0)
convertMemToStr MACRO
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
ENDM

;functions to draw my registers data
drawMyRegisters MACRO
  ;first we need to get the number (4-bytes) and covert it to char
  ;then move it to charToDraw and pick a color and postions then draw
  
  ;print AX
  mov ax,myRegisters
  convertRegToStr
  mov al,myAXx
  mov printX,al
  mov al,myAXy
  mov printY,al
  printRegWithGivenVar

  ;print BX
  mov ax,myRegisters+2
  convertRegToStr
  mov al,myBXx
  mov printX,al
  mov al,myBXy
  mov printY,al
  printRegWithGivenVar

  ;print CX
  mov ax,myRegisters+4
  convertRegToStr
  mov al,myCXx
  mov printX,al
  mov al,myCXy
  mov printY,al
  printRegWithGivenVar

  ;print DX
  mov ax,myRegisters+6
  convertRegToStr
  mov al,myDXx
  mov printX,al
  mov al,myDXy
  mov printY,al
  printRegWithGivenVar

  ;print SI
  mov ax,myRegisters+8
  convertRegToStr
  mov al,mySIx
  mov printX,al
  mov al,mySIy
  mov printY,al
  printRegWithGivenVar

  ;print DI
  mov ax,myRegisters+10d
  convertRegToStr
  mov al,myDIx
  mov printX,al
  mov al,myDIy
  mov printY,al
  printRegWithGivenVar

  ;print BP
  mov ax,myRegisters+12d
  convertRegToStr
  mov al,myBPx
  mov printX,al
  mov al,myBPy
  mov printY,al
  printRegWithGivenVar

  ;print SP
  mov ax,myRegisters+14d
  convertRegToStr
  mov al,mySPx
  mov printX,al
  mov al,mySPy
  mov printY,al
  printRegWithGivenVar
ENDM
;functions to draw other registers data
drawOtherRegisters MACRO
;print AX
  mov ax,OtherRegisters
  convertRegToStr
  mov al,otherAXx
  mov printX,al
  mov al,otherAXy
  mov printY,al
  printRegWithGivenVar

  ;print BX
  mov ax,otherRegisters+2
  convertRegToStr
  mov al,otherBXx
  mov printX,al
  mov al,otherBXy
  mov printY,al
  printRegWithGivenVar

  ;print CX
  mov ax,otherRegisters+4
  convertRegToStr
  mov al,otherCXx
  mov printX,al
  mov al,otherCXy
  mov printY,al
  printRegWithGivenVar

  ;print DX
  mov ax,otherRegisters+6
  convertRegToStr
  mov al,otherDXx
  mov printX,al
  mov al,otherDXy
  mov printY,al
  printRegWithGivenVar

  ;print SI
  mov ax,otherRegisters+8
  convertRegToStr
  mov al,otherSIx
  mov printX,al
  mov al,otherSIy
  mov printY,al
  printRegWithGivenVar

  ;print DI
  mov ax,otherRegisters+10d
  convertRegToStr
  mov al,otherDIx
  mov printX,al
  mov al,otherDIy
  mov printY,al
  printRegWithGivenVar

  ;print BP
  mov ax,otherRegisters+12d
  convertRegToStr
  mov al,otherBPx
  mov printX,al
  mov al,otherBPy
  mov printY,al
  printRegWithGivenVar

  ;print SP
  mov ax,otherRegisters+14d
  convertRegToStr
  mov al,otherSPx
  mov printX,al
  mov al,otherSPy
  mov printY,al
  printRegWithGivenVar
ENDM

printRegWithGivenVar MACRO

  mov al,printX
  mov charToDrawx,al
  mov al,printY
  mov charToDrawy,al
  mov charToDrawColor,YELLOW

  lea si,RegStringToPrint
  mov al,[si]
  mov charToDraw,al
  drawCharWithGivenVar


  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  drawCharWithGivenVar


  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  drawCharWithGivenVar


  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  drawCharWithGivenVar
ENDM

printMemWithGivenVar macro
  mov al,printX
  mov charToDrawx,al
  mov al,printY
  mov charToDrawy,al
  mov charToDrawColor,RED

  lea si,MemStringToPring
  mov al,[si]
  mov charToDraw,al
  drawCharWithGivenVar

  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  drawCharWithGivenVar
endm

;functions to draw my memory data
drawMyMemory macro
LOCAL MyMemLoop,MyMemLoopH,myMemExit
  lea di,myMemory
  mov cx,15d
  add di,cx
  MyMemLoop:
  mov ah,0
  mov al,[di]
  convertMemToStr
  mov al,myMemx
  mov printX,al
  mov al,cl
  mov printY,al
  printMemWithGivenVar
  dec di
  LOOP MyMemLoopH
  jmp myMemExit
  MyMemLoopH: jmp MyMemLoop
  myMemExit:

  mov ah,0
  mov al,[di]
  convertMemToStr
  mov al,myMemx
  mov printX,al
  mov al,0
  mov printY,al
  printMemWithGivenVar
endm
;functions to draw other memory data
drawOtherMemory macro
LOCAL OtherMemLoop,OtherMemLoopH,otherMemExit
  lea di,otherMemory
  mov cx,15d
  add di,cx
  OtherMemLoop:
  mov ah,0
  mov al,[di]
  convertMemToStr
  mov al,otherMemx
  mov printX,al
  mov al,cl
  mov printY,al
  printMemWithGivenVar
  dec di
  LOOP OtherMemLoopH
  jmp otherMemExit
  OtherMemLoopH: jmp OtherMemLoop
  otherMemExit:

  mov ah,0
  mov al,[di]
  convertMemToStr
  mov al,otherMemx
  mov printX,al
  mov al,0
  mov printY,al
  printMemWithGivenVar
endm

; Function to print the two names
printTwoNames MACRO 
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
  
  
ENDM

; Function to draw the two players points
printTwoPoints MACRO

  mov al,myPointsValue
  add al,30h
  mov charToDraw,al
  mov al,myPointsX
  mov charToDrawX,al
  mov al,pointsY
  mov charToDrawY,al
  mov charToDrawColor,YELLOW
  drawCharWithGivenVar

  mov al,otherPointsValue
  add al,30h
  mov charToDraw,al
  mov al,otherPointsX
  mov charToDrawX,al
  mov al,pointsY
  mov charToDrawY,al
  mov charToDrawColor,YELLOW
  drawCharWithGivenVar


ENDM

;Function to print commands
printCommands MACRO
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
ENDM

; Function to draw the points of each color 
printPoints MACRO 
  lea di,coloredPoints
  mov al,[di]
  add al,30h
  mov charToDraw,al
  mov charToDrawColor,RED
  mov al,firstPointX
  mov charToDrawX,al
  mov charToDrawY,21d
  drawCharWithGivenVar
  
  add charToDrawX,2
  inc di
  mov al,[di]
  add al,30h
  mov charToDraw,al
  mov charToDrawColor,YELLOW
  drawCharWithGivenVar

  add charToDrawX,2
  inc di
  mov al,[di]
  add al,30h
  mov charToDraw,al
  mov charToDrawColor,LBLUE
  drawCharWithGivenVar


  add charToDrawX,2
  inc di
  mov al,[di]
  add al,30h
  mov charToDraw,al
  mov charToDrawColor,LGREEN
  drawCharWithGivenVar

  add charToDrawX,2
  inc di
  mov al,[di]
  add al,30h
  mov charToDraw,al
  mov charToDrawColor,PURPLE
  drawCharWithGivenVar
  
ENDM

; Function print two messages of chatting 
printTwoMessage MACRO 
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
ENDM

; Function to print wanted value
printWantedValue MACRO

  mov charToDrawx,1Dh
  mov charToDrawy,20d
  mov charToDrawColor,LGREEN

  mov ax,wantedValue
  convertRegToStr

  lea si,RegStringToPrint
  mov al,[si]
  mov charToDraw,al
  drawCharWithGivenVar


  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  drawCharWithGivenVar


  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  drawCharWithGivenVar


  inc charToDrawx
  inc si
  mov al,[si]
  mov charToDraw,al
  drawCharWithGivenVar


ENDM

.code
main proc
  mov ax,@data
  mov ds,ax
  mov es,ax

  ;set video mode   (320x200)
  mov ah, 00h
  mov al, 13h     
  int 10h 

  drawBackGround
  
  drawMemoryAdresses
  drawMemoryLines
  printTwoNames
  printPoints
  printTwoMessage
  printCommands
  printWantedValue
  ;for the main loop,   note: outside the loop called one time
  home:
  printTwoPoints
  drawRegNames
  drawMyRegisters
  drawOtherRegisters
  drawMyMemory
  drawOtherMemory



  ;get the key pressed to move the gun
  mov ah,1 ; check if key is clicked
  int 16h  ; do not wait for a key-AH:scancode,AL:ASCII)
  jz NoClickedKey  ; if no button is clicked DontRead it

  mov ah,0 ; read the pressed key
  int 16h  ; Get key pressed (Wait for a key-AH:scancode,AL:ASCII)

  continueToMoveOrFire:
  mov cl, 04Dh ; scan code of right arrow
  cmp cl, ah   ; compare clicked key with right arrow
  jz movGunRight

  mov cl, 04Bh ; Scan code of left arrow
  cmp cl, ah   ; compare clicked key with left arrow
  jz movGunLeft

  mov cl, 32d  ; ascii of space
  cmp cl, al   ; compare clicked key with space
  jz fire 
  
  jmp home     ; if not pressed left or right arrow loop again
  
  NoClickedKey:

  mov bx,80d
  mov ax, bulletStartRowPosition
  cmp ax, bx
  jz jumpTocontinuePlaying
  jmp continueToFire
    jumpTocontinuePlaying: jmp continuePlaying
  continueToFire: jmp fire

  movGunRight:
    mov bx,80d                    ; if bullet is not at its start position stop moving the Gun
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
    mov bx,80d                     ; if bullet is not at its start position stop moving the Gun
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
  
  fire:
    drawBullet 
    dec bulletStartRowPosition       ;decreament bullet position (move up)
    mov ax, bulletStartRowPosition   ;if width of bullet is more than position of 
    mov bx, bulletWidth              ;its lower border break;
    cmp ax,bx
  jae continuePlaying
    mov bulletStartRowPosition, 80d  ; return bullet to its start position
  continuePlaying:
  drawGun
  
  drawTarget
  dec targetStartColumnPosition       ;decreament bullet position (move up)
  mov ax, targetStartColumnPosition   ;if width of bullet is more than position of 
  mov bx, 0                           ;its lower border break;
  cmp ax,bx
  jnz continueMovingTarget
    mov targetStartColumnPosition, 115d  ; return bullet to its start position
    ;change the target color
    inc targetColor
    mov ah,6
    mov bh,targetColor
    cmp bh,ah
    jnz continueMovingTarget
      mov targetColor, 1
  continueMovingTarget:
  

  mov ax, bulletStartRowPosition
  add ax, bulletWidth
  mov cx, 15d
  cmp ax, cx
  ja helpJmpEndCompare
      jmp continueToCompare
    helpJmpEndCompare: jmp EndCompare
  continueToCompare:
  
  ; Check if 
  mov ax, bulletStartColumnPosition
  mov cx, bulletEndColumnPosition

  mov bx, targetStartColumnPosition
  mov dx, targetStartColumnPosition
  add dx, targetWidth
  
  cmp ax,bx
  jb case2
    cmp cx, dx    ;case1 
    ja case2
      mov targetStartColumnPosition, 115d
      mov al,targetColor ; ax = 0 targetColor
      mov ah,0           
      add MyScore,ax ; add target color to my score the color is considered as score
      ;change the target color
      inc targetColor
      mov ah,6
      mov bh,targetColor
      cmp bh,ah
      jnz EndCompare
        mov targetColor, 1
  case2:
  cmp cx, dx
  jb case3
      mov targetStartColumnPosition, 115d
      mov al,targetColor ; ax = 0 targetColor
      mov ah,0           
      add MyScore,ax ; add target color to my score the color is considered as score
      ;change the target color
      inc targetColor
      mov ah,6
      mov bh,targetColor
      cmp bh,ah
      jnz EndCompare
        mov targetColor, 1
  case3:
  cmp ax,bx
  ja EndCompare
      cmp cx,dx
      jbe EndCompare
      mov targetStartColumnPosition, 115d
      mov al,targetColor ; ax = 0 targetColor
      mov ah,0           
      add MyScore,ax ; add target color to my score the color is considered as score
      ;change the target color
      inc targetColor
      mov ah,6
      mov bh,targetColor
      cmp bh,ah
      jnz EndCompare
        mov targetColor, 1
  EndCompare:

  
  jmp home
  hlt
main endp
end main