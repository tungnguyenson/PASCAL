Uses CRT, Graph;

Const
  TenTepDL = 'nd.in3';
  MaxN = 100;
  N : Byte = 100;

Var
  A : Array[1..MaxN, 1..MaxN] Of Byte;
  HSX, HSY : Word;
  X0, Y0, XMax, YMax : Word;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      For j := 1 To N Do
        Read(F, A[i, j]);
    Close(F);
  End;

Procedure Khoi_Tao;
  Var
    GD, GM : Integer;
  Begin
    GD := InstallUserDriver('EGAVGA', Nil);
    GM := 2;
    InitGraph(GD, GM, '\TP\BGI');
    X0 := 20;
    Y0 := 20;
    XMax := GetMaxX-20;
    YMax := GetMaxY-20;
  End;

Procedure Bieu_Dien;
  Var
    i, j : Byte;
    x1, y1, x2, y2 : Word;
  Begin
    HSX := (XMax-X0) Div N;
    HSY := (YMax-Y0) Div N;
    SetFillStyle(1, 1);
    SetColor(7);
    For i := 1 To N+1 Do
      Line(x0, y0+(i-1)*HSY, x0+N*HSX, y0+(i-1)*HSY);
    For j := 1 To N+1 Do
      Line(x0+(j-1)*HSX, y0, x0+(j-1)*HSX, y0+N*HSY);
    For i := 1 To N Do
      For j := 1 To N Do
        Begin
          y1 := y0+(i-1)*HSY;
          x1 := x0+(j-1)*HSX;
          y2 := y1+HSY;
          x2 := x1+HSX;
          Case A[i ,j] Of
            0 : Begin
                  Line(x1, y1, x2, y2);
                  FloodFill(x2-1, y1+1, 07);
                End;
            1 : Begin
                  Line(x1, y1, x2, y2);
                  FloodFill(x1+1, y2-1, 07);
                End;
            2 : Begin
                  Line(x1, y2, x2, y1);
                  FloodFill(x1+1, y1+1, 07);
                End;
            3 : Begin
                  Line(x1, y2, x2, y1);
                  FloodFill(x2-1, y2-1, 07);
                End;
          End;
        End;
  End;

Procedure Sinh_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
    OK : Char;
  Begin
    Randomize;
    Repeat
      For i := 1 To N Do
        For j := 1 To N Do
          A[i, j] := Random(4);
      Bieu_Dien;
      OutTextXY(0, YMax+4, 'Co sinh tiep khong?[Y/N]: ');
      OK := Upcase(ReadKey);
    Until OK = 'N';
    Assign(F, TenTepDL);
    Rewrite(F);
    WriteLn(F, N);
    For i := 1 To N Do
      Begin
        For j := 1 To N Do Write(F, A[i, j], ' ');
        WriteLn(F);
      End;
    Close(F);
  End;

BEGIN
  Khoi_Tao;
{  Sinh_Du_Lieu;{}
  Doc_Du_Lieu;
  Bieu_Dien;{}
  ReadLn;
  CloseGraph;
END.