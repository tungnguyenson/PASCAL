Procedure TPlayer.GetLetters;
  Var
    i, j, Len : Byte;
  Begin
    Len := Length(Letters);
    For i := 1 To 7-Len Do
      If Length(LettersAvail) > 0 Then
        Begin
          j := Random(Length(LettersAvail))+1;
          Letters := Letters+LettersAvail[j];
          Delete(LettersAvail, j, 1);
        End;
  End;

Procedure TPlayer.HumanTurn;
  Const
    erNoError = 0;
    erFirstTurn =  1;
  Var
    Row, Col : Byte;
    KeyChar : Char;
    KeyCode : Word;
    Queue : Array[1..7, 1..3] Of Byte;
    TopQueue, i, j : Byte;
    ErrorCode : Byte;

    Procedure ShowCursor;
      Begin
        GoToXY(Left+Col*3-1, Top+Row+1);
      End;

    Function CheckTurn : Byte;
      Var
        i : Byte;
      Begin
        If SoLuotDi = 1 Then
          If Board[8, 8] = NoLetter Then
            ErrorCode := erFirstTurn;
        If TopQueue > 1 Then
          Begin
          End;
      End;

    Procedure ShowErrorMsg(ErrorCode : Byte);
      Var
        ErrorMsg : String;
      Begin
        Case ErrorCode Of
          erFirstTurn :
            ErrorMsg := 'You must place one letter in center of square!';
        End;
      End;

  Begin
    ShowStatusBar('Space : Delete  Enter : Next Player  AltX : Quit');
    Row := 8;
    Col := 8;
    GoToXY(Left+Col*3-1, Top+Row+1);
    TopQueue := 0;
    Repeat
      If (Board[Row, Col] = NoLetter) Then
        Begin
          TextAttr := 15;
          GoToXY(1, 24);
          ClrEOL;
          If Mask[Row, Col] = DoubleLetter Then
            Write('Double Letter Score')
           Else If Mask[Row, Col] = TripleLetter Then
            Write('Triple Letter Score')
           Else If Mask[Row, Col] = DoubleWord Then
            Write('Double Word Score')
           Else If Mask[Row, Col] = TripleWord Then
            Write('Triple Word Score');
          ShowCursor;
        End;
      KeyCode := GetKeyCode;
      Case KeyCode Of
        kbLeftArrow :
          Begin
            If Col > 1 Then Dec(Col)
                       Else Col := Cols;
            ShowCursor;
          End;
        kbRightArrow :
          Begin
            If Col < Cols Then Inc(Col)
                          Else Col := 1;
            ShowCursor;
          End;
        kbUpArrow :
          Begin
            If Row > 1 Then Dec(Row)
                       Else Row := Rows;
            ShowCursor;
          End;
        kbDownArrow :
          Begin
            If Row < Rows Then Inc(Row)
                          Else Row := 1;
            ShowCursor;
          End;
        Ord('A')..Ord('z') :
          Begin
            KeyChar := Chr(KeyCode);
            KeyChar := Upcase(KeyChar);
            If KeyChar In ['A'..'Z'] Then
              If (Board[Row, Col] = NoLetter)And(Pos(KeyChar, Letters) <> 0) Then
                Begin
                  i := Pos(KeyChar, Letters);
                  Board[Row, Col] := Letters[i];
                  ShowNewCell(Row, Col);
                  Letters[i] := NoLetter;
                  Inc(TopQueue);
                  Queue[TopQueue, 1] := Row;
                  Queue[TopQueue, 2] := Col;
                  Queue[TopQueue, 3] := i;
                  ShowStatus(Active);
                  ShowCursor;
                End;
          End;
        Ord('?') : ;
        kbSpaceBar :
          If Board[Row, Col] <> NoLetter Then
            Begin
              i := 1;
              While (i <= 7)And((Queue[i, 1] <> Row)Or(Queue[i, 2] <> Col)) Do
                Inc(i);
              If i <= 7 Then
                Begin
                  Letters[Queue[i, 3]] := Board[Row, Col];
                  Board[Row, Col] := NoLetter;
                  For j := i To TopQueue-1 Do
                    Queue[j] := Queue[j+1];
                  Dec(TopQueue);
                  ShowCell(Row, Col);
                  ShowStatus(Active);
                  ShowCursor;
                End;
            End;
        kbEsc :
          Begin
            ShowStatusBar('Are you sure? [Y/N] ');
            Repeat
              KeyChar := ReadKey;
              If KeyChar = #0 Then KeyChar := ReadKey;
              KeyChar := Upcase(KeyChar);
            Until KeyChar In ['Y', 'N'];
            If KeyChar = 'N' Then
              Begin
                KeyCode := 0;
                ShowStatusBar('Space : Delete  Enter : Next Player  AltX : Quit');
                ShowCursor;
              End;
          End;
      End;
    Until (KeyCode = kbEnter)Or(KeyCode = kbEsc)Or(KeyCode = kbAltX)
          Or(TopQueue = Length(Letters));
    If KeyCode = kbAltX Then GameCancelled := True
     Else If KeyCode = kbEsc Then
       Begin
         For i := 1 To TopQueue Do
           Begin
             Letters[Queue[i, 3]] := Board[Queue[i, 1], Queue[i, 2]];
             Board[Queue[i, 1], Queue[i, 2]] := NoLetter;
             ShowCell(Queue[i, 1], Queue[i, 2]);
           End;
         Letters := '';
         GetLetters;
       End
     Else
      Begin
        ErrorCode := CheckTurn;
        If ErrorCode = erNoError Then
          Begin
            For i := 1 To TopQueue Do
              ShowCell(Queue[i, 1], Queue[i, 2]);
            While Pos(#0, Letters) <> 0 Do
            Delete(Letters, Pos(#0, Letters), 1);
            GetLetters;
          End
         Else
          Begin
            ShowErrorMsg(ErrorCode);
          End;
      End;
  End;

Procedure TPlayer.ComputerTurn;
  Begin
  End;

Procedure TPlayer.ShowStatus;
  Var
    j, x, y, fg, bg : Byte;
    Letter : Char;
  Begin
    x := 47;
    y := (Index-1)*4+3;
    If Status = Active Then
      Begin
        fg := 15;
        bg := 1;
      End
     Else
      Begin
        fg := 7;
        bg := 0;
      End;
    ClearWindow(x, y, 80, y+2, bg);
    TextColor(fg);
    TextBackGround(bg);
    GoToXY(x+1, y);
    Write('Player ', Index, ' (', Name, ')');
    GoToXY(x+1, y+1);
    Write('  Score   : ');
    Write(Score);
    GoToXY(x+1, y+2);
    Write('  Letters : ');
    For j := 1 To 7 Do
      Begin
        Letter := Letters[j];
        If Letter = NoLetter Then
          Write(#218#218#220)
        Else If Letter = BlankLetter Then
          Write(#218#222#220)
        Else
          Write(#218, Chr(Ord(Letter)+127), #220);
      End;
  End;
