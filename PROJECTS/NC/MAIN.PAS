{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+}
{$M 32767,0,200000}

UNIT Main;

INTERFACE

  Uses Global, DOS, Support, Panel, Keyboard, Comment, CtrlObj;

  Type
    PathStr = String[80];

  Var
    LeftPanel : PPanel;
    RightPanel : PPanel;

    KeyCode : Word;
    KeyChar : Char;
    ExitNC : Boolean;
    ActivePanel : PPanel;
    BackgroundScr, NCScr : TSaveScreen;

    i : Integer;
    S : String;

  Procedure InitScreen;

  Procedure InitNC;

  Procedure ChangePanel;

  Procedure DoneNC;

  Procedure DrawNC;

  Procedure Norton_Commander;

IMPLEMENTATION

{$I Init}
{$I Done}
{$I KEYPROC}

Procedure Norton_Commander;
Var
  X, Y : Integer;
  Dest : String;
  ShiftMask : Byte;
Begin
  InitNC;
  InitScreen;
  cmmID := 0;
  Repeat
    KeyCode := 0;
    KeyChar := #0;
    If IsKeypressed Then
      GetKeyCode(KeyCode, KeyChar);
    ShiftMask := kbShiftMask;
    If (ShiftMask And kbAlt <> 0)And(cmmID <> 1) Then
      Begin
        cmmID := 1;
        ShowCommentBarAttachALT;
      End
     Else If (ShiftMask And kbCtrl <> 0)And(cmmID <> 2) Then
      Begin
        cmmID := 2;
        ShowCommentBarAttachCTRL;
      End
     Else If (ShiftMask And kbAlt = 0)And(ShiftMask And kbCtrl = 0)And(cmmID <> 0) Then
      Begin
        cmmID := 0;
        ShowCommentBar;
      End;
    With ActivePanel^ Do
      { Nho xet truong hop thu muc rong }
      Case KeyCode Of
        kbTab : ChangePanel;

        kbUpArrow :
          If FileListIndex > 1 Then
            MoveCursorUp;
        kbDownArrow :
          If FileListIndex < FileCount Then
            MoveCursorDown;
        kbLeftArrow :
          If (ViewMode = Brief)And(FileListIndex > 1) Then
            MoveCursorLeft;
        kbRightArrow :
          If (ViewMode = Brief)And(FileListIndex < FileCount) Then
            MoveCursorRight;

        kbHome : MoveCursorToHome;
        kbEnd : MoveCursorToEnd;
        kbPageUp :
          If FileListIndex > 1 then
            PageUp;

        kbCtrlPageUp :
          Begin
            FileListIndex := 1;
            FirstVisibleItemID := 1;
            LastVisibleItemID := FirstVisibleItemID+VisibleFileCount-1;
            S := Path;
            Path := UpPath(Path);
            If S <> Path Then
				  Begin
                  OpenDir(Path);
                  I := Length(Path)+1;
                  S := Copy(S, I, Length(S)-I);
                  For i := 1 to FileCount do
                    If FileArr[i].Name = S then
                      Begin
                        FileListIndex := i;
                        FileArr[i].Selected := True;
                      End;
                  Draw;
              End;
          End;

        kbPageDown :
          If FileListIndex < FileCount then
            PageDown;

        kbCtrlPageDown :
          Begin
            If (FileArr[FileListIndex].Attr and Directory <>0) then
              If FileArr[FileListIndex].Name <> '..' then
                Begin
                  Path := DownPath(Path, FileArr[FileListIndex].Name);
                  OpenDir(Path);
                  Draw;
                End
          End;

        kbEnter :
          If CommandLine <> '' Then
            Begin
              ExecuteCommandLine;
              CommandLine := '';
            End
           Else If (FileArr[FileListIndex].Attr And Directory = 0) And
                   (FileArr[FileListIndex].Name <> '..') Then
             OpenFile(FileArr[FileListIndex].Name)
           Else If (FileArr[FileListIndex].Name <> '..') Then
             OpenDir(Path+FileArr[FileListIndex].Name)
           Else
             UpDir;

        kbCtrlO :
          Begin
            If Visible Then
              Begin
                Visible := False;
                BackgroundScr.Load;
                ShowCommandLine;
                ShowCommentBar;
              End
             Else
              Begin
                Visible := True;
                DrawNC;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           