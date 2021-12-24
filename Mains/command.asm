.model Huge
.stack 64

.data

Names             dw 'ax','bx','cx','dx','si','di','bp','sp','al','ah','bl','bh','cl','ch','dl','dh'
registers         dw 1111h,2222h,3333h,4444h,5555h,6666h,7777h,8888h
offsets           dw 16 dup(00)
flagdst           db 0h                    ;flag for wrong destination
flag              db 0h                    ;flag for wrong source
;type of source and destination and the final offset of them
typeOfDestination db 0fh
destination       dw 0000h
typeOfSource      db 0fh
source            dw 0000h
;our memory variable
memory            db 16 dup(0)
offsetMemory      dw ?
;our carry
carry             db 0
;our command
MyCommand LABEL BYTE
CommandSize       db 30
ActualSize        db ?
command           db 15 dup('$')
;after getting the command we need to separate it into 3 parts
ourOperation          db 4 dup('$')
regName               db 5 dup('$')
SrcStr                db 5 dup('$')
;our forbidden char
forbiddenChar     db 'M'
;forbidden flag to know that he entered forbidden char
forbiddenFlag     db 0            ;equal 1 when the player use that char
;the possible operations for the player to use
operations  db 'mov','add','adc','sub','sbb','xor','and','nop','shr','shl','clc','ror','rol','rcr','rcl','inc','dec','/'
;codes for the operation
;1=mov
;2=add
;3=adc
;4=sub
;5=sbb
;6=xor
;7=and
;8=nop
;9=shr
;10=shl
;11=clc
;12=ror
;13=rol
;14=rcr
;15=rcl
;16=inc
;17=dec
CodeOfOperation     db ?
;flags for invalid command
invalidOperationFlag  db 0     ;equal 1 when the operation is wrong

.code
main proc
  mov ax,@data
  mov ds,ax
  mov es,ax
  
  call getCommandLvl2
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
  EXITJMPOP: jmp EXITMAIN
  NOEXITOP:
  ;set the memory offset
  lea bx,memory
  mov offsetMemory,bx

  ;destinationCheck regName,Names,offsets,destination,flagdst,typeOfDestination,registers
  ;if the invalid flag == 1 then exit and remove some points from the player
  mov al,flagdst
  mov dl,1
  cmp al,dl
  jz EXITJMPDS
  jmp NOEXITDS
  EXITJMPDS: 
  mov invalidOperationFlag,1
  jmp EXITMAIN
  NOEXITDS:

  ;PUSHALL
  ;sourceCheck SrcStr,Names,offsets,source,flag,typeOfSource,registers
  ;POPALL
  ;if the invalid flag == 1 then exit and remove some points from the player
  mov al,flag
  mov dl,1
  cmp al,dl
  jz EXITJMPSO
  jmp NOEXITSO
  EXITJMPSO: 
  mov invalidOperationFlag,1
  jmp EXITMAIN
  NOEXITSO:

  ;execute CodeOfOperation,invalidOperationFlag,regName,SrcStr,destination,source,typeOfDestination,typeOfSource,carry
  call Execute
  ;function to clear the command string (turn it back to $)
  call ClearCommand

  EXITMAIN:
  hlt
main endp
;----------------------functions----------------------;
getCommandLvl2 proc
  ;get the player's command
  mov ah,0AH
  lea dx,command-2
  int 21h
  ;convert the (enter) char to $
  lea si,command
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
  lea si,command                     ;si-->address of string
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
  lea si,command                     ;the command itself 
  mov al,forbiddenChar
  lea di,ActualSize
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

separateCommand proc
  ;get the operation
  lea si,command
  lea di,ourOperation
  mov dl,20h
  SECON:
  mov al,[si]
  cmp al,dl     ;if the current char is space then exit and inc (si) 
  jz SEOPEREND
  mov [di],al
  inc di
  inc si
  jmp SECON:
  SEOPEREND:
  inc si
  ;now the di is on the first char of the destination
  mov di,si
  ;we need to get the comma (,) so that the destination done
  mov al,2Ch
  lea bx,ActualSize
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

Execute proc
  ;if the operation between memory to memory then exit
  mov al,typeOfDestination
  mov dl,1h
  cmp al,dl
  jnz EXECUTEOP
  ;destination is memory now check the source
  mov al,typeOfSource
  mov dl,1h
  cmp al,dl
  jnz EXECUTEOP
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

