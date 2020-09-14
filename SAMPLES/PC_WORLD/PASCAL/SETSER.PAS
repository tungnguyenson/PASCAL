(*
Chuong trinh thiet lap Serial cua dia
*)
Program SETSERIAL_DISK; 
{Chuong trinh nay thiet lap lai serial cua dia 
theo y thich nguoi su dung. 
Written by Thu Sa.D.H.T.SA}
Uses Crt,Dos; 
Var Reg : Registers; 
Dat : Array[1..25] of byte; 
St : String[2]; 
Tam1: String; 
N,ms1,ms2,ms3,ms4: Byte; 
Procedure CheckStr; 
Var Code:integer; 
X,Y:Byte; 
Begin 
If ( paramstr(1) ' ') Then ST:=paramstr(1) 
Else 
Begin 
write('- Cho Ten O Dia : '); 
readln(ST); 
st:=Upcase(st[1])+st[2] 
End; 
If (paramstr(2) ' ' ) Then 
Begin 
tam1:=paramstr(2); 
if (code 0) Then Halt(1); 
End 
Else 
Begin 
write('- Cho Ma So Serial Disk : '); 
readln(ms1,ms2,ms3,ms4); 
End; 
End; 

Procedure checkODia; 
Begin 
If (St=’0') Then N:=0 Else 
If (ST ='A:') or (St='1') Then N:=1 
Else If (ST ='B:') or (St='2') Then N:=2 
Else If (ST ='C:') or (St='3') Then N:=3 
Else If (ST ='D:') or (St='4') Then N:=4 
Else If (ST ='E:') or (St='5') Then N:=5 
Else Begin 
write(#7#7); 
writeln(' - Khong Co O Dia ', St, ' ! '); 
Halt(1); 
End; 
End; 

BEGIN {Chinh B}
clrscr; 
Checkstr; 
CheckODia; 
reg.AH:=$69; 
reg.BL:=N; 
reg.AL:=1; 
reg.DS:=seg(Dat); 
reg.DX:=ofs(Dat[1]); 
dat[3]:=ms4; 
dat[4]:=ms3; 
dat[5]:=ms2; 
dat[6]:=ms1; 
MSDOS(reg); 
If (Doserror 0) Then 
writeln('- Disk: Khong co Serial, Co Dan Protect, O Dia ', 
St, 'Khong Co Disk !') 
Else writeln(' ** OK **'); 
readln; 
End. 
