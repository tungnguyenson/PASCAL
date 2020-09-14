Uses Graph;

Const
  InputFile = 'system';
  MainColor = 0;

Procedure InitGraphMode;
  Var
    GraphDriver, GraphMode : Integer;
  Begin
    GraphDriver := VGA;
    GraphMode := VGAHi;
    InitGraph(GraphDriver, GraphMode, '\TP\BGI');
  End;

Procedure Convert;
  Var
    FI, FO : Text;
    i, j, H, v, Color : Integer;
  Begin
    Assign(FI, InputFile+'.pic');
    Reset(FI);
    Assign(FO, InputFile+'.dat');
    Rewrite(FO);
    ReadLn(FI, V, H);
    WriteLn(FO, V, ' ', H);
    For i := 1 To V Do
      Begin
        For j := 1 To H Do
          Begin
            Read(FI, Color);
            If Color = MainColor Then
              Begin
                PutPixel(j, i, 4);
                Write(FO, 1);
              End
             Else
              Begin
                PutPixel(j, i, 15);
                Write(FO, 0);
              End;
          End;
        If i <> V Then WriteLn(FO);
      End;
    Close(FO);
    Close(FI);
  End;

BEGIN
  InitGraphMode;
  Convert;
  ReadLn;
  CloseGraph;
END.