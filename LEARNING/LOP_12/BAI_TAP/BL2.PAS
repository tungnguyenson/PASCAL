Program Bai_Lam_2;

Uses CRT;

Const
  TenTepDL = 'CTY.INP';
  MaxCompany = 100;

Var
  C : Array[1..MaxCompany, 1..MaxCompany] Of Byte;
  Stack, KQ : Array[1..MaxCompany*MaxCompany] Of Byte;
  Xet : Array[1..MaxCompany] Of Byte;
  N, k : Byte;
  Max, M, Top : Word;
  F : Text;
  Time1, Time2 : LongInt;

Procedure Doc_Du_Lieu;
  Var
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      For j := 1 To N Do
        Read(F, C[i, j]);
    For i := 1 To N Do C[i, i] := 0;
    Close(F);
  End;

Procedure Ghi_Ket_Qua;
  Var
    i : Byte;
  Begin
    WriteLn('Tong so cac cong ty tim duoc: ', Max);
    If Max > 0 Then
      Begin
        WriteLn('Day cac cong ty:');
        Write(KQ[1]);
        For i := 2 To Max Do Write('->', KQ[i]);
      End;
    WriteLn;
    Write('Nhan phim Enter de ket thuc ...');
    ReadLn;
  End;

Procedure Tim_Max(i : Byte);
  Var
    j : Byte;
  Begin
    If (MemL[0:1132]-Time1)/18.2 > 10 Then
      Begin
        Ghi_Ket_Qua;
        Halt;
      End;
    For j := 1 To N Do
      If (C[i, j] = 1)And(Xet[j] = 0) Then
        Begin
          Xet[j] := 1;
          Inc(M);
          Stack[M] := j;
          If M > Max Then
            Begin
              Max := M;
              For k := 1 To Max Do KQ[k] := Stack[k];
            End;
          Tim_Max(j);
          Xet[j] := 0;
          Stack[M] := 0;
          Dec(M);
        End;
  End;

Procedure Thuc_Hien;
  Var
    i : Byte;
  Begin
    Max := 0;
    FillChar(Stack, Sizeof(Stack), 0);
    Time1 := MemL[0:1132];
    Max := 0;
    For i := 1 To N Do
      Begin
        M := 1;
        Stack[1] := i;
        FillChar(Xet, Sizeof(Xet), 0);
        Xet[i] := 1;
        Tim_Max(i);
      End;
  End;

Begin
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
End.