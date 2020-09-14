Procedure GetPlayers;
  Var
    i : Byte;
    Ch : Char;
  Begin
    ClearWindow(1, 2, 80, 24, 0);
    ShowStatusBar('');
    TextAttr := 7;
    GoToXY(1, 3);
    Write('How many players do you want to play?[1..4, 0 = Exit] ');
    Repeat
      Ch := ReadKey;
    Until Ch In ['0'..'4'];
    WriteLn(Ch);
    If Ch = '0' Then GameCancelled := True
     Else
      Begin
        NumberOfPlayers := Ord(Ch)-48;
        For i := 1 To NumberOfPlayers Do
          Begin
            Write('Player ', i, ' : (H)uman or (C)omputer? ');
            Repeat
              Ch := Upcase(ReadKey);
            Until Ch In ['H', 'C'];
            If Ch = 'H' Then
              Begin
                Player[i].Controller := Human;
                WriteLn('Human');
                Write('Please type your name: ');
                ReadLn(Player[i].Name);
                If Length(Player[i].Name) > 20 Then
                  Player[i].Name := Copy(Player[i].Name, 1, 20);
                If Player[i].Name = '' Then Player[i].Name := 'Human';
              End
             Else
              Begin
                Player[i].Controller := Computer;
                Player[i].Name := 'Computer';
                WriteLn('Computer');
              End;
          End;
        ShowStatusBar('Press any key to continue...');
        Ch := ReadKey;
        If Ch = #0 Then Ch := ReadKey;
        ClearWindow(1, 19, 80, 24, 0);
      End;
  End;

Function GetPlayerFirst : Byte;
  Var
    i, Row, Col : Byte;
    KeyCode : Word;
  Begin
    Row := 8;
    Col := 8;
    Board[8, 8] := BlankLetter;
    Board[8, 9] := BlankLetter;
    ShowCell(8, 8);
    ShowCell(8, 9);
    Repeat
      GoToXY(Left+(Col-1)*3+2, Top+Row+1);
      KeyCode := GetKeyCode;
      If KeyCode = kbLeftArrow Then
        If Col = 1 Then Col := Cols
                   Else Dec(Col);
      If KeyCode = kbRightArrow Then
        If Col = Cols Then Col := 1
                      Else Inc(Col);
      If KeyCode = kbUpArrow Then
        If Row = 1 Then Row := Rows
                   Else Dec(Row);
      If KeyCode = kbDownArrow Then
        If Row = Rows Then Row := 1
                      Else Inc(Row);
    Until (KeyCode = kbSpaceBar)And(Row = 8)And((Col = 8)Or(Col = 9));
    i := Random(2);
    If i = 0 Then
      Begin
        Board[8, 8] := 'A';
        Board[8, 9] := 'B';
      End
     Else
      Begin
        Board[8, 8] := 'B';
        Board[8, 9] := 'A';
      End;
    ShowCell(Row, Col);
    If Board[Row, Col] = 'A' Then GetPlayerFirst := Human
                             Else GetPlayerFirst := Computer;
  End;

