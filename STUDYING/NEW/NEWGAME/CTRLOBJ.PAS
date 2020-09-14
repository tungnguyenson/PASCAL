Unit CtrlObj;

Interface

  Const
    MaxHoriz = 80;
    MaxVert = 25;

  Type
    TTetris = Object
      Left, Top, Height, Width : Byte;
      BackColor, ForeColor, BorderColor : Byte;
      Grid : Array[1..MaxVert, 1..MaxHoriz] Of Byte;
      Level : Byte;
      Procedure Show;
      Procedure ShowGrid(Y, X : Byte);
      Procedure Init(HLevel : Byte);
      Procedure CenterScreen;
      Procedure AniHide1;
      Procedure AniShow1;
      Procedure AniHide2;
      Procedure AniShow2;
      Procedure AniHide3;
      Procedure AniShow3;
      Procedure AnimateHide(Style : Byte);
      Procedure AnimateShow(Style : Byte);
    End;

Implementation

  Uses CRT, Blocks;

  Procedure TTetris.Init;
    Var
      i, j : Byte;
    Begin
      Randomize;
      FillChar(Grid, SizeOf(Grid), 0);
      For i := Height DownTo Height-HLevel+1 Do
        For j := 1 To Width Do
          Grid[i, j] := Random(2);
    End;

  Procedure TTetris.ShowGrid;
    Begin
      If Grid[Y, X] = 0 Then DrawBlock(Left+(X-1)*2, Top+(Y-1), BackColor)
                        Else DrawBlock(Left+(X-1)*2, Top+(Y-1), ForeColor);
    End;

  Procedure TTetris.Show;
    Var
      i, j : Byte;
    Begin
      For i := 1 To Height Do
        For j := 1 To Width Do
          ShowGrid(i, j);
    End;

  Procedure TTetris.CenterScreen;
    Begin
      Left := (80-Width) Div 2;
      Top := (25-Height) Div 2;
      Show;
    End;

  Procedure TTetris.AniHide1;
    Var
      i, j, k : Byte;
    Begin
      k := Height Div 2;
      If k*2 < Height Then k := k+1;
      For i := 1 To k Do
        Begin
          For j := 1 To Width Do
            DrawBlock(Left+(j-1)*2, Top+(i-1), Level);
          For j := 1 To Width Do
            DrawBlock(Left+(j-1)*2, Top+(Height-i), Level);
          Delay(20);
        End;
    End;

  Procedure TTetris.AniShow1;
    Var
      i, j, k : Byte;
    Begin
      k := Height Div 2;
      If k*2 < Height Then k := k+1;
      For i := k DownTo 1 Do
        Begin
          For j := 1 To Width Do
            ShowGrid(i, j);
          For j := 1 To Width Do
            ShowGrid(Height-i+1, j);
          Delay(20);
        End;
    End;

  Procedure TTetris.AniHide2;
    Var
      i, j, k : Byte;
    Begin
      k := Width Div 2;
      If k*2 < Width Then k := k+1;
      For j := 1 To k Do
        Begin
          For i := 1 To Height Do
            DrawBlock(Left+(j-1)*2, Top+(i-1), Level);
          For i := 1 To Height Do
            DrawBlock(Left+(Width-j)*2, Top+(i-1), Level);
          Delay(20);
        End;
    End;

  Procedure TTetris.AniShow2;
    Var
      i, j, k : Byte;
    Begin
      k := Width Div 2;
      If k*2 < Width Then k := k+1;
      For j := k DownTo 1 Do
        Begin
          For i := 1 To Height Do
            ShowGrid(i, j);
          For i := 1 To Height Do
            ShowGrid(i, Width-j+1);
          Delay(20);
        End;
    End;

  Procedure TTetris.AniHide3;
    Var
      i, j : Byte;
    Begin
      For j := 1 To Width Do
        Begin
          For i := 1 To Height Do
            If i Mod 2 = 0 Then
              DrawBlock(Left+(j-1)*2, Top+(i-1), Level)
             Else
              DrawBlock(Left+(Width-j)*2, Top+(i-1), Level);
          Delay(20);
        End;
    End;

  Procedure TTetris.AniShow3;
    Var
      i, j : Byte;
    Begin
      For j := Width DownTo 1 Do
        Begin
          For i := 1 To Height Do
            If i Mod 2 = 0 Then ShowGrid(i, j)
                           Else ShowGrid(i, Width-j+1);
          Delay(20);
        End;
    End;

  Procedure TTetris.AnimateHide;
    Begin
      Case Style Of
        1 : AniHide1;
        2 : AniHide2;
        3 : AniHide3;
       Else AniHide1;
      End;
    End;

  Procedure TTetris.AnimateShow;
    Begin
      Case Style Of
        1 : AniShow1;
        2 : AniShow2;
        3 : AniShow3;
       Else AniShow1;
      End;
    End;

END.