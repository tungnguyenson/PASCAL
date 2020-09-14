Uses CRT;

Const
  MaxN = 100;

Var
  N : Byte;

Procedure Nhap_Du_Lieu;
  Begin
    Write('Nhap so N nam trong khoang 1..', MaxN, ': ');
    Repeat
      ReadLn(N);
      If (N > MaxN)Or(N <= 0) Then Write('Nhap sai! Nhap lai: ');
    Until (N <= MaxN)And(N > 0);
  End;

Function TimA(N : Byte) : LongInt;
  Var
    A1, A2 : LongInt;
    i : Byte;
  Begin
    A1 := 0;
    A2 := 1;
    For i := 2 To N Do

  End;

BEGIN
  ClrScr;
  Nhap_Du_Lieu;
  WriteLn('', TimA(N));
  ReadLn;
END.