{$N+}

Uses CRT;

Const
  TenTepDL = 'BIT.INP';
  TenTepKQ = 'BIT.OUT';

Var
  Bit : Byte;

Procedure Tim(K : Comp);
  Var
    N : Comp;
  Begin
    If K > 2 Then
	   Begin
        N := 1;
        While N < K Do N := N*2;
		  Tim(K-N/2)
      End
     Else Bit := Round(K)-1;
    Bit := 1-Bit;
  End;

Procedure Thuc_Hien;
  Var
    FI, FO : Text;
    K : LongInt;
    i : Byte;
  Begin
    Assign(FI, TenTepDL);
    Reset(FI);
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    While Not EOF(FI) Do
      Begin
        ReadLn(FI, K);
		  Tim(K);
        WriteLn(FO, Bit);
      End;
    Close(FO);
    Close(FI);
  End;

BEGIN
  Thuc_Hien;
END.