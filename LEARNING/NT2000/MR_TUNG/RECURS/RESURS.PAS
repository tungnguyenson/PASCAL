{$R+}
Uses CRT;

Const
  TenTepDL = 'RECURS.INP';
  TenTepKQ = 'RECURS.OUT';

Var
  W : Array[0..20, 0..20, 0..20] Of LongInt;

Procedure Khoi_Tao;
  Var
    i, j : Byte;
  Begin
    For i := 0 To 20 Do
	   For j := 0 To 20 Do
        Begin
		    W[i, j, 0] := 1;
		    W[i, 0, j] := 1;
		    W[0, i, j] := 1;
        End;
  End;

Procedure Tinh_W;
  Var
    a, b, c : Byte;
  Begin
    W[0, 0, 0] := 1;
    For a := 1 To 20 Do
	   For b := 1 To 20 Do
        For c := 1 To 20 Do
          If (a < b)And(b < c) Then
            W[a, b, c] := W[a, b, c-1]+W[a, b-1, c-1]-W[a, b-1, c]
           Else
            W[a, b, c] := W[a-1, b, c]+W[a-1, b-1, c]+W[a-1, b, c-1]-
				              W[a-1, b-1, c-1];
  End;

Procedure Thuc_Hien;
  Var
    FI, FO : Text;
    a, b, c : LongInt;
  Begin
    Assign(FI, TenTepDL);
    Reset(FI);
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    While Not EOF(FI) Do
      Begin
        ReadLn(FI, a, b, c);
        If (a < 0)Or(b < 0)Or(c < 0) Then WriteLn(FO, 1)
         Else If (a > 20)Or(b > 20)Or(c > 20) Then WriteLn(FO, W[20, 20, 20])
         Else WriteLn(FO, W[a, b, c]);
      End;
    Close(FO);
    Close(FI);
  End;

BEGIN
  Khoi_Tao;
  Tinh_W;
  Thuc_Hien;
END.