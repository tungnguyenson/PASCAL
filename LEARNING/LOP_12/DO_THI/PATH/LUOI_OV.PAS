Uses CRT;

Const
  Next : Array[0..1, 1..4, 1..2] Of ShortInt =
         (((-1, -1), (-1,  1), (1, -1), (1, 1)),
          ((-1,  0), ( 0, -1), (0,  1), (1, 0)));
  Max = 7;
  DaXet = MaxLongInt Div 2;

Var
  Bang : Array[0..Max+1, 0..Max+1] Of LongInt;
  Stack : Array[1..Max*Max, 1..2] Of Byte;
  Truoc : Array[1..Max*Max] Of Word;
  N, i : Byte;
  Top, Min : Word;
  F : Text;
  TepVao : String;
  Time : LongInt;

Procedure Sinh_Du_Lieu(N : Byte);
  Const
    MaxGiaTri = 9;
  Var
    i, j : Byte;
  Begin
    Assign(F, TepVao);
    ReWrite(F);
    WriteLn(F, N);
    Randomize;
    For i := 1 To N Do
      Begin
        For j := 1 To N Do Write(F, Random(MaxGiaTri)+1, ' ');
        WriteLn(F);
      End;
    Close(F);
  End;

Procedure Doc_Du_Lieu;
  Var
    i, j : Byte;
  Begin
    FillChar(Bang, SizeOf(Bang), 0);
    Assign(F, TepVao);
    ReSet(F);
    ReadLn(F, N);
    For i := 1 To N Do
      Begin
        For j := 1 To N Do Read(F, Bang[i, j]);
        ReadLn(F);
      End;
    For i := 0 To N+1 Do
      For j := 0 To N+1 Do
        If (i = 0)Or(i = N+1)Or(j = 0)Or(j = N+1) Then Bang[i, j] := MaxLongInt;
    Close(F);
  End;

Function Tim(y : Byte) : Word;
  Var
    j, xs, ys, i, k : Word;
    l, Min : Longint;
  Begin
    Top := 1;
    Stack[Top, 1] := y;
    Stack[Top, 2] := 1;
    Bang[y, 1] := DaXet+Bang[y, 1];
    Repeat
      Min := MaxLongInt;
      For i := 1 To Top Do
        For j := 1 To 4 Do
          Begin
            l := Bang[Stack[i, 1]+Next[i Mod 2, j, 1], Stack[i, 2]+Next[i Mod 2, j, 2]];
            If (Bang[Stack[i, 1], Stack[i, 2]]+l < Min)And(l < DaXet) Then
              Begin
                Min := Bang[Stack[i, 1], Stack[i, 2]]+l;
                ys := Stack[i, 1]+Next[i Mod 2, j, 1];
                xs := Stack[i, 2]+Next[i Mod 2, j, 2];
                k := i;
              End;
          End;
      If Min <> MaxLongInt Then
        Begin
          Inc(Top);
          Stack[Top, 1] := ys;
          Stack[Top, 2] := xs;
          Bang[ys, xs] := Min;
          Truoc[Top] := k;
        End;
    Until xs = N;
    Tim := Bang[Stack[Top, 1], Stack[Top, 1]]-DaXet;
  End;

Procedure Xuat_Ket_Qua;
  Var
    DuongDi : Array[1..Max] Of Word;
    i, j : Byte;
  Begin
    WriteLn('Do dai ngan nhat: ', Min);
    j := 1;
    DuongDi[1] := Top;
    While DuongDi[j] <> 1 Do
      Begin
        DuongDi[j+1] := Truoc[DuongDi[j]];
        Inc(j);
      End;
    For i := j DownTo 1 Do
      Write('(', Stack[DuongDi[i], 1]:2, ',', Stack[DuongDi[i], 2]:2, ')   ');
  End;

Begin
  TepVao := 'data3.inp';
{  Sinh_Du_Lieu(Max, Max);{}
  FillChar(Stack, SizeOf(Stack), 0);
  FillChar(Truoc, SizeOf(Truoc), 0);
  i := 6;
  Doc_Du_Lieu;
  Time := MemL[$0000:$046C];
  Min := Tim(i);
  ClrScr;
  Xuat_Ket_Qua;
  WriteLn;
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:10:7);
  ReadLn;
End.