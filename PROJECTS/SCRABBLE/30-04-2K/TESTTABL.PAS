Uses Table, TextFont;

Type
  TScbTable = Object(TTable)
  End;

Var
  ScbTable : TScbTable;

BEGIN
  With ScbTable Do
    Begin
      Init;
      Show;
      Refresh;
      Cell[7, 12] := 'L';
      Cell[7, 13] := 'Y';
      Refresh;
    End;
  ReadLn;
  LoadVGAFont;
END.