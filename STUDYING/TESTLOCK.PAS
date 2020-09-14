Uses CRT, Keyboard;

Var
  KeyCode, SM : Word;

BEGIN
  ClrScr;
  SM := $FFFF;
  SendKey(kbEnter);
  Repeat
    If SM <> kbShiftMask Then
      Begin
        SM := kbShiftMask;
        If SM And kbNumLock <> 0 Then TextColor(12)
                                 Else TextColor(8);
        GoToXY(1, 2);
        Write('Num');
      End;
    If IsKeyPressed Then KeyCode := GetKeyCode;
  Until KeyCode = kbEsc;{}
END.