Uses CRT;

Const
  TenTepDL = 'NEM.INP';
  TenTepKQ = 'NEM.OUT';
  G : Real = 10.0;
  Pi = 3.1415926535897932385;

Var
  i : Byte;

Function H_Max(v0, Alpha : Real) : Real;
  Begin
    H_Max := ((v0*v0)*(Sin(Alpha)*Sin(Alpha)))/(2*g);
  End;

Function X_Max(v0, Alpha : Real) : Real;
  Begin
    X_Max := Abs(((v0*v0)*Sin(2*Alpha))/g);
  End;

Procedure ConvertToRadian(Var Deg : Real);
  Begin
    Deg := (Deg*Pi)/180;
  End;

Procedure Thuc_Hien;
  Var
    FI, FO : Text;
    V0, Alpha : Real;
  Begin
    Assign(FI, TenTepDL);
    Reset(FI);
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    While Not EOF(FI) Do
      Begin
        ReadLn(FI, V0, Alpha);
        ConvertToRadian(Alpha);
        WriteLn(FO, H_Max(V0, Alpha):0:2, ' ', X_Max(V0, Alpha):0:2);
      End;
    Close(FO);
    Close(FI);
  End;

BEGIN
  Thuc_Hien;
END.