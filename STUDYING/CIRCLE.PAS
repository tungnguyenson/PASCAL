Uses Graph;

Var
  x0, y0 : Integer;
  i : Integer;
  Time : LongInt;

Procedure InitGraphMode;
  Var
    GraphDriver, GraphMode : Integer;
  Begin
    GraphDriver := VGA;
    GraphMode := VGAHi;
    InitGraph(GraphDriver, GraphMode, '\TP\BGI');
    x0 := GetMaxX Div 2;
    y0 := GetMaxY Div 2;
  End;

Procedure Delay(T : LongInt);
  Var
    i, j : LongInt;
  Begin
    For i := 1 To T Do
      For j := 0 To 1024 Do ;
  End;

Procedure MyCircle(PosX, PosY, Radius : Integer; Color : Byte);
  Var
    x, y, LastX, LastY : Integer;
    Angle, AngleInc : Real;
  Begin
    Angle := 0;
    AngleInc := 0.25;
    LastX := 0;
    LastY := 0;
    Repeat
      x := Round(Radius*Cos(Angle*Pi/180));
      y := Round(Radius*Sin(Angle*Pi/180));
      If (LastX <> x)Or(LastY <> y) Then
        Begin
          LastX := x;
          LastY := y;
          PutPixel(PosX+x, PosY-y, Color);
        End;
      Angle := Angle+AngleInc;
    Until Angle >= 360;
  End;

Procedure Quay;
  Const
    Radius = 50;
  Var
    PosX, PosY : Integer;
    x1, y1, x2, y2 : Integer;
    x01, y01, x02, y02 : Integer;
    Angle, AngleInc : Real;
  Begin
    PosX := Radius+1;
    PosY := y0;
    Angle := 0;
    AngleInc := -10;
    x01 := PosX;
    y01 := PosX;
    x02 := PosX;
    y02 := PosX;
    Repeat
      SetColor(10);
      x1 := PosX+Round(Radius*Cos(Angle*Pi/180));
      y1 := PosY-Round(Radius*Sin(Angle*Pi/180));
      x2 := PosX+Round(Radius*Cos((180+Angle)*Pi/180));
      y2 := PosY-Round(Radius*Sin((180+Angle)*Pi/180));
      Line(x1, y1, x2, y2);
      SetColor(0);
      Line(x01, y01, x02, y02);
      x01 := x1;
      y01 := y1;
      x02 := x2;
      y02 := y2;{}
      Delay(100);
{      SetColor(0);
      Line(x1, y1, x2, y2);{}

      Angle := Angle+AngleInc;
      If Angle <= -180 Then Angle := 0;
      If Round(Angle) Mod 20 = 0 Then
        If PosX < GetMaxX-Radius-1 Then Inc(PosX)
          Else PosX := Radius+1;
    Until False;
  End;

BEGIN
  InitGraphMode;
{  Time := MemL[0:$046C];
  For i := 1 To 200 Do
    MyCircle(x0, y0, i, 15);
  Time := MemL[0:$046C]-Time;{}
  Quay;
  ReadLn;
  CloseGraph;
  WriteLn(Time/18.2:10:5);
END.