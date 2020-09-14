{$R-,S-}
Program Phan_Tich;

Uses CRT;

Const
  Max     = 100;
  DaXet   =   1;
  ChuaXet =   0;

Var
  A : Array[1..Max] Of Byte;
  N, t, i, j : Byte;
  Time, Dem : LongInt;

Procedure Khoi_Tao;
  Begin
    Time := MemL[$0000:$046C];
    Dem := 0;
    FillChar(A, SizeOf(A), 0);
  End;

Procedure Xuat(i : Byte);
  Var
    j : Byte;
  Begin
    Inc(Dem);
{    Write(N, ' = ');
    For j := 1 To i-1 Do Write(A[j], '+');
    WriteLn(A[i]);{}
  End;

Procedure Phan_Tich_De_Qui(i, Last, T : Byte);
  Var
    j : Byte;
  Begin
    For j := Last To N-T+1 Do
      Begin
        A[i] := j;
        T := T+j;
        If T = N Then Xuat(i)
                 Else Phan_Tich_De_Qui(i+1, j, T);
        T := T-j;
      End;
  End;

Procedure Phan_Tich_Khong_De_Qui;
  Begin
    i := 1;
    t := N;
    A[1] := N;
    Xuat(1);
    Repeat
      If A[i] > 1 Then
        Begin
          Dec(A[i]);
          Dec(t);
          While t < N Do
            Begin
              If A[i] < N-t Then A[i+1] := A[i]
                            Else A[i+1] := N-t;
              t := t+A[i+1];
              Inc(i);
            End;
          Xuat(i);
        End
       Else
        Begin
          j := i;
          While A[i] = 1 Do Dec(i);
          t := t-(j-i);
        End;
    Until i <= 0;
  End;

Begin
  ClrScr;
  Write('Nhap so tu nhien N: ');
  ReadLn(N);
  WriteLn('----------------------------------------');
  WriteLn('Cac cach phan tich so ', N,':');
  Khoi_Tao;
{  Phan_Tich_De_Qui(1, 1, 0);{}
  Phan_Tich_Khong_De_Qui;{}
  WriteLn;
  WriteLn('So cach phan tich tim duoc: ', Dem);
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:10:5, ' giay');
  WriteLn('----------------------------------------');
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
End.