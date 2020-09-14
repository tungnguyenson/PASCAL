Unit Graph256;

Interface

  Procedure Init256Mode(GraphMode : Integer);
  Function StrConv(i : Word) : String;

Implementation

  Uses Graph, RBG;

  Procedure InitColorRegs;
    Var
      ColRegs : TColor256;
      i : Byte;
    Begin
      GetAllColorRegs(ColRegs);
      For i := 0 To 31 Do
        With ColRegs[32+i] Do
          Begin
            Red := 0;
            Blue := 0;
            Green := i*2+1;
          End;
      For i := 0 To 31 Do
        With ColRegs[64+i] Do
          Begin
            Red := 0;
            Blue := i*2+1;
            Green := 0;
          End;
      For i := 0 To 31 Do
        With ColRegs[96+i] Do
          Begin
            Red := 0;
            Blue := i*2+1;
            Green := i*2+1;
          End;
      For i := 0 To 31 Do
        With ColRegs[128+i] Do
          Begin
            Red := i*2+1;
            Blue := 0;
            Green := 0;
          End;
      For i := 0 To 31 Do
        With ColRegs[160+i] Do
          Begin
            Red := i*2+1;
            Blue := 0;
            Green := i*2+1;
          End;
      For i := 0 To 31 Do
        With ColRegs[192+i] Do
          Begin
            Red := i*2+1;
            Blue := i*2+1;
            Green := 0;
          End;
      For i := 0 To 31 Do
        With ColRegs[224+i] Do
          Begin
            Red := i*2+1;
            Blue := i*2+1;
            Green := i*2+1;
          End;
      SetAllColorRegs(ColRegs);
    End;


  Procedure Init256Mode;
    Var
      Driver, Mode : Integer;
    Begin
      Driver := InstallUserDriver('SVGA256', Nil);
      Mode := GraphMode;
      InitGraph(Driver, Mode, '\TP\BGI');
      InitColorRegs;
    End;

  Function StrConv;
    Var
      S : String;
    Begin
      Str(i, S);
      StrConv := S;
    End;

END.