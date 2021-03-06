Procedure TScrabble.Init;
  Begin
    Randomize;{}
    ForeColor := ScrabbleColor.ForeColor;
    BackColor := ScrabbleColor.BackColor;
    GameExit := False;
    QuerryExit := False;

    HideCursor;
    SetKeyboardSpeed(0, 0);
    SetBrightMode;

    TitleBar.Init('S C R A B B L E  -  The Crossword Game');
    StatusBar.Init('Press Enter to exit');
    TextArea.Init(1, 18, 45, 24);

    New(Table);
    New(Players);
    Table^.Init;

    Show;

  End;

Procedure TScrabble.Show;
  Const
        DefaultNewCell : Array[1..TableSize, 1..TableSize] Of Char =
        ((#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0,'O','N','E','S','T', #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0),
         (#0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0)
        );
  Var
    X, Y : Byte;
  Begin
    ClearWindow(1, 1, 80, 25, BackColor);
    TitleBar.Show;
    StatusBar.Show;
    TextArea.Show;
    Table^.Show;

    For Y := 1 To TableSize Do
      For X := 1 To TableSize Do
        If DefaultNewCell[Y, X] <> NoLetter Then
          Begin
            Table^.Cell[Y,X] := DefaultNewCell[Y, X];
            Table^.DrawNewCell(Y, X);{}
          End;
  End;

Function TScrabble.ConfirmExitGame;
  Var
    KeyCode : Word;
    KeyChar : Char;
    Msg : String;
    X, Y : Integer;
  Begin
    SetCursorType(curSmall);
    CursorMoveWithText := True;
    Msg := 'Do you really want to exit? [Yes, No]: ';
    StatusBar.Change(Msg);
    GetCursorPos(X, Y);
    Repeat
      GetKeyCode(KeyCode, KeyChar);
    Until (KeyCode = kbKeyY)Or(KeyCode = kbKeyN);
    StatusBar.Change(Msg+Upcase(KeyChar));
    If KeyCode = kbKeyY Then ConfirmExitGame := True
                        Else ConfirmExitGame := False;
    StatusBar.Change('');
    SetCursorType(curNone);
  End;

Procedure TScrabble.NewGame;
  Var
    L : Char;
    I : Byte;
  Begin
    GameOver := False;
    LetterCount := ScrabbleLetterCount;
    LetterScore := ScrabbleLetterScore;
    LetterAvail := '';
    For L := 'A' To 'Z' Do
      For I := 1 To LetterCount[L] Do
        LetterAvail := LetterAvail+L;

    Players^.Init;
    With Players^ Do
      Begin
        GetLetters;
        PlayerTurn := 1;
        PlayerInfo[PlayerTurn].Active := True;
        For I := 1 To PlayerCount Do
          PlayerInfo[I].Show;
      End;

    If Not GameExit Then
      Begin
        ShowLetterScore;
        ShowLetterAvail;
        StatusBar.Change('Esc : Exit');
      End;

{    QuerryExit := True;{}
  End;

Procedure TScrabble.ShowLetterAvail;
  Var
    X, Y : Byte;
    i, j : Byte;
    L : Char;
  Begin
    X := 41;
    Y := 18;
    SetTxtColor(7, 0);
    OutStr(X, Y  , 'Letter available:', valNotSet, valNotSet);
    SetTxtColor(15, 0);
    OutStr(X+2, Y+1, 'A    B    C    D    E    F    G  ', valNotSet, valNotSet);
    OutStr(X+2, Y+2, 'H    I    J    K    L    M    N  ', valNotSet, valNotSet);
    OutStr(X+2, Y+3, 'O    P    Q    R    S    T    U  ', valNotSet, valNotSet);
    OutStr(X+2, Y+4, 'V    W    X    Y    Z            ', valNotSet, valNotSet);
    SetTxtColor(7, 0);
    For i := 1 To 4 Do
      For j := 1 To 7 Do                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           