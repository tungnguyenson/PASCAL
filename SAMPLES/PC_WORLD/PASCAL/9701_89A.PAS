PROGRAM TestBrightness;
USES Crt,Brghtnss;
var i:word;
ch:char;
begin
Randomize;
for i:=1 to 500 do
begin
Gotoxy(Random(80)+1,Random(24)+1);
TextAttr:=Random(16);
Write('Ban tin Tin Hoc 12');
end;
DecBrightness;
NormalBrightness;
End.

