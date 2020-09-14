Unit Player;

Interface

  Uses Support, Keyboard, Table;

  Const
    MaxPlayer = 4;

  Type TPlayerStatusColor = Record
    Active  : TColor;
    Passive : TColor;
  End;

  Const
    PlayerStatusColor : TPlayerStatusColor = (
      Active  : (ForeColor : 15;
                 BackColor :  1);
      Passive : (ForeColor :  7;
                 BackColor :  0)
      );

    Human    = 1;
    Computer = 2;

  Type

    TPlayerName = String[20];

    TPlayerInfo = Object
      PlayerID : Byte;
      Left, Top : Byte;
      Name : TPlayerName;
      Controller : Byte;
      Active : Boolean;
      Color : TPlayerStatusColor;

      Score : Integer;
      Letters : String;

      Procedure Init(StName : TPlayerName; Ctrl : Byte);
      Procedure Show;
      Procedure SetActive;
      Procedure SetPassive;
    End;

Implementation

  Procedure TPlayerInfo.Init;
    Begin
      Name := StName;
      Controller := Ctrl;
      Active := False;
      Color := PlayerStatusColor;
      Score := 0;
      Letters := '';
    End;

  Procedure TPlayerInfo.Show;
    Var
      FG, BG : Byte;
      S : String;
      i : Byte;
      Letter : Char;
    Begin
      If Active Then
        Begin
          FG := Color.Active.ForeColor;
          BG := Color.Active.BackColor;
        End
       Else
        Begin
          FG := Color.Passive.ForeColor;
          BG := Color.Passive.BackColor;
        End;
      ClearWindow(Left, Top, 80, Top+2, BG);
      SetTxtColor(FG, BG);
      OutStr(Left+1, Top, 'Player '+StrConv(PlayerID)+' ('+Name+')', valNotSet, valNotSet);
      OutStr(Left+1, Top+1, '  Score   : '+StrConv(Score), valNotSet, valNotSet);
      OutStr(Left+1, Top+2, '  Letters : '+Letters, valNotSet, valNotSet);
      For i := 1 To 7 Do
        With Table.TableSymbols Do
          Begin
            If Length(Letters) < i Then Letter := NoLetter
                                   Else Letter := Letters[i];
            S := ChrBorder[1];
            If Letter = NoLetter Then
              S := S+ChrBorder[1]
             Else If Letter = MarkLetter Then
              S := S+ChrQuestion
             Else S := S+Chr(Ord(Letter)+127);
            S := S+ChrBorder[3];
            OutStr(Left+13+(i-1)*3, Top+2, S, valNotSet, valNotSet);
          End;
    End;


  Procedure TPlayerInfo.SetActive;
    Begin
      Active := True;
      Show;
    End;

  Procedure TPlayerInfo.SetPassive;
    Begin
      Active := False;
      Show;
    End;

End.