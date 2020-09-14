Uses CRT;

Type
  ScrStr = Object
    Content : String;
    XPos, YPos : Byte;
    Constructor Init;
    Procedure Show; Virtual;
    Procedure Hide; Virtual;
    Procedure Move;
    Destructor Done;
  End;

  BoxStr = Object(ScrStr)
    Constructor Init;
    Procedure Show; Virtual;
    Procedure Hide; Virtual;
{    Procedure Move;   {}
    Destructor Done;
  End;

Constructor ScrStr.Init;
  Begin
  End;

Procedure ScrStr.Show;
  Begin
    WriteLn('ScrStr.Show');
  End;

Procedure ScrStr.Hide;
  Begin
    WriteLn('ScrStr.Hide');
  End;

Procedure ScrStr.Move;
  Begin
    WriteLn('ScrStr.Move');
    Hide;
    Show;
  End;

Destructor ScrStr.Done;
  Begin
  End;

Constructor BoxStr.Init;
  Begin
  End;

Procedure BoxStr.Show;
  Begin
    WriteLn('BoxStr.Show');
  End;

Procedure BoxStr.Hide;
  Begin
    WriteLn('BoxStr.Hide');
  End;

{Procedure BoxStr.Move;
  Begin
    Hide;
    WriteLn('BoxStr.Move');
    Show;
  End;{}

Destructor BoxStr.Done;
  Begin
  End;

Var
  S : BoxStr;

BEGIN
  ClrScr;
  S.Init;
  S.Move;
  ReadLn;
END.