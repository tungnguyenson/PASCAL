(*Chuong trinh minh hoa*)
PROGRAM TestRGB;
USES Crt,Brghtnss;
const delaytimes=255 ;
var i:byte;
ch:char;
begin
 ClrScr;
 InitBrghtnss;
 Randomize;
 for i:=1 to 100 do
 begin
  GotoXY(Random(80)+1,Random(24)+1);
  TextAttr:=Random(16);
  Write('BT Tin Hoc');
 end;
 ch:=ReadKey;
 DecBrghtnss(delaytimes);
 Write(#7);
 ch:=Readkey;
 RestoreScr(delaytimes);
 DoneBrghtnss;
 ch:=Readkey;
end.
