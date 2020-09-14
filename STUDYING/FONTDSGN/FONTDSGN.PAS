Program FONT_DESIGNER;


{
   Version 1.0
   Member of NST Software Family
   19/8/2000
}

Uses CRT, Graph, sgFont, spGraph, grMouse, CtrlObj, Keyboard, TextFont;

Const
  CharFile = 'charsave.pas';
  FontFile = 'fontsave.pas';

Var
  msx, msy : Integer;
  msButton : Byte;
  KeyCode : Word;
  cmdClear, cmdCopy, cmdPaste, cmdReset, cmdResetAll : TCommandButton;
  cmdLoad, cmdSave, cmdSaveAll, cmdExit : TCommandButton;
  Grid1, clbGrid : PCharGrid;
  ASCIIGrid : PASCIIGrid;
  FrmMain : PForm;
  Row, Col, LastCol, LastRow : Byte;

Procedure ShowIndex;
  Var
    i, x, y : Integer;
  Begin
    i := (Row-1)*ASCIIGrid^.Cols+Col-1;
    SetFillStyle(1, FrmMain^.FillColor);
    x := FrmMain^.Left+100;
    y := FrmMain^.Top+185;
    Bar(x, y, x+80, y+15);
    SetColor(0);
    PrintStr(x, y, VNIConv('Soos thuws tuwj: ')+StrConv(i));
  End;

Procedure ApplyASCII;
  Var
    i, j : Byte;
  Begin
    For i := 1 To 16 Do
      Begin
        ASCIIGrid^.Grid[Row, Col, i] := 0;
        For j := 7 DownTo 0 Do
          Inc(ASCIIGrid^.Grid[Row, Col, i], (1 Shl j)*Grid1^.Grid[i, 8-j]);
      End;
  End;

Procedure ClearGrid;
  Begin
    With Grid1^ Do
      Begin
        FillChar(Grid, SizeOf(Grid), 0);
        Show;
        ApplyAscii;
      End;
  End;

Procedure CopyGrid;
  Begin
    clbGrid^.Grid := Grid1^.Grid;
  End;

Procedure PasteGrid;
  Begin
    Grid1^.Grid := clbGrid^.Grid;
    Grid1^.Show;
    ApplyASCII;
  End;

Procedure ApplyGrid;
  Var
    i, j : Byte;
  Begin
    If (LastRow <> 255)And(LastCol <> 255) Then
      ASCIIGrid^.ShowChar(LastRow, LastCol);
    LastRow := Row;
    LastCol := Col;
    Grid1^.PrvLeft := ASCIIGrid^.Left+(col-1)*9;
    Grid1^.PrvTop := ASCIIGrid^.Top+(row-1)*17;
    For i := 1 To 16 Do
      For j := 7 DownTo 0 Do
        If ASCIIGrid^.Grid[row, col, i] And (1 Shl j) <> 0 Then
          GRid1^.Grid[i, 8-j] := 1
         Else
          GRid1^.Grid[i, 8-j] := 0;
    Grid1^.Show;
    ShowIndex;
  End;

Procedure ResetASCIIChar;
  Var
    i : Word;
    j : Byte;
  Begin
    i := (Row-1)*ASCIIGrid^.Cols+Col-1;
    If i < 256 Then
      For j := 1 To 16 Do
        ASCIIGrid^.Grid[Row, Col, j] := StdTextFont[i, j-1]
     Else
      For j := 1 To 16 Do
        ASCIIGrid^.Grid[Row, Col, j] := 0;
    For i := 1 To 16 Do
      For j := 7 DownTo 0 Do
        If ASCIIGrid^.Grid[row, col, i] And (1 Shl j) <> 0 Then
          GRid1^.Grid[i, 8-j] := 1
         Else
          GRid1^.Grid[i, 8-j] := 0;
    Grid1^.Show;
  End;

Procedure ResetASCII;
  Var
    i, j : Byte;
  Begin
    With ASCIIGrid^ Do
      For i := 0 To 255 Do
        For j := 1 To 16 Do
          Grid[i Div Cols+1, i Mod Cols+1, j] := StdTextFont[i, j-1];
    For i := 1 To 16 Do
      For j := 7 DownTo 0 Do
        If ASCIIGrid^.Grid[row, col, i] And (1 Shl j) <> 0 Then
          GRid1^.Grid[i, 8-j] := 1
         Else
          GRid1^.Grid[i, 8-j] := 0;
    ASCIIGrid^.ShowAll;
    Grid1^.Show;
  End;

Procedure SaveGrid;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, CharFile);
    {$I-}Reset(F);{$I+}
    If IOResult <> 0 Then Rewrite(F)
                     Else Append(F);
    Write(F, '(');
    For i := 1 To 16 Do
      If i < 16 Then Write(F, ASCIIGrid^.Grid[Row, Col, i]:3, ',')
                Else WriteLn(F, ASCIIGrid^.Grid[Row, Col, i]:3, ');');
    Close(F);
  End;

