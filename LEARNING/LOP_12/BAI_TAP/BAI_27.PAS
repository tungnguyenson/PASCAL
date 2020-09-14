{
Ham so F(n) voi n î Z, n > 0 duoc xac dinh nhu sau:
  F(1) = 0
  F(0) = 1
  F(2*n) = F(n)
  F(2*n+1) = F(n) + F(n+1)
Voi n cho truoc, hay xac dinh va in ra F(n)
Dieu kien: n du lon de khong the khai bao mang gom n phan tu hoac mang co
           chieu dai tang theo n
}

Uses CRT;

Var
  N, F, i : LongInt;

Begin
  ClrScr;
  Repeat
    Write('Nhap so N: ');
    ReadLn(N);
  Until N >= 0;
  If N < 2 Then F := N
  Else
  If N Mod 2 = 0 Then F := 1
  Else
    Begin
      i := 0;
      While 1 Shl i < N Do Inc(i);
      F := i;
    End;{Else}
  WriteLn('F(', N, ') = ', F);
  ReadLn;
End.