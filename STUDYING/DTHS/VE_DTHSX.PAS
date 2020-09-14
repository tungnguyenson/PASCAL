{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+}
{$M 16384,0,655360}

{  Cach ve ham y = f(x):
     - Dat dieu kien de ham so co nghia vao FUNCTION ThoaManDieuKien.
     - Dat f(x) vao FUNCTION Gia_Tri_Ham.
     - Run.
     - Nhap vao:
         + Doan can xet: x î [Left, Right].
         + Mien gia tri gioi han: y î [Bottom, Top].
}
Program Ve_Do_Thi_Ham_So;

Uses Graph;

Const
  Rad = 360/(2*Pi);
  DoChinhXac = 0.0005;

Function ThoaManDieuKien(x : Real) : Boolean;
  Begin
    ThoaManDieuKien := False;
    If (Sin(x) <> 0)And(Cos(x) <> 0) Then
      ThoaManDieuKien := True;{}
  End;

Function Gia_Tri_Ham(x : Real) : Real;
  Begin
    Gia_Tri_Ham := 1/Sqrt(Cos(x)*Cos(x)-5/2*Cos(x)+7/4);
  End;

Var
  x0, y0 : Integer;
  xv1, xv2, yv1, yv2 : Integer;
  dx, dy : Real;
  LoopCount : Integer;
  Min : Real;
  Left, Right, Bottom, Top : Real;
  vpTop, vpLeft, vpWidth, vpHeight : Integer;
  TimePack : LongInt;

Procedure _MoveTo(x, y : Real);
  Begin
    MoveTo(Round(x0+x), Round(y0-y));
  End;

Function _GetPixel(x, y : Real) : Byte;
  Begin
    _GetPixel := GetPixel(Round(x0+x), Round(y0-y));
  End;

Procedure _PutPixel(x, y : Real; Color : Byte);
  Begin
    PutPixel(Round(x0+x), Round(y0-y), Color);
  End;

Procedure _Line(x1, y1, x2, y2 : Real; Color : Byte);
  Begin
    SetColor(Color);
    Line(Round(x0+x1), Round(y0-y1), Round(x0+x2), Round(y0-y2));
  End;

Procedure _OutStr(x, y : Real; St : String; Color : Byte);
  Begin
    SetColor(Color);
    OutTextXY(Round(x0+x), Round(y0-y), St);
  End;

Procedure _OutNum(x, y : Real; i : Integer; Color : Byte);
  Var
    St : String;
  Begin
    SetColor(Color);
    Str(i, St);
    OutTextXY(Round(x0+x), Round(y0-y), St);
  End;

