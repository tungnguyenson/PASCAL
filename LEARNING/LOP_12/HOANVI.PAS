Uses CRT;

Var
  A, Xet : Array[1..100] Of Byte;
  N : Byte;
  Dem, Time : LongInt;

Procedure Duyet(i : Byte);
  Var
    j : Byte;
  Begin
    For j := 1 To N Do
      If Xet[j] = 0 Then
        Begin
          A[i] := j;
          Xet[j] := 1;
          If i < N Then Duyet(i+1)
                   Else Inc(Dem);
          Xet[j] := 0;
        End;
  End;

BEGIN
  ClrScr;
  Time := MemL[0:1132];
  FillChar(Xet, SizeOf(Xet), 0);
  Dem := 0;
  Write('N = ');
  ReadLn(N);
  Duyet(1);
  WriteLn('So hoan vi: ', Dem);
  WriteLn('Thoi gian chay: ', (MemL[0:1132]-Time)/18.2:10:5);
  Write('Nhan Enter de ket thuc ...');
  ReadLn;
END.