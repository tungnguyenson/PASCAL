  Constructor TOptionButton.Init;
    Begin
      Inherited Init(L, T, W, H, S, FG, BG, HLColor);
    End;

  Function TOptionButton.InitOptionButton;
    Begin
      Init(L, T, W, 1, S, FG, BG, HLColor);
      ChangeCaption(S);
      Value := chkUnchecked;
      If V <> NotSet Then Value := V;
      If W = NotSet Then
        Begin
          AutoSize := True;
          W := LenCaption;
          Move(Left, Top, W, 1);
        End;
    End;

  Procedure TOptionButton.ChangeCaption;
    Begin
      If (S[1] <> '(')Or(S[3] <> ')') Then S := '( ) '+S;
      Inherited ChangeCaption(S);
      If AutoSize Then Move(Left, Top, LenCaption, 1);
    End;

  Procedure TOptionButton.Show;
    Begin
      Inherited Show;
      ClearWindow(Left, Top, Right, Bottom, BackColor);
      If Value = chkChecked Then Caption^[2] := #7
                            Else Caption^[2] := ' ';
      ShowCaption(NotSet, NotSet, NotSet, NotSet);
    End;

  Procedure TOptionButton.Hide;
    Begin
      Inherited Hide;
    End;

  Destructor TOptionButton.Done;
    Begin
      Inherited Done;
    End;