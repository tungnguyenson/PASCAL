Unit Player;

Interface

  Uses Support;

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

  Type TPlayer = Object
    Color : TPlayerStatusColor;
    Name : TPlayerName;
    Controller : Byte;
    Procedure Init;
  End;

Implementation

  Procedure TPlayer.Init;
    Begin
    End;

End.