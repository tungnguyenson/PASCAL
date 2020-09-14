Procedure InitScreen;
  Begin
{    ClearWindow(1, 1, 80, 25, 0);{}
    BackgroundScr.Save;
    With LeftPanel^ Do
      Begin
        Init(1, 1, Brief);
        SortBy := SortByTime;
        GetDir(0, Path);
        Path := 'C:\WINNT';
        OpenDir(Path);
        Active := True;
        Visible := True;
        FileArr[FileListIndex].Selected := True;
        ShowHiddenFile := True;
      End;
    With RightPanel^ Do
      Begin
        Init(41, 1, Brief);
        SortBy := SortBySize;
        GetDir(0, Path);
        OpenDir(Path);
        Visible := True;
      End;
    LeftPanel^.OppositePanel := RightPanel;
    RightPanel^.OppositePanel := LeftPanel;
    DrawNC;
  End;

Procedure InitNC;
  Begin
    SetKeyboardSpeed(0, 0);
    ExitNC := False;
    New(LeftPanel);
    New(RightPanel);
    ActivePanel := LeftPanel;
    CommandLine := '';
  End;

Procedure ChangePanel;
  Begin
    With ActivePanel^ Do
      Begin
        Active := False;
        Redraw;
      End;
    With ActivePanel^.OppositePanel^ Do
      Begin
        Active := True;
        Redraw;
        ChangeDefaultDir;
      End;
    ActivePanel := ActivePanel^.OppositePanel;
  End;

Procedure DrawNC;
  Begin
    LeftPanel^.Draw;
    RightPanel^.Draw;
    ShowCommentBar;
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