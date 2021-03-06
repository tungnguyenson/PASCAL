{$R-,S-}
Program Hoan_Vi;

Uses CRT;

Const
  Max     = 100;
  DaXet   =   1;
  ChuaXet =   0;

Var
  A, Xet : Array[1..Max] Of Byte;
  N : Byte;
  Dem, Time : LongInt;

Procedure Khoi_Tao;
  Begin
    Time := MemL[$0000:$046C];
    Dem := 0;
    FillChar(Xet, SizeOf(Xet), ChuaXet);
  End;

Procedure Xuat;
  Var
    i : Byte;
  Begin
    Inc(Dem);
    For i := 1 To N-1 Do Write(A[i], ' ');
    WriteLn(A[N]);{}
  End;

Procedure Tim(i : Byte);
  Var
    j : Byte;
  Begin
    For j := 1 To N Do
      If Xet[j] = ChuaXet Then
        Begin
          A[i] := j;
          Xet[j] := DaXet;
          If i = N Then Xuat
                   Else Tim(i+1);
          Xet[j] := ChuaXet;
        End;
  End;

BEGIN
  ClrScr;
  Write('Nhap so tu nhien N: ');
  ReadLn(N);
  WriteLn('----------------------------------------');
  Khoi_Tao;
{  A[1] := 1;
  Xet[1] := DaXet;{}
  Tim(1);
  WriteLn('So hoan vi tim duoc la: ', Dem);
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:6:3, ' giay');
  WriteLn('----------------------------------------');
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.