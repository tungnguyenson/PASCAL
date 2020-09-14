Program Xap_Hau_2;

Uses CRT;

Const
  NMax = 10;

Var
  Ban_Co : Array[1..NMax, 1..NMax] Of Byte;
  Xep : Array[1..NMax] Of Byte;
  A : Array[1..NMax] Of Byte;
  Cheo1 : Array[2..2*NMax] Of Byte;      {North East - South West}
  Cheo2 : Array[1-NMax..NMax-1] Of Byte; {North West - South East}
  N : Byte;
  Time, Dem : LongInt;
  i, j, k : Integer;

Procedure Xuat;
  Var
    i, j : Byte;
  Begin
{    For j := 1 To N Do Write('----');
    WriteLn('-');
    For i := 1 To N Do
      Begin
        For j := 1 To N Do
          If Ban_Co[i, j] = 1 Then Write('³', i:2, ' ')
                              Else Write('³   ');
        WriteLn('³');
        For j := 1 To N Do Write('----');
        WriteLn('-');
      End;
    WriteLn;}
    Inc(Dem);
  End;
{
Procedure Xep(i : Byte);
  Var
    j, k : Byte;
  Begin
    For j := 1 To N Do
      If (Ban_Co[i, j] = 0)And(A[j] = 1)And(B[i+j] = 1)And(C[i-j] = 1) Then
        Begin
          A[j] := 0;
          B[i+j] := 0;
          C[i-j] := 0;
          Ban_Co[i, j] := 1;
          If i = N Then Inc(Dem)
                   Else Xep(i+1);
          Ban_Co[i, j] := 0;
          A[j] := 1;
          B[i+j] := 1;
          C[i-j] := 1;
        End;
  End;}

BEGIN
  ClrScr;
  Write('Nhap kich thuoc ban co: ');
{  ReadLn(N);}
  N := 8;
  Time := MemL[$0000:$046C];
  FillChar(Xep, SizeOf(Xep), 0);
  For i := 1 to N do A[i] := 1;
  For i := 2 to 2*N do Cheo1[i] := 1;
  For i := 1-N to N-1 do Cheo2[i] := 1;
  i := 1;
  Repeat
    If Xep[i] < N Then
      Begin
        Inc(Xep[i]);
        If i < N Then Inc(i)
                 Else
                   Begin
                     Inc(Dem);
                     WriteLn(Dem, ' ', MemL[$0000:$046C]);
                   End;
      End
     Else
      While (Xep[i] = N)And(i > 0) Do Dec(i);
  Until i = 0;
  WriteLn('Co ', Dem,' cach xep!');
  WriteLn('Thoi gian chay: ', (MemL[$0000:$046C]-Time)/18.2:10:5);
  ReadLn;
END.