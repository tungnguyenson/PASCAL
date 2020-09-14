Uses CRT;

Const
  TenTepDL = 'STONE.IN1';
  TenTepKQ = 'STONE.OUT';
  MaxN = 400;

Var
  Stone, Truoc, Bac, Xet, Stack : Array[1..MaxN] Of Word;
  MinStone, N, Top : Word;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j, k, Leaf, M : Word;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      Begin
        Read(F, j, M);
        Bac[j] := M;
        For k := 1 To M Do
          Begin
            Read(F, Leaf);
            Truoc[Leaf] := j;
          End;
      End;
    Close(F);
  End;

Procedure Thuc_Hien;
  Var
    i, j, k, Max : Word;
  Begin
    FillChar(Stone, SizeOf(Stone), 0);
    FillChar(Xet, SizeOf(Xet), 0);
    MinStone := 1;
    Top := 1;
    Stack[Top] := 1;
    Repeat
      Max := Bac[Stack[1]];
      j := 1;
      For i := 1 To Top Do
        If Max < Bac[Stack[i]] Then
          Begin
            Max := Bac[Stack[i]];
            j := i;
          End;
      If Max > 0 Then
        Begin
        End;
    Until Top = N;
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
END.