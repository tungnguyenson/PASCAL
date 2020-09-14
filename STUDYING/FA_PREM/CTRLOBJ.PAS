Unit CtrlObj;

Interface

  Const
    ButtonHeight = 23;

  Type

    T3DStyle = (Raised, Sunken);

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
      Top, Left, Width, Height : Integer;
      Caption : String;
{      Selected : Boolean;{}
      Enabled : Boolean;
      ForeColor, BackColor : Byte;
      FontBold : Boolean;
      Procedure ShowUp;
      Procedure ShowDown;
      Function IsClick : Boolean;
    End;

    TTextBox = Object
      Left, Top, Width : Integer;
      Txt : String;
      FontBold : Boolean;
      MaxLength : Byte;
      ForeColor, BackColor : Byte;
      Procedure Show;
      Procedure KeyPress;
      Procedure GotFocus;
    End;

    TAlignment = (LeftJustify, RightJustify, AlignCenter);
    PLabel = ^TLabel;
    TLabel = Object
      Left, Top, Width : Integer;
      Alignment : TAlignment;
      Caption : String;
      FontBold : Boolean;
      BackColor, ForeColor : Byte;
      Procedure Show;
    End;

  Var
    Desktop : TDesktop;

  Procedure Draw3DEffect(Left, Top, Right, Bottom : Integer;
                         BackColor : Byte; Style : T3DStyle);

  Procedure NewForm(Var Form : PForm);
  Procedure NewCButton(Var Button : PCommandButton);
  Procedure NewLabel(Var Lbl : PLabel);

Implementation

  Uses Graph, grMouse, sgFont, Keyboard;

  Procedure Draw3DEffect;
    Begin
      SetFillStyle(1, BackColor);
      Bar(Left, Top, Right, Bottom);
      Case Style Of
        Raised :
          Begin
            SetColor((BackColor Mod 8)+8);
            Line(Left, Top, Right, Top);
            Line(Left, Top, Left, Bottom);
            Line(Left+1, Top+1, Right-2, Top+1);
            Line(Left+1, Top+1, Left+1, Bottom-2);
            SetColor(8);
            Line(Right-1, Top+1, Right-1, Bottom-1);
            Line(Left+1, Bottom-1, Right-1, Bottom-1);
            SetColor(0);
            Line(Right, Top, Right, Bottom);
            Line(Left, Bottom, Right, Bottom);
          End;
        Sunken :
          Begin
            SetColor(8);
            Line(Left, Top, Right, Top);
            Line(Left, Top, Left, Bottom);
            SetColor(0);
            Line(Left+1, Top+1, Right-2, Top+1);
            Line(Left+1, Top+1, Left+1, Bottom-2);
            SetColor((BackColor Mod 8)+8);
            Line(Right-1, Top+1, Right-1, Bottom-1);
            Line(Left+1, Bottom-1, Right-1, Bottom-1);
            Line(Right, Top, Right, Bottom);
            Line(Left, Bottom, Right, Bottom);
          End;
      End;
    End;

  Procedure TDesktop.Show;
    Begin
      SetFillStyle(1, BackColor);
      Bar(0, 0, GetMaxX, GetMaxY);
    End;

  Procedure TForm.Show;
    Var
      Right, Bottom : Integer;
    Begin
      HideMouse;
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
          PrintStr(Left+7, Top+2, Caption);
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
      ShowMouse;
    End;

  Procedure NewForm;
    Begin
      New(Form);
      With Form^ Do
        Begin
          Top := GetMaxY Div 4;
          Left := GetMaxX Div 4;
          Height := GetMaxY Div 2;
          Width := GetMaxX Div 2;
          Caption := 'Untitle';
          FullScreen := False;
          ForeColor := 15;
          BackColor := 1;
          FillColor := 7;
        End;
    End;

  Procedure TCommandButton.ShowUp;
    Var
      Bottom, Right, y : Integer;
      i : Byte;
    Begin
      HideMouse;
      Bottom := Top+Height-1;
      Right := Left+Width-1;
      SetColor((BackColor Mod 8)+8);
      Line(Left, Top, Right-1, Top);
      Line(Left, Top, Left, Bottom-1);
      SetColor(8);
      Line(Left+1, Bottom-1, Right-1, Bottom-1);
      Line(Right-1, Top+1, Right-1, Bottom-1);
      SetColor(0);
      Line(Left, Bottom, Right, Bottom);
      Line(Right, Top, Right, Bottom);
      SetFillStyle(1, BackColor);
      Bar(Left+1, Top+1, Right-2, Bottom-2);
      If FontBold = True Then SetFontStyle(fsBold)
                         Else SetFontStyle(fsRegular);
      If Enabled Then
        Begin
          SetColor(ForeColor);
          If Length(Caption) = 1 Then
            PrintStr(Left+(Width-StrWidth(Caption)) Div 2,
                     Top+(Height-CurFont^.Height[Ord(Caption[1])]) Div 2-
                     CurFont^.Top[Ord(Caption[1])]+1, Caption)
           Else
            PrintStr(Left+(Width-StrWidth(Caption)) Div 2, Top+3, Caption)
        End
       Else
        Begin
          SetColor(BackColor Mod 8+8);
          PrintStr(Left+(Width-StrWidth(Caption)) Div 2+1, Top+4, Caption);
          SetColor(8);
          PrintStr(Left+(Width-StrWidth(Caption)) Div 2, Top+3, Caption);
        End;
{      SetColor(0);
      SetLineStyle(1, 0, 1);
      If Selected Then Rectangle(Left+3, Top+3, Right-3, Bottom-3);
      SetLineStyle(0, 0, 1);{}
      ShowMouse;
    End;

  Procedure TCommandButton.ShowDown;
    Var
      Len, Bottom, Right : Integer;
      i : Byte;
    Begin
      HideMouse;
      Bottom := Top+Height-1;
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
      SetFillStyle(1, BackColor);
      Bar(Left+2, Top+2, Right-1, Bottom-1);
      SetColor(ForeColor);
      If FontBold = True Then SetFontStyle(fsBold)
                         Else SetFontStyle(fsRegular);
      If Length(Caption) = 1 Then
        PrintStr(Left+(Width-StrWidth(Caption)) Div 2+1,
                 Top+(Height-CurFont^.Height[Ord(Caption[1])]) Div 2-
                 CurFont^.Top[Ord(Caption[1])]+2, Caption)
       Else
        PrintStr(Left+(Width-StrWidth(Caption)) Div 2+1, Top+4, Caption);
      ShowMouse;
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
      If Enabled And (msx > Left)And(msx < Right)And(msy > Top)And(msy < Bottom)And
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

  Procedure NewCButton;
    Begin
      New(Button);
      With Button^ Do
        Begin
          Caption := 'No name';
          Top := GetMaxY Div 2;
          Left := GetMaxX Div 2;
          Width := StrWidth(Caption)+10;
          Height := ButtonHeight;
          Enabled := True;
          BackColor := 7;
          ForeColor := 0;
          FontBold := False;
        End;
    End;

  Procedure TTextBox.Show;
    Var
      Right, Bottom : Integer;
      StW : Integer;
      i, j : Byte;
    Begin
      Right := Left+Width-1;
      Bottom := Top+19;
      SetFillStyle(1, BackColor);
      Bar(Left, Top, Right, Bottom);
      SetColor(8);
      Line(Left, Top, Right-1, Top);
      Line(Left, Top, Left, Bottom-1);
      SetColor(0);
      Line(Left+1, Top+1, Right-2, Top+1);
      Line(Left+1, Top+1, Left+1, Bottom-2);
      SetColor(7);
      Line(Left+1, Bottom-1, Right-1, Bottom-1);
      Line(Right-1, Top+1, Right-1, Bottom-1);
      SetColor(15);
      Line(Left, Bottom, Right, Bottom);
      Line(Right, Top, Right, Bottom);
      If FontBold = True Then SetFontStyle(fsBold)
                         Else SetFontStyle(fsRegular);
      StW := 6;
      i := 0;
      j := 0;
      While (i < Length(Txt))And(StW < Width) Do
        Begin
          Inc(i);
          If Txt[i] = ' ' Then j := 3
                          Else j := CurFont^.Width[Ord(Txt[i])]+1;
          StW := StW+j;
        End;
      Dec(i);
      SetColor(ForeColor);
      PrintStr(Left+3, Top+2, Copy(Txt, 1, i));
    End;

  Procedure TTextBox.GotFocus;
    Const
      TickTime = 65536;
    Var
      Tick : LongInt;
      KeyCode : Word;
      msx, msy : Integer;
      Button : Byte;
    Begin
      Tick := 0;
    End;

  Procedure TTextBox.KeyPress;
    Begin
    End;

  Procedure TLabel.Show;
    Begin
    End;

  Procedure NewLabel;
    Begin

    End;

End.