{$R-,S-,B-}

Uses CRT;

Const
  N = 9;

Var
  A : Array[1..3, 1..3] Of Byte;
  B : Array[1..N] Of Boolean;
  Time, Dem : LongInt;
  T1, T2, T3, T4, T5, T6 : Byte;

Procedure Xuat(Tong : Byte);
  Var
    i : Byte;
    F : Text;
  Begin
    Assign(F, 'nghiem.out');
    If Dem = 1 Then Rewrite(F)
               Else Append(F);
    WriteLn(F, 'Nghiem thu ', Dem, ':');
    WriteLn(F, A[1, 1], '---', A[1, 2], '---', A[1, 3]);
    WriteLn(F, '| / | \ |');
    WriteLn(F, A[2, 1], '---', A[2, 2], '---', A[2, 3]);
    WriteLn(F, '| \ | / |');
    WriteLn(F, A[3, 1], '---', A[3, 2], '---', A[3, 3]);
    WriteLn(F, 'Tong 4 dinh moi hinh la: ', Tong);
    WriteLn(F);
    Close(F);
  End;

Procedure Tim(i : Byte);
  Var
    j : Byte;
  Begin
    For j := 1 To N Do
      If B[j] = False Then
        Begin
          A[(i-1) Div 3+1, (i-1) Mod 3+1] := j;
          B[j] := True;
          If i < N Then Tim(i+1)
           Else
            Begin
              T1 := A[1, 1]+A[1, 2]+A[2, 1]+A[2, 2];
              T2 := A[1, 2]+A[1, 3]+A[2, 2]+A[2, 3];
              T3 := A[2, 1]+A[2, 2]+A[3, 1]+A[3, 2];
              T4 := A[2, 2]+A[2, 3]+A[3, 2]+A[3, 3];
              T5 := A[1, 1]+A[1, 3]+A[3, 1]+A[3, 3];
              T6 := A[1, 2]+A[2, 1]+A[2, 3]+A[3, 2];
              If (T1 = T2)And(T2 = T3)And(T3 = T4)And(T4 = T5)And(T5 = T6) Then
                Begin
                  Inc(Dem);
                  Xuat(T1);{}
                End;
            End;
          B[j] := False;
        End;
  End;

BEGIN
  Time := MemL[$0000:$046C];
  ClrScr;
  FillChar(A, SizeOf(A), 0);
  FillChar(B, SizeOf(B), False);
  Dem := 0;
  Tim(1);
  WriteLn('Bai toan co ', Dem, ' nghiem');
  WriteLn;
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:7:4, ' giay');
  WriteLn;
  Write('Nhan phim Enter de ket thuc ...');
  ReadLn;
END.