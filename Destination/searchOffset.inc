search MACRO text,regOfset,registers

            mov dx,registersOffsets  
             lea   si, text  ;points to the first word of input from user
             lea   di,  registers  ;points to the first word of array of regsiters
             mov   cx,32                ;iterate on  32 byte (array of register)
             Repne cmpsw ; repeat till find it!!
             cmp   cx,0 ; check if cx reaches 0
             jnz   found ; if != zero ==> is Found
             jz    notFound ;if points out of the array (Cx ==0) ==> will terminate
    found:   
             mov   ax,32 
             sub   ax,cx
             mov cx,ax
             add dx,cx
             add dx,2
             mov registersOffsets,dx
    notFound:
ENDM


