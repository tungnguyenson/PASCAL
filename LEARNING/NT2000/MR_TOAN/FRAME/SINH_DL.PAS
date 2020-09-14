Uses CRT;

Const
  TenTepDL = 'frame.in8';
  M = 10;
  N = 10;
  FrameCount = 8;
  MaxMN = 50;

Var
  Grid : Array[1..MaxMN, 1..MaxMN] Of Char;
  F : Text;
  y1, x1, y2, x2 : Byte;
  i, j, k : Byte;

Procedure Swap(Var x, y : Byte);
  Var
    i : Byte;
  Begin
    i := x;
    x := y;
    y := i;
  End;

BEGIN
  Randomize;
  For i := 1 To M Do
    For j := 1 To N Do
      Grid[i, j] := '.';
  For i := 1 To FrameCount Do
    Begin
      Repeat
        y1 := Random(M)+1;
        x1 := Random(N)+1;
        y2 := Random(M)+1;
        x2 := Random(N)+1;
        If y2 < y1 Then Swap(y1, y2);
        If x2 < x1 Then Swap(x1, x2);
      Until (y2-y1 >= 2)And(x2-x1 >= 2);
      For j := y1 To y2 Do
        Begin
          Grid[j, x1] := Chr(i+65-1);
          Grid[j, x2] := Chr(i+65-1);
        End;
      For k := x1 To x2 Do
        Begin
          Grid[y1, k] := Chr(i+65-1);
          Grid[y2, k] := Chr(i+65-1);
        End;
    End;
  Assign(F, TenTepDL);
  Rewrite(F);
  WriteLn(F, M, ' ' , N);
  For i := 1 To M Do
    Begin
      For j := 1 To N Do Write(F, Grid[i, j]);
      WriteLn(F);
    End;
  Close(F);
END.