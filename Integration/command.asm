include lowCase.inc
include setOff.inc
include PUSHPOP.inc
include validNum.inc
include validMem.inc
include strSpcs.inc
include trimSpcs.inc
include validReg.inc
include HexaStr.inc
include validRD.inc
include Dest.inc
include vMemSrc.inc
include SRC.inc

.model Huge
.stack 64

.data

Names             dw 'ax','bx','cx','dx','si','di','bp','sp','al','ah','bl','bh','cl','ch','dl','dh'
registers         dw 1111h,0000h,3333h,4444h,0005h,000Fh,7777h,8888h
offsets           dw 16 dup(00)
flagdst           db 0h                    ;flag for wrong destination
flag              db 0h                    ;flag for wrong source
;type of source and destination and the final offset of them
typeOfDestination db 0fh
destination       dw 0000h
typeOfSource      db 0fh
source            dw 0000h
;our memory variable
memory            db 11h,22h,33h,44h,11h,22h,33h,44h,11h,22h,33h,44h,11h,22h,33h,44h
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

  destinationCheck regName,Names,offsets,destination,flagdst,typeOfDestination,registers
  ;if the invalid flag == 1 then exit and remove some points from the player
  mov al,flagdst
  mov dl,1
  cmp al,dl
  jz EXITJMPDS
  jmp NOEXITDS
  EXITJMPDS: jmp EXITMAIN
  NOEXITDS:

  PUSHALL
  sourceCheck SrcStr,Names,offsets,source,flag,typeOfSource,registers
  POPALL
  ;if the invalid flag == 1 then exit and remove some points from the player
  mov al,flag
  mov dl,1
  cmp al,dl
  jz EXITJMPSO
  jmp NOEXITSO
  EXITJMPSO: jmp EXITMAIN
  NOEXITSO:

  ;execute CodeOfOperation,invalidOperationFlag,regName,SrcStr,destination,source,typeOfDestination,typeOfSource,carry
  call Execute
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
  jmp SECON
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
EditCarry proc
  mov al,carry
  mov dl,0
  jnz CARRYON
  CLC
  jmp CARRYEXIT
  CARRYON:
  STC
  CARRYEXIT:
  ret
EditCarry endp

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

EXCLC proc
  mov carry,0
  ret
EXCLC endp

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