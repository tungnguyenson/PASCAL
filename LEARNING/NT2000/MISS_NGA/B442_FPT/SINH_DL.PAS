Uses CRT;

Const
  TenTepDL = 'b442.inp';

Var
  k, N, i, j : Word;
  t : Word;
  F : Text;
  S : String;

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

Procedure Lat(Var S : String; i, k : Byte);
  Var
    j : Byte;
    S1 : String;
  Begin
    S1 := '';
    For j := i To i+k-1 Do
      S1 := S[j]+S1;
    Delete(S, i, k);
    Insert(S1, S, i);
  End;

BEGIN
  k := 3;
  N := 10;
  t := 30;
  S := '10001010';
  WriteLn(S, ' : ', Decimal(S));
  Lat(S, 4, 4);
  WriteLn(S, ' : ', Decimal(S));
  ReadLn;
  S := '';
  Randomize;
  For i := 1 To N Do
    S := S+Chr(Random(2)+48);
  Assign(F, TenTepDL);
  Rewrite(F);
  WriteLn(F, N, ' ', k);
  WriteLn(F, S);
  For i := 1 To T Do
    Begin
      j := Random(N-k)+1;
      Lat(S, j, k);
      WriteLn(F, S, ' ', j:5, Decimal(S):10);
    End;
  Close(F);
END.