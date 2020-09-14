Uses CRT;

Const
  TenTepDL = 'MOWER.IN4';
  TenTepKQ = 'MOWER.OUT';
  MaxSize = 50;
  Tree   = '+';
  Passed = 'O';
  Next : Array[1..4, 1..2] Of ShortInt = ((0, 1), (-1, 0), (0, -1), (1, 0));

Var
  Garden : Array[1..MaxSize, 1..MaxSize] Of Char;
  Xet : Array[1..MaxSize, 1..MaxSize] Of Byte;
  D, R : Byte;
  StartX, StartY : Byte;

Procedure Doc_Du_Lieu;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepDL);
    Reset(F);
    ReadLn(F, D, R);
    For i := 1 To D Do
      Begin
        For j := 1 To R Do
          Begin
            Read(F, Garden[i, j]);
            If Garden[i, j] = 'M' Then
              Begin
                StartY := i;
                StartX := j;
              End;
          End;
        ReadLn(F);
      End;
    Close(F);
  End;

Function Thoa_Man(y, x : Byte) : Boolean;
  Var
    i, j : ShortInt;
  Begin
    Thoa_Man := True;
    For i := -1 To 1 Do
      For j := -1 To 1 Do
        Begin
          If (y+i < 1)Or(x+j < 1)Or(y+i > D)Or(x+j > R) Then
            Thoa_Man := False
           Else
            If Garden[y+i, x+j] = Tree Then Thoa_Man := False;
        End;
  End;

Procedure DFS(y, x : ShortInt);
  Var
    i, j : ShortInt;
  Begin
    Xet[y, x] := 1;
    For i := -1 To 1 Do
      For j := -1 To 1 Do
        If (y+i > 0)And(x+j > 0) Then
          Garden[y+i, x+j] := Passed;
    For i := 1 To 4 Do
      If (Thoa_Man(y+Next[i, 1], x+Next[i, 2])) Then
        If (Xet[y+Next[i, 1], x+Next[i, 2]] = 0) Then
          DFS(y+Next[i, 1], x+Next[i, 2]);
  End;

Procedure Working;
  Begin
    FillChar(Xet, SizeOf(Xet), 0);
    DFS(StartY, StartX);
  End;

Procedure Ghi_Ket_Qua;
  Var
    F : Text;
    i, j : Byte;
  Begin
    Assign(F, TenTepKQ);
    Rewrite(F);
    For i := 1 To D Do
      Begin
        For j := 1 To R Do Write(F, Garden[i, j]);
        WriteLn(F);
      End;
    Close(F);
  End;

BEGIN
  ClrScr;
  Doc_Du_Lieu;
  Working;
  Ghi_Ket_Qua;
END.