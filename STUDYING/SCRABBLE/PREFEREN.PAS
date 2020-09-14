Procedure ShowTitleBar(St : String);
  Begin
    TextColor(15);
    TextBackGround(1);
    GoToXY(1, 1);
    ClrEOL;
    GoToXY(28, 1);
    Write(St);
  End;

Procedure ShowStatusBar(St : String);
  Begin
    TextColor(15);
    TextBackGround(1);
    GoToXY(1, 25);
    ClrEOL;
    Write(St);
  End;

Procedure ShowLetterScore;
  Var
    x, y : Byte;
  Begin
    x := 0;
    y := 17;
    SetCharAttr(7, 0);
    OutStr(x, y  , 'Letter Score:');
    OutStr(x+2, y+1, 'A-1  B-3  C-3  D-2  E-1  F-4  G-2');
    OutStr(x+2, y+2, 'H-4  I-1  J-8  K-5  L-1  M-3  N-1');
    OutStr(x+2, y+3, 'O-1  P-3  Q-10 R-1  S-1  T-1  U-1');
    OutStr(x+2, y+4, 'V-4  W-4  X-8  Y-4  Z-10 Blank-0 ');
    {
1 A E I L N O R S T U
2 D G
3 B C M P
4 F H V W Y
5 K
8 J X
10 Q Z
    }
  End;

Procedure ShowCell(Row, Col : Byte);
  Var
    St : String;
    bg : Byte;
    Letter : Char;
  Begin
    Letter := Board[Row, Col];
    If Letter <> NoLetter Then
      Begin
        St := #221;
        If Letter <> BlankLetter Then St := St+Chr(Ord(Letter)+127)
                                 Else St := St+#218;
        If Col <> Cols Then St := St+#218
                       Else St := St+#220;
        OutStrAttr(Left+(Col-1)*3, Top+Row, St, ForeColor+Blink, LetterColor);
      End
     Else
      Begin
        Case Mask[Row, Col] Of
          0 : bg := BackColor;
          1 : bg := 3;
          2 : bg := 1;
          3 : bg := 5;
          4 : bg := 4;
        End;
        If Col <> Cols Then
          OutStrAttr(Left+(Col-1)*3, Top+Row, #221#218#218, ForeColor, bg)
         Else
          OutStrAttr(Left+(Col-1)*3, Top+Row, #221#218#220, ForeColor, bg)
      End;
  End;

Procedure ShowNewCell(Row, Col : Byte);
  Var
    St : String;
    Letter : Char;
  Begin
    Letter := Board[Row, Col];
    If Letter <> NoLetter Then
      Begin
        St := #221;
        If Letter <> BlankLetter Then St := St+Chr(Ord(Letter)+127)
                                 Else St := St+#218;
        If Col <> Cols Then St := St+#218
                       Else St := St+#220;
        OutStrAttr(Left+(Col-1)*3, Top+Row, St, ForeColor+Blink, NewLetterColor);
      End;
  End;

Procedure ShowScreen;
  Var
    i, j, bg : Byte;
    St : String;
  Begin
    ClearWindow(1, 2, 80, 24, 0);
    SetCharAttr(ForeColor, 0);
    OutStr(Left, Top,    'ккккккккккккккккккккккккккккккккккккккккккккк');
    SetCharAttr(ForeColor, BackColor);
    OutStr(Left, Top+1,  'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+2,  'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+3,  'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+4,  'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+5,  'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+6,  'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+7,  'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+8,  'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+9,  'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+10, 'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+11, 'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+12, 'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+13, 'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+14, 'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    OutStr(Left, Top+15, 'нккнккнккнккнккнккнккнккнккнккнккнккнккнккнкм');
    SetCharAttr(ForeColor, 0);
    OutStr(Left, Top+16, '                                                 ');
    For i := 1 To Rows Do
      For j := 1 To Cols Do
        If Board[i, j] <> NoLetter Then
          Begin
            St := #221;
            If Board[i, j] <> BlankLetter Then St := St+Chr(Ord(Board[i, j])+127)
                                          Else St := St+#218;
            If j <> Cols Then St := St+#218
                         Else St := St+#220;
            OutStrAttr(Left+(j-1)*3, Top+i, St, ForeColor+Blink, LetterColor);
          End
         Else
          Begin
            Case Mask[i, j] Of
              0 : bg := BackColor;
              1 : bg := 3;
              2 : bg := 1;
              3 : bg := 5;
              4 : bg := 4;
            End;
            If j <> Cols Then
              OutStrAttr(Left+(j-1)*3, Top+i, #221#218#218, ForeColor, bg)
             Else
              OutStrAttr(Left+(j-1)*3, Top+i, #221#218#220, ForeColor, bg)
          End;
    ShowLetterScore;
    ShowStatusBar('Esc : Abort game');
    For i := 1 To NumberOfPlayers Do
      Player[i].ShowStatus(Passive);
  End;