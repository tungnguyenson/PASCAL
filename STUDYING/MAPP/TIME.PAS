Uses CRT;

Var
  SysClock : LongInt Absolute $0000:$046C;
  Hour, Min, Sec, MiliSec : Word;
  i, j, k : Word;

Type
  TClock = Object
    MarkedTime : LongInt;
    PassedTime : LongInt;
    Procedure MarkTime;
    Function GetPassedMiliSecond : Byte;
  End;

Procedure TClock.MarkTime;
  Begin
    MarkedTime := SysClock;  {LongInt Absolute $0000:$046C}
  End;

Function TClock.GetPassedMiliSecond;
  Var
    Time : LongInt;
  Begin
    Time := SysClock;
    Hour := Round(Time/65543);  { $10007 }
    Time := Time Mod 65543;
    Min := Round(Time/1092);    { $444   }
    Time := Time Mod 1092;
    Sec := Round(Time/18.2);    {1193180/65536 = 18.2}
    Time := Time Mod 18;
    MiliSec := Round(Time/18.2*100);
    { LongTime = (Hour*65543.33)+(Min*1092.38)+(Sec*18.21)+(MiliSec*0.182) }
  End;

Var
  AppClock : LongInt Absolute $0000:$046C;
  Time : LongInt;

BEGIN
  ClrScr;
  Repeat
    Time := AppClock;
    Hour := Round(Time/65543);
    i := Time Mod 65543;
    Min := Round(i/1092);
    i := i Mod 1092;
    Sec := Round(i/18.2);
    i := Time Mod 18;{}
    Milisec := Round(i/18.2*100);
    Window(1, 1, 80, 5);
    GoToXY(1, 1);  ClrEOL;  Write('Hour : ', Hour);
    GoToXY(1, 2);  ClrEOL;  Write('Min : ', Min);
    GoToXY(1, 3);  ClrEOL;  Write('Sec : ', Sec);
    GoToXY(1, 4);  ClrEOL;  Write('Milisec : ', Milisec);
    If Milisec > j Then k := Milisec-j
                   Else k := Milisec+100-j;
    j := Milisec;
    GoToXY(1, 5);  Write(k);
{    If A[j] = 0 Then
      Begin
        Window(1, 6, 80, 25);
        A[j] := 1;
        GoToXY(X, Y);
        Write(j:8);
        X := WhereX;
        Y := WhereY;
      End;}
  Until Keypressed;
END.