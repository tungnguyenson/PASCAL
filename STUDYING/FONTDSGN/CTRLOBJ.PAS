Unit CtrlObj;

Interface

  Const
    ButtonHeight = 23;

  Type

    TDesktop = Object
      BackColor : Byte;
      Procedure Show;
    End;

    PForm = ^TForm;
    TForm = Object
      Left, Top, Height, Width : Integer;
      Caption : String;
      FullScreen : Boolean;
      ForeColor, BackColor, FillColor : Byte;
      Procedure Show;
    End;

    PCommandButton = ^TCommandButton;
    TCommandButton = Object
      Top, Left, Width : Integer;
      Caption : String;
      Color : Byte;
      Procedure ShowUp;
      Procedure ShowDown;
      Function IsClick : Boolean;
    End;

    PCharGrid = ^TCharGrid;
    TCharGrid = Object
      Left, Top : Integer;
      Rows, Cols : Byte;
      Distance : Byte;
      PrvLeft, PrvTop : Integer;
      PrvFillColor, PrvEmptyColor, PrvBorderColor : Byte;
      FillColor, EmptyColor, BorderColor : Byte;
      Grid : Array[1..100, 1..100] Of Byte;
      Procedure Show;
      Procedure ShowPreview;
      Function IsClick : Boolean;
    End;

    PASCIIGrid = ^TASCIIGrid;
    TASCIIGrid = Object
      Left, Top : Integer;
      Rows, Cols : Byte;
      FillColor, EmptyColor, BorderColor : Byte;
      Grid : Array[1..8, 1..40, 1..16] Of Byte;
      Procedure InitFont;
      Procedure ShowChar(Row, Col : Byte);
      Procedure ShowAll;
      Function IsClick(Var Row, Col : Byte) : Boolean;{}
    End;

  Procedure NewForm(Var Form : PForm);

