.model small
 .stack 64
 .data

 text db 'Enter: $'
 max db 9
 chars db 0
 string db 9 DUP (0)
 novalinha db 13,10,13,10,'$'
 hex1 db ?    ;FIRST  HEX DIGIT.
 hex2 db '  , $' ;SECOND HEXT DIGIT.
.code
main proc far
  mov  AX, @data
  mov  DS, AX

  mov  CL, chars
  mov  ch, 0 
  lea  Si,  string
circle:         
    ;get one char from string
  mov  DL, [SI] 
;sperate lower 4 bits in char
  and  DL, 00001111b
  call convert ;CONVERT DL TO DIGIT OR LETTER.
  mov  hex2, dl 
  mov  DL, [SI] 
  shr  DL, 4 ;SHIFT DL 4 BITS TO THE RIGHT.
  call convert ;CONVERT DL TO DIGIT OR LETTER.
  mov  hex1, dl ;SAVE CONVERTED CHARACTER TO DISPLAY LATER.
  inc  si 
  loop circle


proc convert  ;CONVERT DL TO HEX CHARACTER.       
  cmp dl, 9
  jbe is_digit ;jump if ( dl <= 9 ).
    ;letter:  if no jump,
  add dl, 55 ;convert to letter.
  jmp done  
is_digit:  
  add dl, 48 ;convert to digit
done:
  ret
endp 
end main