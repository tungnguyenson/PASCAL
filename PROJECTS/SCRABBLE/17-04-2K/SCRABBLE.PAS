Program SCRABBLE_Crossword_Game;

Uses Global, Support, Player, ScbTable, TextFont;

Type
  TScrabble = Object
    ForeColor : Byte;
    BackColor : Byte;
    GameExit  : Boolean;
    GameOver  : Boolean;

    TitleBar  : TTitleBar;
    StatusBar : TStatusBar;

    Table     : TScrabbleTable;

    Players   : TPlayers;

    Procedure Init;
    Procedure Show;
    Procedure Run;
    Procedure Done;
    Procedure NewGame;
  End;

Var
  Scrabble : TScrabble;

Procedure TScrabble.Init;
  Begin
    ForeColor := ScrabbleColor.ForeColor;
    BackColor := ScrabbleColor.BackColor;
    GameExit := True;

    HideCursor;
    SetKeyboardSpeed(0, 0);
    SetBrightMode;

    TitleBar.Init('S C R A B B L E  -  The Crossword Game');
    StatusBar.Init('Press Enter to exit');

    Table.Init;

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
    Table.Show;

    For Y := 1 To TableSize Do
      For X := 1 To TableSize Do
        If DefaultNewCell[Y, X] <> NoLetter Then
          Begin
            Table.Cell[Y,X] := DefaultNewCell[Y, X];
            Table.DrawNewCell(Y, X);{}
          End;
  End;

Procedure TScrabble.NewGame;
  Begin
    GameOver := False;
    Players.Init;
  End;

Procedure TScrabble.Run;
  Begin
    Repeat
      NewGame;
      Repeat
{        Table.Refresh;{}
        If Players.Turn = Computer Then
          Begin
            Players.ComputerTurn;
            Players.Turn := Human;
          End
         Else
          Begin
            Players.HumanTurn;
            Players.Turn := Computer;
          End
      Until GameOver Or GameExit;
    Until GameExit;
    ReadLn;{}
  End;

Procedure TScrabble.Done;
  Begin
    LoadVGAFont;
    SetTxtColor(7, 0);
    ClearWindow(1, 1, 80, 25, 0);
    SetCursorPos(1, 1);
    SetSmallCursor;
  End;

BEGIN
  Scrabble.Init;
  Scrabble.Run;
  Scrabble.Done;
END.