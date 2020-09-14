{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
Uses CRT;

Const
  TenTepDL = 'BL4.INP';
  TenTepKQ = 'BL4.OUT';
  MaxN = 50;

Var
  P, D, C : Array[1..MaxN] Of Word;
  TrinhTu : Array[1..MaxN] Of Word;
  N : Byte;
  Thuong, Phat : LongInt;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      ReadLn(F, P[i], D[i], C[i]);
    Close(F);
  End;

Procedure SwapInt(Var x, y : Word);
  Var
    z : Word;
  Begin
    z := x;
    x := y;
    y := z;
  End;

Procedure Sort;
  Var
    i, j : Byte;
  Begin
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If P[i]*C[j] > P[j]*C[i] Then
          Begin
            SwapInt(P[i], P[j]);
            SwapInt(C[i], C[j]);
            SwapInt(D[i], D[j]);
            SwapInt(TrinhTu[i], TrinhTu[j]);
          End;
  End;

Procedure Thuc_Hien;
  Var
    i : Byte;
    T : Word;
  Begin
    For i := 1 To N Do TrinhTu[i] := i;
    Sort;
    Thuong := 0;
    Phat := 0;
    T := 0;
    For i := 1 To N Do
      Begin
        T := T+P[i];
        If T < D[i] Then Thuong := Thuong+(D[i]-T)*C[i]
                    Else Phat := Phat+(T-D[i])*C[i];
      End;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    WriteLn(F, Thuong);
    WriteLn(F, Phat);
    For i := 1 To N Do
      WriteLn(F, TrinhTu[i]);
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
  ReadLn;
END.