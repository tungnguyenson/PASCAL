
uses Crt; 
type 
 Character=record 
  Char,Color:byte; 
 end; 
 ScreenMemory=array[1..25,1..80] of Character; 
 Windows=record 
  X1,Y1,X2,Y2,Color: integer; 
  LastScreen: ScreenMemory; 
 end; 
var 
 Screen: ScreenMemory absolute $B800:$0000; 
 Win:array[1..5] of Windows; 
 SaveScreen:ScreenMemory; 

procedure WriteXY(X,Y:integer; St:string; Color:byte); 
var 
 I:byte; 
begin 
for I:=1 to Length(St) do 
 begin 
  Screen[Y,X+I-1].Color:=Color; 
  Screen[Y,X+I-1].Char:=Ord(St[I]); 
 end; 
end; 

{Giam do sang cua mau sac}
procedure DarkNess (var Color:byte); 
begin 
Color:=Color-(Color div 8)*8; 
end; 

{Khoi tao mot cua so}
procedure InitWindow(Num:byte); 
var 
 I,J:integer; 
begin 
with Win[Num] do 
begin 
 LastScreen:=Screen; 
 for I:=X1+1 to X2-1 do 
 begin 
  WriteXY(I,Y1,#196,$7F);
  WriteXY(I,Y2,#196,$7F); 
  for J:=Y1+1 to Y2-1 do WriteXY(I,J,#32,Color*16+15); 
 end; 
 for J:=Y1+1 to Y2-1 do 
 begin 
  WriteXY(X1,J,#179,$7F); 
  WriteXY(X2,J,#179,$7F); 
 end; 
 WriteXY(X1,Y1,#218,$7F); 
 WriteXY(X2,Y1,#191,$7F); 
 WriteXY(X1,Y2,#192,$7F); 
 WriteXY(X2,Y2,#217,$7F); 
 for I:=X1+2 to X2+2 do 
  if (I in [1..80]) and (Y2 < 25) then 
   DarkNess (Screen [Y2+1,I].Color); 
 for I:=Y1+1 to Y2 do 
  if I in[1..25] then 
  begin 
   if X2 < 80 then DarkNess (Screen [I,X2+1] .Color); 
   if X2 < 79 then DarkNess (Screen [I,X2+2] .Color); 
  end; 
 end; 
end; 

{Di chuyen mot cua so} 
procedure MoveWindow(Num:byte); 
label TryAgain; 
var 
 Ch:char; 
 X, Y, LessX, LessY, I, J, MX1, MX2, MY1, MY2: integer; 
 WinMove, Wall: ScreenMemory; 
Begin 
X:=WhereX; 
Y:= WhereY; 
with Win[Num] do 
 if (X in [X1+1..X2-1])and(Y in [Y1+1..Y2-1]) then
 begin 
  X:=X-X1; 
  Y:=Y-Y1; 
 end 
 else X:=0; 
for I:=1 to 80 do 
 for J:=1 to 25 do 
  WinMove[J,I]:=Screen[J,I]; 
MX1:=Win[Num].X1; 
MX2:=Win[Num].X2; 
MY1:=Win[Num].Y1; 
MY2:=Win[Num].Y2; 
with Win[Num+1] do 
begin 
 X1:=30; Y1:=12; X2:=50; Y2:=14; Color:=4; 
 InitWindow(Num+1); 
 WriteXY(34,13, 'Moving Window',$4E); 
end; 
with Win[Num] do 
repeat 
 TryAgain: 
 Ch:=Readkey; 
 LessX:=0; LessY:=0; 
 case Ch of 
  #72: LessY:=-1; 
  #75: LessX:=-1; 
  #80: LessY:=1; 
  #77: LessX:=1; 
  #13:; 
  else goto TryAgain; 
 end; 
 if(X1+LessX > 80) or (X2+ LessX < 1) or (Y1+LessY> 25) or (Y2+LessY < 1) 
 then goto TryAgain; 
 for I:=1 to 80 do 
 for J:=1 to 25 do Wall[J,I]:= LastScreen[J,I]; 
 X1:=X1+LessX; 
 Y1:=Y1+LessY; 
 X2:=X2+LessX; 
 Y2:=Y2+LessY; 
 If X <> 0 then GotoXY(X1+X,Y1+Y); 
 for I:=X1 to X2 do 
 for J:=Y1 to Y2 do 
  if (I in [1..80])and(J in [1..25]) then 
   if not((I in [30..50])and(J in [12.. 14])) then 
    Wall[J,I]:= WinMove[J-Y1+MY1, I-X1+MX1]; 
  if Y2 < 25 then 
   for I:=X1+2 to X2+2 do 
    if I in [1..80] then DarkNess(Wall[Y2+1, I].Color); 
  For I:=Y1+1 to Y2 do 
  if I in [1..25] then
  begin 
   if X2 < 80 then DarkNess (Wall [I, X2+1] .Color);
   if X2 < 79 then DarkNess (Wall [I, X2+2] .Color); 
  end; 
  for I:=32 to 52 do DarkNess(Wall[15,I].Color); 
  for I:=13 to 14 do 
  begin 
   DarkNess(Wall[I,51].Color); DarkNess(Wall[I,52].Color); 
  end; 
  for I:=1 to 80 do 
  for J:=1 to 25 do 
   if not((I in [30..50]) and (J in [12..14])) then 
     Screen[J,I]:=Wall[J,I]; 
until Ch=#13; 
end; 

{Chuong trinh chinh}
BEGIN 
SaveScreen:=Screen; GotoXY(44,11); 
with Win[1] do 
begin 
 X1:=16; Y1:=8; X2:=64; Y2:=18; Color:=1; InitWindow(1); 
end; 
WriteXY(22,11,'Program: Moving Windows',$1B);
WriteXY(22,12,'Name: Nguyen Thanh Trung',$1F);
WriteXY(22,13,'Class: 10A Chuyen tin - DHTH, Ha Noi',$1E);
WriteXY(22,14,'Address: F203-I7, Phuong Mai, Dong Da',$1A);
WriteXY(22,15,'Tel : 8.522634',$1D);
MoveWindow(1); Screen:=SaveScreen;
END.
