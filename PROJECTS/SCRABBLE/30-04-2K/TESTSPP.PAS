Uses Support;

Var
  X, Y : Integer;

BEGIN
  SetCursorPos(40, 10);
  GetCursorPos(X, Y);
  WriteLn(X, ',', Y);
END.