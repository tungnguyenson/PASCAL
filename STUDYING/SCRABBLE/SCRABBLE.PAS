Program SCRABBLE_The_Crossword_Game;

Uses ObjData, TextMode;

Var
  i, j, k : Byte;

BEGIN
  New(Scrabble);
  Repeat
  Until GameExit;
  Scrabble^.Done;
  Dispose(Scrabble);
END.