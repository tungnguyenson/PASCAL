Program SCRABBLE_Crossword_Game;

Uses Global, Support, Player, ScbTable, TextFont, Keyboard;

Type
  TScrabble = Object
    ForeColor : Byte;
    BackColor : Byte;

    GameExit  : Boolean;
    GameQuerryExit : Boolean;
    GameOver  : Boolean;

    TitleBar  : TTitleBar;
    StatusBar : TStatusBar;

    Table     : TScrabbleTable;

    PlayerTurn  : Byte;
    PlayerCount : Byte;
    Player      : Array[1..MaxPlayer] Of TPlayer;

    Procedure Init;
    Procedure Show;
    Procedure Run;
    Procedure Done;
    Function ConfirmExit : Boolean;
    Procedure NewGame;

    Procedure InitPlayers;
    Procedure ComputerTurn;
    Procedure HumanTurn;
    Procedure ApplyTurn;
  End;

Var
  Scrabble : TScrabble;

Procedure TScrabble.Init;
  Begin
    ForeColor := ScrabbleColor.ForeColor;
    BackColor := ScrabbleColor.BackColor;
    GameExit := False;
    GameQuerryExit := True;

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

Function TScrabble.ConfirmExit;
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
    If KeyCode = kbKeyY Then ConfirmExit := True
                        Else ConfirmExit := False;
    StatusBar.Change('');
    SetCursorType(curHide);
  End;

Procedure TScrabble.NewGame;
  Begin
    GameOver := False;
    InitPlayers;
  End;

Procedure TScrabble.InitPlayers;
  Begin
  End;

Procedure TScrabble.HumanTurn;
  Begin
  End;

Procedure TScrabble.ComputerTurn;
  Begin
  End;

Procedure TScrabble.ApplyTurn;
  Begin
  End;

Procedure TScrabble.Run;
  Begin
    Repeat
      NewGame;
      Repeat
{        Table.Refresh;{}
        If PlayerTurn = Computer Then
          Begin
            ComputerTurn;
            PlayerTurn := Human;
          End
         Else
          Begin
            HumanTurn;
            PlayerTurn := Computer;
          End;

        ApplyTurn;

        If GameQuerryExit Then
          Begin
            If ConfirmExit Then
              Begin
                Ga                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         