Uses CRT;

Const
  TenTepDL = 'SO.INP';
  TenTepKQ = 'SO.OUT';

Var
  So : Array[1..64000] Of Char;
  Leng, MaxLeng, LuuVT, N : Word;

Function IsGreater(VT1, VT2 : Word) : Boolean;
  Var
    i : Word;
  Begin
    i := 1;
    While (i <= MaxLeng)And(So[VT1+i-1] >= So[VT2+i-1]) Do Inc(i);
    If i <= MaxLeng Then IsGreater := False
                    Else IsGreater := True;
  End;

Function Tim : Word;
  Var
    i, j : Word;
  Begin
    MaxLeng := 0;
    j := 0;
    For i := 1 To Leng Do
      If So[i] = '0' Then
        Begin
          If j <> 0 Then
            If i-j-1 > MaxLeng Then
              Begin
                MaxLeng := i-j-1;
                LuuVT := j+1;
              End
             Else If (i-j-1 = MaxLeng)And(IsGreater(j+1, LuuVT) = True)Then
               LuuVT := j+1;
          j := i;
        End;
  End;

Procedure Thuc_Hien;
  Var
    FI, FO : Text;
    i, j : Word;
  Begin
    Assign(FI, TenTepDL);
    Reset(FI);
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    ReadLn(FI, N);
    For i := 1 To N Do
      Begin
        Leng := 0;
        While Not EOLn(FI) Do
          Begin
            Inc(Leng);
            Read(FI, So[Leng]);
          End;
        ReadLn(FI);
        Tim;
        If MaxLeng = 0 Then WriteLn(FO, '01')
         Else
          Begin
            For j := 1 To MaxLeng Do
              Write(FO, So[LuuVT+j-1]);
            WriteLn(FO);
          End;
      End;
    Close(FO);
    Close(FI);
  End;

BEGIN
  Thuc_Hien;
END.