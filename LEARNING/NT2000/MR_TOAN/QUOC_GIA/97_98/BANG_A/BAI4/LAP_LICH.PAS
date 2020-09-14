Uses CRT;

Const
  TenTepDL = 'BL4.INP';
  TenTepKQ = 'BL4.OUT';
  MaxN = 1000;

Var
  P, R, D : Array[1..MaxN] Of Word;
  ChiSo : Array[1..MaxN] Of Word;
  N : Word;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Word;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      ReadLn(F, P[i], R[i], D[i]);
    Close(F);
  End;

Procedure Khoi_Tao;
  Var
    i : Word;
  Begin
    For i := 1 To N Do
	   If P[i]+R[i] <= D[i] Then ChiSo[i] := i
                           Else ChiSo[i] := 0;
  End;

Procedure Swap(Var x, y : Word);
  Var
    T : Word;
  Begin
    T := x;
    x := y;
    y := T;
  End;

Procedure Thuc_Hien;
  Var
    i, j : Word;
    TG : Word;
  Begin
    For i := 1 To N Do
      Begin
        TG := 0;
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i, j, Tre, TG : Word;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    TG := 0;
    Tre := 0;
    For i := 1 To N Do
      Begin
        If TG < R[ChiSo[i]] Then TG := R[ChiSo[i]];
        TG := TG+P[ChiSo[i]];
        If TG > D[ChiSo[i]] Then Inc(Tre);
      End;
    WriteLn(F, Tre);
    For i := 1 To N Do
      WriteLn(F, ChiSo[i]);
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Khoi_Tao;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.