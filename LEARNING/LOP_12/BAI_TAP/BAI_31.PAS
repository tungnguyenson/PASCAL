{
Cho mang A[1..N], tim day con max gom toan chu so 0

(*):De tang toc do : Neu A[i] <> 0 Thi i := i+Max0
                     Neu A[i] = 0 Thi i := i-Max0 roi tim
}

Uses CRT;

Const
  NMax = 60000;

Var
  A : Array[1..NMax] Of Byte;
  N, Max0, Vi_Tri : Word;

Procedure Nhap_Du_Lieu;
  Var
    i : Word;
  Begin
    Repeat
      Write('Nhap N<=', NMax, ': ');
      ReadLn(N);
    Until (N > 0)And(N <= NMax);
    Randomize;
    For i := 1 To N Do
    Begin
{     Write('  A[', i, ' = ');
      ReadLn(A[i]);{}
      If Random(5) <> 0 Then A[i] := 0
                        Else A[i] := Random(9)+1;{}
    End;{For}
    For i := 1 To N Do Write(A[i]);
    WriteLn;
  End;{Proc}

Procedure Tim_Max;
  Var
    i, j : Word;
    Xet : Boolean;
  Begin
    i := 0;
    Xet := False;
    Max0 := 0;
    While i <= N Do
    Begin
      Inc(i);
      If (A[i] = 0)And(i <= N) Then
        Begin
          If Xet = False Then
          Begin
            Xet := True;
            j := i;
          End;
        End
       Else If Xet = True Then
        Begin
          Xet := False;
          If i-j > Max0 Then
          Begin
            Max0 := i-j;
            Vi_Tri := j;
          End;
        End;
    End;{While}
  End;{Proc}

Begin
  ClrScr;
  Nhap_Du_Lieu;
  Tim_Max;
  If Max0 > 0 Then
    Begin
      WriteLn('Vi tri cua day con: ', Vi_Tri);
      WriteLn('Do dai day con lon nhat: ', Max0);
    End
   Else WriteLn('Khong co so 0!');
  ReadLn;
End.