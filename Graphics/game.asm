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
        db '                                   |    |                                 |    |'      ;line for the gun  
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

    hlt
main endp
end main