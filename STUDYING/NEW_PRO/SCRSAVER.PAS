Uses CRT, MyCRT;

Const
  MaxStars = 75;

  StarType : String = #196#95; { -._Äùú }

Type
  TStar = Object
    X, Y : ShortInt;
    Kind : Byte;
    Color : Byte;
    Direct : ShortInt;
    Visible : Boolean;
    Interval, Time : LongInt;
    Procedure Init;
    Procedure Show;
    Procedure Hide;
    Procedure Active;
  End;

Var
  Saver : TScreen;
  Stars : Array[1..MaxStars] Of TStar;
  SysTickTime : LongInt Absolute $0000:$046C;
  TickTime : LongInt;

Procedure TStar.Init;
  Begin
    Y := Random(25);
    Color := Random(15)+1;
    Kind := Random(Length(StarType))+1;
    Interval := Random(2000)+1000;
    Time := Random(Interval);
    Visible := True;
    If Random(2) = 0 Then
      Begin
        Direct := -1;
        X := 80;
      End
     Else
      Begin
        Direct := 1;
        X := -1;
      End;
    If (GetChar(X, Y) <> #0)And(GetChar(X, Y) <> #32) Then Visible := False
     Else Visible := True;{}
  End;

Procedure TStar.Show;
  Begin
    If Visible = True Then
      Screen[Y, X] := Color*256+Ord(StarType[Kind])
  End;

Procedure TStar.Hide;
  Begin
    If Visible = True Then
      Screen[Y, X] := Hi(Screen[Y, Y])+Ord(#0);
  End;

Procedure TStar.Active;
  Var
    Ch : Char;
  Begin
    Inc(Time);
{    OutLongInt(0, 0, Time);{}
    If Time >= Interval Then
      Begin
{        GoToXY(X+1, Y+1);{}
        Time := 0;
        Hide;
        X := X+Direct;
        If (X < 0)Or(X > 79) Then
          Init;
        Ch := GetChar(X, Y);
        If (GetChar(X, Y) <> #0)And(GetChar(X, Y) <> #32) Then Visible := False
         Else Visible := True;{}
        Show;
      End;
  End;

Procedure Implement;
  Var
    Ch : Char;
    i : Byte;
  Begin
    Repeat
      For i := 1 To MaxStars Do
        Stars[i].Active;
    Until KeyPressed;
    Ch := ReadKey;
    If Ch = #0 Then Ch := ReadKey;
  End;

Procedure Init;
  Var
    i : Byte;
  Begin
    Saver := Screen;
    ClrScr;
    Randomize;
    For i := 1 To MaxStars Do
      With Stars[i] Do
        Begin
          Init;
          X := Random(80);
          Show;
        End;
    OutStrAttr(10, 10, 'Nguyen Son Tung', 15, 0);
    OutStrAttr(40, 15, 'Nguyen Son Tung', 15, 0);
    OutStrAttr(60, 20, 'Nguyen Son Tung', 15, 0);
  End;

Procedure Done;
  Begin
    Screen := Saver;
  End;

BEGIN
  Init;
  Implement;
  Done;
END.