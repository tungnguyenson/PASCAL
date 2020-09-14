Program SCRABBLE_Crossword_Game;

Uses Global, Support, Player, Table, TextFont, Keyboard;

Type
  TLetterPlace = Record
    SourcePos : Byte;         { from player's letter }
    DestRow, DestCol : Byte;  { from scrabble table  }
  End;

  TPlayerTurnInfo = Record
    PlayerID : Byte;
    LetterPlaceCount : Byte;
    LetterPlace : Array[1..7] Of TLetterPlace;
  End;

  PScbTable = ^TScbTable;
  TScbTable = Object(TTable)
  End;

  PScbPlayer = ^TScbPlayer;
  TScbPlayer = Object
    PlayerTurn  : Byte;
    PlayerCount : Byte;
    PlayerInfo  : Array[1..MaxPlayer] Of TPlayerInfo;
    Procedure Init;
    Procedure Show;
    Procedure GetLetters;
    Procedure ComputerTurn;
    Procedure HumanTurn;
    Procedure ApplyTurn;{}
  End;


  TScrabble = Object
    ForeColor : Byte;
    BackColor : Byte;

    GameExit  : Boolean;
    QuerryExit : Boolean;
    GameOver  : Boolean;

    TitleBar  : TTitleBar;
    StatusBar : TStatusBar;
    TextArea  : TTextArea;

    Table     : PScbTable;
    Players   : PScbPlayer;

    LetterAvail : String;
    LetterCount : TScbLetterCount;
    LetterScore : TScbLetterScore;

    Procedure Init;
    Procedure Show;
    Procedure Run;
    Procedure Done;
    Function  ConfirmExitGame : Boolean;
    Procedure QuerryExitGame;
    Procedure NewGame;
    Procedure ShowLetterAvail;
    Procedure ShowLetterScore;

  End;

Var
  Scrabble : TScrabble;

{$I Player.Inc}
{$I Scrabble.Inc}

BEGIN
  Scrabble.Init;
  Scrabble.Run;
  Scrabble.Done;
END.