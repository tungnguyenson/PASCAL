Uses Support, CtrlObj, Keyboard;

Procedure TestLabel;
  Var
    L : TLabel;
  Begin
    With L Do
      Begin
        InitLabel(15, 2, 30, '~N~guyen ~S~on ~T~ung', 15, 1, 14, AlignRight);
        Show;
        Move(15, 5, NotSet, NotSet);
      End;
    ReadLn;
  End;

Procedure TestCommandButton;
  Var
    cmdYes, cmdNo : TCommandButton;
    I : LongInt;
  Begin
    With cmdYes Do
      Begin
        InitButton(15, 2, '  ~Y~es  ', 7 ,15, 4, 14, 0, NotSet, NotSet);
        Active := True;
        Show;
      End;
    With cmdNo Do
      Begin
        InitButton(25, 2, '   ~N~o   ',  7,15, 4, 14, 0, NotSet, NotSet);
        Show;
      End;
    For I := 1 To $FFFFFF Do I := I;
    cmdYes.ShowShrink;
    For I := 1 To $FFFFFF Do I := I;
    cmdYes.Show;
    ReadLn;
  End;

Procedure TestSingleLineTextBox;
  Var
    txtFile : TSingleLineTextBox;
    KeyCode : Word;
    KeyChar : Char;
  Begin
    With txtFile Do
      Begin
        InitTextBox(15, 3, 40, 'Nguyen Son Tung - 46TH3 - HUCE', 15, 0, 15, 8, NotSet, NotSet);
        SetFocus;
        Show;
        Repeat
          GetKeyEvent(KeyCode, KeyChar);
          Case KeyCode Of
            kbLeftArrow :
              Begin
                If SelLength > 0 Then SelLength := 0;
                MoveCursor(CursorPos-1);
              End;
            kbRightArrow :
              Begin
                If SelLength > 0 Then SelLength := 0;
                MoveCursor(CursorPos+1);
              End;
            kbHome :
              If Txt^ <> '' Then
                Begin
                  If SelLength > 0 Then SelLength := 0;
                  MoveCursor(1);
                End;
            kbEnd :
              If Txt^ <> '' Then
                Begin
                  If SelLength > 0 Then SelLength := 0;
                  MoveCursor(Length(Txt^)+1);
                End;
            kbBackSpace :
              Begin
                If SelLength > 0 Then
                  Begin
                    SelLength := 0;
                    CursorPos := 0;
                    ChangeText('');
                  End
                 Else If CursorPos > 1 Then
                  Begin
                    Dec(CursorPos);
                    Delete(Txt^, CursorPos, 1);
                    MoveCursor(CursorPos);
                    ChangeText(Txt^);
                  End;
              End;
            kbDelete :
              Begin
                If SelLength > 0 Then
                  Begin
                    SelLength := 0;
                    CursorPos := 0;
                    ChangeText('');
                  End
                 Else If (CursorPos > 0)And(CursorPos <= RightChar) Then
                  Begin
                    Delete(Txt^, CursorPos, 1);
                    MoveCursor(CursorPos);
                  End;
              End;
          End;
          Case KeyChar Of
            #32..#255 :
              Begin
                If SelLength > 0 Then
                  Begin
                    SelLength := 0;
                    CursorPos := 2;
                    ChangeText(KeyChar);
                  End
                 Else If Length(Txt^) < MaxLength Then
                  Begin
                    Insert(KeyChar, Txt^, CursorPos);
                    MoveCursor(CursorPos+1);
                  End;
              End;
          End;
        Until KeyCode = kbEsc;
      End;
  End;

Procedure TestCheckBox;
  Var
    Check1, Check2 : TCheckBox;
  Begin
    With Check1 Do
      Begin
        InitCheckBox(5, 3, NotSet, '~U~se tab characters', 15, 1, 10,
                     chkChecked, NotSet);
        Show;
      End;
    With Check2 Do
      Begin
        InitCheckBox(35, 3, NotSet, '~C~hange dir for open', 15, 1, 10,
                     chkUnChecked, NotSet);
        Show;
      End;
    ReadLn;
  End;

Procedure TestOptionButton;
  Var
    Opt1, Opt2, Opt3 : TOptionButton;
  Begin
    With Opt1 Do
      Begin
        Ini                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   