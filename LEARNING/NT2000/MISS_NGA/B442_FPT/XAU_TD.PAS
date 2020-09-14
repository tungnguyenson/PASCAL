Uses CRT;

Const
  TenTepDL = 'td.inp';

Var
  N : Byte;
  S1, S2 : String;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    ReadLn(F, S1);
    ReadLn(F, S2);
    Close(F);
  End;

BEGIN
  ClrScr;
  ReadLn;
END.