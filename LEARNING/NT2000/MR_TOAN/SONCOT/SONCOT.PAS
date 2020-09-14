Uses CRT;

Const
  Next : Array[1..4, 1..2] Of ShortInt = ((-1, 0), (0, -1), (0, 1), (1, 0));
  TenTepDL = 'BAI3.IN1';
  Max = 100;

Var
  Luoi : Array[0..Max+1, 0..Max+1] Of Byte;
  M, N : Byte;
  S : LongInt;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    FillChar(Luoi, SizeOf(Luoi), 0);
    Assign(F, TenTepDL);
    ReSet(F);
    ReadLn(F, M, N);
    S := 0;
    For i := 1 To M Do
      For j := 1 To N Do
        Begin
          Read(F, Luoi[i, j]);
          If Luoi[i, j] > 0 Then Inc(S);
        End;
    Close(F);
  End;

Procedure Thuc_Hien;
  Var
    i, j, k : Byte;
  Begin
    For i := 1 To M Do
      For j := 1 To N Do
        For k := 1 To 4 Do
          If Luoi[i+Next[k, 1], j+Next[k, 2]] < Luoi[i, j] Then
            S := S+Luoi[i, j]-Luoi[i+Next[k, 1], j+Next[k, 2]];
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  WriteLn('Dien tich can son: ', S);
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.