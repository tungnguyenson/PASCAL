Uses CRT;

Const
  InputFile  : String = 'usme0001.sve';
  DataAddr = $9E393;
  BufSize = 32768;

Var
  F : File;
  Buf : Array[1..BufSize] Of Byte;
  i : Word;
  Cash : LongInt;

BEGIN
  ClrScr;
  Write('Enter filesave: ');
  ReadLn(InputFile);{}
  Assign(F, InputFile);
  {$I-}
  Reset(F, 1);
  {$I+}
  If IOResult = 0 Then
    Begin
      Write('Enter new cash: ');
      ReadLn(Cash);{}
      For i := 1 To DataAddr Div BufSize Do
        BlockRead(F, Buf, BufSize);
      BlockRead(F, Buf, DataAddr Mod BufSize);
      BlockWrite(F, Cash, SizeOf(Cash));
      Close(F);
    End
   Else
    WriteLn('Error! No file exist!');
END.