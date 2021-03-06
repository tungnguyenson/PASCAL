Program SCRABBLE_Crossword_Game;

Uses Global, Support, Player, ScbTable, TextFont, Keyboard;

Type
  TScrabble = Object
    ForeColor : Byte;
    BackColor : Byte;

    GameExit  : Boolean;
    QuerryExit : Boolean;
    GameOver  : Boolean;

    TitleBar  : TTitleBar;
    StatusBar : TStatusBar;

    Table     : PScrabbleTable;
    Players   : TPlayers;

    Procedure Init;
    Procedure Show;
    Procedure Run;
    Procedure Done;
    Function  ConfirmExitGame : Boolean;
    Procedure QuerryExitGame;
    Procedure NewGame;

  End;

Var
  Scrabble : TScrabble;

Procedure TScrabble.Init;
  Begin
    ForeColor := ScrabbleColor.ForeColor;
    BackColor := ScrabbleColor.BackColor;
    GameExit := False;
    QuerryExit := True;

    HideCursor;
    SetKeyboardSpeed(0, 0);
    SetBrightMode;

    TitleBar.Init('S C R A B B L E  -  The Crossword Game');
    StatusBar.Init('Press Enter to exit');

    New(Table);
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
  Begin
    SetCursorType(curLarge);
    CursorMoveWithText := True;
    Msg := 'Do you really want to exit? [Yes, No]: ';
    StatusBar.Change(Msg);
    Repeat
      GetKeyCode(KeyCode, KeyChar);
    Until (KeyCode = kbKeyY)Or(KeyCode = kbKeyN);
    StatusBar.Change(Msg+Upcase(KeyChar));
    If KeyCode = kbKeyY Then ConfirmExitGame := True
                        Else ConfirmExitGame := False;
    StatusBar.Change('');
    SetCursorType(curHide);
  End;

Procedure TScrabble.NewGame;
  Begin
    GameOver := False;
    Players.Init;
  End;

Procedure TScrabble.QuerryExitGame;
  Begin
    If QuerryExit Then
      Begin
        If ConfirmExitGame Then
          Begin
            GameExit := True;
          End;
        QuerryExit := False;
      End;
  End;

Procedure TScrabble.Run;
  Begin
    Repeat
      NewGame;
      Repeat
{        Table.Refresh;{}
        If Players.PlayerTurn = Computer Then
          Begin
            Players.ComputerTurn;
            Players.PlayerTurn := Human;
          End
         Else
          Begin
            Players.HumanTurn;
            Players.PlayerTurn := Computer;
          End;

        Players.ApplyTurn;

        QuerryExitGame;
      Until GameOver Or GameExit;

      QuerryExitGame;

    Until GameExit;
  End;

Procedure TScrabble.Done;
  Begin
    Dispose(Table);                                                                                                                                                                                                       