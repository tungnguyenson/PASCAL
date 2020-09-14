Program Toi; 
Uses Crt; 
Begin 
 Textbackground(0);
 Clrscr;
Asm
 Mov DL,64
 Mov BX,0
 Mov AH,10h
 Mov AL,10h
@A:
 Dec DL
 Mov DH,DL
 Mov CH,DL
 Mov CL,DL
 Int 10H
 Push DX
 Push AX
 Mov AH,86H
 Mov DX,10H
 Mov CX,01
 Int 15H
 Pop AX
 Pop DX
 Cmp DL,0
 Jne @A
End;
End.



