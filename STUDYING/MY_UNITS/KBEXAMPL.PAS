Uses CRT, Keyboard, Support;

Var
  KeyCode : Word;

Procedure TestKeyCode;
  Begin
    Repeat
      KeyCode := GetKeyCode;
      WriteLn('Key : ''', GetKeyName(KeyCode), ''' - Code : ', KeyCode);
    Until KeyCode = kbEsc;
  End;

Procedure TestShiftMask;
  Begin
{    kbShiftMask := kbShiftMask Or kbNumLock;
    kbShiftMask := kbShiftMask Or kbCapsLock;
    kbShiftMask := kbShiftMask Or kbScrollLock;{}
    Repeat
{      If kbShiftMask And kbCtrl <> 0 Then
          OutStrAttr(20, 11, 'Ctrl', 4, 7)
       Else
          OutStrAttr(20, 11, 'Ctrl', 8, 7);{}
      OutStrAttr(10, 10, Binary(kbShiftMask), 7, 0);
      If IsKeypressed Then KeyCode := GetKeyCode;
    Until KeyCode = kbEsc;
  End;

BEGIN
  TextAttr := 7;
  ClrScr;
  TestShiftMask;
END.