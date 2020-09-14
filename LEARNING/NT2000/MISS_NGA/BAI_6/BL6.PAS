Uses CRT;

Const
  TenTepDL = 'BL6.INP';
  TenTepKQ = 'BL6.OUT';
  MaxN = 100;

Var
  Day, ChiSo : Array[1..MaxN] Of Word;
  N : Word;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, N);
    For i := 1 To N Do
      Read(F, Day[i]);
    Close(F);
  End;

Procedure Sinh_Du_Lieu(N : Word);
  Var
    F : Text;
    i : Byte;
  Begin
    Assign(F, TenTepDL);
    Rewrite(F);
    WriteLn(F, N);
    Randomize;
    For i := 1 To N Do
      Write(F, Random(10)+1, ' ');
    Close(F);
  End;

Procedure Swap(Var x, y : Word);
  Var
    Tmp : Word;
  Begin
    Tmp := x;
    x := y;
    y := Tmp;
  End;

Procedure Sort;
  Var
    i, j : Word;
  Begin
    For i := 1 To N Do ChiSo[i] := i;
    For i := 1 To N-1 Do
      For j := i+1 To N Do
        If Day[i] > Day[j] Then
          Begin
            Swap(Day[i], Day[j]);
            Swap(ChiSo[i], ChiSo[j]);
          End;
  End;

Procedure Thuc_Hien;
  Var
    i, j : Word;
  Begin
    Sort;
    For i := N DownTo 2 Do
      If Day[i] <> 0 Then
        For j := i-1 DownTo 1 Do
          If Day[j] <> 0 Then
            If Day[i] Mod Day[j] = 0 Then
              Day[j] := 0;
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i, Dem : Word;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    Dem := 0;
    For i := 1 To N Do
      If Day[i] <> 0 Then Inc(Dem);
    WriteLn(F, Dem);
    For i := 1 To N Do
      If Day[i] <> 0 Then
        Write(F, Day[i], ' ');
    Close(F);
  End;

BEGIN
  ClrScr;
{  Sinh_Du_Lieu(10);{}
  Doc_Du_Lieu;
  Thuc_Hien;
  Ghi_Ket_Qua;
END.