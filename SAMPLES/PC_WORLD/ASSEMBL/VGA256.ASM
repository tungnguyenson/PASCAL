;Listing 1: VGA256.ASM: {TASM VGA.ASM}
code segment word 
public Init256 
Init256 Proc near 
 Mov ah,00 
 mov al,13h 
 int 10h 
 ret 
Init256 endp 
code ends 
end 

