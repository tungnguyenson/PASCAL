Program Time_Counter2;
Uses CRT, DOS;
Var
 t, hh, mm,ss,s100 : word;
 tong: longint;

Function LAYTONG: longint; 
Var
 tam: longint;
Begin
GetTime (hh,mm,ss,s100);
tam := hh*3600 + mm*60 + ss;
Laytong := tam*100 + s100 ;
End;

Procedure WAIT(x:word); 
Begin 
tong :=LAYTONG; 
Repeat
Until ((LAYTONG - tong) >= (x div 10));
End; 

BEGIN 
t:= 100; 
ClrScr;
GetTime (hh, mm, ss, s100);
Writeln ('Start:', mm:2, ':', ss:2, ':', s100:2);
Wait(t);
GetTime (hh, mm, ss, s100); 
Write ('Stop:', mm:2, ':', ss:2, ':', s100:2);
Readln;
END.
ÿ