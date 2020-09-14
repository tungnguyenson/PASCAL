Uses CRT, Graph;

Const
  TenTepDL = 'BIT.IN0';
  TenTepKQ = 'BIT.OUT';
  MaxMN = 100;
  a = 10;

Var
  Map : Array[0..MaxMN+1, 0..MaxMN+1] Of Byte;
  Gd, Gm: Integer;
  Row, Col : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
    Ch : Char;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, Row, Col);
    FillChar(Map, SizeOf(Map), 0);
    For i := 1 To Row Do
      Begin
        For j := 1 To Col Do
          Begin
            Read(F, Ch);
            Map[i, j] := Ord(Ch)-48;
          End;
        ReadLn(F);
      End;
    Close(F);
  End;

Procedure Sinh_Du_Lieu(M, N : Byte);
  Var
    F : Text;
    i, j : Byte;
  Begin
    Randomize;
    Assign(F, TenTepDL);
    Rewrite(F);
    WriteLn(F, M, ' ', N);
    For i := 1 To M Do
      Begin
        For j := 1 To N Do Write(F, Random(2));
        WriteLn(F);
      End;
    Close(F);
  End;

Procedure Bieu_Dien;
  Var
    i, j : Byte;
  Begin
    For i := 1 To Row Do
      For j := 1 To Col Do
        Begin
          If Map[i, j] = 1 Then SetFillStyle(1, 8)
                           Else SetFillStyle(1, 7);
          Bar((j-1)*a+1, (i-1)*a+1, (j-1)*a+a-1, (i-1)*a+a-1);
        End;
    SetColor(15);
    Rectangle((11-1)*a+1, (10-1)*a+1, (15-1)*a+a-1, (11-1)*a+a-1);
  End;

BEGIN
{  Sinh_Du_Lieu(20, 20);{}
  Doc_Du_Lieu;
  GD := Detect;
  InitGraph(GD, GM, '\TP\BGI');
  Bieu_Dien;
  ReadLn;
  CloseGraph;
END.