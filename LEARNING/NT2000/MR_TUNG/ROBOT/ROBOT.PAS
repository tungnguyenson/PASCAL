Uses CRT;

Const
  TenTepDL = 'ROBOT.INP';
  TenTepKQ = 'ROBOT.OUT';
  Max = 16;

Var
  X0, Y0, X1, Y1, K : Integer;
  KC : Integer;
  Map : Array[-Max..Max, -Max..Max] Of LongInt;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, K, X0, Y0, X1, Y1);
    Close(F);
  End;

Procedure Khoi_Tao;
  Begin
    KC := Abs(Y1-Y0)+Abs(X1-X0);
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    If K < KC Then WriteLn(F, 0)
     Else
      Begin
      End;
    Close(F);
  End;

Procedure Tim;
  Begin
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Khoi_Tao;
  Tim;
  Ghi_Ket_Qua;
END.