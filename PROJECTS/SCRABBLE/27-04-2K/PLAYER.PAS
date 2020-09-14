Unit Player;

Interface

  Uses Support, ScbTable;

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

    TPlayer = Object
      Name : TPlayerName;
      Controller : Byte;
      Procedure Init;
      Procedure Show;
    End;

    TPlayers = Object
      Color       : TPlayerStatusColor;
      PlayerTurn  : Byte;
      PlayerCount : Byte;
      Player      : Array[1..MaxPlayer] Of TPlayer;

      RefTable : PScrabbleTable;

      Procedure Init;
      Procedure Show;
      Procedure ComputerTurn;
      Procedure HumanTurn;
      Procedure ApplyTurn;
    End;

Implementation

  Procedure TPlayer.Init;
    Begin
    End;

  Procedure TPlayer.Show;
    Begin
    End;

  Procedure TPlayers.Init;
    Begin
    End;

  Procedure TPlayers.Show;
    Var
      I : Byte;
    Begin
      For I := 1 To PlayerCount Do
        Player[I].Show;
    End;

  Procedure TPlayers.HumanTurn;
    Begin
    End;

  Procedure TPlayers.ComputerTurn;
    Begin
    End;

  Procedure TPlayers.ApplyTurn;
    Begin
    End;

End.