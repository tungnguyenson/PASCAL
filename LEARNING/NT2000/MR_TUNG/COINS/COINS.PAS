Uses CRT;

Const
  Max = 5000;
  MaxCoins = 17;
  TenTepDL = 'coins.inp';
  TenTepKQ = '';

Var
  F : Array[0..Max] Of Comp;

Procedure Tinh_F;
  Var
    i, j : Word;
  Begin
    For i := 1 To Max Do F[i] := 1;
    For i := 2 To MaxCoins Do
      For j := i*i To Max Do
        F[j] := F[j]+F[j-i*i];
  End;

Procedure Thuc_Hien;
  Var
    FI, FO : Text;
    x : Word;
  Begin
    Assign(FI, TenTepDL);
    Reset(FI);
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    While Not EOF(FI) Do
      Begin
        ReadLn(FI, x);
        WriteLn(FO, F[x]:0:0);
      End;
    Close(FO);
    Close(FI);
  End;

BEGIN
  Tinh_F;
  Thuc_Hien;
END.