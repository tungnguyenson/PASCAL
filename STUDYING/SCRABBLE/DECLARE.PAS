Const
  MaxPlayer = 4;

  Rows = 15;
  Cols = 15;
  Left = 0;
  Top = 1;

  ForeColor = 15;
  BackColor = 6;
  LetterColor = 9;
  NewLetterColor = 12;

  DoubleLetter = 1;
  TripleLetter = 2;
  DoubleWord = 3;
  TripleWord = 4;
  HideLetter = 5;

  NoLetter = #0;
  BlankLetter = #32;

  None = 0;
  Computer = 1;
  Human = 2;

  Player1 = 1;
  Player2 = 2;
  Player3 = 3;
  Player4 = 4;

  kbAltX = $12D;

Type
  TStatus = (Active, Passive);

  TPlayer = Object
    Index : Byte;
    Name : String;
    Controller : Byte;
    Score : Word;
    Letters : String;
    Procedure GetLetters;
    Procedure HumanTurn;
    Procedure ComputerTurn;
    Procedure ShowStatus(Status : TStatus);
  End;

  Const
    Mask : Array[1..Rows, 1..Cols] Of Byte =
           ((4, 0, 0, 1, 0, 0, 0, 4, 0, 0, 0, 1, 0, 0, 4),
            (0, 3, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 3, 0),
            (0, 0, 3, 0, 0, 0, 1, 0, 1, 0, 0, 0, 3, 0, 0),
            (1, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 3, 0, 0, 1),
            (0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0),
            (0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0),
            (0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0),
            (4, 0, 0, 1, 0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 4),
            (0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0),
            (0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0),
            (0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0),
            (1, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 3, 0, 0, 1),
            (0, 0, 3, 0, 0, 0, 1, 0, 1, 0, 0, 0, 3, 0, 0),
            (0, 3, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 3, 0),
            (4, 0, 0, 1, 0, 0, 0, 4, 0, 0, 0, 1, 0, 0, 4));

    LetterCount : Array['A'..'Z'] Of Byte = (9, 2, 2, 4,12, 2, 3, 2, 9, 1, 1, 4, 2,
                                             6, 8, 2, 1, 6, 4, 6, 4, 2, 2, 1, 2, 1);
    LetterScore : Array['A'..'Z'] Of Byte = (1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3,
                                             1, 1, 3,10, 1, 1, 1, 1, 4, 4, 8, 4,10);
Var
  Board : Array[1..Rows, 1..Cols] Of Char;
  Player : Array[1..MaxPlayer] Of TPlayer;
  LettersAvail : String;
  NumberOfPlayers : Byte;
  PlayerTurn : Byte;
  BlankCount : Byte;
  GameCancelled, GameOver : Boolean;
  SoLuotDi : Word;
