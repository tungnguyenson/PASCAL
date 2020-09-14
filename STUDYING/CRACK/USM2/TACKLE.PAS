Uses CRT;

Const
  InputFile  : String = 'usme0045.sve';
  TeamRecSize = 246;
  FixPos = 208;
  DataAddr = 1165936;
  BufSize = 32768;

Var
  F : File;
  TeamRec : Array[1..TeamRecSize] Of Byte;
  Buf : Array[1..BufSize] Of Byte;
  TeamName : String;
  i, j : Word;

BEGIN
  ClrScr;
{  Write('Enter filesave: ');
  ReadLn(InputFile);{}
  Assign(F, InputFile);
  {$I-}
  Reset(F, 1);
  {$I+}
  If IOResult = 0 Then
    Begin
      WriteLn('  1. All hard tackling');
      WriteLn('  2. All normal tackling');
      WriteLn('  3. All soft tackling');
      Write('Please select: ');
      Repeat
        j := Ord(ReadKey);
      Until j in [49..51];
      WriteLn(j-49);
      Dec(j, 49);
      For i := 1 To DataAddr Div BufSize Do
        BlockRead(F, Buf, BufSize);
      BlockRead(F, Buf, DataAddr Mod BufSize);
      Repeat
        BlockRead(F, TeamRec, FixPos-1);
        BlockWrite(F, j, 1);
        TeamName := '';
        For i := 1 To 20 Do
          If TeamRec[i] <> 0 Then
            TeamName := TeamName + Chr(TeamRec[i]);
{        Write(TeamName:20);{}
        BlockRead(F, TeamRec, TeamRecSize-FixPos);
      Until TeamName = '';
      Close(F);
    End
   Else
    WriteLn('Error! File not found!');
END.