Uses CRT;

Const
  TenTepDL = 'AUT.IN4';
  N = 50;
  MaxN = 200;

Var
  BangTT, BangRa : Array[0..MaxN-1, 0..9] Of Word;
  F : Text;
  i, j : Byte;
  TT_KetThuc, TT_KhoiTao, GT_Vao : Word;

BEGIN
  Randomize;
  For i := 0 To N-1 Do
    For j := 0 To 9 Do
      Begin
        BangTT[i, j] := Random(N);
        BangRa[i, j] := Random(10);
      End;
  TT_KhoiTao := Random(N);
  TT_KetThuc := Random(N);
  GT_Vao := Random(10);
  Assign(F, TenTepDL);
  Rewrite(F);
  WriteLn(F, N);
  For i := 0 To N-1 Do
    Begin
      For j := 0 To 19 Do
        If j < 10 Then Write(F, BangTT[i, j]:4)
                  Else Write(F, BangRa[i, j-10]:2);
      WriteLn(F);
    End;
  WriteLn(F, TT_KhoiTao, ' ', TT_KetThuc, ' ', GT_Vao);
  Close(F);
END.