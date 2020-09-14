Uses CRT;

Const
  Max = 6*6*6*6;

Var
  So, TM : Array[1..Max] Of Word;
  LuuKQ : Array[1..6, 1..3] Of Word;

Procedure Khoi_Tao;
  Var
    i, j, k, l, x : Word;
    S : String;
  Begin
    x := 0;
    For i := 1 To 6 Do
      For j := 1 To 6 Do
        For k := 1 To 6 Do
          For l := 1 To 6 Do
            Begin
              Inc(x);
              So[x] := i*1000+j*100+k*10+l;
            End;
  End;

Function ThoaMan(i : Word; C, T : Byte) : Boolean;
  Var
    j, k : Byte;
    S : Array[1..4] Of Byte;
  Begin
    ThoaMan := True;
    For j := 1 To 4 Do
      Begin
        S[j] := i Div 1000;
        i := (i-S[j]*1000)*10;
      End;
  End;

Function Suggest : Word;
  Var
    Found : Boolean;
    SoLanDoan : Byte;
    C, T : Byte;
    i, j, k : Word;
    Ch : Char;
  Begin
    Found := False;
    SoLanDoan := 0;
    WriteLn('Xin moi ban doan:');
    Randomize;
    Repeat
      Inc(SoLanDoan);
      LuuKQ[SoLanDoan, 1] := So[Random(Max)+1];
      Write('Lan thu ', SoLanDoan, ' : ', LuuKQ[SoLanDoan, 1], '  +  -');
      GoToXY(WhereX-5, WhereY);
      Repeat
        Ch := ReadKey;
      Until Ch In ['0'..'4'];
      LuuKQ[SoLanDoan, 2] := Ord(Ch)-48;
      Write(Ch);
      GoToXY(WhereX+2, WhereY);
      Repeat
        Ch := ReadKey;
      Until Ch In ['0'..'4'];
      LuuKQ[SoLanDoan, 3] := Ord(Ch)-48;
      WriteLn(Ch, '-');
    Until (LuuKQ[SoLanDoan, 2] = 4)Or(SoLanDoan = 6);
    If SoLanDoan = 6 Then
      Begin
        FillChar(TM, SizeOf(TM), 0);
        For i := 1 To Max Do
          For j := 1 To 6 Do
            If ThoaMan(So[i], LuuKQ[j, 2], LuuKQ[j, 3]) Then TM[i] := 1;
      End
     Else Suggest := LuuKQ[SoLanDoan, 1];
  End;

BEGIN
  ClrScr;
  Khoi_Tao;
  WriteLn(ThoaMan(1234, ));
{  WriteLn(Suggest);}
  ReadLn;
END.