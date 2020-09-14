Uses CRT;

Const
  Max = 100;
  TenTepKQ = 'con';

Var
  KQ : Array[1..Max]Of Byte;
  N : Byte;
  Nguoi : Array[1..2] Of Byte;
  Dem, Time : LongInt;
  F : Text;

Procedure Xuat_KQ(i : Byte);
  Var
    j : Byte;
  Begin
    Inc(Dem, 2);
{    For j := 1 To i Do Write(F, Chr(KQ[j]+64));
    WriteLn(F);
    For j := 1 To i Do Write(F, Chr(3-KQ[j]+64));
    WriteLn(F);{}
  End;

Procedure Tim(i : Byte);
  Var
    j : Byte;
  Begin
    For j := 1 To 2 Do
      Begin
        KQ[i] := j;
        Inc(Nguoi[j]);
        If (Nguoi[1] = N)Or(Nguoi[2] = N) Then Xuat_KQ(i)
                                          Else Tim(i+1);
        Dec(Nguoi[j]);
      End;
  End;

Procedure Thuc_Hien;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    FillChar(KQ, SizeOf(KQ), 0);
    Nguoi[1] := 1;
    Nguoi[2] := 0;
    Dem := 0;
    KQ[1] := 1;
    Tim(2);
    Close(F);
  End;

Begin
  ClrScr;
  Repeat
    Write('Nhap so N(<=', Max Div 2, '): ');
    ReadLn(N);
  Until N <= Max Div 2;
  Time := MemL[$0000:$046C];
  Thuc_Hien;
  WriteLn('So kha nang xay ra: ', Dem);
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:7:3, ' giay');
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
End.