{$N+}

Uses CRT;

Const
  MaxN = 100;

Var
  i, N : Byte;
  T1, T2, T3, KQ : Comp;

Procedure Nhap_Du_Lieu;
  Begin
    Write('Nhap so N nam trong khoang 1..', MaxN, ': ');
    Repeat
      ReadLn(N);
      If (N > MaxN)Or(N <= 0) Then Write('Nhap sai! Nhap lai: ');
    Until (N <= MaxN)And(N > 0);
  End;

Function Mu_k(k : Byte) : Comp;
  Var
    S : Comp;
    i : Byte;
  Begin
    S := 1;
    For i := 1 To k Do S := S*2;
    Mu_k := S;
  End;

BEGIN
  ClrScr;
  Nhap_Du_Lieu;
  If N = 1 Then KQ := 2 Else
  If N = 2 Then KQ := 3 Else
    Begin
      T1 := 2;
      T2 := 3;
      For i := 3 To N Do
        Begin
          T3 := T1+T2;
          T1 := T2;
          T2 := T3;
        End;
      KQ := T3;
    End;
  WriteLn('So xau nhi phan thoa man: ', KQ:0:0);
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.