Uses Support, CtrlObj;

Type

  TFrmCopy = Object(TForm)
    Constructor Init(L, T, W, H : Integer;
                     S : String;
                     FG, BG, HLColor : Integer);
    Procedure HandleEvent; Virtual;
    Destructor Done;
  End;

Constructor TFrmCopy.Init;
  Begin
    Inherited Init(L, T, W, H, S, FG, BG, HLColor);
  End;

Procedure TFrmCopy.HandleEvent;
  Begin
    Inherited HandleEvent;
  End;

Destructor TFrmCopy.Done;
  Begin
    Inherited Done;
  End;

Var
  NC : TFrmCopy;

BEGIN
  NC.InitForm(1, 1, 80, 25, StNotUsed, NotSet, NotSet, NotSet);
  NC.Run;
  NC.Done;
END.