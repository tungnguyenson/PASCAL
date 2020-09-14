Program Hyperboloid;

Uses CRT, Graph;

Type
  gr3_toado = Record
    OX, OY, UX, UY, UZ : Integer;
    Xx, Xy : Real;
  End;

Const
  xp = 0.45;
  yp = 0.45;
  xa = -10;
  ya = -10;
  xb =  10;
  yb =  10;

Var
  gr3 : gr3_toado;
  x, y, z, t, t0 : Real;
  Page : Byte;

Function X_(x, y, z : Real) : Integer;
  Begin
    X_ := Round(gr3.OX+
                x*gr3.UX*Cos(gr3.Xx)+
                y*gr3.UY*Cos(gr3.Xy));
  End;

Function Y_(x, y, z : Real) : Integer;
  Begin
    Y_ := Round(gr3.OY+
                x*gr3.UX*Sin(gr3.Xx)+
                y*gr3.UY*Sin(gr3.Xy)-z*gr3.UZ);
  End;

Function Ham(x, y, t : Real) : Real;
  Begin
    Ham := t*sin(sqrt(x*x+y*y))/sqrt(x*x+y*y);
  End;

Procedure Khoi_Tao_Do_Hoa;
  Var
    GraphDriver, GraphMode : Integer;
  Begin
    GraphDriver := InstallUserDriver('EGAVGA', Nil);{}
{    GraphDriver := InstallUserDriver('SVGA256', Nil);{}
    GraphMode := 1;
    InitGraph(GraphDriver, GraphMode, '\TP\BGI');
  End;

Procedure Khoi_Tao_Ham;
  Begin
    With gr3 Do
      Begin
        OX := GetMaxX Div 2;
        OY := GetMaxY Div 4*2;
        UX := 15;
        UY := 15;
        UZ := 15;
        Xx := 0.8*Pi;
        Xy := 0.1*Pi;
      End;
  End;

Procedure Ve_Ham(t : Real; Color : Byte);
  Begin
    SetColor(Color);
    x := xa;
    z := Ham(xa, ya, t);
    MoveTo(X_(x, y, z), Y_(x, y, z));
    Repeat
      y := ya;
      Repeat
        z := Ham(x, y, t);
{        PutPixel(X_(x, y, z), Y_(x, y, z), 10);{}
        LineTo(X_(x, y, z), Y_(x, y, z));{}
        y := y+yp;
      Until y > yb;
      x := x+xp;
    Until x > xb;
  End;

BEGIN
  Khoi_Tao_Do_Hoa;
  Khoi_Tao_Ham;
  t := 0;
  t0 := 1;
  Page := 0;
  SetActivePage(Page);
  SetVisualPage(Page);
  Ve_Ham(t, 10);
  Repeat
    SetVisualPage(Page);
    Page := 1-Page;
    t := t+t0*0.15;
{    GR3.Xx := Gr3.Xx+0.010*t0;
    GR3.Xy := Gr3.Xy+0.005*t0;{}
    If (t >= 10)Or(t <= 0) Then t0 := -t0;
    SetActivePage(Page);
    SetFillStyle(1, 0);
    Bar(0, 0, GetMaxX, GetMaxY);
    Ve_Ham(t, 10);
  Until KeyPressed;
  ReadKey;
  CloseGraph;
END.