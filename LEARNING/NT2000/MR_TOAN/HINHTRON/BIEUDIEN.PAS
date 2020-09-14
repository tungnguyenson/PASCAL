Uses CRT, Graph;

Const
  Max = 100;
  TenTepDL = 'BL3.INP';
  TenTepKQ = 'BL3.OUT';
  Ox = 100;
  Oy = 378;
  Tile = 50;

Type
  HinhTron = Record
    x, y, r : Word;
  End;

Var
  HT : Array[1..Max] Of HinhTron;
  Lop : Array[1..Max, 1..Max] Of Word;
  SoPTLop : Array[1..Max] Of Word;
  N, SoLop : Word;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Word;
    x, y, R : Real;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      Begin
        ReadLn(F, x, y, R);
        HT[i].x := Round(x);
        HT[i].y := Round(y);
        HT[i].R := Round(R);
      End;
    Close(F);
  End;

Procedure Doc_Ket_Qua;
  Var
    F : Text;
    i, j : Word;
  Begin
    Assign(F, TenTepKQ);
    Reset(F);
    ReadLn(F, SoLop);
    For i := 1 To SoLop Do
      Begin
        Read(F, SoPTLop[i]);
        For j := 1 To SoPTLop[i] Do
          Read(F, Lop[i, j]);
      End;
    Close(F);
  End;

Procedure Khoi_Tao_Graph;
  Var
    GD, GM : Integer;
  Begin
    GD := Detect;
    InitGraph(GD, GM, 'C:\TP\BGI');
  End;

Procedure WriteNumber(x, y, N : Integer);
  Var
    S : String;
  Begin
    Str(N, S);
    OutTextXY(x, y, S);
  End;

Procedure Ve_Truc_Toa_Do;
  Var
    i : Integer;
  Begin
    SetColor(7);
    Line(Ox, 0, Ox, GetMaxY);
    Line(0, Oy, GetMaxX, Oy);
    SetColor(15);
    For i := 1 To GetMaxX Div Tile Do
      Begin
        SetColor(15);
        SetLineStyle(0, 0, 1);
        Line(i*Tile, Oy-2, i*Tile, Oy+2);
        If (Tile >= 20)And(i <> Ox Div Tile) Then
          Begin
            WriteNumber(i*Tile-8, Oy+5, i-Ox Div Tile);
            SetColor(8);
            SetLineStyle(1, 0, 1);
            Line(i*Tile, 0, i*Tile, GetMaxY);
          End;
      End;
    For i := 1 To GetMaxY Div Tile Do
      Begin
        SetColor(15);
        SetLineStyle(0, 0, 1);
        Line(Ox-2, GetMaxY-i*Tile, Ox+2, GetMaxY-i*Tile);
        If (Tile >= 20)And(i <> Oy Div Tile) Then
          Begin
            WriteNumber(Ox-20, GetMaxY-i*Tile-4, GetMaxY Div Tile-i);
            SetColor(8);
            SetLineStyle(1, 0, 1);
            Line(0, GetMaxY-i*Tile, GetMaxX, GetMaxY-i*Tile);
          End;
      End;
  End;

Procedure Bieu_Dien;
  Var
    i : Word;
  Begin
    For i := 1 To N Do
      Begin
        SetColor(i Mod 15+1);
        Circle(Ox+HT[i].x*Tile, Oy-HT[i].y*Tile, HT[i].r*Tile);
        WriteNumber(Ox+HT[i].x*Tile, Oy-HT[i].y*Tile, i);
      End;
  End;

Procedure Bieu_Dien_KQ;
  Var
    i, j : Word;
  Begin
    For i := 1 To SoLop Do
      Begin
        SetFillStyle(1, i Mod 14+1);
        For j := 1 To SoPTLop[i] Do
          With HT[Lop[i, j]] Do
            Begin
              SetColor(j Mod 15+1);
              FillEllipse(Ox+x*Tile, Oy-y*Tile, r*Tile, r*Tile);
              WriteNumber(Ox+x*Tile, Oy-y*Tile, i);
            End;
        ReadLn;{}
      End;
  End;

BEGIN
  Doc_Du_Lieu;
  Khoi_Tao_Graph;
  Ve_Truc_Toa_Do;
  Bieu_Dien;
  ReadLn;
{  Doc_Ket_Qua;
  Bieu_Dien_KQ;{}
  CloseGraph;
END.