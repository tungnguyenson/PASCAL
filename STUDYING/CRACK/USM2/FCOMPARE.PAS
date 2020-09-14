Program Invert;

Const
  BufSize = 16384;

Var
  F1, F2 : File;
  FRsl : Text;
  Buf1, Buf2 : Array[1..BufSize] Of Byte;
  S : String;

Procedure FCompare(Var OutputDevice : Text; Var F1, F2 : File);
  Var
    Ch : Char;
    Offset : LongInt;
    i, Result1, Result2 : Integer;
    FName1, FName2 : String;
  Begin
    Reset(F1, 1);
    Reset(F2, 1);
    FName1 := ParamStr(1);
    FName2 := ParamStr(2);
    While Length(FName1) < 11 Do FName1 := ' '+FName1;
    While Length(FName2) < 11 Do FName2 := ' '+FName2;
    WriteLn(OutputDevice, '  Offset   ', FName1:11, ' ', FName2:11);
    WriteLn(OutputDevice, '----------+-----------+-----------+');
    Offset := 0;
    Repeat
      BlockRead(F1, Buf1, BufSize, Result1);
      BlockRead(F2, Buf2, Result1, Result2);
      For i := 1 To Result2 Do
        If Buf1[i] <> Buf2[i] Then
          Begin
            Write(OutputDevice, Offset+i:10);
            Ch := Char(Buf1[i]);
            If Ord(Ch) < 20 Then Write(OutputDevice, Ord(Ch):12)
                            Else Write(OutputDevice, Ch:12);
            Ch := Char(Buf2[i]);
            If Ord(Ch) < 20 Then Write(OutputDevice, Ord(Ch):12)
                            Else Write(OutputDevice, Ch:12);{}
            WriteLn(OutputDevice);
          End;
      Offset := Offset+Result2;
    Until EOF(F1) Or EOF(F2);
    Close(F2);
    Close(F1);
  End;

BEGIN
  If ParamCount > 1 Then
    Begin
      Assign(F1, ParamStr(1));
      {$I-}
      Reset(F1, 1);
      {$I+}
      If IOResult = 0 Then
        Begin
          Close(F1);
          Assign(F2, ParamStr(2));
          {$I-}
          Reset(F2, 1);
          {$I+}
          If IOResult = 0 Then
            Begin
              Close(F2);
              S := ParamStr(3);
              If S = '' Then FCompare(Output, F1, F2)
               Else If (S = '>')And(ParamStr(4) <> '') Then
                Begin
                  S := ParamStr(4);
                  Assign(FRsl, S);
                  Rewrite(FRsl);
                  FCompare(FRsl, F1, F2);
                  Close(FRsl);
                End;
            End;
        End;
    End
   Else
    Begin
      WriteLn('File Compare written by NST');
      WriteLn;
      WriteLn('Usage: FCOMPARE <File1> <File2>');
      WriteLn;
    End;
END.