;regName,SrcStr,destination,source,typeOfDestination,typeOfSource,carry
;destination,source,realDistination,realSource,typeOfDestination,typeOfSource,carry
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
  add bx,[di]
  mov di,destination
  mov ax,[bx]
  mov [di],ax
  jmp MOVEXIT

  MOVREGMEM8:    ;move into 8-bits register
  mov bx,offsetMemory
  mov di,source
  add bx,[di]
  mov di,destination
  mov al,[bx]
  mov [di],al
  jmp MOVEXIT
  
  ;end destination is reg
  MOVDSMEM: ;destination is not register (Memory,Register Indirect) , source may be register or number
  mov al,typeOfSource
  mov dl,2h
  cmp al,dl
  jz MOVMEMSO16
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
  add bx,[di]          ;bx=memory offset
  mov di,source
  mov ax,[di]
  mov [bx],al
  inc bx
  mov [bx],ah
  jmp MOVEXIT

  MOVMEMSO8:
  mov bx,offsetMemory
  mov di,destination
  add bx,[di]          ;bx=memory offset
  mov di,source
  mov al,[di]
  mov [bx],al
  MOVEXIT:
  ret
EXMOV endp

ADD16 proc
  mov si,source
  mov bx,destination
  mov ax,[si]                 ;source
  mov di,[bx]                 ;destination
  add di,ax
  jnc ADDNOCARRY16
  mov carry,1
  ADDNOCARRY16:
  mov [bx],di
  ret
ADD16 endp
ADD8 proc
  mov si,source
  mov bx,destination
  mov al,[si]                 ;source
  mov ah,[bx]                 ;destination
  add ah,al
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
  jnz ADDSOMEM
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
  ;not handeld yet
  ;end destination is reg
  ADDDSMEM: ;destination is not register (Memory,Register Indirect)
  ;not handeld yet

  ADDEXIT:
  ret
EXADD endp

ADC16 proc
  mov si,source
  mov bx,destination
  mov ax,[si]                 ;source
  mov di,[bx]                 ;destination
  add al,carry
  add di,ax
  jnc ADCNOCARRY16
  mov carry,1
  ADCNOCARRY16:
  mov [bx],di
  ret
ADC16 endp
ADC8 proc
  mov si,source
  mov bx,destination
  mov al,[si]                 ;source
  mov ah,[bx]                 ;destination
  add al,carry
  add ah,al
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
  jnz ADCSOMEM
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
  ;not handeld yet
  ;end destination is reg
  ADCDSMEM: ;destination is not register (Memory,Register Indirect)
  ;not handeld yet

  ADCEXIT:
  ret
EXADC endp

SUB16 proc
  mov si,source
  mov bx,destination
  mov ax,[si]                 ;source
  mov di,[bx]                 ;destination
  sub di,ax
  jnc SUBNOCARRY16
  mov carry,1
  SUBNOCARRY16:
  mov [bx],di
  ret
SUB16 endp
SUB8 proc
  mov si,source
  mov bx,destination
  mov al,[si]                 ;source
  mov ah,[bx]                 ;destination
  sub ah,al
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
  ;not handeld yet
  ;end destination is reg
  SUBDSMEM: ;destination is not register (Memory,Register Indirect)
  ;not handeld yet

  SUBEXIT:
  ret
EXSUB endp

SBB16 proc
  mov si,source
  mov bx,destination
  mov ax,[si]                 ;source
  mov di,[bx]                 ;destination
  sub al,carry
  sub di,ax
  jnc SBBNOCARRY16
  mov carry,1
  SBBNOCARRY16:
  mov [bx],di
  ret
SBB16 endp
SBB8 proc
  mov si,source
  mov bx,destination
  mov al,[si]                 ;source
  mov ah,[bx]                 ;destination
  sub al,carry
  sub ah,al
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
  ;not handeld yet
  ;end destination is reg
  SBBDSMEM: ;destination is not register (Memory,Register Indirect)
  ;not handeld yet

  SBBEXIT:
  ret
EXSBB endp

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
  ;not handeld yet
  ;end destination is reg
  XORDSMEM: ;destination is not register (Memory,Register Indirect)
  ;not handeld yet

  XOREXIT:
  ret
EXXOR endp

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
  ;not handeld yet
  ;end destination is reg
  ANDDSMEM: ;destination is not register (Memory,Register Indirect)
  ;not handeld yet

  ANDEXIT:
  ret
EXAND endp

EXSHR proc
  ret
EXSHR endp

EXSHL proc
  ret
EXSHL endp

EXCLC proc
  mov carry,0
  ret
EXCLC endp

EXROR proc
  ret
EXROR endp

EXROL proc
  ret
EXROL endp

EXRCR proc
  ret
EXRCR endp

EXRCL proc
  ret
EXRCL endp

EXINC proc
  mov di,source
  mov bx,destination
  mov ax,[bx] 
  inc ax
  mov [bx],ax
  ret
EXINC endp

EXDEC proc
  mov di,source
  mov bx,destination
  mov ax,[bx]  
  dec ax
  mov [bx],ax
  ret
EXDEC endp

ClearCommand proc

  ret
ClearCommand endp
;-----------------------------------------------------;
end main