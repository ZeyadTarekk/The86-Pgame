.286
.model huge
.stack 64

.data

;dimensions of the screen
row dw 0
col dw 0
; colors
RED EQU 0ch
BLUE EQU 01h
YELLOW EQU 0EH



; Variables for Gun

;iterators for draw gun
; gun starts at row 80d 
rowGun dw 80d
colGun dw 20d
; gun start row and end  row are constants
gunEndRowPosition EQU 90d
; gun start column is variable
gunStartColumnPosition dw 30d
gunWidth EQU 20d





; charToDraw2 db '0'

charToDraw db '0'
colorToDraw db RED    


;global variable for printing line
linex dw ?

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

; draw gun macro 
drawGun MACRO
    mov ax, gunStartColumnPosition
    mov colGun, ax

    rowLoopGun:
    mov ah, 0ch    ;write pixels on screen
    mov bh, 0      ;page
    mov dx, rowGun    ;row
    mov cx, colGun    ;column
    mov al, BLUE     ;colour
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
ENDM



drawMemoryAdressesForOther MACRO 
mov ah,2        ; 0 for memory address
mov dl,27h   ;x
mov dh,0      ;y
mov bh,0
int 10h
mov charToDraw,'0'
drawAnyChar 

mov ah,2        ; 0 for memory address
mov dl,27h   ;x
mov dh,1      ;y
mov bh,0
int 10h
mov charToDraw,'1'
drawAnyChar
ENDM

drawAnyCharColored  MACRO 
  mov  al, charToDraw
  mov  bl, 0Ch  ;Color is red
  mov  bh, 0    ;Display page
  mov  ah, 0Eh  ;Teletype
  int  10h
ENDM

drawAnyChar  MACRO 
  mov  al, charToDraw
  mov  bl, 0Ch  ;Color is red
  mov  bh, 0    ;Display page
  mov  ah, 0Eh  ;Teletype
  int  10h
ENDM


drawZeroForMemory MACRO 
  mov  al, '0'
  mov  bl, 0Eh  ;Color is red
  mov  bh, 0    ;Display page
  mov  ah, 0Eh  ;Teletype
  int  10h
ENDM

drawTwoCharsForMemoryColored MACRO 
  mov  al, charToDraw
  mov  bl, 0Ch  ;Color is red
  mov  bh, 0    ;Display page
  mov  ah, 0Eh  ;Teletype
  int  10h
  mov  al, charToDraw
  mov  bl, 0Ch  ;Color is red
  mov  bh, 0    ;Display page
  mov  ah, 0Eh  ;Teletype
  int  10h
ENDM


drawOtherMemoryNumbers  MACRO 
mov ah,2
mov dl,24h   ;x
mov dh,0      ;y
mov bh,0
int 10h
mov charToDraw , '0'
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,1      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,2      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,3      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,4      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,5      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,6      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,7      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,8      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,9      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,10d      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,11d      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,12d      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,13d      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,14d      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,24h   ;x
mov dh,15d      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
  
ENDM



drawMyMemoryNumbers  MACRO 
mov ah,2
mov dl,10h   ;x
mov dh,0      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,1      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,2      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,3      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,4      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,5      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,6      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,7      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,8      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,9      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,10d     ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,11d      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,12d      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,13d      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,14d      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
mov ah,2
mov dl,10h   ;x
mov dh,15d      ;y
mov bh,0
int 10h
drawTwoCharsForMemoryColored
  
ENDM



drawRegName macro
mov ah,2
mov dl,0
mov dh,myAXy
mov bh,0
int 10h
mov  al, 'A'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'X'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,0
mov dh,myBXy
mov bh,0
int 10h
mov  al, 'B'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'X'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,0
mov dh,myCXy
mov bh,0
int 10h
mov  al, 'C'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'X'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,0
mov dh,myDXy
mov bh,0
int 10h
mov  al, 'D'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'X'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,8
mov dh,mySIy
mov bh,0
int 10h
mov  al, 'S'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'I'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,8
mov dh,myDIy
mov bh,0
int 10h
mov  al, 'D'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'I'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,8
mov dh,mySPy
mov bh,0
int 10h
mov  al, 'S'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'P'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,8
mov dh,myBPy
mov bh,0
int 10h
mov  al, 'B'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'P'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
endm
drawZero MACRO 
  ;draw the ax
mov ah,2
mov dl,myAXx
mov dh,myAXy
mov bh,0
int 10h
draw
;draw the bx
mov ah,2
mov dl,myBXx
mov dh,myBXy
mov bh,0
int 10h
draw
mov ah,2
mov dl,myCXx
mov dh,myCXy
mov bh,0
int 10h
draw
mov ah,2
mov dl,myDXx
mov dh,myDXy
mov bh,0
int 10h
draw

