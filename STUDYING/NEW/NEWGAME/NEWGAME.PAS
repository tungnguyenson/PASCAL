Uses CRT, Support, Keyboard, Blocks, CtrlObj, Font;

Var
  i, j : Byte;
  Block : Array[0..7] Of TBlock;
  Tetris : TTetris;
  KeyCode : Word;

BEGIN
{  LoadFont(0, 256, Seg(UserFont), Ofs(UserFont));{}
  ShowASCIITable;
  Randomize;
  SetBrightMode;{}
  For i := 1 To 7 Do
    With Block[i] Do
      Begin
        NewBlock(Block[i]);
        GenerateBlock(Block[i], i);
        Left := 5+i*8;
        Top := 1;
        Show;
      End;

  With Tetris Do
    Begin
      Left := 10;
      Top := 0;
      Height := 24;
      Width := 30;
      BackColor := 0;
      ForeColor := 1;
      Level := 3;
      Init(15);
      Show;
      Delay(500);
      AnimateHide(2);
      Delay(500);
      AnimateShow(2);{}
    End;

  Repeat
    KeyCode := GetKeyCode;
    If KeyCode = kbUpArrow Then
      For i := 1 To 7 Do
        Begin
          Block[i].Hide;
          RotateBlock(Block[i]);
          Block[i].Refresh;
        End;
  Until KeyCode = kbEsc;
  VGAFont;{}
END.