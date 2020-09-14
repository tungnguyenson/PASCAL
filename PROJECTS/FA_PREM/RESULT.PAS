Procedure Show_Matches_Result;
  Begin
    Show_Main_Screen;
    cmdResult.Enabled := False;
    cmdResult.ShowUp;
    HideMouse;
    ShowMouse;
    Repeat
      CheckOptional;
      If Keypressed Then KeyCode := GetKeyCode;
    Until ((Option <> optMatchResult)And(Option <> optUncheck))Or(KeyCode = kbEsc);
    cmdResult.Enabled := True;
    cmdResult.ShowUp;
  End;
