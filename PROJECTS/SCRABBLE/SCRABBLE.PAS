Program SCRABBLE_The_Crossword_Game;

Uses ObjData, TextMode, Dic;

Var
  i, j, k : Byte;
  Dictionary : PDictionary;

BEGIN
  New(Dictionary);
  Dictionary^.LoadDictionary('words.dat');
  New(Scrabble);
  With Scrabble^ Do
    Begin
      InitGame;
{      ShowAsciiTable;{}
      ComputerThink(1);
    End;
  ReadLn;
{  Repeat
  Until GameExit;{}
  Scrabble^.Done;
  Dispose(Scrabble);
  Dispose(Dictionary);
END.