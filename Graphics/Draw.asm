.286
.model huge
.stack 64

.data

;dimensions of the screen
row dw 0
col dw 0

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
draw macro 
mov  al, '0'
mov  bl, 0Eh  ;Color is red
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, '0'
mov  bl, 0Eh  ;Color is red
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, '0'
mov  bl, 0Eh  ;Color is red
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, '0'
mov  bl, 0Eh  ;Color is red
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

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


;draw the memory lines
mov linex,125d
drawLine
mov linex,147d
drawLine
mov linex,162d
drawLine


mov ah,2
mov dl,10h   ;x
mov dh,0      ;y
mov bh,0
int 10h

mov  al, '0'
mov  bl, 0Eh  ;Color is red
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, '0'
mov  bl, 0Eh  ;Color is red
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,13h   ;x
mov dh,0      ;y
mov bh,0
int 10h

mov  al, '0'
mov  bl, 0Eh  ;Color is red
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h





mov linex,285d
drawLine
mov linex,307d
drawLine


mov ah,2
mov dl,24h   ;x
mov dh,0      ;y
mov bh,0
int 10h

mov  al, '0'
mov  bl, 0Eh  ;Color is red
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h
mov  al, '0'
mov  bl, 0Eh  ;Color is red
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h

mov ah,2
mov dl,27h   ;x
mov dh,0      ;y
mov bh,0
int 10h

mov  al, '0'
mov  bl, 0Eh  ;Color is red
mov  bh, 0    ;Display page
mov  ah, 0Eh  ;Teletype
int  10h





  jmp home
  hlt
main endp
end main