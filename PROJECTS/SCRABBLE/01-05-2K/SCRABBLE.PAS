Program SCRABBLE_Crossword_Game;

Uses Global, Support, Player, Table, TextFont, Keyboard;

Type

  TLetterPlace = Record
    SourcePos : Byte;         { from player's letter }
    DestRow, DestCol : Byte;  { from scrabble table  }
  End;

  TPlayerTurnInfo = Object
    PlayerID : Byte;
    LetterCount : Byte;
    Letters : Array[1..7] Of TLetterPlace;
    Procedure Init(P : Byte);
    Procedure PlaceLetter(SP, DR, DC : Byte);
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
    Procedure ApplyTurn(TurnInfo : TPlayerTurnInfo);{}
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

    PlayerTurnInfo : TPlayerTurnInfo;

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

Procedure TPlayerTurnInfo.Init;
  Begin
    LetterCount := 0;
    PlayerID := P;
  End;

Procedure TPlayerTurnInfo.PlaceLetter;
  Begin
    Inc(LetterCount);
    Letters[LetterCount].SourcePos := SP;
    Letters[LetterCount].DestRow := DR;
    Letters[LetterCount].DestCol := DC;
    Scrabble.Table^.DrawNewCell(Scrabble.Players^.PlayerInfo[PlayerID].Letters[SP],
                                DR, DC);
    Scrabble.Players^.PlayerInfo[PlayerID].Letters[SP] := #0;
    Scrabble.Players^.PlayerInfo[PlayerID].Show;
  End;

BEGIN
  Scrabble.Init;
  Scrabble.Run;
  Scrabble.Done;
END.