Program Change_Wall;
{$M 8192,0,0} 
{Writen by Duong Tung lam, 1966} 
{Language TurboPascal 6.0} 

Uses Dos, crt; 
Const 
 Days: array [0..6] of String [9] = ('Sunday', 'Monday',
       'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
Var
 y, m, d, dow: Word;
 WallDir, DestDir: string;

Procedure Execdos (Command: string); 
Begin  
 SwapVectors;
 Exec(getenv('comspec'), '/C' + Command);
 SwapVectors;
End;

BEGIN (*main program*)
GetDate(y,m,d,dow);
Walldir:=paramstr(1);
DestDir:=Paramstr(2);
if (paramstr(1)= '') or (paramstr(2) = '') then
Begin
 clrscr;
 writeln ('Wallpper-Copyright (c) by Duong Tung lam, 1966');
 writeln ('.........................................');
 writeln ('Syntax: WALL <Wallpaper Directory> <Windows Directory>');
 writeln;
 exit;
end
else
begin
 if days[dow]='Sunday' then
  Execdos ('Copy'+ WallDir + '\sun.bmp'+ 
               DestDir + '\Wall.bmp/y');
 if days[dow]='Monday' then
  Execdos ('Copy'+WallDir + '\mon.bmp' + 
               DestDir +'\Wall.bmp/y');
 if days[dow]='Tuesday' then
  Execdos ('Copy'+WallDir + '\Tue.bmp' + 
               DestDir + '\Wall.bmp/y');
 if days[dow]='Wednesday' then
  Execdos ('Copy'+WallDir + '\Wed.bmp' + 
               DestDir + '\Wall.bmp/y');
 if days[dow]='Thursday' then
  Execdos ('Copy'+ WallDir + '\thr.bmp' + 
               DestDir + '\Wall.bmp/y');
 if days[dow]='Friday' then
  Execdos ('Copy'+WallDir + '\fri.bmp' + 
               DestDir +'\Wall.bmp/y');
 if days[dow]='Saturday' then
  Execdos ('Copy'+WallDir + '\sat.bmp' + 
               DestDir + '\Wall.bmp/y');
end;
END. 