Procedure Khoi_Tao_Do_Hoa;
  Var
    GraphDriver, GraphMode : Integer;
  Begin
    GraphDriver := InstallUserDriver('EGAVGA', Nil);{}
{    GraphDriver := InstallUserDriver('SVGA256', Nil);{}
    GraphMode := 3;
    InitGraph(GraphDriver, GraphMode, '\TP\BGI');
  End;

Procedure Khoi_Tao;
  Begin
    vpWidth := 400;
    vpHeight := 400;
    vpLeft := (GetMaxX+1-vpWidth)Div 2;
    vpTop := (GetMaxY+1-vpHeight)Div 2;
{    Left   := -10;
    Right  := 10;
    Bottom := -1;
    Top    := 1;{}
    dx := vpWidth/(Right-Left);
    dy := vpHeight/(Top-Bottom);
    xv1 := Round((Left-0.5)*dx);
    xv2 := Round((Right+0.5)*dx);
    yv1 := Round((Bottom-0.5)*dy);
    yv2 := Round((Top+0.5)*dy);
    x0 := vpLeft-xv1-Round(0.5*dx){};
    y0 := vpTop+yv2-Round(0.5*dy){};
    LoopCount := 0;
    Min := 2;
  End;

Procedure Ve_Truc_Toa_Do;
  Var
    x, y, i, j : Integer;
    x1, y1, x2, y2 : Integer;
    S : String;
  Begin
{    SetFillStyle(1, 8);
    Bar(0, 0, GetMaxX, GetMaxY);
    SetFillStyle(1, 0);
    Bar(x0+xv1, y0-yv1, x0+xv2, y0-yv2);{}

    _Line(xv1, 0, xv2, 0, 8);
    _Line(0, yv1, 0, yv2, 8);

    SetLineStyle(1, 0, 1);
    x1 := xv1+Round(0.5*dx);
    x2 := xv2-Round(0.5*dx);
    y1 := yv1+Round(0.5*dy);
    y2 := yv2-Round(0.5*dy);
    _Line(x1, y1, x2, y1, 8);
    _Line(x1, y2, x2, y2, 8);
    _Line(x1, y1, x1, y2, 8);
    _Line(x2, y1, x2, y2, 8);{}

    SetLineStyle(0, 0, 1);
    { Draw arrows }
    _Line(xv2, 0, xv2-5, -3, 7);
    _Line(xv2, 0, xv2-5,  3, 7);
    _Line(0, yv2, -3, yv2-3, 7);
    _Line(0, yv2,  3, yv2-3, 7);

    _OutStr(-12, yv2, 'y', 7);
    _OutStr(xv2-7, -5, 'x', 7);
    _OutStr(8, -5, 'O', 7);

    SetColor(7);
    Str(Round(Left), S);
    i := Round((TextWidth(S)+2)/dx);
    If i = 0 Then i := 1;
    Str(Round(Bottom), S);
    j := Round((TextHeight(S)+2)/dy);
    If j = 0 Then j := 1;
    For x := Round(Left) To Round(Right) Do
      If (x <> 0)and(x mod i = 0) Then
        Begin
          _Line(Round(x*dx), -1, Round(x*dx), 1, 7);
           _OutNum(Round(x*dx), -5, x, 8);
        End;
    For y := Round(Bottom) To Round(Top) Do
      If (y <> 0)And(y mod j = 0) Then
        Begin
          _Line(-1, Round(y*dy), 1, Round(y*dy), 7);
          _OutNum(5, Round(y*dy), y, 8);
        End;
    _PutPixel(0, 0, 7);
  End;

Procedure Ve_DTHS(Left, Right : Real);
  Var
    x, y : Real;
  Begin
    If (MemL[0:$46C]-TimePack)/18.2 > 5 then Exit;
    Inc(LoopCount);
    x := (Left+Right)/2;
    If x-Left >= DoChinhXac Then
      Begin
        If ThoaManDieuKien(x) Then
          Begin
            y := Gia_Tri_Ham(x);
            If (y >= Bottom)And(y <= Top) Then
              _PutPixel(x*dx, y*dy, 15);
          End;
        Ve_DTHS(Left, x);
        Ve_DTHS(x, Right);
      End;
  End;

Function ReadBound : Boolean;
  Var
    stLeft, stRight, stBottom, stTop : String;
    i : Integer;
    Error : Boolean;
    Default : Integer;
  Begin
    Default := 10;
    Write('Left  [', -Default, ']: '); ReadLn(stLeft);
    Write('Right [',  Default, ']: '); ReadLn(stRight);
    Write('Bottom[', -Default, ']: '); ReadLn(stBottom);
    Write('Top   [',  Default, ']: '); ReadLn(stTop);
    Error := False;
    If stLeft   = '' Then Str(-Default, stLeft);
    If stRight  = '' Then Str(Default, stRight);
    If stBottom = '' Then Str(-Default, stBottom);
    If stTop    = '' Then Str(Default, stTop);
    Val(stLeft, Left, i);
    If i <> 0 Then Error := True;
    Val(stRight, Right, i);
    If i <> 0 Then Error := True;
    Val(stBottom, Bottom, i);
    If i <> 0 Then Error := True;
    Val(stTop, Top, i);
    If i <> 0 Then Error := True;
    If (Left >= Right)Or(Bottom >= Top) Then Error := True;
    ReadBound := Error = False;
  End;

BEGIN
  If ReadBound = False Then
    Begin
      WriteLn('Data input error!');
      Exit;
    End;
  Khoi_Tao_Do_Hoa;
  Khoi_Tao;
  Ve_Truc_Toa_Do;
  TimePack := MemL[0:$46C];
  Ve_DTHS(Left, Right);
  ReadLn;
  CloseGraph;
END.

{
 Mot so ham tieu bieu:
   y = 1/x
   y = (4*x)/(x*x*x*x+1)
   y = Sin(x)
}