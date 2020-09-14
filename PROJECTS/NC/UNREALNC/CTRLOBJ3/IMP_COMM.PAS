  Constructor TCommonControlObject.Init;
    Begin
      Left   := 35;
      Top    := 12;
      Width  := 15;
      Height := 1;

      ForeColor := 15;
      BackColor := 7;
      If FG <> NotSet Then ForeColor := FG;
      If BG <> NotSet Then BackColor := BG;
      HighlightColor := ForeColor;
      If HLColor <> NotSet Then HighlightColor := HLColor;

      Alignment := AlignLeft;

      ChangeCaption(S);

      Visible := False;
      Move(L, T, W, H);
      GetChar(L, T, TmpFColor, TmpBColor);
      Background := TmpBColor;

      AutoSize := False;
      Enabled := True;
      Active  := False;
      TabIndex := $FF;
      TabStop := False;
      Priority := $FF;
    End;

  Procedure TCommonControlObject.Move;
    Begin
      If Visible Then Hide;
      If L <> NotSet Then Left  := L;
      If T <> NotSet Then Top   := T;
      If W <> NotSet Then Width := W;
      If H <> NotSet Then Height := H;
      Right := Left+Width-1;
      Bottom := Top+Height-1;
      If Visible Then Show;
    End;

  Procedure TCommonControlObject.ChangeCaption;
    Var
      HL : Boolean;
      I, J : Byte;
    Begin
      HotKey := #0;
      LenCaption := 0;
      If S = StNotUsed Then
        Caption := Nil
       Else
        Begin
          If S = StNotSet Then S := 'Default';
          { Check for available memory here! }
          New(Caption);
          Caption^ := S;

          { Get length(Caption) }
          For I := 1 To Length(Caption^) Do
            If (Caption^[I] <> '~') Then Inc(LenCaption)
             Else If Caption^[I+1] = '~' Then Inc(LenCaption);

          { Get HotKey }
          HL := False;
          I := LenCaption+1;
          While (I > 1) Do
            Begin
              Dec(I);
              If Caption^[I] = '~' Then HL := Not HL
               Else If (HL)And(Caption^[I] In ['a'..'z', 'A'..'Z', '0'..'9']) Then
                 HotKey := Caption^[I];
            End;
          If HotKey In ['a'..'z'] Then HotKey := Chr(Ord(HotKey)+32);
        End;
    End;

  Procedure TCommonControlObject.ShowCaption;
    Var
      NewX, NewY, I : Byte;
      HL : Boolean;
    Begin
      If X = NotSet Then X := 0;
      If Y = NotSet Then Y := 0;
      If FG = NotSet Then FG := ForeColor;
      If BG = NotSet Then BG := BackColor;
      Case Alignment Of
        AlignCenter : NewX := (Left+Right-LenCaption) Div 2+1;
        AlignRight  : NewX := Right-LenCaption+1;
       Else { AlignLeft }
		  NewX := Left;
      End;
      NewX := NewX+X;
      NewY := Top+Y;
      ClearWindow(NewX, NewY, NewX+LenCaption-1, NewY, BG);
      HL := False;
      I := 0;
      While I < Length(Caption^) Do
        Begin
          Inc(I);
          If Caption^[I] = '~' Then HL := Not HL
           Else
            Begin
              If HL Then
                OutChar(NewX, NewY, Caption^[I], HighlightColor, BG)
               Else
                OutChar(NewX, NewY, Caption^[I], FG, BG);
              Inc(NewX);
            End;
        End;
    End;

  Procedure TCommonControlObject.Show;
    Begin
      Visible := True;
    End;

  Procedure TCommonControlObject.Hide;
    Begin
      ClearWindow(Left, Top, Right, Bottom, Background);
      Visible := False;
    End;

  Destructor TCommonControlObject.Done;
    Begin
      If Caption <> Nil Then Dispose(Caption);
    End;

