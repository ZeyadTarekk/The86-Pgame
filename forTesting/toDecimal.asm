.model small
.stack 64
.data
;; take decimal and print  on screen as a decimal value 
num dw 1 ; input value
str db 4 dup('0')
.code
main proc
	mov ax,@data
	mov ds,ax
	mov ax,num
	lea si,str+3
	lea di,str
	mov cx,4
	mov dx,0
	label1:
			
		mov bx,10	
		div bx				
		mov dh,30h
		add dl,dh
		mov [si],dl
		dec si	
		mov  dx,0
		loop label1
		mov cx,4
		
	loopPrint:
	mov ah,2
	mov dl,[di]
	int 21h
	inc di
			
	loop loopPrint

main endp	
end main
           