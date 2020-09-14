  Constructor TCommandButton.Init;
    Begin
      Inherited Init(L, T, W, H, S, FG, BG, HLColor);
    End;

  Procedure TCommandButton.InitButton;
    Begin
      Init(L, T, NotSet, 1, S, FG, BG, HLColor);
      SelForeColor := ForeColor;
      SelBackColor := BackColor;
      If SelFG <> NotSet Then SelForeColor := SelFG;
      If SelBG <> NotSet Then SelBackColor := SelBG;
      Command := cmdNothing;
      If cmd <> NotSet Then Command := cmd;
      TabStop := True;
      If TabIdx <> NotSet Then TabIndex := TabIdx;
      Move(Left, Top, LenCaption, 1);
    End;

  Procedure TCommandButton.Show;
    Begin
      Hide;
      Inherited Show;
      If Active Then
        ShowCaption(NotSet, NotSet, SelForeColor, SelBackColor)
       Else
        ShowCaption(NotSet, NotSet, NotSet, NotSet);
      ShowObjectShadow(Left, Top, Right, Bottom, 1);
    End;

  Procedure TCommandButton.Hide;
    Begin
      ClearWindow(Left, Top, Right+1, Bottom+1, Background);
      Visible := False;
    End;

  Procedure TCommandButton.ShowShrink;
    Begin
      Hide;
      ShowCaption(1, 0, SelForeColor, SelBackColor)
    End;

  Procedure TCommandButton.SetFocus;
    Begin
      Active := True;
      If Visible Then Show;
    End;

  Procedure TCommandButton.LostFocus;
    Begin
      Active := False;
      If Visible Then Show;
    End;

  Destructor TCommandButton.Done;
    Begin
      Inherited Done;
    End;
