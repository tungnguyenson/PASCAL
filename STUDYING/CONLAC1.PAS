Uses CRT, Graph;

Var
  MaxX, MaxY : Integer;
  Goc, TangGoc : Real;

Procedure Khoi_Tao_Do_Hoa;
  Var
    GD, GM : Integer;
  Begin
    GD := InstallUserDriver('EGAVGA', Nil);
    GM := 2;
    InitGraph(GD, GM, '\TP\BGI');
    MaxX := GetMaxX;
    MaxY := GetMaxY;
  End;

Function Radian(Degree : Real) : Real;
  Begin
    Radian := Degree/180*Pi;
  End;

Procedure Con_Lac_Don;
  Var
    DeltaX : Real;
    A, x, y, L, R, x1, y1 : Integer;
  Begin
    L := 100;
    A := Round(Sin(Radian(10))*L);
    R := 4;
    Goc := 0;
    TangGoc := 1;
    x := MaxX Div 2;
    y := MaxY Div 8;
    SetColor(8);
    Line(x-A-R-1, y+L+R+1, x+A+r+1, y+L+R+1);
{    Line(x-A-R-1, y, x+A+r+1, y);
    Line(x-A-R-1, y, x-A-R-1, y+L+R+1);
    Line(x+A+R+1, y, x+A+R+1, y+L+R+1);{}
    Repeat
      If Goc >= 360 Then Goc := 0;
      Goc := Goc+TangGoc;
      DeltaX := A*Sin(Radian(Goc));
      x1 := x+Round(DeltaX);
      y1 := y-Round(DeltaX*DeltaX/L)+L;
      SetColor(10);
      SetFillStyle(1, 10);
      FillEllipse(x1, y1, R, R);
      Line(x1, y1, x, y);
      SetColor(7);
      Line(x+Round(DeltaX)-R, y+L+R+1, x+Round(DeltaX)+R, y+L+R+1);
      Delay(5);
      SetColor(0);
      SetFillStyle(1, 0);
      Line(x1, y1, x, y);
      FillEllipse(x1, y1, R, R);
      SetColor(8);
      Line(x+Round(DeltaX)-R, y+L+R+1, x+Round(DeltaX)+R, y+L+R+1);
    Until KeyPressed;
  End;

BEGIN
  Khoi_Tao_Do_Hoa;
  Con_Lac_Don;
  CloseGraph;
END.