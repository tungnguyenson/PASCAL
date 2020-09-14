{ Caution: This unit has not been fully tested }

Unit Global;

Interface

  Uses Support;

  Type

    TScbLetterCount = Array['A'..'Z'] Of Byte;
    TScbLetterScore = Array['A'..'Z'] Of Byte;

  Const

  { Default Color Defination }
    ScrabbleColor : TColor = (
      ForeColor : 7;
      BackColor : 0
    );
    TitleBarColor : TColor = (
      ForeColor : 15;
      BackColor :  1
    );
    StatusBarColor : TColor = (
      ForeColor : 15;
      BackColor :  1
    );

    TextAreaColor : TColor = (
      ForeColor :  7;
      BackColor :  0
    );

  { Default LetterCount }
    ScrabbleLetterCount : TScbLetterCount  =
                          {A  B  C  D  E  F  G  H  I  J  K  L  M}
                          (9, 2, 2, 4,12, 2, 3, 2, 9, 1, 1, 4, 2,
                          {N  O  P  Q  R  S  T  U  V  W  X  Y  Z}
                           6, 8, 2, 1, 6, 4, 6, 4, 2, 2, 1, 2, 1);

  { Default LetterScore }
    ScrabbleLetterScore : TScbLetterScore =
                          {A  B  C  D  E  F  G  H  I  J  K  L  M}
                          (1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3,
                          {N  O  P  Q  R  S  T  U  V  W  X  Y  Z}
                           1, 1, 3,10, 1, 1, 1, 1, 4, 4, 8, 4,10);

  { Default BlankCount }
    ScrabbleBlankCount : Byte = 2;

  Type

    TTitleBar = Object
      ForeColor, BackColor : Byte;
      Caption : TScrString;
      Procedure Init(S : TScrString);
      Procedure Show;
      Procedure Change(S : String);
    End;

    TStatusBar = Object
      ForeColor, BackColor : Byte;
      Caption : TScrString;
      Procedure Init(S : TScrString);
      Procedure Show;
      Procedure Change(S : String);
    End;

    PTextArea = ^TTextArea;
    TTextArea = Object
      Left, Top, Width, Height : Byte;
      Color : TColor;
      CurrentX, CurrentY : Byte;
      WrapText : Boolean;
      Txt : Array[1..25] Of TScrString;
      Procedure Init(L, T, W, H : Byte);
      Procedure Clear;
      Procedure Show;
      Procedure SetCurrentPos(X, Y : Byte);
      Procedure OutMsg(X, Y : Integer; Msg : TScrString);
    End;

Implementation

  Procedure TTitleBar.Init;
    Begin
      ForeColor := TitleBarColor.ForeColor;
      BackColor := TitleBarColor.BackColor;
      Caption := S;
    End;

  Procedure TTitleBar.Show;
    Var
      X : Byte;
    Begin
      ClearWindow(1, 1, 80, 1, BackColor);
      X := TextAlign(AlignCenter, 1, 80, Caption);
      OutStr(X, 1, Caption, ForeColor, BackColor);
    End;

  Procedure TTitleBar.Change;
    Begin
      Caption := S;
      Show;
    End;

  Procedure TStatusBar.Init;
    Begin
      ForeColor := StatusBarColor.ForeColor;
      BackColor := StatusBarColor.BackColor;
      Caption := S;
    End;

  Procedure TStatusBar.Show;
    Begin
      ClearWindow(1, 25, 80, 25, BackColor);
      OutStr(1, 25, Caption, ForeColor, BackColor);
    End;

  Procedure TStatusBar.Change;
    Begin
      Caption := S;
      Show;
    End;

  Procedure TTextArea.Init;
    Begin
      Left   := L;
      Top    := T;
      Width  := W;
      Height := H;
      CurrentX := 1;
      CurrentY := 1;
      Color := TextAreaColor;
      WrapText := True;
    End;

  Procedure TTextArea.Clear;
    Begin
      SetTxtColor(Color.ForeColor, Color.BackColor);
      ClearWindow(Left, Top, Left+Width-1, Top+Height-1, Color.BackColor);
    End;

  Procedure TTextArea.Show;
    Begin
      Clear;
    End;

  Procedure TTextArea.SetCurrentPos;
    Begin
      CurrentX := X;
      CurrentY := Y;
      SetCursorPos(Left+CurrentX-1, Top+CurrentY-1);
    End;

  Procedure TTextArea.OutMsg;
    Begin
      If X = valNotSet Then X := CurrentX;
      If Y = valNotSet Then Y := CurrentY;
      OutStr(Left+X-1, Top+Y-1, Msg, Color.ForeColor, Color.BackColor);
      CurrentX := CursorX-Left+1;
      CurrentY := CursorY-Top+1;
    End;

End.