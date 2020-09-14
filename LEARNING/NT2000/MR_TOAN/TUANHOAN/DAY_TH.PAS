{$A+,B+,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
Const
  TenTepDL = 'SO.INP';
  TenTepKQ = 'SO.OUT';
  Max = 10000;

Var
  A : Array[1..Max] Of LongInt;
  K, T : Word;

Function Next(X : Word) : Word;
  Var
    i, j : Word;
  Begin
    i := 0;
    Repeat
      j := X Mod 10;
      i := i+j*j;
      X := (X-j) Div 10;
    Until X < 1;
    Next := i;
  End;

Procedure Xay_Dung(Var F : Text; i : LongInt);
  Var
    j : Word;
  Begin
    FillChar(A, SizeOf(A), 0);
    A[1] := i;
    k := 1;
    Repeat
      Inc(k);
      A[k] := Next(A[k-1]);
    Until A[k] In [58, 89, 145, 42, 20, 4, 16, 37];
    WriteLn(F, k, ' ', A[k]);
    T := 8;
    WriteLn(F, T);
    For j := k+1 To k+T Do A[j] := Next(A[j-1]);
    For j := k To k+T-1 Do Write(F, A[j], ' ');
    WriteLn(F);
  End;

Procedure Thuc_Hien;
  Var
    FI, FO : Text;
    i : LongInt;
  Begin
    Assign(FI, TenTepDL);
    Reset(FI);
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    While Not EOF(FI) Do
      Begin
        ReadLn(FI, i);
        Xay_Dung(FO, i);
      End;
    Close(FO);
    Close(FI);
  End;

BEGIN
  Thuc_Hien;
END.