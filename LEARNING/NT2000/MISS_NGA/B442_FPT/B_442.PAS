Uses CRT;

Const
  TenTepDL = 'b442.inp';
  TenTepKQ = 'b442.out';
  MaxN = 15;

Type
  QueueType = Array[1..32767] Of Word;

Var
  Xet : Array[0..(1 Shl MaxN-1)] Of Byte;
  Queue, Truoc, BienDoi : ^QueueType;
  N, k : Byte;
  S1, S2, SoPhepBD : Word;
  Left, Right : Word;

Function Decimal(S : String) : LongInt;
  Var
    i : Byte;
    L : LongInt;
  Begin
    L := 0;
    For i := Length(S) DownTo 1 Do
      If S[i] = '1' Then
        L := L+1 Shl (Length(S)-i);
    Decimal := L;
  End;

Function Lat(S : Word; i, k : Byte) : Word;
  Var
    j : Byte;
  Begin
    For j := 0 To k Div 2-1 Do
      Begin
        If (S And (1 Shl (i+j)) <> 0)And(S And (1 Shl (i+(k-j)-1)) = 0) Then
          Inc(S, (1 Shl (i+(k-j)-1))-(1 Shl (i+j)))
         Else If (S And (1 Shl (i+j)) = 0)And(S And (1 Shl (i+(k-j)-1)) <> 0) Then
          Dec(S, (1 Shl (i+(k-j)-1))-(1 Shl (i+j)));
      End;
    Lat := S;
  End;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    S : String;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N, k);
    If N > MaxN Then
      Begin
        WriteLn('Not enough memory to run ...');
        Halt;
      End;
    ReadLn(F, S);
    S1 := Decimal(S);
    ReadLn(F, S);
    S2 := Decimal(S);
    Close(F);
  End;

Procedure Thuc_Hien;
  Var
    i, j : Word;
  Begin
    FillChar(Xet, SizeOf(Xet), 0);
    New(Queue);
    New(Truoc);
    FillChar(Queue^, SizeOf(Queue^), 0);
    FillChar(Truoc^, SizeOf(Truoc^), 0);
    Xet[S1] := 1;
    Left := 1;
    Right := 1;
    Queue^[Right] := S1;
    Repeat
      i := 0;
      While (i <= N-k)And(Queue^[Right] <> S2) Do
        Begin
          j := Lat(Queue^[Left], i, k);
          If Xet[j] = 0 Then
            Begin
              Inc(Right);
              Queue^[Right] := j;
              Truoc^[j] := i;
              Xet[j] := 1;
            End;
          Inc(i);
        End;
      Inc(Left);
    Until (Left > Right)Or(Queue^[Right] = S2);
    If Queue^[Right] = S2 Then
      Begin
        New(BienDoi);
        FillChar(BienDoi^, SizeOf(BienDoi^), 0);
        i := S2;
        BienDoi^[1] := S2;
        SoPhepBD := 1;
        Repeat
          i := Lat(i, Truoc^[i], k);
          If i <> S1 Then
            Begin
              Inc(SoPhepBD);
              BienDoi^[SoPhepBD] := i;
            End;
        Until i = S1;
      End;
    Dispose(Truoc);
    Dispose(Queue);
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i, j, k : Word;
    S : String;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    WriteLn(F, SoPhepBD);
    If SoPhepBD <> 0 Then
      Begin
        For i := SoPhepBD DownTo 1 Do
          Begin
            S := '';
            For j := 0 to N-1 Do
              If BienDoi^[i] And (1 Shl j) <> 0 Then S := '1'+S
               Else S := '0'+S;
            WriteLn(F, S);
          End;
        Dispose(BienDoi);
      End;
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.