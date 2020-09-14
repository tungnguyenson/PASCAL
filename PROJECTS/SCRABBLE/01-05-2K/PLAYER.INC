Procedure TScbPlayer.Init;
  Var
    KeyCode : Word;
    KeyChar : Char;
    I : Byte;
    Y : Byte;
    Msg, SbrMsg, StName : String;
    OK : Boolean;
  Begin
    For I := 1 To 4 Do
      Begin
        PlayerInfo[I].PlayerID := I;
        PlayerInfo[I].Left := 47;
        PlayerInfo[I].Top := 3+(I-1)*4;
      End;

  { The following code is designed for debug only }
    PlayerCount := 4;
    PlayerInfo[1].Init('NSTung', Human);
    PlayerInfo[2].Init('Sir HuyDQ', Human);
    PlayerInfo[3].Init('Han King', Human);
    PlayerInfo[4].Init('Marx Huy', Human);
    Exit;
  {}

    CursorMoveWithText := True;
    SetCursorType(curSmall);
    SetTxtColor(7, 0);
    SbrMsg := 'Press ''1''..''4'' or Esc to exit';
    Scrabble.StatusBar.Change(SbrMsg);
    Msg := 'How many players do you want to play? ';
    Scrabble.TextArea.OutMsg(1, 1, Msg);
    OK := False;
    Repeat
      GetKeyCode(KeyCode, KeyChar);
      If KeyChar In ['1'..'4'] Then OK := True
       Else If (KeyCode = kbEsc) Then
        If Scrabble.ConfirmExitGame = True Then
          Begin
            OK := True;
            Scrabble.GameExit := True;
          End
         Else
          Begin
            Scrabble.StatusBar.Change(SbrMsg);
            SetCursorType(curSmall);
            Scrabble.TextArea.OutMsg(1, 1, Msg);
          End;
    Until OK;
    If Not Scrabble.GameExit Then
      Begin
        Scrabble.TextArea.OutMsg(valNotSet, valNotSet, Upcase(KeyChar));
        PlayerCount := Ord(KeyChar)-Ord('1')+1;
        Scrabble.StatusBar.Change('Type player''s name (empty name = computer)');
        For I := 1 To PlayerCount Do
          Begin
            Inc(Scrabble.TextArea.CurrentY);
            Scrabble.TextArea.OutMsg(1, valNotSet, '  Player '+StrConv(I)+': ');
            ReadLn(StName);
            If StName <> '' Then
              PlayerInfo[I].Init(StName, Human)
             Else
              PlayerInfo[I].Init('Computer', Computer);
            PlayerInfo[I].Show;
          End;
        Scrabble.TextArea.Clear;

      End
     Else
      Begin
        Scrabble.GameExit := True;
      End;
  End;

Procedure TScbPlayer.Show;
  Begin
  End;

Procedure TScbPlayer.GetLetters;
  Var
    I, J, K, L, P : Byte;
  Begin
    For I := 1 To PlayerCount Do
      Begin
        P := PlayerTurn+I;
        If P > PlayerCount Then P := P-PlayerCount;
        With PlayerInfo[P] Do
          Begin
            J := 7-Length(Letters);
            If (J > 0) And(Length(Scrabble.LetterAvail) > 0) Then
              Begin
                If J > Length(Scrabble.LetterAvail) Then
                   J := Length(Scrabble.LetterAvail);
                For K := 1 To J Do
                  Begin
                    L := Random(Length(Scrabble.LetterAvail))+1;
                    Letters := Letters+Scrabble.LetterAvail[L];
                    Delete(Scrabble.LetterAvail, L, 1)
                  End;
              End;
          End;
      End;
  End;

Procedure TScbPlayer.ComputerTurn;
  Begin
  End;

Procedure TScbPlayer.HumanTurn;
  Begin
  End;

Procedure TScbPlayer.ApplyTurn;
  Var
    KeyCode : Word;
    KeyChar : Char;
    OK : Boolean;
  Begin
    OK := False;
    Repeat
      SetCursorType(curSmall);
      CursorMoveWithText := True;
      Scrabble.StatusBar.Change('Press any key to continue or Esc to exit ...');
      GetKeyCode(KeyCode, KeyChar);
      OK := True;
      If KeyCode = kbEsc Then
        Begin
          Scrabble.QuerryExit := True;
          Scrabble.QuerryExitGame;
          If Not Scrabble.GameExit Then OK := False;
        End;
    Until OK;

    Inc(PlayerTurn);
    If PlayerTurn > PlayerCount Then PlayerTurn := 1;
  End;