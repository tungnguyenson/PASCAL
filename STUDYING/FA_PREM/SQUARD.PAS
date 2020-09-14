Procedure Show_Clubs_Squard;
  Var
    TxtThu : TTextBox;
  Begin
    Show_Main_Screen;
    cmdClubSquard.Enabled := False;
    cmdClubSquard.ShowUp;
    HideMouse;
    With txtThu Do
      Begin
        Txt := 'Testing Textbox Control Object';
        Left := 50;
        Top := 100;
        Width := 110;
        ForeColor := 0;
        BackColor := 15;
        FontBold := False;
        Show;
        GotFocus;
      End;
    ShowMouse;
    Repeat
      CheckOptional;
      If Keypressed Then KeyCode := GetKeyCode;
    Until ((Option <> optClubSquard)And(Option <> optUncheck))Or(KeyCode = kbEsc);
    cmdClubSquard.Enabled := True;
    cmdClubSquard.ShowUp;
  End;
