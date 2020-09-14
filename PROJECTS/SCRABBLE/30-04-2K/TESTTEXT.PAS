Uses TextArea, Support;

Var
  TxtArea : TTextArea;

BEGIN
  ClearWindow(1, 1, 80, 25, 0);
  With TxtArea Do
    Begin
      Init(1, 1, 40, 8);
      SetCurrentPos(2, 2);{}
      OutMsg('Hello World!');
    End;
  ReadLn;
END.