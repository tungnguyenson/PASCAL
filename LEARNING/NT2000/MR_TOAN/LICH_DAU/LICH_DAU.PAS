Uses CRT;

Const
  TenTepDL = 'HSTD.INP';
  TenTepKQ = 'HSTD.OUT';
  MaxN = 50;

Var
  HS, ChiSo : Array[1..2, 1..MaxN] Of Word;
  Result : Array[1..MaxN, 1..MaxN] Of Byte;
  A, Luu, Xet : Array[1..MaxN] Of Byte;
  N, MaxPoint, MatchPoint : Byte;
  Time : LongInt;

Procedure Sinh_Du_Lieu;
  Var
    F : Text;
    i : Byte;
  Begin
    N := 10;
    Assign(F, TenTepDL);
    Rewrite(F);
    For i := 1 To N Do Write(F, Random(N)+1:4);
    WriteLn(F);
    For i := 1 To N Do Write(F, Random(N)+1:4);
    Close(F);
  End;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, k : Byte;
    j : Integer;
    S : String;
    Ch : Char;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    For k := 1 To 2 Do
      Begin
        S := '';
        i := 0;
        Repeat
          Read(F, Ch);
          If Ch In ['0'..'9'] Then S := S+Ch
           Else If S <> '' Then
            Begin
              Inc(i);
              Val(S, HS[k, i], j);
              S := '';
            End;
        Until EOLn(F);
        Inc(i);
        Val(S, HS[k, i], j);
      End;
    N := i;
    Close(F);
  End;

Procedure Swap(Var x, y : Word);
  Var
    i : Word;
  Begin
    i := x;
    x := y;
    y := i;
  End;

Procedure Khoi_Tao;
  Var
    i, j, k : Byte;
  Begin
    For i := 1 To 2 Do
	   For j := 1 To N Do ChiSo[i, j] := j;
    For i := 1 To 2 Do
      For j := 1 To N-1 Do
        For k := j+1 To N Do
          If HS[i, j] > HS[i, k] Then
            Begin
              Swap(HS[i, j], HS[i, k]);
              Swap(ChiSo[i, j], ChiSo[i, k]);
            End;
    For i := 1 To N Do
      For j := 1 To N Do
        If HS[1, i] > HS[2, j] Then Result[i, j] := 2
         Else If HS[1, i] = HS[2, j] Then Result[i, j] := 1
         Else Result[i, j] := 0;
    MatchPoint := 0;
    FillChar(Xet, SizeOf(Xet), 0);
    FillChar(A, SizeOf(A), 0);
  End;

Procedure Tim(i : Byte);
  Var
    j, k : Byte;
  Begin
    If (MemL[0:1132]-Time)/18.2 > 1 Then Exit;
    For j := 1 To N Do
      If Xet[j] = 0 Then
        Begin
          A[i] := j;
          Xet[j] := 1;
          Inc(MatchPoint, Result[i, j]);
          If i < N Then Tim(i+1)
           Else If MatchPoint > MaxPoint Then
            Begin
              Luu := A;
              MaxPoint := MatchPoint;
            End;
          Dec(MatchPoint, Result[i, j]);
          Xet[j] := 0;
        End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    For i := 1 To N Do
      WriteLn(F, ChiSo[1, i], ' ', ChiSo[2, Luu[i]], ' ', Result[i, Luu[i]]);
    WriteLn(F, MaxPoint);
    Close(F);
  End;

BEGIN
  ClrScr;
{  Sinh_Du_Lieu;{}
  Doc_Du_Lieu;
  Khoi_Tao;
  Time := MemL[0:1132];
  Tim(1);
  Ghi_Ket_Qua;
  WriteLn((MemL[0:1132]-Time)/18.2:0:5);
END.