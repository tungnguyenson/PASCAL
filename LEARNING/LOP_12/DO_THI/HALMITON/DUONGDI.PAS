Program Thuat_Toan_Duyet_Hamilton;

Uses CRT;

Const
  Max = 100;
  Xoa = 9;

Var
  Canh : Array[1..Max, 1..Max] Of Byte;
  Stack, Xet : Array[1..Max] Of Byte;
  Top, N : Byte;
  Time, Dem_KQ : LongInt;

Procedure Doc_Du_Lieu;
  Var
    TenTepDL : String;
    F : Text;
    i, j : Byte;
  Begin
    ClrScr;
    Write('Nhap ten tep du lieu: ');
    ReadLn(TenTepDL);
    Assign(F, TenTepDL);
    ReSet(F);
    ReadLn(F, N);
    For i := 1 To N Do
      Begin
        For j := 1 To N Do Read(F, Canh[i, j]);
        ReadLn(F);
      End;
    Close(F);
    For i := 1 To N Do Canh[i, i] := 0;
  End;

Procedure Xuat_KQ;
  Var
    i : Byte;
  Begin
    Inc(Dem_KQ);
    Write('Nghiem thu ', Dem_KQ, ': ');
    For i := 1 To N-1 Do Write(Stack[i], ' -> ');
    WriteLn(Stack[N]);
  End;

Procedure Thuat_Toan_Duyet;
  Var
    i, j, k : Byte;
    Found : Boolean;
  Begin
    Dem_KQ := 0;
    FillChar(Stack, SizeOf(Stack), 0);
    FillChar(Xet, SizeOf(Xet), 0);
    i := 1;
    Top := 1;
    Stack[Top] := i;
    Xet[i] := 1;
    Found := False;
    Repeat
      j := 1;
      While (j <= N)And((Canh[i, j] <> 1)Or(Xet[j] <> 0)) Do Inc(j);
      If j <= N Then
        Begin
          Xet[j] := 1;
          Canh[i, j] := Xoa;
          Canh[j, i] := Xoa;
          Inc(Top);
          Stack[Top] := j;
          i := j;
        End
       Else
        Begin
          If Top = N Then
            Begin
              Inc(Dem_KQ);
              Found := True;
              Xuat_KQ;
            End;
          For j := 1 To N Do
            If (Canh[i, j] = Xoa)And(j <> Stack[Top-1])And(Xet[j] = 0) Then
          Begin
            Canh[i, j] := 1;
            Canh[j, i] := 1;
          End;
          Xet[i] := 0;
          Stack[Top] := 0;
          Dec(Top);
          i := Stack[Top];
        End;
    Until (i <= 0){ Or Found};
  End;

Begin
  Doc_Du_Lieu;
  Time := MemL[$0000:$046C];
  Thuat_Toan_Duyet;
  Writeln('Co ', Dem_KQ, ' nghiem!');
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:10:7);
  ReadLn;
End.