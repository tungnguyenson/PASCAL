Program Doi_The;

Uses CRT;

Const
  TenTepDL = 'DOITHE.INP';
  TenTepKQ = 'DOITHE.OUT';
  MaxN = 200;

Var
  A : Array[1..MaxN, 1..MaxN] Of Byte;
  Xet, Queue, KQ : Array[1..MaxN] Of Byte;
  Truoc : Array[1..MaxN, 1..2] Of Byte;
  Left, Right, Top : Word;
  N, BD, KT : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      For j := 1 To N Do
        Read(F, A[i ,j]);
    ReadLn(F, BD, KT);
    Close(F);
  End;

Function SearchCard : Boolean;
  Var
    i, j : Byte;
  Begin
    FillChar(Xet, SizeOf(Xet), 0);
    FillChar(Truoc, SizeOf(Truoc), 0);
    Left := 0;
    Right := 1;
    Queue[1] := BD;
    Xet[BD] := 1;
    Repeat
      Inc(Left);
      If Left <= Right  Then
        Begin
          i := Queue[Left];
          For j := 1 To N Do
            If (Xet[A[i, j]] = 0)And(Queue[Right] <> KT) Then
              Begin
                Xet[A[i, j]] := 1;
                Inc(Right);
                Queue[Right] := A[i, j];
                Truoc[A[i, j], 1] := i;
                Truoc[A[i, j], 2] := j;
              End;
        End;
    Until (Left > Right)Or(Queue[Right] = KT);
    If Left <= Right Then SearchCard := True
                     Else SearchCard := False;
  End;

Function SearchMaxCard : Byte;
  Var
    Max, i, j : Byte;
  Begin
    FillChar(Xet, SizeOf(Xet), 0);
    FillChar(Truoc, SizeOf(Truoc), 0);
    Left := 0;
    Right := 1;
    Queue[1] := BD;
    Xet[BD] := 1;
    Max := BD;
    Repeat
      Inc(Left);
      If Left <= Right  Then
        Begin
          i := Queue[Left];
          For j := 1 To N Do
            If Xet[A[i, j]] = 0 Then
              Begin
                Xet[A[i, j]] := 1;
                Inc(Right);
                Queue[Right] := A[i, j];
                Truoc[A[i, j], 1] := i;
                Truoc[A[i, j], 2] := j;
                If A[i, j] > Max Then Max := A[i, j];
              End;
        End;
    Until Left > Right;
    SearchMaxCard := Max;
    If Max <> BD Then
      Begin
        i := Right;
        While Queue[i] <> Max Do Dec(i);
      End;
  End;

Procedure Lay_Ket_Qua;
  Var
   i, j : Byte;
  Begin
    FillChar(KQ, SizeOf(KQ), 0);
    Top := 0;
    i := Queue[Right];
    Repeat
      j := Truoc[i, 2];
      Inc(Top);
      KQ[Top] := j;
      i := Truoc[i, 1];
    Until i = BD;
  End;

Procedure Thuc_Hien;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    If BD = KT Then WriteLn(F, 0)
     Else
      Begin
        If SearchCard Then
          Begin
            Lay_Ket_Qua;
            WriteLn(F, Top);
            For i := Top DownTo 1 Do Write(F, KQ[i], ' ');
            WriteLn(F);
          End
         Else WriteLn(F, -1);
      End;
    If SearchMaxCard = BD Then WriteLn(F, 0)
     Else
      Begin
        Lay_Ket_Qua;
        WriteLn(F, Top);
        For i := Top DownTo 1 Do Write(F, KQ[i], ' ');
      End;
    Close(F);
  End;

BEGIN
  Doc_Du_Lieu;
  Thuc_Hien;
END.