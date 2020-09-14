Program Chu_Vi_Mien;

Uses CRT;

Const
  MaxM = 100;
  MaxN = 100;
  TenTepDL = '100.100';
  TenTepKQ = 'con';
  Next : Array[1..4, 1..2] Of ShortInt = ((-1, 0), (0, -1), (0, 1), (1, 0));

Var
  A, B : Array[0..MaxM+1, 0..MaxN+1] Of Byte;
  Queue : Array[1..MaxM*MaxN, 1..2] Of Byte;
  M, N : Byte;
  SoMien, MaxChuVi, Chu_Vi : Word;
  Left, Right : Word;
  ys, xs : Byte;
  F : Text;
  Time : LongInt;

Procedure Doc_Du_Lieu;
  Var
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, M, N);
    FillChar(A, SizeOf(A), 0);
    For i := 1 To M Do
      For j := 1 To N Do
        Read(F, A[i, j]);
    Close(F);
  End;

Procedure Sinh_Du_Lieu;
  Var
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Rewrite(F);
    WriteLn(F, MaxM, ' ', MaxN);
    For i := 1 To MaxM Do
      Begin
        For j := 1 To MaxN Do Write(F, Random(5)+1, ' ');
        WriteLn(F);
      End;
    Close(F);
  End;

Function Explore(y, x : Byte) : Word;
  Var
    i, j, k, l, Gia_Tri : Byte;
    Chu_Vi : Word;
  Begin
    Gia_Tri := A[y, x];
    Left := 1;
    Right := 1;
    Queue[1, 1] := y;
    Queue[1, 2] := x;
    B[y, x] := 1;
    Chu_Vi := 0;
    While Left <= Right Do
      Begin
        For j := 1 To 4 Do
          If (A[y+Next[j, 1], x+Next[j, 2]] = Gia_Tri)And
             (B[y+Next[j, 1], x+Next[j, 2]] = 0) Then
            Begin
              Inc(Right);
              Queue[Right, 1] := y+Next[j, 1];
              Queue[Right, 2] := x+Next[j, 2];
              B[y+Next[j, 1], x+Next[j, 2]] := 1;
            End
           Else If A[y+Next[j, 1], x+Next[j, 2]] <> Gia_Tri Then Inc(Chu_Vi);
        Inc(Left);
        y := Queue[Left, 1];
        x := Queue[Left, 2];
      End;
    Explore := Chu_Vi;
  End;

Procedure Thuc_Hien;
  Var
    i, j : Byte;
  Begin
    FillChar(B, SizeOf(B), 0);
    SoMien := 0;
    MaxChuVi := 0;
    For i := 1 To M Do
      For j := 1 To N Do
        If B[i, j] = 0 Then
          Begin
            Inc(SoMien);
            Chu_Vi := Explore(i, j);
            If MaxChuVi < Chu_Vi Then
              Begin
                MaxChuVi := Chu_Vi;
                ys := i;
                xs := j;
              End;
          End;
  End;

Procedure Ghi_Ket_Qua;
  Begin
    Assign(F, TenTepKQ);
    ReWrite(F);
    WriteLn(F, SoMien);
    Write(F, ys, ' ', xs, ' ', MaxChuVi);
    Close(F);
    WriteLn;
    WriteLn('Ket qua duoc ghi ra tep ''', TenTepKQ, '''');
  End;

Begin
  ClrScr;
{  Sinh_Du_Lieu;{}
  Doc_Du_Lieu;
  Time := MemL[$0000:$046C];
  Thuc_Hien;
  Ghi_Ket_Qua;
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:6:3, ' giay');
  Write('Nhan phim Enter de ket thuc chuong trinh ...');
  ReadLn;
End.