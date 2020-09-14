Unit ObjData;

Interface

  Uses TextFont;

  {$I TEMP}

  Type
    StQueue = String[7];

    TQueue = Record
      X, Y : Byte;
      Ch : Char;
    End;

    TScbTable = Object
      Left, Top : Byte;
      Color : TScbtableColor;
      Cells, svCells : TScbCellArray;
      Procedure Init(L, T : Byte);
      Procedure DrawCell(Row, Col : Byte);
      Procedure DrawNewCell(Row, Col : Byte);
      Procedure Show;
      Procedure Refresh;
    End;

    TPlayer = Object
      Index : Byte;
      Left, Top : Byte;
      Name : String[20];
      Color : TScbPlayerStatusColor;
      Controller : (ctlHuman, ctlComputer);
      Letters : StQueue;
      Score : Word;
      Procedure Init;
      Function GetLetters : Byte;
      Procedure ShowStatus(Active : Boolean);
    End;

    PScrabble = ^TScrabble;
    TScrabble = Object
      Color : TScbColor;
      Table : TScbTable;
      Player : Array[1..4] Of TPlayer;
      NumberOfPlayers : Byte;
      PlayerTurn : Byte;
      LetterCount : TScbLetterCount;
      BlankCount : Byte;
      LetterAvail : String;
      LetterTotal : Byte;
      NewLetterQueue : Array[1..7] Of TQueue;
      TitleBar, StatusBar : String[80];
      GameExit, GameOver : Boolean;
      Procedure InitCharSet;
      Procedure InitGame;
      Procedure ResetGame;
      Procedure InitPlayer;
      Procedure ShowLetterScore;
      Procedure ShowLetterAvail;
      Procedure ShowTitleBar;
      Procedure ShowStatusBar;
      Procedure ShowPlayerStatus;
      Procedure Refresh;
      Procedure RandomCells;
      Procedure Done;
    End;

  Var
    Scrabble : PScrabble;

Implementation

  Uses TextMode, Keyboard;

  {$I TEMP2}

  Procedure TScrabble.InitGame;
    Var
      i : Byte;
      Ch : Char;
    Begin
      Color := ScbDefaultColor;
      ClearWindow(0, 0, 79, 24, Color.BackColor);
      TitleBar := 'S C R A B B L E - The Crossword Game';
      StatusBar := '';
      ShowTitleBar;
      ShowStatusBar;
      InitCharSet;
      GameExit := False;
{      ShowAsciiTable;{}
      For i := 1 To 4 Do
        With Player[i] Do
          Begin
            Index := i;
            Left := 46;
            Top := 2+(Index-1)*4;
            Color := ScbPlayerStatusDefaultColor;
          End;
      {}
      GameOver := False;
      PlayerTurn := 4;
      NumberOfPlayers := 0;
      LetterCount := ScbLetterCountDefault;
      BlankCount := ScbBlankCountDefault;
      LetterTotal := BlankCount;
      For Ch := 'A' To 'Z' Do
        LetterTotal := LetterTotal+LetterCount[Ch];
      LetterAvail := '';
      For Ch := 'A' To 'Z' Do
        For i := 1 To LetterCount[Ch] Do
          LetterAvail := LetterAvail+Ch;
      For i := 1 To BlankCount Do
        LetterAvail := LetterAvail+ScbBlankLetter;
      Table.Init(0, 1);
      Table.Show;
      For i := 1 To 4 Do Player[i].Init;
      NumberOfPlayers := 4;
      Player[1].Name := 'Sir Tung';
      Player[2].Name := 'Computer';
      Player[3].Name := 'Sir Tung';
      Player[4].Name := 'Computer';
      Player[1].Controller := ctlHuman;
      Player[2].Controller := ctlComputer;
      Player[3].Controller := ctlHuman;
      Player[4].Controller := ctlComputer;{}
      InitPlayer;
      For i := 1 To 4 Do Player[i].GetLetters;
      Refresh;
    End;

  Procedure TScrabble.ResetGame;
    Begin
      GameExit := False;
    End;

  Function TPlayer.GetLetters;
    Var
      i, j : Byte;
      Ch : Char;
    Begin
      While Length(Letters) < 7 Do
        Letters := Letters+ScbNoLetter;
      For i := 1 To 7 Do
        If Letters[i] = ScbNoLetter Then
          If Length(Scrabble^.LetterAvail) > 0 Then
            Begin
              j := Random(Length(Scrabble^.LetterAvail))+1;
              Ch := Scrabble^.LetterAvail[j];
              Letters[i] := Ch;
              Delete(Scrabble^.LetterAvail, j, 1);
              If Ch = ScbBlankLetter Then Dec(Scrabble^.BlankCount)
                                     Else Dec(Scrabble^.LetterCount[Ch]);
              Dec(Scrabble^.LetterTotal);
            End;
      ShowStatus(False);
    End;

  Procedure TScrabble.RandomCells;
    Var
      i, j, k : Byte;
    Begin
      For i := 1 To ScbTableSize Do
        For j := 1 To ScbTableSize Do
          Begin
            k := Random(100);
            Case k Of
              0 : Table.Cells[i, j] := #32;
              1..26 : Table.Cells[i, j] := Chr(k+64);
              Else Table.Cells[i, j] := #0;
            End;
          End;
    End;

BEGIN
END.