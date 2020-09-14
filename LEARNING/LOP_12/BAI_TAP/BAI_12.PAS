Uses CRT;

Const
  Dau : Array[1..4] Of Char = ('+', '-', '*', '/');
  Max = 100;

Var
  A : Array[1..Max] Of Integer;
  D : Array[1..Max-2] Of Byte;
  N, i : Byte;
  Dem : Word;
  Kq : Integer;

Procedure Xuat;
  Var
    i : Byte;
  Begin
    Inc(Dem);
{    For i := 1 to N-2 Do Write('(');
    Write(A[1]);
    For i := 1 To N-2 Do Write(Dau[D[i]], A[i+1], ')');
    WriteLn('=', A[N]);}
  End;

Procedure Dien(i : Byte);
  Var
    j : Byte;
    LuuKq : Integer;
  Begin
    For j := 1 To 4 Do
      Begin
        D[i] := j;
        LuuKq := Kq;
        Case Dau[D[i]] Of
          '+' : Kq := Kq+A[i+1];
          '-' : Kq := Kq-A[i+1];
          '*' : Kq := Kq*A[i+1];
          '/' : Kq := Kq Div A[i+1];
        End;
        If i = N-2 Then
          Begin
            If Kq = A[N] Then Xuat;
          End
         Else Dien(i+1);
        Kq := LuuKq;
      End;
  End;

Begin
  ClrScr;
  ReadLn(N);
  For i := 1 To N Do
    Begin
{      Write('A[', i, ']');
      ReadLn(A[i]);{}
      A[i] := i;{}
    End;
  Dem := 0;
  Kq := A[1];
  Dien(1);
  WriteLn('Co ', Dem, ' cach!');
  ReadLn;
End.