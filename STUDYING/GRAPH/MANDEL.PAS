Uses CRT, Graph;

Const
  Thresh = 40;
  Num = 16;

Var
  cx, cy : Real;
  i, j, Count, Color, NumColors, NumRows, NumCols : Integer;
  Left, Right, Top, Bottom : Integer;

Procedure Khoi_Tao_Do_Hoa;
  Var
    GraphDriver, GraphMode : Integer;
  Begin
    GraphDriver := InstallUserDriver('EGAVGA', Nil);{}
{    GraphDriver := InstallUserDriver('SVGA256', Nil);{}
    GraphMode := 2;
    InitGraph(GraphDriver, GraphMode, '\TP\BGI');
  End;

Function MandelCount(cx, cy : Real) : Integer;
  Var
    x, y, tmp, fsq : Real;
    Count : Integer;
  Begin
    x := cx;
    y := cy;
    fsq := x*x+y*y;
    Count := 1;
    While (Count <= Num)And(fsq <= Thresh) Do
      Begin
        tmp := x;
        x := x*x-y*y+cx;
        y := 2*tmp*y+cy;
        fsq := x*x+y*y;
        Inc(Count);
      End;
    MandelCount := Count;
  End;

BEGIN
  Khoi_Tao_Do_Hoa;
  Left := 1;
  Right := 10;
  Top := 1;
  Bottom := 10;
  NumRows := Bottom-Top;
  NumCols := Right-Left;
  NumColors := 8;
  For i := 1 To NumRows Do
    For j := 1 To NumCols Do
      Begin
        cx := Left+(Right-Left)*(j-1)/(NumCols-1);
        cy := Top+(Bottom-Top)*(i-1)/(NumRows-1);
        Count := MandelCount(cx, cy);
        If Count = Num Then Color := 0
         Else Color := Trunc((NumColors)*(1.0-Count/Num));
        PutPixel(320+j, 240+i, Color);
      End;
  ReadKey;
  CloseGraph;
END.