.model small 
.stack 64
.data

;data for the char to draw (x,y,char,color)
charToDraw db ?
charToDrawColor db ?
charToDrawx db ?
charToDrawy db ?

; colors
WHITE EQU 0FH
RED EQU 0CH
YELLOW EQU 0EH
BLACK EQU 0H
GRAY EQU 7H
LBLUE EQU 9H
BLUE EQU 1H


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
; gun start column is variable
; This variable changes the position of Other gun
gunStartColumnPositionOther dw 200d


rowTarget dw 0d
colTarget dw 20d
; target start row and end  row are constants
targetEndRowPosition EQU 7d
; target start column is variable
; This variable changes the position of my target
targetStartColumnPosition dw 10d 
targetWidth EQU 10d
; gun start column is variable
; This variable changes the position of Other target
targetStartColumnPositionOther dw 200d


.code
;description

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

drawTarget MACRO
    mov ax, targetStartColumnPosition
    mov colTarget, ax
    
    rowLoopMyTarget:
    mov ah, 0ch    ;write pixels on screen
    mov bh, 0      ;page
    mov dx, rowTarget    ;row
    mov cx, colTarget    ;column
    mov al, YELLOW     ;colour
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
    mov al, YELLOW     ;colour
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
ENDM

drawGun MACRO
    local rowLoopGun
    local RemoverowLoop

    mov colGun,0
    RemoverowLoop:
    mov ah, 0ch    ;write pixels on screen
    mov bh, 0      ;page
    mov dx, rowGun    ;row
    mov cx, colGun    ;column
    mov al, BLUE   ;colour
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
    mov al, BLUE   ;colour
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
    mov al, YELLOW     ;colour
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
    mov al, YELLOW     ;colour
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


main PROC
    mov ax, @data
    mov ds, ax
    mov es, ax

    mov ah,0
    mov al,13h
    int 10h

    mov ah,0bh
    mov bh,00h
    mov bl, RED
    int 10h

    drawGun
    drawTarget
    ret
main ENDP
end main