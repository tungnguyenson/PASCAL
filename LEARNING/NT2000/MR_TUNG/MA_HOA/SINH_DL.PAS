Uses CRT;

Const
  Max = 100;
  TenTepDL = 'MAHOA.INP';

Var
  S : String;
  Xau : Array[1..Max] Of String[Max];
  TT : Array[1..Max] Of Byte;
  i, j, k : Byte;
  F : Text;

BEGIN
  Xau[1] := 'POCOLO';
  For i := 2 To Length(Xau[1]) Do
    Begin
      Xau[i] := Xau[i-1];
      Delete(Xau[i], 1, 1);
      Xau[i] := Xau[i]+Xau[i-1, 1];
    End;
  For i := 1 To Length(Xau[1]) Do TT[i] := i;
  For i := 1 To Length(Xau[1])-1 Do
    For j := i+1 To Length(Xau[1]) Do
      If Xau[i] > Xau[j] Then
        Begin
          S := Xau[i];
          Xau[i] := Xau[j];
          Xau[j] := S;
          k := TT[i];
          TT[i] := TT[j];
          TT[j] := k;
        End;
  S := '';
  For i := 1 To Length(Xau[1]) Do
    S := S+Xau[i, Length(Xau[i])];
  i := 1;
  While TT[i] <> 1 Do Inc(i);
  Assign(F, TenTepDL);
  Rewrite(F);
  WriteLn(F, S);
  WriteLn(F, i);
  Close(F);
END.