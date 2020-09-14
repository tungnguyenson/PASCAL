  Constructor TLabel.Init;
    Begin
      Inherited Init(L, T, W, H, S, FG, BG, HLColor);
    End;

  Procedure TLabel.InitLabel;
    Begin
      Init(L, T, W, 1, S, FG, BG, HLColor);
      If W = NotSet Then
        Begin
          W := LenCaption;
          Move(Left, Top, W, 1);
        End;
      If Align <> NotSet Then Alignment := Align;
    End;

  Procedure TLabel.MoveLabel;
    Begin
      Move(L, T, W, 1);
    End;

  Procedure TLabel.Show;
    Begin
      Inherited Show;
      ClearWindow(Left, Top, Right, Bottom, BackColor);
      ShowCaption(NotSet, NotSet, ForeColor, BackColor);
    End;

  Destructor TLabel.Done;
    Begin
      Inherited Done;
    End;

