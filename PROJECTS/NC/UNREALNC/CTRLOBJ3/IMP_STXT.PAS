  Constructor TSingleLineTextBox.Init;
    Begin
      Inherited Init(L, T, W, H, S, FG, BG, HLColor);
    End;

  Procedure TSingleLineTextBox.InitTextBox;
    Begin
      Init(L, T, W, 1, StNotUsed, FG, BG, NotSet);

      SelForeColor := ForeColor;
      SelBackColor := BackColor;
      If SelFG <> NotSet Then SelForeColor := SelFG;
      If SelBG <> NotSet Then SelBackColor := SelBG;

      TabStop := True;
      If TabIdx <> NotSet Then TabIndex := TabIdx;

      MaxLength := 255;
      If MaxLen <> NotSet Then MaxLength := MaxLen;

      Txt := Nil;
      ChangeText(S);
    End;

  Procedure TSingleLineTextBox.Highlight;
    Begin
      If Txt^ <> '' Then
        Begin
          SelStart := 1;
          SelLength := Length(Txt^);
          CursorPos := Length(Txt^);
          RightChar := Length(Txt^);
          If RightChar > Width Then LeftChar := RightChar-Width+1
        End;
      Show;
    End;

  Procedure TSingleLineTextBox.SetFocus;
    Begin
      Active := True;
      SetSmallCursor;
      SetCursorPos(Left+CursorPos-LeftChar, Top);
      Highlight;
    End;

  Procedure TSingleLineTextBox.MoveCursor;
    Begin
      If ((I > 0)Or(Txt^ = '')) And (I <= Length(Txt^)+1) Then
        Begin
          CursorPos := I;
          If LeftChar+Width-1 < Length(Txt^) Then
            RightChar := LeftChar+Width-1
           Else
            RightChar := Length(Txt^);
          If I < LeftChar Then
            Begin
              LeftChar := I;
              If LeftChar+Width-1 < Length(Txt^) Then
                RightChar := LeftChar+Width-1
               Else
                RightChar := Length(Txt^);
            End
           Else If RightChar < I Then
            Begin
              RightChar := I;
              If RightChar > Width Then LeftChar := RightChar-Width+1
               Else LeftChar := 1;
            End;
          If Active Then SetCursorPos(Left+CursorPos-LeftChar, Top);
          If Visible Then Show;
        End;
    End;

  Procedure TSingleLineTextBox.ChangeText;
    Var
      Marked : Boolean;
    Begin
      If S = StNotSet Then S := 'Default';
      If Length(S) > MaxLength Then
        Delete(S, MaxLength+1, Length(S)-MaxLength);
      If Txt = Nil Then
        Begin
          { Check for available memory here! }
          New(Txt);
        End;
      If S = '' Then
        Begin
          CursorPos := 1;
          SelStart  := 0;
          SelLength := 0;
          LeftChar  := 0;
          RightChar := 0;
        End;
      Txt^ := S;
      MoveCursor(CursorPos);
    End;

  Procedure TSingleLineTextBox.Show;
    Var
      S : String;
      L, R : Byte;
    Begin
      Inherited Show;
      ClearWindow(Left, Top, Right, Bottom, BackColor);
      OutChar(Left-1, Top, '[', ForeColor, Background);
      OutChar(Right+1, Top, ']', ForeColor, Background);
      If RightChar-LeftChar+1 < Width Then
        S := Copy(Txt^, LeftChar, RightChar-LeftChar+1)
       Else S := Copy(Txt^, LeftChar, Width);
      While Length(S) < Width Do S := S+#250;
      OutStr(Left, Top, S, ForeColor, BackColor);

      { Show selected text }
      If SelLength > 0 Then
        Begin
          L := SelStart;
          R := SelStart+SelLength-1;
          If L < LeftChar Then L := LeftChar;
          If R > RightChar Then R := RightChar;
          S := Copy(Txt^, L, R-L+1);
          OutStr(Left+L-LeftChar, Top, S, SelForeColor, SelBackColor);
        End;{}
      SetCursorPos(Left+CursorPos-LeftChar, Top);
    End;

  Procedure TSingleLineTextBox.Hide;
    Begin
      ClearWindow(Left-1, Top, Right+1, Bottom, Background);
      Visible := False;
    End;

  Destructor TSingleLineTextBox.Done;
    Begin
      If Txt <> Nil Then Dispose(Txt);
    End;
