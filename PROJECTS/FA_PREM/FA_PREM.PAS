Program FA_Premier_League_2000;

Uses CRT, Graph, CtrlObj, spGraph, sgFont, grMouse, Keyboard;

Var
  Option : (optUncheck, optLeagueTable, optMatchResult,
            optTopScores, optClubSquard, optExitProgram);
  FrmMain : PForm;
  cmdLeague, cmdResult, cmdTopScores, cmdClubSquard, cmdExit : TCommandButton;
  KeyCode : Word;

Procedure PrintLabel(Left,Top, Width : Integer; Caption : String;
                     Alignment : TAlignment; ForeColor, BackColor : Byte);
  Var
    StW : Integer;
  Begin
    StW := StrWidth(Caption);
    SetFillStyle(1, BackColor);
    Bar(Left, Top, Left+Width-1, Top+14);
    SetColor(ForeColor);
    Case Alignment Of
      LeftJustify  : PrintStr(Left+1, Top, Caption);
      RightJustify : PrintStr(Left+Width-StW-1, Top, Caption);
      AlignCenter  : PrintStr(Left+(Width-StW) Div 2, Top, Caption);
    End;
  End;

Procedure Init_Control_Objects;
  Begin
    NewForm(FrmMain);
    With FrmMain^ Do
      Begin
        FullScreen := True;
        Caption := 'The FA Premier League 2000';
        FillColor := 7;
      End;
    With cmdLeague Do
      Begin
        Caption := 'League Table';
        Top := 440;
        Left := 10;
        Width := 120;
        Height := ButtonHeight;
        BackColor := 7;
        ForeColor := 0;
        FontBold := True;{}
        Enabled := True;
      End;
    With cmdResult Do
      Begin
        Caption := 'Matches Result';
        Top := 440;
        Left := 140;
        Width := 120;
        Height := ButtonHeight;
        BackColor := 7;
        ForeColor := 0;
        FontBold := True;{}
        Enabled := True;
      End;
    With cmdTopScores Do
      Begin
        Caption := 'Top Scores';
        Top := 440;
        Left := 270;
        Width := 110;
        Height := ButtonHeight;
        BackColor := 7;
        ForeColor := 0;
        FontBold := True;
        Enabled := True;
      End;
    With cmdClubSquard Do
      Begin
        Caption := 'Clubs Squard';
        Top := 440;
        Left := 390;
        Width := 120;
        Height := ButtonHeight;
        BackColor := 7;
        ForeColor := 0;
        FontBold := True;
        Enabled := True;
      End;
    With cmdExit Do
      Begin
        Caption := 'Exit Program';
        Top := 440;
        Left := 520;
        Width := 110;
        Height := ButtonHeight;
        BackColor := 7;
        ForeColor := 0;
        FontBold := True;
        Enabled := True;
      End;
  End;

Procedure Show_Main_Screen;
  Begin
    FrmMain^.Show;
    cmdLeague.ShowUp;
    cmdResult.ShowUp;
    cmdTopScores.ShowUp;
    cmdClubSquard.ShowUp;
    cmdExit.ShowUp;
  End;

Procedure CheckOptional;
  Begin
    Option := optUncheck;
    If cmdLeague.IsClick Then
        Option := optLeagueTable;
    If cmdResult.IsClick Then
        Option := optMatchResult;
    If cmdTopScores.IsClick Then
        Option := optTopScores;
    If cmdClubSquard.IsClick Then
        Option := optClubSquard;
    If cmdExit.IsClick Then
        Option := optExitProgram;
  End;

{$I LGTABLE}
{$I RESULT}
{$I TOPSCORE}
{$I SQUARD}

BEGIN
  If InitMouse Then
    Begin
      InitGraphMode('EGAVGA', VGAHi);{}
{      BuiltInEGAVGAMode;{}
      Init_Control_Objects;
      ShowMouse;
      Option := optLeagueTable;
      Repeat
        If Option = optLeagueTable Then Show_League_Table;
        If Option = optMatchResult Then Show_Matches_Result;
        If Option = optTopScores Then Show_Top_Scores;
        If Option = optClubSquard Then Show_Clubs_Squard;
        If Keypressed Then KeyCode := GetKeyCode;
      Until (Option = optExitProgram)Or(KeyCode = kbEsc);
      Dispose(FrmMain);
{      UnloadAllFont;{}
      CloseGraph;
      WriteLn('/ The FA Premier League 2000 /');
      WriteLn('/    NST Testing Software    /');
    End
   Else WriteLn('This program required a mouse!');
END.