Implementation

  Uses Graph, grMouse, sgFont, TextFont;

  Procedure TDesktop.Show;
    Begin
      SetFillStyle(1, BackColor);
      Bar(0, 0, GetMaxX, GetMaxY);
    End;

  Procedure TForm.Show;
    Var
      Right, Bottom : Integer;
    Begin
      SetFontStyle(fsBold);
      If FullScreen Then
        Begin
          Left := 0;
          Top := 0;
          Width := GetMaxX+1;
          Height := GetMaxY+1;
          Right := Left+Width-1;
          Bottom := Top+Height-1;
          SetFillStyle(1, FillColor);
          Bar(Left, Top, Right, Bottom);
          SetFillStyle(1, BackColor);
          Bar(Left, Top, Right, Top+17);
          SetColor(ForeColor);
          PrintStr(Left+7, Top+2, VNIConv(Caption));
        End
       Else
        Begin
          Right := Left+Width-1;
          Bottom := Top+Height-1;
          SetFillStyle(1, FillColor);
          Bar(Left, Top, Right, Bottom);
          SetColor(15);
          Line(Left, Top, Right, Top);
          Line(Left, Top, Left, Bottom);
          Line(Left+1, Top+1, Right-2, Top+1);
          Line(Left+1, Top+1, Left+1, Bottom-2);
          SetColor(8);
          Line(Right-1, Top+1, Right-1, Bottom-1);
          Line(Left+1, Bottom-1, Right-1, Bottom-1);
          Line(Right, Top, Right, Bottom);
          Line(Left, Bottom, Right, Bottom);
          SetFillStyle(1, BackColor);
          Bar(Left+4, Top+4, Right-4, Top+4+16);
          SetColor(ForeColor);
          PrintStr(Left+7, Top+5, Caption);
        End;
      SetFontStyle(fsRegular);
    End;

  Procedure NewForm;
    Begin
      New(Form);
      Form^.Top := GetMaxY Div 4;
      Form^.Left := GetMaxX Div 4;
      Form^.Height := GetMaxY Div 2;
      Form^.Width := GetMaxX Div 2;
      Form^.Caption := 'Untitle';
      Form^.FullScreen := False;
      Form^.ForeColor := 15;
      Form^.BackColor := 1;
      Form^.FillColor := 7;
    End;

  Procedure TCommandButton.ShowUp;
    Var
      Len, Bottom, Right : Integer;
      i : Byte;
    Begin
      Bottom := Top+ButtonHeight-1;
      Right := Left+Width-1;
      SetColor(15);
      Line(Left, Top, Right-1, Top);
      Line(Left, Top, Left, Bottom-1);
      SetColor(8);
      Line(Left+1, Bottom-1, Right-1, Bottom-1);
      Line(Right-1, Top+1, Right-1, Bottom-1);
      SetColor(0);
      Line(Left, Bottom, Right, Bottom);
      Line(Right, Top, Right, Bottom);
      SetFillStyle(1, Color);
      Bar(Left+1, Top+1, Right-2, Bottom-2);
      Len := 0;
      For i := 1 To Length(Caption) Do
        If Caption[i] = ' ' Then Len := Len+3
                            Else Len := Len+CurFont^.Width[Ord(Caption[i])]+1;
      SetColor(0);
      PrintStr(Left+(Width-Len) Div 2, Top+3, Caption);
    End;

  Procedure TCommandButton.ShowDown;
    Var
      Len, Bottom, Right : Integer;
      i : Byte;
    Begin
      Bottom := Top+ButtonHeight-1;
      Right := Left+Width-1;
      SetColor(0);
      Line(Left, Top, Right-1, Top);
      Line(Left, Top, Left, Bottom-1);
      SetColor(8);
      Line(Left+1, Top+1, Right-2, Top+1);
      Line(Left+1, Top+1, Left+1, Bottom-2);
      SetColor(0);
      Line(Left, Bottom, Right, Bottom);
      Line(Right, Top, Right, Bottom);
      SetFillStyle(1, Color);
      Bar(Left+2, Top+2, Right-1, Bottom-1);
      Len := 0;
      For i := 1 To Length(Caption) Do
        If Caption[i] = ' ' Then Len := Len+3
                            Else Len := Len+CurFont^.Width[Ord(Caption[i])]+1;
      SetColor(0);
      PrintStr(Left+(Width-Len) Div 2+1, Top+4, Caption);
    End;

  Function TCommandButton.IsClick;
    Var
      msx, msy, Right, Bottom : Integer;
      msButton : Byte;
    Begin
      IsClick := False;
      GetMouseStatus(msx, msy, msButton);
      Bottom := Top+ButtonHeight-1;
      Right := Left+Width-1;
      If (msx > Left)And(msx < Right)And(msy > Top)And(msy < Bottom)And
         (msButton = msLeftButton) Then
        Begin
          HideMouse;
          ShowDown;
          ShowMouse;
          Repeat
            GetMouseStatus(msx, msy, msButton);
          Until msButton = msNoButton;
          HideMouse;
          ShowUp;
          ShowMouse;
          IsClick := True
        End
       Else IsClick := False;
    End;

  Procedure TCharGrid.ShowPreview;
    Var
      i, j, PrvColor : Byte;
      x, y : Integer;
    Begin
      HideMouse;
      SetColor(PrvBorderColor);
      Rectangle(PrvLeft, PrvTop, PrvLeft+Cols+1, PrvTop+Rows+1);
      For i := 1 To Rows Do
        For j := 1 To Cols Do
          If Grid[i, j] <> 0 Then
            PutPixel(PrvLeft+j, PrvTop+i, PrvFillColor)
           Else
            PutPixel(PrvLeft+j, PrvTop+i, PrvEmptyColor);
      ShowMouse;
    End;

  Procedure TCharGrid.Show;
    Var
      i, j : Byte;
      x, y : Integer;
    Begin
      HideMouse;
      For i := 1 To Rows Do
        For j := 1 To Cols Do
          Begin
            x := Left+(j-1)*Distance;
            y := Top+(i-1)*Distance;
            SetColor(BorderColor);
            Rectangle(x, y, x+Distance, y+Distance);
            If Grid[i, j] <> 0 Then SetFillStyle(1, FillColor)
                               Else SetFillStyle(1, EmptyColor);
            Bar(x+1, y+1, x+Distance-1, y+Distance-1);
          End;
      ShowPreview;
      ShowMouse;
    End;

  Function TCharGrid.IsClick;
    Var
      msx, msy, x, y : Integer;
      msButton, Row, Col : Byte;
      Right, Bottom : Integer;
    Begin
      IsClick := False;
      Bottom := Top+Rows*Distance;
      Right := Left+Cols*Distance;
      GetMouseStatus(msx, msy, msButton);
      If (msx > Left)And(msx < Right)And(msy > Top)And(msy < Bottom) Then
        If ((msy-Top)Mod Distance <> 0)And((msx-Left)Mod Distance <> 0) Then
          If msButton = msLeftButton Then
            Begin
              SetMouseLimit(Left+1, Top+1, Right-1, Bottom-1);
              Repeat
                Row := (msy-Top) Div Distance+1;
                Col := (msx-Left) Div Distance+1;
                If Grid[Row, Col] = 0 Then
                  Begin
                    HideMouse;
                    Grid[Row, Col] := 1;
                    x := Left+(Col-1)*Distance;
                    y := Top+(Row-1)*Distance;
                    SetFillStyle(1, FillColor);
                    Bar(x+1, y+1, x+Distance-1, y+Distance-1);
                    PutPixel(PrvLeft+Col, PrvTop+Row, PrvFillColor);
                    ShowMouse;
                  End;
                GetMouseStatus(msx, msy, msButton);
              Until msButton = msNoButton;
              IsClick := True;
              SetMouseLimit(0, 0, GetMaxX, GetMaxY);
            End
          Else If msButton = msRightButton Then
            Begin
              SetMouseLimit(Left+1, Top+1, Right-1, Bottom-1);
              Repeat
                Row := (msy-Top) Div Distance+1;
                Col := (msx-Left) Div Distance+1;
                If Grid[Row, Col] = 1 Then
                  Begin
                    HideMouse;
                    Grid[Row, Col] := 0;
                    x := Left+(Col-1)*Distance;
                    y := Top+(Row-1)*Distance;
                    SetFillStyle(1, EmptyColor);
                    Bar(x+1, y+1, x+Distance-1, y+Distance-1);
                    PutPixel(PrvLeft+Col, PrvTop+Row, PrvEmptyColor);
                    ShowMouse;
                  End;
                GetMouseStatus(msx, msy, msButton);
              Until msButton = msNoButton;
              IsClick := True;
              SetMouseLimit(0, 0, GetMaxX, GetMaxY);
            End
    End;

  Procedure TASCIIGrid.InitFont;
    Var
      i, j : Integer;
    Begin
      FillChar(Grid, SizeOf(Grid), 0);
      For i := 0 To 255 Do
        For j := 1 To 16 Do
          Grid[i Div Cols+1, i Mod Cols+1, j] := StdTextFont[i, j-1]
    End;

  Procedure TASCIIGrid.ShowChar;
    Var
      i, j, L, T : Integer;
    Begin
      HideMouse;
      L := Left+(Col-1)*9;
      T := Top+(Row-1)*17;
      SetColor(BorderColor);
      Rectangle(L, T, L+9, T+17);
      For i := 1 To 16 Do
        For j := 7 DownTo 0 Do
          If Grid[Row, Col, i] And (1 Shl j) <> 0 Then
            PutPixel(L+8-j, T+i, FillColor)
           Else
            PutPixel(L+8-j, T+i, EmptyColor);
      ShowMouse;
    End;

  Procedure TASCIIGrid.ShowAll;
    Var
      i, j, k, l : Integer;
    Begin
      HideMouse;
      SetFillStyle(1, BorderColor);
      Bar(Left, Top, Left+40*9, Top+8*17);
      For i := 1 To 8 Do
        For j := 1 To 40 Do
          For k := 1 To 16 Do
            For l := 7 DownTo 0 Do
              If Grid[i, j, k] And (1 Shl l) <> 0 Then
                PutPixel(Left+(j-1)*9+(8-l), Top+(i-1)*17+k, FillColor)
               Else
                PutPixel(Left+(j-1)*9+(8-l), Top+(i-1)*17+k, EmptyColor);
      ShowMouse;
    End;

  Function TASCIIGrid.IsClick;
    Var
      msx, msy, x, y : Integer;
      msButton : Byte;
      Right, Bottom : Integer;
    Begin
      IsClick := False;
      Bottom := Top+Rows*17;
      Right := Left+Cols*9;
      GetMouseStatus(msx, msy, msButton);
      If (msx > Left)And(msx < Right)And(msy > Top)And(msy < Bottom) Then
        If ((msy-Top)Mod 17 <> 0)And((msx-Left)Mod 9 <> 0) Then
          If msButton = msLeftButton Then
            Begin
              SetMouseLimit(Left+1, Top+1, Right-1, Bottom-1);
              Repeat
                GetMouseStatus(msx, msy, msButton);
              Until msButton = msNoButton;
              Row := (msy-Top) Div 17+1;
              Col := (msx-Left) Div 9+1;
              IsClick := True;
              SetMouseLimit(0, 0, GetMaxX, GetMaxY);
            End
    End;

End.