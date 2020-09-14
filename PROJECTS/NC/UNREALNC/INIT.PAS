Procedure InitScreen;
  Begin
    ClearWindow(1, 1, 80, 25, 0);{}
    BackgroundScr.Save;
  End;

Procedure InitNC;
  Begin
    SetKeyboardSpeed(0, 0);
    ExitNC := False;
    CommandLine := '';
    AppPath := FExpand('');
    CurrentPath := AppPath;
    cmdHisID := 0;
    cmdHisCount := 0;
    New(LeftPanel);
    New(RightPanel);
    With LeftPanel^ Do
      Begin
        Init(1, 1, Full);
        SortBy := SortByName;
        Visible := False;
        OpenDir(CurrentPath);
        Active := True;
        Visible := True;
        FileArr[FileListIndex].Selected := True;
        ShowHiddenFile := True;
      End;
    With RightPanel^ Do
      Begin
        Init(41, 1, Brief);
        SortBy := SortByName;
        Visible := False;
        OpenDir(CurrentPath);
        Visible := True;
      End;
    LeftPanel^.OppositePanel := RightPanel;
    RightPanel^.OppositePanel := LeftPanel;
    ActivePanel := LeftPanel;
    DrawNC;
  End;

Procedure DrawNC;
  Begin
    If LeftPanel^.Visible Then LeftPanel^.Draw;
    If RightPanel^.Visible Then RightPanel^.Draw;
    If ActivePanel <> Nil Then ChangePanel(ActivePanel)
     Else ShowCommandLine;
    ShowKeyBar;
  End;

Procedure RestartNC;
  Begin
    Asm
      Mov AX, 0003;
      Int 10H;
    End;
    SetBrightMode;
    BackgroundScr.Load;
    LeftPanel^.OpenDir(LeftPanel^.Path);
    RightPanel^.OpenDir(RightPanel^.Path);
    DrawNC;
  End;