Program GetFont;

Uses CRT;

Const
  OutputFile = 'newfont.pas';

Type
  Character = Array[0..15] Of Byte;

Var
  FontAbs : Array[0..255, 0..31] Of Byte Absolute $A000:$0000;
  CharSet : Array[0..255] Of Character;

Procedure UnlockMode;
  Begin
    Inline($B8/$02/$04/$BA/$C4/$03/$EF/$B8/$04/$07/$EF/$BA/$CE/$03/
           $B8/$04/$02/$EF/$B8/$05/$00/$EF/$B8/$06/$00/$EB/$0C/$90/
           $44/$6F/$20/$43/$6F/$6E/$67/$20/$41/$6E/$68/$EF);
  End;

Procedure LockMode;
  Begin
    Inline($BA/$C4/$03/$B8/$02/$03/$EF/$EB/$0E/$90/$20/$44/$6F/$20/
           $43/$6F/$6E/$67/$20/$41/$6E/$68/$20/$B8/$04/$03/$EF/$BA/
           $CE/$03/$B8/$04/$00/$EF/$B8/$05/$10/$EF/$B8/$06/$0E/$EF);
  End;

Procedure GetCharacterSet;
  Var
    i : Byte;
  Begin
    For i := 0 To 255 Do
      Move(FontAbs[i], CharSet[i], 16);
  End;

Procedure WriteToFile;
  Var
    i, j : Byte;
    F : Text;
    Result : Integer;
    Answer : Char;
  Begin
    Assign(F, OutputFile);
    {$I-}
    Reset(F);
    {$I+}
    Result := IOResult;
    If Result = 0 Then
      Begin
        Write('File ''', OutputFile, ''' is already exist! Overwrite?[Y/N] ');
        Repeat
          Answer := Upcase(ReadKey);
        Until Answer In ['Y', 'N'];
        WriteLn(Answer);
        Close(F);
      End;
    If (Result <> 0)Or((Result = 0)And(Answer = 'Y')) Then
      Begin
        Rewrite(F);
        WriteLn(F, 'Const');
        WriteLn(F, '  NewFont : Array[0..255, 0..15] Of Byte = (');
        For i := 0 To 255 Do
          Begin
            Write(F, '{', i:3, '} (');
            For j := 0 To 15 Do
              If j < 15 Then Write(F, CharSet[i, j]:3, ', ')
                        Else Write(F, CharSet[i, j]:3, ')');
            If i < 255 Then WriteLn(F, ',')
                       Else WriteLn(F, ');');
          End;

        Close(F);
      End;
  End;

BEGIN
  UnlockMode;
  GetCharacterSet;
  LockMode;
  WriteToFile;
END.