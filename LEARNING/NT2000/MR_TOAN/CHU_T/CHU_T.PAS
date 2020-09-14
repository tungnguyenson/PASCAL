Uses CRT;

Const
  TenTepKQ = 'SAN.OUT';
  MaxN = 2000;
  Brick : Array[0..3, 0..3] Of Byte = ((0, 1, 1, 1),
                                       (0, 0, 1, 3),
                                       (0, 2, 3, 3),
                                       (2, 2, 2, 3));
Var
  N : LongInt;

Procedure Nhap_Du_Lieu;
  Begin
    Write('Nhap so N trong khoang 1..', MaxN, ': ');
    Repeat
      ReadLn(N);
      If (N < 1)Or(N > MaxN) Then
        Write('Nhap sai! Nhap lai: ');
    Until (N > 0)And(N <= MaxN);
  End;

Procedure Thuc_Hien;
  Var
    F : Text;
    i, j : LongInt;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    If N Mod 4 = 0 Then
      For i := 1 To N Do
        Begin
          For j := 1 To N Do
            Write(F, Brick[(i-1) Mod 4, (j-1) Mod 4]+((i-1) Div 4*(N Div 4)+
							    (j-1) Div 4)*4+1:6);
          WriteLn(F);
        End
     Else Write(F, 0);
    Close(F);
  End;

BEGIN
  ClrScr;
  Nhap_Du_Lieu;
  Thuc_Hien;
END.