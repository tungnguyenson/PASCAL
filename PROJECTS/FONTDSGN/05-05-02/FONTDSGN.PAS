Program FONT_DESIGNER;
{2}
{3}
{
   Version 1.0
   Member of NST Software Family
   19/8/2000
}
{9}
Uses Graph, sgFont, spGraph, grMouse, CtrlObj, Keyboard, Global;

Type
  TCharDef = Array[0..15] Of Byte;

Const
  CharFile = 'charsave.pas';
  FontFile = 'fontsave.pas';

Var
  msx, msy : Integer;
  msButton : Byte;
  KeyCode : Word;
  Row, Col, LastCol, LastRow : Byte;

Procedure ShowIndex; Forward;
Procedure ApplyGrid; Forward;

{$I FontDsgn.Inc}

Procedure ShowIndex;
  Var
    i, x, y : Integer;
  Begin
    i := (Row-1)*ASCIIGrid^.Cols+Col-1;
    SetFillStyle(1, FrmMain^.FillColor);
    x := FrmMain^.Left+110;
    y := FrmMain^.Top+185;
    Bar(x, y, x+80, y+15);
    SetColor(0);
    PrintStr(x, y, VNIConv('Kys tuwj thuws: ')+StrConv(i));
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
        ApplyASCII;
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
    i, j : Word;
  Begin
    With ASCIIGrid^ Do
      For i := 0 To 319 Do
        For j := 1 To 16 Do
          If i < 256 Then
            Grid[i Div Cols+1, i Mod Cols+1, j] := StdTextFont[i, j-1]
           Else
            Grid[i Div Cols+1, i Mod Cols+1, j] := 0;
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
    i := (Row-1)*ASCIIGrid^.Cols+Col-1;
    Write(F, '{', StrConv(i):3, '} (');
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
        Write(F, '{', i:3);
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

Function AnalyzeCharArray(S : String; Var Result : TCharDef) : Boolean;
  Var
    I, P : Byte;
    J, Error : Integer;
  Begin
    If (S <> '')And(S[1] = '{')And(Copy(S, 5, 3) = '} (')And(S[Length(S)-1] = ')') Then
      Begin
        AnalyzeCharArray := True;
        S := Copy(S, 2, Length(S)-3);
        S := S+',';
        I := 0;
        Repeat
          P := Pos(',', S);
          If P <> 0 Then
            Begin
              Val(Copy(S, 1, P-1), J, Error);
              Delete(S, 1, P);
              If I <= 15 Then
                If J <= 255 Then Result[I] := J
                            Else AnalyzeCharArray := False;
              Inc(I);
            End;
        Until P = 0;
      End
     Else AnalyzeCharArray := False;
  End;

Procedure LoadSavedChar;
  Var
    F : Text;
    S1, S : String;
    Result : TCharDef;
    I, J : Word;
  Begin
    Assign(F, CharFile);
    {$I-}Reset(F);{$I+}
    S := '';
    I := 0;
    Repeat
      ReadLn(F, S1);
      If S1 <> '' Then S := S1;
    Until EOF(F);
    Close(F);
    If AnalyzeCharArray(S, Result) Then
      With ASCIIGRid^ Do
        For J := 1 To 16 Do
          Grid[Row, Col, j] := Result[J-1];
    ApplyGrid;
  End;

Procedure LoadAllSavedChars;
  Var
    F : Text;
    S1, S : String;
    Result : TCharDef;
    I, J : Word;
  Begin
    Assign(F, FontFile);
    {$I-}Reset(F);{$I+}
    S := '';
    I := 0;
    Repeat
      ReadLn(F, S);
      If AnalyzeCharArray(S, Result) Then
        Begin
          With ASCIIGrid^ Do
            For J := 1 To 16 Do
              Grid[i Div Cols+1, i Mod Cols+1, j] := Result[J-1];
          Inc(I);
        End;
    Until EOF(F);
    Close(F);
    ASCIIGrid^.ShowAll;
    ApplyGrid;
  End;

Procedure ShowAboutBox;
  Begin
    With FrmAbout^ Do
      Begin
        Show;
        cmdOK.Top := Top+Height-40;
        cmdOK.Left := Left+120;
        cmdOK.ShowUp;
        TxtAbout.Show;
        Repeat
        Until cmdOK.IsClick = True;
      End;
    InitScreen;
  End;

Procedure ShowHelpScreen;
  Begin
    With FrmHelp^ Do
      Begin
        Show;
        cmdClose.Top := Top+Height-40;
        cmdClose.Left := Left+Width-cmdClose.Width-20;
        PlaceButton(cmdNext, cmdClose, ToLeft);
        PlaceButton(cmdPrev, cmdNext, ToLeft);
        cmdPrev.ShowUp;
        cmdNext.ShowUp;
        cmdClose.ShowUp;
        txtHelp.Show;
        Repeat
          If cmdPrev.IsClick Then txtHelp.PrevPage;
          If cmdNext.IsClick Then txtHelp.NextPage;
        Until cmdClose.IsClick = True;
      End;
    InitScreen;
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
        If cmdLoad.IsClick Then LoadSavedChar;
        If cmdSave.IsClick Then SaveGrid;
        If cmdReset.IsClick Then ResetASCIIChar;
        If cmdLoadAll.IsClick Then LoadAllSavedChars;
        If cmdResetAll.IsClick Then ResetASCII;
        If cmdHelp.IsClick Then ShowHelpScreen;
        If cmdAbout.IsClick Then ShowAboutBox;
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
      Until (KeyCode = kbEsc) Or (cmdExit.IsClick = True);{}
      Dispose(Grid1);
      Dispose(clbGrid);
      Dispose(FrmAbout);
      Dispose(FrmHelp);
      Dispose(FrmMain);
      CloseGraph;
    End
   Else
    WriteLn('This program required a mouse!');
END.