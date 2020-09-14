Uses CRT, Graph;

Const
  MaxN = 200;
  a = 10;
  Next : Array[1..4, 1..2] Of ShortInt = ((-1, 0), (0, -1), (0, 1), (1, 0));
  TenTepDL = 'C.i5';
  TenTepKQ = 'CASTLE.OUT';

Type
  Mang = Array[1..MaxN, 1..MaxN] Of Byte;

Var
  C : Array[0..MaxN+1, 0..MaxN+1] Of Byte;
  M, N : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    FillChar(C, SizeOf(C), 0);
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, M, N);
    For i := 1 To M Do
      For j := 1 To N Do
        Read(F, C[i, j]);
    Close(F);
  End;

Procedure Sinh_Du_Lieu(M, N : Byte);
  Var
    F : Text;
    i, j, u, v : Byte;
  Begin
    Randomize;
    FillChar(C, SizeOf(C), 0);
    For i := 1 To N Do
      If Random(2) = 1 Then C[i, 1] := C[i, 1]+4;
    For i := 1 To M Do
      For j := 1 To N Do
        Begin
          If Random(2) = 1 Then
            Begin
              C[i, j] := C[i, j]+1;
              If j < M Then C[i, j+1] := C[i, j+1]+4;
            End;
          If (Random(2) = 1)And(i > 1)And(i < N) Then
            Begin
              C[i, j] := C[i, j]+8;
              C[i+1, j] := C[i+1, j]+2;
            End;
        End;
    Assign(F, TenTepDL);
    Rewrite(F);
    WriteLn(F, M, ' ', N);
    For i := 1 To M Do
      Begin
        For j := 1 To N Do Write(F, C[i, j], ' ');
        WriteLn(F);
      End;
    Close(F);
  End;

Procedure Khoi_Tao_Do_Hoa;
  Var
    GD, GM : Integer;
  Begin
    GD := Detect;
    InitGraph(GD, GM, 'C:\TP\BGI');
  End;

Procedure Bieu_Dien_DL;
  Var
    i, j : Byte;
  Begin
    SetColor(8);
    SetLineStyle(1, 0, 1);
    Rectangle(0, 0, N*a, M*a);
    SetColor(15);
    SetLineStyle(0, 0, 1);
    For i := 1 To M Do
      For j := 1 To N Do
        Begin
          If C[i, j] And 1 = 0 Then
            Line((j-1)*a+a, (i-1)*a, (j-1)*a+a, (i-1)*a+a);
          If C[i, j] And 2 = 0 Then
            Line((j-1)*a, (i-1)*a, (j-1)*a+a, (i-1)*a);
          If C[i, j] And 4 = 0 Then
            Line((j-1)*a, (i-1)*a, (j-1)*a, (i-1)*a+a);
          If C[i, j] And 8 = 0 Then
            Line((j-1)*a, (i-1)*a+a, (j-1)*a+a, (i-1)*a+a);
        End;
  End;

Procedure Bieu_Dien_KQ;
  Var
    i, j : Byte;
  Begin
    SetColor(8);
    SetLineStyle(1, 0, 1);
    Rectangle(0, 0, N*a, M*a);
    SetColor(15);
    SetLineStyle(0, 0, 1);
    For i := 1 To M Do
      For j := 1 To N Do
        Begin
          If C[i, j] And 1 = 0 Then
            Line((j-1)*a+a, (i-1)*a, (j-1)*a+a, (i-1)*a+a);
          If C[i, j] And 2 = 0 Then
            Line((j-1)*a, (i-1)*a, (j-1)*a+a, (i-1)*a);
          If C[i, j] And 4 = 0 Then
            Line((j-1)*a, (i-1)*a, (j-1)*a, (i-1)*a+a);
          If C[i, j] And 8 = 0 Then
            Line((j-1)*a, (i-1)*a+a, (j-1)*a+a, (i-1)*a+a);
        End;
  End;

BEGIN
  ClrScr;
{ Sinh_Du_Lieu(10, 10);{}
  Doc_Du_Lieu;
  Khoi_Tao_Do_Hoa;
  Bieu_Dien_DL;
  ReadLn;
  CloseGraph;
END.