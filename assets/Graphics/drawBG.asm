
.model huge
.stack 64

.data 

row dw 0   
col dw 0

mes db 'This is message','$'                                

.code
main proc
    mov ax,@data
    mov ds,ax
    mov es,ax

;set video mode
mov ah, 00h
mov al, 13h     ;320x200
int 10h     


mainloop:

mov ah, 0ch  ;write pixels on screen
mov bh, 0
mov dx, row    ;row
mov cx, col    ;column
mov al, 0bh  
int 10h  
inc row   

mov ax,row
mov bx,200d
cmp ax,bx
jz incCol
jnz mainloop

incCol:
    inc col
    mov ax,321d 
    cmp col,ax
    jz exit
    mov row,0
    jmp mainloop 
exit:

   

mov ah,2  
mov bh,0
mov dx,0A0Ah
int 10h 

   

mov ah,2
mov dl,'Z'
int 21h 
 
mov ah,2
mov dl,'e'
int 21h  

mov ah,2
mov dl,'y'
int 21h  

        
         
         
    hlt
main endp
end main