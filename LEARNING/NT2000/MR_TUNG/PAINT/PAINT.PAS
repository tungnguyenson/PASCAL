Uses CRT;

Const
  MaxN = 15;
  TenTepDL = 'PAINT.INP';
  TenTepKQ = 'PAINT.OUT';

Var
  N : Byte;
  ToaDoVung : Array[1..MaxN, 1..4] Of Integer;
  Mau : Array[1..MaxN] Of Byte;
  Up : Array[1..MaxN, 1..MaxN] Of Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      ReadLn(F, ToaDoVung[i, 3], ToaDoVung[i, 4], ToaDoVung[i, 1],
		          ToaDoVung[i, 2], Mau[i]);
    Close(F);
  End;

Procedure Khoi_Tao;
  Var
    i, j : Byte;
  Begin
    FillChar(Up, SizeOf(Up), 0);
    For i := 1 To N Do
      For j := 1 To N Do
        If i <> j Then
          If (ToaDoVung[i, 2] >= ToaDoVung[j, 4])And
             (((ToaDoVung[i, 1] >= ToaDoVung[j, 1])And(ToaDoVung[i, 1] < ToaDoVung[j, 3])) Or
             ((ToaDoVung[i, 3] > ToaDoVung[j, 1])And(ToaDoVung[i, 3] <= ToaDoVung[j, 3])))Then
            Up[j, i] := 1;
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Khoi_Tao;
END.