Uses CRT, KeyBoard, Support;

Var
  Shift, KeyCode : Word;

BEGIN
  ClrScr;
{  OutStr(0, 0, '7654321076543210');{}
  Shift := 0;
  Repeat
    If Shift <> kbShiftMask Then
      Begin
        OutStr(2, 0, '  ');
        OutStr(3, 0, '   ');
        OutStr(1, 0, Binary(kbShiftMask));
        OutStr(2, 0, Hexa(kbShiftMask));
        OutByte(3, 0, kbShiftMask);
        Shift := kbShiftMask;
      End;
    If IsKeyPressed Then KeyCode := GetKeyCode;{}
    KeyCode := Ord(ReadKey);
    If KeyCode = 0 Then
      Begin
        KeyCode := Ord(ReadKey);
        WriteLn('FKey - Code ', KeyCode, ' (', Hexa(KeyCode), ')')
      End
     Else
      WriteLn('NKey - Code ', KeyCode, ' (', Hexa(KeyCode), ')');{}
  Until KeyCode = 27;
END.
