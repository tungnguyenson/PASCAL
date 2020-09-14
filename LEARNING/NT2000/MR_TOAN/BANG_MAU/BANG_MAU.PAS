{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
Uses CRT;

Const
  TenTepDL = 'BL1.IN5';
  TenTepKQ = 'BL1.OUT';
  MaxN = 128;

Var
  A, B : Array[1..MaxN, 1..MaxN] Of Byte;
  BienDoi : Array[1..MaxN*2, 1..3] Of Byte;
  N : Byte;
  SoPhepBD : Integer;

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
    For i := 1 To N Do
      For j := 1 To N Do
        Read(F, B[i, j]);
    Close(F);
  End;

Procedure Swap_Byte(Var x, y : Byte);
  Var
    i : Byte;
  Begin
    i := x;
    x := y;
    y := i;
  End;

Procedure Thuc_Hien;
  Var
    i, j, l : Byte;
  Begin
    SoPhepBD := 0;
    For i := 1 To N Do
      If (SoPhepBD >= 0)And(A[i, 1] <> B[i, 1]) Then
        Begin
          j := i;
          While (j <= N)And(A[j, 1] <> B[i, 1]) Do Inc(j);
          If j <= N Then
            Begin
              For l := 1 To N Do
                Swap_Byte(A[i, l], A[j, l]);
              Inc(SoPhepBD);
              BienDoi[SoPhepBD, 1] := 1;
              BienDoi[SoPhepBD, 2] := i;
              BienDoi[SoPhepBD, 3] := j;
            End
           Else SoPhepBD := -1;
        End;
    For i := 1 To N Do
      If (SoPhepBD >= 0)And(A[1, i] <> B[1, i]) Then
        Begin
          j := i;
          While (j <= N)And(A[1, j] <> B[1, i]) Do Inc(j);
          If j <= N Then
            Begin
              For l := 1 To N Do
                Swap_Byte(A[l, i], A[l, j]);
              Inc(SoPhepBD);
              BienDoi[SoPhepBD, 1] := 2;
              BienDoi[SoPhepBD, 2] := i;
              BienDoi[SoPhepBD, 3] := j;
            End
           Else SoPhepBD := -1;
        End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    WriteLn(F, SoPhepBD);
    If SoPhepBD > 0 Then
      For i := 1 To SoPhepBD Do
        WriteLn(F, BienDoi[i, 1], ' ', BienDoi[i, 2], ' ', BienDoi[i, 3]);
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.