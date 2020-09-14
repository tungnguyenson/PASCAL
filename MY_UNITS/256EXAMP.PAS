Uses Graph, Graph256;

Var
  i, j, k : Byte;
  Color : Byte;

BEGIN
  Init256Mode(2);
{  For i := 0 To GetMaxY Do
    Begin
      Color := i Mod 256;
      SetColor(Color);
      Line(0, i, GetMaxX, i);
    End;{}
  j := 3;
  For i := j*32 To j*32+31 Do
    Begin
      SetColor(i);
{      Line(0, i, GetMaxX, i);{}
      k := i-j*32;
      Rectangle(100-k, 100-k, 100+k, 100+k);
{      Circle(100, 100, i-j*32);{}
    End;
  ReadLn;
  CloseGraph;
END.