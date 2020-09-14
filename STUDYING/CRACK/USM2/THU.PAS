Program User;

Uses CRT;

Const
  PlayerRecSize = 45;
  UserTitleSize = 20;

Type
  PlayerRec = Record
    FName : String[14];
    SName : String[14];
    Age : Byte;
    Skill : Array[1..10] Of Byte;
  End;

Var
  Players : PlayerRec;
  PlayersCount : Integer;
  Buf : Array[0..1023] Of Byte;
  UserTitle : String[20];

Procedure ReadUserTitle(Var Source : File);
  Var
    i : Byte;
  Begin
    FillChar(Buf, SizeOf(Buf), 0);
    BlockRead(Source, Buf, UserTitleSize);
    UserTitle := '';
    i := 0;
    While Buf[i] <> 0 Do
      Begin
        UserTitle := UserTitle+Chr(Buf[i]);
        Inc(i);
      End;
  End;

Procedure ReadPlayerInfo(Var Source : File);

  Procedure ReadPlayerRec(Var Source : File; Var Player : PlayerRec);
    Var
      i : Integer;
    Begin
      FillChar(Buf, SizeOf(Buf), 0);
      BlockRead(Source, Buf, PlayerRecSize);
    End;

  Var
    EndOfList : Boolean;
    Player : PlayerRec;

  Begin
    PlayersCount := 0;
    EndOfList := False;
    Repeat
      FillChar(Buf, SizeOf(Buf), 0);
      BlockRead(Source, Buf, PlayerRecSize);
      If EOF(Source) Or ((Player.FName = '')And(Player.SName = '')) Then
        EndOfList := True
       Else
        Begin
          Inc(PlayersCount);
          WriteLn(PlayersCount:5, '  ', Player.FName, ' ', Player.SName);
        End;
    Until EndOfList;
  End;

Procedure DecreaseSkill;
  Var
    i, j : Integer;
    Player : PlayerRec;
    EndOfList : Boolean;
    FI, FO : File;
  Begin
    Randomize;
    Assign(FI, 'usme0001.usr');
    Reset(FI, 1);
    Assign(FO, 'usme0001.tmp');
    Rewrite(FO, 1);
    BlockRead(FI, Buf, 20);
    BlockWrite(FO, Buf, 20);
    PlayersCount := 0;
    EndOfList := False;
    Repeat
      FillChar(Buf, SizeOf(Buf), 0);
      BlockRead(FI, Buf, PlayerRecSize);
      With Player Do
        Begin
          FName := '';
          SName := '';
          For i := 0 To 13 Do
            If Buf[i] <> 0 Then
              FName := FName+Chr(Buf[i]);
          For i := 0 To 13 Do
            If Buf[13+i] <> 0 Then
              SName := SName+Chr(Buf[13+i]);
          For i := 1 To 10 Do
            If i <> 6 Then
              Begin
                j := Buf[i+32];
                If (Buf[29] = 255)And(Buf[30] = 255) Then
                  Begin
                    If j > 90 Then Dec(j, 15)
                     Else If j > 85 Then Dec(j, 5);
                  End
                 Else Dec(j, 15);
                j := j+Random(15)-8;
                If j < 1 Then j := Random(5)+1;
                Buf[i+32] := j;
              End;
          Age := Buf[28];
          For i := 1 To 10 Do
            Skill[i] := Buf[i+32];
        End;
      If Player.SName = 'Bergkamp' Then
        i := i;
      If EOF(FI) Or ((Player.FName = '')And(Player.SName = '')) Then
        EndOfList := True
       Else
        Begin
          Inc(PlayersCount);
{          WriteLn(PlayersCount:5, '  ', Player.FName, ' ', Player.SName);{}
        End;
      BlockWrite(FO, Buf, PlayerRecSize);
    Until EndOfList Or Keypressed;
    While Not EOF(FI) Do
      Begin
        BlockRead(FI, Buf, SizeOf(Buf), i);
        BlockWrite(FO, Buf, i);
      End;
    Close(FI);
    Close(FO);
    Erase(FI);
    Rename(FO, 'usme0001.usr');
    GoToXY(1, 5);
    WriteLn('Done!');
  End;

Procedure Main;
  Begin
    TextAttr := 7;
    ClrScr;
    GoToXY(25, 1);
    Write('-== USM2 Userfile Editor ==-');
  End;

Begin
  Main;
  DecreaseSkill;
  ReadLn;
  ClrScr;
End.