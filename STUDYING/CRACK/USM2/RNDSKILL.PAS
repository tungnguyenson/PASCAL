Program User;

Uses CRT;

Const
  PlayerRecSize = 45;

Type
  PlayerRec = Record
    FName : String[14];
    SName : String[14];
    Age : Byte;
    Club : Word;
    Skill : Array[1..10] Of Byte;
  End;

  ClubRec = Record
    Value : Real;
    OverallSkill : Array[1..10] Of Real;
  End;

Var
  Players : PlayerRec;
  PlayersCount, ClubsCount, Count : Integer;
  Clubs : Array[0..255] Of ClubRec;
  Buf : Array[0..1023] Of Byte;
  HighestClub : Integer;

Procedure RandomSkill;
  Var
    i, j, k : Integer;
    Player : PlayerRec;
    EndOfList : Boolean;
    FI, FO : File;
    Highest : Real;
  Begin
    Randomize;
    Assign(FI, 'usme0001.usr');
    Reset(FI, 1);
    Assign(FO, 'usme0001.tmp');
    Rewrite(FO, 1);
    BlockRead(FI, Buf, 20);
    BlockWrite(FO, Buf, 20);
    PlayersCount := 0;
    ClubsCount := 0;
    EndOfList := False;
    FillChar(Clubs, SizeOf(Clubs), 0);
    FillChar(Clubs, SizeOf(Clubs), 0);
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
          Age := Buf[28];
          Club := Word(Buf[30])*$100+Word(Buf[29]);
          If (Club <> 0)And(Club <> 65535) Then
            Begin
{              For i := 1 To 10 Do
                Skill[i] := Buf[i+32];{}
              Buf[28] := 18+Random(10);
              For i := 1 To 10 Do
                Skill[i] := Random(69)+30;{}
              i := Random(13);
              Case i Of
                0 :
                  Begin
                    Skill[1] := Random(50)+50;
                    Skill[2] := Random(20)+20;
                    Skill[3] := Random(50)+50;
                    Skill[4] := Random(20)+10;
                  End;
                1..5 :
                  Begin
                    Skill[1] := Random(20);
                    Skill[2] := Random(50)+50;
                    Skill[3] := Random(30)+30;
                    Skill[4] := Random(20)+15;
                    Skill[10] := Random(70)+30;
                  End;
                6..10 :
                  Begin
                    Skill[1] := Random(20);
                    Skill[2] := Random(20)+20;
                    Skill[3] := Random(50)+50;
                    Skill[4] := Random(30)+30;
                    Skill[10] := Random(60)+40;
                  End;
                11..12 :
                  Begin
                    Skill[1] := Random(20);
                    Skill[2] := Random(20)+15;
                    Skill[3] := Random(30)+30;
                    Skill[4] := Random(60)+40;
                    Skill[10] := Random(50)+50;
                  End;
              End;
              For i := 1 To 10 Do
                If Skill[i] < 5 Then Skill[i] := Random(5)+1;
              Skill[6] := 100;
              With Clubs[Club] Do
                For i := 1 To 5 Do
                  If OverallSkill[i] = 0 Then OverallSkill[i] := Skill[i]
                   Else OverallSkill[i] := (OverallSkill[i]+Skill[i])/2;
              For i := 1 To 10 Do
                Buf[i+32] := Skill[i];
            End;{}
{          For i := 1 To 10 Do
            Skill[i] := Buf[i+32];
{          If SName = 'Tetradze' Then
            i := i;{}
{          If Club > 256 Then
            i := i;{}
        End;
      If EOF(FI) Or ((Player.FName = '')And(Player.SName = '')) Then
        EndOfList := True
       Else
        Begin
          Inc(PlayersCount);
{          Write(PlayersCount:5, ' ', Player.FName, ' ', Player.SName);
          GoToXY(30, WhereY);
          For i := 1 To 5 Do
            Write(Player.Skill[i]:3);
          For i := 7 To 10 Do
            Write(Player.Skill[i]:3);
          Write(Player.Skill[6]:4);
          WriteLn(Player.Age:4, Player.Club:6);{}
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
{    WriteLn('Done!');{}
    Highest := 0;
    For i := 0 To 255 Do
      With Clubs[i] Do
        Begin
          For j := 1 To 5 Do
            Value := Value+OverallSkill[j];
          Value := Value/5;
          If Highest < Value Then
            Begin
              Highest := Value;
              HighestClub := i;
            End;
        End;
    Write('Highest Club: ', HighestClub:5, ' - Value: ', Highest:0:5);
    WriteLn('  NV: ', Clubs[67].Value:0:5);
  End;

Begin
  ClrScr;
  WriteLn('Index Player                  KP TA PS SH PC TH ST IN BC  FT Age  Club');
  Window(1, 2, 80, 25);
  Repeat
    RandomSkill;{}
  Until (HighestClub = 67)Or(ReadKey = #27);
  Window(1, 1, 80, 25);
End.