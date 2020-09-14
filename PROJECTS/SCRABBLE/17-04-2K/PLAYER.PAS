Unit Player;

Interface

  Uses Support;

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

  Type TPlayer = Object
    Color : TPlayerStatusColor;
    Name : TPlayerName;
    Controller : Byte;
    Procedure HumanTurn;
    Procedure ComputerTurn;
  End;

  Type TPlayers = Object
    Turn  : Byte;
    Count : Byte;
    List  : Array[1..4] Of TPlayer;
    Procedure Init;
    Procedure ComputerTurn;
    Procedure HumanTurn;
  End;

Implementation

  Procedure TPlayer.HumanTurn;
    Begin
    End;

  Procedure TPlayer.ComputerTurn;
    Begin
    End;

  Procedure TPlayers.Init;
    Begin
    End;

  Procedure TPlayers.ComputerTurn;
    Begin
    End;

  Procedure TPlayers.HumanTurn;
    Begin
    End;

End.