Procedure SaveAll;
  Var
    F : Text;
    i, j, R, C : Byte;
    k : Integer;
  Begin
    Assign(F, FontFile);
    Rewrite(F);
    WriteLn(F, 'Const');
    WriteLn(F, '  UserFont : Array[0..255, 0..15] Of Byte = (');
    For i := 0 To 255 Do
      Begin
        Write(F, '{', i:3, ' ');
{        If i >= 32 Then Write(F, Chr(i))
                   Else Write(F, ' ');{}
        Write(F, '} (');
        R := i Div ASCIIGrid^.Cols+1;
        C := i Mod ASCIIGrid^.Cols+1;
        For j := 1 To 16 Do
          If j < 16 Then Write(F, ASCIIGrid^.Grid[R, C, j]:3, ', ')
                    Else Write(F, ASCIIGrid^.Grid[R, C, j]:3, ')');
          If i < 255 Then WriteLn(F, ',')
                    Else WriteLn(F, ');');
      End;
    WriteLn(F);
    k := ASCIIGrid^.Rows*ASCIIGrid^.Cols-256;
    WriteLn(F, '  ExtUserFont : Array[0..', k-1, ', 0..15] Of Byte = (');
    For i := 0 To k-1 Do
      Begin
        Write(F, '{', i:3, '} (');
        R := (i+256) Div ASCIIGrid^.Cols+1;
        C := (i+256) Mod ASCIIGrid^.Cols+1;
        For j := 1 To 16 Do
          If j < 16 Then Write(F, ASCIIGrid^.Grid[R, C, j]:3, ', ')
                    Else Write(F, ASCIIGrid^.Grid[R, C, j]:3, ')');
          If i < k-1 Then WriteLn(F, ',')
                     Else WriteLn(F, ');');
      End;
    Close(F);
  End;

Procedure InitControls;
  Begin
    NewForm(FrmMain);
    With FrmMain^ Do
      Begin
        Caption := VNIConv('Chuwowng trifnh thieest kees font chuwx ' +
                           'cho chees ddooj vawn barn');
        Left := 50;
        Top := 110;
        Height := GetMaxY-Top*2;
        Width := GetMaxX-Left*2;
        FillColor := 7;
      End;
    With cmdClear Do
      Begin
        Top := FrmMain^.Top+FrmMain^.Height-40;
        Left := FrmMain^.Left+15;
        Caption := 'Clear';
        Width := 50;
        Color := 7;
      End;
    With cmdCopy Do
      Begin
        Top := FrmMain^.Top+FrmMain^.Height-40;
        Left := cmdClear.Left+cmdClear.Width+7;
        Caption := 'Copy';
        Width := 50;
        Color := 7;
      End;
    With cmdPaste Do
      Begin
        Top := FrmMain^.Top+FrmMain^.Height-40;
        Left := cmdCopy.Left+cmdCopy.Width+7;
        Caption := 'Paste';
        Width := 50;
        Color := 7;
      End;
    With cmdReset Do
      Begin
        Top := FrmMain^.Top+FrmMain^.Height-40;
        Left := cmdPaste.Left+cmdPaste.Width+7;
        Caption := 'Reset';
        Width := 50;
        Color := 7;
      End;
    With cmdResetAll Do
      Begin
        Top := FrmMain^.Top+FrmMain^.Height-40;
        Left := cmdReset.Left+cmdReset.Width+7;
        Caption := 'Reset all';
        Width := 50;
        Color := 7;
      End;
    With cmdLoad Do
      Begin
        Top := FrmMain^.Top+FrmMain^.Height-40;
        Left := cmdResetAll.Left+cmdResetAll.Width+7;
        Caption := 'Load';
        Width := 50;
        Color := 7;
      End;
    With cmdSave Do
      Begin
        Top := FrmMain^.Top+FrmMain^.Height-40;
        Left := cmdLoad.Left+cmdLoad.Width+7;
        Caption := 'Save';
        Width := 50;
        Color := 7;
      End;
    With cmdSaveAll Do
      Begin
        Top := FrmMain^.Top+FrmMain^.Height-40;
        Left := cmdSave.Left+cmdSave.Width+7;
        Caption := 'Save all';
        Width := 50;
        Color := 7;
      End;
    With cmdExit Do
      Begin
        Top := FrmMain^.Top+FrmMain^.Height-40;
        Left := cmdSaveAll.Left+cmdSaveAll.Width+7;
        Caption := 'Exit';
        Width := 50;
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
  End;

Procedure InitScreen;
  Var
    i : Integer;
  Begin
    FrmMain^.Show;
    cmdClear.ShowUp;
    cmdCopy.ShowUp;
    cmdPaste.ShowUp;
    cmdReset.ShowUp;
    cmdResetAll.ShowUp;
    cmdLoad.ShowUp;
    cmdSave.ShowUp;
    cmdSaveAll.ShowUp;
    cmdExit.ShowUp;
    ASCIIGrid^.ShowAll;
    Grid1^.Show;
    ShowIndex;
  End;

BEGIN
  If InitMouse = True Then
    Begin
      InitGraphMode('EGAVGA', 2);
      InitControls;
      InitScreen;
      ShowMouse;
      Repeat
        If Grid1^.IsClick Then ApplyASCII;
        If ASCIIGrid^.IsClick(Row, Col) Then ApplyGrid;
        If cmdClear.IsClick Then ClearGrid;
        If cmdCopy.IsClick Then CopyGrid;
        If cmdPaste.IsClick Then PasteGrid;
        If cmdReset.IsClick Then ResetASCIIChar;
        If cmdResetAll.IsClick Then ResetASCII;
        If cmdSave.IsClick Then SaveGrid;
        If cmdSaveAll.IsClick Then SaveAll;
        If IsKeyPressed And (KeyCode < $100)Then
        If KeyCode < $100 Then
          Begin
            KeyCode := GetKeyCode;
            KeyCode := Ord(Upcase(Chr(KeyCode)));
            Case Chr(KeyCode) Of
              'L' : ClearGrid;
              'C' : CopyGrid;
              'P' : PasteGrid;
              'R' : ResetASCIIChar;
              'A' : ResetASCII;
              'S' : SaveGrid;
            End;
          End;
      Until (KeyCode = kbEsc) Or (cmdExit.IsClick = True);
      Dispose(Grid1);
      Dispose(clbGrid);
      Dispose(FrmMain);
      CloseGraph;
    End
   Else
    WriteLn('This program required a mouse!');
END.