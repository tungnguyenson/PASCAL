Program Time_Counter1;
Uses
 CRT, DOS;
Var
 t, hh, mm, ss, s100 : word;
BEGIN
t := 1000;
ClrScr; 
GetTime(hh,mm, ss,s100); 
Writeln('Start: ', mm:2 ,  ':', ss:2, ':', s100:2);
Delay(t);
GetTime(hh,mm,ss,s100);
Write ('Stop: ',mm:2, ':', ss:2, ':', s100:2);
Readln;
END.
ÿ