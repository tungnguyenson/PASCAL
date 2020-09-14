{$R-,S-}
Program To_Hop;

Uses CRT;

Const
  Max     = 100;
  DaXet   =   1;
  ChuaXet =   0;

Var
  A : Array[1..Max] Of Byte;
  N, k : Byte;
  Dem, Time : LongInt;

Procedure Khoi_Tao;
  Begin
    Time := MemL[$0000:$046C];
    Dem := 0;
  End;

Procedure Xuat;
  Var
    i : Byte;
  Begin
    Inc(Dem);
    For i := 1 To k-1 Do Write(A[i], ' ');
    WriteLn(A[k]);{}
  End;

Procedure Tim(i, Last : Byte);
  Var
    j : Byte;
  Begin
    For j := Last+1 To N Do
      Begin
        A[i] := j;
        If i = k Then Xuat
                 Else Tim(i+1, j);
      End;
  End;

BEGIN
  ClrScr;
  Write('Nhap so tu nhien k: ');
  ReadLn(k);
  Write('Nhap so tu nhien N: ');
  ReadLn(N);
  WriteLn('----------------------------------------');
  Khoi_Tao;
  Tim(1, 0);
  WriteLn('So to hop tim duoc la: ', Dem);
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:6:3, ' giay');
  WriteLn('----------------------------------------');
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.