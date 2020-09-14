(*
---------------
Chuong trinh lay Serial cua dia
Su dung:
Ngat: $21
Chuc nang (AH =) $69
(AL =) 0 hay 1
----------------
*)
Program lay_serial_disk;
{Chuong trinh nay doc Serial cua dia, va hien len man hinh}
Uses Dos,CRT;
Type
 string2=string[2];
Var
 A : Registers;
 B : array[0..24] of Byte;
 SS : array[2..5] of string2;
 N,I : Byte;
 ST : string[2];

Function Doi(Tam:Byte):String2; 
Var
 Y :Byte;
 Hex :String;
 He :String[1];
Begin
Hex:=' ';
Repeat
 Y:= Tam Mod 16;
 If (Y >= 10) Then He:=Chr(Y+55)
 Else STR(Y,He);
 Hex:=He+Hex;
 Tam:=Tam div 16;
Until (Tam = 0);
Doi:=Hex;
End;

Procedure Check; 
Begin 
If (paramstr(1) <> '') Then ST:=paramstr(1)
Else
Begin
 write(' - Cho O Dia : ');
 readln(St)
End;
ST:=Upcase (ST[1])+ST[2];

If (ST = 'A:') Then N:=1
Else If (ST = 'B:') Then N:=2
Else If (ST = 'C:') Then N:=3
Else If (ST ='D:') Then N:=4 
Else If (ST ='E:') Then N:=5 
Else Begin 
 write(#7#7);
 writeln('- Khong Co O Dia ', St, ' ! ');
 readln;
 Halt(1);
End;
End;

BEGIN {Chinh}
Check;
a.AH:=$69;
a.BL:=N;
a.AL:=0; 
a.DS:=Seg(B); 
a.DX:=ofs(B[0]); 
MSDOS(a); 
write('- Serial Number : '); 
For i:=5 Downto 2 Do 
Begin 
 If (Length(DOI(B[i])) = 1 ) Then SS[i]:='0' + Doi(B[i])
 Else SS[i]:=Doi(B[i]);
 If (i = 3) Then write(' - ');
 write(ss[i]);
End;
readln;
End.

