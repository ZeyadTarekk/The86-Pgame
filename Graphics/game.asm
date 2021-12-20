include gameGraphics.inc
.model huge
.stack 64

.data

;position of registers
myAXx db 10
myAXy db 3
myBXx db 10
myBXy db 4
myCXx db 10
myCXy db 5
myDXx db 10
myDXy db 6
mySIx db 24
mySIy db 3
myDIx db 24
myDIy db 4
mySPx db 24
mySPy db 5
myBPx db 24
myBPy db 6

otherAXx db 50
otherAXy db 3
otherBXx db 50
otherBXy db 4
otherCXx db 50
otherCXy db 5
otherDXx db 50
otherDXy db 6
otherSIx db 64
otherSIy db 3
otherDIx db 64
otherDIy db 4
otherSPx db 64
otherSPy db 5
otherBPx db 64
otherBPy db 6

;position of memory
myMem0x db 36
myMem0y db 0
myMem1x db 36
myMem1y db 1
myMem2x db 36
myMem2y db 2
myMem3x db 36
myMem3y db 3
myMem4x db 36
myMem4y db 4
myMem5x db 36
myMem5y db 5
myMem6x db 36
myMem6y db 6
myMem7x db 36
myMem7y db 7
myMem8x db 36
myMem8y db 8
myMem9x db 36
myMem9y db 9
myMemAx db 36
myMemAy db 10
myMemBx db 36
myMemBy db 11
myMemCx db 36
myMemCy db 12
myMemDx db 36
myMemDy db 13
myMemEx db 36
myMemEy db 14
myMemFx db 36
myMemFy db 15

otherMem0x db 75
otherMem0y db 0
otherMem1x db 75
otherMem1y db 1
otherMem2x db 75
otherMem2y db 2
otherMem3x db 75
otherMem3y db 3
otherMem4x db 75
otherMem4y db 4
otherMem5x db 75
otherMem5y db 5
otherMem6x db 75
otherMem6y db 6
otherMem7x db 75
otherMem7y db 7
otherMem8x db 75
otherMem8y db 8
otherMem9x db 75
otherMem9y db 9
otherMemAx db 75
otherMemAy db 10
otherMemBx db 75
otherMemBy db 11
otherMemCx db 75
otherMemCy db 12
otherMemDx db 75
otherMemDy db 13
otherMemEx db 75
otherMemEy db 14
otherMemFx db 75
otherMemFy db 15

;position of wanted value
wantedx db 36
wantedy db 17


;intial game graphics
gameRow db '                                   |00|0|                                 |00|0|'
        db '                                   |00|1|                                 |00|1|'  ;lines for the moving ball
        db '-----------------------------------|00|2|---------------------------------|00|2|'
        db '       AX=0000       SI=0000       |00|3|      AX=0000       SI=0000      |00|3|'
        db '       BX=0000       DI=0000       |00|4|      BX=0000       DI=0000      |00|4|'
        db '       CX=0000       SP=0000       |00|5|      CX=0000       SP=0000      |00|5|'
        db '       DX=0000       BP=0000       |00|6|      DX=0000       BP=0000      |00|6|'
        db '-----------------------------------|00|7|---------------------------------|00|7|'    
        db '                                   |00|8|                                 |00|8|'    
        db '                                   |00|9|                                 |00|9|'    
        db '             Ali: 20               |00|A|          Ahmed: 30              |00|A|'    
        db '                                   |00|B|                                 |00|B|'
        db '                                   |00|C|                                 |00|C|'
        db '                                   |00|D|                                 |00|D|'
        db '                                   |00|E|                                 |00|E|'
        db '-----------------------------------|00|F|---------------------------------|00|F|'
        db '            Wanted Value --------> |105E| <-------- Wanted Value          |    |'      ;line for the gun  
        db '                                   |    |                                 |    |'      ;this line for the command
        db '-----------------------------------|    |---------------------------------|    |'
        db '                                   |    |                                 |    |'      ;lines for the colored balls
        db '                                   |    |                                 |    |'
        db '-----------------------------------|    |---------------------------------|    |'
        db 'Ali: This is the first chatting line                                            '      ;chatting lines
        db 'Ahmed:  This is the second chatting line                                        '

.code
main proc
    mov ax,@data
    mov ds,ax
    mov es,ax

    clearScreen
    displayScreen gameRow

    mov dl,otherMemFx
    mov dh,otherMemFy
    mov ah,2
    int 10h

    mov ah,9 ;Display
    mov bh,0 ;Page 0
    mov al,44h ;Letter D
    mov cx,2h ;5 times
    mov bl,0FAh ;Green (A) on white(F) background
    int 10h

    hlt
main endp
end main