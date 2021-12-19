moveCurY MACRO
  mov ah,3h
  mov bh,0h
  int 10h
  inc dh
  mov ah,2
  int 10h
ENDM
moveCurX MACRO
  mov ah,3h
  mov bh,0h
  int 10h
  inc dl
  mov ah,2
  int 10h
ENDM

clearScreen MACRO
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
ENDM

displayScreen MACRO row
  LOCAL displayRowLoop
  LOCAL displayColLoop
  ;need to loop 25 time to print each row
  lea si,row

  mov di,1
  displayColLoop:
  push di

  dec si
  mov di,80
  displayRowLoop:
  mov ah,9 ;Display
  mov bh,0 ;Page 0
  inc si
  mov al,[si]
  mov cx,1
  mov bl,0F0h ;white(F) background
  int 10h
  ;need to mov the cursor to next position (inc x)
  moveCurX
  dec di
  cmp di,0
  jnz displayRowLoop
  ;finished the first row
  inc si

  pop di
  ;return the cursor to the beginning but next line
  mov ah,2
  mov dx,di
  mov cl,8
  shl dx,cl
  mov dl,0
  int 10h
  inc di
  cmp di,25
  jnz displayColLoop

ENDM
