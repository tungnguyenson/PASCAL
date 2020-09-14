Procedure Show_Top_Scores;
  Begin
    Show_Main_Screen;
    cmdTopScores.Enabled := False;
    cmdTopScores.ShowUp;
    HideMouse;
    ShowMouse;
    Repeat
      CheckOptional;
      If Keypressed Then KeyCode := GetKeyCode;
    Until ((Option <> optTopScores)And(Option <> optUncheck))Or(KeyCode = kbEsc);
    cmdTopScores.Enabled := True;
    cmdTopScores.ShowUp;
  End;
