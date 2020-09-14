Uses CRT;

Const
  TenTepDL = 'b442.inp';
  MaxN = 15;

Type
  QueueType = Array[1..32767] Of Word;

Var
  Xet : Array[0..(1 Shl MaxN-1)] Of Byte;
  Queue : ^QueueType;
  N : Byte;
  S1, S2 : String;

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


Procedure Doc_Du_Lieu;
  Var
    F : Text;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    ReadLn(F, S1);
    ReadLn(F, S2);
    Close(F);
    If N > MaxN Then
      Begin
        WriteLn('Not enough memory to run ...');
        Halt;
      End;
  End;

Procedure Khoi_Tao;
  Var
    i, j : Byte;
  Begin
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  ReadLn;
END.