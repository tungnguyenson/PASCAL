Uses CRT;

Const
  TenTepDL = 'CONS.INP';
  TenTepKQ = 'CONS.OUT';
  Instruction : Array['1'..'4'] Of String[6] = ('PLUS1', 'MINUS1', 'INC', 'DUP');

Var
  A : String;

Procedure N0(Var S : String);
  Begin
    S := '32';
  End;

Procedure N_Am(N : Longint; Var S : String);
  Begin
    S := '';
    While N < -1 Do
      Begin
        If Odd(N) Then
          Begin
            S := S+'3';
            N := N+1;
          End
         Else
          Begin
            S := S+'4';
            N := N Div 2;
          End
      End;
    S := S+'2';
  End;

Procedure N_Duong(N : Longint; Var S : String);
  Begin
    S := '';
    While N > 1 Do
      Begin
        If Odd(N) Then
          Begin
            S := S+'3';
            N := N-1;
          End
         Else
          Begin
            S := S+'4';
            N := N Div 2;
          End
      End;
    S := S+'1';
  End;

Procedure Ghi_Ket_Qua(Var F : Text; N : Longint; S : String);
  Var
    i : Byte;
  Begin
    WriteLn(F, '# ', N);
    For i := Length(S) DownTo 1 Do
      WriteLn(F, Instruction[S[i]]);
    WriteLn(F);
  End;

Procedure Thuc_Hien;
  Var
    FI, FO : Text;
    N : LongInt;
    S : String;
  Begin
    Assign(FI, TenTepDL);
    Reset(FI);
    Assign(FO, TenTepKQ);
    Rewrite(FO);
    While Not EOF(FI) Do
      Begin
        ReadLn(FI, N);
        If N = 0 Then N0(S)
         Else If N > 0 Then N_Duong(N, S)
         Else N_Am(N, S);
        Ghi_Ket_Qua(FO, N, S);
      End;
    Close(FO);
    Close(FI);
  End;

BEGIN
  Thuc_Hien;
END.