mov ah,2
mov dl,mySIx
mov dh,mySIy
mov bh,0
int 10h
draw

mov ah,2
mov dl,myDIx
mov dh,myDIy
mov bh,0
int 10h
draw

mov ah,2
mov dl,mySPx
mov dh,mySPy
mov bh,0
int 10h
draw

mov ah,2
mov dl,myBPx
mov dh,myBPy
mov bh,0
int 10h
draw
ENDM


drawOtherRegName macro
mov ah,2
mov dl,15h
mov dh,otherAXy
mov bh,0
int 10h
mov  al, 'A'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'X'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,15h
mov dh,otherBXy
mov bh,0
int 10h
mov  al, 'B'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'X'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,15h
mov dh,otherCXy
mov bh,0
int 10h
mov  al, 'C'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'X'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,15h
mov dh,otherDXy
mov bh,0
int 10h
mov  al, 'D'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'X'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,1Dh
mov dh,otherSIy
mov bh,0
int 10h
mov  al, 'S'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'I'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,1Dh
mov dh,otherDIy
mov bh,0
int 10h
mov  al, 'D'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'I'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,1Dh
mov dh,otherSPy
mov bh,0
int 10h
mov  al, 'S'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'P'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,1Dh
mov dh,otherBPy
mov bh,0
int 10h
mov  al, 'B'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, 'P'
mov  bl, 0Fh
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
endm
drawOtherZero macro
  ;draw the ax
mov ah,2
mov dl,otherAXx
mov dh,otherAXy
mov bh,0
int 10h
draw

mov ah,2
mov dl,otherBXx
mov dh,otherBXy
mov bh,0
int 10h
draw

mov ah,2
mov dl,otherCXx
mov dh,otherCXy
mov bh,0
int 10h
draw

mov ah,2
mov dl,otherDXx
mov dh,otherDXy
mov bh,0
int 10h
draw

mov ah,2
mov dl,otherSIx
mov dh,otherSIy
mov bh,0
int 10h
draw

mov ah,2
mov dl,otherDIx
mov dh,otherDIy
mov bh,0
int 10h
draw

mov ah,2
mov dl,otherSPx
mov dh,otherSPy
mov bh,0
int 10h
draw

mov ah,2
mov dl,otherBPx
mov dh,otherBPy
mov bh,0
int 10h
draw
endm
draw macro 
drawZeroForMemory
drawZeroForMemory
drawZeroForMemory
drawZeroForMemory

endm

drawLine macro
LOCAL LineLoop
  mov di,0
  LineLoop:
  mov ah, 0ch    ;write pixels on screen
  mov bh, 0      ;page
  mov dx, di    ;row
  mov cx, linex    ;column
  mov al, 0     ;colour
  int 10h
  inc di
  mov ax,200d
  cmp di,ax
  jnz LineLoop
endm

.code
main proc
  mov ax,@data
  mov ds,ax
  mov es,ax

  ;call drawBG


  ;set video mode
  mov ah, 00h
  mov al, 13h     ;320x200
  int 10h 

  rowLoop:
  mov ah, 0ch    ;write pixels on screen
  mov bh, 0      ;page
  mov dx, row    ;row
  mov cx, col    ;column
  mov al, 7h     ;colour
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


;for the main loop
home:


drawRegName
;draw the zeros of reg
drawZero


drawOtherRegName
;draw other zeros
drawOtherZero



;draw the memory lines
mov linex,125d
drawLine
mov linex,147d
drawLine
mov linex,162d
drawLine


drawMemoryAdressesForOther


mov ah,2
mov dl,13h   ;x
mov dh,0      ;y
mov bh,0
int 10h
mov charToDraw,'0'
drawZeroForMemory




mov linex,287d
drawLine
mov linex,307d
drawLine

mov charToDraw,'0'
drawMyMemoryNumbers
drawOtherMemoryNumbers



drawGun

    ; rowLoopGun:
    ; mov ah, 0ch    ;write pixels on screen
    ; mov bh, 0      ;page
    ; mov dx, rowGun    ;row
    ; mov cx, colGun    ;column
    ; mov al, BLUE     ;colour
    ; int 10h

    ; ;need to mov the row 
    ; inc colGun
    ; mov ax,colGun
    ; mov dx,20d
    ; cmp ax,dx
    ; jnz rowLoopGun

    ; mov colGun,0
    ; inc rowGun
    ; mov ax,rowGun
    ; mov dx,90d
    ; cmp ax,dx
    ; jnz rowLoopGun

    ; mov rowGun,80d
    ; mov colGun,0





  jmp home
  hlt
main endp
end main