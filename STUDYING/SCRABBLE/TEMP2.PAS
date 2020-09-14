  Procedure TScrabble.InitCharSet;
    Type
      TScbCharDefine = Record
        ChrLetter : Array['A'..'Z'] Of TCharDef;
        ChrBorder : Array[1..4] Of TCharDef;
        ChrQuestion : TCharDef;
      End;
    Const
      ScbCharDefine : TScbCharDefine = (
        ChrLetter : (
        {A} (  0,  0, 16, 56,108,198,198,254,198,198,198,198,  0,  0,  0,255),
        {B} (  0,  0,252,102,102,102,124,102,102,102,102,252,  0,  0,  0,255),
        {C} (  0,  0, 60,102,194,192,192,192,192,194,102, 60,  0,  0,  0,255),
        {D} (  0,  0,248,108,102,102,102,102,102,102,108,248,  0,  0,  0,255),
        {E} (  0,  0,254,102, 98,104,120,104, 96, 98,102,254,  0,  0,  0,255),
        {F} (  0,  0,254,102, 98,104,120,104, 96, 96, 96,240,  0,  0,  0,255),
        {G} (  0,  0, 60,102,194,192,192,222,198,198,102, 58,  0,  0,  0,255),
        {H} (  0,  0,198,198,198,198,254,198,198,198,198,198,  0,  0,  0,255),
        {I} (  0,  0, 60, 24, 24, 24, 24, 24, 24, 24, 24, 60,  0,  0,  0,255),
        {J} (  0,  0, 30, 12, 12, 12, 12, 12,204,204,204,120,  0,  0,  0,255),
        {K} (  0,  0,230,102,102,108,120,120,108,102,102,230,  0,  0,  0,255),
        {L} (  0,  0,240, 96, 96, 96, 96, 96, 96, 98,102,254,  0,  0,  0,255),
        {M} (  0,  0,198,238,254,254,214,198,198,198,198,198,  0,  0,  0,255),
        {N} (  0,  0,198,230,246,254,222,206,198,198,198,198,  0,  0,  0,255),
        {O} (  0,  0,124,198,198,198,198,198,198,198,198,124,  0,  0,  0,255),
        {P} (  0,  0,252,102,102,102,124, 96, 96, 96, 96,240,  0,  0,  0,255),
        {Q} (  0,  0,124,198,198,198,198,198,198,214,222,124, 12, 14,  0,255),
        {R} (  0,  0,252,102,102,102,124,108,102,102,102,230,  0,  0,  0,255),
        {S} (  0,  0,124,198,198, 96, 56, 12,  6,198,198,124,  0,  0,  0,255),
        {T} (  0,  0,126,126, 90, 24, 24, 24, 24, 24, 24, 60,  0,  0,  0,255),
        {U} (  0,  0,198,198,198,198,198,198,198,198,198,124,  0,  0,  0,255),
        {V} (  0,  0,198,198,198,198,198,198,198,108, 56, 16,  0,  0,  0,255),
        {W} (  0,  0,198,198,198,198,214,214,214,254,238,108,  0,  0,  0,255),
        {X} (  0,  0,198,198,108,124, 56, 56,124,108,198,198,  0,  0,  0,255),
        {Y} (  0,  0,102,102,102,102, 60, 24, 24, 24, 24, 60,  0,  0,  0,255),
        {Z} (  0,  0,254,198,134, 12, 24, 48, 96,194,198,254,  0,  0,  0,255));
        ChrBorder : (
        {1} (  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,255),
        {2} (255,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0),
        {3} (  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,255),
        {4} (192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,255));
        ChrQuestion :
        {?} (  0,  0,124,198,198, 12, 24, 24, 24,  0, 24, 24,  0,  0,  0,255)
      );

    Var
      i : Byte;
      C : Char;
    Begin
      For C := 'A' To 'Z' Do
        LoadChar(Ord(ScbCharSet.ChrLetter[C]),
                 Seg(ScbCharDefine.ChrLetter[C]),
                 Ofs(ScbCharDefine.ChrLetter[C]));
      For i := 1 To 4 Do
        LoadChar(Ord(ScbCharSet.ChrBorder[i]),
                 Seg(ScbCharDefine.ChrBorder[i]),
                 Ofs(ScbCharDefine.ChrBorder[i]));
      LoadChar(Ord(ScbCharSet.ChrQuestion),
               Seg(ScbCharDefine.ChrQuestion),
               Ofs(ScbCharDefine.ChrQuestion));
    End;

  Procedure TScbTable.Init;
    Begin
      Left := L;
      Top  := T;
      Color := ScbTableDefaultColor;
      FillChar(Cells, SizeOf(Cells), #0);
      FillChar(svCells, SizeOf(svCells), #0);
    End;

  Procedure TScbTable.DrawCell;
    Var
      St : String;
      bg : Byte;
      Letter : Char;
    Begin
      Letter := Cells[Row, Col];
      If Letter <> ScbNoLetter Then
        Begin
          St := ScbCharSet.ChrBorder[4]; { [ }
          If Letter <> ScbBlankLetter Then St := St+Chr(Ord(Letter)+127)
                                      Else St := St+ScbCharSet.ChrBorder[1]; { _ }
          If Col <> ScbTableSize Then St := St+ScbCharSet.ChrBorder[1]  { _ }
                                 Else St := St+ScbCharSet.ChrBorder[3]; { ] }
          OutStrAttr(Left+(Col-1)*3, Top+Row, St,
                     Color.ForeColor+Blink, Color.LetterColor);
        End
       Else
        Begin
          Case ScbMultiplier[Row, Col] Of
            0 : bg := Color.BackColor;
            1 : bg := 3;
            2 : bg := 1;
            3 : bg := 5;
            4 : bg := 4;
          End;
          If Col <> ScbTableSize Then
            OutStrAttr(Left+(Col-1)*3, Top+Row, #221#218#218,
                       Color.ForeColor, bg)
           Else
            OutStrAttr(Left+(Col-1)*3, Top+Row, #221#218#220,
                       Color.ForeColor, bg)
        End;
    End;

  Procedure TScbTable.DrawNewCell;
    Var
      St : String;
      bg : Byte;
      Letter : Char;
    Begin
      Letter := Cells[Row, Col];
      St := ScbCharSet.ChrBorder[4]; { [ }
      If Letter <> ScbBlankLetter Then St := St+Chr(Ord(Letter)+127)
                                  Else St := St+ScbCharSet.ChrBorder[1]; { _ }
      If Col <> ScbTableSize Then St := St+ScbCharSet.ChrBorder[1]  { _ }
                             Else St := St+ScbCharSet.ChrBorder[3]; { ] }
      OutStrAttr(Left+(Col-1)*3, Top+Row, St,
                 Color.ForeColor+Blink, Color.NewLetterColor);
    End;

  Procedure TScbTable.Show;
    Var
      X, Y : Byte;
    Begin
      SetCharAttr(Color.ForeColor, 0);
      OutStr(Left, Top,    'ÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚ');
      SetCharAttr(Color.ForeColor, Color.BackColor);
      OutStr(Left, Top+1,  'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+2,  'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+3,  'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+4,  'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+5,  'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+6,  'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+7,  'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+8,  'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+9,  'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+10, 'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+11, 'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+12, 'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+13, 'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+14, 'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
      OutStr(Left, Top+15, 'ÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÚÝÚÜ');
{      SetCharAttr(8, 0);
      OutStr(Left+1, Top+16, 'ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß');
      SetCharAttr(Blink, 8);
      OutChar(Left+45, Top+1, 'ß');
      For Y := 2 To 15 Do
        OutChar(Left+45, Top+Y, ' ');{}
      { Draw multiplier cells }
      For Y := 1 To ScbTableSize Do
        For X := 1 To ScbTableSize Do
          If ScbMultiplier[Y, X] > 0 Then
            DrawCell(Y, X);
    End;

  Procedure TScbTable.Refresh;
    Var
      X, Y : Byte;
    Begin
      For Y := 1 To ScbTableSize Do
        For X := 1 To ScbTableSize Do
          If Cells[Y, X] <> svCells[Y, X] Then
            Begin
              svCells[Y, X] := Cells[Y, X];
              DrawCell(Y, X);
            End;
    End;

  Procedure TScrabble.InitPlayer;
    Var
      X, Y : Byte;
      i : Byte;
      KeyChar : Char;
      KeyCode : Word;
      Msg : String;
      Name : String;
      OK : Boolean;
    Begin
      If NumberOfPlayers <> 0 Then Exit;{}
      Y := 18;
      SetCharAttr(Color.ForeColor, Color.BackColor);
      Msg := 'How many player do you want to play? ';
      OutStr(0, Y, Msg);
      X := Length(Msg);
      SetCursorPos(X, Y);
      StatusBar := 'Press ''1''..''4'' or Esc to exit';
      ShowStatusBar;
      NumberOfPlayers := 0;
      Repeat
        GetKeyboardEvent(KeyChar, KeyCode);
        If KeyChar in ['1'..'4'] Then
          Begin
            NumberOfPlayers := Ord(KeyChar)-48;
            OutStr(X, Y, KeyChar);
          End
         Else If KeyCode = kbEsc Then
          GameExit := True;
      Until GameExit Or (NumberOfPlayers <> 0);
      If Not GameExit Then
        For i := 1 To NumberOfPlayers Do
          Begin
            StatusBar := 'Type player''s name (empty name = computer)';
            ShowStatusBar;
            Inc(Y);
            SetCharAttr(Color.ForeColor, Color.BackColor);
            Msg := '  Player '+Chr(i+48)+': ';
            X := Length(Msg);
            OutStr(0, Y, Msg);
            SetCursorPos(X, Y);
            ReadLn(Name);
            If Name <> '' Then
              Begin
                Player[i].Name := Name;
                Player[i].Controller := ctlHuman;
              End
             Else
              Begin
                Player[i].Name := 'Computer';
                Player[i].Controller := ctlComputer;
              End;
            Player[i].ShowStatus(False);
          End;
      If Not GameExit Then
        Begin
          StatusBar := 'Press any key to continue...';
          SetCursorPos(Length(StatusBar), 24);
          ShowStatusBar;
          GetKeyboardEvent(KeyChar, KeyCode);
          HideCursor;
        End;
    End;

  Procedure TPlayer.ShowStatus;
    Var
      FG, BG : Byte;
      S : String;
      i : Byte;
      Letter : Char;
    Begin
      If Active Then
        Begin
          FG := Color.PlayerActiveFG;
          BG := Color.PlayerActiveBG;
        End
       Else
        Begin
          FG := Color.PlayerPassiveFG;
          BG := Color.PlayerPassiveBG;
        End;
      ClearWindow(Left, Top, 79, Top+2, BG);
      SetCharAttr(FG, BG);
      OutStr(Left+1, Top, 'Player '+Chr(Index+48)+' ('+Name+')');
      Str(Score, S);
      OutStr(Left+1, Top+1, '  Score   : '+S);
      OutStr(Left+1, Top+2, '  Letters : '+S);
      For i := 1 To 7 Do
        With ScbCharSet Do
          Begin
            If Length(Letters) < i Then Letter := ScbNoLetter
                                   Else Letter := Letters[i];
            S := ChrBorder[1];
            If Letter = ScbNoLetter Then
              S := S+ChrBorder[1]
             Else If Letter = ScbBlankLetter Then
              S := S+ChrQuestion
             Else S := S+Chr(Ord(Letter)+127);
            S := S+ChrBorder[3];
            OutStr(Left+13+(i-1)*3, Top+2, S);
          End;
    End;

  Procedure TScrabble.ShowTitleBar;
    Begin
      While Length(TitleBar) < 80 Do
        Begin
          TitleBar := TitleBar+' ';
          If Length(TitleBar) < 80 Then TitleBar := ' '+TitleBar;
        End;
      OutStrAttr(0, 0, TitleBar, Color.TitleBarFG, Color.TitleBarBG);
    End;

  Procedure TScrabble.ShowStatusBar;
    Begin
      While Length(StatusBar) < 80 Do StatusBar := StatusBar+' ';
      OutStrAttr(0, 24, StatusBar, Color.StatusBarFG, Color.StatusBarBG);
    End;

  Procedure TScrabble.Done;
    Begin
      ClearWindow(0, 0, 79, 24, 0);
      VGAFont;
    End;

  Procedure TPlayer.Init;
    Begin
      Letters := '';
      Score := 0;
    End;

  Procedure TScrabble.ShowPlayerStatus;
    Var
      i : Byte;
    Begin
      For i := 1 To NumberOfPlayers Do
        If PlayerTurn = i Then Player[i].ShowStatus(True)
                          Else Player[i].ShowStatus(False);
    End;

  Procedure TScrabble.Refresh;
    Begin
      Table.Refresh;
      ShowPlayerStatus;
      ShowLetterAvail;
      ShowLetterScore;
      ShowTitleBar;
      ShowStatusBar;
    End;

  Procedure TScrabble.ShowLetterAvail;
    Var
      X, Y : Byte;
      i, j : Byte;
      Ch : Char;
    Begin
      X := 40;
      Y := 17;
      SetCharAttr(7, 0);
      OutStr(X, Y  , 'Letter avail:');
      SetCharAttr(15, 0);
      OutStr(X+2, Y+1, 'A    B    C    D    E    F    G  ');
      OutStr(X+2, Y+2, 'H    I    J    K    L    M    N  ');
      OutStr(X+2, Y+3, 'O    P    Q    R    S    T    U  ');
      OutStr(X+2, Y+4, 'V    W    X    Y    Z     Blank-0');
      SetCharAttr(7, 0);
      For i := 1 To 4 Do
        For j := 1 To 7 Do
          If (i <> 4)Or(j <> 6) Then
            OutChar(X+3+(j-1)*5, Y+i, '-');
      SetCharAttr(15, 0);
      For Ch := 'A' To 'Z' Do
        Begin
          i := (Ord(Ch)-65) Div 7;
          j := (Ord(Ch)-65) Mod 7;
          OutByte(X+4+j*5, Y+i+1, LetterCount[Ch]);
        End;
      OutByte(X+4+6*5, Y+3+1, BlankCount);
    End;

  Procedure TScrabble.ShowLetterScore;
    Var
      X, Y : Byte;
      i, j : Byte;
    Begin
      X := 0;
      Y := 17;
      SetCharAttr(7, 0);
      OutStr(X, Y  , 'Letter score:');
      SetCharAttr(15, 0);
      OutStr(X+2, Y+1, 'A-1  B-3  C-3  D-2  E-1  F-4  G-2');
      OutStr(X+2, Y+2, 'H-4  I-1  J-8  K-5  L-1  M-3  N-1');
      OutStr(X+2, Y+3, 'O-1  P-3  Q-10 R-1  S-1  T-1  U-1');
      OutStr(X+2, Y+4, 'V-4  W-4  X-8  Y-4  Z-10  Blank-0');
      SetCharAttr(7, 0);
      For i := 1 To 4 Do
        For j := 1 To 7 Do
          If (i <> 4)Or(j <> 6) Then
            OutChar(X+3+(j-1)*5, Y+i, '-');
    End;
    {
1 A E I L N O R S T U
2 D G
3 B C M P
4 F H V W Y
5 K
8 J X
10 Q Z
    }
