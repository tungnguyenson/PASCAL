Program Invert;

Const
  BufSize = 16384;

Var
  F, FTmp : File;
  Buf : Array[1..BufSize] Of Byte;
  i, Result : Integer;

BEGIN
  If ParamCount <> 0 Then
    Begin
      Assign(F, ParamStr(1));
      {$I-}
      Reset(F, 1);
      {$I+}
      If IOResult = 0 Then
        Begin
          Assign(FTmp, 'invert.tmp');
          Rewrite(FTmp, 1);
          Repeat
            BlockRead(F, Buf, BufSize, Result);
            For i := 1 To Result Do
              Buf[i] := 255-Buf[i];
            BlockWrite(FTmp, Buf, Result);
          Until (Result < BufSize)Or(EOF(F));
          Close(FTmp);
          Close(F);
          Erase(F);
          Rename(FTmp, ParamStr(1));
        End;
    End
   Else
    Begin
      WriteLn('Invert File written by NST');
      WriteLn;
      WriteLn('Usage: Invert <FileName>');
      WriteLn;
    End;
END.