Uses CRT;

Const
  InputFile = 'solitare.dat';
  OutputFile = 'solitare.zip';
  BufSize = 1024;

Var
  Buf : Array[1..BufSize] Of Byte;
  Conv, NewChars : Array[0..255] Of Byte;
  UsedChars : Byte;

Procedure CountUsedChars;
  Var
    F : File;
    Used : Array[0..255] Of Boolean;
    i, Result : Integer;
  Begin
    For i := 0 To 255 Do Used[i] := False;
    For i := 0 To 255 Do Conv[i] := 0;
    For i := 0 To 255 Do NewChars[i] := 0;
    Assign(F, InputFile);
    Reset(F, 1);
    Repeat
      BlockRead(F, Buf, SizeOf(Buf), Result);
      For i := 1 To Result Do
        Used[Buf[i]] := True;
    Until EOF(F) Or (Result <> BufSize);
    Close(F);
    UsedChars := 0;
    For i := 0 To 255 Do
      If Used[i] = True Then
        Begin
          Inc(UsedChars);
          Conv[UsedChars] := i;
          NewChars[i] := UsedChars;
        End;
  End;

Procedure Zip;
  Var
    FI, FO : File;
    i, Result : Integer;
  Begin
    Assign(FI, InputFile);  Reset(FI, 1);
    Assign(FO, OutputFile);  Rewrite(FO, 1);
    BlockWrite(FO, Conv, UsedChars);
    Repeat
      BlockRead(FI, Buf, SizeOf(Buf), Result);
      For i := 1 To Result Do
        Buf[i] := NewChars[Buf[i]];
      BlockWrite(FO, Buf, Result);
    Until EOF(FI) Or (Result <> BufSize);
    Close(FI);
    Close(FO);
  End;

BEGIN
  CountUsedChars;
  Zip;
END.