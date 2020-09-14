Uses CRT;

Const
  Max_Value = 10000;

Var
  TenTepDL : String;
  F : Text;
  N, i : Integer;

Begin
  ClrScr;
  Write('Nhap ten tep du lieu can tao: ');
  ReadLn(TenTepDL);
  Write('Nhap so phan tu cua day: ');
  ReadLn(N);
  Assign(F, TenTepDL);
  Rewrite(F);
  For i := 1 To N Do
    If i Mod 10 = 0 Then WriteLn(F, Random(Max_Value):8)
                    Else Write(F, Random(Max_Value):8);
  Randomize;
  Close(F);
End.