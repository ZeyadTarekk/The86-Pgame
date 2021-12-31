  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Written by : - Ziad Sherif  13-12-2021                                              ;;
; parameters : - string                                                               ;;
; return     : - string which is converted to hexadecimal                             ;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; HexaIntialPoint MACRO
;                 LOCAL mainLoop                                                         ;;
;                 LOCAL exitHexa                                                             ;;
;                 LOCAL from_zero_nine                                                   ;;
;                 LOCAL skip                                                              ;;
;                 lea si,initalPointStr
;                 ;lea   si,string
;                 ;lea   di,hexaWord    ;converted string to hexadecimal
;     mainLoop:
;                 mov ah,24h              ;to avoid dbox khara error :3
;                 cmp   [si],ah       ;check if char is $
;                 jz    exitHexa           ;if ture ==>end
;                 mov   dl,[si]        ;assci of current char
;                 mov ah,40h
;                 cmp dl,40h          ;compare if digit from 0-9
;                 jbe   from_zero_nine    ;jump to get hexadecimal of digit
;                 sub dl,61h  ;  get hexa of  digit (A==>F)
;                 add dl,10
;                 jmp   skip  ; jump to skip (0-->9)
;     from_zero_nine:
;                 sub dl,30h
;     skip:
;                 mov [si],dl ; assignment value of dl to string
;                 inc si   ; points to the next digit
;                 jmp   mainLoop  ;iterate till  $
;     exitHexa:
;     lea si,initalPointStr       ;;conctenate the final answer ==> 01 02 00 0f $as exmaple ==>should be 120f
;     mov bx,10h             ;; ax 00 01 => 00 10 => 00  12 => 01 20=> 12 0f
;     mov al,[si]
;     mov ah,0
;     mov cl,'$'

;     cmp al,cl
;     jz Outloop
;     inc si
;     LOOPMain:
;         mov dl,[si]
;         cmp dl,cl
;         jz Outloop
;             mul bx
;             add al,[si]
;             inc si
;     jmp LOOPMain
;     Outloop:
;     lea si,initalPointStr
;     mov [si],ax
; ENDM

clearScreen MACRO
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
ENDM
getTheName MACRO name
    mov ah,0AH      
    lea dx,name-2    
    int 21h       
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


.model huge
.stack 64
.data

myNameL LABEL BYTE
myNameSize db 16
myNameActualSize db ?
myName db 16 dup('$')

endl    db  10,13 ,'$'
str           db 10,13,10,13,10,13 
              db '                            Please enter your Name: ','$'


intialPointSize    db 5                    
intialPointActualSize db ?                    
initalPointStr      db 6 dup ('$')
STRIP           db 10,13,10,13,10,13 
                db '                            Please enter your Intial Point: ','$'                    

;invalid    db 'Please Enter Valid inputs [0-9],[A-Z]','$'
.code

;description
main PROC
    
    mov ax,@data
    mov ds,ax


    call GetNameAndIntialP
;     mainLoop:
;     mov bx,0
;     mov ah,2 
;     mov dx,0 ;set cursor at x=0,y=0
;     int 10h
;     clearScreen
;       mov ah,9
;     lea dx,str   
;     int 21h 
    
;     call ClearName
;     ;getTheName playerName            
;     mov ah,0AH      
;     lea dx,playerName-2    
;     int 21h

;     lea si,playerName
;     ;mov ax,'9'
; ;    cmp [si],ax;check if between 0,9
; ;    jbe L09
      
;     mov al,'Z'
;     cmp [si],al ;check if between A,Z
;     jbe LAZ
    
;     mov al,'z'
;     cmp [si],al     ;check if between a,z
;     jbe Lza
    
;   ;  
; ;    L09:
; ;    cmp [si],'0'
; ;    jae exit
; ;    jmp mainLoop
    
;     LAZ:
;     mov al,'A'
;     cmp [si],al
;     jae exit
;     jmp mainLoop
    
    
    
;     Lza:
;     mov al,'a'
;     cmp [si],al
;     jae exit
;     jmp mainLoop
    
;     exit:

;     ;convert the (enter) char to $
;     lea si,playerName
;     mov al,0dh
;     ConvertEnterName:
;     inc si
;     mov bl,[si]
;     cmp bl,al 
;     jnz ConvertEnterName
;     mov [si],24h

;     ; mov ah,9
;     ; lea dx,endl
;     ; int 21h
;     mov ah,9
;     lea dx,STRIP   
;     int 21h 
;     getTheName initalPointStr
;     mov cl,intialPointActualSize
;     mov ch,0
;     lea bx,initalPointStr
;     add bx,cx
;     mov al,'$'
;     mov [bx],al
;     ;Hexaaa initalPointStr
;     call HexaIntialPoint



    ret
main ENDP




GetNameAndIntialP proc
  GNPmainLoop:
    mov bx,0
    mov ah,2 
    mov dx,0 ;set cursor at x=0,y=0
    int 10h
    clearScreen         ;call
    mov ah,9
    lea dx,StringToPrint   
    int 21h 
    
    call ClearName        
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

    mov ah,9
    lea dx,STRIP   
    int 21h 

    mov ah,0AH      
    lea dx,initalPointStr-2    
    int 21h

    mov cl,intialPointActualSize
    mov ch,0
    lea bx,initalPointStr
    add bx,cx
    mov al,'$'
    mov [bx],al
    call HexaIntialPoint
    ret
GetNameAndIntialP endp

ClearName proc
  lea di,myName
  ClearNaAgain:
  mov al,[di]
  mov dl,'$'
  cmp al,dl
  jz ClearNafinish
  mov [di],dl
  inc di
  jmp ClearNaAgain
  ClearNafinish:
  ret
ClearName endp

HexaIntialPoint proc
    lea si,initalPointStr
    ;lea   si,string
    ;lea   di,hexaWord    ;converted string to hexadecimal
    HIPmainLoop:
      mov ah,24h              ;to avoid dbox khara error :3
      cmp   [si],ah       ;check if char is $
      jz    exitHIP           ;if ture ==>end
      mov   dl,[si]        ;assci of current char
      mov ah,40h
      cmp dl,40h          ;compare if digit from 0-9
      jbe   from_zero_nine    ;jump to get hexadecimal of digit
      sub dl,61h  ;  get hexa of  digit (A==>F)
      add dl,10
      jmp   HIPskip  ; jump to skip (0-->9)
    from_zero_nine:
    sub dl,30h
  HIPskip:
  mov [si],dl ; assignment value of dl to string
  inc si   ; points to the next digit
  jmp   HIPmainLoop  ;iterate till  $
  exitHIP:
  lea si,initalPointStr       ;;conctenate the final answer ==> 01 02 00 0f $as exmaple ==>should be 120f
  mov bx,10h             ;; ax 00 01 => 00 10 => 00  12 => 01 20=> 12 0f
  mov al,[si]
  mov ah,0
  mov cl,'$'

  cmp al,cl
  jz HIPOutloop
  inc si
  HIPLOOPMain:
      mov dl,[si]
      cmp dl,cl
      jz HIPOutloop
          mul bx
          add al,[si]
          inc si
  jmp HIPLOOPMain
  HIPOutloop:
  lea si,initalPointStr
  mov [si],ax
  ret
HexaIntialPoint endp



END main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




  
