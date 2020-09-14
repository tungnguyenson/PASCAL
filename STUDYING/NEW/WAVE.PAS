Uses CRT, Graph;

Const
  MaxPixel = 125;

Procedure InitGraphMode(Driver : String; Mode : Integer);
  Var
    GraphDriver : Integer;
  Begin
    GraphDriver := InstallUserDriver(Driver, Nil);
    InitGraph(GraphDriver, Mode, '\tp\bgi');
  End;

Var
  P : Array[1..MaxPixel] Of Real;
  W : Real;
  A : Integer;
  t : Integer;
  Angle : Real;
  Angle0 : Real;
  MaxX, DX : Integer;
  bx : Real;

Procedure ShowWave(WaveColor : Byte);
  Begin
    SetColor(WaveColor);
    MoveTo(1, GetMaxY Div 2+Round(P[1]));
    For t := 1 To MaxPixel Do
      LineTo(1+(t-1)*DX, GetMaxY Div 2+Round(P[t]));{}
{    For t := 1 To MaxPixel Do
      PutPixel(1+(t-1)*DX, GetMaxY Div 2+Round(P[t]), 15);{}
{        PutPixel(1+(t-1)*DX, GetMaxY Div 2+Round(P[t]), t Mod 256);{}
  End;

Procedure HideWave;
  Begin
    SetColor(0);
    MoveTo(1, GetMaxY Div 2+Round(P[1]));
    For t := 1 To MaxPixel Do
      Begin
        LineTo(1+(t-1)*DX, GetMaxY Div 2+Round(P[t]));{}
        PutPixel(1+(t-1)*DX, Round(P[t]), 0);{}
      End;
  End;

Procedure DrawBoat(Color : Byte);
  Var
    X, Y : Integer;
  Begin
    x := Round(bx)*dx;
    y := GetMaxY Div 2+Round(P[Round(bx)])-1;
    SetColor(Color);
    Line(x-7, y-1, x+7, y-1);
    Line(x-7, y, x+7, y);
    Line(x-5, y+1, x+5, y+1);
    Line(x, y-11, x, y);
    Line(x+1, y-12, x+1, y-4);
    Line(x+2, y-11, x+2, y-4);
  End;

Procedure ShowBoat;
  Var
    X, Y : Integer;
  Begin
    x := Round(bx)*dx;
    y := GetMaxY Div 2+Round(P[Round(bx)])-1;
    SetColor(9);
    Rectangle(x-5, y, x+5, y+1);
    Line(x, y-10, x, y);
  End;

BEGIN
  InitGraphMode('SVGA256', 2);
  A := 4;
  W := 8;
  Angle0 := 0;
  bx := maxpixel-3;
  DX := ((GetMaxX-1) Div MaxPixel);
  MaxX := (MaxPixel-1)*DX;
  If MaxX > GetMaxX Then
    Begin
      Dec(DX);
      MaxX := (MaxPixel-1)*DX;
    End;
  SetColor(8);
  Rectangle(0, 0, MaxX+2, GetMaxY);
  Repeat
    Angle := Angle0;
    For t := 1 To MaxPixel Do
      Begin
        P[t] := A*Sin((Pi/180)*Angle);
        Angle := Angle+W;
        If Angle >= 360 Then Angle := 0;
      End;
    ShowWave(8);
{    DrawBoat(7);{}
    Delay(4);
    HideWave;
{    DrawBoat(0);{}
    If Random(2) = 0 Then bx := bx-Random;
    If bx < 3 Then bx := maxpixel-3;
    Angle0 := Angle0+W;
    If Angle0 >= 360 Then Angle0 := 0;
  Until Keypressed;
  CloseGraph;
END.