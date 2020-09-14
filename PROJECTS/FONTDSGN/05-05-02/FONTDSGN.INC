Var
  cmdClear    : TCommandButton;
  cmdCopy     : TCommandButton;
  cmdPaste    : TCommandButton;
  cmdReset    : TCommandButton;
  cmdResetAll : TCommandButton;
  cmdLoad     : TCommandButton;
  cmdSave     : TCommandButton;
  cmdSaveAll  : TCommandButton;
  cmdExit     : TCommandButton;
  cmdLoadAll  : TCommandButton;
  cmdAbout    : TCommandButton;
  cmdHelp     : TCommandButton;
  cmdOK       : TCommandButton;
  cmdClose    : TCommandButton;
  cmdNext     : TCommandButton;
  cmdPrev     : TCommandButton;
  Grid1   : PCharGrid;
  clbGrid : PCharGrid;
  ASCIIGrid : PASCIIGrid;

  TxtAbout : TTextBox;
  TxtHelp  : TTextBox;
  FrmMain  : PForm;
  FrmHelp  : PForm;
  FrmAbout : PForm;

Procedure InitControls;
  Var
    X1, Y1, X2, Y2 : Word;
    W, H : Word;
  Begin
    NewForm(FrmMain);
    With FrmMain^ Do
      Begin
        Caption := VNIConv('Chuwowng trifnh thieest kees font')+' - Font Design';
        Height := 290;
        Width := 490;
        Left := (GetMaxX-Width) Div 2;
        Top :=  (GetMaxY-Height) Div 2;
        FillColor := 7;
      End;
    With cmdClear Do
      Begin
        Top := FrmMain^.Top+FrmMain^.Height-70;
        Left := FrmMain^.Left+15;
        Caption := 'Clear';
        Width := 70;
        Color := 7;
      End;
    With cmdCopy Do
      Begin
        PlaceButton(cmdCopy, cmdClear, ToRight);
        Caption := 'Copy';
        Width := 70;
        Color := 7;
      End;
    With cmdPaste Do
      Begin
        PlaceButton(cmdPaste, cmdCopy, ToRight);
        Caption := 'Paste';
        Width := 70;
        Color := 7;
      End;
    With cmdLoad Do
      Begin
        PlaceButton(cmdLoad, cmdPaste, ToRight);
        Caption := 'Load';
        Width := 70;
        Color := 7;
      End;
    With cmdSave Do
      Begin
        PlaceButton(cmdSave, cmdLoad, ToRight);
        Caption := 'Save';
        Width := 70;
        Color := 7;
      End;
    With cmdReset Do
      Begin
        PlaceButton(cmdReset, cmdSave, ToRight);
        Caption := 'Reset';
        Width := 70;
        Color := 7;
      End;
    With cmdLoadAll Do
      Begin
        PlaceButton(cmdLoadAll, cmdClear, ToDown);
        Caption := 'Load all';
        Width := 70;
        Color := 7;
      End;
    With cmdSaveAll Do
      Begin
        PlaceButton(cmdSaveAll, cmdLoadAll, ToRight);
        Caption := 'Save all';
        Width := 70;
        Color := 7;
      End;
    With cmdResetAll Do
      Begin
        PlaceButton(cmdResetAll, cmdSaveAll, ToRight);
        Caption := 'Reset all';
        Width := 70;
        Color := 7;
      End;
    With cmdHelp Do
      Begin
        PlaceButton(cmdHelp, cmdResetAll, ToRight);
        Caption := 'Help...';
        Width := 70;
        Color := 7;
      End;
    With cmdAbout Do
      Begin
        PlaceButton(cmdAbout, cmdHelp, ToRight);
        Caption := 'About...';
        Width := 70;
        Color := 7;
      End;
    With cmdExit Do
      Begin
        PlaceButton(cmdExit, cmdReset, ToDown);
        Caption := 'Exit';
        Width := 70;
        Color := 7;
      End;
    New(Grid1);
    With Grid1^ Do
      Begin
        Top := FrmMain^.Top+40;
        Left := FrmMain^.Left+15;
        Rows := 16;
        Cols := 8;
        PrvLeft := 0;
        PrvTop := 0;
        PrvFillColor := 4;
        PrvEmptyColor := 15;
        PrvBorderColor := 7;
        FillColor := 9;
        EmptyColor := 15;
        BorderColor := 0;
        Distance := 10;
        FillChar(Grid, SizeOf(Grid), 0);
      End;
    New(ASCIIGrid);
    With ASCIIGrid^ Do
      Begin
        Rows := 8;
        Cols := 40;
        InitFont;
        Left := FrmMain^.Left+110;
        Top := FrmMain^.Top+40;
        FillColor := 9;
        EmptyColor := 15;
        BorderColor := 0;
      End;
    New(clbGrid);
    Row := 256 Div ASCIIGrid^.Cols+1;
    Col := 256 Mod ASCIIGrid^.Cols+1;
    LastRow := 255;
    LastCol := 255;
    ApplyGrid;

    NewForm(FrmAbout);
    With FrmAbout^ Do
      Begin
        Caption := VNIConv('About');
        Height := 200;
        Width := 300;
        Left := (GetMaxX-Width) Div 2;
        Top :=  (GetMaxY-Height) Div 2;
        FillColor := 7;
      End;

    NewForm(FrmHelp);
    With FrmHelp^ Do
      Begin
        Caption := VNIConv('Help');
        Height := 300;
        Width := 400;
        Left := (GetMaxX-Width) Div 2;
        Top :=  (GetMaxY-Height) Div 2;
        FillColor := 7;
      End;

    With cmdOK Do
      Begin
        Caption := 'OK';
        Width := 70;
        Color := 7;
      End;

    With cmdClose Do
      Begin
        Caption := 'Close';
        Width := 70;
        Color := 7;
      End;

    With cmdNext Do
      Begin
        Caption := 'Next';
        Width := 70;
        Color := 7;
      End;

    With cmdPrev Do
      Begin
        Caption := 'Prev';
        Width := 70;
        Color := 7;
      End;

    With TxtAbout Do
      Begin
        X1 := 15;
        Y1 := 30;
        W := FrmAbout^.Width-X1*2;
        H := FrmAbout^.Height-Y1-50;
        Init(FrmAbout^.Left+X1, FrmAbout^.Top+Y1, W, H, 'about.txt');
        ForeColor :=  0;
        BackColor := 15;
        Border := True;
      End;

    With TxtHelp Do
      Begin
        X1 := 15;
        Y1 := 30;
        W := FrmHelp^.Width-X1*2;
        H := FrmHelp^.Height-Y1-50;
        Init(FrmHelp^.Left+X1, FrmHelp^.Top+Y1, W, H, 'help.txt');
        ForeColor :=  0;
        BackColor := 15;
        Border := True;
      End;
  End;

Procedure InitScreen;
  Var
    i : Integer;
  Begin
    HideMouse;
    SetFillStyle(1, 0);
    Bar(0, 0, GetMaxX-1, GetMaxY-1);
    FrmMain^.Show;
    cmdClear.ShowUp;
    cmdCopy.ShowUp;
    cmdPaste.ShowUp;
    cmdReset.ShowUp;
    cmdLoadAll.ShowUp;
    cmdResetAll.ShowUp;
    cmdLoad.ShowUp;
    cmdSave.ShowUp;
    cmdSaveAll.ShowUp;
    cmdAbout.ShowUp;
    cmdHelp.ShowUp;
    cmdExit.ShowUp;
    ASCIIGrid^.ShowAll;
    Grid1^.Show;
    ShowIndex;
    ShowMouse;
  End;

