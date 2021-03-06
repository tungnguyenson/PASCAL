{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+}
{$M 32767,0,200000}

UNIT Main;

INTERFACE

  Uses Global, DOS, Support, Panel, Keyboard, CtrlObj;

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

    X, Y : Integer;
    Dest : String;
    ShiftMask : Byte;
    i : Integer;
    S : String;

  Procedure InitScreen;

  Procedure InitNC;

  Procedure ChangePanel(Panel : PPanel);

  Procedure DoneNC;

  Procedure DrawNC;

  Procedure Norton_Commander;

IMPLEMENTATION

{$I Init}
{$I Done}
{$I KEYPROC}

Procedure Norton_Commander;
Var
  S : String;
Begin
  InitScreen;
  InitNC;
  KeyBarType := 0;
  Repeat
    KeyCode := 0;
    KeyChar := #0;
    If IsKeypressed Then
      GetKeyCode(KeyCode, KeyChar);
    PressingALTCTRLProcess;
    If KeyCode <> kbNoKey Then
      If ActivePanel <> Nil Then
      With ActivePanel^ Do
        Begin
          Case KeyCode Of
            kbTab :
              If OppositePanel^.Visible = True Then
                ChangePanel(OppositePanel);

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

            kbPageDown :
              If FileListIndex < FileCount then
                PageDown;

            kbCtrlPageUp :
              UpDir;

            kbCtrlPageDown :
              If (FileArr[FileListIndex].Name <> '..') Then
                Begin
                  OpenDir(Path+FileArr[FileListIndex].Name);
                  ChangePanel(ActivePanel);
                End;

            kbEnter :
                ProcessENTER;

            kbF5  :
              ProcessCOPY;

            kbF8  :
              ProcessDELETE;

            kbCtrlEnter :
              Begin
                S := FileArr[FileListIndex].Name;
                If FileArr[FileListIndex].Attr And Directory = 0 Then
                  S := LowerStr(S);
                S := CommandLine+' '+S;
                If Length(S)+Length(CurrentPath) < 79 Then
                  CommandLine := S;
                ShowCommandLine;
              End;

          End;
        End
       Else
        { Xu ly dong lenh }
        Begin
          Case KeyCode Of
            kbEnter :
              Begin
                ExecuteCommandLine;
                CommandLine := '';
              End;

            kbUpArrow :
              If cmdHisID > 1 Then
                Begin
                  Dec(cmdHisID);
                  CommandLine := cmdHistory[cmdHisID];
                  ShowCommandLine;
                End;
            kbDownArrow :
              If cmdHisID < cmdHisCount Then
                Begin
                  Inc(cmdHisID);
                  CommandLine := cmdHistory[cmdHisID];
                  ShowCommandLine;
                End;
          End;
        End;

      Case KeyCode Of
          kbCtrlO :
            ToggleAllPanel;

          kbCtrlF1 :
            TogglePanel(LeftPanel);
          kbCtrlF2 :
            TogglePanel(RightPanel);

          kbCtrlF3 : ResortFileList(SortbyName);
          kbCtrlF4 : ResortFileList(SortbyExt);
          kbCtrlF5 : ResortFileList(SortbyTime);
          kbCtrlF6 : ResortFileList(SortbySize);
          kbCtrlF7 : ResortFileList(Unsorted);

          kbAltF1 : ChangeDrive(LeftPanel);
          kbAltF2 : C                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     