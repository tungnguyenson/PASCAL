Unit SpGraph;

Interface

  Procedure EGAVGADriverProc;
{  Procedure SVGA256DriverProc;{}
  Procedure InitGraphMode(GraphDriver : String; GraphMode : Integer);
  Procedure BuiltInEGAVGAMode;{}
{ Procedure BuiltInSVGA256Mode;{}
  Function StrConv(i : Word) : String;

Implementation

  Uses Graph;

  Procedure EGAVGADriverProc; External;
  {$L EGAVGA.OBJ}

{  Procedure SVGA256DriverProc; External;
  {$L SVGA256.OBJ}

  Procedure InitGraphMode;
    Var
      Driver, Mode : Integer;
    Begin
      Driver := InstallUserDriver(GraphDriver, Nil);
      Mode := GraphMode;
      InitGraph(Driver, Mode, '\TP\BGI');
    End;

  Procedure BuiltInEGAVGAMode;
    Var
      Driver, Mode : Integer;
    Begin
      RegisterBGIDriver(@EGAVGADriverProc);
      Driver := Detect;
      InitGraph(Driver, Mode, '');
    End;

{  Procedure BuiltInSVGA256Mode;
    Var
      Driver, Mode : Integer;
    Begin
      RegisterBGIDriver(@SVGA256DriverProc);
      Driver := Detect;
      InitGraph(Driver, Mode, '');
    End;{}

  Function StrConv;
    Var
      S : String;
    Begin
      Str(i, S);
      StrConv := S;
    End;

End.