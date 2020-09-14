  Procedure TSaveScreen.Save;
    Begin
      Move(Mem[$B800:0000], Buffer, SizeOf(Buffer));
    End;

  Procedure TSaveScreen.Load;
    Begin
      Move(Buffer, Mem[$B800:0000], SizeOf(Buffer));
    End;

  Procedure TTable.Init;
    Begin
      X1 := L;
      Y1 := T;
      X2 := R;
      Y2 := B;
      ForeColor := FG;
      BackColor := BG;
      Shadow := False;
    End;

  Procedure TTable.DrawTable;
    Var
      X, Y : Byte;
    Begin
      ClearWindow(X1+1, Y1+1, X2-1, Y2-1, BackColor);
      For Y := Y1+1 To Y2-1 Do
        Begin
          OutChar(X1, Y, #186, ForeColor, BackColor);
          OutChar(X2, Y, #186, ForeColor, BackColor);
        End;
      For X := X1+1 To X2-1 Do
        Begin
          OutChar(X, Y1, #205, ForeColor, BackColor);
          OutChar(X, Y2, #205, ForeColor, BackColor);
        End;
      OutChar(X1, Y1, #201, ForeColor, BackColor);
      OutChar(X2, Y1, #187, ForeColor, BackColor);
      OutChar(X1, Y2, #200, ForeColor, BackColor);
      OutChar(X2, Y2, #188, ForeColor, BackColor);
      If Shadow Then
        ShowObjectShadow(X1, Y1, X2, Y2, 2);
    End;

  Procedure TTable.DrawColumn;
    Var
      Y : Byte;
      Ch : Char;
      TmpColor : Integer;
    Begin
      SetTxtColor(ForeColor, BackColor);
      If (X > X1)And(X < X2) Then
        Begin
          If (T = NotSet)Or(T < Y1) Then T := Y1;
          If (B = NotSet)Or(B > Y2) Then B := Y2;
          For Y := T To B Do
            Begin
              Ch := GetChar(X, Y, TmpColor, TmpColor);
              Case Ch Of
                #196 : If (Y = T) Then Ch := #194
                       Else If (Y = B) Then Ch := #193
                       Else Ch := #197;
                #205 : If (Y = T) Then Ch := #209
                       Else If (Y = B) Then Ch := #207;
                Else If (Not (Ch In [#193, #194, #197, #207, #209])) Then
                  Ch := #179;
              End;
              OutChar(X, Y, Ch, NotSet, NotSet);
            End;
        End;
    End;

  Procedure TTable.DrawRow;
    Var
      X : Byte;
      Ch : Char;
      TmpColor : Integer;
    Begin
      SetTxtColor(ForeColor, BackColor);
      If (Y > Y1)And(Y < Y2) Then
        Begin
          If (L = NotSet)Or(L < X1) Then L := X1;
          If (R = NotSet)Or(L > X2) Then R := X2;
          For X := L To R Do
            Begin
              Ch := GetChar(X, Y, TmpColor, TmpColor);
              Case Ch Of
                #179 : If (X = L) Then Ch := #195
                       Else If (X = R) Then Ch := #180
                       Else Ch := #197;
                #186 : If (X = L) Then Ch := #199
                       Else If (X = R) Then Ch := #182;
                Else If (Not (Ch In [#180, #182, #195, #197, #199])) Then
                  Ch := #196;
              End;
              OutChar(X, Y, Ch, NotSet, NotSet);
            End;
        End;
    End;

  Procedure TCtrlObject.Show;
    Begin
      With ObjectInfo Do
        Case ObjectType Of
          ctrlLabel : lblPtr^.Show;
          ctrlCommandButton : cmdPtr^.Show;
          ctrlSingleLineTextBox : txtPtr^.Show;
          ctrlCheckBox : chkPtr^.Show;
          ctrlOptionButton : optPtr^.Show;
        End;
    End;

  Procedure TCtrlObject.SetFocus;
    Begin
      With ObjectInfo Do
        Case ObjectType Of
          ctrlCommandButton : cmdPtr^.SetFocus;
        End;
    End;

  Procedure TCtrlObject.LostFocus;
    Begin
      With ObjectInfo Do
        Case ObjectType Of
          ctrlCommandButton : cmdPtr^.LostFocus;
        End;
    End;
