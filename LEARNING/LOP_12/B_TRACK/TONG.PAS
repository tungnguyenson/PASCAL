{$R-,S-}
Uses CRT;

Const
  Max =  50;
  GH  =  1;
  OP  =  0;

Var
  A, B : Array[1..Max] Of Byte;
  M, S : Word;
  N : Byte;
  Dem, Time : LongInt;

Procedure Init;
  Var
    i : Byte;
  Begin
    N := Max;
    M := N;
    For i := 1 To N Do A[i] := i;
    FillChar(B, SizeOf(B), 0);
    Dem := 0;
    S := 0;
    Time := MemL[$0000:$046C];
  End;

Procedure Output_Result(k : Byte);
  Var
    i : Byte;
  Begin
    Inc(Dem);
    If OP = 1 Then
      Begin
        For i := 1 To k Do
          If B[i] = 1 Then Write(A[i], ' ');
        WriteLn;
      End;
  End;

Procedure BackTracking1(i, S : Byte);
  Var
    j : Byte;
  Begin
    For j := 0 To GH Do
      Begin
        B[i] := j;
        If j <> 0 Then S := S+A[i];
        If (i < N)And(S < M) Then BackTracking1(i+1, S)
         Else If S = M Then Output_Result(i)
         Else If S > M Then Break;
      End;
  End;

Procedure BackTracking2;
  Var
    NgoCut : Boolean;
    i, k : Byte;
  Begin
    NgoCut := False;
    S := 0;
    k := 0;
    Repeat
      If NgoCut = False Then
        Begin
          Inc(k);
          B[k] := 0;
          If k = N Then NgoCut := True;
        End
       Else
        Begin
          If S = M Then Output_Result(k);
          While (k >= 1)And(B[k] = GH) Do
            Begin
              S := S-A[k];
              Dec(k);
            End;
          If k >= 1 Then
            Begin
              Inc(B[k]);
              S := S+A[k];
              If (k < N)And(S < M) Then NgoCut := False;
            End;
        End
    Until k = 0;
  End;

Begin
  ClrScr;
  Init;
  WriteLn('Thuat toan de qui:');
  BackTracking1(1, 0);
  WriteLn('So ket qua tim duoc: ', Dem);
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:6:3, ' giay');
  WriteLn('----------------------------------------');{}
  Init;
  WriteLn('Thuat toan khong de qui:');
  BackTracking2;
  WriteLn('So ket qua tim duoc: ', Dem);
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:6:3, ' giay');
  WriteLn('----------------------------------------');
  Write('Nhan phim Enter de ket thuc ...');{}
  ReadLn;
End.