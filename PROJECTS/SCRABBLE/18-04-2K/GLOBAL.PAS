Unit Global;

Interface

  Uses Support;

  Type

  { Characters Map : Indicate where character is in new ASCII table }
    TScrabbleCharMap = Record
      ChrLetter : Array['A'..'Z'] Of Char;
      ChrBorder : Array[1..4] Of Char;
      ChrQuestion : Char;
    End;

    TScblLetterCount = Array['A'..'Z'] Of Byte;

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

  { Default LetterCount }
    ScrabbleLetterCount : TScblLetterCount  =
                          {A  B  C  D  E  F  G  H  I  J  K  L  M}
                          (9, 2, 2, 4,12, 2, 3, 2, 9, 1, 1, 4, 2,
                          {N  O  P  Q  R  S  T  U  V  W  X  Y  Z}
                           6, 8, 2, 1, 6, 4, 6, 4, 2, 2, 1, 2, 1);

  { Default LetterScore }
    ScrabbleLetterScore : TScblLetterCount =
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

End.