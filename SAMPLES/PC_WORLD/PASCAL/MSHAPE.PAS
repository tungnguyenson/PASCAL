Uses Crt,Mouse,Graph,Dos;
Const
 Y1Screen=80;
 Y2Screen=400;
 X1Screen=160;
 X2Screen=480;
 ScreenLimit=460;
 X1OkButton=290;
 Y1OkButton=420;
 X2OkButton=350;
 Y2OkButton=440;
 Distance=20;
Type
 Shape=Record
  Name:String[30];
  Shp:Array[1..16,1..2] of byte;
  Xpoint,Ypoint:Integer;
 End;
 FileName=String[30];
Var
 TmpGrid:Array[1..16,1..16] of integer;
 Display,mode,i,j,k,x,y,celli,cellj:Integer;
 CellGrid:Array[1..16,1..2] of byte;
 F:File of Shape;
 TmpShape:Shape;
 Sample,t:Byte;
 GoOn:Boolean;
 FN:FileName;
Function OK(Var x,y:Integer):Boolean;
Begin
 If (y>Y1OkButton) And (y<Y2OkButton) And (x>X1OkButton) And (x<X2OkButton) then Ok:=True
 Else OK:=False;
End;
Procedure Message(M:String);
Var
 Ch:Char;
 i:Integer;
Begin
 SetTextStyle(0,0,1);
 OutTextXY((640-Length(M)*8) div 2,60,M);
 FN:='';
 i:=0;
 Ch:=Readkey;
 While Ch<>#13 do begin
  FN:=FN+Ch;
  OutTextXY(((640-Length(M)*8) div 2)+(Length(M)+i)*8,60,Ch);
  Ch:=Readkey;
  i:=i+1;
 End;
End;
Begin
 Display:=Detect;
 InitGraph(Display,mode,'');
 SetbkColor(Black);
 SetColor(Yellow);
 SetFillStyle(1,LightCyan);
 SetWriteMode(Copyput);
 SetTextStyle(0,0,2);
 SetTextJustify(0,0);
 MouseReset;
 MouseSetLimit(X1Screen,X2Screen,Y1Screen,ScreenLimit);
 Rectangle(X1Screen,Y1Screen,X2Screen,ScreenLimit);
 For i:=1 to 16 do line(X1Screen,Y1Screen+i*Distance,X2Screen,Y1Screen+i*Distance);
 For j:=1 to 16 do line(X1Screen+j*Distance,Y1Screen,X1Screen+j*Distance,Y2Screen);
 SetColor(Cyan);
 Bar3D(X1OkButton,Y1OkButton,X2OkButton,Y2OkButton,2,TopOn);
 Floodfill(X1OkButton+2,Y1OkButton+2,Cyan);
 SetColor(Red);
 OutTextXY(304,439,'OK');
 SetColor(Cyan);
 MouseShow;
 For i:=1 to 16 do for j:=1 to 16 do TmpGrid[i,j]:=0;
 GoOn:=True;
 Sample:=0;
 While GoOn=True do begin
  If MouseLPressed then
  Begin
   MouseGetPosition(x,y);
   Repeat
   Until MouseLReleased;
   If (y<Y2Screen) then begin
    Cellj:=((x-X1Screen) div Distance)+1;
    Celli:=((y-Y1Screen) div Distance)+1;
    TmpGrid[Celli,Cellj]:=TmpGrid[Celli,Cellj] Xor $1;
    If TmpGrid[Celli,Cellj] =1 then begin
     MouseHide;
     SetFillStyle(1,LightCyan);
     FloodFill(x,y,Yellow);
     MouseShow;
    End
    Else begin
     MouseHide;
     SetFillStyle(1,Black);
     FloodFill(x,y,Yellow);
     MouseShow;
    End;
   End;
   If OK(x,y) then begin
    For i:=1 to 16 do
     For j:=1 to 16 do begin
      If j<=8 then k:=j
      Else k:=j-8;
      Sample:=Sample+(TmpGrid[i,j]*(1 shl (8-k)));
      If (k=8) then begin
       TmpShape.Shp[i,j div 8]:=Sample;
       Sample:=0;
      End;
     End;
     GoOn:=False;
   End;
  End;
 End;
 SetTextStyle(0,0,1);
 OutTextXY(180,40,'Click right button for mouse point.');
 GoOn:=True;
 While GoOn=True do
 If MouseRPressed then begin
  MouseGetPosition(x,y);
  Repeat
  Until MouseRReleased;
  If (y<Y2Screen) then begin
   Cellj:=((x-X1Screen) div Distance);
   Celli:=((y-Y1Screen) div Distance);
   TmpShape.Xpoint:=Cellj;
   TmpShape.Ypoint:=Celli;
   MouseHide;
   SetFillStyle(1,Red);
   FloodFill(x,y,Yellow);
   MouseShow;
  End;
  GoOn:=False;
 End;
 Message('Input name for this shape: ');
 TmpShape.Name:=FN;
 {$I-}
 Assign(F,'C:\TURBO\BIN\MSHAPE.DAT');
 Reset(F);
 {$I+}
 If IOResult<>0 then begin
  {$I-}
  Assign(F,'C:\TURBO\BIN\MSHAPE.DAT');
  Rewrite(F);
  {$I+}
 End;
 Seek(F,FileSize(F));
 Write(F,TmpShape);
 Close(F);
End.

