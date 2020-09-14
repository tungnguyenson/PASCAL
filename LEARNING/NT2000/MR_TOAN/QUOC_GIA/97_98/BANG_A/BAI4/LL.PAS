Uses CRT;

Const
  TenTepDL = 'BL4.INP';
  TenTepKQ = 'BL4.OUT';
  MaxN = 1000;

Var
  P, R, D : Array[1..MaxN] Of Word;
  Luu, ChiSo : Array[1..MaxN] Of Word;
  MinTre, N : Word;

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

Procedure Swap(Var x, y : Word);
  Var
    T : Word;
  Begin
    T := x;
    x := y;
    y := T;
  End;

Function Tim_Tre : Word;
  Var
    i, Tre, TG : Word;
  Begin
    TG := 0;
    Tre := 0;
    For i := 1 To N Do
      Begin
        If TG < R[ChiSo[i]] Then TG := R[ChiSo[i]];
        TG := TG+P[ChiSo[i]];
        If TG > D[ChiSo[i]] Then Inc(Tre);
      End;
    Tim_Tre := Tre;
  End;

Procedure Thuc_Hien;
  Var
    i, j, k, l : Word;
    TG : Word;
  Begin
    MinTre := N;
    For i := 1 To MaxN Do
      Begin
        For j := 1 To N Do ChiSo[j] := j;
        For j := 1 To MaxN Do
          Begin
            k := Random(N)+1;
            l := Random(N)+1;
            Swap(ChiSo[k], ChiSo[l]);
          End;
        k := Tim_Tre;
        If k < MinTre Then
          Begin
            k := MinTre;
            Luu := ChiSo;
          End;
      End;
    ChiSo := Luu;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i, j : Word;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    WriteLn(F, Tim_Tre);
    For i := 1 To N Do
      WriteLn(F, ChiSo[i]);
    Close(F);
  End;

BEGIN
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.