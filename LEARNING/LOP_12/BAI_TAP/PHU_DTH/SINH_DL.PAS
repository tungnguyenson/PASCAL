Program Sinh_Du_Lieu_Phu_Doan_Thang;

Uses CRT;

Const
  Dau : Array [0..1] Of ShortInt = (-1, 1);
Var
  TenTepDL : String;
  i, j, N, P, Q, L, R : LongInt;
  F : Text;

Begin
  ClrScr;
{  Write('Nhap ten tep du lieu can tao: ');
  ReadLn(TenTepDL);
  Write('  N = ');  ReadLn(N);
  Write('  P = ');  ReadLn(P);
  Write('  Q = ');  ReadLn(Q);{}
  TenTepDL := 'phu.i2';
  N := 50;
  P := -5;
  Q :=  5;
  Assign(F, TenTepDL);
  Rewrite(F);
  WriteLn(F, N, ' ', P, ' ', Q);
  Randomize;
  For i := 1 To N Do
    Begin
      L := (Q-P) Div 2 + Dau[Random(2)]*Random((Q-P) Div 3 * 4);
      R := L+Random((Q-P) Div 4 * 3);
      WriteLn(F, L, ' ', R);
    End;
  Close(F);
End.