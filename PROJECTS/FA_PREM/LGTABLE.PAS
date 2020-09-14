Procedure Show_League_Table;
  Var
    cmdDefault : TCommandButton;
    cmdNextRound, cmdPrevRound : TCommandButton;
    cmdNextPage, cmdPrevPage : TCommandButton;
    i, Round, Page, Color : Byte;
  Begin
    Show_Main_Screen;
    cmdLeague.Enabled := False;
    cmdLeague.ShowUp;
    With cmdDefault Do
      Begin
        Caption := '<';
        Top := 30;
        Left := 10;
        Width := 14;
        Height := 16;
        BackColor := 7;
        ForeColor := 0;
        FontBold := True;
        Enabled := True;
      End;
    cmdPrevRound := cmdDefault;
    With cmdPrevRound Do
      Begin
        Caption := '<';
        Top := 30;
        Left := 10;
        ShowUp;
      End;
    cmdNextRound := cmdDefault;
    With cmdNextRound Do
      Begin
        Caption := '>';
        Top := 30;
        Left := 110;
        ShowUp;
      End;
    cmdPrevPage := cmdPrevRound;
    With cmdPrevPage Do
      Begin
        Top := 30;
        Left := 530;
        ShowUp;
      End;
    cmdNextPage := cmdNextRound;
    With cmdNextPage Do
      Begin
        Top := 30;
        Left := 605;
        ShowUp;
      End;
    Round := 38;
    Page := 1;
    HideMouse;
    PrintLabel(25, 30, 85, 'Round '+StrConv(Round)+'/38', AlignCenter, 0, 7);
    PrintLabel(545, 30, 60, 'Page '+StrConv(Page)+'/3', AlignCenter, 0, 7);

    Draw3DEffect(10, 60, 630, 420, 7, Raised);
    Draw3DEffect(15, 65, 625,  83, 7, Sunken);
    Draw3DEffect(15, 87, 625, 415, 0, Sunken);
    PrintLabel(17, 67, 607, 'League Table', AlignCenter, 0, 7);

    PrintLabel(30, 95, 50, 'Pos', AlignCenter, 15, 1);
    PrintLabel(80, 95, 150, 'Clubs''s name', AlignCenter, 15, 3);
    PrintLabel(230, 95, 50, 'Pld', AlignCenter, 15, 1);
    PrintLabel(280, 95, 50, 'W', AlignCenter, 15, 3);
    PrintLabel(330, 95, 50, 'D', AlignCenter, 15, 1);
    PrintLabel(380, 95, 50, 'L', AlignCenter, 15, 3);
    PrintLabel(430, 95, 50, 'F', AlignCenter, 15, 1);
    PrintLabel(480, 95, 50, 'A', AlignCenter, 15, 3);
    PrintLabel(530, 95, 50, 'Pts', AlignCenter, 15, 1);
    For i := 1 To 20 Do
      Begin
        Case i Of
               1 : Color := 14;
           2..10 : Color := 11;
          11..17 : Color := 15;
          18..20 : Color := 12;
        End;
        PrintLabel(30, 110+(i-1)*15, 50, StrConv(i), AlignCenter, Color, 0);
        PrintLabel(80, 110+(i-1)*15, 150, 'Team'+StrConv(i), AlignCenter, Color, 0);
      End;
    ShowMouse;
    Repeat
      If cmdPrevRound.IsClick Then ;
      If cmdNextRound.IsClick Then ;
      If cmdPrevPage.IsClick Then ;
      If cmdNextPage.IsClick Then ;

      CheckOptional;
      If Keypressed Then KeyCode := GetKeyCode;
    Until ((Option <> optLeagueTable)And(Option <> optUncheck))Or(KeyCode = kbEsc);
    cmdLeague.Enabled := True;
    cmdLeague.ShowUp;
  End;
